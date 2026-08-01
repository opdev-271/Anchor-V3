import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/czech_plural.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../application/stats_providers.dart';
import '../domain/focus_stats.dart';

/// Statistiky fokus session (docs/spec.md §5.6).
///
/// Záměrně tu **není** žádná „úspěšnost" ani „míra selhání" a nikde se
/// nepoužívá červená — §11 to zakazuje. Přerušený blok je zobrazený jako
/// kratší blok, ne jako prohra, a tvrzení typu „nejlíp ti vychází…" se
/// objeví, teprve když je pod nimi dost dat.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final range = ref.watch(statsRangeProvider);
    final sessionsAsync = ref.watch(statsSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiky')),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text('Statistiky se nepodařilo načíst: $e'),
          ),
        ),
        data: (sessions) {
          final summary = summarize(sessions, days: range.days);
          if (summary.totalCount == 0) {
            return const _EmptyStats();
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SegmentedButton<StatsRange>(
                segments: [
                  for (final r in StatsRange.values)
                    ButtonSegment(value: r, label: Text(r.label)),
                ],
                selected: {range},
                onSelectionChanged: (s) =>
                    ref.read(statsRangeProvider.notifier).state = s.first,
              ),
              const SizedBox(height: AppSpacing.lg),

              _SummaryCard(summary: summary),
              const SizedBox(height: AppSpacing.lg),

              Text('Fokus po dnech', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _FocusChart(
                days: dailyFocus(sessions, days: range.days),
              ),
              const SizedBox(height: AppSpacing.lg),

              _Insights(sessions: sessions),
              const SizedBox(height: AppSpacing.lg),

              const _Reflections(),
            ],
          );
        },
      ),
    );
  }
}

String formatFocus(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  if (h == 0) return '$m min';
  return m == 0 ? '$h h' : '$h h $m min';
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final FocusSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Odpracovaný čas',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              formatFocus(summary.totalFocus),
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            _Row(
              label: 'Dokončené bloky',
              value: '${summary.completedCount}',
            ),
            _Row(
              // Ne „přerušené" jako selhání — jen konstatování délky.
              label: 'Kratší bloky',
              value: '${summary.interruptedCount}',
            ),
            _Row(
              label: 'Dnů s prací',
              value: '${summary.activeDays}',
            ),
            _Row(
              label: 'Průměr na den s prací',
              value: formatFocus(summary.averagePerActiveDay),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sloupcový graf odpracovaného času. Jednobarevný — odstupňování barvou
/// podle „hodně/málo" by bylo hodnocení, které §11 vylučuje.
class _FocusChart extends StatelessWidget {
  const _FocusChart({required this.days});

  final List<DailyFocus> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxMinutes = days
        .map((d) => d.focus.inMinutes)
        .fold<int>(1, (a, b) => a > b ? a : b);

    // U měsíce se popisky nevejdou; graf pak nese jen tvar.
    final showLabels = days.length <= 7;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final day in days)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showLabels)
                        Text(
                          day.focus.inMinutes == 0
                              ? ''
                              : '${day.focus.inMinutes}',
                          style: theme.textTheme.labelSmall,
                        ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        height: 90 *
                            (day.focus.inMinutes / maxMinutes)
                                .clamp(0.02, 1.0),
                        margin: EdgeInsets.symmetric(
                          horizontal: showLabels ? 4 : 1,
                        ),
                        decoration: BoxDecoration(
                          color: day.focus.inMinutes == 0
                              ? theme.colorScheme.surfaceContainerHighest
                              : theme.colorScheme.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppSpacing.xs),
                          ),
                        ),
                      ),
                      if (showLabels) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          weekdayName(day.day.weekday).substring(0, 2),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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

/// „Nejlíp ti vychází…" — jen tvrzení, pod kterými je dost dat.
class _Insights extends StatelessWidget {
  const _Insights({required this.sessions});

  final List<FocusSession> sessions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final weekday = bestWeekday(sessions);
    final timeOfDay = bestTimeOfDay(sessions);
    final duration = bestDuration(sessions);
    final dropOff = typicalDropOff(sessions);

    final items = <String>[
      if (weekday != null)
        'Nejspolehlivěji ti bloky vycházejí '
            '${weekdayNameIn(weekday.value)}.',
      if (timeOfDay != null)
        'Nejlíp ti to jde ${timeOfDay.value.label}.',
      if (duration != null)
        'Nejčastěji ti vydrží blok na ${duration.value} minut.',
      if (dropOff != null)
        'Když blok končíš dřív, bývá to zhruba po '
            '${dropOff.inMinutes} minutách. Zkusit kratší blok?',
    ];

    if (items.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Co ti vychází', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Na závěry je zatím málo dat. Kotva ti je ukáže, až bude mít '
                'aspoň ${czechCount(minSamplesForClaim, one: 'blok', few: 'bloky', many: 'bloků')} '
                've stejný den, čas nebo délku.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Co ti vychází', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(item, style: theme.textTheme.bodyMedium),
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

/// Vlastní poznámky uživatele z Friction Exit.
class _Reflections extends ConsumerWidget {
  const _Reflections();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reflections = ref.watch(reflectionsProvider).valueOrNull ?? const [];
    if (reflections.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Co tě odvádělo', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tvoje vlastní poznámky. Zůstávají jen v telefonu.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final r in reflections.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        r.reflectionText ?? '',
                        style: theme.textTheme.bodyMedium,
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

class _EmptyStats extends StatelessWidget {
  const _EmptyStats();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insights, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Zatím není co ukázat',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Až dokončíš pár bloků, najdeš tu, kdy ti fokus drží nejlíp.',
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
