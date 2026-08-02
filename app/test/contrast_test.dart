import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/design_system/app_colors.dart';
import 'package:kotva/core/design_system/app_theme.dart';

/// Relativní jas podle WCAG 2.1.
double _luminance(Color c) {
  double channel(double v) {
    final s = v / 255.0;
    return s <= 0.03928 ? s / 12.92 : math.pow((s + 0.055) / 1.055, 2.4) as double;
  }

  // `Color` drží složky jako 0.0–1.0; převod na 0–255 odpovídá zápisu tokenů.
  return 0.2126 * channel(c.r * 255) +
      0.7152 * channel(c.g * 255) +
      0.0722 * channel(c.b * 255);
}

/// Poměr kontrastu dvou barev (1:1 až 21:1).
double contrastRatio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  // Prahy z WCAG 2.1 AA, které vyžaduje docs/spec.md §13.
  const textAA = 4.5;
  const nonTextAA = 3.0;

  group('kontrast — světlý režim', () {
    final scheme = AppTheme.light.colorScheme;

    test('text na povrchu i na pozadí splňuje AA', () {
      expect(
        contrastRatio(scheme.onSurface, scheme.surface),
        greaterThanOrEqualTo(textAA),
      );
      expect(
        contrastRatio(scheme.onSurface, AppColors.sandLight),
        greaterThanOrEqualTo(textAA),
      );
    });

    test('primární barva je čitelná jako text', () {
      // Popisky sekcí a odkazy používají primární barvu v běžné velikosti,
      // takže platí přísnější práh, ne ten pro velký text.
      expect(
        contrastRatio(scheme.primary, scheme.surface),
        greaterThanOrEqualTo(textAA),
      );
      expect(
        contrastRatio(scheme.primary, AppColors.sandLight),
        greaterThanOrEqualTo(textAA),
      );
    });

    test('text na primárním tlačítku splňuje AA', () {
      expect(
        contrastRatio(scheme.onPrimary, scheme.primary),
        greaterThanOrEqualTo(textAA),
      );
    });

    test('destruktivní barva je čitelná', () {
      // Nevratná akce nesmí být hůř čitelná než zbytek obrazovky.
      expect(
        contrastRatio(scheme.error, scheme.surface),
        greaterThanOrEqualTo(textAA),
      );
    });
  });

  group('kontrast — tmavý režim', () {
    final scheme = AppTheme.dark.colorScheme;

    test('text na povrchu i na pozadí splňuje AA', () {
      expect(
        contrastRatio(scheme.onSurface, scheme.surface),
        greaterThanOrEqualTo(textAA),
      );
      expect(
        contrastRatio(scheme.onSurface, AppColors.surfaceDark),
        greaterThanOrEqualTo(textAA),
      );
    });

    test('primární barva je čitelná jako text', () {
      // Tenhle případ dřív propadal: původní `shallow` dá na tmavém povrchu
      // 4.42:1, tedy těsně pod hranicí. Proto existuje `anchorDark`.
      expect(
        contrastRatio(scheme.primary, scheme.surface),
        greaterThanOrEqualTo(textAA),
      );
      expect(
        contrastRatio(scheme.primary, AppColors.surfaceDark),
        greaterThanOrEqualTo(textAA),
      );
    });

    test('destruktivní barva je čitelná', () {
      // Nejhorší nález při měření: světlá červená dávala na tmavém povrchu
      // 2.25:1, což propadá i mírnějšímu prahu pro netextové prvky.
      expect(
        contrastRatio(scheme.error, scheme.surface),
        greaterThanOrEqualTo(textAA),
      );
      expect(
        contrastRatio(scheme.error, AppColors.surfaceDark),
        greaterThanOrEqualTo(textAA),
      );
    });
  });

  group('kontrast — stavy session', () {
    test('ikony stavu splňují práh pro netextové prvky', () {
      // Ikony konce bloku jsou velké grafické prvky doprovázené textem,
      // takže platí 3:1, ne 4.5:1.
      expect(
        contrastRatio(AppColors.completed, AppColors.sandLight),
        greaterThanOrEqualTo(nonTextAA),
      );
      expect(
        contrastRatio(AppColors.completedDark, AppColors.surfaceDark),
        greaterThanOrEqualTo(nonTextAA),
      );
      expect(
        contrastRatio(AppColors.interrupted, AppColors.sandLight),
        greaterThanOrEqualTo(nonTextAA),
      );
      expect(
        contrastRatio(AppColors.interrupted, AppColors.surfaceDark),
        greaterThanOrEqualTo(nonTextAA),
      );
    });

    test('přerušený blok nemá signální červenou (§11)', () {
      // Tón aplikace: přerušení není selhání. Červená je vyhrazená
      // destruktivním akcím, ne hodnocení chování uživatele.
      expect(AppColors.interrupted, isNot(AppColors.destructive));
      expect(AppColors.interrupted, isNot(AppColors.destructiveDark));

      // Kdyby někdo `interrupted` posunul do červené, chytí to tahle
      // podmínka: červená složka nesmí zdaleka převažovat nad zelenou.
      final c = AppColors.interrupted;
      expect(c.g, greaterThan(c.r * 0.5));
    });
  });

  group('kontrolní výpočet', () {
    test('poměr černé a bílé je 21:1', () {
      // Sanity check samotného vzorce — bez něj by testy výše mohly
      // procházet i s rozbitým výpočtem.
      expect(
        contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
        closeTo(21.0, 0.01),
      );
    });
  });
}
