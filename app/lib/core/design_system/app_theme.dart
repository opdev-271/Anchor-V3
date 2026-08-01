import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Motiv aplikace.
///
/// Požadavky z docs/spec.md §13 (Přístupnost):
///  - podpora dynamického písma → nikde nepoužíváme pevnou velikost textu bez
///    respektování `MediaQuery.textScaler` (Flutter to dělá automaticky, pokud
///    nepřepíšeme `textScaleFactor`; proto ho nepřepisujeme nikde v aplikaci),
///  - kontrast WCAG AA → páry barev níže jsou voleny na poměr ≥ 4.5:1 pro
///    běžný text a ≥ 3:1 pro velký text a nosné prvky UI,
///  - dotykové cíle ≥ 48 dp ([AppSpacing.minTouchTarget]).
abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.anchor,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.anchor,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.inkLight,
      error: AppColors.destructive,
    );
    return _base(scheme, AppColors.sandLight);
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.anchor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.shallow,
      surface: AppColors.surfaceDarkElevated,
      onSurface: AppColors.inkDark,
      error: AppColors.destructive,
    );
    return _base(scheme, AppColors.surfaceDark);
  }

  static ThemeData _base(ColorScheme scheme, Color scaffoldBackground) {
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        minVerticalPadding: AppSpacing.sm,
      ),
    );
  }
}
