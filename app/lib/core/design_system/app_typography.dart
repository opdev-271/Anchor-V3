import 'package:flutter/material.dart';

/// Typografická škála aplikace.
///
/// Používá přibalený Inter (viz `pubspec.yaml`). Proti systémovému písmu má
/// vyrovnanější šířky číslic a klidnější kresbu, což je znát hlavně na velkém
/// odpočtu, kde se číslice mění každou vteřinu.
///
/// Zásady:
///  - **velké nadpisy mají zápornější prostrkání** — u velkých stupňů působí
///    výchozí mezery rozsypaně,
///  - **odpočet je v lehkém řezu (300)** — velké číslo v tučném řezu působí
///    naléhavě až tísnivě, což jde proti tónu aplikace (docs/spec.md §11),
///  - **nikde nenastavujeme absolutní velikost mimo tuhle škálu**, aby
///    dynamické písmo (§13) fungovalo konzistentně.
abstract final class AppTypography {
  static const fontFamily = 'Inter';

  static TextTheme apply(TextTheme base) {
    return base
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
          displayMedium: base.displayMedium?.copyWith(
            fontWeight: FontWeight.w300,
            letterSpacing: -1.2,
          ),
          displaySmall: base.displaySmall?.copyWith(
            fontWeight: FontWeight.w300,
            letterSpacing: -0.8,
          ),
          headlineLarge: base.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
          ),
          headlineMedium: base.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
          headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
          titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          bodyLarge: base.bodyLarge?.copyWith(height: 1.45),
          bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
          bodySmall: base.bodySmall?.copyWith(height: 1.4),
          labelLarge: base.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        )
        .apply(fontFamily: fontFamily);
  }
}
