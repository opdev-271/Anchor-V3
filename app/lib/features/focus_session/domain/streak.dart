import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';

/// Spočítá streak — počet po sobě jdoucích dní s alespoň jednou **dokončenou**
/// session.
///
/// Návaznost na otevřenou otázku #1 v docs/data-model.md: streak se počítá jako
/// odvozená hodnota z historie, ne jako cachované pole. Dokud je aplikace
/// offline-first bez backendu, je to jednodušší i bezpečnější — neexistuje
/// stav, který by se mohl rozejít s realitou.
///
/// Pravidlo návaznosti (§11 — neobviňovat): pokud dnes ještě žádná session
/// nebyla, ale včera ano, streak **zůstává naživu**. Trestat uživatele v poledne
/// za to, že ještě nezačal, by bylo shamingem.
int calculateStreak(List<FocusSession> sessions, {DateTime? today}) {
  final days = <DateTime>{
    for (final s in sessions)
      if (s.status == SessionStatus.completed) _dateOnly(s.startedAt),
  };
  if (days.isEmpty) return 0;

  final todayDate = _dateOnly(today ?? DateTime.now());
  final yesterday = todayDate.subtract(const Duration(days: 1));

  DateTime cursor;
  if (days.contains(todayDate)) {
    cursor = todayDate;
  } else if (days.contains(yesterday)) {
    cursor = yesterday;
  } else {
    return 0;
  }

  var streak = 0;
  while (days.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

/// Součet skutečně odpracovaného času za dnešek (včetně právě běžící session).
Duration focusedToday(List<FocusSession> sessions, {DateTime? now}) {
  final currentTime = now ?? DateTime.now();
  final todayDate = _dateOnly(currentTime);
  var total = Duration.zero;
  for (final s in sessions) {
    if (_dateOnly(s.startedAt) != todayDate) continue;
    final end = s.endedAt ?? currentTime;
    final d = end.difference(s.startedAt);
    if (!d.isNegative) total += d;
  }
  return total;
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
