import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/enums.dart';
import '../application/app_limits_providers.dart';

/// Nastavení jednoho denního limitu — kolik minut a jak přísně ho vynucovat.
class LimitEditorSheet extends ConsumerStatefulWidget {
  const LimitEditorSheet({
    super.key,
    required this.packageName,
    required this.appLabel,
    this.initialMinutes,
    this.initialIntensity,
  });

  final String packageName;
  final String appLabel;
  final int? initialMinutes;
  final LimitIntensity? initialIntensity;

  @override
  ConsumerState<LimitEditorSheet> createState() => _LimitEditorSheetState();
}

class _LimitEditorSheetState extends ConsumerState<LimitEditorSheet> {
  late double _minutes = (widget.initialMinutes ?? 15).toDouble();
  late LimitIntensity _intensity =
      widget.initialIntensity ?? LimitIntensity.ask;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(widget.appLabel, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),

          Text('Kolik minut denně', style: theme.textTheme.titleMedium),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _minutes,
                  min: 5,
                  max: 240,
                  divisions: 47, // po 5 minutách
                  label: '${_minutes.round()} min',
                  onChanged: (v) => setState(() => _minutes = v),
                ),
              ),
              SizedBox(
                width: 76,
                child: Text(
                  '${_minutes.round()} min',
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          Text('Co se stane po vyčerpání', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          RadioGroup<LimitIntensity>(
            groupValue: _intensity,
            onChanged: (v) => setState(() => _intensity = v!),
            child: Column(
              children: [
                for (final level in LimitIntensity.values)
                  RadioListTile<LimitIntensity>(
                    value: level,
                    title: Text(level.label),
                    subtitle: Text(level.description),
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          FilledButton(
            onPressed: _save,
            child: const Text('Uložit limit'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Limit můžeš kdykoliv změnit nebo zrušit tady v Kotvě. Ani '
            'nejpřísnější varianta ti v tom nebrání — bariéra je pro impulz, '
            'ne pro rozhodnutí.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Uloží limit a zavře sheet.
  ///
  /// Selhání se **musí** dostat na obrazovku. Původně tu žádné odchycení
  /// nebylo a zápis, který spadl na chybu v databázi, se navenek projevil jen
  /// tím, že sheet zůstal otevřený — uživatel netušil, jestli se uložilo, nebo
  /// ne, a změna limitu tiše mizela. Tichý neúspěch je u nastavení, které má
  /// něco vynucovat, horší než hláška.
  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref.read(appLimitsControllerProvider).save(
            packageName: widget.packageName,
            appLabel: widget.appLabel,
            dailyMinutes: _minutes.round(),
            intensity: _intensity,
          );
      navigator.pop();
    } catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Limit se nepodařilo uložit: $e')),
        );
    }
  }
}
