import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/database.dart';
import 'package:kotva/core/storage/enums.dart';
import 'package:kotva/features/stats/domain/focus_stats.dart';

FocusSession _session({
  required DateTime startedAt,
  required SessionStatus status,
  int plannedMinutes = 50,
  int? workedMinutes,
}) {
  final worked = workedMinutes ?? plannedMinutes;
  return FocusSession(
    id: startedAt.microsecondsSinceEpoch,
    remoteId: null,
    profileId: 1,
    startedAt: startedAt,
    endedAt: status == SessionStatus.active
        ? null
        : startedAt.add(Duration(minutes: worked)),
    plannedDurationMinutes: plannedMinutes,
    goalText: '',
    status: status,
    strictness: StrictnessLevel.medium,
    updatedAt: startedAt,
  );
}

void main() {
  final today = DateTime(2026, 8, 1, 10, 0); // sobota

  group('summarize', () {
    test('bez dat vrací nuly', () {
      final s = summarize(const [], days: 7, now: today);
      expect(s.totalFocus, Duration.zero);
      expect(s.totalCount, 0);
      expect(s.activeDays, 0);
      expect(s.averagePerActiveDay, Duration.zero);
    });

    test('započítá i přerušené bloky do odpracovaného času', () {
      // §11 — čas u práce proběhl, i když blok nedoběhl celý.
      final sessions = [
        _session(startedAt: today, status: SessionStatus.completed,
            plannedMinutes: 50),
        _session(
          startedAt: today.subtract(const Duration(hours: 3)),
          status: SessionStatus.interrupted,
          plannedMinutes: 50,
          workedMinutes: 10,
        ),
      ];
      final s = summarize(sessions, days: 7, now: today);
      expect(s.totalFocus, const Duration(minutes: 60));
      expect(s.completedCount, 1);
      expect(s.interruptedCount, 1);
    });

    test('ignoruje session mimo období', () {
      final sessions = [
        _session(
          startedAt: today.subtract(const Duration(days: 10)),
          status: SessionStatus.completed,
        ),
      ];
      expect(summarize(sessions, days: 7, now: today).totalCount, 0);
    });

    test('běžící session se do statistik nepočítá', () {
      final sessions = [
        _session(startedAt: today, status: SessionStatus.active),
      ];
      expect(summarize(sessions, days: 7, now: today).totalCount, 0);
    });

    test('průměr počítá jen aktivní dny, ne kalendářní', () {
      // Volno nemá průměr srážet — byl by to skrytý trest.
      final sessions = [
        _session(startedAt: today, status: SessionStatus.completed,
            plannedMinutes: 60),
        _session(
          startedAt: today.subtract(const Duration(days: 1)),
          status: SessionStatus.completed,
          plannedMinutes: 60,
        ),
      ];
      final s = summarize(sessions, days: 7, now: today);
      expect(s.activeDays, 2);
      expect(s.averagePerActiveDay, const Duration(minutes: 60));
    });
  });

  group('dailyFocus', () {
    test('vrací souvislou řadu dní včetně nulových', () {
      final days = dailyFocus(const [], days: 7, now: today);
      expect(days, hasLength(7));
      expect(days.first.day, DateTime(2026, 7, 26));
      expect(days.last.day, DateTime(2026, 8, 1));
      expect(days.every((d) => d.focus == Duration.zero), isTrue);
    });

    test('sečte víc session ve stejný den', () {
      final sessions = [
        _session(startedAt: today, status: SessionStatus.completed,
            plannedMinutes: 30),
        _session(
          startedAt: today.subtract(const Duration(hours: 5)),
          status: SessionStatus.completed,
          plannedMinutes: 20,
        ),
      ];
      final days = dailyFocus(sessions, days: 7, now: today);
      expect(days.last.focus, const Duration(minutes: 50));
    });
  });

  group('nejlepší kombinace', () {
    test('mlčí, dokud není dost vzorků', () {
      // Tvrdit „úterý je tvůj nejlepší den" z jedné session je nesmysl.
      final sessions = [
        _session(startedAt: today, status: SessionStatus.completed),
      ];
      expect(bestWeekday(sessions), isNull);
      expect(bestTimeOfDay(sessions), isNull);
      expect(bestDuration(sessions), isNull);
    });

    test('najde délku bloku s nejvyšším podílem dokončení', () {
      final sessions = [
        for (var i = 0; i < 3; i++)
          _session(
            startedAt: today.subtract(Duration(days: i)),
            status: SessionStatus.completed,
            plannedMinutes: 25,
          ),
        for (var i = 3; i < 6; i++)
          _session(
            startedAt: today.subtract(Duration(days: i)),
            status: SessionStatus.interrupted,
            plannedMinutes: 90,
            workedMinutes: 10,
          ),
      ];
      final best = bestDuration(sessions);
      expect(best, isNotNull);
      expect(best!.value, 25);
      expect(best.sampleCount, 3);
      expect(best.completedCount, 3);
    });

    test('kategorii, kde nikdy nic nedoběhlo, nevydává za nejlepší', () {
      final sessions = [
        for (var i = 0; i < 4; i++)
          _session(
            startedAt: today.subtract(Duration(days: i)),
            status: SessionStatus.interrupted,
            plannedMinutes: 90,
            workedMinutes: 5,
          ),
      ];
      expect(bestDuration(sessions), isNull);
    });

    test('při shodě podílu rozhoduje víc vzorků', () {
      final sessions = [
        for (var i = 0; i < 3; i++)
          _session(
            startedAt: today.subtract(Duration(days: i)),
            status: SessionStatus.completed,
            plannedMinutes: 25,
          ),
        for (var i = 3; i < 8; i++)
          _session(
            startedAt: today.subtract(Duration(days: i)),
            status: SessionStatus.completed,
            plannedMinutes: 50,
          ),
      ];
      expect(bestDuration(sessions)!.value, 50);
    });

    test('rozliší denní dobu podle hodiny startu', () {
      expect(TimeOfDayBucket.of(DateTime(2026, 8, 1, 9)),
          TimeOfDayBucket.morning);
      expect(TimeOfDayBucket.of(DateTime(2026, 8, 1, 14)),
          TimeOfDayBucket.afternoon);
      expect(TimeOfDayBucket.of(DateTime(2026, 8, 1, 21)),
          TimeOfDayBucket.evening);
    });
  });

  group('typicalDropOff', () {
    test('mlčí při málu dat', () {
      final sessions = [
        _session(
          startedAt: today,
          status: SessionStatus.interrupted,
          workedMinutes: 10,
        ),
      ];
      expect(typicalDropOff(sessions), isNull);
    });

    test('vrací medián, takže ho jeden extrém nestrhne', () {
      final sessions = [
        for (final m in [8, 10, 12, 11, 1])
          _session(
            startedAt: today.subtract(Duration(days: m)),
            status: SessionStatus.interrupted,
            plannedMinutes: 50,
            workedMinutes: m,
          ),
      ];
      // Seřazeno: 1, 8, 10, 11, 12 → medián 10.
      expect(typicalDropOff(sessions), const Duration(minutes: 10));
    });

    test('dokončené bloky do výpočtu nepatří', () {
      final sessions = [
        for (var i = 0; i < 5; i++)
          _session(
            startedAt: today.subtract(Duration(days: i)),
            status: SessionStatus.completed,
          ),
      ];
      expect(typicalDropOff(sessions), isNull);
    });
  });

  group('weekdayName', () {
    test('pojmenuje dny česky v 1. pádě', () {
      expect(weekdayName(DateTime.monday), 'pondělí');
      expect(weekdayName(DateTime.sunday), 'neděle');
    });

    test('s předložkou skloňuje a volí správné v/ve', () {
      // Prosté „ve " + název by dalo „ve středa" nebo „v sobota".
      expect(weekdayNameIn(DateTime.monday), 'v pondělí');
      expect(weekdayNameIn(DateTime.wednesday), 've středu');
      expect(weekdayNameIn(DateTime.thursday), 've čtvrtek');
      expect(weekdayNameIn(DateTime.saturday), 'v sobotu');
      expect(weekdayNameIn(DateTime.sunday), 'v neděli');
    });
  });
}
