import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/database.dart';
import 'package:kotva/core/storage/enums.dart';
import 'package:kotva/features/focus_session/domain/streak.dart';

/// Pomocník — sestaví session daného stavu ve zvolený den.
FocusSession _session({
  required DateTime startedAt,
  required SessionStatus status,
  int minutes = 50,
}) {
  return FocusSession(
    id: startedAt.microsecondsSinceEpoch,
    remoteId: null,
    profileId: 1,
    startedAt: startedAt,
    endedAt: startedAt.add(Duration(minutes: minutes)),
    plannedDurationMinutes: minutes,
    goalText: '',
    status: status,
    strictness: StrictnessLevel.medium,
    updatedAt: startedAt,
  );
}

void main() {
  final today = DateTime(2026, 8, 1, 14, 0);

  group('calculateStreak', () {
    test('bez session je streak nula', () {
      expect(calculateStreak(const [], today: today), 0);
    });

    test('počítá po sobě jdoucí dny s dokončenou session', () {
      final sessions = [
        _session(startedAt: today, status: SessionStatus.completed),
        _session(
          startedAt: today.subtract(const Duration(days: 1)),
          status: SessionStatus.completed,
        ),
        _session(
          startedAt: today.subtract(const Duration(days: 2)),
          status: SessionStatus.completed,
        ),
      ];
      expect(calculateStreak(sessions, today: today), 3);
    });

    test('víc session za jeden den se počítá jako jeden den', () {
      final sessions = [
        _session(startedAt: today, status: SessionStatus.completed),
        _session(
          startedAt: today.subtract(const Duration(hours: 3)),
          status: SessionStatus.completed,
        ),
      ];
      expect(calculateStreak(sessions, today: today), 1);
    });

    test('streak přežije den, kdy uživatel ještě dnes nezačal', () {
      // §11 — netrestat uživatele v poledne za to, že ještě nezačal.
      final sessions = [
        _session(
          startedAt: today.subtract(const Duration(days: 1)),
          status: SessionStatus.completed,
        ),
        _session(
          startedAt: today.subtract(const Duration(days: 2)),
          status: SessionStatus.completed,
        ),
      ];
      expect(calculateStreak(sessions, today: today), 2);
    });

    test('mezera dva dny zpět streak ukončí', () {
      final sessions = [
        _session(
          startedAt: today.subtract(const Duration(days: 2)),
          status: SessionStatus.completed,
        ),
      ];
      expect(calculateStreak(sessions, today: today), 0);
    });

    test('přerušená session se do streaku nepočítá', () {
      final sessions = [
        _session(startedAt: today, status: SessionStatus.interrupted),
      ];
      expect(calculateStreak(sessions, today: today), 0);
    });

    test('přerušená session streak nerozbije, když je i dokončená', () {
      final sessions = [
        _session(startedAt: today, status: SessionStatus.interrupted),
        _session(
          startedAt: today.subtract(const Duration(hours: 2)),
          status: SessionStatus.completed,
        ),
        _session(
          startedAt: today.subtract(const Duration(days: 1)),
          status: SessionStatus.completed,
        ),
      ];
      expect(calculateStreak(sessions, today: today), 2);
    });
  });

  group('focusedToday', () {
    test('sčítá jen dnešní bloky', () {
      final sessions = [
        _session(startedAt: today, status: SessionStatus.completed, minutes: 50),
        _session(
          startedAt: today.subtract(const Duration(hours: 4)),
          status: SessionStatus.interrupted,
          minutes: 10,
        ),
        _session(
          startedAt: today.subtract(const Duration(days: 1)),
          status: SessionStatus.completed,
          minutes: 90,
        ),
      ];
      // Přerušený blok se do odpracovaného času počítá — čas u práce
      // proběhl, i když blok nedoběhl celý (§11).
      expect(focusedToday(sessions, now: today), const Duration(minutes: 60));
    });

    test('běžící session se počítá do aktuálního okamžiku', () {
      final running = FocusSession(
        id: 1,
        remoteId: null,
        profileId: 1,
        startedAt: today.subtract(const Duration(minutes: 20)),
        endedAt: null,
        plannedDurationMinutes: 50,
        goalText: '',
        status: SessionStatus.active,
        strictness: StrictnessLevel.medium,
        updatedAt: today,
      );
      expect(focusedToday([running], now: today), const Duration(minutes: 20));
    });
  });
}
