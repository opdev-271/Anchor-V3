import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/design_system/app_theme.dart';
import 'features/focus_session/presentation/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: KotvaApp()));
}

class KotvaApp extends StatelessWidget {
  const KotvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kotva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Motiv se řídí systémem — aplikace uživateli nevnucuje vzhled.
      themeMode: ThemeMode.system,
      locale: const Locale('cs'),
      supportedLocales: const [Locale('cs'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const DashboardScreen(),
    );
  }
}
