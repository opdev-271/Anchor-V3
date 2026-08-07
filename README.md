# Kotva

Anti-prokrastinační asistent pro Android a iOS. Pomáhá dodržet rozhodnutí „teď budu pracovat“
tím, že ztíží útěk nejen do telefonu, ale i do reálných úniků — kombinací blokování aplikací,
časovaných rituálů, chytré domácnosti a sociální odpovědnosti.

> Ve vývoji. Aktuálně se staví Android; iOS část přibude, až bude k dispozici prostředí s Xcode.

## Stav

| Sprint | Obsah | Stav |
|---|---|---|
| 0 | Základy projektu, design systém, lokální databáze | ✅ |
| 1 | Fokus session — profily, odpočet, rituál začátku, streak | ✅ |
| 2 | Blokování aplikací na Androidu | ✅ |
| 3 | Friction Exit — ztížené předčasné ukončení | ✅ |
| — | Revize Anchor-V1: motiv, čas na obrazovce, denní limity aplikací, vzhled | ✅ |
| 4 | Statistiky — kdy fokus drží nejlíp | ✅ |
| 5 | Kotevní body — Bluetooth maják a NFC štítek | ✅ |
| 6 | Chytrá zásuvka (TP-Link Kasa) | ✅ kód, spínání neověřeno bez hardwaru |
| 7 | Accountability — parťák a zpráva po bloku | ✅ lokální část; sdílení čeká na backend |
| 8–10 | Soukromí, onboarding, akceptační průchod | ⬜ |

Podrobně v [docs/roadmap.md](docs/roadmap.md).

## Dokumentace

| Dokument | Obsah |
|---|---|
| [docs/spec.md](docs/spec.md) | Zadání — funkce, persony, etické principy, akceptační kritéria |
| [docs/architecture.md](docs/architecture.md) | Stack, struktura projektu, zdůvodnění odchylek |
| [docs/data-model.md](docs/data-model.md) | Entity a vztahy |
| [docs/roadmap.md](docs/roadmap.md) | Rozpad MVP na sprinty s použitými API a jejich limity |
| [docs/blocking-android.md](docs/blocking-android.md) | Blokovací vrstva — co jde, co nejde a proč |
| [docs/app-limits.md](docs/app-limits.md) | Denní limity aplikací a čas na obrazovce |
| [docs/anchors.md](docs/anchors.md) | Kotevní body — spotřeba baterie a limity BLE/NFC |
| [docs/smart-home.md](docs/smart-home.md) | Chytrá zásuvka přes TP-Link Kasa |
| [docs/accountability.md](docs/accountability.md) | Parťáci — hranice soukromí a co čeká na backend |
| [docs/post-mvp.md](docs/post-mvp.md) | Odložené funkce |

## Technologie

Flutter (Dart) + nativní Kotlin modul pro blokování. Lokální SQLite (`drift`), stav přes
Riverpod. Aplikace je offline-first — funguje bez připojení i bez backendu.

## Vývoj

Návod na spuštění a testování je v [app/README.md](app/README.md).

## Zásady, které se v kódu drží

Aplikace nikdy neobviňuje uživatele za selhání a nesnaží se ho uvěznit — předčasné ukončení
bloku je vždy možné, jen se zpomalí, aby se přerušil impulz. Data o používání aplikací se
zpracovávají na zařízení. Podrobně v [docs/spec.md §9 a §11](docs/spec.md).
# Anchor-V3
