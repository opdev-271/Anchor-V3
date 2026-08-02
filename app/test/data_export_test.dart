import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/database.dart';
import 'package:kotva/core/storage/enums.dart';
import 'package:kotva/features/privacy/domain/data_export.dart';

final _now = DateTime(2026, 8, 2, 14, 30);

FocusProfile _profile() => FocusProfile(
      id: 1,
      remoteId: null,
      name: 'Hluboká práce',
      durationMinutes: 50,
      goalText: 'TAJNY-CIL-dopsat-vypoved',
      strictness: StrictnessLevel.strict,
      anchorPointId: null,
      smartDeviceId: null,
      notifyPartner: true,
      createdAt: _now,
      updatedAt: _now,
    );

FocusSession _session(SessionStatus status) => FocusSession(
      id: 7,
      remoteId: null,
      profileId: 1,
      startedAt: _now,
      endedAt: _now.add(const Duration(minutes: 20)),
      plannedDurationMinutes: 50,
      goalText: 'TAJNY-CIL-dopsat-vypoved',
      status: status,
      strictness: StrictnessLevel.strict,
      updatedAt: _now,
    );

DataExport _export({
  List<FocusProfile>? profiles,
  List<FocusSession>? sessions,
  List<ConsentRecord>? consents,
}) {
  return DataExport(
    exportedAt: _now,
    profiles: profiles ?? [_profile()],
    sessions: sessions ?? [_session(SessionStatus.completed)],
    frictionEvents: const [],
    blockedLists: const [],
    blockedApps: const [],
    profileListLinks: const [],
    anchors: const [],
    anchorEvents: const [],
    smartDevices: const [],
    partners: const [],
    appLimits: const [],
    consents: consents ?? const [],
  );
}

void main() {
  group('export dat (§14 — export jedním tlačítkem)', () {
    test('obsahuje sekci za každou skupinu dat, kterou Kotva uchovává', () {
      // Kdyby se přidala tabulka a zapomnělo se na ni tady, uživatel by
      // dostal neúplný export a nepoznal by to.
      final json = _export().toJson();
      const expected = [
        'fokusProfily',
        'fokusBloky',
        'pokusyOUkonceni',
        'seznamyBlokovanychAplikaci',
        'blokovaneAplikace',
        'vazbyProfilSeznam',
        'kotevniBody',
        'nepritomnostiUKotvy',
        'chytraZarizeni',
        'partaci',
        'denniLimity',
        'souhlasy',
      ];
      for (final key in expected) {
        expect(json, contains(key), reason: key);
      }
    });

    test('data uživatele v exportu skutečně jsou', () {
      // Protipól k testu parťáka: tam se cíl ven dostat nesmí, tady musí —
      // je to export pro samotného uživatele.
      final encoded = jsonEncode(_export().toJson());
      expect(encoded, contains('TAJNY-CIL-dopsat-vypoved'));
      expect(encoded, contains('Hluboká práce'));
    });

    test('je platný JSON i s diakritikou', () {
      final encoded = jsonEncode(_export().toJson());
      final decoded = jsonDecode(encoded) as Map<String, Object?>;
      expect(decoded['format'], 'kotva-export');
      expect(decoded['verzeFormatu'], DataExport.formatVersion);
    });

    test('časy jdou ven v ISO-8601 i s posunem zóny', () {
      // Bez posunu by nešlo poznat, v jaké zóně čas vznikl, a export by se
      // v jiné zemi četl jinak, než jak byl zapsán.
      final sessions =
          (_export().toJson()['fokusBloky']! as List).cast<Map<String, Object?>>();
      final start = sessions.single['zacatek']! as String;
      expect(start, startsWith('2026-08-02T14:30:00'));
      expect(start, matches(RegExp(r'[+-]\d{2}:\d{2}$')));
    });

    test('nevyplněné časy zůstávají null, ne prázdný řetězec', () {
      final export = _export(
        consents: [
          ConsentRecord(
            id: 1,
            remoteId: null,
            category: ConsentCategory.usageStats,
            grantedAt: _now,
            revokedAt: null,
          ),
        ],
      );
      final consents =
          (export.toJson()['souhlasy']! as List).cast<Map<String, Object?>>();
      expect(consents.single['odvolano'], isNull);
      expect(consents.single['udeleno'], isNotNull);
    });

    test('přerušený blok se v exportu nejmenuje selhání (§11)', () {
      // Tón aplikace neobviňuje ani v datech, která si uživatel odnese.
      final export = _export(sessions: [_session(SessionStatus.interrupted)]);
      final encoded = jsonEncode(export.toJson());
      expect(encoded, contains('kratsi'));
      for (final word in ['selhan', 'failed', 'abandoned', 'neuspe']) {
        expect(encoded.toLowerCase(), isNot(contains(word)), reason: word);
      }
    });

    test('export nese poznámku, že token k účtu uvnitř není', () {
      // Přístupový klíč ke službě do souboru, který uživatel pošle dál,
      // nepatří — a export to má říct nahlas, ne to jen mlčky vynechat.
      final json = _export().toJson();
      expect(json['poznamka'], contains('token'));
      expect(jsonEncode(json).toLowerCase(), isNot(contains('kasa_token')));
    });
  });

  group('název souboru s exportem', () {
    test('nese datum a čas, aby si dva exporty nepřepsaly', () {
      expect(
        exportFileName(DateTime(2026, 8, 2, 9, 5)),
        'kotva-export-2026-08-02-0905.json',
      );
    });
  });
}
