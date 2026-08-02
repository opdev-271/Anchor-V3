import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../blocking/application/blocking_providers.dart';
import '../../focus_session/application/focus_providers.dart';
import '../../privacy/application/privacy_providers.dart';

final appLimitsProvider = StreamProvider<List<AppUsageLimit>>((ref) {
  return ref.watch(databaseProvider).watchAppLimits();
});

final appLimitsControllerProvider = Provider<AppLimitsController>((ref) {
  return AppLimitsController(ref);
});

/// Udržuje limity v databázi a zároveň je propisuje do nativní vrstvy.
///
/// Vynucování běží v `AppLimits.kt` nad `SharedPreferences`, protože služba
/// přístupnosti k databázi Flutteru nemá přístup. Databáze je tu kvůli UI
/// a budoucí synchronizaci; obě strany musí zůstat v souladu, proto každá
/// změna prochází tímhle jedním místem.
class AppLimitsController {
  AppLimitsController(this._ref);

  final Ref _ref;

  Future<void> save({
    required String packageName,
    required String appLabel,
    required int dailyMinutes,
    required LimitIntensity intensity,
  }) async {
    await _ref.read(databaseProvider).upsertAppLimit(
          packageName: packageName,
          appLabel: appLabel,
          dailyMinutes: dailyMinutes,
          intensity: intensity,
        );
    await _syncToNative();
  }

  Future<void> remove(String packageName) async {
    await _ref.read(databaseProvider).deleteAppLimit(packageName);
    await _syncToNative();
  }

  /// Přenese aktuální stav do nativní vrstvy. Volá se i při startu aplikace,
  /// aby se obě strany srovnaly po přeinstalaci nebo vyčištění dat.
  Future<void> syncToNative() => _syncToNative();

  Future<void> _syncToNative() async {
    // Bez souhlasu s kategorií „čas v aplikacích" se do nativní vrstvy
    // nepropisuje nic (docs/spec.md §9). Pojistka navíc: odvolání souhlasu
    // limity samo maže, ale tenhle sync běží i při startu aplikace a nesmí
    // je vzkřísit, kdyby v databázi něco zbylo.
    if (!_ref.read(consentGrantedProvider(ConsentCategory.usageStats))) {
      await _ref.read(blockingChannelProvider).saveAppLimits(const []);
      return;
    }

    final limits = await _ref.read(databaseProvider).allAppLimits();
    await _ref.read(blockingChannelProvider).saveAppLimits(
          limits
              .map(
                (l) => <String, Object>{
                  'packageName': l.packageName,
                  'label': l.appLabel,
                  'dailyMinutes': l.dailyMinutes,
                  'intensity': l.intensity.index,
                },
              )
              .toList(),
        );
  }
}
