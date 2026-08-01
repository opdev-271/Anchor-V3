import '../../../core/storage/enums.dart';

/// Pravidla zpomalení při předčasném ukončení bloku (docs/spec.md §5.5).
///
/// Zadání uvádí 30 sekund; to je hodnota pro střední přísnost. Mírná zpomaluje
/// méně, přísná víc — editor profilu u přísné úrovně slibuje "delší zpomalení
/// při ukončení", takže se to musí opravdu projevit.
///
/// Horní hranice je záměrně nízká. Delší čekání by nezvyšovalo šanci, že se
/// uživatel vrátí k práci — jen by rostla frustrace a s ní pravděpodobnost, že
/// appku odinstaluje. Cílem je přerušit impulz, ne trestat.
Duration breathingDuration(StrictnessLevel strictness) => switch (strictness) {
      StrictnessLevel.mild => const Duration(seconds: 15),
      StrictnessLevel.medium => const Duration(seconds: 30),
      StrictnessLevel.strict => const Duration(seconds: 45),
    };

/// Minimální délka reflexe v znacích.
///
/// Nemá to být esej — jedna věta stačí. Limit existuje jen proto, aby "a" nebo
/// mezerník nebyly platnou odpovědí; samotné psaní je tím zpomalením.
int minReflectionLength(StrictnessLevel strictness) => switch (strictness) {
      StrictnessLevel.mild => 10,
      StrictnessLevel.medium => 20,
      StrictnessLevel.strict => 30,
    };

/// Délka jednoho nádechu/výdechu v dýchacím cvičení.
///
/// 4 s nádech + 4 s výdech je pomalejší než klidové dýchání, což je záměr —
/// prodloužený výdech tlumí aktivaci sympatiku.
const breathCycle = Duration(seconds: 8);
