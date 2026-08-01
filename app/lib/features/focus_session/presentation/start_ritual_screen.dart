import 'package:flutter/material.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';

/// "Rituál začátku" (docs/spec.md §5.1) — krátká animace zavírající se brány.
///
/// Účel není ozdoba: je to zřetelný předěl mezi "teď nepracuji" a "teď pracuji"
/// (§3 — focus rituál s jasným začátkem a koncem). Trvá záměrně jen ~2,5 s —
/// dost na to, aby se stihl přepnout kontext, málo na to, aby začal obtěžovat
/// při každodenním používání.
///
/// Zvuková složka rituálu zatím **není** implementovaná — chybí zvukový asset
/// a přehrávač. Viz TODO níže; není to vynechané tiše.
class StartRitualScreen extends StatefulWidget {
  const StartRitualScreen({
    super.key,
    required this.goalText,
    required this.onComplete,
  });

  final String goalText;
  final VoidCallback onComplete;

  @override
  State<StartRitualScreen> createState() => _StartRitualScreenState();
}

class _StartRitualScreenState extends State<StartRitualScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _gate;
  late final Animation<double> _anchorFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Brána se zavírá s doběhem — jako těžká vrata, ne jako roleta.
    _gate = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.62, curve: Curves.easeInOutCubic),
    );
    _anchorFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    _controller.forward().whenComplete(() {
      if (mounted) widget.onComplete();
    });

    // TODO(sprint-1): jemný zvuk zavření brány — vyžaduje zvukový asset
    // a balíček pro přehrávání. Respektovat tichý režim telefonu.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepSea,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Levé a pravé křídlo brány.
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5 * _gate.value,
                  heightFactor: 1,
                  child: const ColoredBox(color: AppColors.anchor),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5 * _gate.value,
                  heightFactor: 1,
                  child: const ColoredBox(color: AppColors.anchor),
                ),
              ),

              // Kotva a cíl se objeví, až je brána zavřená.
              Center(
                child: Opacity(
                  opacity: _anchorFade.value,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.anchor,
                          size: 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Kotva spuštěna',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.goalText.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            widget.goalText,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
