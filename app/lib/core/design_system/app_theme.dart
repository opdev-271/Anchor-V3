import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Motiv aplikace.
///
/// Požadavky z docs/spec.md §13 (Přístupnost):
///  - podpora dynamického písma → nikde nepoužíváme pevnou velikost textu bez
///    respektování `MediaQuery.textScaler` (Flutter to dělá automaticky, pokud
///    nepřepíšeme `textScaleFactor`; proto ho nepřepisujeme nikde v aplikaci),
///  - kontrast WCAG AA → páry barev níže jsou voleny na poměr ≥ 4.5:1 pro
///    běžný text a ≥ 3:1 pro velký text a nosné prvky UI,
///  - dotykové cíle ≥ 48 dp ([AppSpacing.minTouchTarget]).
///
/// Vizuální jazyk (revize Anchor-V1 — „modernější a elegantnější"):
///  - **žádné stíny.** Plochy se od sebe oddělují tónem povrchu a tenkou
///    linkou, ne vrstvením. Působí to klidněji než plovoucí karty.
///  - **velkorysé rádiusy** — 20 dp na kartách, plná pilulka na tlačítkách.
///  - **tlumené povrchy místo čisté bílé a černé.** Čistá bílá na světlém
///    pozadí a čistá černá na tmavém řežou do očí; aplikace, kterou má člověk
///    otevřenou při práci, si to nemůže dovolit.
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
    final outline = scheme.outlineVariant.withValues(alpha: 0.4);

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.apply(
        ThemeData(brightness: scheme.brightness).textTheme,
      ),
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.apply(
          ThemeData(brightness: scheme.brightness).textTheme,
        ).titleLarge?.copyWith(color: scheme.onSurface),
      ),

      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: outline),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const StadiumBorder(),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
          textStyle: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          shape: const StadiumBorder(),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        shape: const StadiumBorder(),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),

      listTileTheme: const ListTileThemeData(
        minVerticalPadding: AppSpacing.sm,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),

      dividerTheme: DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),

      sliderTheme: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.surfaceContainerHighest,
        thumbColor: scheme.primary,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: scheme.surfaceContainerHighest,
        linearTrackColor: scheme.surfaceContainerHighest,
      ),
    );
  }
}
