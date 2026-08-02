import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../application/accountability_providers.dart';

/// Správa accountability parťáků (docs/spec.md §5.4).
class PartnersScreen extends ConsumerWidget {
  const PartnersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final partners = ref.watch(partnersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Parťáci')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addPartner(context, ref),
        icon: const Icon(Icons.person_add),
        label: const Text('Přidat parťáka'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          96,
        ),
        children: [
          Text(
            'Parťák je člověk, kterému chceš dát vědět, že pracuješ. '
            'Po skončení bloku ti Kotva nabídne hotovou zprávu — poslat ji '
            'můžeš, ale nemusíš.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          partners.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Parťáky se nepodařilo načíst: $e'),
            data: (items) {
              if (items.isEmpty) return const _EmptyPartners();
              return Column(
                children: [
                  for (final partner in items) ...[
                    _PartnerCard(
                      partner: partner,
                      onDelete: () => ref
                          .read(accountabilityControllerProvider)
                          .removePartner(partner.id),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          const _PrivacyNote(),
          const SizedBox(height: AppSpacing.sm),
          const _NotYet(),
        ],
      ),
    );
  }

  Future<void> _addPartner(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<({String name, String contact})>(
      context: context,
      builder: (context) => const _PartnerDialog(),
    );
    if (result == null || result.name.isEmpty) return;
    await ref.read(accountabilityControllerProvider).addPartner(
          name: result.name,
          contact: result.contact,
        );
  }
}

class _PartnerDialog extends StatefulWidget {
  const _PartnerDialog();

  @override
  State<_PartnerDialog> createState() => _PartnerDialogState();
}

class _PartnerDialogState extends State<_PartnerDialog> {
  final _name = TextEditingController();
  final _contact = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nový parťák'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Jméno',
              hintText: 'např. Standa',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _contact,
            decoration: const InputDecoration(
              labelText: 'Kontakt',
              helperText: 'Nepovinné, jen pro tvoji orientaci.',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zrušit'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            (name: _name.text.trim(), contact: _contact.text.trim()),
          ),
          child: const Text('Přidat'),
        ),
      ],
    );
  }
}

class _PartnerCard extends StatelessWidget {
  const _PartnerCard({required this.partner, required this.onDelete});

  final AccountabilityPartner partner;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                partner.name.characters.first.toUpperCase(),
                style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(partner.name, style: theme.textTheme.titleMedium),
                  if (partner.contact != null)
                    Text(
                      partner.contact!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Odebrat',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Zásada ze §9 vysvětlená uživateli jeho slovy.
class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_outline, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Parťák se dozví jen to, že blok proběhl a jak dlouho trval. '
                'Nikdy nevidí tvůj cíl ani to, které aplikace si blokuješ.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Co ze §5.4 zatím není — pojmenované, ne zamlčené.
class _NotYet extends StatelessWidget {
  const _NotYet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chystá se', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Živý stav „pracuje / nepracuje" u parťáka v telefonu a sdílené '
              'focus rooms potřebují server, který zatím není zapojený. '
              'Do té doby posíláš zprávu ty sám/sama — funguje to i tak, jen '
              'to není automatické.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPartners extends StatelessWidget {
  const _EmptyPartners();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.group_outlined, size: 36),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Zatím žádný parťák',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Bez parťáka funguje všechno ostatní stejně.',
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
