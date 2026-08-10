// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'Glaube. Fokus. Konsistenz';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Gebetsmodus. Kindermodus. Schlafmodus.';

  @override
  String get welcomeDescription =>
      'Verfolgen Sie Ihre Gebete, lesen Sie den Koran, zählen Sie Tasbih und bauen Sie bedeutungsvolle Streaks auf – alles an einem Ort.';

  @override
  String get skip => 'Überspringen';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String get continueButton => 'Weitermachen';

  @override
  String get continueForFree => 'Vielleicht später — zuerst die App erkunden';

  @override
  String get getStarted => 'Meine 7-Tage-Testversion starten';

  @override
  String get language => 'Sprache';

  @override
  String get cancel => 'Stornieren';

  @override
  String get ok => 'OK';

  @override
  String get openSettings => 'Öffnen Sie Einstellungen';

  @override
  String get locationRequired => 'Standort erforderlich';

  @override
  String get locationRequiredMessage =>
      'Zur Berechnung der genauen Gebetszeiten und der Qibla-Richtung ist ein Standortzugriff erforderlich. Sie müssen es aktivieren, um die App nutzen zu können.';

  @override
  String get notificationsRequired => 'Benachrichtigungen erforderlich';

  @override
  String get notificationsRequiredMessage =>
      'Um Benachrichtigungen und Erinnerungen zur Gebetszeit zu erhalten, sind Benachrichtigungen erforderlich.';

  @override
  String get sectTitle => 'Wählen Sie Ihre Sekte';

  @override
  String get sectSubtitle => 'Dies hilft uns, Ihr Erlebnis zu personalisieren';

  @override
  String get sectSunni => 'Sunnitisch';

  @override
  String get sectShia => 'Schiiten';

  @override
  String get sectPreferNotToSay => 'Sag es lieber nicht';

  @override
  String get nameTitle => 'Wie heißen Sie?';

  @override
  String get nameSubtitle => 'Lassen Sie uns Ihre Begrüßung personalisieren';

  @override
  String get namePlaceholder => 'Ihr Name';

  @override
  String get locationTitle => 'Finde deine Qibla';

  @override
  String get locationSubtitle =>
      'Aktiviere den Standort für genaue Qibla, Gebetszeiten und Moscheen in der Nähe.';

  @override
  String get locationButton => 'Standortzugriff zulassen';

  @override
  String get locationManualEntry => 'Oder gib deine Stadt ein';

  @override
  String get locationPrivacyNote => 'Bleibt auf deinem Gerät';

  @override
  String get locationFeaturePrayerTimesTitle => 'Gebetszeiten';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Moscheen';

  @override
  String get notificationsTitle => 'Verpasse kein Gebet';

  @override
  String get notificationsSubtitle =>
      'Adhan-Benachrichtigungen, Fokuserinnerungen und täglicher Dhikr — genau dann, wenn du sie brauchst.';

  @override
  String get notificationsButton => 'Benachrichtigungen aktivieren';

  @override
  String get notificationsEnabled => 'Benachrichtigungen sind aktiviert';

  @override
  String get notificationsPreviewDate => 'Freitag, 10. Juli';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'jetzt';

  @override
  String get notificationsPreviewMinutesAgo => 'vor 2 Min.';

  @override
  String get notificationsPreviewHourAgo => 'vor 1 Std.';

  @override
  String get notificationsPreviewAdhanTitle => 'Maghrib-Adhan';

  @override
  String get notificationsPreviewAdhanBody =>
      'Es ist Zeit zu beten. Apps sind pausiert.';

  @override
  String get notificationsPreviewDhikrTitle => 'TÄGLICHER DHIKR';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — nimm dir eine Minute zum Gedenken.';

  @override
  String get notificationsPreviewStreakTitle => 'SERIE';

  @override
  String get notificationsPreviewStreakBody =>
      '7 Tage vollständige Gebete. Weiter so!';

  @override
  String get screenTimeTitle => 'Bildschirmzeit aktivieren';

  @override
  String get screenTimeSubtitle =>
      'Damit kann Deen Focus ablenkende Apps während Salah, Schlafenszeit und Kindermodus pausieren.';

  @override
  String get screenTimeButton => 'Bildschirmzeit-Zugriff erlauben';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus liest niemals deine Daten — es pausiert nur die Apps, die du auswählst.';

  @override
  String screenTimeStepOf(int current, int total) {
    return 'SCHRITT $current VON $total';
  }

  @override
  String get screenTimeStep1Title => 'Bildschirmzeit-Hinweis öffnen';

  @override
  String get screenTimeStep1Body =>
      'Tippe auf „Bildschirmzeit-Zugriff erlauben“ — dein Gerät zeigt seine eigene Berechtigungsanfrage.';

  @override
  String get screenTimeStep2Title => 'Tippe auf Weiter, dann Erlauben';

  @override
  String get screenTimeStep2Body =>
      'Genehmige die Anfrage, damit Deen Focus Apps zum richtigen Zeitpunkt pausieren kann.';

  @override
  String get screenTimeStep3Title => 'Apps zum Sperren wählen';

  @override
  String get screenTimeStep3Body =>
      'Wähle die Apps, die dich am meisten ablenken — Social, Spiele, Video, alles.';

  @override
  String get screenTimeStep4Title => 'Du bist geschützt';

  @override
  String get screenTimeStep4Body =>
      'Apps sperren sich automatisch während Salah, Schlafzeit und Kindermodus.';

  @override
  String get screenTimePromptTitle => 'Bildschirmzeit';

  @override
  String screenTimePromptMessage(String appName) {
    return '„$appName“ möchte auf Bildschirmzeit zugreifen';
  }

  @override
  String get screenTimeDontAllow => 'Nicht erlauben';

  @override
  String get screenTimePromptContinue => 'Weiter';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Spiele';

  @override
  String get screenTimeAndroidStep1Title => 'Nutzungszugriff öffnen';

  @override
  String get screenTimeAndroidStep1Body =>
      'Tippe auf „Bildschirmzeit-Zugriff erlauben“ — dein Gerät öffnet den Nutzungszugriff für Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Bedienungshilfen aktivieren';

  @override
  String get screenTimeAndroidStep2Body =>
      'Aktiviere den Deen-Focus-Dienst, damit Apps während Salah, Schlaf und Kindermodus pausiert werden.';

  @override
  String get screenTimeAndroidStep3Title => 'Apps zum Sperren wählen';

  @override
  String get screenTimeAndroidStep3Body =>
      'Wähle die Apps, die dich am meisten ablenken — Social, Spiele, Video, alles.';

  @override
  String get screenTimeAndroidStep4Title => 'Du bist geschützt';

  @override
  String get screenTimeAndroidStep4Body =>
      'Apps sperren sich automatisch während Salah, Schlafzeit und Kindermodus.';

  @override
  String get screenTimeAndroidUsageTitle => 'Nutzungszugriff';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Deen Focus erlauben, zu erkennen, welche anderen Apps genutzt werden.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Bedienungshilfen';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus benötigt Bedienungshilfen, um ablenkende Apps während Fokus-Sitzungen zu pausieren.';

  @override
  String get screenTimeAndroidPermit => 'Erlauben';

  @override
  String get screenTimeAndroidEnable => 'Aktivieren';

  @override
  String get screenTimeAndroidNotNow => 'Nicht jetzt';

  @override
  String get focusModesTitle => 'Alles in einer App';

  @override
  String get focusModesSubtitle =>
      'Entdecke alles, was Deen Focus bietet. Tippe auf einen Fokusmodus, um zu sehen, wie er funktioniert.';

  @override
  String get focusModesSectionLabel => 'FOKUSMODI · TIPPEN FÜR MEHR';

  @override
  String get focusPrayerTrackingSectionLabel => 'GEBET & TRACKING';

  @override
  String get focusLearningHubSectionLabel => 'LERNHUB';

  @override
  String get focusMoreSectionLabel => 'MEHR';

  @override
  String get focusPrayerModeTitle => 'Gebetsmodus';

  @override
  String get focusPrayerModeDescription =>
      'Blockiere ablenkende Apps automatisch während Salah, damit du mit vollem Khushu beten kannst.';

  @override
  String get focusPrayerModeBullet1 => 'Sperrt Apps zur Gebetszeit';

  @override
  String get focusPrayerModeBullet2 => 'Entsperrt, wenn du fertig bist';

  @override
  String get focusPrayerModeBullet3 => 'Stärkt Fokus und Beständigkeit';

  @override
  String get focusSleepModeTitle => 'Schlafmodus';

  @override
  String get focusSleepModeDescription =>
      'Entspanne auf halal Weise. Blockiere Apps zur Schlafenszeit, damit du gut ruhst und zum Fajr aufwachst.';

  @override
  String get focusSleepModeBullet1 =>
      'Blockiert Apps automatisch zur Schlafenszeit';

  @override
  String get focusSleepModeBullet2 => 'Sanfte Weckrufe für Fajr';

  @override
  String get focusSleepModeBullet3 => 'Schützt deinen Schlaf und Fajr';

  @override
  String get focusChildModeTitle => 'Kindermodus';

  @override
  String get focusChildModeDescription =>
      'Gibst du dein Handy an dein Kind weiter? Sperre Apps sofort, damit nur Sicheres sichtbar ist.';

  @override
  String get focusChildModeBullet1 => 'Sicherheitsmodus mit einem Tipp';

  @override
  String get focusChildModeBullet2 => 'Ausgang durch Passcode geschützt';

  @override
  String get focusChildModeBullet3 => 'Jeden Moment beruhigt';

  @override
  String get focusModeGotIt => 'Verstanden';

  @override
  String get focusFeaturePrayerTimesTitle => 'Genaue Gebetszeiten';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan & Erinnerungen';

  @override
  String get focusFeatureStreaksTitle => 'Serien';

  @override
  String get focusFeatureStreaksSubtitle => 'Bleib beständig';

  @override
  String get focusFeatureChecklistTitle => 'Tägliche Checkliste';

  @override
  String get focusFeatureChecklistSubtitle => 'Gute Gewohnheiten aufbauen';

  @override
  String get focusFeatureQiblaTitle => 'Qibla & Moschee';

  @override
  String get focusFeatureQiblaSubtitle => 'Richtung & Moscheen';

  @override
  String get focusFeatureQuranTitle => 'Koran';

  @override
  String get focusFeatureQuranSubtitle => 'Übersetzungen, Dschuz & Seiten';

  @override
  String get focusFeatureHadithTitle => 'Hadith';

  @override
  String get focusFeatureHadithSubtitle => 'Authentische Sammlungen';

  @override
  String get focusFeatureDuasTitle => 'Duas';

  @override
  String get focusFeatureDuasSubtitle => 'Tägliche Bittgebete';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Digitaler Dhikr-Zähler';

  @override
  String get focusFeatureAiTitle => 'KI-Begleiter';

  @override
  String get focusFeatureAiSubtitle => 'Fragen zu deinem Deen stellen';

  @override
  String get focusFeatureInsightsTitle => 'Einblicke';

  @override
  String get focusFeatureInsightsSubtitle =>
      'Wöchentliche & monatliche Statistiken';

  @override
  String get investTitle => 'In Deen investieren';

  @override
  String get investSubtitle =>
      'Die beste Investition gilt nicht dem, was vergeht — sondern dem, was dich Allah näher bringt. Probiere alles 7 Tage kostenlos.';

  @override
  String get investPremiumUnlocked => 'PREMIUM FREIGESCHALTET';

  @override
  String get investTrialPill =>
      '✨ 7 Tage kostenlos — jederzeit vor Ablauf kündbar';

  @override
  String get investFeatureAiTitle => 'KI-islamischer Assistent';

  @override
  String get investFeatureAiBody =>
      'Frage alles zu deinem Deen — Antworten aus authentischen Quellen.';

  @override
  String get investFeaturePrayerModeTitle => 'Vollbild-Gebetsmodus';

  @override
  String get investFeaturePrayerModeBody =>
      'Ein ruhiger, ablenkungsfreier Bildschirm, der dich zum Gebet ruft.';

  @override
  String get investFeatureAppBlockingTitle => 'Erweiterte App-Sperre';

  @override
  String get investFeatureAppBlockingBody =>
      'Feingranulare Kontrolle darüber, welche Apps wann gesperrt werden.';

  @override
  String get investFeatureNightModeTitle => 'Nacht-Disziplin-Modus';

  @override
  String get investFeatureNightModeBody =>
      'Rechtzeitig zur Ruhe kommen, besser schlafen und zum Fajr aufwachen.';

  @override
  String get investFeaturePlannerTitle => 'Gebetsplaner & Fortschritt';

  @override
  String get investFeaturePlannerBody =>
      'Serien, Einblicke und Tagebücher, die dich beständig halten.';

  @override
  String get investFeatureToolsTitle => 'Exklusive islamische Tools';

  @override
  String get investFeatureToolsBody =>
      'Hidschri-Kalender, Duas, Tasbih, 99 Namen und mehr.';

  @override
  String get investFeatureThemesTitle => 'Premium-Themes & Updates';

  @override
  String get investFeatureThemesBody =>
      'Schöne Themes plus jedes neue Feature, das wir veröffentlichen.';

  @override
  String get investFeatureTajweedTitle => 'Tadschwid meistern';

  @override
  String get investFeatureTajweedBody =>
      'Verbessere deine Rezitation mit geführten Lektionen und Echtzeit-Feedback.';

  @override
  String get socialProofPrefix => 'Werde Teil von ';

  @override
  String get socialProofHighlight => '10.000+';

  @override
  String get socialProofSuffix => ' Muslimen, die mit DeenFocus wachsen';

  @override
  String get mostPopular => 'Am beliebtesten';

  @override
  String get monthlyLabel => 'Monatlich';

  @override
  String get yearlyLabel => 'Jährlich';

  @override
  String get lifetimeLabel => 'Lebensdauer';

  @override
  String get featureNoAds => 'Entfernt alle Anzeigen';

  @override
  String get featureSupport => 'Vorrangiger Support';

  @override
  String get homeTitle => 'Deenly Zuhause';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback =>
      'Tatsächlich geht mit der Not auch Leichtigkeit einher.';

  @override
  String get homeAppsLocked => 'Apps gesperrt';

  @override
  String get homeAppsUnlocked => 'Apps freigeschaltet';

  @override
  String get homeTapToUnlock =>
      'Tippen Sie hier, um Apps vorübergehend zu entsperren';

  @override
  String get homeTapToRelock =>
      'Tippen Sie hier, um blockierte Apps jetzt wieder zu sperren';

  @override
  String get homeRelock => 'Wieder verriegeln';

  @override
  String get homeUnlock => 'Entsperren';

  @override
  String get homePrayerModeActive => 'Gebetsmodus aktiv';

  @override
  String get homeActivatePrayerMode => 'Aktivieren Sie den Gebetsmodus';

  @override
  String get homeAppsBlockedSubtitle =>
      'Apps sind blockiert. Zum Deaktivieren antippen.';

  @override
  String get homeBlockDistractingApps =>
      'Blockieren Sie während Salah ablenkende Apps.';

  @override
  String get homeQiblaDirection => 'Qibla-Richtung';

  @override
  String get homeLocationMissingForQibla =>
      'Aktivieren Sie den Standort, um die Qibla-Richtung zu berechnen.';

  @override
  String get homeQiblaSubtitleGuiding => 'Führt Sie zur Qibla';

  @override
  String get homeToMakkah => 'nach Mekka';

  @override
  String get homeFindMasjid => 'Finden Sie eine Moschee in meiner Nähe';

  @override
  String get quickActionsMasjidFinder => 'Moschee-Finder';

  @override
  String get homeSearchNearbyMosques => 'Suchen Sie nach Moscheen in der Nähe.';

  @override
  String get homePrayerStreak => 'Gebetsstränge';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Einblicke';

  @override
  String get homeOpenStreakDetails => 'Offene Streak-Details.';

  @override
  String get homeTodaysPrayers => 'Die heutigen Gebete';

  @override
  String get homePrayerTimesUnavailable =>
      'Gebetszeiten sind derzeit nicht verfügbar.';

  @override
  String get homeNextPrayerIn => 'Nächstes Gebet in';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Sonnenaufgang';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Maghrib';

  @override
  String get homePrayerIsha => 'Isha';

  @override
  String get homeWeek => 'Woche';

  @override
  String get homeMonth => 'Monat';

  @override
  String get homeThisWeek => 'Deen-Highlights dieser Woche';

  @override
  String get homeJummahMubarak => 'Jummah Mubarak';

  @override
  String get homeJummahReminder => 'Vergessen Sie nicht Surah Al-Kahf.';

  @override
  String get hijriYear => 'n. H.';

  @override
  String get hijriMonthMuharram => 'Muharram';

  @override
  String get hijriMonthSafar => 'Safar';

  @override
  String get hijriMonthRabiAlAwwal => 'Rabiʿ al-awwal';

  @override
  String get hijriMonthRabiAlThani => 'Rabiʿ al-thani';

  @override
  String get hijriMonthJumadaAlAwwal => 'Dschumada al-ula';

  @override
  String get hijriMonthJumadaAlThani => 'Dschumada al-akhira';

  @override
  String get hijriMonthRajab => 'Radschab';

  @override
  String get hijriMonthShaban => 'Schaʿban';

  @override
  String get hijriMonthRamadan => 'Ramadan';

  @override
  String get hijriMonthShawwal => 'Schawwal';

  @override
  String get hijriMonthDhuAlQadah => 'Dhu l-Qaʿda';

  @override
  String get hijriMonthDhuAlHijjah => 'Dhu l-Hiddscha';

  @override
  String get calendarTitle => 'Islamic Calendar';

  @override
  String get calendarBack => 'Back';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarTomorrow => 'Tomorrow';

  @override
  String calendarDaysAway(int days) {
    return '$days days';
  }

  @override
  String get calendarNoEventsThisWeek => 'No Islamic events this week.';

  @override
  String get calendarNoEventsBlessing =>
      'May Allah bless your week with peace and goodness.';

  @override
  String get calendarNoUpcomingEvents => 'No upcoming Islamic events found.';

  @override
  String get calendarUpcomingEvents => 'Upcoming Islamic Events';

  @override
  String get calendarUpcomingThisYear => 'Upcoming This Year';

  @override
  String get calendarThisWeekObservances => 'This Week';

  @override
  String get calendarLegendCycleDays => 'Cycle days (streak protected)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% illuminated';
  }

  @override
  String get calendarMoonNew => 'New Moon';

  @override
  String get calendarMoonWaxingCrescent => 'Waxing Crescent';

  @override
  String get calendarMoonFirstQuarter => 'First Quarter';

  @override
  String get calendarMoonWaxingGibbous => 'Waxing Gibbous';

  @override
  String get calendarMoonFull => 'Full Moon';

  @override
  String get calendarMoonWaningGibbous => 'Waning Gibbous';

  @override
  String get calendarMoonLastQuarter => 'Last Quarter';

  @override
  String get calendarMoonWaningCrescent => 'Waning Crescent';

  @override
  String get calendarEventRamadanBegins => 'Ramadan Begins';

  @override
  String get calendarEventRamadanBeginsDesc => 'Month of fasting';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Night of Power';

  @override
  String get calendarEventEidAlFitr => 'Eid al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc => 'Festival of Breaking the Fast';

  @override
  String get calendarEventDayOfArafah => 'Day of Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Day of standing at Arafah';

  @override
  String get calendarEventEidAlAdha => 'Eid al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Festival of Sacrifice';

  @override
  String get calendarEventIslamicNewYear => 'Islamic New Year';

  @override
  String get calendarEventIslamicNewYearDesc => '1st of Muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Birth of the Prophet';

  @override
  String get calendarEventAshura => 'Ashura';

  @override
  String get calendarEventAshuraDesc => '10th of Muharram';

  @override
  String get calendarEventJumuah => 'Dschumuʿa';

  @override
  String get calendarEventJumuahDesc => 'Freitagsgebet';

  @override
  String get calendarEventWhiteDays => 'Weiße Tage';

  @override
  String get calendarEventWhiteDaysDesc => '13.–15. jedes Monats';

  @override
  String get cycleModeActiveTitle =>
      '„Allah will für euch Erleichterung und will für euch nicht Erschwernis.“ — Koran 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'In dieser Zeit ist deine Serie geschützt. Zyklustage sind pink markiert, und der Zyklusmodus endet automatisch, wenn der Zyklus vorbei ist.';

  @override
  String get cycleModeStreakProtected =>
      'Prayer streak is protected during your cycle';

  @override
  String get cycleModeCalendarHighlighted =>
      'Calendar days are highlighted in pink';

  @override
  String cycleModeAutoEndInfo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Endet automatisch in $days Tagen',
      one: 'Endet automatisch morgen',
      zero: 'Endet heute',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeSettingsTitle => 'Zyklusmodus';

  @override
  String get cycleModeStartDateLabel => 'Startdatum';

  @override
  String get cycleModeLengthLabel => 'Zykluslänge';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Serien pausieren';

  @override
  String get cycleModeExcludeFromStatisticsLabel =>
      'Von Statistiken ausschließen';

  @override
  String get cycleModeSaveButton => 'Speichern';

  @override
  String get cycleModeEditButton => 'Bearbeiten';

  @override
  String get cycleModeChangeStartDateTitle => 'Startdatum ändern?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Wenn du das Startdatum änderst, wird das aktive Zyklusmodus-Fenster neu berechnet. Tage außerhalb des neuen Zeitraums gelten möglicherweise nicht mehr als Zyklustage.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Startdatum ändern';

  @override
  String prayerReminderTitle(String prayer) {
    return 'Hast du $prayer gebetet?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Halte deine Serie am Leben, indem du dein Gebet einträgst.';

  @override
  String get prayerReminderYesButton => 'Ja, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'Später markieren';

  @override
  String get homeTrialBannerTitle =>
      '7 Tage kostenlos — werde ein besserer Muslim ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Alle Funktionen freigeschaltet. Starte heute deine Reise.';

  @override
  String get homeFocusModeTitle => 'Fokusmodus';

  @override
  String get homeFocusModeSubtitle =>
      'Ablenkende Apps während Salah blockieren';

  @override
  String get cycleModeTitle => 'Zyklusmodus';

  @override
  String get cycleModeSubtitle =>
      'Für die Menstruation — Gebete pausieren, Serie behalten';

  @override
  String get dailyChecklistTitle => 'Tägliche Checkliste';

  @override
  String get dailyChecklistSubtitle =>
      'Verfolge deine täglichen spirituellen Ziele';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed von $total erledigt';
  }

  @override
  String get dailyChecklistSectionPrayer => 'Gebet';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Koran & Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Gute Taten';

  @override
  String get dailyChecklistSectionDistraction => 'Ablenkungskontrolle';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Koran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morgen-Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Abend-Adhkar';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Spende';

  @override
  String get dailyChecklistSmileAtSomeone => 'Jemanden anlächeln';

  @override
  String get dailyChecklistFamilyCall => 'Familienanruf';

  @override
  String get dailyChecklistNoMusicToday => 'Heute keine Musik';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'Kein Social Media vor Isha';

  @override
  String get focusScoreTitle => 'Heutiger Fokus-Score';

  @override
  String get focusScorePrayer => 'Gebet';

  @override
  String get focusScoreQuran => 'Koran';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Ablenkungskontrolle';

  @override
  String get insightsBack => 'Zurück';

  @override
  String get insightsTitle => 'Meine Einblicke';

  @override
  String get insightsSubtitle => 'Verfolge deinen Deen-Fortschritt';

  @override
  String get insightsPrayerRate => 'Gebetsrate';

  @override
  String get insightsDayStreak => 'Tagesstreak';

  @override
  String get insightsBestStreak => 'Bester Streak';

  @override
  String get insightsWeekly => 'Wöchentlich';

  @override
  String get insightsMonthly => 'Monatlich';

  @override
  String get insightsPrayersCompleted => 'Absolvierte Gebete';

  @override
  String get insightsRestoreStreak =>
      'Streak wiederherstellen — letzte 24 Stunden';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Gebet $prayerPercent% · Koran $quranPercent% · Dhikr $dhikrPercent% · Ablenkung $distractionPercent%';
  }

  @override
  String get quickActionsCalendar => 'Kalender';

  @override
  String get quickActionsCalendarSubtitle => 'Islamische Daten anzeigen';

  @override
  String get quickActionsSupportUs => 'Unterstütze uns';

  @override
  String get quickActionsSupportUsSubtitle => 'Hilf uns zu wachsen';

  @override
  String get quickActionsSupportUsMessage =>
      'Danke, dass du DeenFocus unterstützen möchtest! Support-Funktionen kommen bald.';

  @override
  String get supportUsTitle => 'DeenFocus unterstützen';

  @override
  String get supportUsHeroTitle => 'DeenFocus unterstützen';

  @override
  String get supportUsHeroBody =>
      'Deine Unterstützung hilft uns, DeenFocus zu verbessern und zu sinnvollen Anliegen beizutragen.';

  @override
  String get supportUsFundSection => 'Deine Unterstützung finanziert';

  @override
  String get supportUsFundSectionSubtitle =>
      'Wir nutzen deine Unterstützung, um mehr Gutes zu schaffen.';

  @override
  String get supportUsFundFeature1Title => 'Neue Funktionen';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Sinnvolle DeenFocus-Funktionen bauen und verbessern.';

  @override
  String get supportUsFundFeature2Title => 'Fehlerbehebungen';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Die App für alle stabil, schnell und zuverlässig halten.';

  @override
  String get supportUsFundFeature3Title => 'Menschen in Not';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Unterstützung für Menschen in schwierigen Situationen.';

  @override
  String get supportUsFundFeature4Title => 'Wohltätigkeit & Gemeinschaft';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Beiträge zu wohltätigen Initiativen und Community-Support.';

  @override
  String get supportUsNeedHelp => 'BRAUCHST DU HILFE?';

  @override
  String get supportUsWhatsApp => 'Per WhatsApp chatten';

  @override
  String get supportUsEmailSupport => 'E-Mail-Support';

  @override
  String get supportUsChooseAmountTitle => 'Unterstützungbetrag wählen';

  @override
  String get supportUsChooseAmountSubtitle =>
      'Du kannst mehrmals unterstützen.';

  @override
  String get supportUsSecurePaymentNote =>
      'Sichere Einmalzahlung · Keine wiederkehrenden Gebühren';

  @override
  String get supportUsTrustBanner =>
      'Sicher • Einmalige Unterstützung • Mehrfach möglich';

  @override
  String get supportUsImpactSectionTitle => 'Wo deine Unterstützung wirkt';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Jeder Beitrag hat nachhaltige Wirkung.';

  @override
  String get supportUsImpactPalestine =>
      'Unterstützung & Bewusstsein für Palästina';

  @override
  String get supportUsImpactNeedy => 'Menschen in Not helfen';

  @override
  String get supportUsImpactCommunity => 'Wohltätigkeit & Community-Support';

  @override
  String get supportUsImpactExperience => 'Bessere DeenFocus-Erfahrung';

  @override
  String get supportUsImpactFeatures => 'Neue Funktionen & Upgrades';

  @override
  String get supportUsImpactQuran => 'Koran & islamisches Lernen';

  @override
  String get supportUsImpactServers => 'Server & App-Zuverlässigkeit';

  @override
  String supportUsCta(String amount) {
    return 'DeenFocus mit $amount unterstützen';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, ich brauche Hilfe mit DeenFocus.';

  @override
  String get supportUsEmailSubject => 'DeenFocus Support-Anfrage';

  @override
  String get supportUsLaunchUnavailable =>
      'Diese App konnte auf diesem Gerät nicht geöffnet werden.';

  @override
  String get supportUsLaunchFailed =>
      'Etwas ist schiefgelaufen. Bitte erneut versuchen.';

  @override
  String get homeAiChatDescription =>
      'Fragen Sie alles zu Gebetszeiten, Koran und islamischer Führung.';

  @override
  String get homeDay => 'Tag';

  @override
  String get homeDays => 'Tage';

  @override
  String get homeNoEventsFoundForDay =>
      'Für diesen Tag wurden keine Veranstaltungen gefunden.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — markieren als';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Rechtzeitig gebetet';

  @override
  String get homeMarkPrayerQada => 'Qada (nachgeholt)';

  @override
  String get homeMarkPrayerMissed => 'Verpasst';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return '$prayerName-Einstellungen';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Gebetszeit';

  @override
  String get homePrayerSettingsNotification => 'Benachrichtigung';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Tugenden, Regelungen und mehr';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Diese Einstellungen gelten nur für $prayerName. Du kannst für jedes Gebet andere Einstellungen wählen.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return '$prayerName-Zeit bearbeiten';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Aktuelle Zeit';

  @override
  String get homeEditPrayerTimeSelectNew => 'Neue Zeit wählen';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Diese benutzerdefinierte Zeit gilt nur für $prayerName. Passe sie an, wenn deine lokale Moschee oder Berechnung abweicht.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Zeit speichern';

  @override
  String get homeEditPrayerTimeReset => 'Auf berechnete Zeit zurücksetzen';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Benachrichtigung für $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Benachrichtigungston';

  @override
  String get homeNotificationSoundFullAdhan => 'Vollständiger Adhan';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Den kompletten Adhan abspielen';

  @override
  String get homeNotificationSoundBeep => 'Piepton';

  @override
  String get homeNotificationSoundBeepSubtitle =>
      'Ein kurzer Benachrichtigungston';

  @override
  String get homeNotificationSoundMute => 'Stumm';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Kein Ton';

  @override
  String get homeNotificationEnableLabel => 'Benachrichtigung aktivieren';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Zur $prayerName-Zeit benachrichtigt werden';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'Über $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Zeit';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakats';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Tugenden';

  @override
  String get homeAboutPrayerReferenceLabel => 'Referenz';

  @override
  String get homeAboutFajrTiming =>
      'Beginnt bei der wahren Morgendämmerung (Fajr Sadiq) und endet bei Sonnenaufgang.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Wer Fajr betet, steht unter dem Schutz Allahs.';

  @override
  String get homeAboutFajrReference =>
      '„Die beiden Rakʿāt des Fajr sind besser als die Welt und alles, was sie enthält.“ (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Beginnt, sobald die Sonne ihren Zenit überschritten hat, und dauert bis zum Beginn von Asr.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Teil der 12 freiwilligen Rakʿāt am Tag, für die Allah ein Haus im Paradies erbaut.';

  @override
  String get homeAboutDhuhrReference =>
      '„Wer an einem Tag und einer Nacht zwölf Rakʿāt betet, dem wird ein Haus im Paradies erbaut.“ (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Beginnt, wenn der Schatten eines Gegenstands seiner Länge entspricht, und dauert bis zum Sonnenuntergang.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Dieses Gebet zu hüten wird besonders belohnt und ausdrücklich gemahnt.';

  @override
  String get homeAboutAsrReference =>
      '„Wer das Asr-Gebet versäumt, dem ist es, als hätte er Familie und Besitz verloren.“ (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Beginnt direkt nach Sonnenuntergang und dauert, bis die rote Dämmerung verschwindet.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Eine Zeit, in der Bittgebete besonders empfohlen sind.';

  @override
  String get homeAboutMaghribReference =>
      '„Es gibt zwei Freuden für den Fastenden… wenn er das Fasten bricht.“ (Sahih al-Bukhari, zum Maghrib-Iftar)';

  @override
  String get homeAboutIshaTiming =>
      'Beginnt, sobald die Dämmerung vollständig verschwunden ist, und dauert bis Mitternacht (oder bis Fajr, je nach Ansicht).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Isha in der Gemeinde zu beten entspricht dem Stehen der halben Nacht im Gebet.';

  @override
  String get homeAboutIshaReference =>
      '„Wer Isha in der Gemeinde betet, dem ist es, als hätte er die Hälfte der Nacht gebetet.“ (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Zurück zum Onboarding';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get tabHome => 'Heim';

  @override
  String get tabFocus => 'Fokus';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Koran';

  @override
  String get tabLearn => 'Lernen';

  @override
  String get quranLoadFailed => 'Korandaten konnten nicht geladen werden';

  @override
  String get quranTabSubtitle => 'Lesen und erforschen Sie den Heiligen Koran';

  @override
  String get quranSearchHint => 'Sure suchen...';

  @override
  String get quranNoSurahsFound => 'Keine Suren gefunden';

  @override
  String get quranVersesLabel => 'Verse';

  @override
  String get quranTextOptions => 'Textoptionen';

  @override
  String get quranEnglishAndArabic => 'Englisch und Arabisch';

  @override
  String get quranArabicOnly => 'Nur Arabisch';

  @override
  String get quranIncreaseFont => 'Schriftart vergrößern';

  @override
  String get quranDecreaseFont => 'Schriftart verringern';

  @override
  String get quranPause => 'Pause';

  @override
  String get quranPlaySurah => 'Spielen Sie Sure';

  @override
  String get quranAudioNoInternet =>
      'Keine Internetverbindung. Audio erfordert Internet.';

  @override
  String get quranAudioTimeout =>
      'Audio-Ladezeit überschritten. Verbindung prüfen.';

  @override
  String get quranSurahLabel => 'Sure';

  @override
  String get save => 'Speichern';

  @override
  String get tasbihBack => 'Zurück';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Wählen Sie einen Dhikr aus oder erstellen Sie Ihren eigenen';

  @override
  String get tasbihAddCustomTitle => 'Dhikr hinzufügen';

  @override
  String get tasbihEditCustomTitle => 'Benutzerdefiniertes Dhikr bearbeiten';

  @override
  String get tasbihArabicOrDhikrHint => 'Arabischer Text oder irgendein Dhikr';

  @override
  String get tasbihTransliterationOptionalHint => 'Transliteration (optional)';

  @override
  String get tasbihMeaningOptionalHint => 'Bedeutung (optional)';

  @override
  String get tasbihNoTransliteration => 'Keine Transliteration';

  @override
  String get tasbihTotalCount => 'Gesamtzahl';

  @override
  String get tasbihGrandTotalLabel => 'Tasbih insgesamt';

  @override
  String get tasbihTapMe => 'Tippen Sie auf „Ich“.';

  @override
  String get tasbihReset => 'Zurücksetzen';

  @override
  String get tasbihRestart => 'Neustart';

  @override
  String get tasbihCurrentCount => 'Aktueller Zählerstand';

  @override
  String get tasbihResetTotal => 'Verlauf löschen';

  @override
  String get focusModeActivated => 'Fokusmodus aktiviert';

  @override
  String get focusSetUpHomeCardTitle => 'Fokusmodus einrichten';

  @override
  String get focusTabSubtitle =>
      'Bleiben Sie konzentriert, wenn es darauf ankommt';

  @override
  String get focusChooseAppsEnableMode =>
      'Apps wählen und Fokusmodus aktivieren';

  @override
  String get focusNotifAppsLockedTitle => 'Apps gesperrt';

  @override
  String get focusNotifAppsUnlockedTitle => 'Apps entsperrt';

  @override
  String get focusNotifNightModeTitle => 'Nachtmodus';

  @override
  String get focusNotifGoodMorningTitle => 'Guten Morgen!';

  @override
  String get focusNotifAppsNowAvailableBody => 'Apps sind jetzt verfügbar.';

  @override
  String get focusNotifSalahLockedBody =>
      'Während des Gebets sind Apps gesperrt.';

  @override
  String get focusNotifSalahCompleteTitle => 'Gebet abgeschlossen';

  @override
  String get focusNotifSalahCompleteBody =>
      'Apps sind jetzt entsperrt. Möge Ihr Gebet angenommen werden.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return '$prayerName-Zeit';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Nehmen Sie sich einen Moment für das $prayerName-Gebet.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Nachtmodus ist an. Gönn Geist und Körper Ruhe.';

  @override
  String get focusNotifGenericLockedBody => 'Ausgewählte Apps sind gesperrt.';

  @override
  String get focusNotifMorningUnlockBody => 'Apps sind nicht verfügbar.';

  @override
  String get widgetDailyVerseTitle => 'Tagesvers';

  @override
  String get widgetOpenAppTimelineHint =>
      'Öffne Deen Focus, um Tagesvers und Gebet-Widget-Daten vorzubereiten.';

  @override
  String get widgetSetLocationForPrayers =>
      'Lege in Deen Focus deinen Standort fest, um Gebete und den Tagesvers zu laden.';

  @override
  String get focusChildModeActive => 'Kindermodus aktiv';

  @override
  String get focusSalahAndNightModeActive => 'Salah und Nachtmodus aktiv';

  @override
  String get focusSalahModeActive => 'Salah-Modus aktiv';

  @override
  String get focusNightModeActive => 'Nachtmodus aktiv';

  @override
  String get focusAppsToBlockTitle => 'Apps zum Blockieren';

  @override
  String get focusAppliesAllModes => 'Gilt für alle Fokusmodi';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Zum Anzeigen und Auswählen von Apps ist Zugriff auf die Bildschirmzeit erforderlich.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Bitte akzeptieren Sie die Offenlegung der Barrierefreiheit, um fortzufahren.';

  @override
  String get focusSelectAppsToBlock => 'Wählen Sie Apps zum Blockieren aus';

  @override
  String get focusLoading => 'Laden...';

  @override
  String get focusOpen => 'Offen';

  @override
  String get focusHide => 'Verstecken';

  @override
  String get focusLoad => 'Laden';

  @override
  String get focusShow => 'Zeigen';

  @override
  String get focusSalahFocusModeTitle => 'Salah-Fokusmodus';

  @override
  String get focusBlockAppsDuringPrayer =>
      'Blockieren Sie Apps während des Gebets';

  @override
  String get focusNightDisciplineTitle => 'Nachtdisziplin';

  @override
  String get focusSleepLabel => 'Schlafen';

  @override
  String get focusWakeLabel => 'Aufwachen';

  @override
  String get focusBlockAppsImmediately => 'Apps sofort blockieren';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Aktivieren Sie die Blockierung von Android-Apps';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Um andere Apps auf Android zu blockieren, muss die Barrierefreiheitsberechtigung von Deenly aktiviert sein. Wir öffnen den richtigen Einstellungsbildschirm für Sie.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Offenlegung der Barrierefreiheitsberechtigung';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly nutzt die Android-Barrierefreiheit, um das Blockieren von Apps im Fokusmodus zu erzwingen.\n\nWarum wir es brauchen: um zu erkennen, wann Sie eine App öffnen, die Sie zum Blockieren ausgewählt haben.\n\nWie wir es verwenden: Nur um die Vordergrund-App zu identifizieren und den Fokusblock-Bildschirm für ausgewählte Apps anzuzeigen. Wir verwenden es nicht, um getippte Texte oder persönliche Inhalte zu lesen.';

  @override
  String get focusNotNow => 'Nicht jetzt';

  @override
  String get focusIUnderstand => 'Ich verstehe';

  @override
  String get focusDone => 'Erledigt';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Entwickeln Sie bessere Nachtgewohnheiten';

  @override
  String get focusPrayerBlockingDescription =>
      'Apps werden während des Gebets blockiert und nach 15 Minuten automatisch entsperrt. Sie können sie aber auch jederzeit über den Startbildschirm entsperren.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Apps werden während des Gebets blockiert. Sie können sie jederzeit über den Startbildschirm entsperren.';

  @override
  String get focusNightBlockingDescription =>
      'Apps werden während Ihres Schlafzyklus blockiert und automatisch entsperrt. Sie können sie aber jederzeit über den Startbildschirm entsperren';

  @override
  String get focusChildBlockingDescription =>
      'Apps werden im Kindermodus sofort blockiert. Entsperren Sie sie mit dem Schalter oder über den Startbildschirm';

  @override
  String get settingsEditUsername => 'Benutzernamen bearbeiten';

  @override
  String get settingsEnterYourName => 'Geben Sie Ihren Namen ein';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Schalten Sie alle Funktionen frei';

  @override
  String get settingsManageSubscriptionTitle => 'Abonnement verwalten';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Plan anzeigen oder Abrechnung aktualisieren';

  @override
  String get settingsUsernameLabel => 'Benutzername';

  @override
  String get settingsLocationLabel => 'Standort';

  @override
  String get settingsDarkModeLabel => 'Dunkler Modus';

  @override
  String get settingsAboutTitle => 'Über Deen Focus';

  @override
  String get settingsContactUsTitle => 'Kontaktieren Sie uns';

  @override
  String get settingsSavingLocation => 'Sparen...';

  @override
  String get settingsSaveLocation => 'Standort speichern';

  @override
  String get settingsAboutTagline => 'Fokus. Disziplin. Konsistenz.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus hilft Ihnen, mit Ihrem Glauben verbunden zu bleiben und gleichzeitig tägliche Ablenkungen in einer modernen Welt zu bewältigen.';

  @override
  String get settingsAboutFeature1 => 'Gebetszeiten mit Erinnerungen';

  @override
  String get settingsAboutFeature2 => 'Qibla-Richtung jederzeit';

  @override
  String get settingsAboutFeature3 => 'Koran und Tasbih für tägliches Dhikr';

  @override
  String get settingsAboutFeature4 => 'Moscheen in der Nähe';

  @override
  String get settingsAboutFeature5 =>
      'Intelligente Fokusmodi für Salah, Schlaf und Familienzeit';

  @override
  String get settingsAboutFocusDescription =>
      'Intelligente Fokusmodi helfen Ihnen, Ablenkungen während Salah, Schlaf und wichtigen Momenten zu blockieren, damit Sie präsent und diszipliniert bleiben können.';

  @override
  String get settingsAboutFooter =>
      'Bleiben Sie konsequent. Bleiben Sie achtsam.\nBleiben Sie mit Ihrem Deen verbunden.';

  @override
  String get settingsEnableSystemNotifications =>
      'Aktivieren Sie Systembenachrichtigungen, um dies zu aktivieren.';

  @override
  String get appDemoTitle => 'App-Demo';

  @override
  String get appDemoLoadFailed => 'Das Demovideo konnte nicht geladen werden.';

  @override
  String get appDemoRestartHint =>
      'Für das Video ist ein vollständiger Neustart der App erforderlich (ein Warmstart kann die Wiedergabe unterbrechen).';

  @override
  String get appDemoPreviewLoadFailed =>
      'Die Demo konnte nicht geladen werden.';

  @override
  String get appDemoTryAgain => 'Versuchen Sie es erneut';

  @override
  String get appDemoWatchLabel => 'Demo ansehen';

  @override
  String get homeAiChatTitle => 'Deen Focus KI';

  @override
  String get homeAiAskQuestionHint => 'Eine Frage stellen...';

  @override
  String get homeAiSend => 'Schicken';

  @override
  String get homeAiErrorPrefix =>
      'Leider ist beim Herstellen der Verbindung mit Deen Focus AI ein Problem aufgetreten.';

  @override
  String get homeAiEmptyTitle => 'Fragen Sie alles über den Islam';

  @override
  String get homeAiEmptySubtitle =>
      'Gebetszeiten, Koran, Hadith, islamische Ereignisse und spirituelle Führung';

  @override
  String get onboardingTypeCityName => 'Geben Sie den Namen Ihrer Stadt ein.';

  @override
  String get onboardingNoLocationsFound => 'Keine Standorte gefunden';

  @override
  String get onboardingTryAnotherCityName =>
      'Versuchen Sie es mit einem anderen Städtenamen.';

  @override
  String get qiblaCompassUnavailable =>
      'Kompass ist auf diesem Gerät nicht verfügbar';

  @override
  String get qiblaFacing => '✓ Mit Blick auf Qibla';

  @override
  String get qiblaTurnToFind => 'Drehen Sie sich um, um Qibla zu finden';

  @override
  String get qiblaDistanceToMakkah => 'Entfernung nach Mekka';

  @override
  String get qiblaFromNorth => 'aus dem Norden';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Moscheen in der Nähe';

  @override
  String get nearbyMosquesTryAgain => 'Versuchen Sie es erneut';

  @override
  String get nearbyMosquesOpenGoogle => 'In Google Maps öffnen';

  @override
  String get nearbyMosquesOpenApple => 'In Apple Maps öffnen';

  @override
  String get nearbyMosquesNoMosquesFoundWithin => 'Keine Moscheen gefunden';

  @override
  String get nearbyMosquesSearchRadius => 'Suchradius: 5 km';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Kartenvorschau ist derzeit nicht verfügbar.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Warten auf Ihren Standort.';

  @override
  String get nearbyMosquesFetchingLocation => 'Standort wird ermittelt…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Aktueller Standort';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Moscheen in der Nähe werden hier angezeigt, sobald die Ergebnisse geladen sind.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'Keine Moscheen im Umkreis von 5 km gefunden';

  @override
  String get nearbyMosquesLocationRequired =>
      'Um Moscheen in der Nähe zu finden, ist ein Standortzugriff erforderlich.';

  @override
  String get nearbyMosquesPermissionOff =>
      'Die Standortberechtigung ist deaktiviert. Aktivieren Sie es in den Einstellungen, um nahegelegene Moscheen anzuzeigen.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'Wir konnten Ihren aktuellen Standort derzeit nicht lesen.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'Das Live-Update ist fehlgeschlagen. Zeigt die zuletzt gespeicherten Ergebnisse an. Zum Aktualisieren ziehen.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Der Standortzugriff wurde verweigert. Aktivieren Sie es in den Einstellungen, um nahegelegene Moscheen anzuzeigen.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'Der Standort ist auf diesem Gerät deaktiviert. Aktivieren Sie es in den Einstellungen und versuchen Sie es dann erneut.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'Die Standortgenehmigung wird noch bearbeitet. Bitte versuchen Sie es gleich noch einmal.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'Die Anfrage hat zu lange gedauert. Überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Keine Internetverbindung oder der Dienst ist nicht erreichbar. Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get nearbyMosquesFormatError =>
      'Wir konnten die Moscheenliste im Moment nicht lesen. Bitte versuchen Sie es später noch einmal.';

  @override
  String get nearbyMosquesPlatformError =>
      'Wir konnten diesen Schritt nicht abschließen. Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Etwas ist schief gelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get nearbyMosquesEmptyHint =>
      'Im Umkreis von 5 km ist auf OpenStreetMap für diesen Ort nichts aufgeführt. Versuchen Sie es später noch einmal oder verschieben Sie die Karte.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count Moscheen im Umkreis von 5 km gefunden';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Dhikr löschen?';

  @override
  String get tasbihDelete => 'Löschen';

  @override
  String get focusAndroidBlockingNotReady =>
      'Die App-Blockierung unter Android ist noch nicht bereit. Lass Bedienungshilfen aktiviert und warte einen Moment auf die Verbindung.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Keine Apps ausgewählt. Bitte wähle zuerst Apps zum Blockieren.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Für das Blockieren von Apps auf dem iPhone ist Bildschirmzeit-Zugriff erforderlich.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Der Fokusmodus konnte nicht aktualisiert werden. Bitte versuche es erneut.';

  @override
  String get focusLoadingInstalledApps => 'Installierte Apps werden geladen...';

  @override
  String get focusNoInstalledAppsToShow =>
      'Keine installierten Apps zum Anzeigen.';

  @override
  String get homeAiSuggestion1 => 'Was ist Ramadan?';

  @override
  String get homeAiSuggestion2 => 'Gebetszeiten';

  @override
  String get homeAiSuggestion3 => 'Leseplan für den Koran';

  @override
  String get homeAiDeveloperPrompt =>
      'Du bist ein sachkundiger und respektvoller islamischer Gelehrten-Assistent. Hilf Nutzern beim Lernen über islamische Traditionen, Feiertage, Gebet, Koranstudium und spirituelle Praxis. Sei warmherzig, prägnant, lehrreich und kultursensibel. Bei Fragen außerhalb islamischer Beratung antworte hilfreich, ohne religiöse Gewissheit vorzutäuschen.';

  @override
  String get homeAiErrorMissingApiKey => 'API-Konfiguration fehlt.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'API-Fehler $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Keine Antwort vom Assistenten.';

  @override
  String get homeAiErrorEmptyContent => 'Leerer Antwortinhalt.';

  @override
  String get settingsPrayerCalculationSection => 'Gebetsberechnung';

  @override
  String get settingsCalculationMethodTitle => 'Berechnungsmethode';

  @override
  String get settingsAsrCalculationTitle => 'Asr-Berechnung';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Große islamische Organisationen';

  @override
  String get calculationMethodSectionMiddleEast => 'Naher Osten';

  @override
  String get calculationMethodSectionAsiaPacific => 'Asien-Pazifik';

  @override
  String get calculationMethodSectionSpecial => 'Spezielle Methoden';

  @override
  String get asrMethodStandard => 'Standard';

  @override
  String get asrMethodStandardSubtitle => 'Schafi, Maliki, Hanbali';

  @override
  String get asrMethodHanafi => 'Hanafi';

  @override
  String get homeLocationChangedTitle => 'Location Changed';

  @override
  String homeLocationChangedMessage(String city) {
    return 'You appear to be in $city. Update your prayer location for accurate times?';
  }

  @override
  String get homeLocationChangedNotNow => 'Not Now';

  @override
  String get homeLocationChangedUpdate => 'Update';

  @override
  String get homeYourNewLocation => 'your new location';

  @override
  String get insightsPrayerStreak => 'Gebetsserie';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => 'Gebete hintereinander';

  @override
  String get insightsDaysInARow => 'Tage hintereinander';

  @override
  String get insightsChipUpToday => '↑ +1';

  @override
  String get insightsChipDayUp => '↑ +1 today';

  @override
  String get insightsWeeklyCompletion => 'Weekly completion';

  @override
  String get insightsMonthlyCompletion => 'Monthly completion';

  @override
  String get insightsThisWeek => 'This week';

  @override
  String get insightsThisMonth => 'This month';

  @override
  String get insightsOverall => 'Overall';

  @override
  String get insightsRateExcellent => 'Excellent';

  @override
  String get insightsRateGood => 'Good';

  @override
  String get insightsRateFair => 'Fair';

  @override
  String get insightsRateStart => 'Keep going';

  @override
  String get insightsPrayersCompletedWeekly => 'Prayers completed (weekly)';

  @override
  String get insightsPrayersCompletedMonthly => 'Prayers completed (monthly)';

  @override
  String insightsCompletionSummary(int done, int possible) {
    return 'You completed $done out of $possible prayers. Alhamdulillah — keep going!';
  }

  @override
  String get insightsFocusExcellent => 'Ausgezeichnet — weiter so!';

  @override
  String get insightsFocusKeepGoing => 'Baue deinen Fokus weiter aus';

  @override
  String get insightsTodaysPrayers => 'Heutige Gebete';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Zyklusmodus aktiv';

  @override
  String get insightsProtectedByCycleMode => 'Deine Serie ist geschützt.';

  @override
  String get insightsCurrentPrayerStreak => 'Aktuelle Gebetsserie';

  @override
  String get insightsBestPrayerStreak => 'Beste Gebetsserie';

  @override
  String get insightsCurrentDayStreak => 'Aktuelle Tagesserie';

  @override
  String get insightsCycleProtectedDays => 'Zyklus-geschützte Tage';

  @override
  String get insightsAchievements => 'Erfolge';

  @override
  String get insightsAchieved => 'Erreicht';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Cycle Mode days are protected and not counted as streak breaks. You have $days protected day(s) available.';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Aktiviere den Zyklusmodus, um deine Serie an Ruhetagen zu schützen.';

  @override
  String get achievementFirstPrayerStreak => 'Erste Gebetsserie';

  @override
  String get achievementSevenPrayerStreak => 'Sieben-Gebete-Serie';

  @override
  String get achievementThirtyPrayerStreak => 'Dreißig-Gebete-Serie';

  @override
  String get achievementFajrWarrior => 'Fajr-Kämpfer';

  @override
  String get achievementQuranReader => 'Koranleser';

  @override
  String get achievementDhikrMaster => 'Dhikr-Meister';

  @override
  String get achievementConsistencyChampion => 'Beständigkeits-Champion';

  @override
  String get prayerCompletionAlhamdulillah => 'Alhamdulillah!';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer wurde verrichtet';
  }

  @override
  String get prayerCompletionStreakIncreased =>
      'Deine Gebetsserie ist gestiegen';

  @override
  String get prayerCompletionKeepGoing =>
      'Jedes Gebet bringt dich Allah näher. Weiter so!';

  @override
  String get prayerCompletionContinue => 'Weiter';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Nächstes Gebet in $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String get weekdayLetterMon => 'M';

  @override
  String get weekdayLetterTue => 'D';

  @override
  String get weekdayLetterWed => 'M';

  @override
  String get weekdayLetterThu => 'D';

  @override
  String get weekdayLetterFri => 'F';

  @override
  String get weekdayLetterSat => 'S';

  @override
  String get weekdayLetterSun => 'S';

  @override
  String get focusHomeBlockingNightAndSalah =>
      'Nacht-Disziplin und Salah-Modus blockieren gerade Apps';

  @override
  String get focusHomeBlockingNight => 'Nacht-Disziplin blockiert gerade Apps';

  @override
  String get focusHomeBlockingSalah => 'Salah-Modus blockiert gerade Apps';

  @override
  String get focusHomeAppsBlockedNow =>
      'Ausgewählte Apps sind gerade blockiert';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode ist aktiviert';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes sind aktiviert';
  }

  @override
  String get focusHomeChooseMode =>
      'Wähle einen Modus, um deine Aufmerksamkeit zu schützen';

  @override
  String get focusStatusSelectApps => 'Apps auswählen zum Starten';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Nacht-Disziplin und Salah-Modus blockieren gerade Apps';

  @override
  String get focusStatusBlockingNight =>
      'Nacht-Disziplin blockiert gerade Apps';

  @override
  String get focusStatusBlockingSalah => 'Salah-Modus blockiert gerade Apps';

  @override
  String get focusStatusAppsLocked => 'Apps sind gerade gesperrt';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Entsperrt bis $time';
  }

  @override
  String get focusStatusNoMode => 'Kein Fokusmodus aktiviert';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Bereit, $targets zu sperren';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '$hours Std. $minutes Min. $seconds Sek.';
  }
}
