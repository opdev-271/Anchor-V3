import 'package:flutter/material.dart';

/// Barevné tokeny aplikace Kotva.
///
/// Metafora: klid hluboké vody a pevný bod (kotva). Paleta je záměrně tlumená —
/// aplikace má uklidňovat, ne budit poplach.
///
/// Zásada z docs/spec.md §11: **žádná červená pro přerušenou session**. Přerušení
/// není selhání, je to jen jiný stav. Proto [interrupted] používá tlumenou
/// pískovou, ne signální červenou. Červená je v celé aplikaci vyhrazená výhradně
/// pro destruktivní akce uživatele (smazání dat), nikdy pro hodnocení chování.
abstract final class AppColors {
  // --- Základ ---
  /// Hluboká voda — primární značková barva.
  static const deepSea = Color(0xFF0E3B43);

  /// Kotva — primární akční barva (tlačítka, aktivní stavy).
  static const anchor = Color(0xFF14746F);

  /// Mělčina — světlejší akcent pro průběh a zvýraznění.
  static const shallow = Color(0xFF2A9D8F);

  /// Primární barva pro tmavý režim.
  ///
  /// Proč nestačí [shallow]: na tmavém povrchu má poměr 4.42:1, což je těsně
  /// **pod** hranicí 4.5:1, kterou WCAG AA žádá pro běžný text. Popisky sekcí
  /// primární barvou přitom běžný text jsou (14 sp), takže by propadaly.
  /// Tenhle odstín je o kousek světlejší a dá 5.10:1. Hlídá to
  /// `test/contrast_test.dart`.
  static const anchorDark = Color(0xFF35A99A);

  // --- Povrchy ---
  static const sandLight = Color(0xFFF6F4EF);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const inkLight = Color(0xFF12211F);

  static const surfaceDark = Color(0xFF10201F);
  static const surfaceDarkElevated = Color(0xFF172C2A);
  static const inkDark = Color(0xFFE8EFED);

  // --- Stavy session ---
  /// Dokončená session.
  static const completed = anchor;

  /// Dokončená session v tmavém režimu — [anchor] na tmavém povrchu dá 3.01:1,
  /// tedy přesně na hraně prahu pro ikony. Světlejší odstín dělá z „těsně
  /// prošlo" čitelný prvek.
  static const completedDark = anchorDark;

  /// Probíhající session.
  static const active = shallow;

  /// Přerušená session — tlumená pískově-jantarová.
  /// NENÍ červená: viz docs/spec.md §11 (žádné shame prvky).
  static const interrupted = Color(0xFFB08341);

  /// Jediné legitimní použití červené: destruktivní akce uživatele
  /// (smazání dat dle §9), nikdy hodnocení jeho chování.
  static const destructive = Color(0xFFB3261E);

  /// Destruktivní barva pro tmavý režim.
  ///
  /// [destructive] je laděná na světlé pozadí a na tmavém povrchu dá jen
  /// 2.25:1 — propadá i mírnějšímu prahu 3:1 pro netextové prvky. Text
  /// „Smazat všechna data" tím byl v tmavém režimu hůř čitelný než zbytek
  /// obrazovky, což je u nevratné akce přesně obráceně, než má být.
  static const destructiveDark = Color(0xFFE5877F);

  /// Přechod pro nosné plochy — hero karta na přehledu, prstenec odpočtu.
  ///
  /// Záměrně velmi mělký: dva blízké odstíny téže barvy. Výraznější přechod by
  /// z klidné aplikace udělal reklamní banner.
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepSea, anchor],
  );

  /// Přechod prstence odpočtu — od hlubší k světlejší, aby bylo poznat,
  /// kudy čas plyne.
  static const progressGradient = [anchor, shallow];
}
