# Akceptační průchod (Sprint 10)

> Průchod [§14 checklistem](spec.md#14-akceptační-kritéria-definition-of-done-pro-mvp) bod po
> bodu. Datum běhu: **4. 8. 2026**, emulátor Pixel_4 (API 31), commit `fc1bce8` + oprava
> zprávy parťákovi.
>
> Checkbox v [spec.md](spec.md) záměrně needituju — spec je zadání, ne zápis o jeho plnění.
> Výsledek je tady.

## Souhrn

| # | Kritérium | Výsledek |
|---|---|---|
| 1 | Profil, session, reálné blokování na Androidu **i iOS** | ⚠️ **Android splněno, iOS ne** |
| 2 | Friction Exit nelze obejít bez zpomalovacího kroku | ✅ splněno |
| 3 | Smart home integrace reálně spíná zařízení | ❌ **neověřeno** — chybí účet i hardware |
| 4 | Parťák dostane stav session bez přístupu k cíli | ⚠️ **lokálně splněno**, doručení čeká na backend |
| 5 | Statistiky za 7/30 dní | ✅ splněno |
| 6 | Onboarding vysvětluje oprávnění před vyžádáním | ✅ splněno |
| 7 | Export a smazání všech dat jedním tlačítkem | ✅ splněno |

**Čtyři ze sedmi splněné, dvě částečně, jedna neověřená.** Tři nedodělky mají společnou
příčinu: chybí prostředí (macOS/Xcode), hardware (zásuvka Kasa) a backend (Firebase).
Nejde o nedokončený kód, ale o věci, které bez těch tří nejdou ověřit ani dopsat.

---

## 1. Profil, session a reálné blokování ⚠️

**Android splněno**, ověřeno celou cestou od nuly:

1. založen seznam blokovaných aplikací „Rozptyleni" s Chromem,
2. založen profil „Akceptacni blok" — 15 min, střední přísnost, cíl, přiřazený seznam,
3. blok spuštěn; otevření Chromu vystřídala `ShieldActivity` s cílem a odpočtem,
4. blok **dokončen**.

Dokončení ověřil nechtěný, ale nejpřísnější možný test: uprostřed bloku se **vybil počítač**
a emulátor tvrdě zhasl. Po restartu se session uzavřela sama jako `completed` s koncem
**22:37:46 — přesně v plánovaný čas**, ne v čase, kdy si toho aplikace po hodinách všimla.
Odpočet odvozený z reálného času (viz [architecture.md](architecture.md)) tím prošel ostrou
zkouškou, na kterou by naplánovaný test nedosáhl.

**iOS není splněné.** Celá nativní blokovací vrstva (Swift, `FamilyControls`/`ManagedSettings`)
chybí a nejde ji napsat ani ověřit bez macOS s Xcode. Flutter část je společná, takže po
doplnění modulu není potřeba měnit UI ani doménu.

## 2. Friction Exit ✅

Ověřeno včetně pokusů o obejití:

| Cesta | Výsledek |
|---|---|
| první obrazovka | žádná možnost rovnou skončit — jen dýchání, napsat proč, nebo zpět k práci |
| dýchání | odpočet proběhne, pak teprve nabídne rozhodnutí |
| reflexe | vyžaduje **minimálně 20 znaků**; s prázdným i tříznakovým textem tlačítko nepustí dál |
| tlačítko zpět | vrátí do běžícího bloku, session zůstává `active`, blokace běží |
| zabití procesu (`force-stop`) | blok běží dál, po startu appky pokračuje odpočet |

Ukončit jde **vždy** — ale až po zpomalení. To je přesně to, co §5.5 a §11 chtějí: bariéra
pro impulz, ne zámek.

**Poznámka k síle bariéry.** Blokaci lze vypnout tím, že uživatel Kotvu ve výběru aplikací
v systému zastaví (Android tím vypne službu přístupnosti) nebo službu vypne ručně. Ověřeno
opakovaně během průchodu. Běžná aplikace tomu zabránit nemůže a **ani nemá** — odpovídá to
§11. Není to obejití Friction Exitu: session tím nekončí, jen se přestane vynucovat překryv.

## 3. Smart home ❌

**Neověřeno.** Kód pro TP-Link Kasa je hotový ([smart-home.md](smart-home.md)) — přihlášení,
výpis zařízení, spínání i obnovení původního stavu — ale nikdy neběžel proti skutečné
zásuvce. Chybí obojí: účet Kasa i hardware. Uživatel navíc odmítl posílat živý požadavek na
TP-Link, takže ani přihlášení není otestované proti reálnému API.

Bez zásuvky ověřit nejde. Postup, až bude k dispozici, je v [smart-home.md](smart-home.md).

## 4. Zpráva parťákovi ⚠️

**Lokální část splněna.** Přidán parťák, u profilu zapnuta nabídka zprávy, blok ukončen dřív.
Aplikace nabídla text a předala ho systémovému výběru:

```
Fokus blok jsem ukončil/a dřív. 0 minut práce se ale počítá.

— posláno z aplikace Kotva
```

Cíl bloku („dopsat report") ani blokované aplikace v textu **nejsou** — což je jádro
kritéria. Hlídá to i test `partner_view_test.dart`.

**Nalezená vada, opravená během průchodu:** u bloku kratšího než minuta zpráva tvrdila
„0 minut práce se ale počítá". Vyznělo to posměšně, tedy opačně, než §11 chce. Nově se
o délce v takovém případě mlčí. Doplněn regresní test.

**Co splněné není:** kritérium říká „parťák **dostane notifikaci**". Kotva zprávu jen
připraví — odeslat ji musí uživatel. To je záměr (§11: aplikace nejedná navenek za
uživatele), ale skutečné doručení druhému člověku i živý stav „pracuje/nepracuje" vyžadují
backend, který neexistuje. Viz [accountability.md](accountability.md).

## 5. Statistiky ✅

Ověřeno proti obsahu databáze — obě období, týden i měsíc:

| Údaj | Zobrazeno | V databázi |
|---|---|---|
| Odpracovaný čas | 15 min | 15 + 0 min |
| Dokončené bloky | 1 | 1 |
| Kratší bloky | 1 | 1 |
| Dnů s prací | 2 | 3. a 4. 8. |

Sedí i tón (§11): kategorie se jmenuje **„Kratší bloky"**, ne selhání, a nikde není červená.
Sekce „Co ti vychází" správně mlčí: *„Na závěry je zatím málo dat… až bude mít aspoň 3 bloky."*

**Slabina tohohle běhu:** oba bloky spadly do posledních 7 dní, takže týden a měsíc ukázaly
stejná čísla — živý běh tedy hranici 30 dní nerozlišil. Období je ale parametrizované
(`summarize(days:)`) a hranici pokrývá test „ignoruje session mimo období".

## 6. Onboarding ✅

Čtyři kroky, projito znovu z Nastavení. Krok 2 vyjmenovává všechna tři oprávnění i s
důvodem a označením, která jsou volitelná; každý krok má sekci „Co je dobré vědět" s tím,
co appka neumí (nezabije cizí aplikaci, neblokuje weby, na iOS slabší).

Onboarding si sám o žádné oprávnění neříká — jen vysvětluje. Podrobně v
[onboarding.md](onboarding.md).

## 7. Export a smazání ✅

Otestováno v pořadí, v jakém to dává smysl: **nejdřív export, pak smazání.**

Export vytvořil `kotva-export-2026-08-04-1701.json` a předal ho systémovému výběru. Obsahoval
všechno z tohoto průchodu — profil, oba bloky i s cíli, parťáka, seznam s Chromem, dva pokusy
o ukončení a záznam souhlasu.

Smazání pak vyprázdnilo **všech 12 tabulek na 0 řádků**, zachovalo verzi schématu 8 a vyčistilo
i nativní `SharedPreferences`. Aplikace po výmazu naběhla čistě, v logu ani jedna výjimka.

---

## Co zbývá a na čem to visí

| Chybí | Blokuje | Bez čeho to nejde |
|---|---|---|
| iOS blokovací vrstva | kritérium 1 | macOS s Xcode |
| Ověření zásuvky Kasa | kritérium 3 | účet Kasa + hardware |
| Doručení parťákovi, živý stav, focus rooms | kritérium 4 | Firebase projekt |
| Kotva přes BLE — detekce odchodu a návratu | — | telefon s BLE rádiem ([anchors.md](anchors.md)) |
| Skutečné měření spotřeby v mA | — | fyzický telefon ([battery.md](battery.md)) |
| Průchod se zapnutým TalkBackem | — | ruční test na zařízení ([accessibility.md](accessibility.md)) |
| Blokování webů (§5.2) | — | otevřená otázka — vyžadovalo by číst obsah prohlížeče, proti §9 |
| Gating na `subscriptionTier` (§12) | — | rozhodnutí o monetizaci; zatím nezačato |
