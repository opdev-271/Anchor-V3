import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../application/blocking_providers.dart';

/// Vysvětlení oprávnění potřebných pro blokaci — a teprve pak tlačítko, které
/// otevře systémové nastavení.
///
/// docs/spec.md §8 to vyžaduje výslovně: uživatel musí vědět, **proč** appka
/// oprávnění chce, ještě než ho o něj požádáme. Obě oprávnění se navíc na
/// Androidu neudělují runtime dialogem, ale ručně v Nastavení — bez deep linku
/// a vysvětlení by uživatel nevěděl, kam jít.
class BlockingPermissionCard extends ConsumerStatefulWidget {
  const BlockingPermissionCard({super.key});

  @override
  ConsumerState<BlockingPermissionCard> createState() =>
      _BlockingPermissionCardState();
}

class _BlockingPermissionCardState
    extends ConsumerState<BlockingPermissionCard> with WidgetsBindingObserver {
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
    // Uživatel uděluje oprávnění mimo aplikaci; po návratu musíme přečíst
    // aktuální stav, jinak by karta tvrdila, že oprávnění pořád chybí.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(blockingPermissionsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permissions = ref.watch(blockingPermissionsProvider);

    return permissions.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (p) {
        final channel = ref.read(blockingChannelProvider);

        return Column(
          children: [
            if (!p.accessibilityEnabled)
              _PermissionTile(
                icon: Icons.accessibility_new,
                title: 'Zapni službu Kotva pro blokaci',
                body: 'Aby Kotva poznala, že jsi otevřel/a blokovanou aplikaci, '
                    'potřebuje zapnout svou službu přístupnosti. Kotva díky ní '
                    'vidí jen název aplikace v popředí — nečte obsah obrazovky '
                    'a nikam ho neposílá.',
                actionLabel: 'Otevřít nastavení přístupnosti',
                onAction: channel.openAccessibilitySettings,
                required: true,
              )
            else
              _GrantedTile(
                text: 'Blokace je připravená.',
              ),
            if (!p.usageAccessGranted) ...[
              const SizedBox(height: AppSpacing.sm),
              _PermissionTile(
                icon: Icons.bar_chart,
                title: 'Volitelné: seřadit aplikace podle používání',
                body: 'S přístupem k údajům o používání ti Kotva v seznamu '
                    'nabídne nahoře ty aplikace, ve kterých trávíš nejvíc času. '
                    'Bez něj se seznam seřadí abecedně — blokace funguje stejně.',
                actionLabel: 'Otevřít nastavení přístupu k údajům',
                onAction: channel.openUsageAccessSettings,
                required: false,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Obě nastavení můžeš kdykoliv vypnout v systémovém nastavení '
              'telefonu.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    required this.required,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: required
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleSmall),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(body, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrantedTile extends StatelessWidget {
  const _GrantedTile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.check_circle, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(text, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
