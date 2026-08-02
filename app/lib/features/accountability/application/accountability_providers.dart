import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/database.dart';
import '../../focus_session/application/focus_providers.dart';
import '../data/share_channel.dart';
import '../domain/partner_view.dart';

final shareChannelProvider = Provider<ShareChannel>((ref) {
  return const ShareChannel();
});

final partnersProvider = StreamProvider<List<AccountabilityPartner>>((ref) {
  return ref.watch(databaseProvider).watchPartners();
});

final accountabilityControllerProvider =
    Provider<AccountabilityController>((ref) {
  return AccountabilityController(ref);
});

class AccountabilityController {
  AccountabilityController(this._ref);

  final Ref _ref;

  Future<void> addPartner({required String name, String? contact}) {
    return _ref.read(databaseProvider).addPartner(
          name: name,
          contact: (contact == null || contact.trim().isEmpty)
              ? null
              : contact.trim(),
        );
  }

  Future<void> removePartner(int id) =>
      _ref.read(databaseProvider).deletePartner(id);

  /// True, pokud má aplikace po skončení bloku nabídnout odeslání zprávy.
  Future<bool> shouldOfferUpdate(FocusSession session) async {
    final db = _ref.read(databaseProvider);
    final profile = await db.findProfile(session.profileId);
    if (profile?.notifyPartner != true) return false;
    return (await db.allPartners()).isNotEmpty;
  }

  /// Připraví zprávu a předá ji systémovému výběru aplikací.
  ///
  /// Text vzniká výhradně v [composePartnerMessage], takže se ven nedostane
  /// nic nad rámec toho, co §9 povoluje.
  Future<void> shareUpdate(FocusSession session) async {
    final message = composePartnerMessage(partnerUpdateFor(session));
    await _ref
        .read(shareChannelProvider)
        .shareText(message, title: 'Dát vědět parťákovi');
  }
}
