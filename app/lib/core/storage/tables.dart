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
  DateTimeColumn get updatedAt => dateTime()();
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
