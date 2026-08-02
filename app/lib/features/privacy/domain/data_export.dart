import '../../../core/storage/database.dart';
import '../../../core/storage/enums.dart';

/// Sestavení kompletního exportu dat (docs/spec.md §9, akceptační kritérium
/// §14 „všechna citlivá data lze exportovat").
///
/// Proč vlastní mapování místo `toJson()` z driftu:
///
///  - drift serializuje `DateTime` jako počet milisekund a enumy jako indexy.
///    Export má být čitelný pro **člověka**, ne jen pro appku, takže časy jdou
///    ven v ISO-8601 a enumy pojmenované.
///  - export je závazek vůči uživateli, ne vedlejší efekt schématu. Explicitní
///    mapování znamená, že nový sloupec v databázi se v exportu neobjeví sám
///    od sebe — a hlavně že se do něj omylem nedostane něco, co tam nepatří.
///
/// **Co v exportu záměrně není:** přihlašovací token k účtu chytré domácnosti.
/// Je to přístupový klíč k cizí službě, ne uživatelova data o fokusu; v souboru,
/// který uživatel pošle e-mailem nebo uloží na disk, nemá co dělat. Export to
/// o sobě říká v poli `poznamka`.
class DataExport {
  const DataExport({
    required this.exportedAt,
    required this.profiles,
    required this.sessions,
    required this.frictionEvents,
    required this.blockedLists,
    required this.blockedApps,
    required this.profileListLinks,
    required this.anchors,
    required this.anchorEvents,
    required this.smartDevices,
    required this.partners,
    required this.appLimits,
    required this.consents,
  });

  final DateTime exportedAt;
  final List<FocusProfile> profiles;
  final List<FocusSession> sessions;
  final List<FrictionExitEvent> frictionEvents;
  final List<BlockedAppList> blockedLists;
  final List<BlockedApp> blockedApps;
  final List<ProfileBlockedList> profileListLinks;
  final List<AnchorPoint> anchors;
  final List<AnchorEvent> anchorEvents;
  final List<SmartDevice> smartDevices;
  final List<AccountabilityPartner> partners;
  final List<AppUsageLimit> appLimits;
  final List<ConsentRecord> consents;

  /// Verze formátu. Kdyby se struktura někdy změnila, starý soubor půjde
  /// poznat podle čísla, ne podle hádání ze struktury.
  static const formatVersion = 1;

  Map<String, Object?> toJson() => {
        'format': 'kotva-export',
        'verzeFormatu': formatVersion,
        'vytvorenoV': _time(exportedAt),
        'poznamka': 'Export obsahuje všechna data, která Kotva uchovává '
            'v telefonu. Přihlašovací token k účtu chytré domácnosti v něm '
            'záměrně není — je to přístupový klíč k účtu, ne tvoje data.',
        'fokusProfily': profiles.map(_profile).toList(),
        'fokusBloky': sessions.map(_session).toList(),
        'pokusyOUkonceni': frictionEvents.map(_frictionEvent).toList(),
        'seznamyBlokovanychAplikaci': blockedLists.map(_blockedList).toList(),
        'blokovaneAplikace': blockedApps.map(_blockedApp).toList(),
        'vazbyProfilSeznam': profileListLinks.map(_profileListLink).toList(),
        'kotevniBody': anchors.map(_anchor).toList(),
        'nepritomnostiUKotvy': anchorEvents.map(_anchorEvent).toList(),
        'chytraZarizeni': smartDevices.map(_smartDevice).toList(),
        'partaci': partners.map(_partner).toList(),
        'denniLimity': appLimits.map(_appLimit).toList(),
        'souhlasy': consents.map(_consent).toList(),
      };

  Map<String, Object?> _profile(FocusProfile p) => {
        'id': p.id,
        'nazev': p.name,
        'delkaMinut': p.durationMinutes,
        'cil': p.goalText,
        'prisnost': p.strictness.name,
        'kotevniBodId': p.anchorPointId,
        'chytreZarizeniId': p.smartDeviceId,
        'nabidnoutZpravuPartakovi': p.notifyPartner,
        'vytvoreno': _time(p.createdAt),
        'zmeneno': _time(p.updatedAt),
      };

  Map<String, Object?> _session(FocusSession s) => {
        'id': s.id,
        'profilId': s.profileId,
        'zacatek': _time(s.startedAt),
        'konec': _time(s.endedAt),
        'planovanaDelkaMinut': s.plannedDurationMinutes,
        'cil': s.goalText,
        // `interrupted` je „kratší blok", ne selhání (docs/spec.md §11).
        // Export používá stejný slovník jako obrazovky.
        'stav': _sessionStatus(s.status),
        'prisnost': s.strictness.name,
      };

  Map<String, Object?> _frictionEvent(FrictionExitEvent e) => {
        'id': e.id,
        'blokId': e.sessionId,
        'kdy': _time(e.triggeredAt),
        'krok': e.stepType.name,
        'zamysleni': e.reflectionText,
        'vysledek': e.outcome.name,
      };

  Map<String, Object?> _blockedList(BlockedAppList l) => {
        'id': l.id,
        'nazev': l.name,
        'vytvoreno': _time(l.createdAt),
        'zmeneno': _time(l.updatedAt),
      };

  Map<String, Object?> _blockedApp(BlockedApp a) => {
        'seznamId': a.listId,
        'balicek': a.packageName,
        'nazev': a.appLabel,
      };

  Map<String, Object?> _profileListLink(ProfileBlockedList l) => {
        'profilId': l.profileId,
        'seznamId': l.listId,
      };

  Map<String, Object?> _anchor(AnchorPoint a) => {
        'id': a.id,
        'nazev': a.name,
        'typ': a.type.name,
        'identifikator': a.tagIdentifier,
        'naposledyVidenO': _time(a.lastSeenAt),
        'vytvoreno': _time(a.createdAt),
      };

  Map<String, Object?> _anchorEvent(AnchorEvent e) => {
        'id': e.id,
        'kotevniBodId': e.anchorPointId,
        'blokId': e.sessionId,
        'odchod': _time(e.leftAt),
        'navrat': _time(e.returnedAt),
        'zamysleni': e.reflectionText,
      };

  Map<String, Object?> _smartDevice(SmartDevice d) => {
        'id': d.id,
        'nazev': d.name,
        'poskytovatel': d.provider.name,
        'idUPoskytovatele': d.externalDeviceId,
        'vytvoreno': _time(d.createdAt),
      };

  Map<String, Object?> _partner(AccountabilityPartner p) => {
        'id': p.id,
        'jmeno': p.name,
        'kontakt': p.contact,
        'vytvoreno': _time(p.createdAt),
      };

  Map<String, Object?> _appLimit(AppUsageLimit l) => {
        'balicek': l.packageName,
        'nazev': l.appLabel,
        'denniMinuty': l.dailyMinutes,
        'intenzita': l.intensity.name,
        'zmeneno': _time(l.updatedAt),
      };

  Map<String, Object?> _consent(ConsentRecord c) => {
        'kategorie': c.category.name,
        'udeleno': _time(c.grantedAt),
        'odvolano': _time(c.revokedAt),
      };

  static String _sessionStatus(SessionStatus status) => switch (status) {
        SessionStatus.active => 'probiha',
        SessionStatus.completed => 'dokonceny',
        SessionStatus.interrupted => 'kratsi',
      };

  /// ISO-8601 v lokálním čase i s posunem. `toIso8601String()` samo o sobě
  /// posun neuvádí, takže by u lokálních časů nešlo poznat, v jaké zóně vznikly.
  static String? _time(DateTime? value) {
    if (value == null) return null;
    if (value.isUtc) return value.toIso8601String();

    final offset = value.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final abs = offset.abs();
    final hours = abs.inHours.toString().padLeft(2, '0');
    final minutes = (abs.inMinutes % 60).toString().padLeft(2, '0');
    return '${value.toIso8601String()}$sign$hours:$minutes';
  }
}

/// Název souboru s exportem. Datum a čas v názvu proto, aby si uživatel
/// nepřepsal starší export novějším.
String exportFileName(DateTime at) {
  String two(int v) => v.toString().padLeft(2, '0');
  return 'kotva-export-${at.year}-${two(at.month)}-${two(at.day)}'
      '-${two(at.hour)}${two(at.minute)}.json';
}
