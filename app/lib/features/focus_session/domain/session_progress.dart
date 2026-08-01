import '../../../core/storage/database.dart';

/// Průběh běžící session, odvozený z **hodin reálného času**, ne z čítače.
///
/// Důvod: odpočet musí přežít uspání procesu, zabití aplikace i restart —
/// jediné, co je perzistované, je `startedAt` a plánovaná délka. Vše ostatní se
/// dopočítá. Díky tomu nelze session "ošidit" ani ji rozbít přepnutím do pozadí.
class SessionProgress {
  const SessionProgress({required this.session, required this.now});

  final FocusSession session;
  final DateTime now;

  Duration get planned => Duration(minutes: session.plannedDurationMinutes);

  DateTime get plannedEnd => session.startedAt.add(planned);

  Duration get elapsed {
    final e = now.difference(session.startedAt);
    if (e.isNegative) return Duration.zero;
    return e > planned ? planned : e;
  }

  Duration get remaining => planned - elapsed;

  /// 0.0 → 1.0 pro indikátor průběhu.
  double get fraction {
    final total = planned.inSeconds;
    if (total <= 0) return 1;
    return (elapsed.inSeconds / total).clamp(0.0, 1.0);
  }

  /// True, jakmile session doběhla naplánovanou délku.
  bool get isDone => !now.isBefore(plannedEnd);
}

/// Formátuje trvání jako `MM:SS`, u delších bloků `H:MM:SS`.
String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  final mm = m.toString().padLeft(2, '0');
  final ss = s.toString().padLeft(2, '0');
  return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
}
