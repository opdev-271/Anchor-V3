import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/czech_plural.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../anchor/application/anchor_providers.dart';
import '../../anchor/presentation/anchors_screen.dart';
import '../../blocking/presentation/profile_lists_picker.dart';
import '../../smart_home/application/smart_home_providers.dart';
import '../../smart_home/presentation/smart_home_screen.dart';
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

  /// Kotva, u které má blok probíhat. `null` = bez kotvy.
  int? _anchorPointId;

  /// Chytrá zásuvka, která se má během bloku vypnout. `null` = žádná.
  int? _smartDeviceId;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p?.name ?? '');
    _goalController = TextEditingController(text: p?.goalText ?? '');
    _duration = (p?.durationMinutes ?? 50).toDouble();
    _strictness = p?.strictness ?? StrictnessLevel.medium;

    _anchorPointId = p?.anchorPointId;
    _smartDeviceId = p?.smartDeviceId;

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

            Text('Kotevní bod', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            _AnchorPicker(
              selectedId: _anchorPointId,
              onChanged: (id) => setState(() => _anchorPointId = id),
            ),
            const SizedBox(height: AppSpacing.md),

            Text('Chytrá zásuvka', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            _SmartDevicePicker(
              selectedId: _smartDeviceId,
              onChanged: (id) => setState(() => _smartDeviceId = id),
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
        anchorPointId: _anchorPointId,
        smartDeviceId: _smartDeviceId,
      );
    } else {
      profileId = await db.createProfile(
        name: name,
        durationMinutes: _duration.round(),
        goalText: goal,
        strictness: _strictness,
        anchorPointId: _anchorPointId,
        smartDeviceId: _smartDeviceId,
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

/// Výběr kotvy pro profil. Volba „bez kotvy" je plnohodnotná — funkce musí
/// být volitelná a bez majáku má aplikace fungovat beze změny (§8).
class _AnchorPicker extends ConsumerWidget {
  const _AnchorPicker({required this.selectedId, required this.onChanged});

  final int? selectedId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anchors = ref.watch(anchorsProvider).valueOrNull ?? const [];

    if (anchors.isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.anchor),
          title: const Text('Zatím žádná kotva'),
          subtitle: const Text('Nastavit můžeš maják nebo NFC štítek.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AnchorsScreen()),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: RadioGroup<int?>(
          groupValue: selectedId,
          onChanged: onChanged,
          child: Column(
            children: [
              const RadioListTile<int?>(
                value: null,
                title: Text('Bez kotvy'),
                subtitle: Text('Blok pohlídá jen čas a cíl.'),
              ),
              for (final anchor in anchors)
                RadioListTile<int?>(
                  value: anchor.id,
                  title: Text(anchor.name),
                  subtitle: Text(
                    anchor.type == AnchorType.ble
                        ? 'Maják — pozná i odchod od stolu'
                        : 'NFC štítek — jen start přiložením',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Výběr chytré zásuvky pro profil. „Žádná" je plnohodnotná volba — bez
/// zařízení musí zbytek aplikace fungovat beze změny (§8).
class _SmartDevicePicker extends ConsumerWidget {
  const _SmartDevicePicker({required this.selectedId, required this.onChanged});

  final int? selectedId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(smartDevicesProvider).valueOrNull ?? const [];

    if (devices.isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.power),
          title: const Text('Žádná zásuvka'),
          subtitle: const Text('Propoj účet Kasa a vyber zařízení.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SmartHomeScreen()),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: RadioGroup<int?>(
          groupValue: selectedId,
          onChanged: onChanged,
          child: Column(
            children: [
              const RadioListTile<int?>(
                value: null,
                title: Text('Žádná'),
                subtitle: Text('Blok se zásuvkou nehýbe.'),
              ),
              for (final device in devices)
                RadioListTile<int?>(
                  value: device.id,
                  title: Text(device.name),
                  subtitle: const Text('Vypne se po dobu bloku'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
