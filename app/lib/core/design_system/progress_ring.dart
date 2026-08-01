import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Prstenec odpočtu fokus session.
///
/// Vlastní vykreslení místo `CircularProgressIndicator` kvůli dvěma věcem,
/// které Material widget neumí: přechodu barvy podél oblouku a možnosti mít
/// dráhu výrazně tenčí než samotný ukazatel. Obojí drží pozornost u čísla
/// uprostřed, ne u prstence.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.child,
    this.size = 280,
  });

  /// 0.0 → 1.0.
  final double value;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          value: value.clamp(0.0, 1.0),
          trackColor: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.trackColor});

  final double value;
  final Color trackColor;

  static const _trackWidth = 6.0;
  static const _progressWidth = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - _progressWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _trackWidth
        ..color = trackColor,
    );

    if (value <= 0) return;

    // Start nahoře (12 hodin) a po směru hodinových ručiček.
    const startAngle = -math.pi / 2;
    final sweep = 2 * math.pi * value;

    canvas.drawArc(
      rect,
      startAngle,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _progressWidth
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: 2 * math.pi,
          colors: AppColors.progressGradient,
          transform: const GradientRotation(startAngle),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.trackColor != trackColor;
}
