import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../focus_session/application/focus_providers.dart';
import '../data/kasa_client.dart';

final kasaClientProvider = Provider<KasaClient>((ref) {
  final client = KasaClient();
  ref.onDispose(client.close);
  return client;
});

/// Úložiště přihlašovacího tokenu.
///
/// Token do běžné databáze nepatří — je to přístupový klíč k účtu uživatele
/// (docs/spec.md §9). `flutter_secure_storage` ho na Androidu ukládá přes
/// Keystore, ne jen do app-private souboru.
///
/// **Heslo se neukládá vůbec.** Použije se jen jednou při přihlášení a dál
/// se pracuje výhradně s tokenem.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final kasaTokenProvider = AsyncNotifierProvider<KasaTokenNotifier, String?>(
  KasaTokenNotifier.new,
);

class KasaTokenNotifier extends AsyncNotifier<String?> {
  static const _key = 'kasa_token';

  @override
  Future<String?> build() {
    return ref.watch(secureStorageProvider).read(key: _key);
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final token = await ref.read(kasaClientProvider).login(
            username: username,
            password: password,
            // Kasa cloud chce stabilní identifikátor zařízení. Nepoužíváme
            // nic, co by šlo spojit s konkrétním telefonem — stačí náhodná
            // hodnota vygenerovaná jednou při přihlášení.
            terminalUuid: DateTime.now().microsecondsSinceEpoch.toString(),
          );
      await ref.read(secureStorageProvider).write(key: _key, value: token);
      state = AsyncValue.data(token);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await ref.read(secureStorageProvider).delete(key: _key);
    // Odpojení účtu smaže i zařízení — bez tokenu s nimi stejně nic neuděláme
    // a nechávat je v seznamu by bylo matoucí.
    final db = ref.read(databaseProvider);
    for (final device in await db.watchSmartDevices().first) {
      await db.deleteSmartDevice(device.id);
    }
    state = const AsyncValue.data(null);
  }
}

/// Zařízení dostupná na účtu — načítá se ze sítě.
final kasaDevicesProvider =
    FutureProvider.autoDispose<List<KasaDevice>>((ref) async {
  final token = ref.watch(kasaTokenProvider).valueOrNull;
  if (token == null) return const [];
  return ref.watch(kasaClientProvider).listDevices(token);
});

/// Zařízení uložená v aplikaci.
final smartDevicesProvider = StreamProvider<List<SmartDevice>>((ref) {
  return ref.watch(databaseProvider).watchSmartDevices();
});

/// Spíná zásuvku podle stavu fokus bloku.
///
/// Je to jediné místo, kde se se zásuvkou manipuluje — stejně jako u blokování
/// aplikací. Session může skončit i cestami bez tlačítka (doběhnutím času,
/// dorovnáním po restartu), a odběr stavu je pokryje všechny naráz.
final smartHomeSyncProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<FocusSession?>>(
    activeSessionProvider,
    (previous, next) {
      final controller = ref.read(smartHomeControllerProvider);
      final session = next.valueOrNull;
      if (session != null) {
        controller.onSessionStarted(session);
      } else {
        controller.onSessionEnded();
      }
    },
    fireImmediately: true,
  );
});

final smartHomeControllerProvider = Provider<SmartHomeController>((ref) {
  return SmartHomeController(ref);
});

class SmartHomeController {
  SmartHomeController(this._ref);

  final Ref _ref;

  /// ID zařízení, které tenhle blok vypnul. Držíme ho, abychom na konci
  /// věděli, co obnovit, i kdyby uživatel mezitím profil upravil.
  int? _deviceId;

  /// Vypne zásuvku přiřazenou profilu a zapamatuje si její původní stav.
  ///
  /// Selhání je **neškodné**: blok běží dál a uživatel se jen dozví, že se
  /// zásuvku nepodařilo přepnout. Fokus nemá padat kvůli chytré domácnosti.
  Future<void> onSessionStarted(FocusSession session) async {
    final db = _ref.read(databaseProvider);
    final profile = await db.findProfile(session.profileId);
    final deviceId = profile?.smartDeviceId;
    if (deviceId == null) return;

    final device = await db.findSmartDevice(deviceId);
    final token = _ref.read(kasaTokenProvider).valueOrNull;
    if (device == null || token == null) return;

    _deviceId = deviceId;
    final client = _ref.read(kasaClientProvider);
    try {
      // Nejdřív zjistit původní stav — když byla televize vypnutá už předtím,
      // na konci bloku ji nesmíme zapnout.
      final wasOn = await client.isOn(token, device.externalDeviceId);
      await db.rememberDeviceState(deviceId, wasOn);
      if (wasOn) {
        await client.setOn(token, device.externalDeviceId, false);
      }
    } on KasaException catch (e) {
      debugPrint('Kotva: zásuvku se nepodařilo vypnout — $e');
    }
  }

  /// Obnoví stav zásuvky z doby před blokem.
  Future<void> onSessionEnded() async {
    final deviceId = _deviceId;
    if (deviceId == null) return;
    _deviceId = null;

    final db = _ref.read(databaseProvider);
    final device = await db.findSmartDevice(deviceId);
    final token = _ref.read(kasaTokenProvider).valueOrNull;
    if (device == null || token == null) return;

    // `null` = stav se nepodařilo zjistit, takže nemáme co obnovovat.
    // Zapnout „pro jistotu" by bylo horší než nedělat nic.
    final wasOn = device.stateBeforeSession;
    if (wasOn != true) return;

    try {
      await _ref
          .read(kasaClientProvider)
          .setOn(token, device.externalDeviceId, true);
    } on KasaException catch (e) {
      debugPrint('Kotva: zásuvku se nepodařilo vrátit zpět — $e');
    } finally {
      await db.rememberDeviceState(deviceId, null);
    }
  }

  /// Ruční přepnutí z UI — aby si uživatel mohl ověřit, že spojení funguje,
  /// bez čekání na fokus blok.
  Future<void> toggle(SmartDevice device, bool on) async {
    final token = _ref.read(kasaTokenProvider).valueOrNull;
    if (token == null) {
      throw const KasaException('Nejprve propoj účet Kasa.');
    }
    await _ref
        .read(kasaClientProvider)
        .setOn(token, device.externalDeviceId, on);
  }

  Future<void> saveDevice(KasaDevice device) {
    return _ref.read(databaseProvider).upsertSmartDevice(
          provider: SmartProvider.kasa,
          externalDeviceId: device.deviceId,
          name: device.alias,
        );
  }
}
