import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';

/// Statistiky fokus session (docs/spec.md §5.6).
///
/// Všechno jsou čisté funkce nad seznamem session — žádný stav, žádná
/// databáze. Díky tomu jdou pravidla otestovat bez emulátoru, což je u
/// statistik podstatné: chyba v agregaci není vidět, jen tiše lže.
///
/// Tón výstupů se řídí [§11](../../../../docs/spec.md): statistiky **nehodnotí**.
/// Nikde se nepočítá „úspěšnost" ani „míra selhání" — jen se hledá, co
/// uživateli vychází nejlíp, aby to mohl zopakovat.

/// Souhrn za období.
class FocusSummary {
  const FocusSummary({
    required this.totalFocus,
    required this.completedCount,
    required this.interruptedCount,
    required this.activeDays,
  });

  /// Skutečně odpracovaný čas — včetně přerušených bloků. Čas u práce
  /// proběhl, i když blok nedoběhl celý.
  final Duration totalFocus;

  final int completedCount;
  final int interruptedCount;

  /// Počet dní, kdy proběhla aspoň jedna session.
  final int activeDays;

  int get totalCount => completedCount + interruptedCount;

  /// Průměr na aktivní den, ne na kalendářní — dny bez práce nemají
  /// průměr srážet, to by byl skrytý trest za volno.
  Duration get averagePerActiveDay => activeDays == 0
      ? Duration.zero
      : Duration(seconds: totalFocus.inSeconds ~/ activeDays);
}

/// Denní součet pro graf.
class DailyFocus {
  const DailyFocus({required this.day, required this.focus});

  final DateTime day;
  final Duration focus;
}

/// Zjištění typu „nejlíp ti vychází…". Nese i počet vzorků, aby UI mohlo
/// mlčet, dokud jich není dost.
class BestSlot<T> {
  const BestSlot({
    required this.value,
    required this.sampleCount,
    required this.completedCount,
  });

  final T value;
  final int sampleCount;
  final int completedCount;
}

/// Denní doba, ve které blok začal.
enum TimeOfDayBucket {
  morning,
  afternoon,
  evening;

  String get label => switch (this) {
        TimeOfDayBucket.morning => 'dopoledne',
        TimeOfDayBucket.afternoon => 'odpoledne',
        TimeOfDayBucket.evening => 'večer',
      };

  static TimeOfDayBucket of(DateTime time) {
    if (time.hour < 12) return TimeOfDayBucket.morning;
    if (time.hour < 18) return TimeOfDayBucket.afternoon;
    return TimeOfDayBucket.evening;
  }
}

/// Kolik session musí mít kategorie, než o ní něco tvrdíme.
///
/// Bez téhle hranice by aplikace po jediném bloku prohlásila „úterý je tvůj
/// nejlepší den", což je nesmysl, který podkopává důvěru ve zbytek čísel.
const minSamplesForClaim = 3;

/// Session, které nejsou ještě aktivní — do statistik patří jen uzavřené.
Iterable<FocusSession> _finished(List<FocusSession> sessions) =>
    sessions.where((s) => s.status != SessionStatus.active);

Duration _worked(FocusSession session) {
  final end = session.endedAt;
  if (end == null) return Duration.zero;
  final d = end.difference(session.startedAt);
  return d.isNegative ? Duration.zero : d;
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Souhrn za posledních [days] dní (dnešek včetně).
FocusSummary summarize(
  List<FocusSession> sessions, {
  required int days,
  DateTime? now,
}) {
  final currentTime = now ?? DateTime.now();
  final from = _dateOnly(currentTime).subtract(Duration(days: days - 1));

  var total = Duration.zero;
  var completed = 0;
  var interrupted = 0;
  final activeDays = <DateTime>{};

  for (final s in _finished(sessions)) {
    if (s.startedAt.isBefore(from)) continue;
    total += _worked(s);
    if (s.status == SessionStatus.completed) {
      completed++;
    } else {
      interrupted++;
    }
    activeDays.add(_dateOnly(s.startedAt));
  }

  return FocusSummary(
    totalFocus: total,
    completedCount: completed,
    interruptedCount: interrupted,
    activeDays: activeDays.length,
  );
}

/// Denní součty pro graf, nejstarší první. Dny bez práce jsou v seznamu
/// s nulou, aby graf neměl díry.
List<DailyFocus> dailyFocus(
  List<FocusSession> sessions, {
  required int days,
  DateTime? now,
}) {
  final today = _dateOnly(now ?? DateTime.now());
  final totals = <DateTime, Duration>{};

  for (final s in _finished(sessions)) {
    final day = _dateOnly(s.startedAt);
    totals[day] = (totals[day] ?? Duration.zero) + _worked(s);
  }

  return [
    for (var i = days - 1; i >= 0; i--)
      () {
        final day = today.subtract(Duration(days: i));
        return DailyFocus(day: day, focus: totals[day] ?? Duration.zero);
      }(),
  ];
}

/// Den v týdnu, ve kterém uživateli bloky nejčastěji doběhnou celé.
///
/// Vrací `null`, dokud žádná kategorie nemá dost vzorků — raději nic než
/// tvrzení z jednoho pozorování.
BestSlot<int>? bestWeekday(List<FocusSession> sessions) {
  return _bestBy(sessions, (s) => s.startedAt.weekday);
}

/// Denní doba s nejvyšším podílem dokončených bloků.
BestSlot<TimeOfDayBucket>? bestTimeOfDay(List<FocusSession> sessions) {
  return _bestBy(sessions, (s) => TimeOfDayBucket.of(s.startedAt));
}

/// Délka bloku, která uživateli nejčastěji vydrží až do konce.
BestSlot<int>? bestDuration(List<FocusSession> sessions) {
  return _bestBy(sessions, (s) => s.plannedDurationMinutes);
}

/// Společné jádro: seskupí session podle klíče a vrátí kategorii s nejvyšším
/// podílem dokončení. Při shodě rozhoduje větší počet vzorků — tvrzení
/// opřené o víc dat je důvěryhodnější.
BestSlot<T>? _bestBy<T>(
  List<FocusSession> sessions,
  T Function(FocusSession) key,
) {
  final groups = <T, List<FocusSession>>{};
  for (final s in _finished(sessions)) {
    groups.putIfAbsent(key(s), () => []).add(s);
  }

  BestSlot<T>? best;
  double bestRatio = -1;

  for (final entry in groups.entries) {
    if (entry.value.length < minSamplesForClaim) continue;
    final completed =
        entry.value.where((s) => s.status == SessionStatus.completed).length;
    final ratio = completed / entry.value.length;

    final isBetter = ratio > bestRatio ||
        (ratio == bestRatio && entry.value.length > (best?.sampleCount ?? 0));
    if (isBetter) {
      bestRatio = ratio;
      best = BestSlot(
        value: entry.key,
        sampleCount: entry.value.length,
        completedCount: completed,
      );
    }
  }

  // Kategorie, kde nikdy nic nedoběhlo, není „nejlepší" — to by byl
  // nesmyslný a demotivující výstup.
  if (best != null && best.completedCount == 0) return null;
  return best;
}

/// Po jak dlouhé práci uživatel bloky typicky ukončuje dřív.
///
/// Medián, ne průměr: jeden blok ukončený po deseti vteřinách by průměr
/// strhl a číslo by přestalo odpovídat skutečnosti.
Duration? typicalDropOff(List<FocusSession> sessions) {
  final durations = _finished(sessions)
      .where((s) => s.status == SessionStatus.interrupted)
      .map(_worked)
      .where((d) => d > Duration.zero)
      .toList()
    ..sort();

  if (durations.length < minSamplesForClaim) return null;
  return durations[durations.length ~/ 2];
}

/// Název dne v týdnu v 1. pádě (1 = pondělí).
String weekdayName(int weekday) => switch (weekday) {
      DateTime.monday => 'pondělí',
      DateTime.tuesday => 'úterý',
      DateTime.wednesday => 'středa',
      DateTime.thursday => 'čtvrtek',
      DateTime.friday => 'pátek',
      DateTime.saturday => 'sobota',
      _ => 'neděle',
    };

/// Den v týdnu s předložkou, připravený k vložení do věty.
///
/// Čeština tu mění dvě věci naráz: předložku (`v` vs. `ve`) i pád dne.
/// Prosté „ve " + [weekdayName] by dalo „ve středa" nebo „v sobota".
String weekdayNameIn(int weekday) => switch (weekday) {
      DateTime.monday => 'v pondělí',
      DateTime.tuesday => 'v úterý',
      DateTime.wednesday => 've středu',
      DateTime.thursday => 've čtvrtek',
      DateTime.friday => 'v pátek',
      DateTime.saturday => 'v sobotu',
      _ => 'v neděli',
    };
