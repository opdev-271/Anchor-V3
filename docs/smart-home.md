# Chytrá domácnost — TP-Link Kasa

> Sprint 6 z [roadmap.md](roadmap.md), funkce [spec.md §5.3](spec.md#53-rozšíření-mimo-telefon--real-world-lock).
> Pokrývá akceptační kritérium [§14](spec.md#14-akceptační-kritéria-definition-of-done-pro-mvp) —
> „alespoň jedna smart home integrace funkčně vypne/zapne zařízení podle stavu session".

## Jak to funguje

Uživatel propojí účet TP-Link Kasa, vybere zásuvku a přiřadí ji fokus profilu. Při startu bloku
Kotva zásuvku vypne, po skončení ji vrátí do stavu, v jakém byla předtím.

| Vrstva | Soubor |
|---|---|
| Klient cloud API | [kasa_client.dart](../app/lib/features/smart_home/data/kasa_client.dart) |
| Řízení podle session | [smart_home_providers.dart](../app/lib/features/smart_home/application/smart_home_providers.dart) |
| UI | [smart_home_screen.dart](../app/lib/features/smart_home/presentation/smart_home_screen.dart) |

## Rozhodnutí, která stojí za vysvětlení

**Obnovuje se původní stav, ne „zapnuto".** Před vypnutím se zjistí, jestli byla zásuvka
vůbec zapnutá. Když byla televize vypnutá už předtím, na konci bloku ji aplikace nezapne —
to by uživatele překvapilo a bylo by to horší než nedělat nic. Když se stav nepodaří zjistit,
neobnovuje se nic.

**Selhání je neškodné.** Když se zásuvku nepodaří přepnout, fokus blok běží dál a chyba se jen
zaloguje. Blok nikdy nespadne kvůli tomu, že nejde spojení se zásuvkou — to by z doplňkové
funkce udělalo jediný bod selhání celé aplikace.

**Heslo se neukládá.** Použije se jen jednou při přihlášení; dál se pracuje výhradně
s přístupovým tokenem, který leží v `flutter_secure_storage` (na Androidu Keystore), ne
v běžné databázi ([§9](spec.md#9-soukromí-a-bezpečnost)).

**Cloud, ne lokální síť.** Kasa zásuvky umí i lokální protokol na portu 9999, ale ten funguje
jen když je telefon na stejné Wi-Fi. Cloud funguje odkudkoliv a uživatel nemusí řešit, na jaké
je zrovna síti.

## Limity

1. **API není veřejně dokumentované ani garantované.** TP-Link ho může kdykoliv změnit nebo
   omezit. Klient je proto psaný tak, aby selhání nic nerozbilo, a chyby překládá na věty,
   kterým uživatel rozumí („Nesprávné jméno nebo heslo", „Zásuvka je offline") místo obecného
   „něco se pokazilo".
2. **Vyžaduje internet** na telefonu i u zásuvky.
3. **Zásuvka vypíná napájení**, což je u televize tvrdé vypnutí. Aplikace na to upozorňuje —
   nepatří do ní nic, čemu by to mohlo uškodit.
4. **Jen Kasa.** Google Home, SmartThings a Matter vyžadují OAuth a partnerskou registraci
   u výrobce; jsou v datovém modelu připravené, ale neimplementované. Roadmapa je od začátku
   řadila za Kasu právě kvůli tomuhle nákladu.

## Stav ověření — čtěte pozorně

Ověřené je:

- protokol klienta proti mocku HTTP: přihlášení, seznam zařízení, čtení stavu, zapnutí
  i vypnutí, překlad chybových kódů, vypršelý token i výpadek sítě
  ([kasa_client_test.dart](../app/test/kasa_client_test.dart), 13 testů),
- obrazovka propojení účtu a chování bez propojeného účtu na emulátoru.

**Neověřené je samotné spínání skutečné zásuvky.** K tomu je potřeba účet TP-Link Kasa
a fyzické zařízení; ani jedno nemám k dispozici. Akceptační kritérium §14 č. 3 tedy zatím
**není potvrzené** — kód je hotový a otestovaný proti mocku, ale že reálná zásuvka sepne,
musí vyzkoušet někdo s hardwarem.

Doporučený postup ověření: propojit účet, v seznamu zařízení použít tlačítka „Vypnout teď"
a „Zapnout teď" (jsou tam právě proto, aby šlo spojení ověřit bez čekání na fokus blok),
teprve pak přiřadit zásuvku profilu a spustit blok.
