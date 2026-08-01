import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'enums.dart';
import 'tables.dart';

part 'database.g.dart';

/// Lokální databáze aplikace.
///
/// Offline-first (docs/spec.md §13): veškerý stav fokus session žije primárně
/// tady na zařízení. Cloud sync přibude až se zapojením Firebase a bude stavět
/// na sloupcích `remoteId` / `updatedAt`, ne na přepisu schématu.
@DriftDatabase(
  tables: [
    FocusProfiles,
    FocusSessions,
    BlockedAppLists,
    BlockedApps,
    ProfileBlockedLists,
    FrictionExitEvents,
    AppUsageLimits,
    AnchorPoints,
    AnchorEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Konstruktor pro testy — umožňuje in-memory databázi.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Sprint 2 — blokování aplikací (docs/spec.md §5.2).
            await m.createTable(blockedAppLists);
            await m.createTable(blockedApps);
            await m.createTable(profileBlockedLists);
          }
          if (from < 3) {
            // Sprint 3 — Friction Exit (docs/spec.md §5.5).
            await m.createTable(frictionExitEvents);
            // Starší session přísnost neznají; výchozí `medium` odpovídá
            // tomu, co nabízí editor profilu.
            await m.addColumn(focusSessions, focusSessions.strictness);
          }
          if (from < 4) {
            // Revize Anchor-V1 — denní limity aplikací.
            await m.createTable(appUsageLimits);
          }
          if (from < 5) {
            // Sprint 5 — kotevní body (docs/spec.md §5.3).
            await m.createTable(anchorPoints);
            await m.createTable(anchorEvents);
            await m.addColumn(focusProfiles, focusProfiles.anchorPointId);
          }
        },
        beforeOpen: (details) async {
          // Bez tohohle SQLite cizí klíče ignoruje a `onDelete: cascade`
          // by byl jen dekorace.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // --- Fokus profily ---

  Stream<List<FocusProfile>> watchProfiles() {
    return (select(focusProfiles)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<FocusProfile?> findProfile(int id) {
    return (select(focusProfiles)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> createProfile({
    required String name,
    required int durationMinutes,
    required String goalText,
    required StrictnessLevel strictness,
    int? anchorPointId,
  }) {
    final now = DateTime.now();
    return into(focusProfiles).insert(
      FocusProfilesCompanion.insert(
        name: name,
        durationMinutes: durationMinutes,
        strictness: strictness,
        goalText: Value(goalText),
        anchorPointId: Value(anchorPointId),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> updateProfile({
    required int id,
    required String name,
    required int durationMinutes,
    required String goalText,
    required StrictnessLevel strictness,
    int? anchorPointId,
  }) {
    return (update(focusProfiles)..where((t) => t.id.equals(id))).write(
      FocusProfilesCompanion(
        name: Value(name),
        durationMinutes: Value(durationMinutes),
        goalText: Value(goalText),
        strictness: Value(strictness),
        // Value(null) je tu podstatné: odebrání kotvy se musí zapsat,
        // ne tiše přeskočit jako „nezměněno".
        anchorPointId: Value(anchorPointId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteProfile(int id) {
    return (delete(focusProfiles)..where((t) => t.id.equals(id))).go();
  }

  // --- Fokus session ---

  /// Sleduje právě běžící session. Aplikace povoluje nejvýš jednu naráz.
  Stream<FocusSession?> watchActiveSession() {
    return (select(focusSessions)
          ..where((t) => t.status.equalsValue(SessionStatus.active))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Sleduje konkrétní session včetně jejího koncového stavu — obrazovka
  /// průběhu tak může po doběhnutí zobrazit uzavření bloku, místo aby zmizela.
  Stream<FocusSession?> watchSession(int id) {
    return (select(focusSessions)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<FocusSession?> findActiveSession() {
    return (select(focusSessions)
          ..where((t) => t.status.equalsValue(SessionStatus.active))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Založí session ze snapshotu profilu. Vrací její ID.
  Future<int> startSession(FocusProfile profile) {
    final now = DateTime.now();
    return into(focusSessions).insert(
      FocusSessionsCompanion.insert(
        profileId: profile.id,
        startedAt: now,
        plannedDurationMinutes: profile.durationMinutes,
        goalText: Value(profile.goalText),
        status: SessionStatus.active,
        strictness: Value(profile.strictness),
        updatedAt: now,
      ),
    );
  }

  /// Zaznamená pokus o předčasné ukončení — dokončený i ten, po kterém se
  /// uživatel vrátil zpět k práci.
  Future<int> logFrictionExit({
    required int sessionId,
    required FrictionStep stepType,
    required FrictionOutcome outcome,
    String? reflectionText,
  }) {
    return into(frictionExitEvents).insert(
      FrictionExitEventsCompanion.insert(
        sessionId: sessionId,
        triggeredAt: DateTime.now(),
        stepType: stepType,
        outcome: outcome,
        reflectionText: Value(reflectionText),
      ),
    );
  }

  Stream<List<FrictionExitEvent>> watchFrictionEvents(int sessionId) {
    return (select(frictionExitEvents)
          ..where((t) => t.sessionId.equals(sessionId)))
        .watch();
  }

  /// Poslední reflexe napříč session — podklad pro statistiky (§5.6).
  /// Prázdné texty vynechává, aby se v přehledu neobjevovaly prázdné řádky
  /// po dechových cvičeních.
  Stream<List<FrictionExitEvent>> watchRecentReflections({int limit = 20}) {
    return (select(frictionExitEvents)
          ..where((t) => t.reflectionText.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.triggeredAt)])
          ..limit(limit))
        .watch();
  }

  /// Uzavře session daným stavem. [endedAt] lze předat explicitně, aby session
  /// doběhlá na pozadí dostala správný čas konce, ne čas, kdy si toho appka
  /// všimla po návratu z pozadí.
  Future<void> finishSession(
    int sessionId,
    SessionStatus status, {
    DateTime? endedAt,
  }) {
    final now = DateTime.now();
    return (update(focusSessions)..where((t) => t.id.equals(sessionId))).write(
      FocusSessionsCompanion(
        status: Value(status),
        endedAt: Value(endedAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Session pro statistiky a streak, od zadaného data (včetně).
  Stream<List<FocusSession>> watchSessionsSince(DateTime from) {
    return (select(focusSessions)
          ..where((t) => t.startedAt.isBiggerOrEqualValue(from))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .watch();
  }

  // --- Seznamy blokovaných aplikací ---

  Stream<List<BlockedAppList>> watchBlockedLists() {
    return (select(blockedAppLists)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Stream<List<BlockedApp>> watchAppsInList(int listId) {
    return (select(blockedApps)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.appLabel)]))
        .watch();
  }

  Future<List<BlockedApp>> appsInList(int listId) {
    return (select(blockedApps)..where((t) => t.listId.equals(listId))).get();
  }

  Future<int> createBlockedList(String name) {
    final now = DateTime.now();
    return into(blockedAppLists).insert(
      BlockedAppListsCompanion.insert(
        name: name,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> renameBlockedList(int id, String name) {
    return (update(blockedAppLists)..where((t) => t.id.equals(id))).write(
      BlockedAppListsCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteBlockedList(int id) {
    return (delete(blockedAppLists)..where((t) => t.id.equals(id))).go();
  }

  /// Přepíše obsah seznamu jedním zápisem — jednodušší a bez mezistavů,
  /// ve kterých by seznam byl chvíli neúplný.
  Future<void> replaceAppsInList(
    int listId,
    List<({String packageName, String label})> apps,
  ) {
    return transaction(() async {
      await (delete(blockedApps)..where((t) => t.listId.equals(listId))).go();
      for (final app in apps) {
        await into(blockedApps).insert(
          BlockedAppsCompanion.insert(
            listId: listId,
            packageName: app.packageName,
            appLabel: app.label,
          ),
        );
      }
      await (update(blockedAppLists)..where((t) => t.id.equals(listId))).write(
        BlockedAppListsCompanion(updatedAt: Value(DateTime.now())),
      );
    });
  }

  // --- Vazba profil ↔ seznam ---

  Stream<List<BlockedAppList>> watchListsForProfile(int profileId) {
    final query = select(blockedAppLists).join([
      innerJoin(
        profileBlockedLists,
        profileBlockedLists.listId.equalsExp(blockedAppLists.id),
      ),
    ])..where(profileBlockedLists.profileId.equals(profileId));
    return query.watch().map(
          (rows) => rows.map((r) => r.readTable(blockedAppLists)).toList(),
        );
  }

  Future<List<int>> listIdsForProfile(int profileId) async {
    final rows = await (select(profileBlockedLists)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    return rows.map((r) => r.listId).toList();
  }

  Future<void> setListsForProfile(int profileId, List<int> listIds) {
    return transaction(() async {
      await (delete(profileBlockedLists)
            ..where((t) => t.profileId.equals(profileId)))
          .go();
      for (final listId in listIds) {
        await into(profileBlockedLists).insert(
          ProfileBlockedListsCompanion.insert(
            profileId: profileId,
            listId: listId,
          ),
        );
      }
    });
  }

  /// Všechny balíčky, které má profil blokovat — sjednocení jeho seznamů.
  Future<List<String>> blockedPackagesForProfile(int profileId) async {
    final query = selectOnly(blockedApps, distinct: true)
      ..addColumns([blockedApps.packageName])
      ..join([
        innerJoin(
          profileBlockedLists,
          profileBlockedLists.listId.equalsExp(blockedApps.listId),
        ),
      ])
      ..where(profileBlockedLists.profileId.equals(profileId));
    final rows = await query.get();
    return rows.map((r) => r.read(blockedApps.packageName)!).toList();
  }

  // --- Kotevní body ---

  Stream<List<AnchorPoint>> watchAnchors() {
    return (select(anchorPoints)..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<AnchorPoint?> findAnchor(int id) {
    return (select(anchorPoints)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> createAnchor({
    required AnchorType type,
    required String tagIdentifier,
    required String name,
  }) {
    return into(anchorPoints).insertOnConflictUpdate(
      AnchorPointsCompanion.insert(
        type: type,
        tagIdentifier: tagIdentifier,
        name: name,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> renameAnchor(int id, String name) {
    return (update(anchorPoints)..where((t) => t.id.equals(id)))
        .write(AnchorPointsCompanion(name: Value(name)));
  }

  Future<void> deleteAnchor(int id) {
    return (delete(anchorPoints)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markAnchorSeen(int id) {
    return (update(anchorPoints)..where((t) => t.id.equals(id)))
        .write(AnchorPointsCompanion(lastSeenAt: Value(DateTime.now())));
  }

  // --- Nepřítomnosti u kotvy ---

  /// Otevřená nepřítomnost dané session — ta, ke které ještě nepřišel návrat.
  Future<AnchorEvent?> openAbsence(int sessionId) {
    return (select(anchorEvents)
          ..where((t) => t.sessionId.equals(sessionId) & t.returnedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.leftAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> recordDeparture({
    required int anchorPointId,
    required int sessionId,
    required DateTime leftAt,
  }) {
    return into(anchorEvents).insert(
      AnchorEventsCompanion.insert(
        anchorPointId: anchorPointId,
        sessionId: Value(sessionId),
        leftAt: leftAt,
      ),
    );
  }

  Future<void> recordReturn(int eventId, {String? reflectionText}) {
    return (update(anchorEvents)..where((t) => t.id.equals(eventId))).write(
      AnchorEventsCompanion(
        returnedAt: Value(DateTime.now()),
        reflectionText: Value(reflectionText),
      ),
    );
  }

  Stream<List<AnchorEvent>> watchAbsences(int sessionId) {
    return (select(anchorEvents)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.desc(t.leftAt)]))
        .watch();
  }

  // --- Denní limity aplikací ---

  Stream<List<AppUsageLimit>> watchAppLimits() {
    return (select(appUsageLimits)
          ..orderBy([(t) => OrderingTerm.asc(t.appLabel)]))
        .watch();
  }

  Future<List<AppUsageLimit>> allAppLimits() => select(appUsageLimits).get();

  Future<void> upsertAppLimit({
    required String packageName,
    required String appLabel,
    required int dailyMinutes,
    required LimitIntensity intensity,
  }) {
    return into(appUsageLimits).insertOnConflictUpdate(
      AppUsageLimitsCompanion.insert(
        packageName: packageName,
        appLabel: appLabel,
        dailyMinutes: dailyMinutes,
        intensity: intensity,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> deleteAppLimit(String packageName) {
    return (delete(appUsageLimits)
          ..where((t) => t.packageName.equals(packageName)))
        .go();
  }

  Stream<List<FocusSession>> watchRecentSessions({int limit = 20}) {
    return (select(focusSessions)
          ..where((t) => t.status.equalsValue(SessionStatus.active).not())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(limit))
        .watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'kotva.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
