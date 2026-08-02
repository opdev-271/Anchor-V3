import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../focus_session/application/focus_providers.dart';
import '../../privacy/application/privacy_providers.dart';
import '../../privacy/presentation/consent_gate.dart';
import '../application/smart_home_providers.dart';
import '../data/kasa_client.dart';

/// Chytrá domácnost — propojení účtu a výběr zásuvek (docs/spec.md §5.3).
class SmartHomeScreen extends ConsumerWidget {
  const SmartHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Přihlášení k účtu poskytovatele je jediné místo, kde Kotva komunikuje
    // ven — bez souhlasu se nesmí nabídnout ani ono (docs/spec.md §9).
    if (!ref.watch(consentGrantedProvider(ConsentCategory.smartHome))) {
      return const ConsentRequestScreen(
        title: 'Chytrá zásuvka',
        category: ConsentCategory.smartHome,
      );
    }

    final theme = Theme.of(context);
    final token = ref.watch(kasaTokenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chytrá zásuvka'),
        actions: [
          if (token.valueOrNull != null)
            IconButton(
              tooltip: 'Odpojit účet',
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(kasaTokenProvider.notifier).signOut(),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Během fokus bloku může Kotva vypnout zásuvku, do které je '
            'zapojená televize nebo konzole. Po skončení ji vrátí do stavu, '
            'v jakém byla předtím.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          token.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _SignInCard(error: '$e'),
            data: (value) =>
                value == null ? const _SignInCard() : const _DeviceList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          const _Limitations(),
        ],
      ),
    );
  }
}

/// Přihlášení k účtu Kasa.
class _SignInCard extends ConsumerStatefulWidget {
  const _SignInCard({this.error});

  final String? error;

  @override
  ConsumerState<_SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends ConsumerState<_SignInCard> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Propojit účet Kasa', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Přihlašuješ se k TP-Link Kasa. Heslo se použije jen jednou '
              'a neukládá se — Kotva si nechá pouze přístupový token.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _username,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Heslo',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),

            if (widget.error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.error!.replaceFirst('KasaException', '').trim(),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            ],

            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _busy ? null : _signIn,
              child: Text(_busy ? 'Přihlašuji…' : 'Propojit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() => _busy = true);
    await ref.read(kasaTokenProvider.notifier).signIn(
          username: _username.text.trim(),
          password: _password.text,
        );
    if (mounted) setState(() => _busy = false);
  }
}

/// Zařízení na účtu s možností ručního přepnutí.
class _DeviceList extends ConsumerWidget {
  const _DeviceList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final devices = ref.watch(kasaDevicesProvider);
    final saved = ref.watch(smartDevicesProvider).valueOrNull ?? const [];

    return devices.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'Zařízení se nepodařilo načíst.\n$e',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Na účtu nejsou žádná zařízení. Přidej zásuvku v aplikaci '
                'Kasa a vrať se sem.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zařízení na účtu', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final device in list)
              _DeviceCard(
                device: device,
                savedDevice: saved
                    .where((s) => s.externalDeviceId == device.deviceId)
                    .firstOrNull,
              ),
          ],
        );
      },
    );
  }
}

class _DeviceCard extends ConsumerWidget {
  const _DeviceCard({required this.device, required this.savedDevice});

  final KasaDevice device;
  final SmartDevice? savedDevice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSaved = savedDevice != null;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.power,
                  color: device.online
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.alias, style: theme.textTheme.titleMedium),
                      Text(
                        device.online
                            ? device.model
                            : '${device.model} · offline',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: isSaved
                      ? OutlinedButton(
                          onPressed: () => ref
                              .read(databaseProvider)
                              .deleteSmartDevice(savedDevice!.id),
                          child: const Text('Odebrat'),
                        )
                      : FilledButton(
                          onPressed: () => ref
                              .read(smartHomeControllerProvider)
                              .saveDevice(device),
                          child: const Text('Používat'),
                        ),
                ),
                if (isSaved) ...[
                  const SizedBox(width: AppSpacing.sm),
                  // Ruční přepnutí, aby si uživatel ověřil spojení hned
                  // a nemusel čekat na fokus blok.
                  IconButton(
                    tooltip: 'Vypnout teď',
                    icon: const Icon(Icons.power_settings_new),
                    onPressed: () => _toggle(context, ref, false),
                  ),
                  IconButton(
                    tooltip: 'Zapnout teď',
                    icon: const Icon(Icons.power),
                    onPressed: () => _toggle(context, ref, true),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool on) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(smartHomeControllerProvider).toggle(savedDevice!, on);
      messenger.showSnackBar(
        SnackBar(content: Text(on ? 'Zapnuto.' : 'Vypnuto.')),
      );
    } on KasaException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

/// Poctivě uvedená omezení (docs/spec.md §8, §15).
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
              'Spínání jde přes cloud TP-Linku, takže vyžaduje internet '
              'na telefonu i u zásuvky.',
            ),
            _Bullet(
              'Když se zásuvku nepodaří přepnout, fokus blok běží dál. '
              'Kotva kvůli zásuvce blok nikdy nezruší.',
            ),
            _Bullet(
              'Zásuvka vypne napájení. U televize to znamená tvrdé vypnutí — '
              'nezapojuj tak nic, čemu by to mohlo uškodit.',
            ),
            _Bullet(
              'Zatím je podporovaná jen Kasa. Google Home, SmartThings '
              'a Matter vyžadují partnerskou registraci a přibudou později.',
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
