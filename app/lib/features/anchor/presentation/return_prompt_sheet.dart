import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/storage/database.dart';
import '../../focus_session/application/focus_providers.dart';
import '../application/anchor_providers.dart';
import '../domain/anchor_presence.dart';

/// Otázka po návratu ke kotvě (docs/spec.md §5.3).
///
/// Tón je závazný (§11): aplikace se **neptá „proč jsi odešel"**. Nabízí
/// uživateli poznámku pro jeho vlastní reflexi a odpověď je nepovinná —
/// „Přeskočit" je rovnocenná volba, ne únik.
class ReturnPromptSheet extends ConsumerStatefulWidget {
  const ReturnPromptSheet({super.key, required this.absence});

  final AnchorEvent absence;

  @override
  ConsumerState<ReturnPromptSheet> createState() => _ReturnPromptSheetState();
}

class _ReturnPromptSheetState extends ConsumerState<ReturnPromptSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final away = DateTime.now().difference(widget.absence.leftAt);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.anchor, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Vítej zpátky', style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            returnPrompt(away),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: false,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'např. došla mi voda',
              helperText: 'Nepovinné. Zůstává jen v telefonu.',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _save(null),
                  child: const Text('Přeskočit'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: () => _save(_controller.text.trim()),
                  child: const Text('Uložit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save(String? text) async {
    // Notifier se čte **předem**, ne až po zápisu do databáze. Uživatel může
    // sheet zavřít, zatímco zápis běží; `ref` pak patří odstraněnému widgetu
    // a sáhnout na něj skončí chybou. Notifier ale žije v ProviderScope, ne ve
    // widgetu, takže přes await bezpečně přežije — a hlavně: úklid otevřené
    // nepřítomnosti musí proběhnout i tak, jinak by se dotaz objevil znovu.
    final openAbsence = ref.read(openAbsenceProvider.notifier);
    final db = ref.read(databaseProvider);

    await db.recordReturn(
      widget.absence.id,
      reflectionText: (text == null || text.isEmpty) ? null : text,
    );
    openAbsence.state = null;

    if (mounted) Navigator.of(context).pop();
  }
}
