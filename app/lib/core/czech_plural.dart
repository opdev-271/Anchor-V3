/// Vybere správný tvar podstatného jména podle počtu.
///
/// Čeština má tři číselné tvary, ne dva jako angličtina:
///  - 1 → jednotné číslo ("1 aplikace", "1 den"),
///  - 2–4 → množné číslo v 1. pádě ("3 aplikace", "3 dny"),
///  - 0 a 5+ → množné číslo v 2. pádě ("5 aplikací", "0 dní").
///
/// Bez tohohle by v UI vznikaly tvary jako "1 aplikací" nebo "2 dní",
/// které působí nedbale.
String czechPlural(
  int count, {
  required String one,
  required String few,
  required String many,
}) {
  if (count == 1) return one;
  if (count >= 2 && count <= 4) return few;
  return many;
}

/// Zkratka pro nejčastější případ — číslo i tvar v jednom řetězci.
String czechCount(
  int count, {
  required String one,
  required String few,
  required String many,
}) {
  return '$count ${czechPlural(count, one: one, few: few, many: many)}';
}
