import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/enums.dart';
import '../../focus_session/application/focus_providers.dart';
import '../application/anchor_providers.dart';
import '../data/anchor_channel.dart';

/// Průvodce přidáním kotvy: nejdřív volba typu, pak vlastní spárování.
class AnchorPairingSheet extends ConsumerStatefulWidget {
  const AnchorPairingSheet({super.key});

  @override
  ConsumerState<AnchorPairingSheet> createState() => _AnchorPairingSheetState();
}

class _AnchorPairingSheetState extends ConsumerState<AnchorPairingSheet> {
  AnchorType? _type;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, controller) => switch (_type) {
        null => _TypeChooser(
            onPick: (t) => setState(() => _type = t),
            controller: controller,
          ),
        AnchorType.ble => _BlePairing(controller: controller),
        AnchorType.nfc => _NfcPairing(controller: controller),
      },
    );
  }
}

class _TypeChooser extends ConsumerWidget {
  const _TypeChooser({required this.onPick, required this.controller});

  final ValueChanged<AnchorType> onPick;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ble = ref.watch(bleStatusProvider).valueOrNull;
    final nfc = ref.watch(nfcAvailableProvider).valueOrNull ?? false;

    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Jaká kotva?', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.lg),
        for (final type in AnchorType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Card(
              child: ListTile(
                leading: Icon(
                  type == AnchorType.ble ? Icons.bluetooth : Icons.nfc,
                ),
                title: Text(type.label),
                subtitle: Text(type.description),
                trailing: const Icon(Icons.chevron_right),
                // Nedostupný typ nezakazujeme potichu — obrazovka za ním
                // uživateli vysvětlí, co chybí a jak to zapnout.
                onTap: () => onPick(type),
              ),
            ),
          ),
        if (ble != null && !ble.supported)
          Text(
            'Tenhle telefon Bluetooth maják nepodporuje.',
            style: theme.textTheme.bodySmall,
          ),
        if (!nfc)
          Text(
            'NFC je vypnuté nebo ho telefon nemá.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// Spárování Bluetooth majáku — sken okolí a výběr ze seznamu.
class _BlePairing extends ConsumerStatefulWidget {
  const _BlePairing({required this.controller});

  final ScrollController controller;

  @override
  ConsumerState<_BlePairing> createState() => _BlePairingState();
}

class _BlePairingState extends ConsumerState<_BlePairing> {
  List<BleDevice> _devices = const [];
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    unawaited(_scan());
  }

  /// Zjistí stav Bluetooth, případně si řekne o oprávnění, a proskenuje okolí.
  ///
  /// Po **každém** `await` se kontroluje [mounted]. Není to opatrnost navíc:
  /// uživatel může sheet zavřít kdykoliv — a čeká se tu na systémový dialog
  /// o oprávnění, který nemá žádný časový strop. Sáhnout pak na `setState`
  /// nebo `ref` znamená pracovat s widgetem, který už neexistuje, což Flutter
  /// ohlásí jako `_lifecycleState != defunct` a shodí to celý snímek.
  Future<void> _scan() async {
    final channel = ref.read(anchorChannelProvider);
    final status = await channel.bleStatus();
    if (!mounted) return;

    if (!status.permitted) {
      await channel.requestBlePermission();
      if (!mounted) return;
      ref.invalidate(bleStatusProvider);
      return;
    }
    if (!status.ready) return;

    setState(() => _scanning = true);
    final devices = await channel.scanOnce();
    if (!mounted) return;

    setState(() {
      _devices = devices;
      _scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = ref.watch(bleStatusProvider).valueOrNull;

    if (status != null && !status.ready) {
      return _Blocked(
        controller: widget.controller,
        title: !status.supported
            ? 'Bluetooth tu není'
            : !status.enabled
                ? 'Zapni Bluetooth'
                : 'Kotva potřebuje svolení',
        body: !status.supported
            ? 'Tenhle telefon Bluetooth majáky nepodporuje. Zkus NFC štítek.'
            : !status.enabled
                ? 'Bez zapnutého Bluetooth maják nenajdeme.'
                : 'Kotva hledá jen tvůj maják. Polohu z toho neodvozuje '
                    'a nikam nic neposílá.',
        actionLabel: status.supported && !status.permitted ? 'Povolit' : null,
        onAction: () async {
          await ref.read(anchorChannelProvider).requestBlePermission();
          // Sheet mohl mezitím zmizet — viz poznámka u [_scan].
          if (!mounted) return;
          ref.invalidate(bleStatusProvider);
        },
      );
    }

    return ListView(
      controller: widget.controller,
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Vyber maják', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Polož telefon vedle majáku — nahoře bude ten s nejsilnějším '
          'signálem.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (_scanning)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_devices.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Text(
              'Nic v dosahu. Maják musí vysílat — štítek probuď nebo dej '
              'sluchátka do párovacího režimu.',
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          for (final device in _devices)
            ListTile(
              leading: const Icon(Icons.bluetooth),
              title: Text(device.displayName),
              subtitle: Text('signál ${device.rssi} dBm'),
              contentPadding: EdgeInsets.zero,
              onTap: () => _confirm(device),
            ),

        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: _scanning ? null : _scan,
          icon: const Icon(Icons.refresh),
          label: const Text('Hledat znovu'),
        ),
      ],
    );
  }

  Future<void> _confirm(BleDevice device) async {
    final name = await _promptForName(context, initial: device.displayName);
    if (name == null || name.isEmpty || !mounted) return;

    // `ref` se drží widgetu, takže i tenhle zápis musí být za kontrolou výše.
    await ref.read(databaseProvider).createAnchor(
          type: AnchorType.ble,
          tagIdentifier: device.address,
          name: name,
        );
    if (mounted) Navigator.of(context).pop();
  }
}

/// Spárování NFC štítku — uživatel ho přiloží k telefonu.
class _NfcPairing extends ConsumerStatefulWidget {
  const _NfcPairing({required this.controller});

  final ScrollController controller;

  @override
  ConsumerState<_NfcPairing> createState() => _NfcPairingState();
}

class _NfcPairingState extends ConsumerState<_NfcPairing> {
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    final channel = ref.read(anchorChannelProvider);
    unawaited(channel.startNfcReader());
    _subscription = channel.nfcTags.listen(_onTag);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    unawaited(ref.read(anchorChannelProvider).stopNfcReader());
    super.dispose();
  }

  Future<void> _onTag(String id) async {
    final name = await _promptForName(context, initial: 'Pracovní stůl');
    if (name == null || name.isEmpty || !mounted) return;

    await ref.read(databaseProvider).createAnchor(
          type: AnchorType.nfc,
          tagIdentifier: id,
          name: name,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = ref.watch(nfcAvailableProvider).valueOrNull ?? false;

    if (!available) {
      return _Blocked(
        controller: widget.controller,
        title: 'NFC není k dispozici',
        body: 'Zapni NFC v nastavení telefonu, nebo použij Bluetooth maják.',
      );
    }

    return ListView(
      controller: widget.controller,
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.xl),
        const Center(child: Icon(Icons.nfc, size: 64)),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Přilož štítek k telefonu',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Stačí ho podržet u zadní strany. Kotva si zapamatuje jeho '
          'identifikátor, nic víc.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Blocked extends StatelessWidget {
  const _Blocked({
    required this.controller,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final ScrollController controller;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(body, style: theme.textTheme.bodyMedium),
        if (actionLabel != null) ...[
          const SizedBox(height: AppSpacing.lg),
          FilledButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ],
    );
  }
}

Future<String?> _promptForName(BuildContext context, {required String initial}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pojmenuj kotvu'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Název',
          hintText: 'např. Pracovní stůl',
        ),
        onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zrušit'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: const Text('Uložit'),
        ),
      ],
    ),
  );
}
