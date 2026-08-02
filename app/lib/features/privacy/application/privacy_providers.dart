import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../accountability/application/accountability_providers.dart';
import '../../blocking/application/blocking_providers.dart';
import '../../focus_session/application/focus_providers.dart';
import '../../smart_home/application/smart_home_providers.dart';
import '../domain/consent.dart';
import '../domain/data_export.dart';

/// Historie souhlasů, nejnovější první.
final consentRecordsProvider = StreamProvider<List<ConsentRecord>>((ref) {
  return ref.watch(databaseProvider).watchConsents();
});

/// Aktuální stav všech kategorií — to, co potřebuje UI i ostatní funkce.
final consentStateProvider = Provider<Map<ConsentCategory, bool>>((ref) {
  final records = ref.watch(consentRecordsProvider).valueOrNull;
  // Dokud se historie načítá, platí „nesouhlas". Předpokládat souhlas, který
  // jsme ještě nepřečetli, by znamenalo chvíli sbírat data bez povolení.
  if (records == null) {
    return {for (final c in ConsentCategory.values) c: false};
  }
  return consentState(records);
});

/// Souhlas s jednou kategorií. Funkce se na tohle ptají místo toho, aby si
/// stav odvozovaly samy.
final consentGrantedProvider =
    Provider.family<bool, ConsentCategory>((ref, category) {
  return ref.watch(consentStateProvider)[category] ?? false;
});

final privacyControllerProvider = Provider<PrivacyController>((ref) {
  return PrivacyController(ref);
});

/// Souhlasy, export a smazání dat (docs/spec.md §9, akceptační kritérium §14).
class PrivacyController {
  PrivacyController(this._ref);

  final Ref _ref;

  // --- Souhlasy ---

  Future<void> grant(ConsentCategory category) {
    return _ref.read(databaseProvider).grantConsent(category);
  }

  /// Odvolá souhlas **a zastaví, co na něm stálo.**
  ///
  /// Zapsat odvolání a nechat funkci běžet dál by byl souhlas jen naoko.
  /// Úklid proto patří sem, ne do UI — odvolání se dá vyvolat i ze smazání
  /// všech dat a obojí musí dopadnout stejně.
  Future<void> revoke(ConsentCategory category) async {
    await _ref.read(databaseProvider).revokeConsent(category);
    await _applyRevocation(category);
  }

  Future<void> _applyRevocation(ConsentCategory category) async {
    switch (category) {
      case ConsentCategory.usageStats:
        // Limity vynucuje nativní vrstva nezávisle na Flutter enginu — musí
        // se zahodit tam i v databázi, jinak by hlídkovaly dál.
        await _ref.read(databaseProvider).clearAppLimits();
        await _ref.read(blockingChannelProvider).clearNativeData();

      case ConsentCategory.location:
        // Hlídání kotvy se zastaví samo: `anchorMonitorProvider` se na souhlas
        // ptá před každým skenem. Uložené kotevní body zůstávají — jsou to
        // uživatelovy záznamy, ne sbíraná data, a po opětovném udělení
        // souhlasu je nechce zadávat znovu.
        break;

      case ConsentCategory.smartHome:
        // Odhlášení smaže token i uložená zařízení.
        await _ref.read(kasaTokenProvider.notifier).signOut();
    }
  }

  // --- Export všech dat (akceptační kritérium §14) ---

  /// Sestaví export, uloží ho do souboru a předá systémovému výběru.
  ///
  /// Vrací cestu k souboru, aby obrazovka mohla uživateli říct, co vzniklo,
  /// i když si žádnou aplikaci pro sdílení nevybere.
  Future<String> exportEverything() async {
    final db = _ref.read(databaseProvider);
    final now = DateTime.now();

    final export = DataExport(
      exportedAt: now,
      profiles: await db.allProfiles(),
      sessions: await db.allSessions(),
      frictionEvents: await db.allFrictionEvents(),
      blockedLists: await db.allBlockedLists(),
      blockedApps: await db.allBlockedApps(),
      profileListLinks: await db.allProfileListLinks(),
      anchors: await db.allAnchors(),
      anchorEvents: await db.allAnchorEvents(),
      smartDevices: await db.allSmartDevices(),
      partners: await db.allPartners(),
      appLimits: await db.allAppLimits(),
      consents: await db.allConsents(),
    );

    // Odsazený JSON: export má být čitelný pro člověka, ne jen strojově
    // zpracovatelný. Pár kilobajtů navíc za to stojí.
    final json = const JsonEncoder.withIndent('  ').convert(export.toJson());

    // Cache, ne dokumenty: soubor je jednorázový meziprodukt pro předání ven.
    // Adresář odpovídá `res/xml/file_paths.xml` — jinam FileProvider nesmí.
    final dir = Directory(
      p.join((await getTemporaryDirectory()).path, 'exporty'),
    );
    await dir.create(recursive: true);

    // Starší exporty se uklidí, aby se v cache nehromadily kopie všech dat.
    await _removeOldExports(dir);

    final file = File(p.join(dir.path, exportFileName(now)));
    await file.writeAsString(json);

    await _ref.read(shareChannelProvider).shareFile(
          file.path,
          title: 'Export dat z Kotvy',
        );
    return file.path;
  }

  Future<void> _removeOldExports(Directory dir) async {
    await for (final entry in dir.list()) {
      if (entry is File && p.extension(entry.path) == '.json') {
        await entry.delete();
      }
    }
  }

  // --- Smazání všech dat (akceptační kritérium §14) ---

  /// Smaže všechno, co o uživateli aplikace ví — ve všech třech úložištích.
  ///
  /// Databáze sama nestačí. Stav je rozprostřený do tří míst a smazat jen jedno
  /// by nechalo appku ve stavu, který vypadá prázdně, ale není:
  ///
  ///  1. **SQLite** — profily, bloky, kotvy, parťáci, souhlasy.
  ///  2. **Nativní `SharedPreferences`** — běžící blokace a denní limity, které
  ///     vynucuje služba přístupnosti mimo Flutter engine.
  ///  3. **`flutter_secure_storage`** — token k účtu chytré domácnosti.
  ///
  /// Volba vzhledu se **nemaže**. Není to údaj o uživateli ani o jeho chování,
  /// a přepnutí motivu bez varování by vypadalo jako chyba. Obrazovka to říká
  /// nahlas, aby to nebylo překvapení.
  /// Pořadí kroků není libovolné — každý krok potřebuje něco, co ten další
  /// odstraní.
  Future<void> deleteEverything() async {
    final db = _ref.read(databaseProvider);

    // 1. Ukončit běžící blok normální cestou. Odběratelé stavu session tím
    //    dostanou šanci uklidit po sobě — hlavně vrátit chytrou zásuvku do
    //    původního stavu. Smazat session rovnou z databáze by zásuvku nechalo
    //    vypnutou a uživatel by netušil proč.
    final active = await db.findActiveSession();
    if (active != null) {
      await _ref.read(sessionControllerProvider).interrupt(active);
    }

    // 2. Odhlásit účet chytré domácnosti. Musí přijít před výmazem databáze —
    //    `signOut` si v ní ještě hledá, která zařízení odebrat.
    await _ref.read(kasaTokenProvider.notifier).signOut();

    // 3. Nativní stav, ke kterému se databáze nedostane.
    await _ref.read(blockingChannelProvider).clearNativeData();

    // 4. A nakonec databáze.
    await db.wipeAllData();
  }
}
