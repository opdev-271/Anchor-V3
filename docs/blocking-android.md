# Blokování aplikací na Androidu — použitá API a jejich limity

> Sprint 2 z [roadmap.md](roadmap.md), funkce [spec.md §5.2](spec.md#52-blokování-aplikací-a-webů).
> Tento dokument plní požadavek [spec.md §15](spec.md#15-co-od-tebe-očekávám-jako-výstup):
> u každé implementované funkce popsat použité platformní oprávnění/API a jeho limity,
> a otevřeně pojmenovat, co realizovat nejde.

## Co je použito

| Vrstva | API | Soubor |
|---|---|---|
| Detekce aplikace v popředí | `AccessibilityService`, událost `TYPE_WINDOW_STATE_CHANGED` | [KotvaAccessibilityService.kt](../app/android/app/src/main/kotlin/cz/kotva/KotvaAccessibilityService.kt) |
| Překryv blokované aplikace | Nativní `Activity` | [ShieldActivity.kt](../app/android/app/src/main/kotlin/cz/kotva/ShieldActivity.kt) |
| Seznam aplikací | `PackageManager.queryIntentActivities` + `<queries>` v manifestu | [InstalledApps.kt](../app/android/app/src/main/kotlin/cz/kotva/InstalledApps.kt) |
| Řazení podle používání | `UsageStatsManager.queryUsageStats` | tamtéž |
| Kontrola oprávnění a deep-linky | `Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES`, `AppOpsManager`, `Settings.ACTION_*` | [BlockingPlugin.kt](../app/android/app/src/main/kotlin/cz/kotva/BlockingPlugin.kt) |
| Sdílení stavu s Flutterem | `SharedPreferences` | [BlockingState.kt](../app/android/app/src/main/kotlin/cz/kotva/BlockingState.kt) |

## Oprávnění a jak se udělují

**Služba přístupnosti** — povinná, bez ní blokace nefunguje vůbec. Uděluje se **ručně**
v Nastavení → Přístupnost; Android pro ni nemá runtime dialog. Proto aplikace nejdřív
vysvětlí, k čemu ji potřebuje, a teprve pak nabídne tlačítko s deep-linkem na
`Settings.ACTION_ACCESSIBILITY_SETTINGS` — přesně jak vyžaduje
[§8](spec.md#8-technická-omezení-která-musíš-zohlednit).

**Přístup k údajům o používání** (`PACKAGE_USAGE_STATS`) — **volitelný**. Slouží jen
k seřazení seznamu aplikací podle skutečně stráveného času. Bez něj se seznam seřadí
abecedně a blokace funguje beze změny. Uděluje se také ručně, deep-link vede na
`Settings.ACTION_USAGE_ACCESS_SETTINGS`.

Rozsah služby je držený co nejužší kvůli [§9](spec.md#9-soukromí-a-bezpečnost):
odebírá se jediný typ událostí a `canRetrieveWindowContent` je vypnuté, takže služba
nemá k obsahu cizích aplikací přístup ani technicky.

## Limity, které tahle cesta má

1. **Cizí aplikaci nelze ukončit.** Android to běžné aplikaci neumožňuje. Blokace je
   překryv a odklonění na plochu, ne "zabití" procesu. Pro účel aplikace to stačí —
   cílem je přerušit impulz, ne postavit vězení ([§11](spec.md#11-tón-etika-a-wellbeing-principy-závazné-pro-copy-i-logiku)).
2. **Blokovaná aplikace na okamžik probliskne.** Systém o změně okna informuje až poté,
   co se aplikace otevře. Předběhnout to nelze.
3. **Uživatel může službu kdykoliv vypnout** v systémovém nastavení. Je to záměr Androidu
   a je to v souladu s §11 — autonomie zůstává u uživatele.
4. **Weby se neblokují.** Blokace konkrétních URL by znamenala číst obsah prohlížeče, což
   je disproporční zásah do soukromí a v rozporu s §9. Blokovat lze celý prohlížeč jako
   aplikaci. Blokace jednotlivých webů v MVP schválně **není**, byť ji §5.2 zmiňuje —
   považuji cenu za soukromí za příliš vysokou a navrhuji to probrat, než se do toho půjde.

## Co nejde realizovat vůbec

**`DevicePolicyManager.setPackagesSuspended`** by uměl tvrdší blokaci — systém by aplikaci
odmítl spustit. Vyžaduje ale roli **device ownera**, kterou lze nastavit jen přes ADB nebo
podnikový enrollment na továrně resetovaném zařízení. Pro běžně distribuovanou spotřebitelskou
aplikaci je nepoužitelná. Zadání ji v §5.2 a §7.1 zmiňuje jako možnost — tady je to
uvedené na pravou míru místo tichého vynechání.

Nejbližší reálná alternativa je právě `AccessibilityService`, který je zároveň cestou,
kterou používají Freedom, Cold Turkey i další nástroje v této kategorii.

## Poznámka k architektuře

Blokovací služba běží nezávisle na Flutter enginu — když uživatel odsune aplikaci z popředí,
engine může být uspaný nebo zabitý. Stav blokace proto žije v `SharedPreferences`, ke kterým
mají přístup obě strany. Nativní strana si zároveň sama hlídá čas konce bloku, aby blokace
nezůstala viset, kdyby Flutter proces zanikl dřív, než ji stihl vypnout.
