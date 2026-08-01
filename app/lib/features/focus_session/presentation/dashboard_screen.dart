import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/czech_plural.dart';
import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../app_limits/application/app_limits_providers.dart';
import '../../blocking/application/blocking_providers.dart';
import '../../screen_time/presentation/screen_time_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../application/focus_providers.dart';
import '../domain/session_progress.dart';
import 'profile_editor_screen.dart';
import 'session_screen.dart';
import 'start_ritual_screen.dart';

/// Dashboard (docs/spec.md §10) — rychlý přehled a start session.
///
/// Klíčové prvky dle zadání: velké tlačítko "Začít fokus", aktuální streak,
/// dnešní progres.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Session mohla doběhnout, zatímco aplikace neběžela.
      ref.read(sessionControllerProvider).reconcile();
      // Nativní vrstva mohla přijít o svůj stav (vyčištění dat, přeinstalace);
      // databáze je tu zdrojem pravdy, tak ji propíšeme zpět.
      ref.read(appLimitsControllerProvider).syncToNative();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(sessionControllerProvider).reconcile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Udržuje blokaci v souladu se stavem session po celou dobu, co appka běží.
    ref.watch(blockingSyncProvider);

    final profilesAsync = ref.watch(profilesProvider);
    final activeSession = ref.watch(activeSessionProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kotva'),
        titleTextStyle: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            tooltip: 'Čas na obrazovce',
            icon: const Icon(Icons.timelapse),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ScreenTimeScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Nastavení',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Nový profil'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            96, // místo pod FAB
          ),
          children: [
            const _TodayCard(),
            const SizedBox(height: AppSpacing.lg),

            if (activeSession != null) ...[
              _ResumeBanner(
                session: activeSession,
                onResume: () => _openSession(activeSession.id),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            Text('Fokus profily', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            profilesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Profily se nepodařilo načíst: $e'),
              data: (profiles) {
                if (profiles.isEmpty) return const _EmptyProfiles();
                return Column(
                  children: [
                    for (final p in profiles) ...[
                      _ProfileCard(
                        profile: p,
                        blocked: activeSession != null,
                        onStart: () => _startSession(p),
                        onEdit: () => _openEditor(profile: p),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor({FocusProfile? profile}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileEditorScreen(profile: profile),
      ),
    );
  }

  /// Spuštění bloku: založit session → rituál začátku → obrazovka průběhu.
  Future<void> _startSession(FocusProfile profile) async {
    final id = await ref.read(sessionControllerProvider).start(profile);
    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ritualContext) => StartRitualScreen(
          goalText: profile.goalText,
          onComplete: () {
            // Rituál nahradíme obrazovkou průběhu, aby se nedalo "zpět"
            // vrátit do animace.
            Navigator.of(ritualContext).pushReplacement(
              MaterialPageRoute(builder: (_) => SessionScreen(sessionId: id)),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openSession(int id) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SessionScreen(sessionId: id)),
    );
  }
}

/// Dnešní progres a streak.
class _TodayCard extends ConsumerWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final today = ref.watch(focusedTodayProvider);

    // Jediná plocha v aplikaci s výraznou barvou — nese hlavní čísla a dělá
    // z přehledu zřetelné centrum, místo aby všechny karty vypadaly stejně.
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _Metric(
              label: 'Dnes odpracováno',
              value: formatDuration(today),
              icon: Icons.timelapse,
            ),
          ),
          Container(
            width: 1,
            height: 52,
            color: Colors.white.withValues(alpha: 0.2),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          ),
          Expanded(
            child: _Metric(
              label: czechPlural(
                streak,
                one: 'den v řadě',
                few: 'dny v řadě',
                many: 'dní v řadě',
              ),
              value: '$streak',
              icon: Icons.anchor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.7)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

/// Nabídne návrat do rozdělané session (např. po restartu aplikace).
class _ResumeBanner extends StatelessWidget {
  const _ResumeBanner({required this.session, required this.onResume});

  final FocusSession session;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppColors.anchor,
      child: InkWell(
        onTap: onResume,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.play_circle_fill, color: Colors.white),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blok právě běží',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    if (session.goalText.trim().isNotEmpty)
                      Text(
                        session.goalText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.blocked,
    required this.onStart,
    required this.onEdit,
  });

  final FocusProfile profile;

  /// True, když už jiný blok běží — start je pak nedostupný.
  final bool blocked;
  final VoidCallback onStart;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.durationMinutes} min · '
                        '${profile.strictness.label.toLowerCase()} přísnost',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Upravit',
                  icon: const Icon(Icons.tune),
                  onPressed: onEdit,
                ),
              ],
            ),
            if (profile.goalText.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(profile.goalText, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: blocked ? null : onStart,
                icon: const Icon(Icons.anchor),
                label: Text(blocked ? 'Jiný blok už běží' : 'Začít fokus'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProfiles extends StatelessWidget {
  const _EmptyProfiles();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.anchor, size: 40, color: AppColors.anchor),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Zatím tu není žádný profil',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Vytvoř si první fokus profil — stačí délka bloku a to, '
              'co chceš stihnout.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
