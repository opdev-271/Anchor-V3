import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';

/// Odvození aktuálního stavu souhlasů z jejich historie (docs/spec.md §9).
///
/// Tabulka `ConsentRecords` je přírůstková — jeden řádek na udělení, odvolání
/// do něj doplní `revokedAt`. Kategorie je tedy povolená právě tehdy, když pro
/// ni existuje řádek **bez** `revokedAt`.
///
/// Záměrně se neptáme na „poslední řádek": při shodných časových razítkách
/// (což se stane, když uživatel přepínač rychle přepne tam a zpět) není pořadí
/// definované a odpověď by se náhodně měnila.
bool isConsentGranted(List<ConsentRecord> records, ConsentCategory category) {
  return records
      .any((r) => r.category == category && r.revokedAt == null);
}

/// Stav všech kategorií naráz — pohodlnější pro UI než tři samostatné dotazy.
Map<ConsentCategory, bool> consentState(List<ConsentRecord> records) {
  return {
    for (final category in ConsentCategory.values)
      category: isConsentGranted(records, category),
  };
}

/// Co uživateli o kategorii říct **předtím**, než ho o souhlas požádáme
/// (docs/spec.md §8).
///
/// Texty žijí tady, ne ve widgetu, aby šly otestovat a aby se nedaly omylem
/// rozejít mezi obrazovkou souhlasů a onboardingem.
extension ConsentCopy on ConsentCategory {
  /// K čemu data slouží.
  String get purpose => switch (this) {
        ConsentCategory.usageStats =>
          'Kotva čte, kolik času trávíš v jednotlivých aplikacích. Díky tomu '
              'umí ukázat přehled času na obrazovce a hlídat denní limity.',
        ConsentCategory.location =>
          'Kotva pozná, jestli je telefon u tvého kotevního bodu — majáku nebo '
              'NFC štítku u stolu. Slouží to k tomu, aby si všimla, že jsi '
              'od práce odešel/odešla.',
        ConsentCategory.smartHome =>
          'Kotva se přihlásí k tvému účtu chytré domácnosti a po dobu bloku '
              'vypne zvolenou zásuvku. Po skončení ji vrátí do původního stavu.',
      };

  /// Kam data putují. Odpověď je u všech tří stejná, ale je to ta nejdůležitější
  /// informace na obrazovce, tak ať ji uživatel vidí u každé kategorie zvlášť.
  String get dataFlow => switch (this) {
        ConsentCategory.usageStats =>
          'Zpracovává se v telefonu. Kotva neposílá nikam, které aplikace '
              'používáš.',
        ConsentCategory.location =>
          'Zpracovává se v telefonu. Kotva neurčuje tvou polohu — vidí jen to, '
              'jestli je konkrétní maják na dosah.',
        ConsentCategory.smartHome =>
          'Přihlášení jde na servery poskytovatele zásuvky, protože jinak se '
              'zásuvka ovládat nedá. Kotva mu neposílá nic o tvých blocích '
              'ani cílech.',
      };

  /// Co přestane fungovat po odvolání. Uživatel má vědět, co ztrácí, **než**
  /// souhlas odvolá — ne až se mu funkce tiše rozbije.
  String get consequenceOfRevoking => switch (this) {
        ConsentCategory.usageStats =>
          'Přehled času na obrazovce zmizí a denní limity se přestanou hlídat. '
              'Blokace během fokus bloku funguje dál — ta na tomhle nezávisí.',
        ConsentCategory.location =>
          'Kotva přestane hlídat, jestli jsi u stolu. Fokus bloky běží dál, '
              'jen bez upozornění na odchod.',
        ConsentCategory.smartHome =>
          'Kotva se odhlásí z účtu a zapomene uložená zařízení. Zásuvka '
              'zůstane v tom stavu, v jakém právě je.',
      };
}
