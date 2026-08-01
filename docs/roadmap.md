# MVP Roadmapa — Kotva

> Postup funkce po funkci podle priority v [spec.md § 5](spec.md#5-klíčové-funkce--mvp-verze-10)
> (MVP), ne podle § 6 (post-MVP — viz [post-mvp.md](post-mvp.md)), přesně jak vyžaduje
> [spec.md § 15](spec.md#15-co-od-tebe-očekávám-jako-výstup). U každé funkce je uvedeno
> platformní oprávnění/API a jeho limity.

## Sekvencování: nejdřív Android

Vývoj běží **nejdřív jen pro Android**; iOS část se doplní později, až bude k dispozici
prostředí s Xcode (macOS). Volba Flutteru tím není dotčená — UI vrstva bude pro iOS hotová,
doplní se jen nativní blokovací modul (Swift, Sprint 2) a build/podpis.

Dopad na akceptační kritéria [§14](spec.md#14-akceptační-kritéria-definition-of-done-pro-mvp):
první bod ("blokování na Android **i iOS**") zůstane nesplněný, dokud iOS část nedoběhne —
není vynechaný, jen odložený. Ostatní kritéria jdou splnit na Androidu nezávisle.

## Stav

| Sprint | Stav |
|---|---|
| 0 — Základy | ✅ hotovo (bez Firebase — viz poznámka níže) |
| 1 — Fokus session jádro | ✅ hotovo |
| 2 — Blokování appek (Android) | ✅ hotovo — viz [blocking-android.md](blocking-android.md) |
| 3 — Friction Exit | ✅ hotovo |
| 4 — Statistiky | ⏭️ další na řadě |
| 5–10 | ⬜ neotevřeno |

**Firebase zatím není zapojený.** Vyžaduje projekt založený pod účtem uživatele
(`google-services.json`). Sprinty 0 a 1 ho nepotřebují — aplikace je offline-first
([§13](spec.md#13-nefunkční-požadavky)) a veškerý stav drží lokální SQLite databáze
(`drift`) se sloupci `remoteId`/`updatedAt` připravenými na pozdější synchronizaci.
Firebase Auth a cloud sync se doplní, až bude projekt k dispozici.

## Sprint 0 — Základy

- Odsouhlasit [data-model.md](data-model.md) (3 otevřené otázky na konci dokumentu).
- Inicializovat Flutter projekt + Firebase projekt (Auth, Firestore, Functions, FCM) dle
  [architecture.md](architecture.md).
- Založit adresářovou strukturu a design systém (tokeny, bez shame-based komponent).
- Firebase Auth — e-mail/social login.
- **Permissions/API:** žádné platformní speciální oprávnění zatím.

## Sprint 1 — Fokus session jádro ([§5.1](spec.md#51-fokus-session-jádro-aplikace))

- CRUD `FocusProfile` (délka 15–180 min, cíl, přísnost).
- `FocusSession` start/stop, odpočet, rituál začátku (animace + zvuk).
- Streak počítadlo (cache na `User`, přepočet Cloud Function triggerem — viz data-model.md
  otevřená otázka #1).
- Offline-first lokální perzistence, sync do Firestore po obnovení připojení.
- **Permissions/API:** žádné — čistě in-app stav. Toto je bezpečný sprint na ověření core
  smyčky před rizikovými platformními integracemi.

## Sprint 2 — Blokování aplikací a webů ([§5.2](spec.md#52-blokování-aplikací-a-webů)) ⚠️ nejrizikovější

- **Android:** `UsageStatsManager` (detekce popředí appky) + `AccessibilityService` nebo
  `DevicePolicyManager` (vynucení omezení).
  - *Limity:* uživatel musí ručně povolit Usage Access v Nastavení — nelze žádat programaticky
    jako standardní runtime permission; UX musí obsahovat deep-link (`Intent` na
    `ACTION_USAGE_ACCESS_SETTINGS`) a jasné vysvětlení předem (§8).
- **iOS:** `FamilyControls` (autorizace) + `ManagedSettings` (shield appek) + `DeviceActivity`
  (plánování).
  - *Limity:* funguje od iOS 16+; nelze číst obsah appek ani je "zabít" na pozadí — jde jen o
    shield (blokovací overlay) přes oficiální framework. Appky jsou reprezentovány jako opaké
    `FamilyActivitySelection` tokeny, ne čitelná jména (viz data-model.md otevřená otázka #2).
- Vlastní seznamy appek ("Sociální sítě", "Zprávy", "Hry") + přiřazení k profilům.
- **Doporučení:** implementovat nejmenší funkční řez první (např. jeden pevný seznam, jedno
  API) a rozšiřovat iterativně — toto je sprint s nejvyšším rizikem platformních překvapení.

## Sprint 3 — Friction Exit ([§5.5](spec.md#55-friction-exit--ztížený-způsob-předčasného-ukončení)) ✅

- Flow při pokusu o předčasné ukončení: dechové cvičení NEBO jedna reflexní věta —
  uživatel si volí, což je samo o sobě první moment zastavení.
- Délka zpomalení se řídí přísností profilu (mírná 15 s, střední 30 s dle zadání, přísná 45 s).
  Editor profilu u přísné úrovně slibuje „delší zpomalení při ukončení", takže se to musí
  reálně projevit. Horní hranice je držená nízko schválně — delší čekání by nezvyšovalo šanci
  na návrat k práci, jen frustraci a pravděpodobnost odinstalace.
- **Nelze obejít** (akceptační kritérium §14): během kroku je systémové „zpět" vypnuté přes
  `PopScope` a tlačítko k ukončení do dokončení kroku vůbec neexistuje. Ukončení session
  navíc vede **výhradně** přes tuto obrazovku — jiná cesta ven neexistuje.
- **Ukončení je po zpomalení vždy umožněno** — žádná další podmínka ani přemlouvání (§11).
- Odpočet dýchání běží na Flutter tickeru, ne na `Timer`u: ticker se zastaví, když aplikace
  není v popředí, takže zpomalení znamená skutečnou přítomnost, ne odsunutou aplikaci.
- Každý pokus se loguje jako `FrictionExitEvent` — včetně těch, po kterých se uživatel vrátil
  k práci. Právě ta data ukážou, kdy a proč pozornost odchází (podklad pro §5.6).
- **Permissions/API:** žádné — čistě UI a stav.

## Sprint 4 — Statistiky ([§5.6](spec.md#56-statistiky-a-zpětná-vazba))

- Agregace fokus hodin za týden/měsíc, nejúspěšnější kombinace (den/čas/délka).
- Žádné shame prvky (červené kříže, obviňující texty) — vazba na [§11](spec.md#11-tón-etika-a-wellbeing-principy-závazné-pro-copy-i-logiku).
- **Permissions/API:** žádné nové — čte z existujících `FocusSession` záznamů.

## Sprint 5 — Real World Lock: kotvy ([§5.3](spec.md#53-rozšíření-mimo-telefon--real-world-lock), část)

- BLE/NFC pairing kotevního bodu (`AnchorPoint`).
  - **Android:** `BluetoothLeScanner` (BLE) / `NfcAdapter` (NFC). **iOS:** `CoreBluetooth` (BLE);
    NFC čtení mimo aktivní session na iOS je omezené (`CoreNFC` vyžaduje aktivní scan session
    spuštěnou uživatelem, nelze pasivně sledovat na pozadí jako Android) — reálná alternativa je
    primárně BLE maják na iOS, NFC jako doplněk s explicitním "přiložit telefon" gestem.
  - *Limity baterie:* úsporný scanning interval 60–90s (§8), ne kontinuální sledování.
- Leave/return detekce → `AnchorEvent` + nepovinná reflexní otázka (bez obviňování).
- **Wear OS / watchOS micro-nudge:** navrhuji jako **stretch goal mimo MVP** — přidává dvě další
  nativní platformy (Wear OS Kotlin companion, watchOS Swift companion) s vlastním
  distribučním/testovacím overheadem. MVP akceptační kritéria (§14) tuto funkci nevyžadují.
  Otevřeně navrhováno k odsunutí, ne tiše vynecháno.

## Sprint 6 — Smart home ([§5.3](spec.md#53-rozšíření-mimo-telefon--real-world-lock), pokračování)

- **TP-Link Kasa REST API první** — cloudové REST rozhraní, žádná MFi/Works-with-Google
  certifikace potřeba. Přímo pokrývá akceptační kritérium
  "[alespoň jedna smart home integrace funkčně vypne/zapne zařízení](spec.md#14-akceptační-kritéria-definition-of-done-pro-mvp)".
- Google Home API / SmartThings API / Matter — navazující iterace až po Kasa; vyžadují
  OAuth flow a/nebo formální partnerskou registraci, vyšší náklad na implementaci a schvalování.
- **Musí být plně volitelné** — appka funguje beze zbytku i bez jakéhokoliv smart zařízení (§8).

## Sprint 7 — Accountability ([§5.4](spec.md#54-sociální-odpovědnost-accountability))

- Pozvánky parťáka (e-mail/odkaz), přijetí.
- Binární stav session (active/inactive) přes Firestore + FCM notifikace — `firestore_rules`
  vynucují, že parťák nikdy nevidí `goalText` ani `BlockedAppList` (viz architecture.md).
- Focus rooms: sdílená přítomnost, bez chatu (aby nerozptylovalo).
- **Bez peněžních sázek v MVP** — pouze měkký důsledek (automatická zpráva parťákovi); finanční
  sankce/gambling mechaniky výslovně odloženy na V2 kvůli právním a etickým rizikům (§11).
- **Permissions/API:** FCM push notifikace.

## Sprint 8 — Soukromí a nastavení ([§9](spec.md#9-soukromí-a-bezpečnost), [§10](spec.md#10-uxui--popis-obrazovek))

- Granulární souhlasy per kategorie (usage_stats, location, smart_home) — `ConsentRecord`.
- Export a smazání všech dat jedním tlačítkem (klient + Cloud Function pro purge Firestore).
- Nastavení appky: správa připojených smart zařízení a oprávnění.

## Sprint 9 — Onboarding a polish

- Onboarding vysvětluje **všechna** oprávnění před jejich vyžádáním (Usage Stats/Screen Time,
  Real World Lock ukázka, výběr první kotvy) — mandát §8, ne až po instalaci.
- Přístupnost: dynamické písmo, VoiceOver/TalkBack, kontrast WCAG AA.
- Battery profiling BLE scanningu a usage trackingu — cíl pod 3 % denní spotřeby (§13).
- Ověření offline režimu (session i blokování appek funguje bez internetu, sync po obnovení).

## Sprint 10 — Akceptační průchod

Projít [§14 checklist](spec.md#14-akceptační-kritéria-definition-of-done-pro-mvp) bod po bodu se
skutečnými zařízeními (Android + iOS), ne jen simulátory, kvůli platformním oprávněním ze
Sprintu 2 a 5.

## Monetizace ([§12](spec.md#12-monetizace))

Implementovat gating na `User.subscriptionTier` (freemium: 1 profil + základní statistiky
zdarma) až po funkční core smyčce (po Sprintu 4) — ne dřív, aby gating nebrzdil ověřování
core hodnoty appky.
