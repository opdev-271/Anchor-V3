import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/czech_plural.dart';

void main() {
  group('czechPlural', () {
    String days(int n) => czechPlural(
          n,
          one: 'den',
          few: 'dny',
          many: 'dní',
        );

    test('jednička má jednotné číslo', () {
      expect(days(1), 'den');
    });

    test('dva až čtyři mají 1. pád množného čísla', () {
      expect(days(2), 'dny');
      expect(days(3), 'dny');
      expect(days(4), 'dny');
    });

    test('pět a víc má 2. pád množného čísla', () {
      expect(days(5), 'dní');
      expect(days(11), 'dní');
      expect(days(100), 'dní');
    });

    test('nula má 2. pád množného čísla', () {
      expect(days(0), 'dní');
    });
  });

  group('czechCount', () {
    test('spojí číslo se správným tvarem', () {
      String apps(int n) => czechCount(
            n,
            one: 'aplikace',
            few: 'aplikace',
            many: 'aplikací',
          );
      expect(apps(1), '1 aplikace');
      expect(apps(3), '3 aplikace');
      expect(apps(7), '7 aplikací');
    });
  });
}
