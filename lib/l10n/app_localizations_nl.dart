// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'Vertrouwen. Focus. Samenhang';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Gebedsmodus. Kindmodus. Slaapmodus.';

  @override
  String get welcomeDescription =>
      'Houd uw gebeden bij, lees de Koran, tel Tasbih en bouw betekenisvolle streaks op - allemaal op één plek.';

  @override
  String get skip => 'Overslaan';

  @override
  String get notNow => 'Niet nu';

  @override
  String get continueButton => 'Doorgaan';

  @override
  String get continueForFree => 'Doorgaan met gratis plan';

  @override
  String get getStarted => 'Premium ontgrendelen';

  @override
  String get language => 'Taal';

  @override
  String get cancel => 'Annuleren';

  @override
  String get ok => 'OK';

  @override
  String get openSettings => 'Instellingen openen';

  @override
  String get locationRequired => 'Locatie vereist';

  @override
  String get locationRequiredMessage =>
      'Locatietoegang is vereist om nauwkeurige gebedstijden en Qibla-richting te berekenen. U moet dit inschakelen om de app te kunnen gebruiken.';

  @override
  String get notificationsRequired => 'Meldingen vereist';

  @override
  String get notificationsRequiredMessage =>
      'Meldingen zijn vereist om waarschuwingen en herinneringen voor gebedstijd te ontvangen.';

  @override
  String get sectTitle => 'Kies uw sekte';

  @override
  String get sectSubtitle => 'Dit helpt ons uw ervaring te personaliseren';

  @override
  String get sectSunni => 'Soennieten';

  @override
  String get sectShia => 'Sjiieten';

  @override
  String get sectPreferNotToSay => 'Zeg het liever niet';

  @override
  String get nameTitle => 'Wat is jouw naam?';

  @override
  String get nameSubtitle => 'Laten we uw begroeting personaliseren';

  @override
  String get namePlaceholder => 'Jouw naam';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => 'Locatietoegang toestaan';

  @override
  String get locationManualEntry => 'Or enter your city';

  @override
  String get locationPrivacyNote => 'Stays on your device';

  @override
  String get locationFeaturePrayerTimesTitle => 'Prayer times';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Masjids';

  @override
  String get notificationsTitle => 'Never Miss a Prayer';

  @override
  String get notificationsSubtitle =>
      'Adhan alerts, focus reminders and daily dhikr — delivered right when you need them.';

  @override
  String get notificationsButton => 'Meldingen inschakelen';

  @override
  String get notificationsEnabled => 'Meldingen zijn ingeschakeld';

  @override
  String get notificationsPreviewDate => 'Friday, 10 July';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'now';

  @override
  String get notificationsPreviewMinutesAgo => '2m';

  @override
  String get notificationsPreviewHourAgo => '1h';

  @override
  String get notificationsPreviewAdhanTitle => 'Maghrib Adhan';

  @override
  String get notificationsPreviewAdhanBody =>
      'It\'s time to pray. Apps are paused.';

  @override
  String get notificationsPreviewDhikrTitle => 'Daily Dhikr';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — take a minute to remember.';

  @override
  String get notificationsPreviewStreakTitle => 'Streak';

  @override
  String get notificationsPreviewStreakBody =>
      '7 days of complete prayers. Keep going!';

  @override
  String get screenTimeTitle => 'Schermtijd inschakelen';

  @override
  String get screenTimeSubtitle =>
      'Hiermee kan Deen Focus afleidende apps pauzeren tijdens Salah, slaaptijd en kindermodus.';

  @override
  String get screenTimeButton => 'Toegang tot Schermtijd toestaan';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus never reads your data — it only pauses the apps you choose.';

  @override
  String screenTimeStepOf(int current, int total) {
    return 'STEP $current OF $total';
  }

  @override
  String get screenTimeStep1Title => 'Open the Screen Time prompt';

  @override
  String get screenTimeStep1Body =>
      'Tap \'Allow Screen Time Access\' — your device will show its own permission sheet.';

  @override
  String get screenTimeStep2Title => 'Tap Continue, then Allow';

  @override
  String get screenTimeStep2Body =>
      'Approve the request so Deen Focus can pause apps at the right moments.';

  @override
  String get screenTimeStep3Title => 'Choose apps to lock';

  @override
  String get screenTimeStep3Body =>
      'Pick the apps that distract you most — social, games, video, anything.';

  @override
  String get screenTimeStep4Title => 'You\'re protected';

  @override
  String get screenTimeStep4Body =>
      'Apps lock automatically during Salah, sleep time and child mode.';

  @override
  String get screenTimePromptTitle => 'Screen Time';

  @override
  String screenTimePromptMessage(String appName) {
    return '\'$appName\' would like to access Screen Time';
  }

  @override
  String get screenTimeDontAllow => 'Don\'t Allow';

  @override
  String get screenTimePromptContinue => 'Continue';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Games';

  @override
  String get screenTimeAndroidStep1Title => 'Open Usage Access settings';

  @override
  String get screenTimeAndroidStep1Body =>
      'Tap \'Allow Screen Time Access\' — your device will open Usage Access for Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Enable Accessibility';

  @override
  String get screenTimeAndroidStep2Body =>
      'Turn on the Deen Focus service so apps can pause during Salah, sleep, and child mode.';

  @override
  String get screenTimeAndroidStep3Title => 'Choose apps to lock';

  @override
  String get screenTimeAndroidStep3Body =>
      'Pick the apps that distract you most — social, games, video, anything.';

  @override
  String get screenTimeAndroidStep4Title => 'You\'re protected';

  @override
  String get screenTimeAndroidStep4Body =>
      'Apps lock automatically during Salah, sleep time and child mode.';

  @override
  String get screenTimeAndroidUsageTitle => 'Usage access';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Allow Deen Focus to track which other apps are being used.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Accessibility';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus needs Accessibility to pause distracting apps during focus sessions.';

  @override
  String get screenTimeAndroidPermit => 'Allow';

  @override
  String get screenTimeAndroidEnable => 'Enable';

  @override
  String get screenTimeAndroidNotNow => 'Not now';

  @override
  String get focusModesTitle => 'Everything in One App';

  @override
  String get focusModesSubtitle =>
      'Explore all that Deen Focus offers. Tap a focus mode to see how it works.';

  @override
  String get focusModesSectionLabel => 'FOCUS MODES · TAP TO LEARN MORE';

  @override
  String get focusPrayerTrackingSectionLabel => 'PRAYER & TRACKING';

  @override
  String get focusLearningHubSectionLabel => 'LEARNING HUB';

  @override
  String get focusMoreSectionLabel => 'MORE';

  @override
  String get focusPrayerModeTitle => 'Gebedsmodus';

  @override
  String get focusPrayerModeDescription =>
      'Block distracting apps automatically during Salah so you can pray with full khushu.';

  @override
  String get focusPrayerModeBullet1 => 'Auto-locks apps at prayer time';

  @override
  String get focusPrayerModeBullet2 => 'Unlocks when you\'re done';

  @override
  String get focusPrayerModeBullet3 => 'Builds focus & consistency';

  @override
  String get focusSleepModeTitle => 'Slaapmodus';

  @override
  String get focusSleepModeDescription =>
      'Wind down the halal way. Block apps at bedtime so you rest well and wake for Fajr.';

  @override
  String get focusSleepModeBullet1 => 'Auto-blocks apps at bedtime';

  @override
  String get focusSleepModeBullet2 => 'Gentle Fajr wake reminders';

  @override
  String get focusSleepModeBullet3 => 'Protects your sleep & Fajr';

  @override
  String get focusChildModeTitle => 'Kindmodus';

  @override
  String get focusChildModeDescription =>
      'Handing your phone to your child? Instantly lock apps so they only see what\'s safe.';

  @override
  String get focusChildModeBullet1 => 'One-tap safe mode';

  @override
  String get focusChildModeBullet2 => 'Passcode-protected exit';

  @override
  String get focusChildModeBullet3 => 'Peace of mind, every time';

  @override
  String get focusModeGotIt => 'Got it';

  @override
  String get focusFeaturePrayerTimesTitle => 'Accurate Prayer Times';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan & reminders';

  @override
  String get focusFeatureStreaksTitle => 'Streaks';

  @override
  String get focusFeatureStreaksSubtitle => 'Stay consistent';

  @override
  String get focusFeatureChecklistTitle => 'Daily Checklist';

  @override
  String get focusFeatureChecklistSubtitle => 'Build good habits';

  @override
  String get focusFeatureQiblaTitle => 'Qibla & Masjid';

  @override
  String get focusFeatureQiblaSubtitle => 'Direction & mosques';

  @override
  String get focusFeatureQuranTitle => 'Quran';

  @override
  String get focusFeatureQuranSubtitle => 'Translations, Juzz & pages';

  @override
  String get focusFeatureHadithTitle => 'Hadith';

  @override
  String get focusFeatureHadithSubtitle => 'Authentic collections';

  @override
  String get focusFeatureDuasTitle => 'Duas';

  @override
  String get focusFeatureDuasSubtitle => 'Daily supplications';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Digital dhikr counter';

  @override
  String get focusFeatureAiTitle => 'AI Companion';

  @override
  String get focusFeatureAiSubtitle => 'Ask about your Deen';

  @override
  String get focusFeatureInsightsTitle => 'Insights';

  @override
  String get focusFeatureInsightsSubtitle => 'Weekly & monthly stats';

  @override
  String get investTitle => 'Investeer in je Deen';

  @override
  String get investSubtitle =>
      'Je hoeft niet na te denken over het uitgeven van koffie of snacks...';

  @override
  String get investComparisonTitle => 'Ga Premium of ga door met gratis plan';

  @override
  String get investDailyCoffee => 'Dagelijkse koffie';

  @override
  String get investDailyCoffeePrice => '\$ 5/dag';

  @override
  String get investFastFood => 'Fastfood';

  @override
  String get investFastFoodPrice => '\$ 10/maaltijd';

  @override
  String get investYourDeen => 'Jouw Deen';

  @override
  String get investYourDeenPrice => '\$ 4,99/maand';

  @override
  String get investComparisonQuote =>
      'Je geeft \$10 uit aan kleine dingen zonder na te denken – waarom investeer je niet in je Deen?';

  @override
  String get bestValueTag => 'BESTE WAARDE';

  @override
  String get mostPopularChoice => 'Meest populaire keuze';

  @override
  String get monthlyPriceValue => '\$ 4,99';

  @override
  String get monthlyPriceSuffix => '/maand';

  @override
  String get monthlyPlanSubtitle =>
      'Maandelijks gefactureerd • Op elk gewenst moment opzeggen';

  @override
  String get yearlyPriceValue => '\$ 24,99';

  @override
  String get yearlyPriceSuffix => '/jaar';

  @override
  String get yearlyPlanSubtitle => 'Bespaar 50% • Jaarlijks gefactureerd';

  @override
  String get lifetimePriceValue => '\$ 79,99';

  @override
  String get lifetimePriceSuffix => 'levensduur';

  @override
  String get lifetimePlanSubtitle => 'Eenmalige aankoop • Altijd toegang';

  @override
  String get everythingYouGet => 'Alles wat je krijgt';

  @override
  String get featureFocusModeAllModes =>
      'Onbeperkte focusmodus met alle 3 de modi';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'Geavanceerde gebedsanalyses en -reeksen';

  @override
  String get featureAiAssistant => 'AI islamitische assistent';

  @override
  String get featurePrioritySupportEarlyAccess =>
      'Prioritaire ondersteuning en vroege toegang';

  @override
  String get socialProofPrefix => 'Meedoen';

  @override
  String get socialProofHighlight => '10.000+';

  @override
  String get socialProofSuffix => 'Moslims groeien al met Deen Focus';

  @override
  String get mostPopular => 'Meest populair';

  @override
  String get monthlyLabel => 'Maandelijks';

  @override
  String get monthlyPrice =>
      '\$ 4,99/maand · maandelijks gefactureerd · op elk moment opzegbaar';

  @override
  String get yearlyLabel => 'Jaarlijks';

  @override
  String get yearlyPrice =>
      '\$24,99/jaar · bespaar 50% · jaarlijks gefactureerd';

  @override
  String get lifetimeLabel => 'Levensduur';

  @override
  String get lifetimePrice =>
      '\$ 79,99 levenslang · eenmalige aankoop · eeuwige toegang';

  @override
  String get featurePrayerAnalytics => 'Geavanceerde gebedsanalyses';

  @override
  String get featureFocusMode => 'Onbeperkte focusmodus';

  @override
  String get featureMasjidMode => 'Masjid automatische modus';

  @override
  String get featureNoAds => 'Verwijdert alle advertenties';

  @override
  String get featureSupport => 'Prioritaire ondersteuning';

  @override
  String get homeTitle => 'Deenly Thuis';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback => 'Met ontberingen komt inderdaad gemak.';

  @override
  String get homeAppsLocked => 'Apps vergrendeld';

  @override
  String get homeAppsUnlocked => 'Apps ontgrendeld';

  @override
  String get homeTapToUnlock => 'Tik om apps tijdelijk te ontgrendelen';

  @override
  String get homeTapToRelock =>
      'Tik om geblokkeerde apps nu opnieuw te vergrendelen';

  @override
  String get homeRelock => 'Opnieuw vergrendelen';

  @override
  String get homeUnlock => 'Ontgrendelen';

  @override
  String get homePrayerModeActive => 'Gebedsmodus actief';

  @override
  String get homeActivatePrayerMode => 'Activeer de gebedsmodus';

  @override
  String get homeAppsBlockedSubtitle =>
      'Apps zijn geblokkeerd. Tik om te deactiveren.';

  @override
  String get homeBlockDistractingApps =>
      'Blokkeer afleidende apps tijdens Salah.';

  @override
  String get homeQiblaDirection => 'Qibla-richting';

  @override
  String get homeLocationMissingForQibla =>
      'Schakel locatie in om de Qibla-richting te berekenen.';

  @override
  String get homeQiblaSubtitleGuiding => 'Ik begeleid je naar de Qibla';

  @override
  String get homeToMakkah => 'naar Mekka';

  @override
  String get homeFindMasjid => 'Vind moskee bij mij in de buurt';

  @override
  String get quickActionsMasjidFinder => 'Moskeezoeker';

  @override
  String get homeSearchNearbyMosques => 'Zoek nabijgelegen moskeeën.';

  @override
  String get homePrayerStreak => 'Gebedsreeksen';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Inzichten';

  @override
  String get homeOpenStreakDetails => 'Open streak-details.';

  @override
  String get homeTodaysPrayers => 'De gebeden van vandaag';

  @override
  String get homePrayerTimesUnavailable =>
      'Gebedstijden zijn momenteel niet beschikbaar.';

  @override
  String get homeNextPrayerIn => 'Volgende gebed binnen';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Zonsopgang';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Maghreb';

  @override
  String get homePrayerIsha => 'Isja';

  @override
  String get homeWeek => 'Week';

  @override
  String get homeMonth => 'Maand';

  @override
  String get homeThisWeek => 'Hoogtepunten van Deen deze week';

  @override
  String get homeJummahMubarak => 'Jummah Moebarak';

  @override
  String get homeJummahReminder => 'Vergeet Surah Al-Kahf niet.';

  @override
  String get hijriYear => 'AH';

  @override
  String get hijriMonthMuharram => 'Muharram';

  @override
  String get hijriMonthSafar => 'Safar';

  @override
  String get hijriMonthRabiAlAwwal => 'Rabi\' al-Awwal';

  @override
  String get hijriMonthRabiAlThani => 'Rabi\' al-Thani';

  @override
  String get hijriMonthJumadaAlAwwal => 'Jumada al-Awwal';

  @override
  String get hijriMonthJumadaAlThani => 'Jumada al-Thani';

  @override
  String get hijriMonthRajab => 'Rajab';

  @override
  String get hijriMonthShaban => 'Sha\'ban';

  @override
  String get hijriMonthRamadan => 'Ramadan';

  @override
  String get hijriMonthShawwal => 'Shawwal';

  @override
  String get hijriMonthDhuAlQadah => 'Dhu al-Qi\'dah';

  @override
  String get hijriMonthDhuAlHijjah => 'Dhu al-Hijjah';

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
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Friday congregational prayer';

  @override
  String get calendarEventWhiteDays => 'White Days';

  @override
  String get calendarEventWhiteDaysDesc => 'Recommended fasting days';

  @override
  String get cycleModeActiveTitle =>
      'Allah intends ease for you and does not intend hardship for you. — Quran 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'In deze periode is je reeks beschermd. Cyclusdagen zijn roze gemarkeerd en Cyclusmodus schakelt automatisch uit wanneer de cyclus eindigt.';

  @override
  String cycleModeActiveSubtitleOld(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Auto-ends in $days days',
      one: 'Auto-ends tomorrow',
    );
    return '$_temp0';
  }

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
      other: 'Automatically ends in $days days',
      one: 'Automatically ends tomorrow',
      zero: 'Ends today',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeSettingsTitle => 'Cyclusmodus';

  @override
  String get cycleModeStartDateLabel => 'Startdatum';

  @override
  String get cycleModeLengthLabel => 'Cyclusduur';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '1 dag',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Reeksen pauzeren';

  @override
  String get cycleModeExcludeFromStatisticsLabel =>
      'Uitsluiten van statistieken';

  @override
  String get cycleModeSaveButton => 'Opslaan';

  @override
  String get cycleModeEditButton => 'Bewerken';

  @override
  String get cycleModeChangeStartDateTitle => 'Startdatum wijzigen?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Als je de startdatum wijzigt, wordt het actieve Cyclusmodus-venster herberekend. Dagen buiten het nieuwe bereik worden mogelijk niet meer als cyclusdagen behandeld.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Startdatum wijzigen';

  @override
  String prayerReminderTitle(String prayer) {
    return 'Did you pray $prayer?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Keep your streak alive by logging your prayer.';

  @override
  String get prayerReminderYesButton => 'Yes, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'I\'ll mark later';

  @override
  String get homeTrialBannerTitle =>
      'Free for 7 days — become a better Muslim ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Every feature unlocked. Start your journey today.';

  @override
  String get homeFocusModeTitle => 'Focus Mode';

  @override
  String get homeFocusModeSubtitle => 'Block distracting apps during Salah';

  @override
  String get cycleModeTitle => 'Cycle Mode';

  @override
  String get cycleModeSubtitle =>
      'For menstruation — pause prayers, keep your streak';

  @override
  String get dailyChecklistTitle => 'Daily Checklist';

  @override
  String get dailyChecklistSectionPrayer => 'Gebed';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Koran & Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Goede daden';

  @override
  String get dailyChecklistSectionDistraction => 'Afleidingscontrole';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Avond-adhkar';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Charity';

  @override
  String get dailyChecklistSmileAtSomeone => 'Smile at someone';

  @override
  String get dailyChecklistFamilyCall => 'Family call';

  @override
  String get dailyChecklistNoMusicToday => 'No music today';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'No social media before Isha';

  @override
  String get focusScoreTitle => 'Focusscore van vandaag';

  @override
  String get focusScorePrayer => 'Gebed';

  @override
  String get focusScoreQuran => 'Koran';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Afleidingscontrole';

  @override
  String get insightsBack => 'Terug';

  @override
  String get insightsTitle => 'Mijn inzichten';

  @override
  String get insightsSubtitle => 'Volg je Deen-voortgang';

  @override
  String get insightsPrayerRate => 'Gebedspercentage';

  @override
  String get insightsDayStreak => 'Dagreeks';

  @override
  String get insightsBestStreak => 'Beste reeks';

  @override
  String get insightsWeekly => 'Wekelijks';

  @override
  String get insightsMonthly => 'Maandelijks';

  @override
  String get insightsPrayersCompleted => 'Voltooide gebeden';

  @override
  String get insightsRestoreStreak => 'Herstel mijn reeks — laatste 24 uur';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Gebed $prayerPercent% · Koran $quranPercent% · Dhikr $dhikrPercent% · Afleiding $distractionPercent%';
  }

  @override
  String get quickActionsCalendar => 'Calendar';

  @override
  String get quickActionsCalendarSubtitle => 'View Islamic dates';

  @override
  String get quickActionsSupportUs => 'Support Us';

  @override
  String get quickActionsSupportUsSubtitle => 'Help us grow';

  @override
  String get quickActionsSupportUsMessage =>
      'Thank you for considering to support DeenFocus! Support features coming soon.';

  @override
  String get supportUsTitle => 'Support DeenFocus';

  @override
  String get supportUsHeroTitle => 'Help keep DeenFocus growing';

  @override
  String get supportUsHeroBody =>
      'DeenFocus is built with love to help the Ummah stay focused and consistent. Your support keeps it alive and improving for everyone.';

  @override
  String get supportUsFundSection => 'YOUR CONTRIBUTIONS FUND';

  @override
  String get supportUsFundFeature1Title => 'New Islamic features';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Fresh tools to deepen your worship';

  @override
  String get supportUsFundFeature2Title => 'Server & infrastructure';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Keeping the app fast and reliable';

  @override
  String get supportUsFundFeature3Title => 'Bug fixes & updates';

  @override
  String get supportUsFundFeature3Subtitle =>
      'A smoother, more stable experience';

  @override
  String get supportUsFundFeature4Title => 'Quran, Salah & productivity';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Continual improvements to core features';

  @override
  String get supportUsNeedHelp => 'NEED HELP?';

  @override
  String get supportUsWhatsApp => 'Chat on WhatsApp';

  @override
  String get supportUsEmailSupport => 'Email Support';

  @override
  String get supportUsChooseAmountTitle => 'Choose a one-time amount';

  @override
  String get supportUsChooseAmountSubtitle =>
      'Every bit helps keep DeenFocus growing.';

  @override
  String get supportUsCustomAmountLabel => 'Or enter a custom amount';

  @override
  String get supportUsPurposeLabel => 'Purpose of your donation (optional)';

  @override
  String get supportUsPurposeHint => 'e.g. Sadaqah, Zakat, app development...';

  @override
  String get supportUsPurposeNote =>
      'Tell us the purpose and we\'ll utilize your contribution accordingly.';

  @override
  String get supportUsOptionalFooter =>
      'Support is entirely optional and helps us keep improving DeenFocus.';

  @override
  String supportUsCta(String amount) {
    return 'Support with $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, I need help with DeenFocus.';

  @override
  String get supportUsEmailSubject => 'DeenFocus support request';

  @override
  String get supportUsLaunchUnavailable =>
      'Could not open that app on this device.';

  @override
  String get supportUsLaunchFailed => 'Something went wrong. Please try again.';

  @override
  String get homeAiChatDescription =>
      'Vraag alles over gebedstijden, de Koran en islamitische richtlijnen.';

  @override
  String get homeDay => 'Dag';

  @override
  String get homeDays => 'Dagen';

  @override
  String get homeNoEventsFoundForDay =>
      'Er zijn geen evenementen gevonden voor deze dag.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — markeer als';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Op tijd gebeden';

  @override
  String get homeMarkPrayerQada => 'Qada (ingehaald)';

  @override
  String get homeMarkPrayerMissed => 'Gemist';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return '$prayerName-instellingen';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Gebedstijd';

  @override
  String get homePrayerSettingsNotification => 'Melding';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Deugden, regels en meer';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Deze instellingen gelden alleen voor $prayerName. Je kunt per gebed andere voorkeuren instellen.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return '$prayerName-tijd bewerken';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Huidige tijd';

  @override
  String get homeEditPrayerTimeSelectNew => 'Nieuwe tijd selecteren';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Deze aangepaste tijd geldt alleen voor $prayerName. Pas hem aan als je lokale moskee of berekening afwijkt.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Tijd opslaan';

  @override
  String get homeEditPrayerTimeReset => 'Terugzetten naar berekende tijd';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Melding voor $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Meldingsgeluid';

  @override
  String get homeNotificationSoundFullAdhan => 'Volledige Adhan';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Speel de volledige Adhan af';

  @override
  String get homeNotificationSoundBeep => 'Pieptoon';

  @override
  String get homeNotificationSoundBeepSubtitle => 'Een korte meldingstoon';

  @override
  String get homeNotificationSoundMute => 'Gedempt';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Geen geluid';

  @override
  String get homeNotificationEnableLabel => 'Melding inschakelen';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Krijg een melding op $prayerName-tijd';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'Over $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Tijd';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakat';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Deugden';

  @override
  String get homeAboutPrayerReferenceLabel => 'Referentie';

  @override
  String get homeAboutFajrTiming =>
      'Begint bij de ware dageraad (Fajr Sadiq) en eindigt bij zonsopgang.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Wie Fajr bidt, staat onder de bescherming van Allah.';

  @override
  String get homeAboutFajrReference =>
      '«De twee rakʿāt van Fajr zijn beter dan de wereld en alles wat zij bevat.» (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Begint zodra de zon haar zenit passeert en duurt tot Asr begint.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Onderdeel van de 12 vrijwillige rakʿāt per dag waarvoor Allah een huis in het Paradijs bouwt.';

  @override
  String get homeAboutDhuhrReference =>
      '«Wie twaalf rakʿāt bidt tijdens een dag en een nacht, krijgt een huis in het Paradijs gebouwd.» (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Begint wanneer de schaduw van een voorwerp gelijk is aan zijn lengte en duurt tot zonsondergang.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Dit gebed bewaken wordt bijzonder beloond en gewaarschuwd.';

  @override
  String get homeAboutAsrReference =>
      '«Wie het Asr-gebed mist, is alsof hij zijn familie en bezit verloor.» (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Begint meteen na zonsondergang en duurt tot de rode schemering verdwijnt.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Een tijd waarin smeekbeden bijzonder worden aangemoedigd.';

  @override
  String get homeAboutMaghribReference =>
      '«Er zijn twee momenten waarop een vastende zich verheugt… wanneer hij het vasten verbreekt.» (Sahih al-Bukhari, over Maghrib-iftar)';

  @override
  String get homeAboutIshaTiming =>
      'Begint wanneer de schemering volledig verdwijnt en duurt tot middernacht (of tot Fajr, volgens sommige meningen).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Isha in congregatie bidden staat gelijk aan het staan van een half nacht in gebed.';

  @override
  String get homeAboutIshaReference =>
      '«Wie Isha in congregatie bidt, is alsof hij de helft van de nacht heeft gebeden.» (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Terug naar Onboarding';

  @override
  String get settings => 'Instellingen';

  @override
  String get appLanguage => 'App-taal';

  @override
  String get tabHome => 'Thuis';

  @override
  String get tabFocus => 'Focus';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Koran';

  @override
  String get tabLearn => 'Leren';

  @override
  String get quranLoadFailed => 'Kan Korangegevens niet laden';

  @override
  String get quranTabSubtitle => 'Lees en verken de Heilige Koran';

  @override
  String get quranSearchHint => 'Zoek soera...';

  @override
  String get quranNoSurahsFound => 'Geen soera\'s gevonden';

  @override
  String get quranVersesLabel => 'verzen';

  @override
  String get quranTextOptions => 'Tekst opties';

  @override
  String get quranEnglishAndArabic => 'Engels en Arabisch';

  @override
  String get quranArabicOnly => 'Alleen Arabisch';

  @override
  String get quranIncreaseFont => 'Lettertype vergroten';

  @override
  String get quranDecreaseFont => 'Lettertype verkleinen';

  @override
  String get quranPause => 'Pauze';

  @override
  String get quranPlaySurah => 'Speel soera';

  @override
  String get quranAudioNoInternet =>
      'Geen internetverbinding. Audio vereist internet.';

  @override
  String get quranAudioTimeout =>
      'Audio laden verlopen. Controleer uw verbinding.';

  @override
  String get quranSurahLabel => 'Soera';

  @override
  String get save => 'Redden';

  @override
  String get tasbihBack => 'Rug';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Selecteer een dhikr of maak er zelf een';

  @override
  String get tasbihAddCustomTitle => 'Voeg Dhikr toe';

  @override
  String get tasbihEditCustomTitle => 'Aangepaste Dhikr bewerken';

  @override
  String get tasbihArabicOrDhikrHint => 'Arabische tekst of een dhikr';

  @override
  String get tasbihTransliterationOptionalHint => 'Transliteratie (optioneel)';

  @override
  String get tasbihMeaningOptionalHint => 'Betekenis (optioneel)';

  @override
  String get tasbihNoTransliteration => 'Geen transliteratie';

  @override
  String get tasbihTotalCount => 'Totaal aantal';

  @override
  String get tasbihGrandTotalLabel => 'Tasbih totaal';

  @override
  String get tasbihTapMe => 'Tik op mij';

  @override
  String get tasbihReset => 'Opnieuw instellen';

  @override
  String get tasbihRestart => 'Opnieuw opstarten';

  @override
  String get tasbihCurrentCount => 'Huidige telling';

  @override
  String get tasbihResetTotal => 'Geschiedenis wissen';

  @override
  String get focusModeActivated => 'Focusmodus geactiveerd';

  @override
  String get focusSetUpHomeCardTitle => 'Focusmodus instellen';

  @override
  String get focusTabSubtitle =>
      'Blijf gefocust wanneer het er het meest toe doet';

  @override
  String get focusChooseAppsEnableMode =>
      'Kies apps en schakel de focusmodus in';

  @override
  String get focusNotifAppsLockedTitle => 'Apps vergrendeld';

  @override
  String get focusNotifAppsUnlockedTitle => 'Apps ontgrendeld';

  @override
  String get focusNotifNightModeTitle => 'Nachtmodus';

  @override
  String get focusNotifGoodMorningTitle => 'Goedemorgen!';

  @override
  String get focusNotifAppsNowAvailableBody => 'Apps zijn nu beschikbaar.';

  @override
  String get focusNotifSalahLockedBody =>
      'Apps zijn vergrendeld tijdens Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah voltooid';

  @override
  String get focusNotifSalahCompleteBody =>
      'Apps zijn nu ontgrendeld. Moge je gebed worden aangenomen.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return '$prayerName-tijd';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Neem een moment voor het $prayerName-gebed.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Nachtmodus staat aan. Laat geest en lichaam rusten.';

  @override
  String get focusNotifGenericLockedBody =>
      'Geselecteerde apps zijn vergrendeld.';

  @override
  String get focusNotifMorningUnlockBody => 'Apps zijn niet beschikbaar.';

  @override
  String get widgetDailyVerseTitle => 'Dagvers';

  @override
  String get widgetOpenAppTimelineHint =>
      'Open Deen Focus om je dagvers en gebed-widgetgegevens klaar te zetten.';

  @override
  String get widgetSetLocationForPrayers =>
      'Stel je locatie in Deen Focus in om gebeden en het dagvers te laden.';

  @override
  String get focusChildModeActive => 'Kindmodus actief';

  @override
  String get focusSalahAndNightModeActive => 'Salah- en nachtmodus actief';

  @override
  String get focusSalahModeActive => 'Salah-modus actief';

  @override
  String get focusNightModeActive => 'Nachtmodus actief';

  @override
  String get focusAppsToBlockTitle => 'Apps om te blokkeren';

  @override
  String get focusAppliesAllModes => 'Geldt voor alle scherpstelmodi';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Toegang tot Screen Time is vereist om apps te bekijken en te selecteren.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Accepteer de openbaarmaking van de toegankelijkheid om door te gaan.';

  @override
  String get focusSelectAppsToBlock => 'Selecteer apps om te blokkeren';

  @override
  String get focusLoading => 'Laden...';

  @override
  String get focusOpen => 'Open';

  @override
  String get focusHide => 'Verbergen';

  @override
  String get focusLoad => 'Laden';

  @override
  String get focusShow => 'Show';

  @override
  String get focusSalahFocusModeTitle => 'Salah-focusmodus';

  @override
  String get focusBlockAppsDuringPrayer => 'Blokkeer apps tijdens het gebed';

  @override
  String get focusNightDisciplineTitle => 'Nachtdiscipline';

  @override
  String get focusSleepLabel => 'Slaap';

  @override
  String get focusWakeLabel => 'Wakker worden';

  @override
  String get focusBlockAppsImmediately => 'Blokkeer apps onmiddellijk';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Schakel Android-app-blokkering in';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Om andere apps op Android te kunnen blokkeren, moet de toegankelijkheidstoestemming van Deenly zijn ingeschakeld. Wij openen het juiste instellingenscherm voor u.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Openbaarmaking van toegankelijkheidsrechten';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly gebruikt Android-toegankelijkheid om app-blokkering in de Focus-modus af te dwingen.\n\nWaarom we het nodig hebben: om te detecteren wanneer u een app opent die u hebt geselecteerd voor blokkering.\n\nHoe we het gebruiken: alleen om de app op de voorgrond te identificeren en het Focus-blokscherm voor geselecteerde apps weer te geven. We gebruiken het niet om getypte tekst of persoonlijke inhoud te lezen.';

  @override
  String get focusNotNow => 'Niet nu';

  @override
  String get focusIUnderstand => 'Ik begrijp';

  @override
  String get focusDone => 'Klaar';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Ontwikkel betere nachtgewoonten';

  @override
  String get focusPrayerBlockingDescription =>
      'Apps worden tijdens het gebed geblokkeerd en na 15 minuten automatisch ontgrendeld, of je kunt ze op elk gewenst moment ontgrendelen vanaf het startscherm.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Apps worden tijdens het gebed geblokkeerd, of je kunt ze op elk gewenst moment ontgrendelen vanaf het startscherm.';

  @override
  String get focusNightBlockingDescription =>
      'Apps worden tijdens uw slaapcyclus geblokkeerd en automatisch ontgrendeld, of u kunt ze op elk gewenst moment ontgrendelen vanaf het startscherm';

  @override
  String get focusChildBlockingDescription =>
      'Apps worden onmiddellijk geblokkeerd in de kindermodus. Ontgrendel ze met de schakelaar of vanaf het startscherm';

  @override
  String get settingsEditUsername => 'Gebruikersnaam bewerken';

  @override
  String get settingsEnterYourName => 'Voer uw naam in';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Ontgrendel alle functies';

  @override
  String get settingsManageSubscriptionTitle => 'Abonnement beheren';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Bekijk plan of werk facturatie bij';

  @override
  String get settingsUsernameLabel => 'Gebruikersnaam';

  @override
  String get settingsLocationLabel => 'Locatie';

  @override
  String get settingsDarkModeLabel => 'Donkere modus';

  @override
  String get settingsAboutTitle => 'Over Deen Focus';

  @override
  String get settingsContactUsTitle => 'Neem contact met ons op';

  @override
  String get settingsSavingLocation => 'Besparing...';

  @override
  String get settingsSaveLocation => 'Locatie opslaan';

  @override
  String get settingsAboutTagline => 'Focus. Discipline. Samenhang.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus helpt je verbonden te blijven met je geloof terwijl je dagelijkse afleidingen beheert in een moderne wereld.';

  @override
  String get settingsAboutFeature1 => 'Gebedstijden met herinneringen';

  @override
  String get settingsAboutFeature2 => 'Qibla-richting op elk moment';

  @override
  String get settingsAboutFeature3 => 'Koran en Tasbih voor dagelijkse dhikr';

  @override
  String get settingsAboutFeature4 => 'Nabijgelegen moskeeën';

  @override
  String get settingsAboutFeature5 =>
      'Slimme focusmodi voor Salah, slaap en familietijd';

  @override
  String get settingsAboutFocusDescription =>
      'Slimme focusmodi helpen je afleidingen te blokkeren tijdens Salah, slaap en belangrijke momenten, zodat je aanwezig en gedisciplineerd kunt blijven.';

  @override
  String get settingsAboutFooter =>
      'Blijf consistent. Blijf bewust.\nBlijf verbonden met je Deen.';

  @override
  String get settingsEnableSystemNotifications =>
      'Schakel systeemmeldingen in om dit in te schakelen.';

  @override
  String get appDemoTitle => 'App-demo';

  @override
  String get appDemoLoadFailed => 'Kan de demovideo niet laden.';

  @override
  String get appDemoRestartHint =>
      'Video heeft een volledige herstart van de app nodig (een warme herstart kan het afspelen onderbreken).';

  @override
  String get appDemoPreviewLoadFailed => 'Kan de demo niet laden.';

  @override
  String get appDemoTryAgain => 'Probeer het opnieuw';

  @override
  String get appDemoWatchLabel => 'Bekijk de demo';

  @override
  String get homeAiChatTitle => 'Deen Focus AI';

  @override
  String get homeAiAskQuestionHint => 'Stel een vraag...';

  @override
  String get homeAiSend => 'Versturen';

  @override
  String get homeAiErrorPrefix =>
      'Sorry, ik kwam een ​​probleem tegen tijdens het verbinden met Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Vraag alles over de Islam';

  @override
  String get homeAiEmptySubtitle =>
      'Gebedstijden, koran, hadith, islamitische evenementen en spirituele begeleiding';

  @override
  String get onboardingTypeCityName => 'Typ uw stadsnaam..';

  @override
  String get onboardingNoLocationsFound => 'Geen locaties gevonden';

  @override
  String get onboardingTryAnotherCityName => 'Probeer een andere plaatsnaam.';

  @override
  String get qiblaCompassUnavailable =>
      'Kompas niet beschikbaar op dit apparaat';

  @override
  String get qiblaFacing => '✓ Kijkend naar Qibla';

  @override
  String get qiblaTurnToFind => 'Draai je om en vind Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Afstand tot Mekka';

  @override
  String get qiblaFromNorth => 'uit Noord';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Nabijgelegen moskeeën';

  @override
  String get nearbyMosquesTryAgain => 'Probeer het opnieuw';

  @override
  String get nearbyMosquesOpenGoogle => 'Openen in Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Openen in Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'Geen moskeeën gevonden binnen';

  @override
  String get nearbyMosquesSearchRadius => 'Zoekradius: 5 km';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Kaartvoorbeeld momenteel niet beschikbaar.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Wachten op uw locatie.';

  @override
  String get nearbyMosquesFetchingLocation => 'Je locatie ophalen…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Huidige locatie';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Moskeeën in de buurt verschijnen hier zodra de resultaten zijn geladen.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'Geen moskeeën gevonden binnen 5 km';

  @override
  String get nearbyMosquesLocationRequired =>
      'Locatietoegang is vereist om nabijgelegen moskeeën te vinden.';

  @override
  String get nearbyMosquesPermissionOff =>
      'Locatietoestemming is uitgeschakeld. Schakel het in de instellingen in om nabijgelegen moskeeën te zien.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'We kunnen uw huidige locatie momenteel niet lezen.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'Live-update mislukt. Laatst opgeslagen resultaten weergeven. Trek om te vernieuwen.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Locatietoegang is geweigerd. Schakel dit in Instellingen in om nabijgelegen moskeeën te zien.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'Locatie is uitgeschakeld op dit apparaat. Schakel het in via Instellingen en probeer het opnieuw.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'Locatietoestemming wordt nog verwerkt. Probeer het over enkele ogenblikken opnieuw.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'Het verzoek duurde te lang. Controleer uw internetverbinding en probeer het opnieuw.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Geen internetverbinding of de dienst is onbereikbaar. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get nearbyMosquesFormatError =>
      'We konden de moskeelijst momenteel niet lezen. Probeer het later opnieuw.';

  @override
  String get nearbyMosquesPlatformError =>
      'Die stap konden we niet voltooien. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Er is iets misgegaan. Probeer het opnieuw.';

  @override
  String get nearbyMosquesEmptyHint =>
      'Niets vermeld binnen een straal van 5 km op OpenStreetMap voor deze plek. Probeer het later opnieuw of verplaats de kaart.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count moskeeën gevonden binnen een straal van 5 km';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Dikr verwijderen?';

  @override
  String get tasbihDelete => 'Verwijderen';

  @override
  String get focusAndroidBlockingNotReady =>
      'Android-appblokkering is nog niet klaar. Houd toegankelijkheid aan en wacht even op de verbinding.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Geen apps geselecteerd. Kies eerst apps om te blokkeren.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Schermtijd-toegang is vereist om apps op de iPhone te blokkeren.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Er ging iets mis bij het bijwerken van de Focus-modus. Probeer het opnieuw.';

  @override
  String get focusLoadingInstalledApps => 'Geïnstalleerde apps laden...';

  @override
  String get focusNoInstalledAppsToShow =>
      'Geen geïnstalleerde apps om te tonen.';

  @override
  String get homeAiSuggestion1 => 'Wat is Ramadan?';

  @override
  String get homeAiSuggestion2 => 'Gebedstijden';

  @override
  String get homeAiSuggestion3 => 'Koran leesplan';

  @override
  String get homeAiDeveloperPrompt =>
      'Je bent een kundige en respectvolle islamitische geleerde-assistent. Help gebruikers islamitische tradities, feestdagen, gebed, Koranstudie en spirituele praktijken te leren. Wees warm, beknopt, educatief en cultureel sensitief. Buiten islamitische begeleiding: antwoord nuttig zonder religieuze zekerheid voor te wenden.';

  @override
  String get homeAiErrorMissingApiKey => 'API-configuratie ontbreekt.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'API-fout $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Geen antwoord van de assistent.';

  @override
  String get homeAiErrorEmptyContent => 'Lege antwoordinhoud.';

  @override
  String get settingsPrayerCalculationSection => 'Gebedberekening';

  @override
  String get settingsCalculationMethodTitle => 'Berekeningsmethode';

  @override
  String get settingsAsrCalculationTitle => 'Asr-berekening';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Grote islamitische organisaties';

  @override
  String get calculationMethodSectionMiddleEast => 'Midden-Oosten';

  @override
  String get calculationMethodSectionAsiaPacific => 'Azië-Pacific';

  @override
  String get calculationMethodSectionSpecial => 'Speciale methoden';

  @override
  String get asrMethodStandard => 'Standaard';

  @override
  String get asrMethodStandardSubtitle => 'Shafi, Maliki, Hanbali';

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
  String get insightsPrayerStreak => 'Prayer streak';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => 'Prayers in a row';

  @override
  String get insightsDaysInARow => 'Days in a row';

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
  String get insightsFocusExcellent => 'Excellent — keep it up!';

  @override
  String get insightsFocusKeepGoing => 'Keep building your focus';

  @override
  String get insightsTodaysPrayers => 'Today\'s prayers';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Cycle mode active';

  @override
  String get insightsProtectedByCycleMode => 'Your streak is protected.';

  @override
  String get insightsCurrentPrayerStreak => 'Current prayer streak';

  @override
  String get insightsBestPrayerStreak => 'Best prayer streak';

  @override
  String get insightsCurrentDayStreak => 'Current day streak';

  @override
  String get insightsCycleProtectedDays => 'Cycle protected days';

  @override
  String get insightsAchievements => 'Achievements';

  @override
  String get insightsAchieved => 'Achieved';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Cycle Mode days are protected and not counted as streak breaks. You have $days protected day(s) available.';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Enable Cycle Mode to protect your streak during rest days.';

  @override
  String get achievementFirstPrayerStreak => 'First Prayer Streak';

  @override
  String get achievementSevenPrayerStreak => 'Seven Prayer Streak';

  @override
  String get achievementThirtyPrayerStreak => 'Thirty Prayer Streak';

  @override
  String get achievementFajrWarrior => 'Fajr Warrior';

  @override
  String get achievementQuranReader => 'Quran Reader';

  @override
  String get achievementDhikrMaster => 'Dhikr Master';

  @override
  String get achievementConsistencyChampion => 'Consistency Champion';

  @override
  String get prayerCompletionAlhamdulillah => 'Alhamdulillah!';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer has been completed';
  }

  @override
  String get prayerCompletionStreakIncreased =>
      'Your prayer streak has increased';

  @override
  String get prayerCompletionKeepGoing =>
      'Every prayer brings you closer to Allah. Keep going!';

  @override
  String get prayerCompletionContinue => 'Continue';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Next prayer in $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }
}
