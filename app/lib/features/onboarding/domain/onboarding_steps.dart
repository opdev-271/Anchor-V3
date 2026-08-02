import '../../../core/storage/enums.dart';

/// Jeden krok onboardingu.
///
/// Obsah je čistá data, ne widgety — jde tak otestovat, že onboarding opravdu
/// vysvětluje všechno, co [spec §8] vyžaduje, a že u každého oprávnění stojí
/// vysvětlení **dřív** než tlačítko.
class OnboardingStep {
  const OnboardingStep({
    required this.title,
    required this.body,
    this.permissions = const [],
    this.limitations = const [],
    this.consentCategory,
    this.actionLabel,
  });

  final String title;

  /// Hlavní odstavec. Vysvětluje, k čemu krok je.
  final String body;

  /// Oprávnění probíraná v tomhle kroku. Prázdné u kroků, které si o nic
  /// neříkají.
  final List<PermissionExplanation> permissions;

  /// Co aplikace **neumí**. Zadání (§8) chce omezení popsat v onboardingu,
  /// ne až po instalaci — uživatel se to nemá dozvědět tak, že mu funkce
  /// nebude fungovat.
  final List<String> limitations;

  /// Kategorie souhlasu, které se krok týká. Onboarding souhlas **neuděluje** —
  /// jen vysvětluje; o svolení si řekne až funkce sama (viz `consent_gate.dart`).
  final ConsentCategory? consentCategory;

  /// Nepovinná nabídka rovnou danou věc nastavit. Cíl si podle
  /// [consentCategory] vybere obrazovka — doména o navigaci neví.
  ///
  /// Je to **nabídka**, ne krok, který je potřeba splnit: [spec §10] chce
  /// v onboardingu „výběr první kotvy", ale kotva je volitelná funkce (§8),
  /// takže projít dál musí jít i bez ní.
  final String? actionLabel;
}

/// Vysvětlení jednoho oprávnění — proč ho appka chce a co za něj uživatel
/// dostane.
class PermissionExplanation {
  const PermissionExplanation({
    required this.name,
    required this.why,
    required this.optional,
  });

  final String name;
  final String why;

  /// Volitelné oprávnění musí být poznat. Bez tohohle rozlišení by uživatel
  /// odklikával všechno stejně a nevěděl, co si může odpustit.
  final bool optional;
}

/// Kroky onboardingu v pořadí, v jakém je uživatel uvidí.
///
/// Skladba vychází z [spec §10] („vysvětlení proč potřebujeme Usage Stats,
/// ukázka Real World Lock, výběr první kotvy") a z [spec §8] (vysvětlit
/// omezení v onboardingu).
///
/// Onboarding **nic nevyžaduje**. Vysvětluje a nabízí; každý krok jde přejít
/// dál a celý onboarding jde přeskočit. Aplikace, která má respektovat
/// autonomii uživatele (§11), ho nesmí držet v uvítací sekvenci jako rukojmí.
const onboardingSteps = <OnboardingStep>[
  OnboardingStep(
    title: 'Kotva ti podrží pozornost',
    body: 'Nastavíš si blok — jak dlouhý a na čem chceš pracovat. Kotva po tu '
        'dobu ztíží cestu k tomu, co tě obvykle strhne. Neuhlídá tě násilím: '
        'skončit můžeš vždycky, jen ne omylem a bez rozmyslu.',
    limitations: [
      'Kotva tě nehodnotí. Kratší blok není selhání a nikde se ti to '
          'nepřipomene.',
    ],
  ),
  OnboardingStep(
    title: 'Co Kotva potřebuje a proč',
    body: 'Tohle jsou oprávnění, o která si Kotva časem řekne. Uděluješ je '
        'ručně v nastavení telefonu — Kotva si je vzít nemůže, jen tě navede '
        'na správné místo.',
    permissions: [
      PermissionExplanation(
        name: 'Služba přístupnosti',
        why: 'Jediný způsob, jak běžná aplikace pozná, která appka je právě '
            'v popředí. Kotva díky ní ví, že jsi otevřel/a něco blokovaného. '
            'Vidí název aplikace — nečte obsah obrazovky a nikam ho neposílá.',
        optional: false,
      ),
      PermissionExplanation(
        name: 'Přístup k údajům o používání',
        why: 'Kolik času trávíš v jednotlivých aplikacích. Z toho Kotva staví '
            'přehled času na obrazovce a hlídá denní limity.',
        optional: true,
      ),
      PermissionExplanation(
        name: 'Přístup k oznámením',
        why: 'Po vyčerpání denního limitu schová notifikace té aplikace, aby '
            'tě netahaly zpátky.',
        optional: true,
      ),
    ],
    limitations: [
      'Kotva cizí aplikaci nedokáže vypnout. Místo toho ji překryje a nabídne '
          'návrat na plochu.',
      'Jednotlivé weby blokovat neumí — musela by číst obsah prohlížeče, což '
          'dělat nechce. Zablokovat jde celý prohlížeč.',
      'Na iPhonu bude blokování fungovat jinak a slaběji. Apple ho pouští jen '
          'přes svůj Screen Time a čtení cizích aplikací zakazuje úplně.',
    ],
    consentCategory: ConsentCategory.usageStats,
  ),
  OnboardingStep(
    title: 'Fokus i mimo telefon',
    body: 'Rozptýlení nebývá jen v mobilu. Kotva umí sáhnout i do pokoje: '
        'chytrou zásuvkou vypnout televizi po dobu bloku a podle majáku '
        'u stolu poznat, že jsi od práce odešel/odešla.',
    limitations: [
      'Obojí je dobrovolné. Bez zásuvky i bez majáku funguje zbytek aplikace '
          'úplně stejně.',
      'Zásuvku Kotva po skončení bloku vrátí do stavu, v jakém byla předtím — '
          'když byla televize vypnutá už před blokem, nezapne ji.',
    ],
    consentCategory: ConsentCategory.smartHome,
  ),
  OnboardingStep(
    title: 'Kotevní bod u stolu',
    body: 'Kotva je místo, u kterého chceš pracovat. Bluetooth maják na stole '
        'umí průběžně poznat, jestli jsi poblíž. NFC štítek slouží spíš jako '
        'rituál — přiložíš telefon a blok začne.',
    limitations: [
      'NFC neumí hlídat přítomnost průběžně. Android ho na pozadí nečte, takže '
          'odchod od stolu tímhle způsobem poznat nejde.',
      'Kotva neurčuje tvou polohu. Vidí jen to, jestli je konkrétní maják '
          'na dosah.',
    ],
    consentCategory: ConsentCategory.location,
    actionLabel: 'Nastavit kotvu teď',
  ),
];
