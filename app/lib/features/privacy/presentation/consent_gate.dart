import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/screen_body.dart';
import '../../../core/storage/enums.dart';
import '../application/privacy_providers.dart';
import '../domain/consent.dart';

/// Obrazovka, která se ukáže místo funkce, dokud pro ni není souhlas
/// (docs/spec.md §8 a §9).
///
/// Používá se jako **předčasný návrat** z `build` té které obrazovky:
///
/// ```dart
/// if (!ref.watch(consentGrantedProvider(ConsentCategory.usageStats))) {
///   return const ConsentRequestScreen(
///     title: 'Čas na obrazovce',
///     category: ConsentCategory.usageStats,
///   );
/// }
/// ```
///
/// Proč samostatná obrazovka a ne obal kolem obsahu: předčasný návrat zaručí,
/// že se bez souhlasu **nepostaví** ani zbytek stromu — tedy ani plovoucí
/// tlačítko, ani providery, které by si samy sáhly pro data. Obal by obsah
/// schoval, ale postavit by ho nechal.
///
/// Texty i důsledky odvolání žijí v `domain/consent.dart`, aby se obrazovka
/// souhlasů a tahle nemohly rozejít.
class ConsentRequestScreen extends ConsumerWidget {
  const ConsentRequestScreen({
    super.key,
    required this.title,
    required this.category,
  });

  /// Titulek v hlavičce — stejný, jaký má zastoupená obrazovka, aby uživatel
  /// poznal, kam přišel.
  final String title;

  final ConsentCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: ScreenBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lock_outline,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Nejdřív tvoje svolení', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(category.purpose, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                category.dataFlow,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // „Zapnout a povolit", ne „Souhlasím" — uživatel má vědět, že tím
              // něco zapíná, ne že odklepává podmínky.
              FilledButton(
                onPressed: () =>
                    ref.read(privacyControllerProvider).grant(category),
                child: const Text('Zapnout a povolit'),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Vypnout to můžeš kdykoliv v Nastavení → Soukromí a data.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
