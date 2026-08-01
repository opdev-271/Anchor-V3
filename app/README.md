# Kotva — mobilní aplikace

Anti-prokrastinační asistent. Zadání a plán najdeš v [../docs](../docs) —
[spec.md](../docs/spec.md), [architecture.md](../docs/architecture.md),
[roadmap.md](../docs/roadmap.md).

Aktuálně se staví **jen Android** (iOS až bude k dispozici prostředí s Xcode).

## Prostředí

Flutter SDK není v systémových cestách — leží v `~/development/flutter`.
Do každého terminálu, kde chceš pouštět `flutter`:

```bash
export PATH="$HOME/development/flutter/bin:$PATH"
```

Trvale (přidá řádek do `~/.bashrc`):

```bash
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
```

Flutter je nakonfigurovaný na Android SDK v `~/Android/Sdk` a na JDK 21 dodávané
s Android Studiem (`/snap/android-studio/current/jbr`). Platformy mimo Android
jsou vypnuté (`flutter config --no-enable-ios --no-enable-web ...`).

## Spuštění

```bash
~/Android/Sdk/emulator/emulator -avd Pixel_4 -no-boot-anim -gpu swiftshader_indirect &
```

```bash
export PATH="$HOME/development/flutter/bin:$PATH" && cd app && flutter run
```

## Testy a kontrola

```bash
export PATH="$HOME/development/flutter/bin:$PATH" && cd app && flutter test && flutter analyze
```

## Generovaný kód

Databázová vrstva (`drift`) generuje `lib/core/storage/database.g.dart`. Po změně
tabulek v `lib/core/storage/tables.dart` je potřeba přegenerovat:

```bash
export PATH="$HOME/development/flutter/bin:$PATH" && cd app && dart run build_runner build
```

## Paměť

`android/gradle.properties` má heap Gradlu snížený na 2 GB (šablona dává 8 GB),
aby se vedle buildu vešel i emulátor a Android Studio na 16GB stroji. Gradle
daemon lze mezi buildy uspat:

```bash
cd app/android && ./gradlew --stop
```

## Struktura

```
lib/
  core/
    design_system/   motiv, barvy, typografie, rozestupy, ScreenBody, ProgressRing
    storage/         drift databáze, tabulky, enumy
    czech_plural.dart  skloňování číslovek
  features/
    focus_session/
      domain/        odpočet, streak (čistý Dart, pokryto testy)
      application/   Riverpod providery, řízení session
      presentation/  Dashboard, editor profilu, rituál, průběh session
    blocking/
      data/          MethodChannel do nativní vrstvy
      application/   oprávnění, seznamy, synchronizace se session
      presentation/  vysvětlení oprávnění, výběr aplikací, správa seznamů

android/app/src/main/kotlin/cz/kotva/
  BlockingPlugin.kt              MethodChannel, oprávnění, deep-linky
  KotvaAccessibilityService.kt   detekce aplikace v popředí
  ShieldActivity.kt              překryv blokované aplikace
  BlockingState.kt               stav sdílený s Flutterem přes SharedPreferences
  InstalledApps.kt               seznam aplikací + řazení podle používání
```

Limity a omezení blokovací vrstvy popisuje [../docs/blocking-android.md](../docs/blocking-android.md).

## Testování blokace na emulátoru

Službu přístupnosti lze místo proklikávání nastavení zapnout přes adb:

```bash
adb shell settings put secure enabled_accessibility_services cz.kotva/cz.kotva.KotvaAccessibilityService && adb shell settings put secure accessibility_enabled 1
```
