import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../focus_session/application/focus_providers.dart';
import '../application/blocking_providers.dart';
import 'app_picker_screen.dart';
import 'blocking_permission_card.dart';

/// Správa blokovacích seznamů ("Sociální sítě", "Zprávy", "Hry")
/// dle docs/spec.md §5.2.
class BlockedListsScreen extends ConsumerWidget {
  const BlockedListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lists = ref.watch(blockedListsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Blokované aplikace')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createList(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nový seznam'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          96,
        ),
        children: [
          const BlockingPermissionCard(),
          const SizedBox(height: AppSpacing.lg),
          Text('Seznamy', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          lists.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Seznamy se nepodařilo načíst: $e'),
            data: (items) {
              if (items.isEmpty) return const _EmptyLists();
              return Column(
                children: [
                  for (final list in items) ...[
                    _ListCard(list: list),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createList(BuildContext context, WidgetRef ref) async {
    final name = await _promptForName(context);
    if (name == null || name.isEmpty) return;
    final id = await ref.read(databaseProvider).createBlockedList(name);
    if (!context.mounted) return;
    // Prázdný seznam je k ničemu — rovnou nabídneme výběr aplikací.
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AppPickerScreen(listId: id, listName: name),
      ),
    );
  }
}

Future<String?> _promptForName(BuildContext context, {String initial = ''}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(initial.isEmpty ? 'Nový seznam' : 'Přejmenovat seznam'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Název',
          hintText: 'např. Sociální sítě',
        ),
        onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zrušit'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(controller.text.trim()),
          child: const Text('Uložit'),
        ),
      ],
    ),
  );
}

class _ListCard extends ConsumerWidget {
  const _ListCard({required this.list});

  final BlockedAppList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final apps = ref.watch(appsInListProvider(list.id)).valueOrNull ?? const [];

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                AppPickerScreen(listId: list.id, listName: list.name),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      apps.isEmpty
                          ? 'Zatím prázdný — vyber aplikace'
                          : apps.map((a) => a.appLabel).join(', '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (action) async {
                  final db = ref.read(databaseProvider);
                  if (action == 'rename') {
                    final name =
                        await _promptForName(context, initial: list.name);
                    if (name != null && name.isNotEmpty) {
                      await db.renameBlockedList(list.id, name);
                    }
                  } else if (action == 'delete') {
                    await db.deleteBlockedList(list.id);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'rename', child: Text('Přejmenovat')),
                  PopupMenuItem(value: 'delete', child: Text('Smazat')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLists extends StatelessWidget {
  const _EmptyLists();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.block, size: 36),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Zatím žádný seznam',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Vytvoř si seznam, třeba "Sociální sítě", a přiřaď ho fokus '
              'profilu. Jeden seznam můžeš použít ve víc profilech.',
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
