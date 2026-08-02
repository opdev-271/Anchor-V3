import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../blocking/application/blocking_providers.dart';
import '../../blocking/data/blocking_channel.dart';
import '../../privacy/application/privacy_providers.dart';
import '../../privacy/presentation/consent_gate.dart';
import '../application/app_limits_providers.dart';
import 'limit_editor_sheet.dart';

/// Správa denních limitů na aplikace (revize Anchor-V1).
class AppLimitsScreen extends ConsumerStatefulWidget {
  const AppLimitsScreen({super.key});

  @override
  ConsumerState<AppLimitsScreen> createState() => _AppLimitsScreenState();
}

class _AppLimitsScreenState extends ConsumerState<AppLimitsScreen>
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
      ref.invalidate(blockingPermissionsProvider);
      ref.invalidate(notificationAccessProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Limit se bez souhlasu nedá ani založit — vynucování stojí na čtení času
    // stráveného v aplikaci (docs/spec.md §9).
    if (!ref.watch(consentGrantedProvider(ConsentCategory.usageStats))) {
      return const ConsentRequestScreen(
        title: 'Denní limity',
        category: ConsentCategory.usageStats,
      );
    }

    final theme = Theme.of(context);
    final limits = ref.watch(appLimitsProvider);
    final permissions = ref.watch(blockingPermissionsProvider).valueOrNull;
    final notificationAccess =
        ref.watch(notificationAccessProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Denní limity')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addLimit,
        icon: const Icon(Icons.add),
        label: const Text('Přidat limit'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          96,
        ),
        children: [
          if (permissions != null && !permissions.accessibilityEnabled)
            _WarningCard(
              text: 'Limity se bez zapnuté služby Kotva nevynutí. Zapneš ji '
                  'v sekci Blokované aplikace.',
            ),
          if (permissions != null && !permissions.usageAccessGranted)
            _WarningCard(
              text: 'Bez přístupu k údajům o používání Kotva nezjistí, kolik '
                  'času jsi v aplikaci strávil/a, a limit nespustí.',
            ),

          _NotificationAccessCard(granted: notificationAccess),
          const SizedBox(height: AppSpacing.lg),

          limits.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Limity se nepodařilo načíst: $e'),
            data: (items) {
              if (items.isEmpty) return const _EmptyLimits();
              return Column(
                children: [
                  for (final limit in items) ...[
                    _LimitCard(
                      limit: limit,
                      onEdit: () => _editLimit(limit),
                      onDelete: () => ref
                          .read(appLimitsControllerProvider)
                          .remove(limit.packageName),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Limit platí na jeden den a o půlnoci se obnoví. Kotva cizí '
            'aplikaci nedokáže vypnout — místo toho ji překryje a nabídne '
            'návrat na plochu.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addLimit() async {
    final apps = await ref.read(blockingChannelProvider).getInstalledApps();
    if (!mounted) return;

    final selected = await showModalBottomSheet<InstalledApp>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AppChooser(apps: apps),
    );
    if (selected == null || !mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => LimitEditorSheet(
        packageName: selected.packageName,
        appLabel: selected.label,
      ),
    );
  }

  Future<void> _editLimit(AppUsageLimit limit) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => LimitEditorSheet(
        packageName: limit.packageName,
        appLabel: limit.appLabel,
        initialMinutes: limit.dailyMinutes,
        initialIntensity: limit.intensity,
      ),
    );
  }
}

/// Stav oprávnění pro tlumení notifikací.
final notificationAccessProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(blockingChannelProvider).isNotificationAccessGranted();
});

class _NotificationAccessCard extends ConsumerWidget {
  const _NotificationAccessCard({required this.granted});

  final bool granted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (granted) {
      return Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Po vyčerpání limitu Kotva schová i notifikace dané aplikace.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      );
    }

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_off, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Volitelné: schovat i notifikace',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'S přístupem k oznámením Kotva po vyčerpání limitu odstraní '
              'notifikace dané aplikace, aby tě netahaly zpátky. Zvuk '
              'upozornění potlačit nedokáže — ten přehraje systém dřív, než '
              'se o notifikaci dozví.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonal(
                onPressed: ref
                    .read(blockingChannelProvider)
                    .openNotificationAccessSettings,
                child: const Text('Otevřít nastavení oznámení'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}

class _LimitCard extends StatelessWidget {
  const _LimitCard({
    required this.limit,
    required this.onEdit,
    required this.onDelete,
  });

  final AppUsageLimit limit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(limit.appLabel, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${limit.dailyMinutes} min denně · '
                      '${limit.intensity.label.toLowerCase()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Zrušit limit',
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLimits extends StatelessWidget {
  const _EmptyLimits();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.hourglass_empty, size: 36),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Zatím žádný limit',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Nastav si třeba 15 minut denně na prohlížeč. Až je vyčerpáš, '
              'Kotva se ozve.',
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

/// Výběr aplikace, pro kterou se limit zakládá.
class _AppChooser extends StatefulWidget {
  const _AppChooser({required this.apps});

  final List<InstalledApp> apps;

  @override
  State<_AppChooser> createState() => _AppChooserState();
}

class _AppChooserState extends State<_AppChooser> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.apps
        : widget.apps
            .where((a) => a.label.toLowerCase().contains(_query))
            .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Hledat aplikaci',
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final app = filtered[i];
                return ListTile(
                  title: Text(app.label),
                  onTap: () => Navigator.of(context).pop(app),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
