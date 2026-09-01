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
  String get locationManualEntry => 'Stadt manuell eingeben';

  @override
  String get locationOrDivider => 'oder';

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
  String get notificationsMaybeLater => 'Vielleicht später';

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
  String get notificationsPreviewAdhanBody => 'Es ist Zeit zu beten.';

  @override
  String get notificationsPreviewDhikrTitle => 'Täglicher Dhikr';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — nimm dir einen Moment.';

  @override
  String get notificationsPreviewStreakTitle => 'Serie';

  @override
  String get notificationsPreviewStreakBody => '7 Tage vollständige Gebete.';

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
  String get onboardingSelectAppsTitlePrefix => 'Wähle';

  @override
  String get onboardingSelectAppsTitleAccent => 'Apps zum Sperren';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Wähle die Apps, die du zur Gebetszeit sperren möchtest.';

  @override
  String get onboardingSelectAppsButton => 'Apps auswählen';

  @override
  String get onboardingSelectAppsSkipForNow => 'Vorerst überspringen';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'Du hast die Kontrolle';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'Wir lesen deine Daten nie. Wir sperren nur die Apps, die du wählst.';

  @override
  String get onboardingSelectAppsMockAllApps => 'Alle Apps & Kategorien';

  @override
  String get onboardingSelectAppsMockPhotos => 'Fotos';

  @override
  String get onboardingSelectAppsMockNotes => 'Notizen';

  @override
  String get onboardingSelectAppsMockMusic => 'Musik';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => 'Podcasts';

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
  String get onboardingWidgetsLiveTitle => 'Deine Gebete, immer in Reichweite';

  @override
  String get onboardingWidgetsLiveSubtitle =>
      'Bleib verbunden mit dem, was am wichtigsten ist — direkt vom Home- oder Sperrbildschirm.';

  @override
  String get onboardingWidgetsSectionTitle => 'Widgets';

  @override
  String get onboardingWidgetsSectionBodyPrefix =>
      'Sieh das nächste Gebet, Serien und Fortschritt ';

  @override
  String get onboardingWidgetsSectionBodyEmphasis => 'auf einen Blick.';

  @override
  String get onboardingLiveActivitiesSectionTitle => 'Live Activity';

  @override
  String get onboardingLiveActivitiesSectionBodyPrefix =>
      'Sieh Gebets-Updates ';

  @override
  String get onboardingLiveActivitiesSectionBodyEmphasis => 'in Echtzeit';

  @override
  String get onboardingLiveActivitiesSectionBodySuffix =>
      ' auf Sperrbildschirm und Dynamic Island.';

  @override
  String get onboardingWidgetsLiveTrustPrefix => 'Entwickelt, damit du ';

  @override
  String get onboardingWidgetsLiveTrustEmphasis => 'beständig';

  @override
  String get onboardingWidgetsLiveTrustSuffix =>
      ' zu bleiben und nichts Wichtiges zu verpassen.';

  @override
  String get onboardingWidgetsMockStreak => 'Serie';

  @override
  String get onboardingWidgetsMockStreakValue => '12 Tage';

  @override
  String get onboardingWidgetsMockFocus => 'Fokus';

  @override
  String get onboardingWidgetsMockFocusValue => '25 Min.';

  @override
  String get onboardingWidgetsLiveLockDate => 'Dienstag, 6. Mai';

  @override
  String get onboardingWidgetsLiveLockTime => '9:41';

  @override
  String get onboardingWidgetsLiveNextPrayer => 'Dhuhr 12:45, in 02:15:32';

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
  String get restrictedModeSalahTitle => 'Gebetszeit';

  @override
  String get restrictedModeSalahMessage =>
      'Tritt von Ablenkungen zurück und folge dem Gebetsruf.';

  @override
  String get restrictedModeSalahInfo =>
      'Nutze diesen Moment, um dich mit Allah zu verbinden.';

  @override
  String get restrictedModeSalahQuote =>
      'Verrichte das Gebet zu Meinem Gedenken.';

  @override
  String get restrictedModeSalahQuoteSource => 'Quran 20:14';

  @override
  String get restrictedModeSalahCta => 'Gebet beginnen';

  @override
  String get restrictedModeChildTitle => 'Kind-Fokusmodus';

  @override
  String get restrictedModeChildMessage =>
      'Ein sichererer, ausgewogenerer Raum für fokussierte Bildschirmzeit.';

  @override
  String get restrictedModeChildInfo =>
      'Einige Apps sind vorübergehend nicht verfügbar.';

  @override
  String get restrictedModeChildQuote =>
      'Lehrt eure Kinder das Gebet, wenn sie sieben sind.';

  @override
  String get restrictedModeChildQuoteSource => 'Hadith - Abu Dawud';

  @override
  String get restrictedModeChildCta => 'Geschützt bleiben';

  @override
  String get restrictedModeNightTitle => 'Nacht-Fokusmodus';

  @override
  String get restrictedModeNightMessage =>
      'Zeit, sich auszuruhen und von digitalen Ablenkungen zu trennen.';

  @override
  String get restrictedModeNightInfo =>
      'Lege dein Gerät beiseite und genieße eine ruhige Nacht.';

  @override
  String get restrictedModeNightQuote =>
      'Und Wir machten euren Schlaf zur Ruhe.';

  @override
  String get restrictedModeNightQuoteSource => 'Quran 78:9';

  @override
  String get restrictedModeNightCta => 'Gute Nacht';

  @override
  String get restrictedModeAppsUnavailable =>
      'Einige Apps sind vorübergehend nicht verfügbar.';

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
  String get investNoCommitment => 'Keine Bindung. Jederzeit kündbar.';

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
  String get homeSearchNearbyMosques =>
      'Moscheen in der Nähe über OpenStreetMap finden.';

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
  String get homeTapPrayerToMark =>
      'Tippe auf ein Gebet, um es als gebetet, nachgeholt oder verpasst zu markieren.';

  @override
  String get homeSetLocation => 'Standort festlegen';

  @override
  String get homeEditPrayerSettings => 'Gebetseinstellungen bearbeiten';

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
  String get calendarTitle => 'Islamischer Kalender';

  @override
  String get calendarBack => 'Zurück';

  @override
  String get calendarToday => 'Heute';

  @override
  String get calendarTomorrow => 'Morgen';

  @override
  String calendarDaysAway(int days) {
    return '$days Tage';
  }

  @override
  String get calendarNoEventsThisWeek =>
      'Keine islamischen Ereignisse diese Woche.';

  @override
  String get calendarNoEventsBlessing =>
      'Möge Allah deine Woche mit Frieden und Güte segnen.';

  @override
  String get calendarNoUpcomingEvents =>
      'Keine bevorstehenden islamischen Ereignisse gefunden.';

  @override
  String get calendarUpcomingEvents => 'Bevorstehende islamische Ereignisse';

  @override
  String get calendarUpcomingThisYear => 'Bevorstehend in diesem Jahr';

  @override
  String get calendarThisWeekObservances => 'Diese Woche';

  @override
  String get calendarLegendCycleDays => 'Zyklustage (Serie geschützt)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% beleuchtet';
  }

  @override
  String get calendarMoonNew => 'Neumond';

  @override
  String get calendarMoonWaxingCrescent => 'Zunehmende Sichel';

  @override
  String get calendarMoonFirstQuarter => 'Erstes Viertel';

  @override
  String get calendarMoonWaxingGibbous => 'Zunehmender Mond';

  @override
  String get calendarMoonFull => 'Vollmond';

  @override
  String get calendarMoonWaningGibbous => 'Abnehmender Mond';

  @override
  String get calendarMoonLastQuarter => 'Letztes Viertel';

  @override
  String get calendarMoonWaningCrescent => 'Abnehmende Sichel';

  @override
  String get calendarEventRamadanBegins => 'Ramadan beginnt';

  @override
  String get calendarEventRamadanBeginsDesc => 'Monat des Fastens';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Nacht der Bestimmung';

  @override
  String get calendarEventEidAlFitr => 'Eid al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc => 'Fest des Fastenbrechens';

  @override
  String get calendarEventDayOfArafah => 'Tag von Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Tag des Stehens auf Arafah';

  @override
  String get calendarEventEidAlAdha => 'Eid al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Opferfest';

  @override
  String get calendarEventIslamicNewYear => 'Islamischer Neujahrstag';

  @override
  String get calendarEventIslamicNewYearDesc => '1. Muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Geburt des Propheten';

  @override
  String get calendarEventAshura => 'Ashura';

  @override
  String get calendarEventAshuraDesc => '10. Muharram';

  @override
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Freitagsgebet in der Gemeinde';

  @override
  String get calendarEventWhiteDays => 'Weiße Tage';

  @override
  String get calendarEventWhiteDaysDesc => 'Empfohlene Fastentage';

  @override
  String get cycleModeActiveTitle => 'Dein Zyklus ist eine Pause, kein Stopp.';

  @override
  String get cycleModeActiveSubtitle => 'Dhikr • Tasbih • Quran hören';

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
  String get cycleModePauseStreaksLabel => 'Gebets-Serie schützen';

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
  String get prayerNotificationSubtitleFajr =>
      '„Wahrlich, die Rezitation der Morgendämmerung wird bezeugt.“ — Qur’an 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '„Verrichtet das Gebet beim Sinken der Sonne...“ — Qur’an 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '„Haltet die Gebete ein, besonders das mittlere Gebet.“ — Qur’an 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '„So preist Allah, wenn ihr den Abend erreicht...“ — Qur’an 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '„Verrichtet das Gebet -  bis zur Dunkelheit der Nacht.“ — Qur’an 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'Es ist Zeit für $prayerName';
  }

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
  String get homeLivePrayerUpdatesTitle => 'Live-Gebetsupdates';

  @override
  String get homeLivePrayerUpdatesBody =>
      'Sieh aktuelles und nächstes Gebet auf dem Sperrbildschirm & Dynamic Island.';

  @override
  String get homeLivePrayerUpdatesCta => 'Live-Updates aktivieren';

  @override
  String get homeWidgetsPromoTitle => 'Widgets';

  @override
  String get homeWidgetsPromoBody =>
      'Sieh deinen Tagesvers und die Gebetszeiten auf dem Home-Bildschirm.';

  @override
  String get homeWidgetsPromoCta => 'Widget hinzufügen';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Nacht';

  @override
  String get focusModeShortChild => 'Kind';

  @override
  String get focusModeLabelSalah => 'Salah-Modus';

  @override
  String get focusModeLabelNight => 'Nachtmodus';

  @override
  String get focusModeLabelChild => 'Kindermodus';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return '$first- und $second-Modi sind aktiviert';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return '$first-, $second- und $third-Modi sind aktiviert';
  }

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
  String get dailyChecklistSectionDistraction => 'Persönliche Disziplin';

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
  String get quickActionsSupportUs => 'Spenden';

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
  String get supportUsWhatsAppQuestionHowTo => 'Wie benutze ich DeenFocus?';

  @override
  String get supportUsWhatsAppQuestionFeature =>
      'Ich brauche Hilfe bei einer Funktion';

  @override
  String get supportUsWhatsAppQuestionSubscription =>
      'Ich habe ein Problem mit meinem Abo';

  @override
  String get supportUsEmailSubject => 'DeenFocus Support-Anfrage';

  @override
  String get supportUsLaunchUnavailable =>
      'Diese App konnte auf diesem Gerät nicht geöffnet werden.';

  @override
  String get supportUsLaunchFailed =>
      'Etwas ist schiefgelaufen. Bitte erneut versuchen.';

  @override
  String get supportUsThankYouTitle => 'JazakAllah khair';

  @override
  String get supportUsThankYouBody =>
      'Danke, dass du DeenFocus unterstützt. Du kannst jederzeit erneut unterstützen.';

  @override
  String get supportUsPurchasePending =>
      'Deine Unterstützung ist ausstehend. Wir bestätigen sie, sobald Apple den Kauf abschließt.';

  @override
  String get supportUsPurchaseFailed =>
      'Die Unterstützung konnte nicht abgeschlossen werden. Bitte versuche es erneut.';

  @override
  String get supportUsProductUnavailable =>
      'Dieser Unterstützungsbetrag ist gerade nicht verfügbar. Bitte versuche es später erneut.';

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
  String get tabQuran => 'Lernen';

  @override
  String get tabLearn => 'Lernen';

  @override
  String get quranLoadFailed => 'Korandaten konnten nicht geladen werden';

  @override
  String get quranTabSubtitle => 'Lesen und erforschen Sie den Heiligen Koran';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Sure suchen...';

  @override
  String get quranSearchHintExtended => 'Sure oder Bedeutung suchen...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranNoSurahsFound => 'Keine Suren gefunden';

  @override
  String get quranVersesLabel => 'Verse';

  @override
  String quranSurahHeaderSubtitle(String name, int count) {
    return '$name • $count Verse';
  }

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
  String get quranModeSurah => 'Sure';

  @override
  String get quranModeJuz => 'Dschuz';

  @override
  String get quranModePage => 'Seite';

  @override
  String get quranSwitchToPageView => 'Seitenansicht';

  @override
  String get quranSwitchToSurahView => 'Surenansicht';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => 'Weiterlesen';

  @override
  String get quranPreviousAyah => 'Previous ayah';

  @override
  String get quranNextAyah => 'Next ayah';

  @override
  String get quranPreviousJuz => 'Previous Juz';

  @override
  String get quranNextJuz => 'Next Juz';

  @override
  String get quranPreviousPage => 'Previous page';

  @override
  String get quranNextPage => 'Next page';

  @override
  String get quranMarkPageRead => 'Read';

  @override
  String quranPageMarkedRead(int page) {
    return 'Page $page marked as read';
  }

  @override
  String get quranMushafComplete => 'Complete';

  @override
  String get quranPageEmpty => 'No ayahs on this page';

  @override
  String get quranTranslationUnavailable =>
      'Translation not available for this ayah';

  @override
  String quranJuzProgressLabel(int percent, int juz) {
    return '$percent% von Dschuz $juz';
  }

  @override
  String get quranBookmarksTitle => 'Lesezeichen';

  @override
  String get quranBookmarksEmpty => 'No bookmarks yet';

  @override
  String get quranBookmark => 'Bookmark';

  @override
  String get quranBookmarkSaved => 'Bookmark saved';

  @override
  String get quranBookmarkRemoved => 'Bookmark removed';

  @override
  String quranBookmarkCount(int count) {
    return '$count gespeichert';
  }

  @override
  String get quranQuickTajweed => 'Tadschwid-Übung';

  @override
  String get quranQuickTajweedSub => 'Rezitieren & bewerten';

  @override
  String get quranLastListened => 'Zuletzt gehört';

  @override
  String get quranNoneYet => 'Noch keine';

  @override
  String get quranOpenPage => 'Open page';

  @override
  String get quranOpenJuz => 'Open Juz';

  @override
  String get quranOpenAyah => 'Open ayah';

  @override
  String get quranReadingToolsTitle => 'Reading tools';

  @override
  String get quranQuickActions => 'Quick actions';

  @override
  String get quranReadingToolsHint =>
      'Tafsir, color Tajweed, word-by-word, and extra reciters coming soon.';

  @override
  String get quranCopy => 'Copy';

  @override
  String get quranShare => 'Share';

  @override
  String get quranCopied => 'Copied to clipboard';

  @override
  String get quranShareCopiedHint => 'Copied — paste to share';

  @override
  String get quranColorTajweed => 'Color Tajweed';

  @override
  String get quranTafsir => 'Tafsir';

  @override
  String get quranWordByWord => 'Word-by-word';

  @override
  String get quranReciters => 'Reciters';

  @override
  String get quranComingSoon => 'Coming soon';

  @override
  String get tajweedDisabledHint =>
      'Enable AI Tajweed Practice in Reading Settings';

  @override
  String get readingSettingsTajweedPractice => 'KI-Koran-Tadschwid';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Rezitiere Verse und erhalte Feedback';

  @override
  String get readingSettingsTajweedSeeHowItWorks => 'So funktioniert’s';

  @override
  String get quranSeeHowAiQuranTajweedWorks => 'see how AI Quran Tajweed works';

  @override
  String get readingSettingsTajweedDeleteModel => 'KI-Modell löschen';

  @override
  String get readingSettingsTajweedDeleteConfirmTitle =>
      'KI-Koran-Tadschwid-Modell löschen?';

  @override
  String get readingSettingsTajweedDeleteConfirmBody =>
      'Du kannst Tadschwid erst wieder üben, wenn du das KI-Modell erneut herunterlädst. Dadurch wird auch Speicherplatz freigegeben.';

  @override
  String get readingSettingsTajweedDeleteConfirmAction => 'Löschen';

  @override
  String get readingSettingsTajweedDeleted => 'KI-Tadschwid-Modell gelöscht';

  @override
  String get readingSettingsTajweedDeleteFailed =>
      'KI-Tadschwid-Modell konnte nicht gelöscht werden';

  @override
  String get readingSettingsTajweedFreePreviewTranslation =>
      'Im Namen Allahs, des Allerbarmers, des Barmherzigen.';

  @override
  String get quranAudioSettingsTitle => 'Audio settings';

  @override
  String get quranPlaybackSpeed => 'Playback speed';

  @override
  String get quranVolume => 'Volume';

  @override
  String get quranRepeat => 'Repeat';

  @override
  String get quranRepeatOff => 'Off';

  @override
  String get quranRepeatAyah => 'Ayah';

  @override
  String get quranRepeatSurah => 'Surah';

  @override
  String get readingSettingsTitle => 'Leseeinstellungen';

  @override
  String get readingSettingsArabicFontSize => 'Arabische Schriftgröße';

  @override
  String get readingSettingsTranslationFontSize => 'Übersetzungs-Schriftgröße';

  @override
  String get readingSettingsLineSpacing => 'Zeilenabstand';

  @override
  String get readingSettingsDefaultMode => 'Standard-Lesemodus';

  @override
  String get readingSettingsRememberPosition => 'Letzte Position merken';

  @override
  String get readingSettingsScript => 'Arabische Schrift';

  @override
  String get readingSettingsScriptUthmani => 'Uthmani (Hafs)';

  @override
  String get readingSettingsScriptIndopak => 'IndoPak (Hafs)';

  @override
  String get readingSettingsArabicFont => 'Arabische Schriftart';

  @override
  String get readingSettingsFontUthmanic => 'Uthmanic Hafs';

  @override
  String get readingSettingsFontNooreHuda => 'Noore Huda';

  @override
  String get readingSettingsFontSystem => 'System (nativ)';

  @override
  String get readingSettingsShowTranslation => 'Übersetzung anzeigen';

  @override
  String get readingSettingsShowTransliteration => 'Transliteration anzeigen';

  @override
  String get readingSettingsTranslationSection => 'Übersetzung';

  @override
  String get readingSettingsTranslationLabel => 'Übersetzung';

  @override
  String get readingSettingsTranslationCurrent => 'Aktuell';

  @override
  String get readingSettingsInstalledTranslations => 'Installiert';

  @override
  String get readingSettingsAvailableTranslations => 'Verfügbar';

  @override
  String get readingSettingsTranslationInstalled => 'Installiert';

  @override
  String get readingSettingsTranslationSelected => 'Ausgewählt';

  @override
  String get readingSettingsTranslationDownload => 'Laden';

  @override
  String get readingSettingsTranslationInstalling => 'Wird installiert…';

  @override
  String get readingSettingsTranslationDownloading => 'Wird heruntergeladen…';

  @override
  String get readingSettingsLayoutTheme => 'Koran-Layout';

  @override
  String get readingSettingsLayoutClassic => 'Mushaf';

  @override
  String get readingSettingsLayoutSimple => 'Einfach';

  @override
  String get readingSettingsLayoutColor => 'Farbiger Koran';

  @override
  String get readingSettingsColorTheme => 'Lesethema';

  @override
  String get readingSettingsColorThemeParchment => 'Pergament';

  @override
  String get readingSettingsColorThemeEmerald => 'Smaragd';

  @override
  String get readingSettingsColorThemeMidnight => 'Mitternacht';

  @override
  String get readingSettingsPreview => 'Vorschau';

  @override
  String get readingSettingsResetHistoryTitle => 'Lesedaten zurücksetzen';

  @override
  String get readingSettingsResetHistorySubtitle =>
      'Löscht Weiterlesen, Seitenfortschritt, Lesezeichen und Schnellaktionen';

  @override
  String get readingSettingsResetHistoryConfirmTitle =>
      'Lesedaten zurücksetzen?';

  @override
  String get readingSettingsResetHistoryConfirmBody =>
      'Dadurch werden Weiterlesen, Seitenfortschritt, Lesezeichen, zuletzt gehört und Tadschwid-Verknüpfungen entfernt. Anzeige- und Übersetzungseinstellungen bleiben erhalten.';

  @override
  String get readingSettingsResetHistoryDone => 'Lesedaten gelöscht';

  @override
  String get readingSettingsResetHistoryButton => 'Zurücksetzen';

  @override
  String readingSettingsTranslationDownloadFailed(String name) {
    return '$name konnte nicht geladen werden. Versuche es erneut, wenn du online bist.';
  }

  @override
  String readingSettingsTranslationSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => 'Mit dem Rezitieren beginnen';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'WORTGENAUIGKEIT';

  @override
  String get tajweedWordReviewLabel => 'WORTÜBERSICHT';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Rezitieren & Tadschwid prüfen';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nasal, 2 Zählzeiten';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Echo-Sprung';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Vokal verlängern';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Buchstaben verschmelzen';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Nun verbergen';

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
  String tasbihLoopLabel(int number) {
    return 'Loop $number';
  }

  @override
  String get tasbihCurrentDhikr => 'Current Dhikr';

  @override
  String get tasbihViewAll => 'View All';

  @override
  String get tasbihSaveSession => 'Save session';

  @override
  String get tasbihSessionSaved => 'Session saved';

  @override
  String get tasbihSwipeHint =>
      'Slide beads through the center · reverse to undo';

  @override
  String get tasbihEditGoalTitle => 'Set goal';

  @override
  String get tasbihCustomGoalHint => 'Enter a number (e.g. 33)';

  @override
  String get tasbihSoundOn => 'Sound on';

  @override
  String get tasbihSoundOff => 'Sound off';

  @override
  String tasbihSessionSummary(int total, int goal, int loops) {
    return 'Total this session $total · Goal $goal · Loops completed $loops';
  }

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
  String get widgetPrayerProgressTitle => 'Dein Gebetsfortschritt';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed von $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'Gebete abgeschlossen.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Weiter so — noch $count Gebete heute';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — alle Gebete heute erledigt';

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
  String get settingsRateDeenFocus => 'DeenFocus bewerten ⭐';

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
      'Bleib beständig. Bleib achtsam. Bleib mit deinem Deen verbunden.';

  @override
  String get settingsAboutOffersHeading => 'Was Deen Focus bietet';

  @override
  String get settingsAboutNewBadge => 'Neu';

  @override
  String get settingsAboutFooterCard =>
      'Intelligente Tools, die dir helfen, achtsam, beständig und mit deinem Deen verbunden zu bleiben — jeden Tag.';

  @override
  String get settingsAboutOfferPrayerTimesTitle => 'Genaue Gebetszeiten';

  @override
  String get settingsAboutOfferPrayerTimesSubtitle =>
      'Rechtzeitige Gebetsbenachrichtigungen und schöne Widgets, damit du auf Kurs bleibst.';

  @override
  String get settingsAboutOfferPrayerStreaksTitle => 'Gebets-Streaks';

  @override
  String get settingsAboutOfferPrayerStreaksSubtitle =>
      'Baue Beständigkeit auf und wachse in deinem Deen mit täglicher und gesamter Streak-Verfolgung.';

  @override
  String get settingsAboutOfferCycleModeTitle => 'Zyklusmodus';

  @override
  String get settingsAboutOfferCycleModeSubtitle =>
      'Für die Menstruation — pausiere Gebete, behalte deinen Streak und setze deine Reise fort.';

  @override
  String get settingsAboutOfferQuranTajweedTitle => 'Al-Quran Tajweed';

  @override
  String get settingsAboutOfferQuranTajweedSubtitle =>
      'Lies, höre und übe Tajweed mit unserem KI-gestützten Echtzeit-Feedback.';

  @override
  String get settingsAboutOfferLiveActivitiesTitle => 'Live Activities';

  @override
  String get settingsAboutOfferLiveActivitiesSubtitle =>
      'Bleib über laufende Gebete und Fokussitzungen direkt vom Sperrbildschirm informiert.';

  @override
  String get settingsAboutOfferQiblaTitle => 'Qibla- & Moscheefinder';

  @override
  String get settingsAboutOfferQiblaSubtitle =>
      'Finde jederzeit die Qibla-Richtung und entdecke Moscheen in deiner Nähe.';

  @override
  String get settingsAboutOfferFocusModesTitle => 'Fokusmodi';

  @override
  String get settingsAboutOfferFocusModesSubtitle =>
      'Blockiere ablenkende Apps während Salah, Schlaf, Lernen oder Familienzeit.';

  @override
  String get settingsAboutOfferTasbihTitle => 'Tasbih & Dhikr';

  @override
  String get settingsAboutOfferTasbihSubtitle =>
      'Digitaler Tasbih, der dir hilft, Allah den ganzen Tag zu gedenken.';

  @override
  String get settingsAboutOfferCalendarTitle => 'Islamischer Kalender';

  @override
  String get settingsAboutOfferCalendarSubtitle =>
      'Hidschri-Kalender mit wichtigen islamischen Daten und Erinnerungen.';

  @override
  String get settingsAboutGridNamesTitle => '99 Namen Allahs';

  @override
  String get settingsAboutGridNamesSubtitle =>
      'Lerne und reflektiere über Asma ul-Husna.';

  @override
  String get settingsAboutGridDuasTitle => 'Duas & Adhkar';

  @override
  String get settingsAboutGridDuasSubtitle =>
      'Morgen-, Abend- und tägliche Duas.';

  @override
  String get settingsAboutGridPrayerTitle => 'Gebet & Rituale';

  @override
  String get settingsAboutGridPrayerSubtitle =>
      'Lerne Salah, Wudu, Hajj und mehr.';

  @override
  String get settingsAboutGridFiqhTitle => 'Fiqh & Traditionen';

  @override
  String get settingsAboutGridFiqhSubtitle =>
      'Entdecke authentisches islamisches Wissen.';

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
  String get nearbyMosquesTitle => 'Moscheen in der Nähe gefunden';

  @override
  String get nearbyMosquesTryAgain => 'Versuchen Sie es erneut';

  @override
  String get nearbyMosquesOpenGoogle => 'In Google Maps öffnen';

  @override
  String get nearbyMosquesOpenApple => 'In Apple Maps öffnen';

  @override
  String get nearbyMosquesNoMosquesFoundWithin => 'Keine Moscheen gefunden';

  @override
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Suchradius: $radiusKm km';
  }

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
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'Keine Moscheen im Umkreis von $radiusKm km gefunden';
  }

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
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'Im Umkreis von $radiusKm km ist auf OpenStreetMap für diesen Ort nichts aufgeführt. Später erneut versuchen oder den Bereich erweitern.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count Moscheen im Umkreis von $radiusKm km gefunden';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count Moscheen in der Nähe';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'Innerhalb $radiusKm km · Nach Entfernung sortiert';
  }

  @override
  String get nearbyMosquesDirections => 'Route';

  @override
  String get nearbyMosquesDenominationSunni => 'Sunnitisch';

  @override
  String get nearbyMosquesDenominationShia => 'Schiitisch';

  @override
  String get nearbyMosquesDenominationAhlEHadith => 'Ahl-e-Hadith';

  @override
  String get nearbyMosquesDenominationNotSpecified =>
      'Konfession nicht angegeben';

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
  String get focusDiagnosticButton => 'Diagnose';

  @override
  String get focusDiagnosticTitle => 'App-Sperre testen';

  @override
  String get focusDiagnosticIntro =>
      'Sperre deine ausgewählten Apps 60 Sekunden lang vorübergehend mit derselben App-Sperre wie im Fokusmodus. Öffne eine gesperrte App, um zu prüfen, ob der DeenFocus-Sperrbildschirm erscheint.';

  @override
  String focusDiagnosticIntroWithApp(String appName) {
    return 'Sperre deine ausgewählten Apps 60 Sekunden lang vorübergehend. Öffne $appName, um zu prüfen, ob der DeenFocus-Sperrbildschirm erscheint.';
  }

  @override
  String get focusDiagnosticStart => 'Test starten';

  @override
  String get focusDiagnosticEndEarly => 'Test beenden';

  @override
  String focusDiagnosticRunning(int seconds) {
    return 'App-Sperre ist für ${seconds}s aktiv. Wechsle zu einer ausgewählten App, um den Sperrbildschirm zu testen.';
  }

  @override
  String get focusDiagnosticSuccessTitle => 'Test abgeschlossen';

  @override
  String get focusDiagnosticSuccessBody =>
      'App-Sperre wurde mit deinen ausgewählten Apps aktiviert. Wenn du den DeenFocus-Sperrbildschirm gesehen hast, funktioniert die App-Sperre.';

  @override
  String get focusDiagnosticCancelledTitle => 'Test beendet';

  @override
  String get focusDiagnosticCancelledBody =>
      'Die Diagnose-Sperre wurde ausgeschaltet. Deine Fokusmodi und Zeitpläne wurden nicht geändert.';

  @override
  String get focusDiagnosticMissingAppsTitle => 'Zuerst Apps auswählen';

  @override
  String get focusDiagnosticMissingAppsBody =>
      'Wähle mindestens eine App zum Sperren, bevor du den App-Sperre-Test startest.';

  @override
  String get focusDiagnosticMissingPermissionTitle =>
      'Berechtigung erforderlich';

  @override
  String get focusDiagnosticMissingPermissionBodyIos =>
      'Bildschirmzeit-Zugriff ist zum Sperren von Apps erforderlich. Erlaube Bildschirmzeit und versuche es erneut.';

  @override
  String get focusDiagnosticMissingPermissionBodyAndroid =>
      'Android-Bedienungshilfen müssen für DeenFocus aktiviert sein, damit App-Sperre funktioniert.';

  @override
  String get focusDiagnosticFailedTitle => 'Test konnte nicht gestartet werden';

  @override
  String get focusDiagnosticFailedBody =>
      'App-Sperre wurde nicht aktiviert. Prüfe Berechtigungen und ausgewählte Apps und versuche es erneut.';

  @override
  String get focusDiagnosticClose => 'Fertig';

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
    return '$count Gebete';
  }

  @override
  String get insightsPrayersInARow => 'Gebete hintereinander';

  @override
  String get insightsDaysInARow => 'Tage hintereinander';

  @override
  String insightsChipUpToday(int count) {
    return '↑ $count';
  }

  @override
  String get insightsChipDayUp => '↑ 1 heute';

  @override
  String get insightsWeeklyCompletion => 'Wöchentliche Erfüllung';

  @override
  String get insightsMonthlyCompletion => 'Monatliche Erfüllung';

  @override
  String get insightsThisWeek => 'Diese Woche';

  @override
  String get insightsThisMonth => 'Dieser Monat';

  @override
  String get insightsOverall => 'Gesamt';

  @override
  String get insightsRateExcellent => 'Ausgezeichnet';

  @override
  String get insightsRateGood => 'Gut';

  @override
  String get insightsRateFair => 'In Ordnung';

  @override
  String get insightsRateStart => 'Weiter so';

  @override
  String get insightsPrayersCompletedWeekly => 'Gebete erfüllt (wöchentlich)';

  @override
  String get insightsPrayersCompletedMonthly => 'Gebete erfüllt (monatlich)';

  @override
  String insightsCompletionSummary(int done, int possible) {
    return 'Du hast $done von $possible Gebeten erfüllt.\nAlhamdulillah — weiter so!';
  }

  @override
  String get insightsFocusExcellent => 'Ausgezeichnet — weiter so!';

  @override
  String get insightsFocusKeepGoing => 'Baue deinen Fokus weiter aus';

  @override
  String get insightsTodaysPrayers => 'Heutige Gebete';

  @override
  String get insightsPrayersCompletedLabel => 'Gebete erfüllt — Alhamdulillah!';

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
  String get insightsMyProgress => 'Mein Fortschritt';

  @override
  String insightsLevelNumber(int level) {
    return 'Stufe $level';
  }

  @override
  String insightsXpProgress(String current, String next) {
    return '$current / $next XP';
  }

  @override
  String insightsXpTotal(String xp) {
    return '$xp XP';
  }

  @override
  String insightsXpToNext(String xp, int level) {
    return '$xp XP bis Stufe $level';
  }

  @override
  String get insightsMaxLevel => 'MAXIMALE STUFE';

  @override
  String insightsAchievementsUnlocked(int unlocked, int total) {
    return '$unlocked / $total freigeschaltet';
  }

  @override
  String get insightsAchievementUnlockedTitle => 'Erfolg freigeschaltet';

  @override
  String get insightsLevelUpTitle => 'STUFENAUFSTIEG';

  @override
  String get achievementFirstPrayer => 'Erstes Gebet';

  @override
  String get achievementFajrChampion => 'Fajr-Champion';

  @override
  String get achievementFiveADay => 'Fünf am Tag';

  @override
  String get achievementPerfectWeek => 'Perfekte Woche';

  @override
  String get achievementPerfectMonth => 'Perfekter Monat';

  @override
  String get achievementQuranDevotee => 'Quran-Freund';

  @override
  String get achievementDhikrStarter => 'Dhikr-Start';

  @override
  String get achievementNightWorshipper => 'Nachtanbeter';

  @override
  String get achievementMasjidCompanion => 'Moschee-Begleiter';

  @override
  String get achievementDistractionDefender => 'Fokus-Hüter';

  @override
  String get achievementCycleGuardian => 'Zyklus-Hüter';

  @override
  String get achievementProtectedMonth => 'Geschützter Monat';

  @override
  String get achievementSixMonthJourney => 'Sechs-Monats-Reise';

  @override
  String get achievementDeenFocusMaster => 'DeenFocus Master';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Zyklustage sind geschützt und gelten nicht als Serienbruch. Du hast $days geschützte(n) Tag(e).';
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

  @override
  String get appLockDemoIntroTitle => 'So funktioniert App-Sperre';

  @override
  String get appLockDemoIntroSubtitle =>
      'Bleib in DeenFocus. Tippe auf dem nächsten Bildschirm auf Instagram, um zu sehen, wie es zur Gebetszeit pausiert.';

  @override
  String get appLockDemoStartButton => 'Demo starten';

  @override
  String get appLockDemoTryOpeningApp => 'Versuch, Instagram zu öffnen';

  @override
  String get appLockDemoSalahModeBadge => 'SALAH-MODUS';

  @override
  String get appLockDemoTimeToPray => 'Es ist Zeit zum Beten';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Verbleibende Zeit: $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'Ich habe $prayerName gebetet';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName abgeschlossen';
  }

  @override
  String get appLockDemoStreakIncreased => 'Dein Gebetsstreak ist gestiegen';

  @override
  String get appLockDemoPrayerStreakLabel => 'GEBETSSTREAK';

  @override
  String get appLockDemoDayStreakLabel => 'TAGESSTREAK';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Nächstes Gebet in $minutes Minuten';
  }

  @override
  String get appLockDemoStreakMotivation =>
      'Weiter so! Deine Beständigkeit bringt dich Allah näher.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Bete. Einmal einchecken.\nZurück in deinen Tag.';

  @override
  String get appLockDemoCompletionBody =>
      'App-Sperre pausiert ausgewählte Apps sanft während Salah, damit du dich aufs Gebet konzentrieren kannst — danach machst du weiter.';

  @override
  String get appLockDemoContinueSetup => 'Einrichtung fortsetzen';

  @override
  String get appLockDemoAppMessages => 'Nachrichten';

  @override
  String get appLockDemoAppCalendar => 'Kalender';

  @override
  String get appLockDemoAppPhotos => 'Fotos';

  @override
  String get appLockDemoAppCamera => 'Kamera';

  @override
  String get appLockDemoAppMail => 'Mail';

  @override
  String get appLockDemoAppMaps => 'Karten';

  @override
  String get appLockDemoAppWeather => 'Wetter';

  @override
  String get appLockDemoAppClock => 'Uhr';

  @override
  String get appLockDemoAppNotes => 'Notizen';

  @override
  String get appLockDemoAppSettings => 'Einstellungen';

  @override
  String get appLockDemoAppMusic => 'Musik';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Gebets-Updates';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live-Aktivität für dein nächstes Gebet auf dem Sperrbildschirm';

  @override
  String get liveActivitySectionTitle => 'Live-Aktivitäten';

  @override
  String get liveActivityStayUpdatedTitle => 'Auf einen Blick informiert';

  @override
  String get liveActivityStayUpdatedBody =>
      'Sieh dein nächstes Gebet und seine Zeit direkt auf dem Sperrbildschirm.';

  @override
  String get liveActivityEnableLabel => 'Live-Aktivität aktivieren';

  @override
  String get liveActivityPromptNotNow => 'Nicht jetzt';

  @override
  String get liveActivityUnsupported =>
      'Live-Aktivitäten sind auf diesem Gerät nicht verfügbar.';

  @override
  String get liveActivityPermissionNeeded =>
      'Erlaube Mitteilungen, damit Gebets-Updates auf dem Sperrbildschirm erscheinen.';

  @override
  String get liveActivityPermissionButton => 'Mitteilungen erlauben';

  @override
  String get liveActivityStatusActive => 'Live-Aktivität ist aktiv';

  @override
  String get liveActivityStatusOff => 'Live-Aktivität ist aus';

  @override
  String get liveActivityEnabledPromptTitle => 'Live Activity is on';

  @override
  String get liveActivityEnabledPromptBodyIos =>
      'Prayer updates are now on your Lock Screen and Dynamic Island. Lock your phone to see your current and next prayer anytime.';

  @override
  String get liveActivityEnabledPromptBodyAndroid =>
      'Prayer updates now show as an ongoing notification. Lock your phone or pull down the notification shade to check anytime.';

  @override
  String get liveActivityEnabledPromptButton => 'Got it';

  @override
  String get liveActivityNowLabel => 'Jetzt';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Aktualisiert um $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer um $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Gebetsalarme';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Volle Gebetsalarme, die den Stummmodus durchbrechen können';

  @override
  String get prayerAlarmsMasterLabel => 'Gebetsalarme aktivieren';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Einen nativen Alarm für jedes ausgewählte Gebet planen';

  @override
  String get prayerAlarmsSnoozeLabel => 'Schlummerdauer';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Alarme nach Gebet';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Erlauben Sie Alarmberechtigungen, damit Gebetsalarme pünktlich auslösen.';

  @override
  String get prayerAlarmsPermissionButton => 'Alarme erlauben';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Erlauben Sie Vollbildalarme für den Sperrbildschirm. Ohne das erscheinen sie als Banner.';

  @override
  String get prayerAlarmsFsiButton => 'Vollbild-Einstellungen';

  @override
  String get prayerAlarmsUnsupported =>
      'Native Gebetsalarme sind auf diesem Gerät nicht verfügbar. Sanfte Gebetsbenachrichtigungen funktionieren weiterhin.';

  @override
  String get prayerAlarmsIosFallback =>
      'Auf dieser iOS-Version werden sanfte Gebetsbenachrichtigungen statt AlarmKit verwendet.';

  @override
  String get prayerAlarmsDeniedTitle => 'Alarmberechtigung erforderlich';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Gebetsalarme bleiben aus, bis Sie die Alarmberechtigung erlauben. Sanfte Benachrichtigungen sind unberührt.';

  @override
  String get prayerAlarmsOpenSettings => 'Einstellungen öffnen';

  @override
  String get prayerAlarmsStatusReady => 'Alarme sind bereit zur Planung';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Berechtigung nötig — Alarme sind nicht aktiv';

  @override
  String get prayerAlarmsStatusFallback =>
      'Auf diesem Gerät werden sanfte Benachrichtigungen verwendet';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Alarme sind an. Vollbild für Sperrbildschirm aktivieren.';

  @override
  String get prayerAlarmsCancel => 'Nicht jetzt';

  @override
  String get homePrayerAlarmEnableLabel => 'Gebetsalarm';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Nativen Alarm zu $prayerName auslösen';
  }

  @override
  String get prayerAlarmBadge => 'Gebetsalarm';

  @override
  String get prayerAlarmSubtitle => 'Zeit zum Beten';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — Zeit zum Beten';
  }

  @override
  String get prayerAlarmIvePrayed => 'Ich habe gebetet';

  @override
  String get prayerAlarmDismiss => 'Schließen';

  @override
  String get prayerAlarmSnooze => 'Schlummern';

  @override
  String get appLockDemoAppPhone => 'Telefon';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Erinnerungen';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Bücher';

  @override
  String get appLockDemoAppHealth => 'Health';

  @override
  String get appLockDemoAppWallet => 'Wallet';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'App-Demo';

  @override
  String get settingsAppDemoChooseModeTitle => 'App-Sperre erleben';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Wähle einen Fokus-Modus und sieh, wie ausgewählte Apps pausieren — ohne DeenFocus zu verlassen.';

  @override
  String get appLockDemoDone => 'Fertig';

  @override
  String get appLockDemoSleepIntroTitle => 'So funktioniert der Schlafmodus';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Bleib in DeenFocus. Tippe auf dem nächsten Bildschirm auf Instagram, um die Pause zur Schlafenszeit zu sehen.';

  @override
  String get appLockDemoSleepModeBadge => 'SCHLAFMODUS';

  @override
  String get appLockDemoSleepLockTitle => 'Zeit zum Abschalten';

  @override
  String get appLockDemoSleepLockCta => 'Ich bin bereit zu ruhen';

  @override
  String get appLockDemoSleepCompleted => 'Schlafmodus geschützt';

  @override
  String get appLockDemoSleepRewardSubtitle => 'Dein Nachtschutz ist gestiegen';

  @override
  String get appLockDemoSleepStreakLabel => 'NACHTSTREAK';

  @override
  String get appLockDemoSleepRewardFooter =>
      'Fajr-Erinnerung für den Morgen gesetzt';

  @override
  String get appLockDemoSleepMotivation =>
      'Ruhe dich gut aus, damit du gestärkt zu Fajr aufstehst.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Ruhige Nächte.\nKlare Morgen.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'Der Schlafmodus pausiert ausgewählte Apps nachts sanft, damit du ruhen kannst — danach machst du weiter.';

  @override
  String get appLockDemoChildIntroTitle => 'So funktioniert der Kindermodus';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Bleib in DeenFocus. Tippe auf dem nächsten Bildschirm auf Instagram, um die Sperre im Kindermodus zu sehen.';

  @override
  String get appLockDemoChildModeBadge => 'KINDERMODUS';

  @override
  String get appLockDemoChildLockTitle => 'Apps sind geschützt';

  @override
  String get appLockDemoChildLockDetail =>
      'Ausgewählte Apps bleiben im Kindermodus gesperrt';

  @override
  String get appLockDemoChildLockCta => 'Verstanden';

  @override
  String get appLockDemoChildCompleted => 'Kindermodus aktiv';

  @override
  String get appLockDemoChildRewardSubtitle =>
      'Dein Schutzstreak ist gestiegen';

  @override
  String get appLockDemoChildStreakLabel => 'SICHERHEITSSTREAK';

  @override
  String get appLockDemoChildRewardFooter =>
      'Jederzeit mit deinem Passcode beenden';

  @override
  String get appLockDemoChildMotivation =>
      'Ruhe, jedes Mal wenn du dein Handy weitergibst.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'Sicherer Modus mit einem Tipp.\nNur was du erlaubst.';

  @override
  String get appLockDemoChildCompletionBody =>
      'Der Kindermodus sperrt ausgewählte Apps, damit dein Kind nur Sicheres sieht — danach entsperrst du, wenn du bereit bist.';

  @override
  String get appLockDemoSleepCompletionTitle => 'Ruhe dich gut aus';

  @override
  String get appLockDemoChildCompletionTitle => 'Mit gutem Gefühl';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Pausiere Ablenkungen zur Salah, damit du mit Präsenz beten kannst.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Schütze deine Nächte, damit Ruhe leichter fällt — und Fajr leichter wird.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Gib dein Handy mit Zuversicht weiter — nur erlaubte Apps bleiben offen.';

  @override
  String get settingsAppDemoHomeFeaturesTitle => 'Auf einen Blick verbunden';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'Sieh, wie Widgets und Live Activity Gebetszeiten nah halten — ohne die App zu öffnen.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Tagesvers und Gebetszeiten auf deinem Home-Bildschirm, stets aktuell.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Aktuelles und nächstes Gebet auf Sperrbildschirm und Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Rezitiere einen Vers und erhalte sofortiges Tadschwid-Feedback.';

  @override
  String get featureDemoTajweedTitle => 'Tadschwid';

  @override
  String get featureDemoTajweedIntroTitle =>
      'So funktioniert die Tadschwid-Übung';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Bleib in DeenFocus. Öffne Tadschwid-Übung, rezitiere einen Vers und sieh Wort-für-Wort-Feedback.';

  @override
  String get featureDemoTajweedQuranCallout =>
      'Tippe auf Tadschwid-Übung, um zu starten';

  @override
  String get featureDemoTajweedLegendCallout =>
      'Farbmarkierungen zeigen Tadschwid-Regeln beim Lesen';

  @override
  String get featureDemoTajweedReciteCallout =>
      'Tippe auf Rezitieren & Tadschwid prüfen';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'Einmaliger Download, damit die Übung offline funktioniert';

  @override
  String get featureDemoTajweedMicCallout =>
      'Tippe auf das Mikrofon und beginne zu rezitieren';

  @override
  String get featureDemoTajweedResultCallout =>
      'Sieh, welche Wörter korrekt, verpasst oder zu üben sind';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tadschwid, bereit';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Jederzeit selbstsicher rezitieren.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Öffne Quran → Tadschwid-Übung, um jeden Vers geräteintern zu bewerten — nach dem ersten Download vollständig offline.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 Verse • Mekkanisch';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 Verse • Medinensisch';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => 'Al-Fatihah • 7 Verse';

  @override
  String get featureDemoTajweedSurahMeta => 'SURE 1 • MEKKANISCH';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'Im Namen Allahs, des Allerbarmers, des Barmherzigen.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatihah · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'KI-Modell wird vorbereitet';

  @override
  String get featureDemoTajweedPreparingBody =>
      'Einmaliger Download, damit die Tadschwid-Übung danach vollständig offline funktioniert. Das passiert nur einmal.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Weiter üben — hör die Referenz und versuch es erneut.';

  @override
  String get featureDemoTajweedStatCorrect => 'Richtig';

  @override
  String get featureDemoTajweedStatPronunciation => 'Aussprache';

  @override
  String get featureDemoTajweedStatWrong => 'Falsches Wort';

  @override
  String get featureDemoTajweedStatMissed => 'Verpasst';

  @override
  String get featureDemoTajweedStatExtra => 'Zusätzlich';

  @override
  String get featureDemoContinue => 'Weiter';

  @override
  String get featureDemoSampleStatusTime => '9:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      'Dein Gerät erlaubt Apps nicht, Widgets automatisch zu platzieren. Füge das große DeenFocus-Widget über die Widget-Galerie des Home-Bildschirms hinzu.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Widget vom Home-Bildschirm hinzufügen';

  @override
  String get featureDemoOfferNo => 'Nein';

  @override
  String get featureDemoOfferYes => 'Ja';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      'Möchtest du Live Activity auf deinem Gerät aktivieren?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      'Möchtest du dieses Widget zum Home-Bildschirm hinzufügen?';

  @override
  String get featureDemoWidgetsTitle => 'Widgets';

  @override
  String get featureDemoWidgetsIntroTitle => 'Sieh deine Home-Screen-Widgets';

  @override
  String get featureDemoWidgetsIntroSubtitle =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsShowcaseCallout =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsDetailsTitle => 'Gebetsführung auf einen Blick';

  @override
  String get featureDemoWidgetsDetailsBody =>
      'Das Medium-Widget zeigt den Tagesvers und alle fünf Gebete — aktualisiert beim Öffnen von DeenFocus.';

  @override
  String get featureDemoWidgetsCompletionTitle => 'Widgets bereit';

  @override
  String get featureDemoWidgetsCompletionSubtitle =>
      'Glaubenserinnerungen auf deinem Home-Bildschirm.';

  @override
  String get featureDemoWidgetsCompletionBody =>
      'Füge DeenFocus-Widgets aus der Widget-Galerie hinzu und öffne die App einmal zum Synchronisieren.';

  @override
  String get featureDemoWidgetsHomeHint => 'Mittwoch, 13. August';

  @override
  String get featureDemoWidgetSampleDate => 'Mi., 13. Aug.';

  @override
  String get featureDemoWidgetSampleVerse =>
      'Dir allein dienen wir, und Dich allein bitten wir um Hilfe.';

  @override
  String get featureDemoWidgetSampleSource => 'Sure 1:5';

  @override
  String get featureDemoLiveActivityTitle => 'Live Activity';

  @override
  String get featureDemoLiveActivityIntroTitle => 'Live Activity erleben';

  @override
  String get featureDemoLiveActivityIntroSubtitle =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityShowcaseCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveActivityDetailsTitle =>
      'Gebets-Updates immer sichtbar';

  @override
  String get featureDemoLiveActivityDetailsBody =>
      'Live Activity hält Maghrib, Isha und den Countdown auf dem Sperrbildschirm nah — in den Einstellungen aktivieren.';

  @override
  String get featureDemoLiveActivityCompletionTitle => 'Live Activity bereit';

  @override
  String get featureDemoLiveActivityCompletionSubtitle =>
      'Das nächste Gebet, immer in der Nähe.';

  @override
  String get featureDemoLiveActivityCompletionBody =>
      'Aktiviere Live Activity unter Einstellungen → Gebetsberechnung für Updates auf dem Sperrbildschirm.';

  @override
  String get featureDemoLiveActivityLockHint => 'Mittwoch, 13. August';

  @override
  String get featureDemoLiveActivitySampleTime => '18:48';

  @override
  String get featureDemoLiveActivitySampleNextTime => '20:11';

  @override
  String get featureDemoWidgetsIntroSubtitleIos =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsIntroSubtitleAndroid =>
      'Stay in DeenFocus. Long-press the Home Screen, open the widget picker, and try all three sizes.';

  @override
  String get featureDemoWidgetsLongPressCalloutIos =>
      'Lange auf den Home-Bildschirm tippen';

  @override
  String get featureDemoWidgetsLongPressCalloutAndroid =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsAddCallout =>
      'Tippe auf +, um ein DeenFocus-Widget zu wählen';

  @override
  String get featureDemoWidgetsAddSlotLabel => 'Add Widget';

  @override
  String get featureDemoWidgetsGalleryTitle => 'DeenFocus-Widget wählen';

  @override
  String get featureDemoWidgetsGallerySubtitle =>
      'Switch between Small, Medium, and Large — then add it to your Home Screen.';

  @override
  String get featureDemoWidgetsAddCta => 'Add Widget';

  @override
  String get featureDemoWidgetsAddCtaAndroid => 'Add widget';

  @override
  String get featureDemoWidgetsChangeCta => 'Change size';

  @override
  String get featureDemoWidgetSizeSmall => 'Klein';

  @override
  String get featureDemoWidgetSizeMedium => 'Mittel';

  @override
  String get featureDemoWidgetSizeLarge => 'Groß';

  @override
  String get featureDemoWidgetSizeSmallSubtitle =>
      'Compact prayer times at a glance';

  @override
  String get featureDemoWidgetSizeMediumSubtitle =>
      'Daily verse plus all five prayers';

  @override
  String get featureDemoWidgetSizeLargeSubtitle =>
      'Prayer progress with today’s schedule';

  @override
  String get featureDemoLiveActivityIntroSubtitleIos =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityIntroSubtitleAndroid =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see the ongoing prayer notification and shade.';

  @override
  String get featureDemoLiveOpenPrayerCalcCallout =>
      'Tippe auf Gebetsberechnung';

  @override
  String get featureDemoLiveEnableToggleCallout => 'Live Activity aktivieren';

  @override
  String get featureDemoLiveLockScreenCallout =>
      'Your prayer Live Activity on the Lock Screen';

  @override
  String get featureDemoLiveCompactTitle => 'Compact Dynamic Island';

  @override
  String get featureDemoLiveCompactCallout =>
      'Current prayer stays visible at the top';

  @override
  String get featureDemoLiveExpandCta => 'Expand Dynamic Island';

  @override
  String get featureDemoLiveExpandedTitle => 'Expanded Dynamic Island';

  @override
  String get featureDemoLiveExpandedCallout =>
      'See current time and the next prayer together';

  @override
  String get featureDemoLiveActivityCompletionSubtitleIos =>
      'Lock Screen and Dynamic Island, ready.';

  @override
  String get featureDemoLiveActivityCompletionSubtitleAndroid =>
      'Ongoing prayer updates, ready.';

  @override
  String get featureDemoLiveActivityCompletionBodyIos =>
      'Enable Live Activity in Settings → Prayer Calculation to show prayer updates on your Lock Screen and Dynamic Island.';

  @override
  String get featureDemoLiveActivityCompletionBodyAndroid =>
      'Enable Live Activity in Settings → Prayer Calculation to show an ongoing prayer notification on Android.';

  @override
  String get featureDemoAndroidStatusBarHint => 'Ongoing notification';

  @override
  String get featureDemoAndroidOngoingTitle => 'Live prayer notification';

  @override
  String get featureDemoAndroidOngoingCallout =>
      'Silent ongoing update — current and next prayer';

  @override
  String get featureDemoAndroidOpenShadeCta => 'Benachrichtigungsleiste öffnen';

  @override
  String get featureDemoAndroidShadeTitle => 'Notification shade';

  @override
  String get featureDemoAndroidShadeCallout =>
      'Expand to see the full current and next prayer status';

  @override
  String get featureDemoAndroidOngoingBadge => 'Ongoing';

  @override
  String get appLockDemoOfferPrayerTitle =>
      'Bereit, den Gebetsmodus auszuprobieren?';

  @override
  String get appLockDemoOfferSleepTitle =>
      'Bereit, den Schlafmodus auszuprobieren?';

  @override
  String get appLockDemoOfferChildTitle =>
      'Bereit, den Kindermodus auszuprobieren?';

  @override
  String get appLockDemoOfferPrayerCta => 'Gebetsmodus aktivieren';

  @override
  String get appLockDemoOfferSleepCta => 'Schlafmodus aktivieren';

  @override
  String get appLockDemoOfferChildCta => 'Kindermodus aktivieren';

  @override
  String get appLockDemoOfferNotNow => 'Nicht jetzt';

  @override
  String get nightlyWrapUpPrayersTitle => 'Schließe die Gebete von heute ab';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Markiere offene oder verpasste Gebete, um deine Gebets-Serie zu schützen.';

  @override
  String get nightlyWrapUpChecklistTitle =>
      'Vervollständige deine Tagescheckliste';

  @override
  String get nightlyWrapUpChecklistBody =>
      'Einige Punkte sind noch offen — schließe den Tag bewusst ab.';

  @override
  String get nightlyWrapUpBothTitle => 'Schließe deinen Tag ab';

  @override
  String get nightlyWrapUpBothBody =>
      'Markiere offene Gebete und schließe deine Tagescheckliste vor Tagesende ab.';

  @override
  String get cycleModeEndedNotificationTitle => 'Zyklusmodus ist beendet';

  @override
  String get cycleModeEndedNotificationBody =>
      'Dein Zyklusmodus ist jetzt aus. Du kannst wieder beten. Wenn du die Daten des Zyklusmodus ändern möchtest, tippe hier zum Bearbeiten.';

  @override
  String get libraryHomeTitle => 'Islamische Bibliothek';

  @override
  String get libraryHomeSubtitle =>
      'Lerne Hadith, Bittgebete, die 99 Namen und mehr';

  @override
  String get libraryHubTitle => 'Islamische Bibliothek';

  @override
  String get libraryModuleQuran => 'Koran';

  @override
  String get libraryModuleQuranSub => 'Lesen, hören und Tadschwid üben';

  @override
  String get libraryModuleHadith => 'Hadith';

  @override
  String get libraryModuleHadithSub => 'Sammlungen aus authentischen Quellen';

  @override
  String get libraryModuleDuas => 'Bittgebete & Adhkar';

  @override
  String get libraryModuleDuasSub => 'Morgen-, Abend- und tägliches Gedenken';

  @override
  String get libraryModulePrayerMethods => 'Gebet & islamische Methoden';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, Salah, Hadsch und mehr';

  @override
  String get libraryModuleFiqh => 'Fiqh & Traditionen';

  @override
  String get libraryModuleFiqhSub =>
      'Sunni, Schia, Madhhabs, Ahl-e Hadith und mehr';

  @override
  String get libraryModuleNames => '99 Namen Allahs';

  @override
  String get libraryModuleNamesSub => 'Asma ul-Husna lernen und bedenken';

  @override
  String get libraryModulePillarsIslam => 'Säulen des Islam';

  @override
  String get libraryModulePillarsIslamSub =>
      'Die fünf Grundlagen des Glaubens in der Praxis';

  @override
  String get libraryModulePillarsIman => 'Säulen des Iman';

  @override
  String get libraryModulePillarsImanSub => 'Die sechs Glaubensartikel';

  @override
  String get libraryModuleProphets => 'Prophet Muhammad';

  @override
  String get libraryModuleProphetsSub =>
      'Sein Leben, seine Mission und zeitlose Lehren';

  @override
  String get libraryModuleOccasions => 'Islamische Anlässe';

  @override
  String get libraryModuleOccasionsSub =>
      'Ramadan, Festtage, Hadsch und gesegnete Tage';

  @override
  String get libraryKeyLesson => 'Wichtige Lehre';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current von $total';
  }

  @override
  String get libraryPrevious => 'Zurück';

  @override
  String get libraryNext => 'Weiter';

  @override
  String get libraryBookmark => 'Lesezeichen';

  @override
  String get libraryCopy => 'Kopieren';

  @override
  String get libraryShare => 'Teilen';

  @override
  String get libraryCopied => 'In die Zwischenablage kopiert';

  @override
  String get libraryShareCopiedHint => 'Kopiert — zum Teilen einfügen';

  @override
  String get libraryShareReference => 'Quelle';

  @override
  String get contentShareIntro =>
      'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍';

  @override
  String get contentShareExplore => 'DeenFocus entdecken:';

  @override
  String get contentShareFailed =>
      'Teilen gerade nicht möglich. Bitte erneut versuchen.';

  @override
  String get libraryBookmarkSaved => 'Lesezeichen gespeichert';

  @override
  String get libraryBookmarkRemoved => 'Lesezeichen entfernt';

  @override
  String get libraryTranslation => 'Übersetzung';

  @override
  String get libraryTransliteration => 'Umschrift';

  @override
  String get libraryMeaning => 'Bedeutung';

  @override
  String get libraryBookmarksTitle => 'Gespeicherte Lerninhalte';

  @override
  String get libraryBookmarksSubtitle =>
      'Hadith, Bittgebete, Namen, Fiqh und mehr';

  @override
  String get libraryBookmarksEmpty =>
      'Noch keine gespeicherten Inhalte. Tippe auf Lesezeichen bei einem Lerninhalt, um ihn hier zu speichern.';

  @override
  String get libraryMarkCompleted => 'Als abgeschlossen markieren';

  @override
  String get librarySectionCompleted => 'Abgeschlossen';

  @override
  String get libraryReflection => 'Reflexion';

  @override
  String get libraryComingSoonTitle => 'Demnächst';

  @override
  String get libraryComingSoonBody =>
      'Dieses Modul wird vorbereitet. Schau in einem späteren Update wieder vorbei.';

  @override
  String get librarySearchHint => 'Suchen…';

  @override
  String get libraryHubSearchHint => 'Lernen durchsuchen…';

  @override
  String get libraryHubSearchSections => 'Bereiche';

  @override
  String get libraryHubSearchTopics => 'Themen';

  @override
  String get librarySearchEmpty => 'Keine Treffer';

  @override
  String libraryItemCount(int count) {
    return '$count Einträge';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown von $total';
  }

  @override
  String libraryContinueFrom(int number) {
    return 'Weiter · $number';
  }

  @override
  String get libraryInProgress => 'In Bearbeitung';

  @override
  String libraryReference(String source) {
    return 'Quelle: $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count Bittgebete';
  }

  @override
  String get libraryDuaCategoryMorning => 'Morgen';

  @override
  String get libraryDuaCategoryEvening => 'Abend';

  @override
  String get libraryDuaCategoryDailyLife => 'Alltag';

  @override
  String get libraryDuaCategorySleep => 'Schlaf';

  @override
  String get libraryDuaCategoryFood => 'Essen';

  @override
  String get libraryDuaCategoryTravel => 'Reise';

  @override
  String get libraryDuaCategoryIllness => 'Krankheit';

  @override
  String get libraryDuaCategoryProtection => 'Schutz';

  @override
  String get libraryDuaCategoryForgiveness => 'Vergebung';

  @override
  String get libraryDuaCategoryParents => 'Eltern';

  @override
  String libraryHadithCount(int count) {
    return '$count Hadithe';
  }

  @override
  String get libraryHadithNarrator => 'Überlieferer:';

  @override
  String get libraryHadithSource => 'Quelle:';

  @override
  String get libraryHadithCollectionBukhari => 'Sahih al-Buchari';

  @override
  String get libraryHadithCollectionMuslim => 'Sahih Muslim';

  @override
  String get libraryHadithCollectionRiyad => 'Riyad us-Saliheen';

  @override
  String get libraryHadithCollectionNawawi => '40 Hadithe Nawawi';

  @override
  String get libraryHadithCollectionHisnul => 'Hisnul Muslim';

  @override
  String libraryGuideStepCount(int count) {
    return '$count Schritte';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get libraryGuideWudu => 'Wudu';

  @override
  String get libraryGuideSalah => 'Salah';

  @override
  String get libraryGuideGhusl => 'Ghusl';

  @override
  String get libraryGuideTayammum => 'Tayammum';

  @override
  String get libraryGuideJanazah => 'Janaza-Gebet';

  @override
  String get libraryGuideUmrah => 'Umra';

  @override
  String get libraryGuideHajj => 'Hadsch';

  @override
  String get libraryGuideFasting => 'Fasten';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawba';

  @override
  String get libraryOccasionImportance => 'Bedeutung';

  @override
  String get libraryOccasionVirtues => 'Tugenden';

  @override
  String get libraryOccasionRecommendedActs => 'Empfohlene Handlungen';

  @override
  String get libraryFiqhOverview => 'Überblick';

  @override
  String get libraryFiqhKeyPoints => 'Wichtige Punkte';

  @override
  String get libraryFiqhDifferences => 'Wichtige Unterschiede';

  @override
  String get libraryFiqhCommonGround => 'Gemeinsamkeiten';

  @override
  String get insightsCompleted => 'Abgeschlossen';

  @override
  String get insightsInProgress => 'In Bearbeitung';

  @override
  String get insightsKeepGoingTitle => 'Weiter so!';

  @override
  String get insightsKeepGoingBody =>
      'Du machst große Fortschritte. Jedes Gebet zählt.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Freigeschaltete Erfolge';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer =>
      'Du hast dein erstes Gebet verrichtet.';

  @override
  String get achievementDescSevenPrayerStreak =>
      'Verrichte 7 Gebete hintereinander.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Verrichte 30 Gebete hintereinander.';

  @override
  String get achievementDescFajrWarrior => 'Bete Fajr an 14 Tagen.';

  @override
  String get achievementDescFajrChampion => 'Bete Fajr an 30 Tagen.';

  @override
  String get achievementDescFiveADay =>
      'Verrichte alle fünf Gebete an einem Tag.';

  @override
  String get achievementDescPerfectWeek =>
      'Verrichte jedes Gebet an 7 Tagen hintereinander.';

  @override
  String get achievementDescPerfectMonth =>
      'Verrichte jedes Gebet an 30 Tagen hintereinander.';

  @override
  String get achievementDescQuranReader => 'Lies den Quran an 7 Tagen.';

  @override
  String get achievementDescQuranDevotee => 'Lies den Quran an 30 Tagen.';

  @override
  String get achievementDescDhikrStarter => 'Verrichte Dhikr an 7 Tagen.';

  @override
  String get achievementDescDhikrMaster => 'Verrichte Dhikr an 30 Tagen.';

  @override
  String get achievementDescNightWorshipper => 'Bete Tahajjud an 7 Tagen.';

  @override
  String get achievementDescMasjidCompanion => 'Besuche die Moschee 7 Mal.';

  @override
  String get achievementDescDistractionDefender =>
      'Bleibe 7 Tage frei von Ablenkungen.';

  @override
  String get achievementDescCycleGuardian =>
      'Schütze deine Serie 7 Tage mit dem Zyklusmodus.';

  @override
  String get achievementDescProtectedMonth =>
      'Schütze deine Serie 30 Tage mit dem Zyklusmodus.';

  @override
  String get achievementDescConsistencyChampion =>
      'Bleibe 100 Tage konsequent.';

  @override
  String get achievementDescSixMonthJourney => 'Mache 180 Tage weiter.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Erreiche DeenFocus Master (Stufe 15).';

  @override
  String get dailyChecklistOptional => 'Optional';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Wut zügeln / Freundlich sprechen';

  @override
  String get digitalBalanceTitle => 'Digitale Balance';

  @override
  String get digitalBalanceSubtitle => 'Sieh, wohin deine Zeit geht';

  @override
  String get digitalBalanceViewCta => 'Digitale Balance ansehen →';

  @override
  String get digitalBalanceTodayLabel => 'Heute';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Andere Apps';

  @override
  String get digitalBalanceTodayPhoneTime => 'Heutige Telefonzeit';

  @override
  String get digitalBalanceWhereTimeGoes => 'Wohin deine Zeit geht';

  @override
  String get digitalBalanceViewAllApps => 'Alle Apps ansehen';

  @override
  String get digitalBalanceAllAppsTitle => 'Alle Apps';

  @override
  String get digitalBalanceNoApps => 'Heute noch keine App-Nutzung erfasst.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen vs. digitale Zeit';

  @override
  String get digitalBalanceYourWeek => 'Deine Woche';

  @override
  String get digitalBalanceThisWeek => 'Diese Woche';

  @override
  String get digitalBalancePhoneUsageLegend => 'Telefonnutzung';

  @override
  String get digitalBalanceDailyInsight => 'Täglicher Impuls';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Jede Minute, die deinen Iman stärkt, zählt.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'Deine DeenFocus-Zeit ist diese Woche höher als letzte Woche. MashaAllah!';

  @override
  String get digitalBalanceInsightQuietDay =>
      'Ein ruhiger Tag bisher. DeenFocus-Zeit erscheint hier.';

  @override
  String get digitalBalanceGoalTitle => 'Dein Deen-Zeit-Ziel';

  @override
  String get digitalBalanceAdjustGoal => 'Ziel anpassen';

  @override
  String get digitalBalanceGoalReached =>
      'Du hast das heutige Deen-Zeit-Ziel erreicht. MashaAllah!';

  @override
  String get digitalBalanceGoalSheetTitle => 'Tägliche Deen-Zeit';

  @override
  String get digitalBalanceGoalCustomHint => 'Minuten pro Tag';

  @override
  String get digitalBalanceGoalSave => 'Speichern';

  @override
  String get digitalBalanceGoal15 => '15 min';

  @override
  String get digitalBalanceGoal30 => '30 min';

  @override
  String get digitalBalanceGoal45 => '45 min';

  @override
  String get digitalBalanceGoal60 => '1 Stunde';

  @override
  String get digitalBalancePermissionTitle =>
      'Verstehe deine digitalen Gewohnheiten';

  @override
  String get digitalBalancePermissionBody =>
      'Erlaube DeenFocus den Zugriff auf deine App-Nutzung, damit du siehst, wohin deine Zeit geht und wie viel du deinem Deen gibst.';

  @override
  String get digitalBalanceEnableUsage => 'App-Nutzung aktivieren';

  @override
  String get digitalBalanceMaybeLater => 'Vielleicht später';

  @override
  String get digitalBalanceUnavailableTitle =>
      'App-Nutzung ist hier nicht verfügbar';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple teilt Screen Time nicht mit anderen Apps, daher kann Digital Balance die iPhone-Nutzung noch nicht zeigen. Gebete, Serien und DeenFocus-Einblicke funktionieren weiter.';

  @override
  String get digitalBalanceInfoTitle => 'Über Digitale Balance';

  @override
  String get digitalBalanceInfoBody =>
      'Digitale Balance zeigt, wohin deine Zeit geht und wie viel du deinem Deen gibst. Die Nutzung bleibt auf deinem Gerät.';

  @override
  String digitalBalanceDurationMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String digitalBalanceDurationHours(int hours) {
    return '${hours}h';
  }

  @override
  String digitalBalanceDurationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String digitalBalancePercentShort(int percent) {
    return 'DeenFocus · $percent% der Telefonzeit';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% deiner Telefonzeit';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% der heutigen Telefonzeit';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% mehr DeenFocus-Zeit als letzte Woche';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'Du hast heute $duration in DeenFocus verbracht. Bleib dran.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'Deine DeenFocus-Zeit ist im Vergleich zu gestern um $percent% gestiegen.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / Tag';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return 'Noch $minutes Minuten bis zum heutigen Ziel';
  }

  @override
  String get tajweedPracticeTitle => 'Tadschwid-Übung';

  @override
  String tajweedPracticeAyahTitle(String surah, String ref) {
    return '$surah · $ref';
  }

  @override
  String get tajweedDownloadTitle => 'KI-Modell wird vorbereitet';

  @override
  String get tajweedDownloadFailedTitle =>
      'KI-Modell konnte nicht vorbereitet werden';

  @override
  String get tajweedDownloadBody =>
      'Einmaliger Download, damit die Tadschwid-Übung danach vollständig offline funktioniert. Das passiert nur einmal.';

  @override
  String get tajweedDownloadFinishing => 'Einrichtung wird abgeschlossen…';

  @override
  String get tajweedDownloadCanLeave =>
      'Du kannst diesen Bildschirm verlassen — der Download läuft im Hintergrund weiter.';

  @override
  String get tajweedDownloadTryAgain => 'Erneut versuchen';

  @override
  String get tajweedDownloadPleaseTryAgain => 'Bitte erneut versuchen.';

  @override
  String get tajweedErrorFeatureDisabled =>
      'KI-Tadschwid-Übung ist aus. Aktiviere sie zuerst in den Einstellungen.';

  @override
  String get tajweedErrorModelMissing =>
      'Das KI-Modell ist noch nicht installiert.';

  @override
  String get tajweedErrorModelDownloadFailed =>
      'Download des KI-Modells fehlgeschlagen. Verbindung prüfen und erneut versuchen.';

  @override
  String get tajweedErrorModelLoadFailed =>
      'Das KI-Modell konnte auf diesem Gerät nicht geladen werden.';

  @override
  String get tajweedErrorCouldNotPrepare =>
      'Das KI-Modell konnte nicht vorbereitet werden.';

  @override
  String get tajweedErrorUnsupported =>
      'KI-Tadschwid-Übung ist auf diesem Gerät nicht verfügbar.';

  @override
  String get sharePromoTitle => 'Sieh dir das auf DeenFocus an 🌙';

  @override
  String get sharePromoBody =>
      'Eine einfache App, die dir hilft, dich auf deinen Deen zu konzentrieren, pünktlich zu beten und bessere Gewohnheiten aufzubauen.';

  @override
  String get sharePromoDownloadHeading => 'DeenFocus herunterladen:';

  @override
  String sharePromoAppStoreLine(String url) {
    return '🍎 App Store: $url';
  }

  @override
  String sharePromoPlayStoreLine(String url) {
    return '🤖 Google Play: $url';
  }

  @override
  String get shareBrandName => 'DeenFocus';

  @override
  String get shareBrandTagline =>
      'Dein Begleiter für einen besseren Deen, jeden Tag.';

  @override
  String get shareDownloadCta => 'DeenFocus herunterladen';

  @override
  String get shareAppStoreBadge => 'App Store';

  @override
  String get sharePlayStoreBadge => 'Google Play';

  @override
  String get shareFailed => 'Teilen nicht möglich. Bitte versuche es erneut.';

  @override
  String insightsRatio(int done, int possible) {
    return '$done / $possible';
  }

  @override
  String insightsCompactRatio(int done, int possible) {
    return '$done/$possible';
  }

  @override
  String insightsPercent(int value) {
    return '$value%';
  }

  @override
  String insightsFocusScoreValue(int score) {
    return '$score / 100';
  }

  @override
  String insightsWeekNumber(int week) {
    return 'W$week';
  }

  @override
  String get insightsLevelName1 => 'Neuanfang';

  @override
  String get insightsLevelName2 => 'Erste Schritte';

  @override
  String get insightsLevelName3 => 'Gewohnheit aufbauen';

  @override
  String get insightsLevelName4 => 'Stetiger Beter';

  @override
  String get insightsLevelName5 => 'Beständiges Herz';

  @override
  String get insightsLevelName6 => 'Gebetshüter';

  @override
  String get insightsLevelName7 => 'Ergebener Diener';

  @override
  String get insightsLevelName8 => 'Starke Routine';

  @override
  String get insightsLevelName9 => 'Hingebungsvoller Beter';

  @override
  String get insightsLevelName10 => 'Standhaft';

  @override
  String get insightsLevelName11 => 'Vertiefter Glaube';

  @override
  String get insightsLevelName12 => 'Starke Beständigkeit';

  @override
  String get insightsLevelName13 => 'Vorbild der Hingabe';

  @override
  String get insightsLevelName14 => 'Außergewöhnliche Beständigkeit';

  @override
  String get insightsLevelName15 => 'DeenFocus Master';

  @override
  String get lockScreenOptionsTitle => 'Sperrbildschirm-Stil';

  @override
  String get lockScreenOptionsSubtitle =>
      'Wähle, wie Gebetserinnerungen erscheinen';

  @override
  String get lockScreenOptionsHint =>
      'Tippe auf einen Stil, um das Vollbild-Layout zu öffnen.';

  @override
  String get lockScreenDefaultBadge => 'Standard';

  @override
  String get lockScreenSelectedBadge => 'Ausgewählt';

  @override
  String get lockScreenPreviewLabel => 'Vorschau';

  @override
  String get lockScreenStyleClassic => 'Gebetserinnerung';

  @override
  String get lockScreenStyleTasbih => 'Tasbih-Zähler';

  @override
  String get lockScreenStyleVerse => 'Täglicher Vers';

  @override
  String get lockScreenStyleDua => 'Tägliches Bittgebet';

  @override
  String get lockScreenStyleQuiz => 'Wissenscheck';

  @override
  String get lockScreenStyleTimes => 'Gebetszeiten';

  @override
  String get lockScreenStyleCountdown => 'Countdown';

  @override
  String get lockScreenStyleHold => 'Halten zum Bestätigen';

  @override
  String get lockScreenStyleType => 'Tippen zum Bestätigen';

  @override
  String get lockScreenStyleMinimal => 'Minimaler Fokus';

  @override
  String get lockScreenItsTimeToPray => 'Es ist Zeit zum Beten:';

  @override
  String lockScreenRemainingTime(String time) {
    return 'Verbleibende Zeit: $time';
  }

  @override
  String get lockScreenRemindLater => 'Später erinnern';

  @override
  String get lockScreenNextVerse => 'Nächster Vers';

  @override
  String get lockScreenVerseForToday => 'Vers für heute';

  @override
  String get lockScreenDuaForToday => 'Bittgebet für heute';

  @override
  String get lockScreenTapToCount => 'Tippe irgendwo, um zu zählen';

  @override
  String get lockScreenHoldHint => 'Gedrückt halten zum Bestätigen';

  @override
  String lockScreenTypeHint(String word) {
    return 'Tippe $word zum Bestätigen';
  }

  @override
  String get lockScreenTypeWord => 'ALHAMDULILLAH';

  @override
  String get lockScreenConfirmBeforeAllah =>
      'Bestätige vor Allah, dass du gebetet hast.';

  @override
  String get lockScreenQuizCategory => 'Gebet';

  @override
  String get lockScreenQuizQuestion =>
      'Wie viele tägliche Gebete sind verpflichtend?';

  @override
  String get lockScreenQuizA => 'Drei';

  @override
  String get lockScreenQuizB => 'Vier';

  @override
  String get lockScreenQuizC => 'Fünf';

  @override
  String get lockScreenQuizCorrect => 'Richtig';

  @override
  String get lockScreenQuizIncorrect => 'Falsch';

  @override
  String get lockScreenQuizComplete => 'Wissenscheck abgeschlossen';

  @override
  String get lockScreenQuizCategoryFasting => 'Fasten';

  @override
  String get lockScreenQuizCategoryPillars => 'Säulen';

  @override
  String get lockScreenQuizQ2 => 'In welchem Monat fasten Muslime?';

  @override
  String get lockScreenQuizQ2A => 'Schawwal';

  @override
  String get lockScreenQuizQ2B => 'Ramadan';

  @override
  String get lockScreenQuizQ2C => 'Muharram';

  @override
  String get lockScreenQuizQ3 => 'Welche ist die erste Säule des Islam?';

  @override
  String get lockScreenQuizQ3A => 'Salah';

  @override
  String get lockScreenQuizQ3B => 'Schahada';

  @override
  String get lockScreenQuizQ3C => 'Haddsch';

  @override
  String get lockScreenTimeUp => 'Die Zeit ist um';

  @override
  String get lockScreenHoldRelease => 'Weiter halten zum Bestätigen';

  @override
  String lockScreenCountProgress(int current, int total) {
    return '$current von $total';
  }

  @override
  String get lockScreenVerseTranslation =>
      'Gedenket Meiner, so gedenke Ich euer.';

  @override
  String get lockScreenVerseRef => 'Koran 2:152';

  @override
  String get lockScreenDuaTransliteration => 'Rabbana atina fid-dunya hasanah';

  @override
  String get lockScreenDuaTranslation =>
      'Unser Herr, gib uns Gutes im Diesseits und Gutes im Jenseits.';

  @override
  String get lockScreenDuaSource => 'Al-Baqara 2:201';

  @override
  String get lockScreenSampleRemaining => '2 Std. 34 Min.';

  @override
  String get lockScreenDhikrAstaghfirullah => 'Astaghfirullah';

  @override
  String get lockScreenDhikrSubhanAllah => 'SubhanAllah';

  @override
  String get lockScreenDhikrAlhamdulillah => 'Alhamdulillah';

  @override
  String get lockScreenDhikrAllahuAkbar => 'Allahu Akbar';

  @override
  String get homeTajweedPromoTitle => 'Quran KI-Tajweed';

  @override
  String get homeTajweedPromoBody =>
      'Rezitiere einen beliebigen Vers und erhalte sofort KI-Feedback zu deinem Tajweed.';

  @override
  String get homeTajweedPromoCta => 'Tajweed üben';

  @override
  String get homeTajweedPromoAiFeedback => 'KI-Feedback';

  @override
  String homeTajweedPromoWordAccuracy(int percent) {
    return '$percent % Wortgenauigkeit';
  }

  @override
  String get homeLockScreenPromoTitle => 'Sperrbildschirm-Stile';

  @override
  String get homeLockScreenPromoBody =>
      'Gestalte deinen Sperrbildschirm mit schönen islamischen Designs und hilfreichen Erinnerungen.';

  @override
  String get homeLockScreenPromoCta => 'Stile entdecken';

  @override
  String get homeFullScreenAlarmPromoTitle =>
      'Vollbild-AlarmKit zur Gebetszeit';

  @override
  String get homeFullScreenAlarmPromoBody =>
      'Bleib dran mit einer ruhigen, ablenkungsfreien Vollbild-Warnung, wenn es Zeit zum Beten ist.';

  @override
  String get homeFullScreenAlarmPromoCta => 'Gebetsalarme aktivieren';

  @override
  String get homeFullScreenAlarmPromoSlideToStop => 'Zum Stoppen wischen';

  @override
  String get homePromoNewBadge => 'NEU';

  @override
  String get homeReadQuranPromoTitle => 'Koran lesen';

  @override
  String get homeReadQuranPromoSubtitle => 'Lesen, hören & Tajweed üben';

  @override
  String get homeReadQuranPromoCta => 'Koran öffnen';

  @override
  String get homeReadQuranPromoNewBadge => 'Neu';

  @override
  String cycleModeActiveStatus(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Serie geschützt • Endet in $days Tagen',
      one: 'Serie geschützt • Endet morgen',
      zero: 'Serie geschützt • Endet heute',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeProtectPrayerStreakSubtitle =>
      'Behalte deine Serie während der Zyklustage';

  @override
  String get cycleModeExcludeFromStatisticsSubtitle =>
      'Zyklustage nicht in den Gebetsstatistiken zählen';

  @override
  String get homePromoPreviewCity => 'Lahore';

  @override
  String get focusScreenTimeAuthPasscodeRequired =>
      'Dieses iPhone braucht einen Gerätecode, bevor Apple Bildschirmzeit-Zugriff erlaubt. Code in den Einstellungen setzen, dann erneut versuchen.';

  @override
  String get focusScreenTimeAuthCanceled =>
      'Der Bildschirmzeit-Zugriff wurde abgebrochen, bevor Apple ihn erteilt hat. Bitte erneut versuchen und die Apple-Abfrage abschließen.';

  @override
  String get focusScreenTimeAuthConflict =>
      'Eine andere App verwaltet bereits Familienkontrollen auf diesem iPhone. Zuerst deaktivieren, dann erneut versuchen.';

  @override
  String get focusScreenTimeAuthInvalidAccount =>
      'Mit einem gültigen iCloud-Konto auf diesem iPhone anmelden und Bildschirmzeit-Zugriff erneut versuchen.';

  @override
  String get focusScreenTimeAuthNetwork =>
      'Dieses iPhone braucht eine Internetverbindung, bevor Apple Bildschirmzeit-Zugriff erteilen kann.';

  @override
  String get focusScreenTimeAuthRestricted =>
      'Familienkontrollen sind auf diesem iPhone eingeschränkt, daher kann DeenFocus hier keinen Bildschirmzeit-Zugriff anfordern.';

  @override
  String get focusScreenTimeAuthUnavailable =>
      'Familienkontrollen sind auf diesem iPhone derzeit nicht verfügbar.';

  @override
  String get focusScreenTimeAuthIosVersion =>
      'App-Sperre über Bildschirmzeit erfordert iOS 16 oder neuer.';

  @override
  String get focusScreenTimeAuthInvalidArgument =>
      'Die Bildschirmzeit-Autorisierung war ungültig. Bitte erneut versuchen.';

  @override
  String get focusScreenTimeAuthFailedGeneric =>
      'Bildschirmzeit-Zugriff konnte auf diesem iPhone nicht erteilt werden.';

  @override
  String widgetLockCountdownHoursMinutes(String hours, String minutes) {
    return 'In $hours Std. $minutes Min.';
  }

  @override
  String widgetLockCountdownMinutes(String minutes) {
    return 'In $minutes Min.';
  }

  @override
  String get lockScreenRecommendedBadge => 'Empfohlen';
}
