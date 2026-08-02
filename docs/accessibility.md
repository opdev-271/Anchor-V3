# Přístupnost

> Sprint 9. Zadání: [spec.md §13](spec.md#13-nefunkční-požadavky) — dynamické písmo,
> odečítač obrazovky, kontrast WCAG AA.

## Kontrast: co ukázalo měření

Motiv o sobě od začátku tvrdil, že páry barev splňují WCAG AA. **Při prvním skutečném
změření propadly tři.** Tvrzení v komentáři není totéž co ověřená vlastnost, proto to teď
hlídá [`test/contrast_test.dart`](../app/test/contrast_test.dart).

| Pár | Bylo | Práh | Řešení |
|---|---|---|---|
| destruktivní barva na tmavém povrchu | **2.25** | 4.5 | nová [`destructiveDark`](../app/lib/core/design_system/app_colors.dart) → 5.67 |
| primární barva na tmavém povrchu | **4.42** | 4.5 | nová `anchorDark` → 5.10 |
| „dokončeno" na tmavém povrchu | **3.01** | 3.0 (ikona) | `completedDark`, ať to není na hraně |

Nejhorší z nich byl ten první: text **„Smazat všechna data"** byl v tmavém režimu hůř
čitelný než zbytek obrazovky. U nevratné akce je to přesně obráceně, než má být.

Příčina je u všech tří stejná — odstín vyladěný na světlé pozadí na tmavém neplatí. Tmavý
režim proto má vlastní varianty, ne jen jinak namíchané pozadí.

Prahy podle WCAG 2.1 AA: **4.5:1** pro běžný text, **3:1** pro ikony a nosné prvky. Popisky
sekcí primární barvou jsou 14 sp, tedy běžný text — proto u nich platí přísnější práh, ne
ten pro velký text.

## Dynamické písmo

Aplikace nikde nepřepisuje `textScaleFactor` ani `MediaQuery.textScaler` a nemá jedinou
natvrdo psanou velikost písma mimo návrhový systém. Systémové zvětšení tedy platí.

To samo o sobě nestačí — text se musí i **vejít**. Testy proto vykreslují onboarding
a prstenec odpočtu při zvětšení 1.0×, 1.3× a 2.0× a kontrolují, že nic nepřeteče; přetečení
hlásí Flutter jako výjimku, takže test spadne. Navíc se ověřuje, že při 2.0× zůstane
dosažitelné tlačítko „Dál" — kdyby ho odsunul přetečený text, uživatel by se ze sekvence
nedostal.

## Odečítač obrazovky (TalkBack)

Doplněno tam, kde informaci nesl **jen tvar nebo barva**:

- **Prstenec odpočtu.** Oblouk je kreslený na plátno, takže z něj odečítač nepřečte nic —
  uživateli by zbyl jen čas uprostřed, bez informace, jak daleko blok je. Nový popisek se
  slučuje s časem do jednoho uzlu, takže TalkBack přečte „Průběh bloku, 12:34" a jako
  hodnotu procenta. Ověřeno i na emulátoru: `content-desc` uzlu je `22 %, Průběh bloku…`.
- **Tečky onboardingu.** Bez popisku by z nich byla jen řada prázdných obdélníků; teď se
  čtou jako „Krok 2 ze 4".
- **Přepínač zobrazení hesla** u přihlášení ke Kasa účtu byl jediný `IconButton` bez
  popisku — odečítač by přečetl jen „tlačítko".

Ostatní ikonová tlačítka popisek už měla, což potvrdil průchod celým `lib/`.

## Co zůstává neověřené

- **Skutečný průchod TalkBackem.** Testy ověřují, že sémantické uzly mají správné popisky
  a hodnoty. Jak se s aplikací opravdu pracuje se zapnutým odečítačem — pořadí čtení,
  gesta, srozumitelnost — se dá posoudit jen ručním průchodem na zařízení.
- **Kontrast obrázkových prvků**, které nejsou z palety (ikona aplikace, přechod na hero
  kartě). Test pokrývá barevné tokeny, ne rastry.
