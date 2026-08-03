import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/database.dart';
import 'package:kotva/core/storage/enums.dart';

/// Regrese nahlášená z telefonu: „funguje jen první režim, další dva ne".
///
/// Příčina nebyla v intenzitách, ale v zápisu. `insertOnConflictUpdate` z driftu
/// cílí na primární klíč (`ON CONFLICT("id")`), jenže `id` je autoIncrement
/// a nikdy nekoliduje — skutečná kolize nastane na unikátním sloupci. SQLite ji
/// pak nemá jak vyřešit a vyhodí `UNIQUE constraint failed`.
///
/// Navenek to vypadalo jako „jde jen první volba": **založit** limit šlo,
/// protože při vkládání nového řádku ke kolizi nedojde. Jakákoliv pozdější
/// **změna** spadla, takže uživateli zůstala ta intenzita, se kterou limit
/// vznikl.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('úprava denního limitu (regrese)', () {
    test('druhé uložení téhož balíčku změní hodnoty místo pádu', () async {
      await db.upsertAppLimit(
        packageName: 'com.google.android.deskclock',
        appLabel: 'Clock',
        dailyMinutes: 15,
        intensity: LimitIntensity.ask,
      );

      // Tohle dřív skončilo výjimkou a uživatel zůstal na „Zeptat se".
      await db.upsertAppLimit(
        packageName: 'com.google.android.deskclock',
        appLabel: 'Clock',
        dailyMinutes: 5,
        intensity: LimitIntensity.hard,
      );

      final limits = await db.allAppLimits();
      expect(limits, hasLength(1), reason: 'nesmí vzniknout druhý řádek');
      expect(limits.single.dailyMinutes, 5);
      expect(limits.single.intensity, LimitIntensity.hard);
    });

    test('projde každá intenzita, ne jen ta první', () async {
      // Jádro hlášení: druhá a třetí volba musí jít nastavit stejně jako první.
      for (final intensity in LimitIntensity.values) {
        await db.upsertAppLimit(
          packageName: 'com.android.chrome',
          appLabel: 'Chrome',
          dailyMinutes: 30,
          intensity: intensity,
        );
        final limits = await db.allAppLimits();
        expect(limits.single.intensity, intensity, reason: intensity.name);
      }
    });

    test('limity různých aplikací se navzájem nepřepisují', () async {
      await db.upsertAppLimit(
        packageName: 'com.android.chrome',
        appLabel: 'Chrome',
        dailyMinutes: 30,
        intensity: LimitIntensity.code,
      );
      await db.upsertAppLimit(
        packageName: 'com.android.contacts',
        appLabel: 'Contacts',
        dailyMinutes: 10,
        intensity: LimitIntensity.ask,
      );
      expect(await db.allAppLimits(), hasLength(2));
    });
  });

  group('kotevní body (stejná vada)', () {
    test('opětovné spárování téže kotvy jí přepíše jméno', () async {
      await db.createAnchor(
        type: AnchorType.ble,
        tagIdentifier: 'AA:BB:CC:DD:EE:FF',
        name: 'Stůl',
      );
      await db.createAnchor(
        type: AnchorType.ble,
        tagIdentifier: 'AA:BB:CC:DD:EE:FF',
        name: 'Pracovna',
      );

      final anchors = await db.watchAnchors().first;
      expect(anchors, hasLength(1));
      expect(anchors.single.name, 'Pracovna');
    });
  });

  group('chytrá zařízení (stejná vada)', () {
    test('uložení už známého zařízení přepíše název', () async {
      await db.upsertSmartDevice(
        provider: SmartProvider.kasa,
        externalDeviceId: 'dev-1',
        name: 'Zásuvka',
      );
      await db.upsertSmartDevice(
        provider: SmartProvider.kasa,
        externalDeviceId: 'dev-1',
        name: 'Televize',
      );

      final devices = await db.watchSmartDevices().first;
      expect(devices, hasLength(1));
      expect(devices.single.name, 'Televize');
    });

    test('datum prvního propojení se přepsáním názvu nemění', () async {
      await db.upsertSmartDevice(
        provider: SmartProvider.kasa,
        externalDeviceId: 'dev-1',
        name: 'Zásuvka',
      );
      final first = (await db.watchSmartDevices().first).single.createdAt;

      await Future<void>.delayed(const Duration(milliseconds: 5));
      await db.upsertSmartDevice(
        provider: SmartProvider.kasa,
        externalDeviceId: 'dev-1',
        name: 'Televize',
      );

      expect((await db.watchSmartDevices().first).single.createdAt, first);
    });
  });
}
