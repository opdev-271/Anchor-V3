import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/design_system/app_theme.dart';
import 'package:kotva/core/design_system/progress_ring.dart';
import 'package:kotva/features/onboarding/presentation/onboarding_screen.dart';
import 'package:kotva/features/settings/application/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Obalí widget aplikačním motivem a zadaným zvětšením písma.
///
/// Zvětšení se nastavuje přes `MediaQuery`, tedy stejnou cestou, jakou ho
/// dodává systém — testuje se to, co uživatel opravdu dostane, ne obezlička
/// v kódu aplikace.
Widget _app(Widget child, {required double scale, Brightness? brightness}) {
  return MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
    child: MaterialApp(
      theme: brightness == Brightness.dark ? AppTheme.dark : AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  /// Krok, po kterém Android přestává být „velké písmo" a je to už krajní
  /// nastavení přístupnosti. Kdo ho zapne, má na to důvod.
  const scales = [1.0, 1.3, 2.0];

  group('dynamické písmo (§13)', () {
    testWidgets('onboarding se nerozpadne ani při dvojnásobném písmu',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      for (final scale in scales) {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
            child: _app(const OnboardingScreen(), scale: scale),
          ),
        );
        await tester.pumpAndSettle();

        // Přetečení layoutu hlásí Flutter jako výjimku. Kdyby se text při
        // zvětšení nevešel, spadne to tady — a přesně o to jde.
        expect(
          tester.takeException(),
          isNull,
          reason: 'onboarding přetekl při zvětšení $scale',
        );
      }
    });

    testWidgets('onboarding jde projít i ve zvětšeném písmu', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: _app(const OnboardingScreen(), scale: 2.0),
        ),
      );
      await tester.pumpAndSettle();

      // Tlačítko „Dál" musí zůstat dosažitelné — kdyby ho odsunul přetečený
      // text, uživatel se ze sekvence nedostane.
      expect(find.text('Dál'), findsOneWidget);
      expect(find.text('Přeskočit'), findsOneWidget);

      await tester.tap(find.text('Dál'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('prstenec odpočtu snese zvětšené písmo', (tester) async {
      for (final scale in scales) {
        await tester.pumpWidget(
          _app(
            const Center(
              child: ProgressRing(
                value: 0.42,
                semanticLabel: 'Průběh bloku',
                child: Text('12:34'),
              ),
            ),
            scale: scale,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'prstenec přetekl při zvětšení $scale',
        );
      }
    });
  });

  group('odečítač obrazovky (§13)', () {
    testWidgets('prstenec odpočtu hlásí průběh, ne jen číslo uprostřed',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _app(
          const Center(
            child: ProgressRing(
              value: 0.42,
              semanticLabel: 'Průběh bloku',
              child: Text('12:34'),
            ),
          ),
          scale: 1.0,
        ),
      );

      // Oblouk je kreslený na plátno, takže bez tohohle popisku by odečítač
      // o průběhu bloku neřekl vůbec nic.
      //
      // Hledá se vzorem, ne přesnou shodou: popisek se slučuje s časem
      // uprostřed prstence do jednoho uzlu („Průběh bloku / 12:34"). Právě to
      // je žádoucí — odečítač přečte obojí naráz i s procenty.
      final ring = find.bySemanticsLabel(RegExp('Průběh bloku'));
      expect(ring, findsOneWidget);

      final node = tester.getSemantics(ring);
      expect(node.value, '42 %');
      expect(node.label, contains('12:34'));

      handle.dispose();
    });

    testWidgets('tečky onboardingu se čtou jako krok X z Y', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: _app(const OnboardingScreen(), scale: 1.0),
        ),
      );
      await tester.pumpAndSettle();

      // Bez popisku by z indikátoru byla jen řada prázdných obdélníků.
      expect(find.bySemanticsLabel(RegExp(r'Krok 1 z \d')), findsOneWidget);

      handle.dispose();
    });
  });
}
