import 'package:flutter/services.dart';

/// Jedna aplikace nainstalovaná na zařízení.
class InstalledApp {
  const InstalledApp({
    required this.packageName,
    required this.label,
    required this.usageMinutes,
  });

  final String packageName;
  final String label;

  /// Čas v popředí za posledních 7 dní. Bez oprávnění k údajům o používání
  /// je vždy 0 — seznam se pak řadí abecedně.
  final int usageMinutes;
}

/// Dart strana mostu do nativní blokovací vrstvy.
///
/// Odpovídající Kotlin kód: `android/app/src/main/kotlin/cz/kotva/BlockingPlugin.kt`.
///
/// Blokování je funkce **jen pro Android** (docs/roadmap.md — sekvencování).
/// Na jiných platformách všechny dotazy vracejí "nedostupné" místo výjimky,
/// aby se zbytek aplikace dal spustit i tam.
class BlockingChannel {
  const BlockingChannel();

  static const _channel = MethodChannel('cz.kotva/blocking');

  Future<bool> isAccessibilityServiceEnabled() async {
    return await _invoke<bool>('isAccessibilityServiceEnabled') ?? false;
  }

  Future<void> openAccessibilitySettings() =>
      _invoke<void>('openAccessibilitySettings');

  Future<bool> hasUsageAccess() async {
    return await _invoke<bool>('hasUsageAccess') ?? false;
  }

  Future<void> openUsageAccessSettings() =>
      _invoke<void>('openUsageAccessSettings');

  Future<List<InstalledApp>> getInstalledApps() async {
    final raw = await _invoke<List<dynamic>>('getInstalledApps');
    if (raw == null) return const [];
    return raw
        .cast<Map<dynamic, dynamic>>()
        .map(
          (m) => InstalledApp(
            packageName: m['packageName'] as String,
            label: m['label'] as String,
            usageMinutes: (m['usageMinutes'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList();
  }

  /// Zapne blokaci do [endsAt]. Nativní strana si čas konce drží sama, aby
  /// blokace nezůstala viset, kdyby Flutter proces mezitím zanikl.
  Future<void> startBlocking({
    required List<String> packages,
    required String goalText,
    required DateTime endsAt,
  }) {
    return _invoke<void>('startBlocking', {
      'packages': packages,
      'goalText': goalText,
      'endsAtMillis': endsAt.millisecondsSinceEpoch,
    });
  }

  Future<void> stopBlocking() => _invoke<void>('stopBlocking');

  Future<T?> _invoke<T>(String method, [Map<String, dynamic>? args]) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      // Platforma bez nativní implementace (zatím iOS, testy).
      return null;
    } on PlatformException {
      return null;
    }
  }
}
