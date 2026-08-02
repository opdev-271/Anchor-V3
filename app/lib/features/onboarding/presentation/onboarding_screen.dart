import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/enums.dart';
import '../../anchor/presentation/anchors_screen.dart';
import '../../smart_home/presentation/smart_home_screen.dart';
import '../application/onboarding_providers.dart';
import '../domain/onboarding_steps.dart';

/// Uvítací sekvence při prvním spuštění (docs/spec.md §8, §10).
///
/// Splňuje akceptační kritérium §14: „Onboarding jasně vysvětluje všechna
/// požadovaná oprávnění před jejich vyžádáním."
///
/// **Onboarding sám o žádné oprávnění nežádá.** Vysvětlí, co bude potřeba
/// a proč; o svolení si řekne až konkrétní funkce, ve chvíli, kdy ji uživatel
/// otevře a kdy má tedy kontext. Vyžádat všechno dopředu je sice svůdné, ale
/// znamená to nechat uživatele odklikat oprávnění dřív, než ví, k čemu jsou.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _page == onboardingSteps.length - 1;

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// Konec sekvence — ať už uživatel prošel všechny kroky, nebo přeskočil.
  ///
  /// Onboarding se otevírá dvěma cestami a každá končí jinak: při prvním
  /// spuštění je kořenem stromu a zmizí přepnutím příznaku, z nastavení je
  /// přidaný na zásobník a musí se odebrat. Bez téhle větve by druhá cesta
  /// vedla na obrazovku, ze které nejde odejít.
  void _finish() {
    ref.read(onboardingCompletedProvider.notifier).complete();
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
  }

  /// Otevře nastavení té funkce, které se krok týká.
  ///
  /// Cílová obrazovka si sama vyžádá souhlas přes `ConsentRequestScreen` —
  /// onboarding tím nic neobchází, jen zkracuje cestu.
  void _openSetup(OnboardingStep step) {
    final destination = switch (step.consentCategory) {
      ConsentCategory.location => const AnchorsScreen(),
      ConsentCategory.smartHome => const SmartHomeScreen(),
      _ => null,
    };
    if (destination == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Přeskočit je vidět od začátku a na každém kroku. Uvítací
            // sekvence nesmí držet uživatele jako rukojmí (§11).
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                ),
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Přeskočit'),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: onboardingSteps.length,
                itemBuilder: (context, i) => _StepView(
                  step: onboardingSteps[i],
                  onAction: () => _openSetup(onboardingSteps[i]),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _PageDots(count: onboardingSteps.length, current: _page),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(_isLast ? 'Začít' : 'Dál'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Oprávnění po tobě Kotva chtít nebude teď — řekne si o ně '
                    'až u funkce, které se týkají.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepView extends StatelessWidget {
  const _StepView({required this.step, required this.onAction});

  final OnboardingStep step;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(step.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Text(step.body, style: theme.textTheme.bodyLarge),

          if (step.permissions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            for (final permission in step.permissions) ...[
              _PermissionRow(permission: permission),
              const SizedBox(height: AppSpacing.md),
            ],
          ],

          if (step.limitations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Co je dobré vědět', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            for (final limitation in step.limitations)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('— ', style: theme.textTheme.bodySmall),
                    Expanded(
                      child: Text(
                        limitation,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],

          if (step.actionLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onAction,
              child: Text(step.actionLabel!),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.permission});

  final PermissionExplanation permission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          permission.optional ? Icons.check_circle_outline : Icons.key_outlined,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permission.optional
                    ? '${permission.name} — volitelné'
                    : permission.name,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(permission.why, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      // Tečky jsou čistě vizuální. Odečítač by z nich jinak přečetl jen
      // řadu prázdných tvarů.
      label: 'Krok ${current + 1} z $count',
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Container(
              width: i == current ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: i == current
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
