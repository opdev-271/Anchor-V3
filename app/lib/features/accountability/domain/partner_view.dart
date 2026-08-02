import '../../../core/czech_plural.dart';
import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';

/// Co smí accountability parťák vidět (docs/spec.md §5.4 a §9).
///
/// Zadání to formuluje jednoznačně: parťák vidí **jen to, jestli session
/// probíhá nebo proběhla — nikdy obsah práce**. Konkrétně nesmí vidět cíl
/// bloku ani seznam blokovaných aplikací.
///
/// Proto tenhle soubor existuje jako samostatná vrstva: veškerý text, který
/// kdy opustí telefon směrem k parťákovi, vzniká **tady** a nikde jinde.
/// Kdyby se to skládalo přímo v UI, dřív nebo později by tam někdo přidal
/// `session.goalText`, protože „to přece dává smysl" — a tiše by tím porušil §9.
/// Hlídají to testy.
enum PartnerStatus {
  /// Právě pracuje.
  working,

  /// Blok doběhl celý.
  finished,

  /// Blok skončil dřív. Záměrně se **nejmenuje** `failed` — parťák nemá
  /// dostat podklad k tomu, aby uživatele káral (§11).
  endedEarly;

  String get label => switch (this) {
        PartnerStatus.working => 'pracuje',
        PartnerStatus.finished => 'dokončil/a blok',
        PartnerStatus.endedEarly => 'skončil/a dřív',
      };
}

/// Jediné, co se o session dostane ven.
///
/// Všimni si, co tu **není**: cíl bloku, název profilu, blokované aplikace,
/// reflexe z Friction Exit. Nic z toho parťákovi nepatří.
class PartnerUpdate {
  const PartnerUpdate({required this.status, required this.workedMinutes});

  final PartnerStatus status;

  /// Odpracované minuty. Délka není obsah práce — je to právě ta „binární"
  /// informace navíc, která dává accountability smysl, aniž by prozradila,
  /// na čem uživatel dělá.
  final int workedMinutes;
}

/// Sestaví, co smí parťák vědět o dané session.
PartnerUpdate partnerUpdateFor(FocusSession session, {DateTime? now}) {
  final end = session.endedAt ?? now ?? DateTime.now();
  final worked = end.difference(session.startedAt);
  final minutes = worked.isNegative ? 0 : worked.inMinutes;

  return PartnerUpdate(
    status: switch (session.status) {
      SessionStatus.active => PartnerStatus.working,
      SessionStatus.completed => PartnerStatus.finished,
      SessionStatus.interrupted => PartnerStatus.endedEarly,
    },
    workedMinutes: minutes,
  );
}

/// Znění zprávy pro parťáka.
///
/// Tón drží §11: ani u předčasně ukončeného bloku se uživatel neshazuje.
/// Zadání v §5.4 nabízí jako příklad „zase jsem to nedodělal/a"; takovou
/// formulaci aplikace **nepoužívá** — sebeobviňování v šabloně by odporovalo
/// zásadě, že appka uživatele nezahanbuje. Zpráva konstatuje fakt.
String composePartnerMessage(PartnerUpdate update, {String? senderName}) {
  final who = (senderName == null || senderName.trim().isEmpty)
      ? 'Kotva'
      : senderName.trim();

  // Skloňování přes czechCount — „1 minut práce" by působilo nedbale.
  final minutes = czechCount(
    update.workedMinutes,
    one: 'minuta',
    few: 'minuty',
    many: 'minut',
  );

  final body = switch (update.status) {
    PartnerStatus.working =>
      'Právě mám fokus blok. Ozvu se, až doběhne.',
    PartnerStatus.finished => 'Fokus blok hotový — $minutes práce.',
    PartnerStatus.endedEarly =>
      'Fokus blok jsem ukončil/a dřív. $minutes práce se ale počítá.',
  };

  return '$body\n\n— posláno z aplikace $who';
}
