import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/enums.dart';
import '../domain/friction_rules.dart';

/// Friction Exit — zpomalení mezi impulzem skončit a skutečným ukončením
/// (docs/spec.md §5.5).
///
/// Dvě pravidla, která se nesmí porušit:
///
///  1. **Zpomalovací krok nejde obejít** (akceptační kritérium §14). Systémové
///     "zpět" je po dobu kroku vypnuté a tlačítko k ukončení do té doby vůbec
///     neexistuje.
///  2. **Po zpomalení je ukončení vždy možné** (§5.5, §11). Aplikace nemá být
///     vězení — cílem je přerušit impulz, ne uživatele uvěznit. Proto tu není
///     žádná podmínka, žádné přemlouvání navíc a žádný další krok.
///
/// Odpočet dýchání běží na Flutter tickeru, ne na `Timer`u. Ticker se zastaví,
/// když aplikace není v popředí — zpomalení tak znamená 30 sekund skutečné
/// přítomnosti, ne 30 sekund odsunuté aplikace.
class FrictionExitScreen extends ConsumerStatefulWidget {
  const FrictionExitScreen({
    super.key,
    required this.strictness,
    required this.goalText,
  });

  final StrictnessLevel strictness;
  final String goalText;

  @override
  ConsumerState<FrictionExitScreen> createState() => _FrictionExitScreenState();
}

/// Výsledek, se kterým obrazovka končí.
class FrictionExitResult {
  const FrictionExitResult({
    required this.outcome,
    required this.step,
    this.reflectionText,
  });

  final FrictionOutcome outcome;
  final FrictionStep step;
  final String? reflectionText;
}

enum _Phase { choice, breathing, reflection, decision }

class _FrictionExitScreenState extends ConsumerState<FrictionExitScreen>
    with SingleTickerProviderStateMixin {
  _Phase _phase = _Phase.choice;
  FrictionStep? _step;
  late final AnimationController _breath;
  final _reflectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: breathingDuration(widget.strictness),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _phase = _Phase.decision);
        }
      });
    _reflectionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _breath.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  bool get _canLeave => _phase == _Phase.choice || _phase == _Phase.decision;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Během zpomalovacího kroku systémové "zpět" nefunguje — jinak by šel
      // krok obejít a akceptační kritérium §14 by neplatilo.
      canPop: _canLeave,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: switch (_phase) {
              _Phase.choice => _ChoiceView(
                  goalText: widget.goalText,
                  onBreathing: _startBreathing,
                  onReflection: () => setState(() {
                    _step = FrictionStep.reflection;
                    _phase = _Phase.reflection;
                  }),
                  onCancel: () => Navigator.of(context).pop(),
                ),
              _Phase.breathing => _BreathingView(
                  controller: _breath,
                  total: breathingDuration(widget.strictness),
                ),
              _Phase.reflection => _ReflectionView(
                  controller: _reflectionController,
                  minLength: minReflectionLength(widget.strictness),
                  onDone: () => setState(() => _phase = _Phase.decision),
                ),
              _Phase.decision => _DecisionView(
                  goalText: widget.goalText,
                  onResume: () => _finish(FrictionOutcome.resumed),
                  onEnd: () => _finish(FrictionOutcome.ended),
                ),
            },
          ),
        ),
      ),
    );
  }

  void _startBreathing() {
    setState(() {
      _step = FrictionStep.breathing;
      _phase = _Phase.breathing;
    });
    _breath.forward(from: 0);
  }

  void _finish(FrictionOutcome outcome) {
    final text = _reflectionController.text.trim();
    Navigator.of(context).pop(
      FrictionExitResult(
        outcome: outcome,
        step: _step ?? FrictionStep.breathing,
        reflectionText: text.isEmpty ? null : text,
      ),
    );
  }
}

/// Volba zpomalovacího kroku.
///
/// Volba sama je součástí zpomalení — donutí na vteřinu přemýšlet místo
/// reflexivního ťuknutí. Zároveň respektuje, že někomu sedí dýchání a někomu
/// psaní.
class _ChoiceView extends StatelessWidget {
  const _ChoiceView({
    required this.goalText,
    required this.onBreathing,
    required this.onReflection,
    required this.onCancel,
  });

  final String goalText;
  final VoidCallback onBreathing;
  final VoidCallback onReflection;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Spacer(),
        Text(
          'Než skončíš',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Dej si chvilku. Pak se rozhodneš — a ať zvolíš cokoliv, '
          'bude to v pořádku.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (goalText.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Text(
                    'Tvůj cíl pro tenhle blok',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    goalText,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
        const Spacer(),
        _OptionCard(
          icon: Icons.air,
          title: 'Nadechnout se',
          subtitle: 'Chvíle klidného dýchání.',
          onTap: onBreathing,
        ),
        const SizedBox(height: AppSpacing.sm),
        _OptionCard(
          icon: Icons.edit_note,
          title: 'Napsat proč',
          subtitle: 'Jedna věta o tom, co tě odvádí.',
          onTap: onReflection,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextButton(
          onPressed: onCancel,
          child: const Text('Vrátit se k práci'),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dýchací cvičení — kruh se nafukuje s nádechem a splaskává s výdechem.
class _BreathingView extends StatelessWidget {
  const _BreathingView({required this.controller, required this.total});

  final AnimationController controller;
  final Duration total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final elapsedMs = (controller.value * total.inMilliseconds).round();
        final remaining = Duration(
          milliseconds: total.inMilliseconds - elapsedMs,
        );

        // Fáze uvnitř jednoho nádechu/výdechu.
        final cycleT =
            (elapsedMs % breathCycle.inMilliseconds) / breathCycle.inMilliseconds;
        final inhaling = cycleT < 0.5;
        final scale = inhaling
            ? 0.55 + 0.45 * (cycleT * 2)
            : 1.0 - 0.45 * ((cycleT - 0.5) * 2);

        return Column(
          children: [
            const Spacer(),
            SizedBox(
              height: 240,
              width: 240,
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.shallow,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              inhaling ? 'Nádech' : 'Výdech',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${remaining.inSeconds + 1} s',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: controller.value,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ],
        );
      },
    );
  }
}

/// Reflexe — jedna věta o tom, proč chce uživatel skončit.
class _ReflectionView extends StatelessWidget {
  const _ReflectionView({
    required this.controller,
    required this.minLength,
    required this.onDone,
  });

  final TextEditingController controller;
  final int minLength;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final length = controller.text.trim().length;
    final ready = length >= minLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Co tě teď odvádí?', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Napiš jednu větu. Nikdo jiný ji neuvidí — je jen pro tebe, '
          'ať víš, co se opakuje.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'např. nemůžu se soustředit, pořád myslím na…',
            helperText: ready
                ? 'Díky.'
                : 'Ještě ${minLength - length} znaků',
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: ready ? onDone : null,
            child: const Text('Pokračovat'),
          ),
        ),
      ],
    );
  }
}

/// Rozhodnutí po zpomalení. Obě možnosti jsou dostupné — žádné další překážky.
class _DecisionView extends StatelessWidget {
  const _DecisionView({
    required this.goalText,
    required this.onResume,
    required this.onEnd,
  });

  final String goalText;
  final VoidCallback onResume;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Spacer(),
        const Icon(Icons.anchor, size: 56, color: AppColors.anchor),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Jak dál?',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          goalText.trim().isEmpty
              ? 'Rozhodnutí je na tobě. Obě možnosti jsou v pořádku.'
              : 'Zbývá ti „$goalText“. Rozhodnutí je na tobě — '
                  'obě možnosti jsou v pořádku.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onResume,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Vrátit se k práci'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onEnd,
            child: const Text('Ukončit blok'),
          ),
        ),
      ],
    );
  }
}
