import 'package:drift/drift.dart';

import 'enums.dart';

/// Tabulky odpovídají entitám v docs/data-model.md.
///
/// Lokální primární klíč je `int autoIncrement` (přirozené pro SQLite);
/// [remoteId] drží budoucí Firestore document ID, aby offline-first synchronizace
/// (docs/spec.md §13) nevyžadovala migraci schématu, až přibude backend.
/// [updatedAt] slouží pro budoucí last-write-wins slučování.

/// Uživatelem definovaný profil fokus session (docs/data-model.md → FocusProfile).
class FocusProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// 15–180 minut dle docs/spec.md §5.1. Rozsah hlídá i DB, ne jen UI.
  ///
  /// Sebe-reference je záměrná idiomatika drift DSL: tělo getteru čte pouze
  /// generátor kódu a překládá ho na líný `check: () => ...` v `database.g.dart`,
  /// za běhu se getter nikdy nevolá. Analyzer to bez kontextu vidí jako rekurzi.
  // ignore: recursive_getters
  IntColumn get durationMinutes => integer().check(durationMinutes.isBetweenValues(15, 180))();

  TextColumn get goalText => text().withDefault(const Constant(''))();
  IntColumn get strictness => intEnum<StrictnessLevel>()();

  /// Kotva, u které má blok probíhat. Nepovinná — funkce musí být volitelná
  /// a bez majáku má aplikace fungovat beze změny (docs/spec.md §8).
  IntColumn get anchorPointId => integer()
      .nullable()
      .references(AnchorPoints, #id, onDelete: KeyAction.setNull)();

  /// Chytrá zásuvka, která se má během bloku vypnout. Také nepovinná —
  /// bez zařízení musí zbytek aplikace fungovat beze změny (docs/spec.md §8).
  IntColumn get smartDeviceId => integer()
      .nullable()
      .references(SmartDevices, #id, onDelete: KeyAction.setNull)();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Jeden proběhlý nebo probíhající blok (docs/data-model.md → FocusSession).
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()();

  IntColumn get profileId =>
      integer().references(FocusProfiles, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  /// Snapshot z profilu v okamžiku startu — pozdější úprava profilu nesmí
  /// zpětně přepsat historii, na které stojí statistiky (§5.6).
  IntColumn get plannedDurationMinutes => integer()();
  TextColumn get goalText => text().withDefault(const Constant(''))();

  IntColumn get status => intEnum<SessionStatus>()();

  /// Snapshot přísnosti z profilu — určuje délku zpomalení ve Friction Exit
  /// (docs/spec.md §5.5). Snapshot ze stejného důvodu jako u délky a cíle:
  /// úprava profilu uprostřed běžícího bloku nesmí měnit jeho pravidla.
  IntColumn get strictness =>
      intEnum<StrictnessLevel>().withDefault(const Constant(1))();

  DateTimeColumn get updatedAt => dateTime()();
}

/// Záznam o pokusu o předčasné ukončení (docs/data-model.md → FrictionExitEvent).
///
/// Loguje se **každý** pokus, i ten, po kterém se uživatel vrátil k práci —
/// právě ta data ukazují, kdy a proč pozornost odchází, což je podklad pro
/// statistiky v §5.6.
class FrictionExitEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId =>
      integer().references(FocusSessions, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get triggeredAt => dateTime()();
  IntColumn get stepType => intEnum<FrictionStep>()();
  TextColumn get reflectionText => text().nullable()();
  IntColumn get outcome => intEnum<FrictionOutcome>()();
}

/// Pojmenovaný seznam blokovaných aplikací, např. "Sociální sítě"
/// (docs/data-model.md → BlockedAppList, docs/spec.md §5.2).
class BlockedAppLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Jedna aplikace v seznamu.
///
/// [packageName] je platformní identifikátor pro Android. [appLabel] je jen
/// cache čitelného názvu pro UI — po odinstalaci aplikace zůstane záznam
/// smysluplný, místo aby se ze seznamu stal prázdný řádek.
class BlockedApps extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get listId =>
      integer().references(BlockedAppLists, #id, onDelete: KeyAction.cascade)();

  TextColumn get packageName => text()();
  TextColumn get appLabel => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {listId, packageName},
      ];
}

/// Chytré zařízení, které se má během bloku vypnout (docs/data-model.md →
/// SmartDevice, docs/spec.md §5.3).
class SmartDevices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()();
  IntColumn get provider => intEnum<SmartProvider>()();

  /// Identifikátor v systému poskytovatele.
  TextColumn get externalDeviceId => text()();

  TextColumn get name => text()();

  /// Stav zásuvky před začátkem bloku. Po skončení se obnoví — když byla
  /// televize vypnutá už předtím, aplikace ji na konci nesmí zapnout.
  BoolColumn get stateBeforeSession => boolean().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {provider, externalDeviceId},
      ];
}

/// Kotevní bod — místo, u kterého má uživatel pracovat (docs/data-model.md →
/// AnchorPoint, docs/spec.md §5.3).
class AnchorPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()();
  IntColumn get type => intEnum<AnchorType>()();

  /// BLE adresa nebo ID NFC štítku.
  TextColumn get tagIdentifier => text()();

  TextColumn get name => text().withLength(min: 1, max: 60)();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {tagIdentifier},
      ];
}

/// Jedna nepřítomnost u kotvy (docs/data-model.md → AnchorEvent).
///
/// Odchod a návrat drží **jeden řádek** se dvěma časy, ne dvě události.
/// Datový model navrhoval `eventType` (left/returned); při implementaci se
/// ukázalo, že pár v jednom řádku je jednodušší číst i vyhodnocovat — otevřená
/// nepřítomnost je prostě ta, které chybí `returnedAt`.
class AnchorEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get anchorPointId =>
      integer().references(AnchorPoints, #id, onDelete: KeyAction.cascade)();

  /// Nepřítomnost může nastat i mimo fokus blok, proto nepovinné.
  IntColumn get sessionId => integer()
      .nullable()
      .references(FocusSessions, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get leftAt => dateTime()();
  DateTimeColumn get returnedAt => dateTime().nullable()();

  /// Nepovinná odpověď na otázku při návratu. Otázka se ptá **bez obviňování**
  /// — je to podklad pro reflexi, ne výslech (docs/spec.md §5.3 a §11).
  TextColumn get reflectionText => text().nullable()();
}

/// Denní limit času pro jednu aplikaci (revize Anchor-V1).
///
/// Zdrojem pravdy pro vynucování je nativní `AppLimits.kt` v `SharedPreferences`
/// — služba přístupnosti běží nezávisle na Flutter enginu a do databáze by se
/// nedostala. Tahle tabulka drží tutéž konfiguraci pro UI a pro budoucí
/// synchronizaci; po každé změně se stav propíše do nativní vrstvy.
class AppUsageLimits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text()();
  TextColumn get appLabel => text()();

  /// Kolik minut denně smí uživatel v aplikaci strávit.
  /// Sebe-reference je idiomatika drift DSL — viz [FocusProfiles.durationMinutes].
  // ignore: recursive_getters
  IntColumn get dailyMinutes => integer().check(dailyMinutes.isBiggerThanValue(0))();

  IntColumn get intensity => intEnum<LimitIntensity>()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {packageName},
      ];
}

/// M:N vazba profil ↔ seznam — jeden seznam lze přiřadit více profilům
/// (docs/data-model.md).
class ProfileBlockedLists extends Table {
  IntColumn get profileId =>
      integer().references(FocusProfiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get listId =>
      integer().references(BlockedAppLists, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {profileId, listId};
}
