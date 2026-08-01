import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../focus_session/application/focus_providers.dart';
import '../application/blocking_providers.dart';

/// Výběr aplikací do jednoho blokovacího seznamu (docs/spec.md §5.2).
class AppPickerScreen extends ConsumerStatefulWidget {
  const AppPickerScreen({
    super.key,
    required this.listId,
    required this.listName,
  });

  final int listId;
  final String listName;

  @override
  ConsumerState<AppPickerScreen> createState() => _AppPickerScreenState();
}

class _AppPickerScreenState extends ConsumerState<AppPickerScreen> {
  Set<String>? _selected;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appsAsync = ref.watch(installedAppsProvider);
    final savedAsync = ref.watch(appsInListProvider(widget.listId));

    // Výchozí výběr se převezme z databáze jen jednou; potom už rozhoduje
    // uživatel a stream by mu ho přepisoval pod rukama.
    final saved = savedAsync.valueOrNull;
    if (_selected == null && saved != null) {
      _selected = saved.map((a) => a.packageName).toSet();
    }
    final selected = _selected ?? const <String>{};

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Hledat aplikaci',
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton(
            onPressed: () => _save(selected),
            child: Text('Uložit výběr (${selected.length})'),
          ),
        ),
      ),
      body: appsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text('Seznam aplikací se nepodařilo načíst: $e'),
          ),
        ),
        data: (apps) {
          if (apps.isEmpty) {
            return const _NoApps();
          }
          final filtered = _query.isEmpty
              ? apps
              : apps
                  .where((a) => a.label.toLowerCase().contains(_query))
                  .toList();

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final app = filtered[i];
              final isSelected = selected.contains(app.packageName);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (v) => setState(() {
                  final next = {...selected};
                  if (v ?? false) {
                    next.add(app.packageName);
                  } else {
                    next.remove(app.packageName);
                  }
                  _selected = next;
                }),
                title: Text(app.label),
                subtitle: app.usageMinutes > 0
                    ? Text(
                        _usageLabel(app.usageMinutes),
                        style: theme.textTheme.bodySmall,
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  String _usageLabel(int minutes) {
    if (minutes < 60) return '$minutes min za týden';
    final hours = minutes ~/ 60;
    return '$hours h za týden';
  }

  Future<void> _save(Set<String> selected) async {
    final apps = ref.read(installedAppsProvider).valueOrNull ?? const [];
    final byPackage = {for (final a in apps) a.packageName: a};

    final entries = selected
        .map(
          (pkg) => (
            packageName: pkg,
            label: byPackage[pkg]?.label ?? pkg,
          ),
        )
        .toList();

    await ref
        .read(databaseProvider)
        .replaceAppsInList(widget.listId, entries);
    if (mounted) Navigator.of(context).pop();
  }
}

class _NoApps extends StatelessWidget {
  const _NoApps();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.apps, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Žádné aplikace k zobrazení',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Blokace aplikací zatím funguje jen na Androidu.',
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
