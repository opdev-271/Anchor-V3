import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';
import '../../focus_session/application/focus_providers.dart';
import '../../privacy/application/privacy_providers.dart';
import '../data/anchor_channel.dart';
import '../domain/anchor_presence.dart';

final anchorChannelProvider = Provider<AnchorChannel>((ref) {
  final channel = AnchorChannel();
  ref.onDispose(channel.dispose);
  return channel;
});

final bleStatusProvider = FutureProvider.autoDispose<BleStatus>((ref) {
  return ref.watch(anchorChannelProvider).bleStatus();
});

final nfcAvailableProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(anchorChannelProvider).nfcAvailable();
});

final anchorsProvider = StreamProvider<List<AnchorPoint>>((ref) {
  return ref.watch(databaseProvider).watchAnchors();
});

/// Nepřítomnosti u kotvy během konkrétní session.
final absencesProvider =
    StreamProvider.autoDispose.family<List<AnchorEvent>, int>((ref, sessionId) {
  return ref.watch(databaseProvider).watchAbsences(sessionId);
});

/// Otevřená nepřítomnost běžící session — podklad pro dotaz při návratu.
final openAbsenceProvider = StateProvider<AnchorEvent?>((ref) => null);

/// Hlídá, jestli je telefon u kotvy, po dobu běžícího fokus bloku.
///
/// Sleduje stav session a sám se spouští a zastavuje. Mimo blok se neskenuje
/// vůbec — hlídat přítomnost, když uživatel nepracuje, nemá smysl a stálo by
/// to baterii (docs/spec.md §13).
final anchorMonitorProvider = Provider<AnchorMonitor>((ref) {
  final monitor = AnchorMonitor(ref);
  ref.onDispose(monitor.dispose);

  ref.listen<AsyncValue<FocusSession?>>(
    activeSessionProvider,
    (previous, next) => monitor.syncWith(next.valueOrNull),
    fireImmediately: true,
  );

  return monitor;
});

class AnchorMonitor {
  AnchorMonitor(this._ref);

  final Ref _ref;

  Timer? _timer;
  int? _sessionId;
  AnchorPoint? _anchor;
  PresenceState _presence = const PresenceState();

  /// Zapne nebo vypne hlídání podle toho, jestli běží blok s přiřazenou kotvou.
  Future<void> syncWith(FocusSession? session) async {
    if (session == null) {
      _stop();
      return;
    }
    if (_sessionId == session.id) return;

    final db = _ref.read(databaseProvider);
    final profile = await db.findProfile(session.profileId);
    final anchorId = profile?.anchorPointId;
    if (anchorId == null) {
      _stop();
      return;
    }

    final anchor = await db.findAnchor(anchorId);
    // NFC kotva umí jen potvrdit „jsem tady" přiložením štítku; hlídat
    // přítomnost průběžně neumí (viz AnchorPlugin.kt).
    if (anchor == null || anchor.type != AnchorType.ble) {
      _stop();
      return;
    }

    _sessionId = session.id;
    _anchor = anchor;
    _presence = const PresenceState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    // První kontrola hned, ať se ví, jestli uživatel u kotvy vůbec je.
    unawaited(_check());
    _timer = Timer.periodic(scanPeriod, (_) => unawaited(_check()));
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    _sessionId = null;
    _anchor = null;
    _presence = const PresenceState();
  }

  Future<void> _check() async {
    final anchor = _anchor;
    final sessionId = _sessionId;
    if (anchor == null || sessionId == null) return;

    // Souhlas se ověřuje před **každým** skenem, ne jen při spuštění hlídání.
    // Uživatel ho může odvolat uprostřed běžícího bloku a od té chvíle se
    // skenovat nesmí (docs/spec.md §9).
    if (!_ref.read(consentGrantedProvider(ConsentCategory.location))) return;

    final devices = await _ref.read(anchorChannelProvider).scanOnce();
    final seen = devices.any((d) => d.address == anchor.tagIdentifier);

    final previous = _presence;
    _presence = updatePresence(previous, seen: seen, now: DateTime.now());

    final db = _ref.read(databaseProvider);
    if (seen) await db.markAnchorSeen(anchor.id);

    // Odchod právě potvrzen — zapsat.
    if (!previous.isAway && _presence.isAway) {
      await db.recordDeparture(
        anchorPointId: anchor.id,
        sessionId: sessionId,
        leftAt: _presence.awaySince!,
      );
      debugPrint('Kotva: odchod od kotvy ${anchor.name}');
      return;
    }

    // Návrat — otevřenou nepřítomnost předáme UI, aby se mohlo zeptat.
    if (previous.isAway && !_presence.isAway) {
      final open = await db.openAbsence(sessionId);
      if (open != null) {
        _ref.read(openAbsenceProvider.notifier).state = open;
      }
    }
  }

  void dispose() => _timer?.cancel();

  /// Rozestup kontrol. Zrcadlí `AnchorScanner.SCAN_PERIOD_MS` na nativní
  /// straně — zadání doporučuje 60–90 s (docs/spec.md §8).
  static const scanPeriod = Duration(seconds: 75);
}
