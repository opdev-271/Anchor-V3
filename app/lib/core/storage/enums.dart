/// Úroveň přísnosti fokus profilu (docs/spec.md §5.1).
///
/// Pořadí hodnot je perzistované jako index — **nikdy nepřeskupovat ani nemazat**
/// existující položky bez migrace databáze.
enum StrictnessLevel {
  mild,
  medium,
  strict;

  String get label => switch (this) {
        StrictnessLevel.mild => 'Mírná',
        StrictnessLevel.medium => 'Střední',
        StrictnessLevel.strict => 'Přísná',
      };

  String get description => switch (this) {
        StrictnessLevel.mild => 'Jemné připomenutí, když se ztratíš.',
        StrictnessLevel.medium => 'Blokace rozptýlení, ukončit jde po zamyšlení.',
        StrictnessLevel.strict => 'Silnější bariéra i delší zpomalení při ukončení.',
      };
}

/// Stav fokus session (docs/spec.md §5.1).
///
/// Pořadí hodnot je perzistované jako index — viz poznámka u [StrictnessLevel].
enum SessionStatus {
  /// Právě běží.
  active,

  /// Doběhla do konce naplánované délky.
  completed,

  /// Uživatel ji ukončil dřív. Záměrně se **nejmenuje** `failed` ani `abandoned`
  /// — tón aplikace neobviňuje (docs/spec.md §11).
  interrupted,
}

/// Poskytovatel chytré domácnosti (docs/spec.md §5.3, §7.1).
///
/// Pořadí hodnot je perzistované jako index — **nikdy nepřeskupovat**.
/// Zatím je implementovaný jen [kasa]; ostatní jsou v seznamu proto, aby
/// pozdější doplnění nevyžadovalo migraci.
enum SmartProvider {
  kasa,
  googleHome,
  smartThings,
  matter;

  String get label => switch (this) {
        SmartProvider.kasa => 'TP-Link Kasa',
        SmartProvider.googleHome => 'Google Home',
        SmartProvider.smartThings => 'SmartThings',
        SmartProvider.matter => 'Matter',
      };

  /// Zatím umí Kotva jen Kasa. Ostatní vyžadují OAuth a partnerskou
  /// registraci — viz docs/smart-home.md.
  bool get isImplemented => this == SmartProvider.kasa;
}

/// Typ kotevního bodu (docs/spec.md §5.3).
///
/// Pořadí hodnot je perzistované jako index — **nikdy nepřeskupovat**.
enum AnchorType {
  /// Bluetooth maják. Umí průběžně poznat, jestli je telefon poblíž.
  ble,

  /// NFC štítek. Na rozdíl od BLE **neumí** hlídat přítomnost průběžně —
  /// systém tag přečte jen ve chvíli, kdy k němu uživatel telefon přiloží.
  /// Slouží tedy jako rituál („přiložit a začít"), ne jako čidlo blízkosti.
  nfc;

  String get label => switch (this) {
        AnchorType.ble => 'Bluetooth maják',
        AnchorType.nfc => 'NFC štítek',
      };

  String get description => switch (this) {
        AnchorType.ble =>
          'Kotva průběžně pozná, jestli jsi u stolu, a zaznamená, když odejdeš.',
        AnchorType.nfc =>
          'Přiložením telefonu ke štítku blok začneš. Android neumí NFC číst '
              'na pozadí, takže odchod od stolu tímhle způsobem poznat nejde.',
      };
}

/// Intenzita vynucení denního limitu aplikace (revize Anchor-V1).
///
/// Pořadí hodnot se posílá jako index přes MethodChannel do `AppLimits.kt`
/// a je perzistované — **nikdy nepřeskupovat**.
enum LimitIntensity {
  /// Zeptá se, jestli opravdu prodloužit; povolí 5 minut a pak se zeptá znovu.
  ask,

  /// Prodloužení navíc vyžaduje opsat kód na přeházené klávesnici.
  code,

  /// Bez prodloužení — do konce dne je aplikace zavřená.
  hard;

  String get label => switch (this) {
        LimitIntensity.ask => 'Zeptat se',
        LimitIntensity.code => 'Opsat kód',
        LimitIntensity.hard => 'Bez výjimky',
      };

  String get description => switch (this) {
        LimitIntensity.ask =>
          'Po vyčerpání se Kotva zeptá a případně přidá 5 minut. Pak se zeptá znovu.',
        LimitIntensity.code =>
          'Prodloužení o 5 minut vyžaduje opsat kód na přeházené klávesnici.',
        LimitIntensity.hard =>
          'Žádné prodloužení. Do konce dne aplikace nepůjde použít.',
      };
}

/// Kategorie citlivých dat, pro kterou se uděluje samostatný souhlas
/// (docs/spec.md §9, docs/data-model.md → ConsentRecord).
///
/// Pořadí hodnot je perzistované jako index — **nikdy nepřeskupovat**.
///
/// Kategorie jsou záměrně tři a odpovídají tomu, co appka **skutečně** dělá.
/// Souhlas, který nic neovlivní, je jen zaškrtávátko navíc; každá z těchhle
/// kategorií proto při odvolání odpovídající funkci opravdu zastaví
/// (viz `consent_providers.dart`).
enum ConsentCategory {
  /// Čtení času stráveného v aplikacích — přehled času na obrazovce
  /// a denní limity.
  usageStats,

  /// Blízkost kotevního bodu. Kotva polohu **neurčuje**: sken majáku je
  /// v manifestu označený `neverForLocation`. Kategorie se tak jmenuje kvůli
  /// datovému modelu a kvůli tomu, že Android 11 a starší si na sken bez
  /// polohového oprávnění neposvítí.
  location,

  /// Ovládání chytré zásuvky a přihlášení k účtu poskytovatele.
  smartHome;

  String get label => switch (this) {
        ConsentCategory.usageStats => 'Čas v aplikacích',
        ConsentCategory.location => 'Blízkost kotvy',
        ConsentCategory.smartHome => 'Chytrá domácnost',
      };
}

/// Typ zpomalovacího kroku ve Friction Exit (docs/spec.md §5.5).
///
/// Pořadí hodnot je perzistované jako index — viz poznámka u [StrictnessLevel].
enum FrictionStep {
  /// Dýchací cvičení — nevyžaduje nic vymýšlet, jen počkat a dýchat.
  breathing,

  /// Napsání jedné věty o tom, proč chce uživatel skončit dřív.
  reflection,
}

/// Jak Friction Exit dopadl.
///
/// Pořadí hodnot je perzistované jako index — viz poznámka u [StrictnessLevel].
enum FrictionOutcome {
  /// Uživatel se vrátil k práci.
  resumed,

  /// Uživatel blok ukončil. Tahle možnost je po zpomalení **vždy** dostupná
  /// (docs/spec.md §5.5 a §11 — autonomii uživatele respektujeme).
  ended,
}
