# Architektura — Kotva

## Stack

| Vrstva | Volba | Zdůvodnění |
|---|---|---|
| Cross-platform framework | **Flutter (Dart)** | Zvoleno z alternativ v [spec.md § 7.1](spec.md#71-doporučený-stack) — lepší kontrola nad nativními pluginy pro Screen Time / Usage Stats než RN, silnější typový systém pro komplexní stavový stroj session/blocking. |
| Backend (MVP) | **Firebase** — Auth, Firestore, Cloud Functions, FCM | Přesně dle spec pro MVP; NestJS+PostgreSQL zvážit až při škálování mimo MVP. |
| Android blokovací vrstva | Nativní Kotlin modul: `UsageStatsManager` + `AccessibilityService` / `DevicePolicyManager` | |
| iOS blokovací vrstva | Nativní Swift modul: `FamilyControls` + `ManagedSettings` + `DeviceActivity` (iOS 16+) | |
| Smart home | TP-Link Kasa REST API (první), Google Home API / SmartThings API / Matter (další iterace) | |
| Notifikace | FCM + lokální notifikace (offline fallback) | |
| Analytika | On-device primárně, agregovaná telemetrie do backendu jen se souhlasem | Viz [spec.md § 9](spec.md#9-soukromí-a-bezpečnost) |

## Struktura projektu

Zadání v [spec.md § 7.2](spec.md#72-struktura-projektu-návrh) navrhuje `/native/android` a
`/native/ios` jako samostatné top-level složky. Ve Flutteru to **neodpovídá** tomu, jak framework
strukturálně vyžaduje natívní kód — Kotlin/Swift moduly musí fyzicky žít uvnitř
`app/android` a `app/ios` (standardní umístění pro `MethodChannel`/`EventChannel` platform
pluginy; jinak by je Flutter build toolchain nenašel). Logické rozdělení podle featur ale
zůstává zachováno jedna vrstva výš.

```
/app                                  # Flutter aplikace
  /lib
    /features
      /focus_session/                 # 5.1 — timer, rituál, streak
      /blocking/                      # 5.2 — Dart strana platform channels
      /smart_home/                    # 5.3 (zásuvky) — Kasa/Google Home/SmartThings klienti
      /accountability/                # 5.4 — partneři, focus rooms
      /stats/                         # 5.6
      /onboarding/                    # permissions education
    /core
      /design_system/                 # tokeny, komponenty (bez shame-based UI, viz spec §11)
      /networking/                    # Firestore/Functions klienti
      /storage/                       # offline-first lokální perzistence
      /permissions/                   # sjednocené permission-request flow + deep-linky do nastavení
  /android                            # nativní Kotlin platform channel implementace blokování
  /ios                                # nativní Swift platform channel implementace blokování
  /test
/backend
  /functions                          # Cloud Functions (streak přepočet, export/delete, FCM triggery)
  /firestore_rules                    # bezpečnostní pravidla — vynucují binární accountability visibility
/docs
  spec.md
  data-model.md
  architecture.md
  roadmap.md
  post-mvp.md
```

Poznámky k odchylkám od zadání:

- `/native/android`, `/native/ios` → `/app/android`, `/app/ios` (Flutter platform-channel
  konvence, viz výše).
- Wear OS / watchOS modul (zmíněný v [spec.md § 5.3](spec.md#53-rozšíření-mimo-telefon--real-world-lock))
  není v úvodní struktuře zahrnut jako vlastní adresář — přidá se jako `/wear` (Wear OS,
  Kotlin) a `/watch` (watchOS, Swift companion app) až ve chvíli, kdy na něj dojde řada v
  roadmapě (Sprint 5, označeno jako stretch goal).

## Datové zpracování a soukromí (napříč vrstvami)

- Usage stats a poloha: zpracování on-device (`core/storage`), do Firestore jde jen minimum
  nutné pro cross-device sync a accountability binární stav.
- `firestore_rules` vynucují, že `AccountabilityPartner` dotaz může vrátit jen odvozený
  `active/inactive` stav, nikdy `FocusSession.goalText` ani `BlockedAppList` obsah — pravidlo,
  ne jen UI konvence (viz [data-model.md](data-model.md#accountabilitypartner)).
