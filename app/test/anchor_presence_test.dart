import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/features/anchor/domain/anchor_presence.dart';

void main() {
  final t0 = DateTime(2026, 8, 1, 10, 0);
  const awayAfter = Duration(minutes: 3);

  PresenceState scan(
    PresenceState state, {
    required bool seen,
    required Duration at,
  }) =>
      updatePresence(
        state,
        seen: seen,
        now: t0.add(at),
        awayAfter: awayAfter,
      );

  group('updatePresence', () {
    test('spatření nastaví čas a zruší nepřítomnost', () {
      var s = const PresenceState();
      s = scan(s, seen: true, at: Duration.zero);
      expect(s.lastSeenAt, t0);
      expect(s.isAway, isFalse);
    });

    test('jedno nezdařené okno ještě není odchod', () {
      // Signál kolísá; stačí položit telefon za monitor.
      var s = scan(const PresenceState(), seen: true, at: Duration.zero);
      s = scan(s, seen: false, at: const Duration(seconds: 75));
      expect(s.isAway, isFalse);
    });

    test('odchod se pozná až po překročení prahu', () {
      var s = scan(const PresenceState(), seen: true, at: Duration.zero);
      s = scan(s, seen: false, at: const Duration(minutes: 2));
      expect(s.isAway, isFalse);
      s = scan(s, seen: false, at: const Duration(minutes: 3));
      expect(s.isAway, isTrue);
    });

    test('nepřítomnost se počítá od posledního spatření', () {
      // Ne od okamžiku vyhodnocení — jinak by každá nepřítomnost vycházela
      // o práh kratší, než ve skutečnosti byla.
      var s = scan(const PresenceState(), seen: true, at: Duration.zero);
      s = scan(s, seen: false, at: const Duration(minutes: 5));
      expect(s.awaySince, t0);
    });

    test('návrat nepřítomnost ukončí', () {
      var s = scan(const PresenceState(), seen: true, at: Duration.zero);
      s = scan(s, seen: false, at: const Duration(minutes: 4));
      expect(s.isAway, isTrue);
      s = scan(s, seen: true, at: const Duration(minutes: 5));
      expect(s.isAway, isFalse);
      expect(s.lastSeenAt, t0.add(const Duration(minutes: 5)));
    });

    test('další nezdařená okna už začátek nepřítomnosti neposouvají', () {
      var s = scan(const PresenceState(), seen: true, at: Duration.zero);
      s = scan(s, seen: false, at: const Duration(minutes: 4));
      final started = s.awaySince;
      s = scan(s, seen: false, at: const Duration(minutes: 9));
      expect(s.awaySince, started);
    });

    test('dokud nebyl maják vidět ani jednou, odchod nehlásíme', () {
      var s = const PresenceState();
      s = scan(s, seen: false, at: const Duration(minutes: 30));
      expect(s.isAway, isFalse);
      expect(s.lastSeenAt, isNull);
    });
  });

  group('returnPrompt', () {
    test('u krátké nepřítomnosti neuvádí minuty', () {
      final text = returnPrompt(const Duration(minutes: 4));
      expect(text, contains('chvíli'));
      expect(text, isNot(contains('4')));
    });

    test('u delší nepřítomnosti uvede, jak dlouho', () {
      expect(returnPrompt(const Duration(minutes: 25)), contains('25'));
    });

    test('neobviňuje', () {
      // §11 — aplikace se neptá „proč jsi odešel".
      for (final d in [const Duration(minutes: 4), const Duration(minutes: 40)]) {
        final text = returnPrompt(d).toLowerCase();
        expect(text, isNot(contains('proč')));
        expect(text, contains('chceš'));
      }
    });
  });
}
