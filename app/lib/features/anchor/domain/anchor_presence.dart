/// Vyhodnocení, jestli je telefon u kotvy (docs/spec.md §5.3).
///
/// Skenování běží v oknech po ~75 s ([AnchorScanner] na nativní straně), takže
/// vstupem je posloupnost „viděn / neviděn". Z ní se skládá stav.
///
/// Klíčové pravidlo: **jedno nezdařené okno neznamená odchod.** Bluetooth signál
/// kolísá — stačí, že si uživatel položí telefon za monitor. Za odchod se
/// považuje teprve to, když maják chybí déle než [PresenceState.awayAfter].
/// Bez toho by aplikace hlásila odchody, které se nestaly, a data pro reflexi
/// by byla k ničemu.
class PresenceState {
  const PresenceState({this.lastSeenAt, this.awaySince});

  /// Naposledy, kdy byl maják v dosahu.
  final DateTime? lastSeenAt;

  /// Od kdy je uživatel považovaný za nepřítomného. `null` = je u kotvy
  /// (nebo maják ještě nebyl vidět ani jednou).
  final DateTime? awaySince;

  bool get isAway => awaySince != null;

  /// Jak dlouho musí maják chybět, než to bereme jako odchod od stolu.
  ///
  /// Tři minuty pokrývají odskočení pro sklenici vody, ale zachytí odchod
  /// z místnosti. Kratší práh by při kolísání signálu hlásil falešné odchody.
  static const awayAfter = Duration(minutes: 3);
}

/// Zpracuje výsledek jednoho skenovacího okna.
PresenceState updatePresence(
  PresenceState current, {
  required bool seen,
  required DateTime now,
  Duration awayAfter = PresenceState.awayAfter,
}) {
  if (seen) {
    return PresenceState(lastSeenAt: now);
  }

  final lastSeen = current.lastSeenAt;
  // Maják nebyl vidět nikdy — nemáme od čeho měřit, takže ani nemůžeme
  // tvrdit, že uživatel odešel.
  if (lastSeen == null) return current;

  // Odchod už běží; opakované nezdařené okno na tom nic nemění.
  if (current.awaySince != null) return current;

  if (now.difference(lastSeen) >= awayAfter) {
    // Za začátek nepřítomnosti bereme poslední spatření, ne okamžik, kdy
    // to aplikace vyhodnotila — jinak by každá nepřítomnost vycházela
    // o práh kratší, než ve skutečnosti byla.
    return PresenceState(lastSeenAt: lastSeen, awaySince: lastSeen);
  }

  return current;
}

/// Text otázky při návratu.
///
/// Zadání (§5.3) i §11 to říkají jasně: **bez obviňování**, jen podklad pro
/// reflexi. Proto se aplikace neptá „proč jsi odešel", ale nabízí uživateli,
/// aby si sám poznamenal, co se dělo — a odpověď je vždy nepovinná.
String returnPrompt(Duration away) {
  final minutes = away.inMinutes;
  if (minutes < 10) {
    return 'Byl/a jsi chvíli pryč. Chceš si poznamenat, co to bylo?';
  }
  return 'Byl/a jsi pryč zhruba $minutes minut. '
      'Chceš si poznamenat, co to bylo?';
}
