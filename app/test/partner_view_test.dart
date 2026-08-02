import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/database.dart';
import 'package:kotva/core/storage/enums.dart';
import 'package:kotva/features/accountability/domain/partner_view.dart';

/// Session s citlivým obsahem — cíl je tu schválně výmluvný, aby bylo
/// v testu vidět, kdyby prosákl ven.
FocusSession _session({
  required SessionStatus status,
  int workedMinutes = 25,
  String goalText = 'TAJNY-CIL-dopsat-vypoved',
}) {
  final start = DateTime(2026, 8, 2, 9, 0);
  return FocusSession(
    id: 1,
    remoteId: null,
    profileId: 1,
    startedAt: start,
    endedAt: status == SessionStatus.active
        ? null
        : start.add(Duration(minutes: workedMinutes)),
    plannedDurationMinutes: 50,
    goalText: goalText,
    status: status,
    strictness: StrictnessLevel.medium,
    updatedAt: start,
  );
}

void main() {
  group('hranice soukromí (§9)', () {
    test('zpráva nikdy neobsahuje cíl bloku', () {
      // Tohle je celý smysl téhle vrstvy: parťák vidí stav, ne obsah práce.
      for (final status in SessionStatus.values) {
        final update = partnerUpdateFor(
          _session(status: status),
          now: DateTime(2026, 8, 2, 9, 25),
        );
        final message = composePartnerMessage(update);
        expect(message, isNot(contains('TAJNY-CIL')));
        expect(message, isNot(contains('vypoved')));
      }
    });

    test('PartnerUpdate nese jen stav a odpracované minuty', () {
      final update = partnerUpdateFor(
        _session(status: SessionStatus.completed, workedMinutes: 50),
      );
      expect(update.status, PartnerStatus.finished);
      expect(update.workedMinutes, 50);
    });
  });

  group('partnerUpdateFor', () {
    test('běžící session hlásí, že uživatel pracuje', () {
      final update = partnerUpdateFor(
        _session(status: SessionStatus.active),
        now: DateTime(2026, 8, 2, 9, 20),
      );
      expect(update.status, PartnerStatus.working);
      expect(update.workedMinutes, 20);
    });

    test('dokončený a předčasně ukončený blok se rozlišují', () {
      expect(
        partnerUpdateFor(_session(status: SessionStatus.completed)).status,
        PartnerStatus.finished,
      );
      expect(
        partnerUpdateFor(_session(status: SessionStatus.interrupted)).status,
        PartnerStatus.endedEarly,
      );
    });

    test('posun hodin zpět nedá záporné minuty', () {
      final update = partnerUpdateFor(
        _session(status: SessionStatus.active),
        now: DateTime(2026, 8, 2, 8, 30),
      );
      expect(update.workedMinutes, 0);
    });
  });

  group('tón zprávy (§11)', () {
    test('u předčasného konce se uživatel neshazuje', () {
      // Zadání §5.4 nabízí jako příklad „zase jsem to nedodělal/a".
      // Takovou formulaci aplikace nepoužívá — odporovala by §11.
      final message = composePartnerMessage(
        partnerUpdateFor(
          _session(status: SessionStatus.interrupted, workedMinutes: 12),
        ),
      ).toLowerCase();

      expect(message, isNot(contains('zase')));
      expect(message, isNot(contains('nezvlád')));
      expect(message, isNot(contains('nedodělal')));
      expect(message, isNot(contains('selh')));
      // Odpracovaný čas se naopak uzná.
      expect(message, contains('počítá'));
    });

    test('u dokončeného bloku uvede odpracovaný čas', () {
      final message = composePartnerMessage(
        partnerUpdateFor(
          _session(status: SessionStatus.completed, workedMinutes: 50),
        ),
      );
      expect(message, contains('50 minut'));
    });

    test('minuty se skloňují', () {
      String msg(int m) => composePartnerMessage(
            partnerUpdateFor(
              _session(status: SessionStatus.completed, workedMinutes: m),
            ),
          );
      // „1 minut práce" by působilo nedbale.
      expect(msg(1), contains('1 minuta'));
      expect(msg(3), contains('3 minuty'));
      expect(msg(25), contains('25 minut'));
    });

    test('podepíše se jménem aplikace, když jméno odesílatele chybí', () {
      final message = composePartnerMessage(
        partnerUpdateFor(_session(status: SessionStatus.completed)),
      );
      expect(message, contains('Kotva'));
    });
  });
}
