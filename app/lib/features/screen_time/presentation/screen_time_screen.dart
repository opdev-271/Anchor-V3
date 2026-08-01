import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../blocking/application/blocking_providers.dart';
import '../../blocking/data/blocking_channel.dart';
import '../../blocking/presentation/blocking_permission_card.dart';

final _todayUsageProvider = FutureProvider.autoDispose<List<AppUsage>>((ref) {
  return ref.watch(blockingChannelProvider).getTodayUsage();
});

final _weekTotalsProvider = FutureProvider.autoDispose<List<DailyUsage>>((ref) {
  return ref.watch(blockingChannelProvider).getDailyTotals(days: 7);
});

/// Přehled času stráveného na obrazovce (revize Anchor-V1).
///
/// Čísla pocházejí z `UsageStatsManager`, takže zahrnují i dobu před instalací
/// Kotvy. Bez uděleného oprávnění „Přístup k údajům o používání" systém vrátí
/// prázdno — obrazovka to řekne rovnou a nabídne, kde ho zapnout.
class ScreenTimeScreen extends ConsumerStatefulWidget {
  const ScreenTimeScreen({super.key});

  @override
  ConsumerState<ScreenTimeScreen> createState() => _ScreenTimeScreenState();
}

class _ScreenTimeScreenState extends ConsumerState<ScreenTimeScreen>
    with WidgetsBindingObserver {
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
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(_todayUsageProvider);
      ref.invalidate(_weekTotalsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permissions = ref.watch(blockingPermissionsProvider).valueOrNull;
    final today = ref.watch(_todayUsageProvider);
    final week = ref.watch(_weekTotalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Čas na obrazovce')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_todayUsageProvider);
          ref.invalidate(_weekTotalsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (permissions != null && !permissions.usageAccessGranted) ...[
              const BlockingPermissionCard(),
              const SizedBox(height: AppSpacing.lg),
            ],

            today.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Data se nepodařilo načíst: $e'),
              data: (apps) {
                final total = apps.fold<int>(0, (sum, a) => sum + a.minutes);
                return _TotalCard(minutes: total);
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Posledních 7 dní', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            week.when(
              loading: () => const SizedBox(height: 120),
              error: (e, _) => const SizedBox.shrink(),
              data: (days) => _WeekChart(days: days),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Dnes podle aplikací', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            today.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
              data: (apps) {
                final shown = apps.where((a) => a.minutes > 0).take(15).toList();
                if (shown.isEmpty) return const _NoData();
                final max = shown.first.minutes;
                return Column(
                  children: [
                    for (final app in shown)
                      _AppRow(app: app, maxMinutes: max),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String formatMinutes(int minutes) {
  if (minutes < 60) return '$minutes min';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '$h h' : '$h h $m min';
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              'Dnes na obrazovce',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              formatMinutes(minutes),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Jednoduchý sloupcový graf. Záměrně bez barevného hodnocení „hodně/málo" —
/// aplikace nemá uživatele soudit (docs/spec.md §11), jen mu ukázat čísla.
class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.days});

  final List<DailyUsage> days;

  static const _dayNames = ['po', 'út', 'st', 'čt', 'pá', 'so', 'ne'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (days.isEmpty) return const SizedBox.shrink();
    final max = days.map((d) => d.minutes).fold<int>(1, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final day in days)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatMinutes(day.minutes),
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        height: 80 * (day.minutes / max).clamp(0.02, 1.0),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppSpacing.xs),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _dayNames[day.day.weekday - 1],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({required this.app, required this.maxMinutes});

  final AppUsage app;
  final int maxMinutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  app.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                formatMinutes(app.minutes),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: LinearProgressIndicator(
              value: maxMinutes == 0 ? 0 : app.minutes / maxMinutes,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.query_stats, size: 36),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Zatím žádná data',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Kotva potřebuje přístup k údajům o používání. Bez něj systém '
              'čas na obrazovce neposkytne.',
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
