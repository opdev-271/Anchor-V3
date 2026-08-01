import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotva/core/design_system/screen_body.dart';

/// Regrese k chybě z Anchor-V1: odpočet nebyl vycentrovaný, protože `Column`
/// se smrskl na šířku nejširšího potomka a `Padding` ho zarovnal doleva.
void main() {
  const key = Key('uzky-prvek');

  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(body: SafeArea(child: child)),
      );

  testWidgets('ScreenBody vycentruje úzký prvek vůči obrazovce', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ScreenBody(
          child: Column(
            children: [
              SizedBox(key: key, width: 60, height: 60),
            ],
          ),
        ),
      ),
    );

    final screen = tester.getSize(find.byType(Scaffold)).width;
    final element = tester.getCenter(find.byKey(key));
    expect(element.dx, moreOrLessEquals(screen / 2, epsilon: 0.5));
  });

  testWidgets(
    'holý Padding + Column úzký prvek necentruje — proto ScreenBody existuje',
    (tester) async {
      await tester.pumpWidget(
        wrap(
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(key: key, width: 60, height: 60),
              ],
            ),
          ),
        ),
      );

      final screen = tester.getSize(find.byType(Scaffold)).width;
      final element = tester.getCenter(find.byKey(key));
      // Column se smrskl na 60 px a Padding ho položil k levému okraji:
      // střed prvku je 24 + 30 = 54 px, ne uprostřed obrazovky.
      expect(element.dx, moreOrLessEquals(54, epsilon: 0.5));
      expect(element.dx, isNot(moreOrLessEquals(screen / 2, epsilon: 1)));
    },
  );

  testWidgets('ScreenBody centruje i při různě širokých potomcích',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ScreenBody(
          child: Column(
            children: [
              SizedBox(width: 200, height: 20),
              SizedBox(key: key, width: 40, height: 20),
            ],
          ),
        ),
      ),
    );

    final screen = tester.getSize(find.byType(Scaffold)).width;
    expect(
      tester.getCenter(find.byKey(key)).dx,
      moreOrLessEquals(screen / 2, epsilon: 0.5),
    );
  });
}
