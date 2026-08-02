# Accountability — co je hotové a co čeká na backend

> Sprint 7 z [roadmap.md](roadmap.md), funkce [spec.md §5.4](spec.md#54-sociální-odpovědnost-accountability).

## Hranice soukromí je nejdůležitější část

[§9](spec.md#9-soukromí-a-bezpečnost) říká jednoznačně: parťák nikdy nevidí, jaké aplikace si
uživatel blokuje ani jaký má cíl — **pouze binární stav „v session / mimo session"**.

Proto veškerý text, který kdy opustí telefon směrem k parťákovi, vzniká na jediném místě:
[partner_view.dart](../app/lib/features/accountability/domain/partner_view.dart). Kdyby se
zpráva skládala přímo v UI, dřív nebo později by tam někdo přidal `session.goalText`, protože
„to přece dává smysl" — a tiše by tím porušil §9. Hlídá to test, který zkouší všechny stavy
session a ověřuje, že se cíl do zprávy nedostane.

Ven jde jen: stav (pracuje / dokončil / skončil dřív) a počet odpracovaných minut. Délka není
obsah práce — je to právě ta informace navíc, která dává accountability smysl, aniž by
prozradila, na čem uživatel dělá.

## Aplikace zprávu neodesílá

Zadání §5.4 mluví u „sázek" o *automatické* zprávě parťákovi. Kotva ji **nabídne**, ale
neodešle: po skončení bloku se objeví tlačítko, které předá připravený text systémovému výběru
aplikací, a uživatel vybere, komu a čím ho pošle.

Automatické odeslání navenek bez potvrzení by bylo jednání za uživatele — a to si aplikace,
která má respektovat jeho autonomii ([§11](spec.md#11-tón-etika-a-wellbeing-principy-závazné-pro-copy-i-logiku)),
dovolit nemůže. Navíc bez backendu ani technicky nejde.

## Tón zprávy

Zadání nabízí jako příklad formulaci „zase jsem to nedodělal/a". Takovou větu aplikace
**nepoužívá** — sebeobviňování v šabloně by odporovalo §11, které zahanbování zakazuje.
Zpráva konstatuje fakt a odpracovaný čas uznává i u předčasně ukončeného bloku. Ověřuje to test.

## Žádné peníze

§5.4 i §11 vylučují v MVP finanční sázky a cokoliv, co by mohlo působit jako gambling.
Implementovaná „jemná sázka" je proto jen ta zpráva parťákovi — nic víc.

## Co zatím není a proč

| Z §5.4 | Stav |
|---|---|
| Parťák vidí, jestli session probíhá | ⬜ potřebuje backend |
| Zpráva parťákovi po bloku | ✅ jako nabídka, odesílá uživatel |
| Sdílené focus rooms | ⬜ potřebuje backend |

Živý stav u parťáka v telefonu i focus rooms vyžadují server, kterým by data mezi zařízeními
tekla. Firebase zatím není zapojený — vyžaduje projekt založený pod účtem uživatele
(viz poznámka v [roadmap.md](roadmap.md)). Do té doby je parťák uložený jen lokálně a slouží
k tomu, aby aplikace věděla, komu zprávu nabídnout.

Aplikace to říká uživateli přímo na obrazovce Parťáci, ne až ve chvíli, kdy zjistí, že nic
nechodí.

## Stav ověření

Ověřeno na emulátoru: přidání parťáka, uložení do databáze, migrace schématu, přepínač
u profilu, nabídka po skončení bloku i otevření systémového výběru aplikací se správným
textem — bez cíle bloku.

Neověřeno: nic podstatného. Odeslání samotné zprávy už obstarává aplikace, kterou si uživatel
vybere.
