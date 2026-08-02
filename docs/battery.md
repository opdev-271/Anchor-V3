# Spotřeba baterie a offline režim

> Sprint 9. Zadání: [spec.md §13](spec.md#13-nefunkční-požadavky) — cíl pod 3 % denní
> spotřeby, plus [§8](spec.md#8-technická-omezení-která-musíš-zohlednit) (úsporný scanning
> interval 60–90 s) a offline-first provoz.

## Dvě věci, které mohou žrát baterii

### 1. Skenování Bluetooth majáku

Sken běží v oknech: **6 s poslouchání, pak 75 s ticho** (`AnchorScanner.SCAN_WINDOW_MS`
a `SCAN_PERIOD_MS`). To je duty cycle **8 %** a rozestup sedí do rozmezí, které žádá §8.

Zásadní je, že sken běží **jen po dobu fokus bloku s přiřazenou BLE kotvou**, ne celý den.
Hlídat přítomnost, když uživatel nepracuje, nemá smysl.

Odhad při 20 mA odběru rádia během okna (typické pro `SCAN_MODE_LOW_LATENCY` na mobilním
SoC) vychází na průměrných **1.6 mA** po dobu bloku:

| Hodin bloků denně | Náklad | Na baterii 2800 mAh | Podíl rozpočtu 3 % |
|---|---|---|---|
| 2 h | 3.2 mAh | 0.11 % | 4 % |
| 4 h | 6.4 mAh | 0.23 % | 8 % |
| 8 h | 12.8 mAh | 0.46 % | 15 % |

I krajní případ — osm hodin bloků denně na nejmenší uvažované baterii — spotřebuje jen
šestinu povoleného rozpočtu. Rezerva je dost velká na to, aby ji neshodila ani chyba
v odhadu odběru o 100 %.

### 2. Měření času v aplikacích

Hlídka limitů v `KotvaAccessibilityService` se ptá `UsageStatsManager` po **15 s**
(`LIMIT_CHECK_INTERVAL_MS`) — a jen tehdy, když vůbec nějaký limit existuje
(`scheduleWatchdog` se jinak rovnou ukončí). Kdo limity nepoužívá, neplatí za ně nic.

**Změřeno** na emulátoru s navázanou službou přístupnosti a dvěma aktivními limity:

```
okno: 240 s
CPU čas aplikace: 0.01 s  (0.00 % jednoho jádra)
přepočet na 24 h: 0.1 min CPU
```

Proces byl po celou dobu ve stavu `S (sleeping)`. Šestnáct dotazů na `queryEvents` za
čtyři minuty stálo deset milisekund CPU — v rozpočtu se to neprojeví.

## Co změřit nešlo

**Skutečný odběr v mA.** Emulátor nemá BLE rádio ani reálné počítadlo baterie; čísla
z `dumpsys batterystats` jsou tam syntetická. Tabulka výše je proto **výpočet**, ne měření —
opřený o změřený duty cycle a o publikovaný odběr BLE skenu, ne o odhad zátěže Kotvy.

Skutečné ověření vyžaduje fyzický telefon a nejlépe delší běh: nechat den běžet s kotvou
a limity a porovnat `Nastavení → Baterie` proti dni bez nich. Patří k tomu, co zbývá ověřit
na hardwaru — viz [anchors.md](anchors.md).

## Offline režim

Ověřeno na emulátoru s vypnutou Wi-Fi i mobilními daty (`ping` hlásil
`Network is unreachable`):

- fokus blok šlo **spustit i odpočítávat** bez sítě,
- **blokování aplikací fungovalo** — otevření Chromu vystřídala `ShieldActivity` s cílem
  bloku a zbývajícím časem,
- ukončení přes Friction Exit proběhlo normálně a blokace se vypnula.

Je to očekávané, ne šťastná náhoda: aplikace je offline-first, veškerý stav drží lokální
SQLite a blokování stojí na `SharedPreferences` čtených nativní vrstvou. **Síť zatím
nepotřebuje nic kromě chytré zásuvky** — ta bez internetu nesepne a Kotva to snese, protože
selhání zásuvky blok nesráží (viz [smart-home.md](smart-home.md)).

Sync po obnovení připojení ověřit nejde — synchronizace neexistuje, dokud není backend.

## Poznámka k testování

Služba přístupnosti se **vypne při každé přeinstalaci aplikace i po `am force-stop`**.
Při ověřování blokace to jednou vypadalo jako chyba: shield nenaskočil, ačkoliv byl blok
aktivní. Příčinou byla vypnutá služba, ne blokace. Před každým testem blokování se proto
vyplatí zkontrolovat:

```bash
adb shell dumpsys accessibility | grep -A1 "Bound services"
```
