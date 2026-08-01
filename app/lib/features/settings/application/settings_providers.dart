import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Instance [SharedPreferences] načtená před `runApp`.
///
/// Přepisuje se v `main.dart` přes `overrideWithValue`. Díky tomu je motiv
/// k dispozici hned při prvním snímku a aplikace nebliká přepnutím z výchozího
/// vzhledu na uložený.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Přepiš v ProviderScope v main.dart');
});

/// Uložená volba motivu.
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(_key);
    return _decode(stored);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_key, _encode(mode));
  }

  /// Ukládá se název, ne index — přidání další hodnoty do `ThemeMode` by jinak
  /// tiše přepsalo význam už uložených voleb.
  static String _encode(ThemeMode mode) => switch (mode) {
        ThemeMode.system => 'system',
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
      };

  static ThemeMode _decode(String? value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}

extension ThemeModeLabel on ThemeMode {
  String get label => switch (this) {
        ThemeMode.system => 'Podle systému',
        ThemeMode.light => 'Světlý',
        ThemeMode.dark => 'Tmavý',
      };

  String get description => switch (this) {
        ThemeMode.system => 'Přepne se spolu s nastavením telefonu.',
        ThemeMode.light => 'Vždy světlý vzhled.',
        ThemeMode.dark => 'Vždy tmavý vzhled.',
      };

  IconData get icon => switch (this) {
        ThemeMode.system => Icons.brightness_auto,
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
      };
}
