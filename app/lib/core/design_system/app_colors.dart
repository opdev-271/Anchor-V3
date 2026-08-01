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

  /// Probíhající session.
  static const active = shallow;

  /// Přerušená session — tlumená pískově-jantarová.
  /// NENÍ červená: viz docs/spec.md §11 (žádné shame prvky).
  static const interrupted = Color(0xFFB08341);

  /// Jediné legitimní použití červené: destruktivní akce uživatele
  /// (smazání dat dle §9), nikdy hodnocení jeho chování.
  static const destructive = Color(0xFFB3261E);
}
