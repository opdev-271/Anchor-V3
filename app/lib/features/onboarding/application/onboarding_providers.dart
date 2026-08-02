import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/application/settings_providers.dart';

/// Jestli má uživatel onboarding za sebou.
///
/// Žije v `SharedPreferences`, ne v databázi, a to schválně: smazání všech dat
/// (§9) vyprázdní databázi, ale onboarding se tím **nemá** spustit znovu.
/// Uživatel appku zná — přehrát mu uvítací sekvenci znovu by bylo otravné
/// a vypadalo by to jako chyba.
final onboardingCompletedProvider =
    NotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);

class OnboardingNotifier extends Notifier<bool> {
  static const _key = 'onboarding_completed';

  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;
  }

  /// Volá se jak po dokončení, tak po přeskočení. Rozdíl mezi „prošel do konce"
  /// a „přeskočil" si aplikace nepamatuje — nebylo by to k čemu a znamenalo by
  /// to sledovat, jak pozorně uživatel četl.
  Future<void> complete() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(_key, true);
  }

  /// Umožní projít onboarding znovu z nastavení.
  Future<void> reset() async {
    state = false;
    await ref.read(sharedPreferencesProvider).setBool(_key, false);
  }
}
