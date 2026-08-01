import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../application/focus_providers.dart';
import '../domain/session_progress.dart';

/// Obrazovka průběhu session (docs/spec.md §10 → "Průběh session").
///
/// Sleduje session podle ID, ne "právě aktivní" — díky tomu zobrazí i okamžik
/// uzavření bloku místo aby zmizela ve chvíli, kdy odpočet doběhne.
class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key, required this.sessionId});

  final int sessionId;

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen>
    with WidgetsBindingObserver {
  bool _completionRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Po návratu z pozadí dorovnat stav — odpočet mohl doběhnout, zatímco byl
    // proces uspaný.
    if (state == AppLifecycleState.resumed) {
      ref.read(sessionControllerProvider).reconcile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(sessionByIdProvider(widget.sessionId));

    return PopScope(
      // Systémové "zpět" nesmí session tiše zahodit; ukončení jde jen přes
      // tlačítko níže (v Sprintu 3 přes Friction Exit).
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: sessionAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Chyba: $e')),
            data: (session) {
              if (session == null) {
                return const Center(child: Text('Session nenalezena.'));
              }
              return switch (session.status) {
                SessionStatus.active => _ActiveView(
                    session: session,
                    onDone: _requestCompletion,
                  ),
                SessionStatus.completed => _ClosingView(
                    session: session,
                    completed: true,
                  ),
                SessionStatus.interrupted => _ClosingView(
                    session: session,
                    completed: false,
                  ),
              };
            },
          ),
        ),
      ),
    );
  }

  void _requestCompletion(FocusSession session) {
    if (_completionRequested) return;
    _completionRequested = true;
    ref.read(sessionControllerProvider).complete(session);
  }
}

class _ActiveView extends ConsumerWidget {
  const _ActiveView({required this.session, required this.onDone});

  final FocusSession session;
  final void Function(FocusSession) onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = ref.watch(tickerProvider).valueOrNull ?? DateTime.now();
    final progress = SessionProgress(session: session, now: now);

    if (progress.isDone) {
      // Zápis do DB nesmí proběhnout uprostřed buildu.
      WidgetsBinding.instance.addPostFrameCallback((_) => onDone(session));
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            width: 260,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress.fraction,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.active),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatDuration(progress.remaining),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w300,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      'zbývá',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (session.goalText.trim().isNotEmpty)
            Text(
              session.goalText,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => _confirmExit(context, ref),
            icon: const Icon(Icons.pause_circle_outline),
            label: const Text('Potřebuji přestávku'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            // §11: uživatel má vždy možnost skončit. Text to říká otevřeně,
            // aby appka nepůsobila jako past.
            'Skončit můžeš kdykoliv.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context, WidgetRef ref) async {
    // Sprint 3 tuto přímou otázku nahradí Friction Exit flow
    // (dech / reflexe) dle docs/spec.md §5.5.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ukončit blok?'),
        content: const Text(
          'Blok se uloží jako přerušený. To je v pořádku — data slouží '
          'jen k tomu, aby ses příště trefil/a lépe.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Pokračovat v práci'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ukončit'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(sessionControllerProvider).interrupt(session);
    }
  }
}

/// Uzavření bloku — dokončeného i přerušeného.
///
/// Tón obou variant je podporující (§11). Přerušený blok **není** označen
/// červenou ani slovem "selhání"; je to jen kratší blok.
class _ClosingView extends StatelessWidget {
  const _ClosingView({required this.session, required this.completed});

  final FocusSession session;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final worked = (session.endedAt ?? DateTime.now())
        .difference(session.startedAt);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            completed ? Icons.anchor : Icons.water,
            size: 72,
            color: completed ? AppColors.completed : AppColors.interrupted,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            completed ? 'Blok dokončen' : 'Blok ukončen dřív',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            completed
                ? 'Odpracoval/a jsi ${formatDuration(worked)}. Pěkná práce.'
                : 'I tak jsi odpracoval/a ${formatDuration(worked)}. '
                    'To se počítá.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zpět na přehled'),
          ),
        ],
      ),
    );
  }
}
