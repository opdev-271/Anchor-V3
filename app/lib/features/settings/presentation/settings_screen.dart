import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../app_limits/presentation/app_limits_screen.dart';
import '../../blocking/presentation/blocked_lists_screen.dart';
import '../../screen_time/presentation/screen_time_screen.dart';
import '../application/settings_providers.dart';

/// Nastavení aplikace (docs/spec.md §10 → „Nastavení appky").
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nastavení')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          _SectionLabel('Vzhled'),
          RadioGroup<ThemeMode>(
            groupValue: mode,
            onChanged: (v) {
              if (v != null) ref.read(themeModeProvider.notifier).set(v);
            },
            child: Column(
              children: [
                for (final option in ThemeMode.values)
                  RadioListTile<ThemeMode>(
                    value: option,
                    secondary: Icon(option.icon),
                    title: Text(option.label),
                    subtitle: Text(option.description),
                  ),
              ],
            ),
          ),
          const Divider(),

          _SectionLabel('Čas na obrazovce'),
          ListTile(
            leading: const Icon(Icons.timelapse),
            title: const Text('Přehled času na obrazovce'),
            subtitle: const Text('Kolik času trávíš v jednotlivých aplikacích'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ScreenTimeScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.hourglass_bottom),
            title: const Text('Denní limity aplikací'),
            subtitle: const Text('Např. jen 15 minut denně na prohlížeč'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AppLimitsScreen()),
            ),
          ),
          const Divider(),

          _SectionLabel('Fokus'),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Blokované aplikace'),
            subtitle: const Text('Seznamy pro fokus profily'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BlockedListsScreen()),
            ),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'Kotva zpracovává údaje o používání aplikací přímo v telefonu '
              'a nikam je neodesílá.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
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
        AppSpacing.md,
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
