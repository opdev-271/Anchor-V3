import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/czech_plural.dart';
import '../../../core/design_system/app_spacing.dart';
import '../application/blocking_providers.dart';
import 'blocked_lists_screen.dart';

/// Výběr blokovacích seznamů pro jeden fokus profil (M:N vazba
/// dle docs/data-model.md).
///
/// Vrací vybraná ID seznamů; ukládá je až volající, aby se u nově zakládaného
/// profilu nezapisovalo do databáze dřív, než uživatel profil vůbec uloží.
class ProfileListsPicker extends ConsumerStatefulWidget {
  const ProfileListsPicker({super.key, required this.initialSelection});

  final List<int> initialSelection;

  @override
  ConsumerState<ProfileListsPicker> createState() => _ProfileListsPickerState();
}

class _ProfileListsPickerState extends ConsumerState<ProfileListsPicker> {
  late final Set<int> _selected = widget.initialSelection.toSet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lists = ref.watch(blockedListsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Blokované seznamy')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(_selected.toList()),
            child: const Text('Hotovo'),
          ),
        ),
      ),
      body: lists.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Chyba: $e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Zatím nemáš žádný blokovací seznam',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.tonal(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BlockedListsScreen(),
                        ),
                      ),
                      child: const Text('Vytvořit seznam'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            children: [
              for (final list in items)
                Consumer(
                  builder: (context, ref, _) {
                    final apps =
                        ref.watch(appsInListProvider(list.id)).valueOrNull ??
                            const [];
                    return CheckboxListTile(
                      value: _selected.contains(list.id),
                      onChanged: (v) => setState(() {
                        if (v ?? false) {
                          _selected.add(list.id);
                        } else {
                          _selected.remove(list.id);
                        }
                      }),
                      title: Text(list.name),
                      subtitle: Text(
                        apps.isEmpty
                            ? 'Prázdný seznam'
                            : czechCount(
                                apps.length,
                                one: 'aplikace',
                                few: 'aplikace',
                                many: 'aplikací',
                              ),
                      ),
                    );
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Spravovat seznamy'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BlockedListsScreen(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
