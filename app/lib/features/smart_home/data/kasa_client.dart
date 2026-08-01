import 'dart:convert';

import 'package:http/http.dart' as http;

/// Zásuvka nebo jiné spínatelné zařízení na účtu Kasa.
class KasaDevice {
  const KasaDevice({
    required this.deviceId,
    required this.alias,
    required this.model,
    required this.online,
  });

  final String deviceId;
  final String alias;
  final String model;
  final bool online;
}

/// Chyba při komunikaci s Kasa cloudem.
///
/// Nese i strojový kód, aby UI mohlo odlišit „špatné heslo" od „nedostupná
/// služba" a neházet uživateli obecné „něco se pokazilo".
class KasaException implements Exception {
  const KasaException(this.message, {this.code});

  final String message;
  final int? code;

  /// Token vypršel nebo je neplatný — je potřeba se přihlásit znovu.
  bool get isAuthError => code == -20651 || code == -20675;

  @override
  String toString() => 'KasaException($code): $message';
}

/// Klient cloudového API TP-Link Kasa (docs/spec.md §5.3, §7.1).
///
/// ## Proč cloud a ne lokální síť
///
/// Kasa zásuvky umí i lokální protokol na portu 9999, ale ten funguje jen když
/// je telefon na stejné Wi-Fi. Cloudové API funguje odkudkoliv a nevyžaduje,
/// aby uživatel řešil, na jaké je síti. Pro fokus blok, který má vypnout
/// televizi doma, je to spolehlivější.
///
/// ## Co je na tomhle API křehké
///
/// Není veřejně dokumentované ani garantované — TP-Link ho může kdykoliv změnit
/// nebo omezit. Klient je proto psaný tak, aby selhání bylo **neškodné**:
/// když se zásuvku nepodaří přepnout, fokus blok běží dál a uživatel dostane
/// zprávu. Blok nikdy nespadne kvůli tomu, že nejde spojení se zásuvkou.
class KasaClient {
  KasaClient({http.Client? httpClient, Uri? endpoint})
      : _http = httpClient ?? http.Client(),
        _endpoint = endpoint ?? Uri.parse('https://wap.tplinkcloud.com');

  final http.Client _http;
  final Uri _endpoint;

  /// Přihlásí uživatele a vrátí token.
  ///
  /// Heslo se používá **jen tady** a nikam se neukládá — dál se pracuje
  /// výhradně s tokenem (docs/spec.md §9).
  Future<String> login({
    required String username,
    required String password,
    required String terminalUuid,
  }) async {
    final response = await _call({
      'method': 'login',
      'params': {
        'appType': 'Kasa_Android',
        'cloudUserName': username,
        'cloudPassword': password,
        'terminalUUID': terminalUuid,
      },
    });
    final token = response['token'] as String?;
    if (token == null) {
      throw const KasaException('Přihlášení neproběhlo — chybí token.');
    }
    return token;
  }

  /// Zařízení na účtu. Filtruje na ta, která umí spínat.
  Future<List<KasaDevice>> listDevices(String token) async {
    final response = await _call(
      {'method': 'getDeviceList'},
      token: token,
    );
    final list = (response['deviceList'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    return list
        .map(
          (d) => KasaDevice(
            deviceId: d['deviceId'] as String? ?? '',
            alias: d['alias'] as String? ?? 'Zásuvka',
            model: d['deviceModel'] as String? ?? '',
            online: (d['status'] as num?)?.toInt() == 1,
          ),
        )
        .where((d) => d.deviceId.isNotEmpty)
        .toList();
  }

  /// Zjistí, jestli je zásuvka zapnutá.
  Future<bool> isOn(String token, String deviceId) async {
    final response = await _passthrough(
      token,
      deviceId,
      {
        'system': {'get_sysinfo': {}},
      },
    );
    final relayState =
        (response['system']?['get_sysinfo']?['relay_state'] as num?)?.toInt();
    return relayState == 1;
  }

  /// Zapne nebo vypne zásuvku.
  Future<void> setOn(String token, String deviceId, bool on) async {
    await _passthrough(
      token,
      deviceId,
      {
        'system': {
          'set_relay_state': {'state': on ? 1 : 0},
        },
      },
    );
  }

  /// Příkaz zařízení se posílá jako **řetězec s JSONem** uvnitř JSONu —
  /// tak to Kasa cloud vyžaduje.
  Future<Map<String, dynamic>> _passthrough(
    String token,
    String deviceId,
    Map<String, dynamic> command,
  ) async {
    final response = await _call(
      {
        'method': 'passthrough',
        'params': {
          'deviceId': deviceId,
          'requestData': jsonEncode(command),
        },
      },
      token: token,
    );
    final raw = response['responseData'];
    if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
    if (raw is Map<String, dynamic>) return raw;
    return const {};
  }

  Future<Map<String, dynamic>> _call(
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final uri = token == null
        ? _endpoint
        : _endpoint.replace(queryParameters: {'token': token});

    final http.Response response;
    try {
      response = await _http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } catch (e) {
      throw KasaException('Nepodařilo se spojit s Kasa cloudem: $e');
    }

    if (response.statusCode != 200) {
      throw KasaException(
        'Kasa cloud odpověděl chybou ${response.statusCode}.',
        code: response.statusCode,
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final errorCode = (decoded['error_code'] as num?)?.toInt() ?? 0;
    if (errorCode != 0) {
      throw KasaException(
        _messageFor(errorCode, decoded['msg'] as String?),
        code: errorCode,
      );
    }

    return (decoded['result'] as Map<String, dynamic>?) ?? const {};
  }

  /// Překládá kódy na věty, kterým uživatel rozumí. Neznámý kód se ukáže
  /// i s původní zprávou — mlžit „něco se pokazilo" nepomůže nikomu.
  String _messageFor(int code, String? original) => switch (code) {
        -20601 => 'Nesprávné jméno nebo heslo.',
        -20651 || -20675 => 'Přihlášení vypršelo, přihlas se prosím znovu.',
        -20571 => 'Zásuvka je offline.',
        _ => original?.isNotEmpty == true
            ? '$original (kód $code)'
            : 'Kasa cloud odmítl požadavek (kód $code).',
      };

  void close() => _http.close();
}
