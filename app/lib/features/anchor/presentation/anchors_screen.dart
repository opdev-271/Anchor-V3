import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../focus_session/application/focus_providers.dart';
import '../../privacy/application/privacy_providers.dart';
import '../../privacy/presentation/consent_gate.dart';
import '../application/anchor_providers.dart';
import 'anchor_pairing_sheet.dart';

/// Správa kotevních bodů (docs/spec.md §5.3).
class AnchorsScreen extends ConsumerStatefulWidget {
  const AnchorsScreen({super.key});

  @override
  ConsumerState<AnchorsScreen> createState() => _AnchorsScreenState();
}

class _AnchorsScreenState extends ConsumerState<AnchorsScreen>
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
    // Bluetooth i oprávnění mohl uživatel změnit mimo aplikaci.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(bleStatusProvider);
      ref.invalidate(nfcAvailableProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bez souhlasu se maják neskenuje, takže nemá smysl ani kotvy zakládat
    // (docs/spec.md §9).
    if (!ref.watch(consentGrantedProvider(ConsentCategory.location))) {
      return const ConsentRequestScreen(
        title: 'Kotevní body',
        category: ConsentCategory.location,
      );
    }

    final theme = Theme.of(context);
    final anchors = ref.watch(anchorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kotevní body')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAnchor,
        icon: const Icon(Icons.add),
        label: const Text('Přidat kotvu'),
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
            'Kotva je místo, u kterého chceš pracovat — třeba maják na '
            'pracovním stole. Během bloku si Kotva všimne, když od něj '
            'odejdeš, a při návratu ti nabídne poznámku.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          anchors.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Kotvy se nepodařilo načíst: $e'),
            data: (items) {
              if (items.isEmpty) return const _EmptyAnchors();
              return Column(
                children: [
                  for (final anchor in items) ...[
                    _AnchorCard(
                      anchor: anchor,
                      onDelete: () =>
                          ref.read(databaseProvider).deleteAnchor(anchor.id),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          const _Limitations(),
        ],
      ),
    );
  }

  Future<void> _addAnchor() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AnchorPairingSheet(),
    );
  }
}

class _AnchorCard extends StatelessWidget {
  const _AnchorCard({required this.anchor, required this.onDelete});

  final AnchorPoint anchor;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              anchor.type == AnchorType.ble
                  ? Icons.bluetooth
                  : Icons.nfc,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anchor.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    anchor.type.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Odebrat kotvu',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAnchors extends StatelessWidget {
  const _EmptyAnchors();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.anchor, size: 36),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Zatím žádná kotva',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Bez kotvy funguje všechno ostatní stejně — je to doplněk, '
              'ne podmínka.',
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

/// Poctivě pojmenovaná omezení. Uživatel se je má dozvědět tady, ne až ve
/// chvíli, kdy mu kotva přestane fungovat (docs/spec.md §8).
class _Limitations extends StatelessWidget {
  const _Limitations();

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
            Text('Co je dobré vědět', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            _Bullet(
              'Kotva hledá maják zhruba jednou za minutu a půl, ne souvisle. '
              'Šetří to baterii, ale krátké odskočení nemusí zaznamenat.',
            ),
            _Bullet(
              'Maják musí vysílat — hodí se štítky typu Tile, iBeacon nebo '
              'sluchátka v párovacím režimu.',
            ),
            _Bullet(
              'Některá zařízení kvůli soukromí mění svou adresu. Takový maják '
              'po čase přestane být rozpoznatelný a kotvu je potřeba nastavit '
              'znovu.',
            ),
            _Bullet(
              'NFC štítek umí blok jen odstartovat přiložením. Android neumí '
              'NFC číst na pozadí, takže odchod od stolu jím poznat nejde.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('·  ', style: theme.textTheme.bodyMedium),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
