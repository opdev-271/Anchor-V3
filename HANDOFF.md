# Předání: aplikace Kotva (Anchor-V1)

Shrnutí stavu k 4. 8. 2026 pro pokračování v nové konverzaci.
Vlož tenhle soubor (nebo jeho obsah) jako první zprávu.

**Sprintový plán je hotový — sprinty 0–10 proběhly.** Co zbývá, visí na prostředí
(macOS, hardware, backend), ne na kódu. Podrobně v `docs/acceptance.md`.

---

## 1. Co to je

Mobilní anti-prokrastinační aplikace **Kotva** (angl. *Anchor*) podle zadání ve dvou
dokumentech:

- `/home/oliver/op dev/Documents/apps/Antiprokrastinace/prompt_1.docx` — původní zadání,
  přepsané do `docs/spec.md` (sekce §1–§15, na které se všude odkazuji)
- `/home/oliver/op dev/Documents/apps/Kotva/Kotva_V1_co_predelat.docx` — revize V1,
  zapracovaná (viz níže)

**Pracovní adresář:** `/home/oliver/Documents/Antiprokrastinace`

## 2. Prostředí (důležité — není standardní)

| Co | Kde |
|---|---|
| Flutter SDK 3.44.8 | `~/development/flutter` — **není v PATH** |
| Android SDK | `~/Android/Sdk` |
| JDK 21 | `/snap/android-studio/current/jbr` |
| Emulátor | AVD `Pixel_4` (API 31), 2 GB RAM |

Před každým příkazem:

```bash
export PATH="$HOME/development/flutter/bin:$PATH"
export JAVA_HOME="/snap/android-studio/current/jbr"
export ANDROID_HOME="$HOME/Android/Sdk"
```

**Stroj má 16 GB RAM.** Gradle heap je proto v `app/android/gradle.properties` snížený
z šablonových 8 GB na 2 GB. Emulátor spouštět s `-memory 2048`. Emulátor občas spadne —
stačí ho nastartovat znovu, data v něm přežívají.

```bash
~/Android/Sdk/emulator/emulator -avd Pixel_4 -no-snapshot-save -no-boot-anim -gpu swiftshader_indirect -memory 2048 &
```

`adb` **není v PATH**, volat přes `~/Android/Sdk/platform-tools/adb`.

### Past, na kterou se dá naletět

**Přeinstalace aplikace i `am force-stop` vypnou službu přístupnosti.** Android to dělá
schválně. Bez ní neběží blokace ani denní limity a vypadá to jako chyba v appce — jednou
mě to svedlo k závěru, že se rozbilo blokování offline. Před každým testem blokace:

```bash
~/Android/Sdk/platform-tools/adb shell dumpsys accessibility | grep -A1 "Bound services"
```

Zapnutí pro testy (emulátor):

```bash
adb shell settings put secure enabled_accessibility_services cz.kotva/cz.kotva.KotvaAccessibilityService
adb shell settings put secure accessibility_enabled 1
adb shell appops set cz.kotva GET_USAGE_STATS allow   # pro čas na obrazovce a limity
```

### Android Studio

Projekt v něm zatím **nepůjde otevřít smysluplně**: chybí plugin Flutter i Dart (v instalaci
žádný není). Po doinstalaci z Marketplace je potřeba nastavit SDK na
`/home/oliver/development/flutter` a otevřít složku **`app/`**, ne kořen repozitáře — kořenové
`.idea/` popisuje Javový modul a je zastaralé.

## 3. Git

- Remote: `https://github.com/opdev-271/Anchor-V1.git`
- **`origin/main` je pořád na `33856e8`** (Revize Anchor-V1)
- **9 commitů není pushnutých**
- Uživatel pushuje sám (nemám a nesmím mít jeho přihlašovací údaje):

```bash
git -C /home/oliver/Documents/Antiprokrastinace push
```

```
1968062 Oprava: sáhnutí na widget, který už neexistuje
ad5c659 Sprint 10: akceptační průchod §14
fc1bce8 Oprava: změnu denního limitu nešlo uložit
c41ecba Sprint 9: onboarding, přístupnost, spotřeba a offline
d96c6d4 Sprint 8: soukromí — granulární souhlasy, export a smazání dat
9e87ac7 Sprint 7: accountability — parťák a zpráva po bloku
3e03136 Sprint 6: chytrá zásuvka přes TP-Link Kasa
fa79277 Sprint 5: kotevní body (Bluetooth maják a NFC štítek)
0237f22 Sprint 4: statistiky fokus session
33856e8 Revize Anchor-V1: motiv, čas na obrazovce, denní limity, vzhled  ← origin/main
8e2535e Sprint 3: Friction Exit
db16d71 Kotva: sprinty 0-2
```

Netrackované: `HANDOFF.md` (tenhle soubor) a `.idea/`.

## 4. Stack a struktura

Flutter (Dart) + nativní Kotlin. Lokální SQLite přes `drift`, stav přes Riverpod 2.6.1
(3.x koliduje s `drift_dev`). Offline-first — **Firebase není zapojený** a zatím není potřeba.

```
docs/          spec.md, architecture.md, data-model.md, roadmap.md,
               blocking-android.md, app-limits.md, anchors.md, smart-home.md,
               accountability.md, privacy.md, onboarding.md, accessibility.md,
               battery.md, acceptance.md, post-mvp.md
app/lib/core/  design_system/ (motiv, Inter, ScreenBody, ProgressRing)
               storage/ (drift: database.dart, tables.dart, enums.dart)
               czech_plural.dart
app/lib/features/
               focus_session/ blocking/ friction_exit/ stats/
               anchor/ smart_home/ accountability/ app_limits/
               screen_time/ settings/ privacy/ onboarding/
app/android/app/src/main/kotlin/cz/kotva/
               BlockingPlugin, KotvaAccessibilityService, ShieldActivity,
               BlockingState, InstalledApps, UsageTracker, AppLimits,
               LimitReachedActivity, NotificationSuppressor,
               AnchorScanner, AnchorPlugin, SharePlugin, MainActivity
```

Každá feature má `domain/` (čistý Dart, testy), `application/` (Riverpod),
`presentation/` (UI), případně `data/` (kanál/API).

**Databáze je na `schemaVersion = 8`**, migrace jsou postupné v `database.dart`.

## 5. Stav sprintů

| Sprint | Stav |
|---|---|
| 0 — Základy | ✅ |
| 1 — Fokus session (profily, odpočet, rituál, streak) | ✅ |
| 2 — Blokování aplikací na Androidu | ✅ ověřeno naživo |
| 3 — Friction Exit | ✅ ověřeno naživo |
| Revize Anchor-V1 | ✅ ověřeno naživo |
| 4 — Statistiky | ✅ ověřeno naživo |
| 5 — Kotevní body BLE/NFC | ✅ kód; **detekci nešlo ověřit** (emulátor nemá BLE) |
| 6 — Chytrá zásuvka Kasa | ✅ kód; **spínání neověřeno** (chybí účet i hardware) |
| 7 — Accountability | ✅ lokální část; sdílení čeká na backend |
| 8 — Soukromí a nastavení | ✅ ověřeno naživo — `docs/privacy.md` |
| 9 — Onboarding a polish | ✅ ověřeno naživo — `onboarding.md`, `accessibility.md`, `battery.md` |
| 10 — Akceptační průchod | ✅ proběhl — `docs/acceptance.md` |

**Testů: 120, všechny procházejí. `flutter analyze` bez nálezů.**

### Výsledek §14 (akceptační kritéria)

| # | Kritérium | Stav |
|---|---|---|
| 1 | Profil, session, blokování Android **i iOS** | ⚠️ Android ✅, iOS ❌ |
| 2 | Friction Exit nelze obejít | ✅ |
| 3 | Smart home reálně spíná | ❌ neověřeno |
| 4 | Parťák dostane stav bez cíle | ⚠️ lokálně ✅, doručení ❌ |
| 5 | Statistiky 7/30 dní | ✅ |
| 6 | Onboarding před vyžádáním oprávnění | ✅ |
| 7 | Export a smazání jedním tlačítkem | ✅ |

## 6. Zásady, které se v kódu drží (nevynechávat!)

Tohle je páteř celého projektu — zadání to vyžaduje a je to prosazené v kódu i testech:

- **§11 — aplikace neobviňuje.** Nikde není červená pro chování uživatele (jen pro
  destruktivní akce). Přerušený blok = „kratší blok", ne selhání. Nepočítá se „úspěšnost"
  ani „míra selhání". Enum se jmenuje `interrupted`, ne `failed`. Platí i pro export
  (`stav: "kratsi"`) a pro zprávu parťákovi — obojí hlídá test.
- **§11 — uživatel může vždy skončit.** Friction Exit zpomalí, ale ukončení nakonec
  vždy povolí.
- **§9 — parťák nikdy nevidí cíl ani blokované aplikace.** Veškerý text mířící ven vzniká
  jen v `partner_view.dart`, hlídá to test.
- **§8 — každé oprávnění se nejdřív vysvětlí, pak teprve vyžádá.** Onboarding si sám
  o žádné neříká; o svolení žádá až funkce přes `ConsentRequestScreen`.
- **Souhlas není zaškrtávátko.** Odvolání souhlasu musí funkci **skutečně zastavit** —
  úklid je v `PrivacyController.revoke`, ne v UI.
- **Poctivost o limitech.** Kde něco nejde, aplikace to řekne uživateli na obrazovce
  („Co je dobré vědět") a je to sepsané v `docs/`. Nic se nevynechává tiše.
- **Volitelnost.** Bez kotvy / zásuvky / parťáka musí zbytek fungovat beze změny.

## 7. Klíčová technická rozhodnutí (proč to tak je)

- **Odpočet je odvozený z reálného času**, ne z čítače — přežije zabití procesu.
  Ověřeno `am force-stop` i tvrdým vypnutím stroje uprostřed bloku: session se pak
  uzavřela jako `completed` s koncem v **plánovaný** čas, ne v čase, kdy si toho appka
  všimla.
- **Blokování**: `AccessibilityService` + shield Activity. `DevicePolicyManager` **nejde
  použít** (vyžaduje device ownera přes ADB/enrollment). Cizí aplikaci nelze ukončit.
- **Weby se neblokují** — vyžadovalo by to číst obsah prohlížeče, což jde proti §9.
  Blokovat lze celý prohlížeč. **Otevřená otázka k rozhodnutí.**
- **Měření času** z `UsageStatsManager.queryEvents`, ne `queryUsageStats` (ten vrací
  předpočítané intervaly přesahující období).
- **Hlídka limitů si popředí zjišťuje sama** z `UsageTracker.currentForegroundPackage()`.
  První verze si ho pamatovala z událostí přístupnosti a **nefungovala**. Běží jen tehdy,
  když vůbec nějaký limit existuje.
- **BLE sken v oknech** ~6 s po 75 s (§8 chce 60–90 s), jen po dobu bloku. Duty cycle 8 %,
  hluboko pod cílem 3 % denní spotřeby (výpočet v `battery.md`).
- **Statistiky mlčí, dokud nemají aspoň 3 vzorky** v kategorii; medián místo průměru.
- **Zásuvka obnovuje původní stav**, ne „zapnuto".
- **Aplikace nikdy neodesílá zprávu sama** — jen ji předá systémovému výběru.
- **Souhlasy jsou přírůstkové** — udělení zakládá řádek, odvolání do něj doplní `revokedAt`.
  Stav = „existuje řádek bez `revokedAt`", ne „poslední řádek" (pořadí není při shodných
  časech definované). Historie je kvůli doložitelnosti a jde do exportu.
- **Smazání dat sahá do tří úložišť** — SQLite, nativní prefs, `flutter_secure_storage`.
  Pořadí kroků není libovolné, viz `privacy.md`.
- **Tmavý režim má vlastní barvy** pro primární, destruktivní a „dokončeno". Odstín
  vyladěný na světlé pozadí na tmavém neplatí; hlídá to `contrast_test.dart`.
- **Vycentrování**: `Column` se smrští na šířku nejširšího potomka a `Padding` ho zarovná
  doleva. Řeší `ScreenBody` + regresní test.

### Dvě chyby, které stojí za zapamatování

- **`insertOnConflictUpdate` z driftu cílí na primární klíč**, ne na unikátní sloupec.
  U tabulek s `uniqueKeys` je proto potřeba uvést `onConflict: DoUpdate(..., target: [...])`
  ručně. Bez toho **šlo záznam založit, ale ne změnit** — projevilo se to jako „u denních
  limitů funguje jen první režim". Hlídá `upsert_test.dart`.
- **Po každém `await` v `State`/`ConsumerState` kontrolovat `mounted`**, než se sáhne na
  `setState` nebo `ref`. Čeká se tam i na systémové dialogy bez časového stropu; jinak
  přijde `_lifecycleState != defunct`. Notifier, který je potřeba i po zavření obrazovky,
  si přečti **před** awaitem — žije v ProviderScope, ne ve widgetu.

## 8. Co je potřeba ověřit na reálném hardwaru

1. **Kotva BLE** — detekce odchodu/návratu. Sken se na emulátoru spustí a poctivě hlásí
   „nic v dosahu", ale rádio tam není.
2. **Chytrá zásuvka** — že reálná Kasa zásuvka sepne. **Akceptační kritérium §14 č. 3
   zatím není potvrzené.** Postup v `docs/smart-home.md`.
3. **Denní limity na Chromu** — na emulátoru se Chrome do statistik nezapočítával
   (zasekl se na úvodní obrazovce). Limity ověřeny na aplikaci Hodiny, kde fungovaly
   ve všech třech intenzitách včetně přeházené klávesnice.
4. **Spotřeba baterie v mA** — dosud jen výpočet, ne měření (`battery.md`).
5. **Průchod se zapnutým TalkBackem** — testy ověřují sémantické uzly, ne skutečnou práci
   s odečítačem.

**Telefon je připojený přes USB (Motorola Edge 50 Neo), ale bez zapnutého ladění.**
Pro test na něm: Nastavení → Informace o telefonu → 7× Číslo sestavení → Možnosti pro
vývojáře → Ladění přes USB, pak potvrdit dialog s otiskem klíče.

## 9. Otevřené otázky pro uživatele

- **Blokování webů** (§5.2) — neimplementováno kvůli §9. Chce to řešit jinak?
- **Firebase** — bez projektu pod jeho účtem nejde: cloud sync, živý stav parťáka,
  focus rooms, purge dat z backendu a Sprint 0 bod „Firebase Auth".
- **iOS** — celá nativní blokovací vrstva (Swift, `FamilyControls`/`ManagedSettings`)
  chybí; čeká na prostředí s Xcode. **Akceptační kritérium §14 č. 1 kvůli tomu
  není splněné.**
- **Monetizace (§12)** — gating na `User.subscriptionTier` (freemium: 1 profil + základní
  statistiky) **nezačatý**. Roadmapa ho řadí až po funkční core smyčce, ta hotová je.
- **Zvuk rituálu začátku** — TODO v `start_ritual_screen.dart`, chybí zvukový asset.
- **Wear OS / watchOS** (§5.3) — navrženo jako stretch goal mimo MVP.
- **Google Home / SmartThings / Matter** — vyžadují OAuth a partnerskou registraci.

## 10. Co dělat dál

Sprintový plán je vyčerpaný. Nabízí se:

- **Push a review** devíti commitů — nic z toho zatím není na GitHubu.
- **Monetizace (§12)** — jediná nezačatá položka roadmapy, která nevisí na prostředí.
- **iOS vrstva**, až bude macOS s Xcode. Flutter část je společná a hotová; doplní se
  nativní modul a build/podpis.
- **Firebase**, až bude projekt — odemkne kritérium 4 naplno, cloud sync a focus rooms.
- **Ověření na telefonu** podle seznamu v §8.

## 11. Jak se mnou pracovat (co fungovalo)

- Po každém sprintu: `flutter analyze` + `flutter test`, pak build, instalace na emulátor
  a **skutečné proklikání** přes `adb shell input tap/text` + screenshoty. Nálezy, které
  jinak nevzniknou: nefunkční úprava limitu i výjimka po zavření sheetu se našly takhle,
  ne testy.
- Na konci průchodu vždy projet `adb logcat` na nezachycené výjimky — jedna tam tiše
  seděla, aniž by aplikace spadla.
- Screenshoty měřit programově (PIL), ne odhadem z obrázku — takhle se našel posun
  odpočtu o 45 px.
- **`dart format` na projekt nepouštět.** Repozitář není formátovaný aktuální verzí
  `dart_style` a přeformátovalo by to i nedotčené soubory. Odsazení psát ručně.
- `adb shell input text` **neumí diakritiku** a polyká mezery — psát ASCII a `%s` místo
  mezery.
- Dialogy se po zavření klávesnice posouvají — souřadnice tlačítek číst z čerstvého
  `uiautomator dump`, ne z dřívějšího.
- Commitovat po logických celcích, česky, s vysvětlením *proč*.
- Uživatel odmítl: přidávat závislosti bez ptaní a posílat živý požadavek na TP-Link.
