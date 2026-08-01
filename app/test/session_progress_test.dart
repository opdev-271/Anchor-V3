import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/database.dart';
import 'package:kotva/core/storage/enums.dart';
import 'package:kotva/features/focus_session/domain/session_progress.dart';

FocusSession _running(DateTime startedAt, int minutes) => FocusSession(
      id: 1,
      remoteId: null,
      profileId: 1,
      startedAt: startedAt,
      endedAt: null,
      plannedDurationMinutes: minutes,
      goalText: 'dokončit kapitolu 3',
      status: SessionStatus.active,
      updatedAt: startedAt,
    );

void main() {
  final start = DateTime(2026, 8, 1, 9, 0);

  group('SessionProgress', () {
    test('na začátku zbývá celá plánovaná délka', () {
      final p = SessionProgress(session: _running(start, 50), now: start);
      expect(p.remaining, const Duration(minutes: 50));
      expect(p.elapsed, Duration.zero);
      expect(p.fraction, 0);
      expect(p.isDone, isFalse);
    });

    test('v polovině bloku je fraction 0.5', () {
      final p = SessionProgress(
        session: _running(start, 50),
        now: start.add(const Duration(minutes: 25)),
      );
      expect(p.remaining, const Duration(minutes: 25));
      expect(p.fraction, closeTo(0.5, 0.001));
      expect(p.isDone, isFalse);
    });

    test('přesně v čase konce je blok hotový', () {
      final p = SessionProgress(
        session: _running(start, 50),
        now: start.add(const Duration(minutes: 50)),
      );
      expect(p.remaining, Duration.zero);
      expect(p.fraction, 1);
      expect(p.isDone, isTrue);
    });

    test('po překročení konce se odpočet nezáporní', () {
      // Simuluje návrat z pozadí dlouho po doběhnutí bloku.
      final p = SessionProgress(
        session: _running(start, 50),
        now: start.add(const Duration(hours: 5)),
      );
      expect(p.remaining, Duration.zero);
      expect(p.elapsed, const Duration(minutes: 50));
      expect(p.fraction, 1);
      expect(p.isDone, isTrue);
    });

    test('posun hodin zpět neudělá záporný elapsed', () {
      final p = SessionProgress(
        session: _running(start, 50),
        now: start.subtract(const Duration(minutes: 10)),
      );
      expect(p.elapsed, Duration.zero);
      expect(p.remaining, const Duration(minutes: 50));
    });

    test('plannedEnd odpovídá startu plus délce', () {
      final p = SessionProgress(session: _running(start, 90), now: start);
      expect(p.plannedEnd, DateTime(2026, 8, 1, 10, 30));
    });
  });

  group('formatDuration', () {
    test('formátuje minuty a sekundy', () {
      expect(formatDuration(const Duration(minutes: 25)), '25:00');
      expect(formatDuration(const Duration(minutes: 4, seconds: 7)), '04:07');
      expect(formatDuration(Duration.zero), '00:00');
    });

    test('u bloků nad hodinu přidá hodiny', () {
      expect(
        formatDuration(const Duration(hours: 2, minutes: 5, seconds: 3)),
        '2:05:03',
      );
    });
  });
}
