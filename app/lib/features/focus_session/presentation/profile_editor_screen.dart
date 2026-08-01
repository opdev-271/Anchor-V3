import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/czech_plural.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../blocking/presentation/profile_lists_picker.dart';
import '../application/focus_providers.dart';

/// Nastavení fokus profilu (docs/spec.md §10 → "Nastavení fokus profilu").
///
/// Sprint 1 pokrývá délku, cíl a úroveň přísnosti. Výběr blokovaných aplikací
/// a chytrého zařízení přibude ve Sprintu 2 resp. 6 — proto jsou tu zatím
/// pojmenované jako plánované, ne skryté.
class ProfileEditorScreen extends ConsumerStatefulWidget {
  const ProfileEditorScreen({super.key, this.profile});

  final FocusProfile? profile;

  bool get isEditing => profile != null;

  @override
  ConsumerState<ProfileEditorScreen> createState() =>
      _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends ConsumerState<ProfileEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _goalController;
  late double _duration;
  late StrictnessLevel _strictness;

  /// Vybrané blokovací seznamy. U nového profilu se ukládají až spolu s ním.
  List<int> _selectedListIds = const [];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p?.name ?? '');
    _goalController = TextEditingController(text: p?.goalText ?? '');
    _duration = (p?.durationMinutes ?? 50).toDouble();
    _strictness = p?.strictness ?? StrictnessLevel.medium;

    if (p != null) {
      ref.read(databaseProvider).listIdsForProfile(p.id).then((ids) {
        if (mounted) setState(() => _selectedListIds = ids);
      });
    }
  }

  Future<void> _pickLists() async {
    final result = await Navigator.of(context).push<List<int>>(
      MaterialPageRoute(
        builder: (_) => ProfileListsPicker(initialSelection: _selectedListIds),
      ),
    );
    if (result != null && mounted) {
      setState(() => _selectedListIds = result);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Upravit profil' : 'Nový fokus profil'),
        actions: [
          if (widget.isEditing)
            IconButton(
              tooltip: 'Smazat profil',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Název profilu',
                hintText: 'např. Hluboká práce',
              ),
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Zadej název profilu.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            TextFormField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Cíl bloku',
                hintText: 'např. dokončit kapitolu 3',
                helperText: 'Nepovinné. Uvidíš ho po celou dobu bloku.',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Délka bloku', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    // Rozsah 15–180 min dle docs/spec.md §5.1.
                    value: _duration,
                    min: 15,
                    max: 180,
                    divisions: 33, // po 5 minutách
                    label: '${_duration.round()} min',
                    onChanged: (v) => setState(() => _duration = v),
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    '${_duration.round()} min',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Text('Úroveň přísnosti', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            RadioGroup<StrictnessLevel>(
              groupValue: _strictness,
              onChanged: (v) => setState(() => _strictness = v!),
              child: Column(
                children: [
                  for (final level in StrictnessLevel.values)
                    RadioListTile<StrictnessLevel>(
                      value: level,
                      title: Text(level.label),
                      subtitle: Text(level.description),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Blokované aplikace', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: ListTile(
                leading: const Icon(Icons.block),
                title: Text(
                  _selectedListIds.isEmpty
                      ? 'Žádný seznam'
                      : czechCount(
                          _selectedListIds.length,
                          one: 'seznam',
                          few: 'seznamy',
                          many: 'seznamů',
                        ),
                ),
                subtitle: const Text(
                  'Během bloku se vybrané aplikace překryjí připomínkou cíle.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickLists,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Poctivě pojmenované, co ještě není hotové — místo prázdné sekce.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chystá se', style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Propojení s chytrou zásuvkou a kotevním bodem zatím '
                      'není hotové — přibude v další verzi.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            FilledButton(
              onPressed: _save,
              child: Text(widget.isEditing ? 'Uložit změny' : 'Vytvořit profil'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final db = ref.read(databaseProvider);
    final name = _nameController.text.trim();
    final goal = _goalController.text.trim();

    final int profileId;
    if (widget.isEditing) {
      profileId = widget.profile!.id;
      await db.updateProfile(
        id: profileId,
        name: name,
        durationMinutes: _duration.round(),
        goalText: goal,
        strictness: _strictness,
      );
    } else {
      profileId = await db.createProfile(
        name: name,
        durationMinutes: _duration.round(),
        goalText: goal,
        strictness: _strictness,
      );
    }
    await db.setListsForProfile(profileId, _selectedListIds);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Smazat profil?'),
        content: const Text(
          'Historie dokončených bloků z tohoto profilu se smaže také.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Smazat'),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;
    await ref.read(databaseProvider).deleteProfile(widget.profile!.id);
    if (mounted) Navigator.of(context).pop();
  }
}
