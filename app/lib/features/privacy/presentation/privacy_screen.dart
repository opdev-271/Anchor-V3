import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/enums.dart';
import '../../anchor/application/anchor_providers.dart';
import '../../app_limits/presentation/app_limits_screen.dart'
    show notificationAccessProvider;
import '../../blocking/application/blocking_providers.dart';
import '../../smart_home/application/smart_home_providers.dart';
import '../application/privacy_providers.dart';
import '../domain/consent.dart';


/// Soukromí a data na jednom místě (docs/spec.md §9, §10).
///
/// Obrazovka plní tři akceptační kritéria z §14 naráz: granulární souhlasy,
/// export všech dat jedním tlačítkem a jejich smazání jedním tlačítkem.
/// Je záměrně jedna — kdyby bylo soukromí rozeseté po nastavení, uživatel
/// by nikdy neviděl celkový obrázek.
class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen>
    with WidgetsBindingObserver {
  /// Blokuje tlačítka po dobu exportu nebo mazání, aby uživatel nespustil
  /// obojí naráz.
  bool _busy = false;

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
    // Systémová oprávnění se udělují mimo aplikaci — po návratu je potřeba
    // přečíst je znovu, jinak by přehled ukazoval zastaralý stav.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(blockingPermissionsProvider);
      ref.invalidate(notificationAccessProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final consents = ref.watch(consentStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Soukromí a data')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: Text(
              'Kotva zpracovává data přímo v telefonu. Tady vidíš, k čemu máš '
              'udělený souhlas, co je připojené a jak si data vzít s sebou '
              'nebo smazat.',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          const _SectionLabel('Souhlasy se zpracováním'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'Každou kategorii povoluješ zvlášť a můžeš ji kdykoliv vypnout. '
              'Bez souhlasu se daná funkce nespustí — zbytek aplikace funguje '
              'beze změny.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          for (final category in ConsentCategory.values)
            _ConsentTile(
              category: category,
              granted: consents[category] ?? false,
              onChanged: (value) => _setConsent(category, value),
            ),

          const Divider(height: AppSpacing.xl),

          const _SectionLabel('Oprávnění a připojená zařízení'),
          const _PermissionsOverview(),

          const Divider(height: AppSpacing.xl),

          const _SectionLabel('Tvoje data'),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Exportovat všechna data'),
            subtitle: const Text(
              'Vytvoří soubor JSON se vším, co o tobě Kotva ví, a nabídne '
              'ho k uložení nebo odeslání.',
            ),
            enabled: !_busy,
            onTap: _busy ? null : _export,
          ),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              // Červená je v Kotvě vyhrazená destruktivním akcím, ne chování
              // uživatele (docs/spec.md §11). Tohle je přesně ten případ.
              color: _busy ? null : theme.colorScheme.error,
            ),
            title: Text(
              'Smazat všechna data',
              style: TextStyle(
                color: _busy ? null : theme.colorScheme.error,
              ),
            ),
            subtitle: const Text(
              'Nevratně smaže profily, historii bloků, kotvy, limity '
              'i připojené účty.',
            ),
            enabled: !_busy,
            onTap: _busy ? null : _confirmDelete,
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: _GoodToKnow(),
          ),
        ],
      ),
    );
  }

  Future<void> _setConsent(ConsentCategory category, bool value) async {
    final controller = ref.read(privacyControllerProvider);
    if (value) {
      await controller.grant(category);
      return;
    }

    // Odvolání něco vypne, a uživatel má vědět co, **než** to potvrdí.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vypnout „${category.label}"?'),
        content: Text(category.consequenceOfRevoking),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Nechat zapnuté'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Vypnout'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await controller.revoke(category);
    if (!mounted) return;
    _toast('Souhlas jsi odvolal/a. Funkce je vypnutá.');
  }

  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      await ref.read(privacyControllerProvider).exportEverything();
      if (!mounted) return;
      _toast('Export je hotový — vyber, kam ho uložit.');
    } catch (e) {
      if (!mounted) return;
      // Poctivě říct, že to nevyšlo. Tichý neúspěch u exportu je horší než
      // chybová hláška — uživatel by si myslel, že data má.
      _toast('Export se nepovedl: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDelete() async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Smazat všechna data?'),
        content: const Text(
          'Smažou se fokus profily, historie bloků a zamyšlení, seznamy '
          'blokovaných aplikací, kotevní body, denní limity, parťáci '
          'i propojení s chytrou zásuvkou.\n\n'
          'Nastavení vzhledu zůstane. Zpět to vzít nejde — pokud si chceš '
          'data nechat, nejdřív je vyexportuj.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Zpět'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Smazat všechno'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(privacyControllerProvider).deleteEverything();
      if (!mounted) return;
      _toast('Hotovo. Kotva o tobě nemá žádná data.');
    } catch (e) {
      if (!mounted) return;
      _toast('Mazání se nepovedlo: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Jedna kategorie souhlasu i s vysvětlením, proč ji Kotva chce.
///
/// Vysvětlení je vidět **vždycky**, ne až po rozkliknutí: §8 chce, aby uživatel
/// věděl, k čemu souhlas dává, ještě než ho udělí.
class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    required this.category,
    required this.granted,
    required this.onChanged,
  });

  final ConsentCategory category;
  final bool granted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category.label,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  Switch(value: granted, onChanged: onChanged),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(category.purpose, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      category.dataFlow,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Co je udělené a co je připojené — na jednom místě, jak chce §10.
class _PermissionsOverview extends ConsumerWidget {
  const _PermissionsOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(blockingPermissionsProvider).valueOrNull;
    final notificationAccess =
        ref.watch(notificationAccessProvider).valueOrNull ?? false;
    final anchors = ref.watch(anchorsProvider).valueOrNull ?? const [];
    final devices = ref.watch(smartDevicesProvider).valueOrNull ?? const [];
    final channel = ref.read(blockingChannelProvider);

    return Column(
      children: [
        _StatusTile(
          icon: Icons.accessibility_new,
          title: 'Služba přístupnosti',
          subtitle: 'Umožňuje blokovat aplikace během fokus bloku.',
          granted: permissions?.accessibilityEnabled ?? false,
          onTap: channel.openAccessibilitySettings,
        ),
        _StatusTile(
          icon: Icons.bar_chart,
          title: 'Přístup k údajům o používání',
          subtitle: 'Potřebný pro čas na obrazovce a denní limity.',
          granted: permissions?.usageAccessGranted ?? false,
          onTap: channel.openUsageAccessSettings,
        ),
        _StatusTile(
          icon: Icons.notifications_off_outlined,
          title: 'Přístup k notifikacím',
          subtitle: 'Volitelný — tiší notifikace z aplikací s vyčerpaným limitem.',
          granted: notificationAccess,
          onTap: channel.openNotificationAccessSettings,
        ),
        ListTile(
          leading: const Icon(Icons.anchor),
          title: const Text('Kotevní body'),
          subtitle: Text(
            anchors.isEmpty
                ? 'Žádné'
                : anchors.map((a) => a.name).join(', '),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.power),
          title: const Text('Chytrá zařízení'),
          subtitle: Text(
            devices.isEmpty ? 'Žádná' : devices.map((d) => d.name).join(', '),
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool granted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: granted
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : const Icon(Icons.chevron_right),
      // Udělené oprávnění se odebírá v systémovém nastavení, ne tady —
      // odkaz vede na tutéž obrazovku v obou stavech.
      onTap: onTap,
    );
  }
}

/// Poctivě o tom, co appka neumí (zásada z docs/spec.md §11 — nic se
/// nezamlčuje).
class _GoodToKnow extends StatelessWidget {
  const _GoodToKnow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Co je dobré vědět', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Kotva zatím nemá účet ani zálohu v cloudu, takže se maže jen to, '
          'co je v tomhle telefonu — jinde nic není.\n\n'
          'Smazání se netýká oprávnění udělených v systému. Ta zůstávají '
          'zapnutá, dokud je nevypneš v nastavení telefonu.\n\n'
          'Export je jednorázový soubor. Kotva si po sobě uklidí ten '
          'předchozí, ale kopie, které si někam uložíš, jsou dál na tobě.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
