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
