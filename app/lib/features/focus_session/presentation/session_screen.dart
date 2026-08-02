import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/progress_ring.dart';
import '../../../core/design_system/screen_body.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../accountability/application/accountability_providers.dart';
import '../../anchor/application/anchor_providers.dart';
import '../../anchor/presentation/return_prompt_sheet.dart';
import '../../friction_exit/presentation/friction_exit_screen.dart';
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
    // Hlídání kotvy se řídí stavem session; stačí ho udržet naživu.
    ref.watch(anchorMonitorProvider);

    // Po návratu ke kotvě se nabídne poznámka pro reflexi (§5.3).
    ref.listen<AnchorEvent?>(openAbsenceProvider, (previous, next) {
      if (next != null) _askAboutAbsence(next);
    });

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

  Future<void> _askAboutAbsence(AnchorEvent absence) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReturnPromptSheet(absence: absence),
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

    return ScreenBody(
      child: Column(
        children: [
          const Spacer(),
          ProgressRing(
            value: progress.fraction,
            semanticLabel: 'Průběh bloku',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatDuration(progress.remaining),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'zbývá',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (session.goalText.trim().isNotEmpty)
            Text(
              session.goalText,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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

  /// Otevře Friction Exit (docs/spec.md §5.5). Ukončení bloku prochází
  /// **výhradně** tudy — jiná cesta ven ze session neexistuje, jinak by
  /// zpomalení šlo obejít (akceptační kritérium §14).
  Future<void> _confirmExit(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.of(context).push<FrictionExitResult>(
      MaterialPageRoute(
        builder: (_) => FrictionExitScreen(
          strictness: session.strictness,
          goalText: session.goalText,
        ),
      ),
    );
    // `null` = uživatel se vrátil k práci ještě před volbou kroku.
    if (result == null) return;

    final db = ref.read(databaseProvider);
    await db.logFrictionExit(
      sessionId: session.id,
      stepType: result.step,
      outcome: result.outcome,
      reflectionText: result.reflectionText,
    );

    if (result.outcome == FrictionOutcome.ended) {
      await ref.read(sessionControllerProvider).interrupt(session);
    }
  }
}

/// Nabídka dát vědět parťákovi (docs/spec.md §5.4).
///
/// Objeví se jen když si to uživatel u profilu zapnul a má aspoň jednoho
/// parťáka. Je to **nabídka**, ne automatické odeslání — zprávu odešle až
/// uživatel ve zvolené aplikaci.
class _PartnerOffer extends ConsumerWidget {
  const _PartnerOffer({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(accountabilityControllerProvider);
    return FutureBuilder<bool>(
      future: controller.shouldOfferUpdate(session),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return TextButton.icon(
          onPressed: () => controller.shareUpdate(session),
          icon: const Icon(Icons.send_outlined),
          label: const Text('Dát vědět parťákovi'),
        );
      },
    );
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

    return ScreenBody(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            completed ? Icons.anchor : Icons.water,
            size: 72,
            // Tmavý režim má vlastní odstín „dokončeno" — ten světlý na něm
            // dá jen 3.01:1, tedy přesně na hraně (viz app_colors.dart).
            color: completed
                ? (theme.brightness == Brightness.dark
                    ? AppColors.completedDark
                    : AppColors.completed)
                : AppColors.interrupted,
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
          const SizedBox(height: AppSpacing.sm),
          _PartnerOffer(session: session),
        ],
      ),
    );
  }
}
