import 'dart:async';

import 'package:flutter/services.dart';

/// Zařízení nalezené při skenování.
class BleDevice {
  const BleDevice({
    required this.address,
    required this.name,
    required this.rssi,
  });

  final String address;
  final String name;

  /// Síla signálu v dBm. Čím blíž nule, tím blíž zařízení.
  final int rssi;

  String get displayName => name.isEmpty ? address : name;
}

/// Dostupnost Bluetooth skenování.
class BleStatus {
  const BleStatus({
    required this.supported,
    required this.enabled,
    required this.permitted,
  });

  static const unavailable =
      BleStatus(supported: false, enabled: false, permitted: false);

  /// Telefon má Bluetooth.
  final bool supported;

  /// Bluetooth je zapnutý.
  final bool enabled;

  /// Uživatel udělil oprávnění ke skenování.
  final bool permitted;

  bool get ready => supported && enabled && permitted;
}

/// Dart strana mostu do nativní vrstvy kotev.
///
/// Odpovídající Kotlin kód: `android/app/src/main/kotlin/cz/kotva/AnchorPlugin.kt`.
/// Na platformách bez implementace (zatím iOS, testy) vrací „nedostupné"
/// místo výjimky, aby zbytek aplikace fungoval beze změny.
class AnchorChannel {
  AnchorChannel() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  static const _channel = MethodChannel('cz.kotva/anchor');

  final _nfcTags = StreamController<String>.broadcast();

  /// ID štítků přiložených k telefonu, dokud běží [startNfcReader].
  Stream<String> get nfcTags => _nfcTags.stream;

  Future<void> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onNfcTag') {
      final id = (call.arguments as Map)['id'] as String?;
      if (id != null && id.isNotEmpty) _nfcTags.add(id);
    }
  }

  Future<BleStatus> bleStatus() async {
    final raw = await _invoke<Map<dynamic, dynamic>>('bleStatus');
    if (raw == null) return BleStatus.unavailable;
    return BleStatus(
      supported: raw['supported'] as bool? ?? false,
      enabled: raw['enabled'] as bool? ?? false,
      permitted: raw['permitted'] as bool? ?? false,
    );
  }

  Future<void> requestBlePermission() =>
      _invoke<void>('requestBlePermission');

  /// Jedno skenovací okno. Nativní strana ho po několika vteřinách sama ukončí
  /// — souvislé skenování by šlo proti limitu spotřeby (docs/spec.md §13).
  Future<List<BleDevice>> scanOnce() async {
    final raw = await _invoke<List<dynamic>>('scanOnce');
    if (raw == null) return const [];
    final devices = raw
        .cast<Map<dynamic, dynamic>>()
        .map(
          (m) => BleDevice(
            address: m['address'] as String,
            name: (m['name'] as String?) ?? '',
            rssi: (m['rssi'] as num?)?.toInt() ?? -127,
          ),
        )
        .toList();
    // Nejsilnější signál nahoru — maják na stole bývá nejblíž.
    devices.sort((a, b) => b.rssi.compareTo(a.rssi));
    return devices;
  }

  Future<bool> nfcAvailable() async {
    return await _invoke<bool>('nfcAvailable') ?? false;
  }

  Future<void> startNfcReader() => _invoke<void>('startNfcReader');

  Future<void> stopNfcReader() => _invoke<void>('stopNfcReader');

  void dispose() => _nfcTags.close();

  Future<T?> _invoke<T>(String method, [Map<String, dynamic>? args]) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
