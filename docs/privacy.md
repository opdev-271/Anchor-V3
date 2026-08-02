# Soukromí, souhlasy a data uživatele

> Sprint 8. Zadání: [spec.md §9](spec.md#9-soukromí-a-bezpečnost) a akceptační kritérium
> [§14](spec.md#14-akceptační-kritéria-definition-of-done-pro-mvp) — „všechna citlivá data
> lze exportovat a smazat jedním tlačítkem".

Všechno je na jedné obrazovce: **Nastavení → Soukromí a data**
([privacy_screen.dart](../app/lib/features/privacy/presentation/privacy_screen.dart)).
Kdyby bylo soukromí rozeseté po nastavení, uživatel by nikdy neviděl celkový obrázek.

## Granulární souhlasy

Tři kategorie podle §9 — `usage_stats`, `location`, `smart_home`
([`ConsentCategory`](../app/lib/core/storage/enums.dart)).

| Kategorie | K čemu je | Co se stane po odvolání |
|---|---|---|
| Čas v aplikacích | přehled času na obrazovce, denní limity | limity se smažou v databázi **i v nativní vrstvě**, přehled se skryje |
| Blízkost kotvy | BLE maják / NFC štítek u stolu | skenování se zastaví, uložené kotvy zůstanou |
| Chytrá domácnost | přihlášení k účtu a spínání zásuvky | odhlášení účtu, smazání tokenu i uložených zařízení |

### Souhlas není zaškrtávátko

Zásada, na které stojí celý sprint: **souhlas, který nic neovlivní, žádný souhlas není.**
Odvolání proto vždycky něco skutečně vypne — úklid je v `PrivacyController.revoke`, ne v UI,
aby dopadl stejně, ať se spustí odkudkoliv.

Vynucení má dvě vrstvy:

1. **Před vstupem do funkce** — `ConsentRequestScreen` je předčasný návrat z `build`
   dotčené obrazovky. Nejde o obal kolem obsahu: předčasný návrat zaručí, že se bez souhlasu
   ani nepostaví zbytek stromu, tedy ani plovoucí tlačítko, ani providery, které by si samy
   sáhly pro data.
2. **Za běhu** — hlídání kotvy se na souhlas ptá **před každým skenem**, ne jen při spuštění.
   Uživatel může souhlas odvolat uprostřed běžícího bloku a od té chvíle se skenovat nesmí.

### Proč je tabulka přírůstková

`ConsentRecords` drží **historii**, ne aktuální stav: udělení zakládá řádek, odvolání do něj
doplní `revokedAt`. Řádky se nepřepisují ani nemažou.

Kdyby tabulka držela jen jeden řádek na kategorii, odvolání by předchozí souhlas přepsalo
a nešlo by doložit, kdy vlastně platil — což je přesně to, co GDPR chce mít doložitelné.
Historie navíc jde do exportu.

Aktuální stav je tedy „existuje řádek **bez** `revokedAt`", ne „poslední řádek". Obojí dá
stejnou odpověď, ale první formulace nezávisí na pořadí — a při shodných časových razítkách
(rychlé přepnutí přepínače tam a zpět) pořadí definované není. Hlídá to test.

### Souhlas se při aktualizaci nedoplňuje

Migrace na `schemaVersion = 8` existujícím uživatelům souhlas **nepředvyplňuje**, ani když
funkce už používají. Souhlas, který si aplikace udělí sama za uživatele, žádný souhlas není;
po aktualizaci dostane normální dotaz.

## Export všech dat

Tlačítko sestaví JSON, uloží ho do souboru a předá systémovému výběru — uživatel si vybere,
kam ho uloží nebo komu pošle. Aplikace **nikdy neodesílá sama**, stejně jako u zprávy
parťákovi (§11).

Rozhodnutí:

- **Vlastní mapování místo `toJson()` z driftu.** Drift serializuje `DateTime` jako počet
  milisekund a enumy jako indexy. Export má být čitelný pro člověka, tak jdou časy ven
  v ISO-8601 **i s posunem zóny** (bez něj by nešlo poznat, v jaké zóně vznikly) a enumy
  pojmenované. Explicitní mapování hlavně znamená, že se do exportu nedostane nový sloupec
  sám od sebe.
- **Slovník je stejný jako na obrazovkách.** Přerušený blok je v exportu `kratsi`, ne
  `failed` ani `selhani` — tón aplikace neobviňuje ani v datech, která si uživatel odnese
  (§11). Hlídá to test.
- **Token k účtu chytré domácnosti v exportu není.** Je to přístupový klíč k cizí službě, ne
  data o fokusu, a v souboru, který uživatel pošle e-mailem, nemá co dělat. Export to o sobě
  říká v poli `poznamka` — nevynechává se to mlčky.
- **Soubor, ne text.** Export může mít stovky kilobajtů; intent s takovým množstvím textu by
  systém odmítl.

Soubor jde ven jako `content://` URI přes `FileProvider` (`file://` Android od verze 7
odmítá — `FileUriExposedException`). Provider je `exported="false"` a
[`file_paths.xml`](../app/android/app/src/main/res/xml/file_paths.xml) mu povoluje **jen**
adresář `exporty/` v cache — ne celé app-private úložiště. Cílová aplikace dostane dočasné
oprávnění k jednomu souboru, ne přístup do adresáře Kotvy.

Předchozí export se před vytvořením nového smaže, aby se v cache nehromadily kopie všech dat.

## Smazání všech dat

Stav je rozprostřený do **tří** úložišť a smazat jen jedno by nechalo aplikaci ve stavu, který
vypadá prázdně, ale není:

1. **SQLite** — profily, bloky, kotvy, parťáci, souhlasy.
2. **Nativní `SharedPreferences`** (`kotva_blocking`, `kotva_limits`, `kotva_notif`) — běžící
   blokace a denní limity, které vynucuje služba přístupnosti mimo Flutter engine. Databáze
   se k nim nedostane.
3. **`flutter_secure_storage`** — token k účtu chytré domácnosti.

Pořadí kroků v `PrivacyController.deleteEverything` není libovolné:

1. **Ukončit běžící blok normální cestou.** Odběratelé stavu session tím dostanou šanci
   uklidit po sobě — hlavně vrátit chytrou zásuvku do původního stavu. Smazat session rovnou
   z databáze by zásuvku nechalo vypnutou a uživatel by netušil proč.
2. **Odhlásit účet chytré domácnosti** — `signOut` si v databázi ještě hledá, která zařízení
   odebrat, takže musí přijít před jejím výmazem.
3. **Nativní stav.**
4. **Databáze.** Maže se obsah tabulek, ne soubor: schéma i verze zůstávají, takže po smazání
   běží stejná databáze dál a nespustí se migrace znovu od nuly.

### Co se nemaže a proč

- **Volba vzhledu.** Není to údaj o uživateli ani o jeho chování a přepnutí motivu bez
  varování by vypadalo jako chyba. Obrazovka to říká nahlas v potvrzovacím dialogu.
- **Systémová oprávnění.** Zůstávají udělená, dokud je uživatel nevypne v nastavení telefonu —
  aplikace je odebrat nemůže. Obrazovka to uvádí v sekci „Co je dobré vědět".
- **Kopie exportů, které si uživatel uložil jinam.** Ty už Kotva neovládá.

## Co zatím chybí

- **Purge dat z backendu.** §9 chce smazání „z appky **i z backendu**". Backend zatím není
  (viz [roadmap.md](roadmap.md) — Firebase není zapojený), takže není co mazat: všechna data
  jsou v telefonu. Až Firestore přibude, doplní se Cloud Function jako další krok
  v `deleteEverything`. Obrazovka uživateli neslibuje víc, než co appka umí — říká, že
  cloudová záloha neexistuje.
- **iOS.** Nativní část smazání (`clearNativeData`) je jen pro Android, stejně jako blokovací
  vrstva. Na jiných platformách kanál vrátí „nedostupné" a zbytek proběhne.
