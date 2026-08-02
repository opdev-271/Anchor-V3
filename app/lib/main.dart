import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/design_system/app_theme.dart';
import 'features/focus_session/presentation/dashboard_screen.dart';
import 'features/onboarding/application/onboarding_providers.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/settings/application/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Načteno před prvním snímkem, aby uložený motiv platil hned a aplikace
  // neproblikla světlým vzhledem, než se přečte volba uživatele.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const KotvaApp(),
    ),
  );
}

class KotvaApp extends ConsumerWidget {
  const KotvaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Kotva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      locale: const Locale('cs'),
      supportedLocales: const [Locale('cs'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Onboarding je jen při prvním spuštění. Přepíná se stavem, ne navigací,
      // aby po jeho dokončení nezůstal v zásobníku a nešlo se do něj vrátit
      // tlačítkem zpět.
      home: ref.watch(onboardingCompletedProvider)
          ? const DashboardScreen()
          : const OnboardingScreen(),
    );
  }
}
