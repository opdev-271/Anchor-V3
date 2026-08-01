# PROMPT PRO VÝVOJ APLIKACE: "Kotva" — anti-prokrastinační asistent

> Přepis zadávacího dokumentu `prompt_1.docx`. Slouží jako zdroj pravdy pro `data-model.md`,
> `architecture.md`, `roadmap.md` a `post-mvp.md` v tomto adresáři.

## 1. Role a kontext

Jsi senior full-stack mobilní vývojář a produktový designér se zkušenostmi s tvorbou "digital
wellbeing" a habit-forming aplikací (např. Forest, Freedom, One Sec, Opal). Tvým úkolem je
navrhnout a implementovat mobilní aplikaci pro Android a iOS podle specifikace níže. Postupuj
systematicky: nejdřív navrhni architekturu a datový model, poté vytvoř strukturu projektu, a
nakonec implementuj jednotlivé obrazovky a logiku. Pokud narazíš na technické omezení platformy
(viz sekce 8), otevřeně ho popiš a navrhni nejbližší možné řešení místo tichého vynechání funkce.

## 2. Název a jednovětý popis

**Pracovní název:** Kotva (anglicky "Anchor")

**Popis:** Aplikace, která pomáhá lidem dodržet rozhodnutí "teď budu pracovat" tím, že jim ztíží
útěk nejen do telefonu, ale i do běžných reálných úniků — televize, další káva, bezcílná procházka
po bytě — pomocí kombinace blokování zařízení, chytré domácnosti, časovaných rituálů a sociální
odpovědnosti.

## 3. Problém, který řešíme

Existuje spousta nástrojů, které blokují sociální sítě v prohlížeči nebo mobilu (Freedom, Cold
Turkey, Focus). Žádný z nich ale neřeší to, že člověk uteče od práce úplně jinam: zapne televizi,
jde si udělat další kávu, začne uklízet, nebo jen bloumá po bytě. Uživatelé chtějí nástroj, který:

- vytvoří "focus rituál" s jasným začátkem a koncem,
- ztíží (ne znemožní — to není reálné) úniky mimo telefon,
- dá jim vnější tlak/odpovědnost, protože vlastní vůle na to nestačí,
- neshazuje je za selhání, ale pomáhá se rychle vrátit zpět.

## 4. Cílová skupina a persony

**Persona 1 — "Remote Radka", 29 let**
Pracuje z domova na volné noze, sama sobě šéf. Největší nepřítel: kuchyně 3 metry od stolu a
televize v obýváku. Chce vizuální a zvukovou bariéru mezi "teď pracuji" a "teď nepracuji".

**Persona 2 — "Student Standa", 22 let**
Píše diplomku, bydlí na koleji. Prokrastinuje procházkami po chodbě a nekonečným "jen na chvíli"
scrollováním. Potřebuje sociální tlak (spolubydlící/studijní parta), ne jen aplikaci.

**Persona 3 — "Manažer Marek", 41 let**
Má hluboká work bloky mezi schůzkami, ale rozptyluje ho vlastní telefon a chytré hodinky s
notifikacemi. Chce integraci s kalendářem a automatické spouštění fokus módu.

## 5. Klíčové funkce — MVP (verze 1.0)

### 5.1 Fokus session (jádro aplikace)

- Uživatel nastaví délku bloku (15–180 min), cíl (volný text, např. "dokončit kapitolu 3") a
  úroveň přísnosti (Mírná / Střední / Přísná).
- Po spuštění se aktivuje blokace vybraných aplikací a webů (viz 5.2) a spustí se
  vizuální/zvukový "rituál začátku" (např. krátká animace zavírající se brány + jemný zvuk).
- Během session je vidět odpočet, aktuální cíl a "streak" počítadlo.
- Předčasné ukončení vyžaduje potvrzovací krok navržený tak, aby snížil impulzivitu (viz 5.5 —
  Friction Exit).

### 5.2 Blokování aplikací a webů

- **Android:** využití `UsageStatsManager` a `Accessibility Service` / `DevicePolicyManager` pro
  dočasné omezení spuštění vybraných aplikací.
- **iOS:** využití Apple frameworku Screen Time API / Family Controls / DeviceActivity /
  ManagedSettings (dostupné od iOS 16) — nutno počítat s tím, že Apple striktně omezuje, co lze
  blokovat a jak (viz sekce 8, Omezení).
- Uživatel si vytváří vlastní seznamy ("Sociální sítě", "Zprávy", "Hry") a přiřazuje je k
  jednotlivým fokus profilům.

### 5.3 Rozšíření mimo telefon — "Real World Lock"

Toto je klíčová odlišující funkce oproti konkurenci:

- **Chytrá zásuvka / chytrá domácnost:** integrace s Google Home, Matter, SmartThings a TP-Link
  Kasa API — během fokus session lze automaticky vypnout/omezit napájení TV nebo herní konzole
  připojené přes chytrou zásuvku.
- **Bluetooth/NFC "kotevní bod":** uživatel si k telefonu přiřadí NFC tag nebo Bluetooth maják
  (např. na pracovním stole). Fokus session se spustí/pozastaví podle toho, jestli je telefon u
  kotvy — pokud uživatel odejde z místnosti déle než X minut, aplikace to zaznamená a při návratu
  k tomu zeptá na důvod (bez obviňování, jen data pro reflexi).
- **Chytré hodinky (Wear OS / watchOS):** doplňkové mikro-nudge na zápěstí místo hlasitých
  notifikací na telefonu, aby nebyl narušen fokus zvukem z telefonu.

### 5.4 Sociální odpovědnost (accountability)

- Možnost pozvat "accountability parťáka" (kamarád, kolega, partner), který vidí pouze to, jestli
  session probíhá/proběhla, ne obsah práce.
- Volitelné "sázky": uživatel předem nastaví jemný důsledek při přerušení session (např.
  automatická zpráva parťákovi "zase jsem to nedodělal/a", nikoliv finanční sankce v MVP — ty
  nechat na V2 kvůli právním a etickým rizikům).
- Sdílené "focus rooms" — víc lidí spustí session ve stejný čas, vidí navzájem jen stav
  (pracuje / pauza), žádný chat během session, aby to nerozptylovalo.

### 5.5 "Friction Exit" — ztížený způsob předčasného ukončení

- Při pokusu o předčasné ukončení session aplikace nezablokuje uživatele natvrdo (to vede k
  frustraci a odinstalaci), ale vloží mikro-zpomalení: 30sekundové dýchací cvičení nebo napsání
  jedné věty o tom, proč chce skončit dřív.
- Po tomto kroku je ukončení vždy umožněno — respektujeme autonomii uživatele, cílem je přerušit
  impulzivní reakci, ne vytvořit vězení.

### 5.6 Statistiky a zpětná vazba

- Přehled: kolik fokus hodin za týden/měsíc, nejčastější místa/časy selhání, nejúspěšnější
  kombinace (den, čas, délka bloku).
- Žádné "shame" prvky (červené kříže, obviňující texty) — tón je podporující, ne trestající (viz
  sekce 11 — Etika a wellbeing).

## 6. Rozšířené funkce — post-MVP (verze 2.0+)

- AI kouč, který na základě historie navrhuje optimální délku bloků a čas dne ("Všiml jsem si,
  že v pondělí ráno ti fokus nejlépe vydrží 50 minut.").
- Integrace s kalendářem (Google/Outlook) — automatické navrhování fokus bloků mezi schůzkami.
- Geofencing (např. automatické spuštění fokus profilu při příchodu do knihovny/kavárny).
- Gamifikace: RPG-styl "energetické body" za dokončené session, kosmetické odměny (skiny appky),
  žádné pay-to-win prvky.
- Integrace s chytrou žárovkou (změna barvy světla při fokusu vs. pauze).
- Týmová/firemní verze s agregovanými (anonymizovanými) statistikami pro HR wellbeing programy.

## 7. Technická architektura

### 7.1 Doporučený stack

- **Cross-platform framework:** Flutter (preferováno kvůli lepší kontrole nad nativními pluginy
  pro Screen Time / Usage Stats) nebo React Native + Expo dev client.
- **Backend:** Firebase (Auth, Firestore, Cloud Functions, FCM pro notifikace) pro MVP; při
  škálování zvážit Node.js/NestJS + PostgreSQL.
- **Blokovací vrstva Android:** nativní modul (Kotlin) využívající `UsageStatsManager`,
  `AccessibilityService`, případně `DevicePolicyManager` pro pokročilejší omezení (vyžaduje
  explicitní souhlas uživatele a čitelné vysvětlení oprávnění).
- **Blokovací vrstva iOS:** nativní modul (Swift) přes `FamilyControls`, `ManagedSettings`,
  `DeviceActivity` framework.
- **Smart home integrace:** Google Home API, SmartThings API, případně obecný Matter/Thread
  standard; pro TP-Link Kasa použij jejich cloudové REST API.
- **Notifikace:** Firebase Cloud Messaging + lokální notifikace pro spolehlivost i bez internetu.
- **Analytika:** on-device zpracování co nejvíc (viz sekce 9 — Soukromí), agregovaná/anonymizovaná
  telemetrie do backendu jen se souhlasem.

### 7.2 Struktura projektu (návrh)

```
/app
  /features
    /focus_session
    /blocking
    /smart_home
    /accountability
    /stats
    /onboarding
  /core
    /design_system
    /networking
    /storage
    /permissions
  /native
    /android (Kotlin moduly)
    /ios (Swift moduly)
/backend
  /functions
  /firestore_rules
/docs
  spec.md (tento dokument)
```

## 8. Technická omezení, která musíš zohlednit

- iOS blokování je striktně omezené Applem. Nelze číst obsah jiných appek ani je "zabíjet" na
  pozadí; lze pouze omezit jejich spuštění přes oficiální Screen Time frameworky a uživatel musí
  explicitně povolit Family Controls. Popiš toto omezení uživateli v onboardingu, ne až po
  instalaci.
- Přístup k Usage Stats na Androidu vyžaduje speciální systémové oprávnění, které uživatel musí
  ručně povolit v nastavení telefonu — UX flow na to musí jasně navést (deep link do správného
  nastavení).
- Integrace chytré domácnosti je závislá na tom, jaké zařízení uživatel vlastní — funkce musí být
  plně volitelná a nesmí blokovat používání zbytku appky, pokud uživatel žádnou chytrou zásuvku
  nemá.
- Bluetooth/NFC kotva spotřebovává baterii — implementuj úsporný scanning interval (např. každých
  60–90 s), ne kontinuální sledování.
- Zvaž a popiš, které funkce nejsou technicky proveditelné vůbec (např. "detekce, že si uživatel
  dělá kávu" bez fyzického senzoru není řešitelná softwarově — nahraď ji kotvícím bodem u
  pracovního stolu, ne detekcí kuchyně).

## 9. Soukromí a bezpečnost

- Data o používání appek a poloze zpracovávej primárně on-device; do cloudu posílej jen to, co je
  nutné pro synchronizaci mezi zařízeními a accountability funkce.
- Accountability parťák nikdy nevidí, jaké konkrétní appky uživatel blokuje ani jaký má cíl —
  pouze binární stav "v session / mimo session".
- Explicitní GDPR-compliant souhlasy pro každou kategorii dat zvlášť (usage stats, poloha, smart
  home).
- Možnost kompletního exportu a smazání dat z appky i z backendu na jedno tlačítko.
- Žádné sdílení dat třetím stranám pro reklamní účely.

## 10. UX/UI — popis obrazovek

| Obrazovka | Účel | Klíčové prvky |
|---|---|---|
| Onboarding | Vysvětlit koncept, získat oprávnění | Vysvětlení proč potřebujeme Usage Stats/Screen Time, ukázka "Real World Lock", výběr první "kotvy" |
| Dashboard | Rychlý přehled a start session | Velké tlačítko "Začít fokus", aktuální streak, dnešní progres |
| Nastavení fokus profilu | Konfigurace bloku | Délka, cíl, úroveň přísnosti, seznam blokovaných appek, výběr chytrého zařízení |
| Průběh session | Aktivní blok | Odpočet, cíl, tlačítko "Potřebuji přestávku" (vede na Friction Exit flow) |
| Friction Exit | Zpomalení impulzivního ukončení | Krátké dechové cvičení / jedna reflexní otázka, poté možnost potvrdit ukončení |
| Statistiky | Zpětná vazba bez shamingu | Grafy fokus hodin, nejlepší časy/dny, žádné červené "failure" indikátory |
| Accountability | Správa parťáků a sdílených místností | Seznam parťáků, pozvánky, stav "pracuje/nepracuje" |
| Nastavení appky | Oprávnění, propojená zařízení, soukromí | Správa smart home zařízení, export/smazání dat |

## 11. Tón, etika a wellbeing principy (závazné pro copy i logiku)

- Aplikace nikdy neobviňuje ani nezahanbuje uživatele za selhání — žádné texty typu "Zase jsi to
  nezvládl/a".
- Cílem je snížit impulzivitu, ne vytvořit digitální vězení — uživatel má vždy nakonec možnost
  ukončit cokoliv, jen s malým zpomalením.
- Žádné manipulativní "dark patterns" (umělé prodlužování predikce úspěchu kvůli udržení
  předplatného apod.).
- Volitelné "sázky" v sociální funkci nesmí v MVP zahrnovat peníze ani cokoliv, co by mohlo být
  vnímáno jako gambling mechanika.

## 12. Monetizace

- Freemium model: základní fokus session, 1 blokovací profil a základní statistiky zdarma.
- Předplatné (měsíční/roční): neomezené profily, smart home integrace, accountability funkce,
  pokročilé statistiky a AI kouč (V2).
- Žádné reklamy v appce zaměřené na wellbeing — nekonzistentní s hodnotovou nabídkou.

## 13. Nefunkční požadavky

- **Spotřeba baterie:** pozadí běžící služby (Bluetooth scanning, usage tracking) musí mít
  měřitelný dopad pod 3 % denní spotřeby baterie.
- **Offline režim:** fokus session a blokování appek musí fungovat i bez internetového připojení;
  synchronizace proběhne po obnovení připojení.
- **Přístupnost:** podpora dynamického písma, VoiceOver/TalkBack, dostatečný kontrast barev
  (WCAG AA).
- **Podporované verze:** Android 10+ (API 29+), iOS 16+.

## 14. Akceptační kritéria (Definition of Done pro MVP)

- [ ] Uživatel může vytvořit fokus profil, spustit a dokončit session s reálným blokováním
      zvolených appek na Android i iOS.
- [ ] Friction Exit flow funguje a nelze ho obejít bez proběhnutí zpomalovacího kroku.
- [ ] Alespoň jedna smart home integrace (např. TP-Link Kasa) funkčně vypne/zapne zařízení podle
      stavu session.
- [ ] Accountability parťák dostane notifikaci o stavu session bez přístupu k detailům cíle.
- [ ] Statistiky se zobrazují korektně za posledních 7/30 dní.
- [ ] Onboarding jasně vysvětluje všechna požadovaná oprávnění před jejich vyžádáním.
- [ ] Všechna citlivá data lze exportovat a smazat jedním tlačítkem.

## 15. Co od tebe očekávám jako výstup

- Navrhni datový model (entity, vztahy) jako první krok a ukaž mi ho k odsouhlasení.
- Navrhni strukturu projektu podle sekce 7.2 a zdůvodni případné odchylky.
- Postupuj funkci po funkci podle priority v sekci 5 (MVP), ne podle sekce 6 (post-MVP) — ty
  implementuj až po potvrzení, že MVP funguje.
- U každé implementované funkce mi stručně napiš, jaké platformní oprávnění/API jsi použil a jaké
  má limity.
- Pokud narazíš na funkci, kterou nejde technicky spolehlivě realizovat (viz sekce 8), řekni to
  rovnou a navrhni nejbližší reálnou alternativu — nevynechávej to mlčky.
