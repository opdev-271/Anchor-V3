# Denní limity aplikací a čas na obrazovce

> Revize **Anchor-V1** (`Kotva_V1_co_predelat.docx`). Rozšiřuje původní zadání
> ([spec.md](spec.md)) o funkce, které nejsou vázané na fokus session: sledování času
> na obrazovce a denní limity na jednotlivé aplikace.

## Vztah k původnímu zadání

Původní spec řeší blokování **během fokus bloku**. Denní limity fungují nezávisle na tom,
jestli nějaký blok běží — jsou to dvě samostatné vrstvy nad toutéž službou přístupnosti:

| Vrstva | Kdy platí | Co dělá |
|---|---|---|
| Fokus blok ([spec.md §5.2](spec.md#52-blokování-aplikací-a-webů)) | jen po dobu session | překryje vybrané aplikace připomínkou cíle |
| Denní limit (tento dokument) | celý den | po vyčerpání minut aplikaci zastaví |

Obě vyhodnocuje [KotvaAccessibilityService](../app/android/app/src/main/kotlin/cz/kotva/KotvaAccessibilityService.kt);
fokus blok má přednost.

## Měření času

Čas se počítá z [UsageTracker](../app/android/app/src/main/kotlin/cz/kotva/UsageTracker.kt)
nad `UsageStatsManager.queryEvents`, ne nad `queryUsageStats`. Důvod: `queryUsageStats`
vrací předpočítané intervaly, které mohou přesahovat zadané období, takže „kolik jsem dnes
strávil v Chrome" z nich vyjde nepřesně. Z jednotlivých událostí popředí a pozadí se čas
složí přesně — u limitů je to nutnost, jinak by se spouštěly dřív nebo později, než uživatel
čeká.

Právě běžící relace se dopočítává zvlášť: aplikace v popředí ještě událost o odchodu
nevygenerovala, a bez toho by se limit nikdy nespustil.

Limit se navíc kontroluje **i za běhu**, ne jen při otevření aplikace (interval 15 s).
Bez toho by šel obejít tím, že uživatel prostě nepřepne okno.

Hlídka si popředí zjišťuje sama přes `UsageTracker.currentForegroundPackage()`. První verze
si ho pamatovala z událostí přístupnosti a při testu se ukázalo, že to nefunguje: stačila
jediná událost z jiného balíčku a hlídka se odmlčela, takže se limit během používání nevynutil
vůbec — spustil se až při dalším otevření aplikace. Současná verze běží nezávisle na tom,
jaké události zrovna chodí.

## Tři intenzity vynucení

Odpovídají třem úrovním ze zadání revize:

| Intenzita | Chování |
|---|---|
| **Zeptat se** | Nabídne prodloužení o 5 minut. Po jejich uplynutí se zeptá znovu. |
| **Opsat kód** | Prodloužení vyžaduje opsat čtyřmístný kód na **přeházené** klávesnici. |
| **Bez výjimky** | Žádné prodloužení, do konce dne zavřeno. |

U varianty „opsat kód" není smysl v obtížnosti, ale v tom, že úkon **nejde provést ze svalové
paměti** — vyžaduje pozornost, což je přesně to, co přeruší impulz. Číslice se losují znovu
při každém zobrazení i po chybném pokusu, aby opakování nebylo snazší.

I nejpřísnější varianta nechává uživateli možnost limit v Kotvě změnit nebo zrušit. Bariéra
je pro impulz, ne pro rozhodnutí — stejná zásada jako u Friction Exit
([spec.md §11](spec.md#11-tón-etika-a-wellbeing-principy-závazné-pro-copy-i-logiku)).

## Notifikace po vyčerpání limitu

Zadání požaduje, aby z vyčerpané aplikace nechodily notifikace. Řeší to
[NotificationSuppressor](../app/android/app/src/main/kotlin/cz/kotva/NotificationSuppressor.kt)
přes `NotificationListenerService`.

**Limity tohoto řešení, které je potřeba znát:**

- Android neumožňuje cizí aplikaci zakázat, aby notifikaci **vytvořila**. Lze ji jen odebrat
  hned po zobrazení. V praxi zmizí prakticky okamžitě, může ale krátce probliknout.
- **Zvuk potlačit nelze** — systém ho přehraje dřív, než se o notifikaci vůbec dozvíme.
- Trvalé notifikace (přehrávač, hovor) se záměrně neodstraňují — nejde o rozptýlení, ale
  o probíhající činnost, kterou by odebrání rozbilo.
- Oprávnění „Přístup k oznámením" uděluje uživatel ručně. Bez něj limity fungují dál, jen
  notifikace chodit budou; funkce je proto celá volitelná.

## Oprávnění

| Oprávnění | Nutné pro | Bez něj |
|---|---|---|
| Služba přístupnosti | vynucení limitu | limit se nespustí |
| Přístup k údajům o používání | měření času | Kotva nezjistí, kolik času uplynulo |
| Přístup k oznámením | tlumení notifikací | limity fungují, notifikace chodí |

Všechna tři se udělují **ručně v systémovém nastavení** — Android pro ně nemá runtime dialog.
Aplikace u každého nejdřív vysvětlí účel a teprve pak nabídne tlačítko s deep-linkem, jak
vyžaduje [spec.md §8](spec.md#8-technická-omezení-která-musíš-zohlednit).

## Zdroj pravdy

Konfigurace limitů žije na dvou místech a je to záměr:

- **`AppLimits.kt` / `SharedPreferences`** — zdroj pravdy pro vynucování. Služba přístupnosti
  běží nezávisle na Flutter enginu a do jeho databáze se nedostane.
- **Tabulka `AppUsageLimits` v drift** — pro UI a budoucí synchronizaci mezi zařízeními.

Každá změna prochází `AppLimitsController`, který zapíše do obou. Při startu aplikace se stav
z databáze propíše do nativní vrstvy, aby se srovnaly po vyčištění dat nebo přeinstalaci.
