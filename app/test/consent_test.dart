import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/database.dart';
import 'package:kotva/core/storage/enums.dart';
import 'package:kotva/features/privacy/domain/consent.dart';

ConsentRecord _record(
  ConsentCategory category, {
  required DateTime grantedAt,
  DateTime? revokedAt,
  int id = 1,
}) {
  return ConsentRecord(
    id: id,
    remoteId: null,
    category: category,
    grantedAt: grantedAt,
    revokedAt: revokedAt,
  );
}

void main() {
  final t0 = DateTime(2026, 8, 2, 9, 0);

  group('odvození stavu souhlasu (§9)', () {
    test('bez záznamů není udělený žádný souhlas', () {
      // Výchozí stav je „ne". Aplikace nesmí nic sbírat, dokud se nezeptá.
      final state = consentState(const []);
      for (final category in ConsentCategory.values) {
        expect(state[category], isFalse, reason: category.name);
      }
    });

    test('otevřený záznam znamená udělený souhlas', () {
      final records = [_record(ConsentCategory.usageStats, grantedAt: t0)];
      expect(isConsentGranted(records, ConsentCategory.usageStats), isTrue);
    });

    test('doplněné revokedAt souhlas ruší', () {
      final records = [
        _record(
          ConsentCategory.usageStats,
          grantedAt: t0,
          revokedAt: t0.add(const Duration(hours: 1)),
        ),
      ];
      expect(isConsentGranted(records, ConsentCategory.usageStats), isFalse);
    });

    test('souhlas je platný, i když mu předchází odvolaná historie', () {
      // Udělit → odvolat → udělit znovu. Historie zůstává kvůli doložitelnosti,
      // ale rozhoduje jediný otevřený záznam.
      final records = [
        _record(
          ConsentCategory.location,
          id: 1,
          grantedAt: t0,
          revokedAt: t0.add(const Duration(days: 1)),
        ),
        _record(
          ConsentCategory.location,
          id: 2,
          grantedAt: t0.add(const Duration(days: 2)),
        ),
      ];
      expect(isConsentGranted(records, ConsentCategory.location), isTrue);
    });

    test('shodná časová razítka nerozhodují — rozhoduje otevřenost záznamu', () {
      // Kdyby se stav odvozoval z „posledního řádku", byla by odpověď při
      // shodném čase náhodná. Tenhle případ nastane při rychlém přepnutí
      // přepínače tam a zpět.
      final records = [
        _record(ConsentCategory.smartHome, id: 1, grantedAt: t0, revokedAt: t0),
        _record(ConsentCategory.smartHome, id: 2, grantedAt: t0),
      ];
      expect(isConsentGranted(records, ConsentCategory.smartHome), isTrue);
    });

    test('kategorie se navzájem neovlivňují', () {
      // Granularita je celý smysl §9: souhlas s jednou věcí není souhlas se vším.
      final records = [_record(ConsentCategory.usageStats, grantedAt: t0)];
      final state = consentState(records);
      expect(state[ConsentCategory.usageStats], isTrue);
      expect(state[ConsentCategory.location], isFalse);
      expect(state[ConsentCategory.smartHome], isFalse);
    });
  });

  group('texty souhlasů (§8)', () {
    test('každá kategorie má vysvětlení, tok dat i důsledek odvolání', () {
      // §8 chce vysvětlení **před** vyžádáním. Prázdný text by znamenal
      // obrazovku, která si o souhlas řekne bez odůvodnění.
      for (final category in ConsentCategory.values) {
        expect(category.label, isNotEmpty, reason: category.name);
        expect(category.purpose, isNotEmpty, reason: category.name);
        expect(category.dataFlow, isNotEmpty, reason: category.name);
        expect(
          category.consequenceOfRevoking,
          isNotEmpty,
          reason: category.name,
        );
      }
    });

    test('kotva se neprezentuje jako sledování polohy', () {
      // BLE sken je v manifestu `neverForLocation` a aplikace polohu neurčuje.
      // Text to musí říkat, jinak by uživatel souhlasil s něčím jiným, než co
      // se opravdu děje.
      expect(
        ConsentCategory.location.dataFlow,
        contains('neurčuje'),
      );
    });
  });
}
