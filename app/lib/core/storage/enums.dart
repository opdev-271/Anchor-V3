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
