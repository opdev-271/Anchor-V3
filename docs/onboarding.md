# Onboarding

> Sprint 9. Zadání: [spec.md §8](spec.md#8-technická-omezení-která-musíš-zohlednit)
> („popiš omezení uživateli v onboardingu, ne až po instalaci") a
> [§10](spec.md#10-uxui--popis-obrazovek). Plní akceptační kritérium
> [§14](spec.md#14-akceptační-kritéria-definition-of-done-pro-mvp): *onboarding jasně
> vysvětluje všechna požadovaná oprávnění před jejich vyžádáním*.

Čtyři kroky: **koncept → oprávnění → Real World Lock → kotevní bod**. Skladba odpovídá
§10 („vysvětlení proč potřebujeme Usage Stats, ukázka Real World Lock, výběr první kotvy").

## Onboarding sám o žádné oprávnění nežádá

Nejdůležitější rozhodnutí celého sprintu. Onboarding **vysvětlí**, co bude potřeba a proč;
o svolení si řekne až konkrétní funkce, ve chvíli, kdy ji uživatel otevře.

Vyžádat všechno dopředu je svůdné — appka by měla oprávnění hned a nemusela řešit prázdné
stavy. Znamenalo by to ale nechat uživatele odklikat oprávnění dřív, než ví, k čemu jsou,
což je přesně ten vzorec, proti kterému §8 míří. Souhlas daný „aby to zmizelo" není souhlas.

Prakticky to drží [`ConsentRequestScreen`](../app/lib/features/privacy/presentation/consent_gate.dart)
ze Sprintu 8: každá funkce si o svolení říká sama, se svým vysvětlením a v kontextu.
Onboarding jen zkracuje cestu — poslední krok nabízí „Nastavit kotvu teď", což vede na
tutéž obrazovku se souhlasem, nic neobchází.

Aby to nebylo překvapení, stojí to pod tlačítkem na každém kroku: *„Oprávnění po tobě Kotva
chtít nebude teď — řekne si o ně až u funkce, které se týkají."*

## Přeskočit jde odkudkoliv

Tlačítko **Přeskočit** je vidět od prvního kroku. Uvítací sekvence nesmí držet uživatele
jako rukojmí — je to stejná zásada jako u Friction Exitu (§11): aplikace smí zpomalit,
ne zamknout.

Ze stejného důvodu je i „výběr první kotvy" ze §10 **nabídka, ne krok ke splnění**. Kotva
je volitelná funkce (§8) a bez majáku musí zbytek fungovat beze změny, takže projít dál
musí jít i bez ní.

Onboarding se nepamatuje, jestli uživatel prošel do konce, nebo přeskočil. Nebylo by to
k čemu a znamenalo by to sledovat, jak pozorně četl.

## Co se říká nahlas

§8 chce omezení popsat v onboardingu, ne až po instalaci. Každý krok má proto sekci
**„Co je dobré vědět"**:

- Kotva cizí aplikaci nedokáže vypnout — jen ji překryje.
- Jednotlivé weby blokovat neumí; šlo by to jen čtením obsahu prohlížeče, což dělat nechce
  (§9). Zablokovat jde celý prohlížeč.
- Na iPhonu bude blokování fungovat jinak a slaběji — Apple ho pouští jen přes Screen Time.
- NFC neumí hlídat přítomnost průběžně; odchod od stolu tudy poznat nejde.
- Kotva neurčuje polohu, vidí jen dosah konkrétního majáku.
- A hned v prvním kroku: **kratší blok není selhání** (§11).

Volitelná oprávnění jsou označená jako volitelná. Bez toho rozlišení by uživatel odklikával
všechno stejně a nevěděl, co si může odpustit.

## Kde texty žijí

V [`domain/onboarding_steps.dart`](../app/lib/features/onboarding/domain/onboarding_steps.dart)
jako čistá data, ne ve widgetech — stejně jako texty souhlasů. Jde je testovat a nedají se
omylem rozejít mezi onboardingem a obrazovkou, která si o totéž oprávnění říká doopravdy.

## Stav dokončení

Příznak žije v `SharedPreferences`, **ne v databázi**. Smazání všech dat (§9) vyprázdní
databázi, ale onboarding se tím spustit znovu nemá: uživatel appku zná a přehrát mu uvítací
sekvenci po smazání dat by vypadalo jako chyba.

Projít ho znovu jde kdykoliv z **Nastavení → Projít úvodní seznámení znovu**. Otevřený
z nastavení se chová jinak než při prvním spuštění — musí se odebrat ze zásobníku, zatímco
při prvním spuštění je kořenem stromu a zmizí přepnutím příznaku. Bez téhle větve by druhá
cesta vedla na obrazovku, ze které nejde odejít.
