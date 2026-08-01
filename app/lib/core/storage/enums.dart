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
