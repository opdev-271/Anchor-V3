import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../domain/session_progress.dart';
import '../domain/streak.dart';

/// Databáze aplikace. Jediná instance na běh procesu.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Všechny fokus profily uživatele.
final profilesProvider = StreamProvider<List<FocusProfile>>((ref) {
  return ref.watch(databaseProvider).watchProfiles();
});

/// Právě běžící session (nebo `null`).
final activeSessionProvider = StreamProvider<FocusSession?>((ref) {
  return ref.watch(databaseProvider).watchActiveSession();
});

/// Konkrétní session podle ID — obrazovka průběhu ji sleduje i po uzavření,
/// aby mohla zobrazit dokončení bloku.
final sessionByIdProvider =
    StreamProvider.autoDispose.family<FocusSession?, int>((ref, id) {
  return ref.watch(databaseProvider).watchSession(id);
});

/// Sekundový tik pro odpočet. Samostatný provider, aby překreslování odpočtu
/// nezpůsobovalo dotazy do databáze.
///
/// Tiká **jen když nějaká session běží**. Bez toho by časovač budil UI každou
/// sekundu po celou dobu, co je aplikace otevřená, což jde přímo proti limitu
/// spotřeby baterie v docs/spec.md §13 (pod 3 % denně).
final tickerProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final hasActiveSession =
      ref.watch(activeSessionProvider).valueOrNull != null;
  if (!hasActiveSession) {
    return Stream.value(DateTime.now());
  }

  final controller = StreamController<DateTime>();
  controller.add(DateTime.now());
  final timer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => controller.add(DateTime.now()),
  );
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });
  return controller.stream;
});

/// Průběh běžící session, přepočítaný každou sekundu.
final sessionProgressProvider = Provider.autoDispose<SessionProgress?>((ref) {
  final session = ref.watch(activeSessionProvider).valueOrNull;
  if (session == null) return null;
  final now = ref.watch(tickerProvider).valueOrNull ?? DateTime.now();
  return SessionProgress(session: session, now: now);
});

/// Historie session za posledních 90 dní — podklad pro streak a dnešní progres.
/// 90 dní pokrývá i nejdelší reálný streak a drží dotaz malý.
final recentHistoryProvider = StreamProvider<List<FocusSession>>((ref) {
  final from = DateTime.now().subtract(const Duration(days: 90));
  return ref.watch(databaseProvider).watchSessionsSince(from);
});

final streakProvider = Provider.autoDispose<int>((ref) {
  final sessions = ref.watch(recentHistoryProvider).valueOrNull ?? const [];
  return calculateStreak(sessions);
});

final focusedTodayProvider = Provider.autoDispose<Duration>((ref) {
  final sessions = ref.watch(recentHistoryProvider).valueOrNull ?? const [];
  // Sleduje ticker, aby běžící session narůstala i vizuálně.
  ref.watch(tickerProvider);
  return focusedToday(sessions);
});

/// Řízení životního cyklu session.
final sessionControllerProvider = Provider<SessionController>((ref) {
  return SessionController(ref.watch(databaseProvider));
});

class SessionController {
  SessionController(this._db);

  final AppDatabase _db;

  /// Spustí session z profilu. Pokud už nějaká běží, vrátí její ID beze změny —
  /// aplikace povoluje nejvýš jednu naráz.
  Future<int> start(FocusProfile profile) async {
    final existing = await _db.findActiveSession();
    if (existing != null) return existing.id;
    return _db.startSession(profile);
  }

  /// Uzavře session jako dokončenou. Čas konce je **plánovaný** konec, ne
  /// okamžik, kdy si toho aplikace všimla — session doběhlá na pozadí tak má
  /// v historii správný čas.
  Future<void> complete(FocusSession session) {
    final plannedEnd =
        session.startedAt.add(Duration(minutes: session.plannedDurationMinutes));
    return _db.finishSession(
      session.id,
      SessionStatus.completed,
      endedAt: plannedEnd,
    );
  }

  /// Předčasné ukončení. Vždy povoleno — zpomalení řeší Friction Exit
  /// (docs/spec.md §5.5, Sprint 3), ne zákaz.
  Future<void> interrupt(FocusSession session) {
    return _db.finishSession(session.id, SessionStatus.interrupted);
  }

  /// Dorovná stav po návratu aplikace do popředí: pokud plánovaný konec už
  /// nastal, session se uzavře jako dokončená.
  Future<void> reconcile() async {
    final active = await _db.findActiveSession();
    if (active == null) return;
    final plannedEnd =
        active.startedAt.add(Duration(minutes: active.plannedDurationMinutes));
    if (!DateTime.now().isBefore(plannedEnd)) {
      await complete(active);
    }
  }
}
