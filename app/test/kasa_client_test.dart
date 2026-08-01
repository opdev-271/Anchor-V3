import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kotva/features/smart_home/data/kasa_client.dart';

/// Vrací připravenou odpověď a zapamatuje si poslední požadavek.
class _Recorder {
  Map<String, dynamic>? lastBody;
  Uri? lastUri;

  MockClient respond(Object body) {
    return MockClient((request) async {
      lastUri = request.url;
      lastBody = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(jsonEncode(body), 200);
    });
  }
}

KasaClient _client(http.Client inner) => KasaClient(
      httpClient: inner,
      endpoint: Uri.parse('https://example.test'),
    );

void main() {
  group('login', () {
    test('vrátí token a heslo pošle jen sem', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({
          'error_code': 0,
          'result': {'token': 'abc123'},
        }),
      );

      final token = await client.login(
        username: 'user@example.test',
        password: 'tajne',
        terminalUuid: 'uuid-1',
      );

      expect(token, 'abc123');
      expect(rec.lastBody!['method'], 'login');
      expect(rec.lastBody!['params']['cloudUserName'], 'user@example.test');
    });

    test('chybné přihlášení hlásí srozumitelně', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({'error_code': -20601, 'msg': 'Invalid credentials'}),
      );

      await expectLater(
        client.login(
          username: 'u',
          password: 'spatne',
          terminalUuid: 'uuid-1',
        ),
        throwsA(
          isA<KasaException>().having(
            (e) => e.message,
            'message',
            contains('Nesprávné jméno nebo heslo'),
          ),
        ),
      );
    });

    test('chybějící token je chyba, ne tichý úspěch', () async {
      final rec = _Recorder();
      final client = _client(rec.respond({'error_code': 0, 'result': {}}));

      await expectLater(
        client.login(username: 'u', password: 'p', terminalUuid: 'x'),
        throwsA(isA<KasaException>()),
      );
    });
  });

  group('listDevices', () {
    test('načte zařízení a pozná offline', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({
          'error_code': 0,
          'result': {
            'deviceList': [
              {
                'deviceId': 'dev1',
                'alias': 'Televize',
                'deviceModel': 'HS100(EU)',
                'status': 1,
              },
              {
                'deviceId': 'dev2',
                'alias': 'Konzole',
                'deviceModel': 'HS110(EU)',
                'status': 0,
              },
            ],
          },
        }),
      );

      final devices = await client.listDevices('token');
      expect(devices, hasLength(2));
      expect(devices.first.alias, 'Televize');
      expect(devices.first.online, isTrue);
      expect(devices.last.online, isFalse);
      // Token patří do dotazu, ne do těla.
      expect(rec.lastUri!.queryParameters['token'], 'token');
    });

    test('záznam bez ID přeskočí', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({
          'error_code': 0,
          'result': {
            'deviceList': [
              {'alias': 'Rozbitý'},
            ],
          },
        }),
      );
      expect(await client.listDevices('token'), isEmpty);
    });
  });

  group('setOn', () {
    test('pošle příkaz jako JSON v řetězci, jak Kasa vyžaduje', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({
          'error_code': 0,
          'result': {'responseData': '{"system":{"set_relay_state":{}}}'},
        }),
      );

      await client.setOn('token', 'dev1', false);

      expect(rec.lastBody!['method'], 'passthrough');
      final requestData = rec.lastBody!['params']['requestData'] as String;
      final command = jsonDecode(requestData) as Map<String, dynamic>;
      expect(command['system']['set_relay_state']['state'], 0);
    });

    test('zapnutí posílá stav 1', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({
          'error_code': 0,
          'result': {'responseData': '{}'},
        }),
      );

      await client.setOn('token', 'dev1', true);
      final command = jsonDecode(
        rec.lastBody!['params']['requestData'] as String,
      ) as Map<String, dynamic>;
      expect(command['system']['set_relay_state']['state'], 1);
    });
  });

  group('isOn', () {
    test('přečte stav relé z odpovědi', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({
          'error_code': 0,
          'result': {
            'responseData':
                '{"system":{"get_sysinfo":{"relay_state":1,"alias":"TV"}}}',
          },
        }),
      );
      expect(await client.isOn('token', 'dev1'), isTrue);
    });

    test('chybějící stav bere jako vypnuto', () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({
          'error_code': 0,
          'result': {'responseData': '{}'},
        }),
      );
      expect(await client.isOn('token', 'dev1'), isFalse);
    });
  });

  group('chyby', () {
    test('vypršelý token je rozpoznatelný, aby šlo nabídnout přihlášení',
        () async {
      final rec = _Recorder();
      final client = _client(rec.respond({'error_code': -20651}));

      try {
        await client.listDevices('stary-token');
        fail('mělo vyhodit KasaException');
      } on KasaException catch (e) {
        expect(e.isAuthError, isTrue);
      }
    });

    test('offline zásuvka má vlastní hlášku', () async {
      final rec = _Recorder();
      final client = _client(rec.respond({'error_code': -20571}));

      await expectLater(
        client.setOn('token', 'dev1', false),
        throwsA(
          isA<KasaException>().having(
            (e) => e.message,
            'message',
            contains('offline'),
          ),
        ),
      );
    });

    test('neznámý kód nese původní zprávu, ne obecné „něco se pokazilo"',
        () async {
      final rec = _Recorder();
      final client = _client(
        rec.respond({'error_code': -12345, 'msg': 'Rate limited'}),
      );

      await expectLater(
        client.listDevices('token'),
        throwsA(
          isA<KasaException>().having(
            (e) => e.message,
            'message',
            allOf(contains('Rate limited'), contains('-12345')),
          ),
        ),
      );
    });

    test('výpadek sítě se nepropíše jako pád', () async {
      final client = _client(
        MockClient((_) async => throw const SocketExceptionStub()),
      );

      await expectLater(
        client.listDevices('token'),
        throwsA(isA<KasaException>()),
      );
    });
  });
}

/// Náhrada za síťovou chybu — `MockClient` neumí vyhodit `SocketException`
/// bez importu `dart:io`, který v testech nechceme.
class SocketExceptionStub implements Exception {
  const SocketExceptionStub();

  @override
  String toString() => 'spojení selhalo';
}
