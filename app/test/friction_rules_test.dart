import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/storage/enums.dart';
import 'package:kotva/features/friction_exit/domain/friction_rules.dart';

void main() {
  group('breathingDuration', () {
    test('střední přísnost odpovídá 30 s ze zadání §5.5', () {
      expect(
        breathingDuration(StrictnessLevel.medium),
        const Duration(seconds: 30),
      );
    });

    test('přísnější úroveň zpomaluje déle', () {
      final mild = breathingDuration(StrictnessLevel.mild);
      final medium = breathingDuration(StrictnessLevel.medium);
      final strict = breathingDuration(StrictnessLevel.strict);
      expect(mild, lessThan(medium));
      expect(medium, lessThan(strict));
    });

    test('zpomalení zůstává krátké i u nejpřísnější úrovně', () {
      // §5.5 a §11 — cílem je přerušit impulz, ne trestat. Delší čekání
      // zvyšuje jen frustraci a šanci na odinstalaci.
      for (final level in StrictnessLevel.values) {
        expect(
          breathingDuration(level),
          lessThanOrEqualTo(const Duration(minutes: 1)),
        );
      }
    });
  });

  group('minReflectionLength', () {
    test('přísnější úroveň chce delší zamyšlení', () {
      expect(
        minReflectionLength(StrictnessLevel.mild),
        lessThan(minReflectionLength(StrictnessLevel.strict)),
      );
    });

    test('limit zůstává v rozsahu jedné věty', () {
      // Zadání mluví o "napsání jedné věty", ne o eseji.
      for (final level in StrictnessLevel.values) {
        expect(minReflectionLength(level), greaterThan(0));
        expect(minReflectionLength(level), lessThanOrEqualTo(50));
      }
    });
  });

  group('breathCycle', () {
    test('jeden cyklus je pomalejší než klidové dýchání', () {
      expect(breathCycle.inSeconds, greaterThanOrEqualTo(6));
    });

    test('do nejkratšího zpomalení se vejde aspoň jeden celý cyklus', () {
      expect(
        breathingDuration(StrictnessLevel.mild).inMilliseconds,
        greaterThanOrEqualTo(breathCycle.inMilliseconds),
      );
    });
  });
}
