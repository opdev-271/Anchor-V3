# Kotevní body — co jde, co nejde a proč

> Sprint 5 z [roadmap.md](roadmap.md), funkce [spec.md §5.3](spec.md#53-rozšíření-mimo-telefon--real-world-lock)
> („Real World Lock" — Bluetooth/NFC kotevní bod). Plní požadavek
> [§15](spec.md#15-co-od-tebe-očekávám-jako-výstup) popsat u každé funkce použité
> API a jeho limity.

## Co je hotové

Uživatel si spáruje kotvu — Bluetooth maják nebo NFC štítek — a přiřadí ji fokus profilu.
Během bloku Kotva sleduje, jestli je maják v dosahu. Když zmizí na déle než tři minuty,
zaznamená to jako odchod; po návratu nabídne poznámku pro vlastní reflexi.

| Vrstva | API | Soubor |
|---|---|---|
| Hledání majáků | `BluetoothLeScanner` | [AnchorScanner.kt](../app/android/app/src/main/kotlin/cz/kotva/AnchorScanner.kt) |
| Čtení NFC štítku | `NfcAdapter.enableReaderMode` | [AnchorPlugin.kt](../app/android/app/src/main/kotlin/cz/kotva/AnchorPlugin.kt) |
| Vyhodnocení přítomnosti | čistý Dart, pokryto testy | [anchor_presence.dart](../app/lib/features/anchor/domain/anchor_presence.dart) |
| Řízení sledování | Riverpod, vázané na stav session | [anchor_providers.dart](../app/lib/features/anchor/application/anchor_providers.dart) |

## Spotřeba baterie

[§8](spec.md#8-technická-omezení-která-musíš-zohlednit) vyžaduje úsporný interval, ne souvislé
sledování. Skenuje se proto v **oknech**: ~6 s poslechu, pak 75 s ticha (zadání doporučuje
60–90 s). To je zhruba osmiprocentní zátěž rádia místo stoprocentní.

Sledování navíc běží **jen po dobu fokus bloku**. Mimo blok se neskenuje vůbec — hlídat
přítomnost, když uživatel nepracuje, nemá smysl a stálo by to baterii zbytečně.

Cenou je zpoždění: krátké odskočení od stolu se nemusí zaznamenat. Pro účel aplikace to
nevadí — zajímá nás „byl pryč deset minut", ne „vstal na osm vteřin".

## Proč tři minuty

Jedno nezdařené okno **není** odchod. Bluetooth signál kolísá; stačí položit telefon za
monitor. Za odchod se považuje teprve to, když maják chybí déle než tři minuty. Kratší práh
by hlásil odchody, které se nestaly, a data pro reflexi by byla k ničemu.

Nepřítomnost se počítá **od posledního spatření**, ne od okamžiku vyhodnocení — jinak by
každá vycházela o práh kratší, než ve skutečnosti byla.

## Limity, které je potřeba znát

1. **NFC neumí hlídat přítomnost.** Android nedovolí číst štítky na pozadí — tag se přečte
   jedině tehdy, když je aplikace v popředí a uživatel k němu telefon přiloží. NFC kotva tedy
   funguje jako **rituál** („přilož a začni"), ne jako čidlo blízkosti. Odchod od stolu jí
   poznat nejde. Aplikace to říká už při volbě typu kotvy.
2. **Maják musí vysílat.** Fungují iBeacony, štítky typu Tile nebo sluchátka v párovacím
   režimu. Vypnuté zařízení v zásuvce ne.
3. **Adresa nemusí být stálá.** Řada zařízení kvůli soukromí mění MAC adresu v řádu minut;
   takový maják se po čase tváří jako cizí a kotva přestane fungovat. Spolehlivé jsou majáky
   se stálým identifikátorem. Aplikace na to upozorňuje při párování, ne až když to přestane
   fungovat.
4. **Sledování běží jen s aplikací.** Kotva nemá službu na popředí, takže po delším odsunutí
   do pozadí může systém časovač uspat. Pro spolehlivé sledování celého dlouhého bloku by
   bylo potřeba přidat foreground service s trvalou notifikací — vědomě odloženo, protože
   trvalá notifikace jde proti klidnému tónu aplikace a pro typickou délku bloku to zatím
   není nutné.

## Oprávnění

| Oprávnění | K čemu | Bez něj |
|---|---|---|
| `BLUETOOTH_SCAN` | hledání majáku | Bluetooth kotva nefunguje |
| `NFC` | čtení štítku | NFC kotva nefunguje |

`BLUETOOTH_SCAN` je v manifestu označené `neverForLocation`. Bez toho by Android vyžadoval
i polohové oprávnění, protože z okolních majáků lze polohu odvodit. Kotva polohu neodvozuje
a nechce ji — deklarace to říká systému i uživateli ([§9](spec.md#9-soukromí-a-bezpečnost)).
Polohové oprávnění se vyžaduje jen na Androidu 11 a starším, kde `BLUETOOTH_SCAN` neexistuje;
v manifestu je proto omezené `maxSdkVersion="30"`.

## Tón otázky při návratu

Zadání i [§11](spec.md#11-tón-etika-a-wellbeing-principy-závazné-pro-copy-i-logiku) to říkají
jasně: **bez obviňování**. Aplikace se neptá „proč jsi odešel" — nabízí poznámku pro vlastní
reflexi a „Přeskočit" je rovnocenná volba, ne únik. U krátké nepřítomnosti neuvádí ani počet
minut, aby to nepůsobilo jako měření prohřešku. Hlídá to i test.

## Stav ověření

Na emulátoru je ověřený celý řetězec kromě samotné detekce: párovací obrazovka, žádost
o oprávnění, spuštění skenu i prázdný výsledek. **Detekci odchodu a návratu nelze na emulátoru
ověřit** — nemá skutečné BLE rádio a v dosahu žádný maják. Logika vyhodnocení je pokrytá
jednotkovými testy ([anchor_presence_test.dart](../app/test/anchor_presence_test.dart));
chování s reálným majákem je potřeba vyzkoušet na fyzickém telefonu.
