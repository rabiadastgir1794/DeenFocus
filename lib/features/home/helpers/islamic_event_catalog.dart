import '../../../l10n/app_localizations.dart';
import '../model/home_models.dart';

/// Stable kinds for major / weekly Islamic observances shown on Calendar.
enum IslamicEventKind {
  ramadanBegins,
  laylatAlQadr,
  eidAlFitr,
  dayOfArafah,
  eidAlAdha,
  islamicNewYear,
  mawlidAnNabi,
  ashura,
  jumuah,
  whiteDays,
  other,
}

/// Presentation helpers for [HomeIslamicEvent] titles from Aladhan.
abstract class IslamicEventCatalog {
  static const majorKinds = <IslamicEventKind>[
    IslamicEventKind.mawlidAnNabi,
    IslamicEventKind.ramadanBegins,
    IslamicEventKind.laylatAlQadr,
    IslamicEventKind.eidAlFitr,
    IslamicEventKind.dayOfArafah,
    IslamicEventKind.eidAlAdha,
    IslamicEventKind.islamicNewYear,
  ];

  static IslamicEventKind kindForTitle(String title) {
    final t = title.toLowerCase().trim();

    if (t.contains('jumu') || t == 'friday' || t.contains('jummah')) {
      return IslamicEventKind.jumuah;
    }
    if (t.contains('white day')) {
      return IslamicEventKind.whiteDays;
    }
    if (t.contains('ashura') || t.contains('ashuraa')) {
      return IslamicEventKind.ashura;
    }
    if (t.contains('mawlid') ||
        t.contains('milad') ||
        (t.contains('birthday') && t.contains('prophet')) ||
        t.contains('mawlid an-nabi') ||
        t.contains('mawlid al-nabi')) {
      return IslamicEventKind.mawlidAnNabi;
    }
    if ((t.contains('ramadan') || t.contains('ramadhan')) &&
        (t.contains('begin') ||
            t.contains('first') ||
            t.contains('start') ||
            t.contains('1st') ||
            t.contains('1 '))) {
      return IslamicEventKind.ramadanBegins;
    }
    // Day 1 of Ramadan often titled simply with Ramadan in holidays list
    if (t == 'ramadan' || t == 'ramadhan') {
      return IslamicEventKind.ramadanBegins;
    }
    if (t.contains('qadr') ||
        t.contains('decree') ||
        (t.contains('night') && t.contains('power'))) {
      return IslamicEventKind.laylatAlQadr;
    }
    if (t.contains('fitr')) {
      return IslamicEventKind.eidAlFitr;
    }
    if (t.contains('arafah') ||
        t.contains('arafa') ||
        t.contains('arafat') ||
        t.contains('wuquf')) {
      return IslamicEventKind.dayOfArafah;
    }
    if (t.contains('adha') || t.contains('sacrifice')) {
      return IslamicEventKind.eidAlAdha;
    }
    if (t.contains('new year') ||
        t.contains('islamic new') ||
        (t.contains('muharram') && (t.contains('1') || t.contains('first')))) {
      return IslamicEventKind.islamicNewYear;
    }
    return IslamicEventKind.other;
  }

  static bool isMajor(IslamicEventKind kind) => majorKinds.contains(kind);

  static bool isThisWeekObservance(IslamicEventKind kind) {
    return kind == IslamicEventKind.jumuah ||
        kind == IslamicEventKind.ashura ||
        kind == IslamicEventKind.dayOfArafah ||
        kind == IslamicEventKind.whiteDays ||
        kind == IslamicEventKind.other ||
        isMajor(kind);
  }

  static String localizedTitle(AppLocalizations l10n, IslamicEventKind kind) {
    switch (kind) {
      case IslamicEventKind.ramadanBegins:
        return l10n.calendarEventRamadanBegins;
      case IslamicEventKind.laylatAlQadr:
        return l10n.calendarEventLaylatAlQadr;
      case IslamicEventKind.eidAlFitr:
        return l10n.calendarEventEidAlFitr;
      case IslamicEventKind.dayOfArafah:
        return l10n.calendarEventDayOfArafah;
      case IslamicEventKind.eidAlAdha:
        return l10n.calendarEventEidAlAdha;
      case IslamicEventKind.islamicNewYear:
        return l10n.calendarEventIslamicNewYear;
      case IslamicEventKind.mawlidAnNabi:
        return l10n.calendarEventMawlid;
      case IslamicEventKind.ashura:
        return l10n.calendarEventAshura;
      case IslamicEventKind.jumuah:
        return l10n.calendarEventJumuah;
      case IslamicEventKind.whiteDays:
        return l10n.calendarEventWhiteDays;
      case IslamicEventKind.other:
        return '';
    }
  }

  static String localizedDescription(
    AppLocalizations l10n,
    IslamicEventKind kind,
  ) {
    switch (kind) {
      case IslamicEventKind.ramadanBegins:
        return l10n.calendarEventRamadanBeginsDesc;
      case IslamicEventKind.laylatAlQadr:
        return l10n.calendarEventLaylatAlQadrDesc;
      case IslamicEventKind.eidAlFitr:
        return l10n.calendarEventEidAlFitrDesc;
      case IslamicEventKind.dayOfArafah:
        return l10n.calendarEventDayOfArafahDesc;
      case IslamicEventKind.eidAlAdha:
        return l10n.calendarEventEidAlAdhaDesc;
      case IslamicEventKind.islamicNewYear:
        return l10n.calendarEventIslamicNewYearDesc;
      case IslamicEventKind.mawlidAnNabi:
        return l10n.calendarEventMawlidDesc;
      case IslamicEventKind.ashura:
        return l10n.calendarEventAshuraDesc;
      case IslamicEventKind.jumuah:
        return l10n.calendarEventJumuahDesc;
      case IslamicEventKind.whiteDays:
        return l10n.calendarEventWhiteDaysDesc;
      case IslamicEventKind.other:
        return '';
    }
  }

  static String displayTitle(AppLocalizations l10n, HomeIslamicEvent event) {
    final kind = kindForTitle(event.title);
    if (kind == IslamicEventKind.other) return event.title;
    return localizedTitle(l10n, kind);
  }

  static String displayDescription(
    AppLocalizations l10n,
    HomeIslamicEvent event,
  ) {
    final kind = kindForTitle(event.title);
    if (kind == IslamicEventKind.other) return '';
    return localizedDescription(l10n, kind);
  }
}

/// Localized Hijri month names (1–12).
String localizedHijriMonth(AppLocalizations l10n, int monthNumber) {
  switch (monthNumber) {
    case 1:
      return l10n.hijriMonthMuharram;
    case 2:
      return l10n.hijriMonthSafar;
    case 3:
      return l10n.hijriMonthRabiAlAwwal;
    case 4:
      return l10n.hijriMonthRabiAlThani;
    case 5:
      return l10n.hijriMonthJumadaAlAwwal;
    case 6:
      return l10n.hijriMonthJumadaAlThani;
    case 7:
      return l10n.hijriMonthRajab;
    case 8:
      return l10n.hijriMonthShaban;
    case 9:
      return l10n.hijriMonthRamadan;
    case 10:
      return l10n.hijriMonthShawwal;
    case 11:
      return l10n.hijriMonthDhuAlQadah;
    case 12:
      return l10n.hijriMonthDhuAlHijjah;
    default:
      return '';
  }
}

/// Moon phase display name from phase fraction (0–1).
String localizedMoonPhaseName(AppLocalizations l10n, double phaseFraction) {
  if (phaseFraction < 0.0625 || phaseFraction >= 0.9375) {
    return l10n.calendarMoonNew;
  }
  if (phaseFraction < 0.1875) return l10n.calendarMoonWaxingCrescent;
  if (phaseFraction < 0.3125) return l10n.calendarMoonFirstQuarter;
  if (phaseFraction < 0.4375) return l10n.calendarMoonWaxingGibbous;
  if (phaseFraction < 0.5625) return l10n.calendarMoonFull;
  if (phaseFraction < 0.6875) return l10n.calendarMoonWaningGibbous;
  if (phaseFraction < 0.8125) return l10n.calendarMoonLastQuarter;
  return l10n.calendarMoonWaningCrescent;
}
