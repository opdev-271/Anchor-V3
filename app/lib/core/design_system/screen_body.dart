import 'package:flutter/material.dart';

import 'app_spacing.dart';

/// Obsah obrazovky, který zabírá **celou** šířku.
///
/// Řeší past, na kterou aplikace narazila u odpočtu: `Column` se na příčné ose
/// smrští na šířku nejširšího potomka a `Padding` ho pak umístí k levému okraji,
/// místo aby ho vycentroval. Výsledkem je obsah viditelně posunutý doleva —
/// tím víc, čím užší jsou jeho prvky.
///
/// Projevilo se to jen na obrazovkách, kde žádný potomek nešel přes celou
/// šířku. Tam, kde bylo tlačítko `SizedBox(width: double.infinity)`, `Column`
/// se roztáhl a všechno sedělo — proto ta nekonzistence mezi obrazovkami.
///
/// [ScreenBody] šířku vynutí, takže `crossAxisAlignment: center` skutečně
/// centruje vůči obrazovce.
class ScreenBody extends StatelessWidget {
  const ScreenBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(width: double.infinity, child: child),
    );
  }
}
