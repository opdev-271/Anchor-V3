import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/database.dart';
import '../../focus_session/application/focus_providers.dart';
import '../data/blocking_channel.dart';

final blockingChannelProvider = Provider<BlockingChannel>((ref) {
  return const BlockingChannel();
});

/// Stav oprávnění potřebných pro blokování.
class BlockingPermissions {
  const BlockingPermissions({
    required this.accessibilityEnabled,
    required this.usageAccessGranted,
  });

  /// Bez tohohle blokace vůbec nefunguje.
  final bool accessibilityEnabled;

  /// Volitelné — jen řadí seznam aplikací podle používání.
  final bool usageAccessGranted;

  bool get canBlock => accessibilityEnabled;
}

/// Oprávnění se čtou při každém probuzení obrazovky — uživatel je uděluje
/// v systémovém nastavení, tedy mimo aplikaci, a při návratu musí UI ukazovat
/// aktuální stav.
final blockingPermissionsProvider =
    FutureProvider.autoDispose<BlockingPermissions>((ref) async {
  final channel = ref.watch(blockingChannelProvider);
  final results = await Future.wait([
    channel.isAccessibilityServiceEnabled(),
    channel.hasUsageAccess(),
  ]);
  return BlockingPermissions(
    accessibilityEnabled: results[0],
    usageAccessGranted: results[1],
  );
});

final installedAppsProvider =
    FutureProvider.autoDispose<List<InstalledApp>>((ref) {
  return ref.watch(blockingChannelProvider).getInstalledApps();
});

/// Seznamy blokovaných aplikací.
final blockedListsProvider = StreamProvider<List<BlockedAppList>>((ref) {
  return ref.watch(databaseProvider).watchBlockedLists();
});

final appsInListProvider =
    StreamProvider.autoDispose.family<List<BlockedApp>, int>((ref, listId) {
  return ref.watch(databaseProvider).watchAppsInList(listId);
});

/// Seznamy přiřazené konkrétnímu profilu.
final listsForProfileProvider =
    StreamProvider.autoDispose.family<List<BlockedAppList>, int>((ref, id) {
  return ref.watch(databaseProvider).watchListsForProfile(id);
});

/// Drží blokaci v souladu se stavem session.
///
/// Je to jediné místo, kde se blokace zapíná a vypíná — schválně ne v UI
/// u tlačítka "Začít fokus". Session totiž může skončit i cestami, které
/// žádné tlačítko nemají: doběhnutím času, dorovnáním po restartu aplikace
/// nebo přerušením z jiné obrazovky. Odběr stavu pokryje všechny naráz.
///
/// `fireImmediately` řeší start aplikace nad rozběhnutou session — po restartu
/// telefonu je nativní stav prázdný a blokaci je potřeba nastavit znovu.
final blockingSyncProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<FocusSession?>>(
    activeSessionProvider,
    (previous, next) {
      final session = next.valueOrNull;
      final controller = ref.read(blockingControllerProvider);
      if (session != null) {
        controller.startFor(session);
      } else {
        controller.stop();
      }
    },
    fireImmediately: true,
  );
});

/// Spouští a zastavuje blokaci podle stavu session.
final blockingControllerProvider = Provider<BlockingController>((ref) {
  return BlockingController(
    ref.watch(databaseProvider),
    ref.watch(blockingChannelProvider),
  );
});

class BlockingController {
  BlockingController(this._db, this._channel);

  final AppDatabase _db;
  final BlockingChannel _channel;

  /// Zapne blokaci pro danou session.
  ///
  /// Když profil nemá přiřazený žádný seznam, blokaci nezapíná — session
  /// proběhne "jen" jako časovaný blok. Je to legitimní režim, ne chyba
  /// (docs/spec.md §8: funkce musí být volitelná).
  Future<void> startFor(FocusSession session) async {
    final packages = await _db.blockedPackagesForProfile(session.profileId);
    if (packages.isEmpty) return;

    final endsAt = session.startedAt
        .add(Duration(minutes: session.plannedDurationMinutes));
    await _channel.startBlocking(
      packages: packages,
      goalText: session.goalText,
      endsAt: endsAt,
    );
    debugPrint('Kotva: blokace zapnuta pro ${packages.length} aplikací');
  }

  Future<void> stop() => _channel.stopBlocking();
}
