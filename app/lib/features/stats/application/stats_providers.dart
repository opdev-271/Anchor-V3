import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/database.dart';
import '../../focus_session/application/focus_providers.dart';

/// Zvolené období přehledu.
enum StatsRange {
  week(7, 'Týden'),
  month(30, 'Měsíc');

  const StatsRange(this.days, this.label);

  final int days;
  final String label;
}

final statsRangeProvider = StateProvider<StatsRange>((ref) => StatsRange.week);

/// Historie session pro statistiky. Bere 30 dní i pro týdenní pohled —
/// přepnutí období tak nečeká na nový dotaz do databáze.
final statsSessionsProvider = StreamProvider<List<FocusSession>>((ref) {
  final from = DateTime.now().subtract(const Duration(days: 30));
  return ref.watch(databaseProvider).watchSessionsSince(from);
});

final reflectionsProvider = StreamProvider<List<FrictionExitEvent>>((ref) {
  return ref.watch(databaseProvider).watchRecentReflections();
});
