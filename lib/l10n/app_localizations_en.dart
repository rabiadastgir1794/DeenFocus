// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'Faith. Focus. Consistency';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Prayer Mode. Child Mode. Sleep Mode.';

  @override
  String get welcomeDescription =>
      'Where faith meets focus. Protect your prayers, silence distractions, and grow closer to Allah — every day.';

  @override
  String get skip => 'Skip';

  @override
  String get notNow => 'Not now';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueForFree => 'Maybe later — explore the app first';

  @override
  String get getStarted => 'Start My 7-Day Free Trial';

  @override
  String get language => 'Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get locationRequired => 'Location Required';

  @override
  String get locationRequiredMessage =>
      'Location access is required to calculate accurate prayer times and Qibla direction. You must enable it to use the app.';

  @override
  String get notificationsRequired => 'Notifications Required';

  @override
  String get notificationsRequiredMessage =>
      'Notifications are required to receive prayer time alerts and reminders.';

  @override
  String get sectTitle => 'Choose Your Sect';

  @override
  String get sectSubtitle => 'This helps us personalize your experience';

  @override
  String get sectSunni => 'Sunni';

  @override
  String get sectShia => 'Shia';

  @override
  String get sectPreferNotToSay => 'Prefer not to say';

  @override
  String get nameTitle => 'What\'s Your Name?';

  @override
  String get nameSubtitle => 'Let\'s personalize your greeting';

  @override
  String get namePlaceholder => 'Your name';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => 'Allow Location Access';

  @override
  String get locationManualEntry => 'Enter your city manually';

  @override
  String get locationOrDivider => 'or';

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
  String get notificationsButton => 'Enable Notifications';

  @override
  String get notificationsMaybeLater => 'Maybe Later';

  @override
  String get notificationsEnabled => 'Notifications are enabled';

  @override
  String get notificationsPreviewDate => 'Friday, 10 July';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'now';

  @override
  String get notificationsPreviewMinutesAgo => '2m ago';

  @override
  String get notificationsPreviewHourAgo => '1h ago';

  @override
  String get notificationsPreviewAdhanTitle => 'Maghrib Adhan';

  @override
  String get notificationsPreviewAdhanBody => 'It\'s time to pray.';

  @override
  String get notificationsPreviewDhikrTitle => 'Daily Dhikr';

  @override
  String get notificationsPreviewDhikrBody => 'SubhanAllah — take a moment.';

  @override
  String get notificationsPreviewStreakTitle => 'Streak';

  @override
  String get notificationsPreviewStreakBody => '7 days of complete prayers.';

  @override
  String get screenTimeTitle => 'Enable Screen Time';

  @override
  String get screenTimeSubtitle =>
      'This is what lets Deen Focus pause distracting apps during Salah, sleep time and child mode.';

  @override
  String get screenTimeButton => 'Allow Screen Time Access';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus never reads your data — it only pauses the apps you choose.';

  @override
  String get onboardingSelectAppsTitlePrefix => 'Select';

  @override
  String get onboardingSelectAppsTitleAccent => 'Apps to Lock';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Select the apps you want to lock when it\'s time to pray.';

  @override
  String get onboardingSelectAppsButton => 'Select Apps';

  @override
  String get onboardingSelectAppsSkipForNow => 'Skip for Now';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'You\'re in control';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'We never read your data. We only lock the apps you choose.';

  @override
  String get onboardingSelectAppsMockAllApps => 'All Apps & Categories';

  @override
  String get onboardingSelectAppsMockPhotos => 'Photos';

  @override
  String get onboardingSelectAppsMockNotes => 'Notes';

  @override
  String get onboardingSelectAppsMockMusic => 'Music';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => 'Podcasts';

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
  String get onboardingWidgetsLiveTitle => 'Your prayers, always within reach';

  @override
  String get onboardingWidgetsLiveSubtitle =>
      'Stay connected with what matters most — right from your Home Screen or Lock Screen.';

  @override
  String get onboardingWidgetsSectionTitle => 'Widgets';

  @override
  String get onboardingWidgetsSectionBodyPrefix =>
      'Check your next prayer, streaks, and progress ';

  @override
  String get onboardingWidgetsSectionBodyEmphasis => 'at a glance.';

  @override
  String get onboardingLiveActivitiesSectionTitle => 'Live Activities';

  @override
  String get onboardingLiveActivitiesSectionBodyPrefix =>
      'See your upcoming prayer updates in ';

  @override
  String get onboardingLiveActivitiesSectionBodyEmphasis => 'real time';

  @override
  String get onboardingLiveActivitiesSectionBodySuffix =>
      ' on your Lock Screen and Dynamic Island.';

  @override
  String get onboardingWidgetsLiveTrustPrefix => 'Designed to help you stay ';

  @override
  String get onboardingWidgetsLiveTrustEmphasis => 'consistent';

  @override
  String get onboardingWidgetsLiveTrustSuffix =>
      ' and never miss what matters most.';

  @override
  String get onboardingWidgetsMockStreak => 'Streak';

  @override
  String get onboardingWidgetsMockStreakValue => '12 days';

  @override
  String get onboardingWidgetsMockFocus => 'Focus';

  @override
  String get onboardingWidgetsMockFocusValue => '25 min';

  @override
  String get onboardingWidgetsLiveLockDate => 'Tuesday, 6 May';

  @override
  String get onboardingWidgetsLiveLockTime => '9:41';

  @override
  String get onboardingWidgetsLiveNextPrayer => 'Dhuhr 12:45 PM in 02:15:32';

  @override
  String get focusModesSectionLabel => 'FOCUS MODES · TAP TO LEARN MORE';

  @override
  String get focusPrayerTrackingSectionLabel => 'PRAYER & TRACKING';

  @override
  String get focusLearningHubSectionLabel => 'LEARNING HUB';

  @override
  String get focusMoreSectionLabel => 'MORE';

  @override
  String get focusPrayerModeTitle => 'Prayer Mode';

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
  String get focusSleepModeTitle => 'Sleep Mode';

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
  String get focusChildModeTitle => 'Child Mode';

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
  String get restrictedModeSalahTitle => 'Salah Time';

  @override
  String get restrictedModeSalahMessage =>
      'It\'s time to step away from distractions and answer the call to prayer.';

  @override
  String get restrictedModeSalahInfo =>
      'Take this moment to connect with Allah.';

  @override
  String get restrictedModeSalahQuote => 'Establish prayer for My remembrance.';

  @override
  String get restrictedModeSalahQuoteSource => 'Quran 20:14';

  @override
  String get restrictedModeSalahCta => 'Start Salah';

  @override
  String get restrictedModeChildTitle => 'Child Focus Mode';

  @override
  String get restrictedModeChildMessage =>
      'A safer, more balanced space for focused screen time.';

  @override
  String get restrictedModeChildInfo =>
      'Some apps are temporarily unavailable.';

  @override
  String get restrictedModeChildQuote =>
      'Teach your children prayer when they are seven.';

  @override
  String get restrictedModeChildQuoteSource => 'Hadith - Abu Dawood';

  @override
  String get restrictedModeChildCta => 'Stay Protected';

  @override
  String get restrictedModeNightTitle => 'Night Focus Mode';

  @override
  String get restrictedModeNightMessage =>
      'It\'s time to rest and disconnect from digital distractions.';

  @override
  String get restrictedModeNightInfo =>
      'Put your device aside and enjoy a peaceful night.';

  @override
  String get restrictedModeNightQuote =>
      'And We made your sleep a means for rest.';

  @override
  String get restrictedModeNightQuoteSource => 'Quran 78:9';

  @override
  String get restrictedModeNightCta => 'Good Night';

  @override
  String get restrictedModeAppsUnavailable =>
      'Some apps are temporarily unavailable.';

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
  String get investTitle => 'Invest in Deen';

  @override
  String get investSubtitle =>
      'The best investment isn\'t in things that fade — it\'s in what draws you closer to Allah. Try everything free for 7 days.';

  @override
  String get investPremiumUnlocked => 'PREMIUM UNLOCKED';

  @override
  String get investTrialPill => '✨ 7 days free — cancel anytime before it ends';

  @override
  String get investNoCommitment => 'No commitment. Cancel anytime.';

  @override
  String get investFeatureAiTitle => 'AI Islamic Assistant';

  @override
  String get investFeatureAiBody =>
      'Ask anything about your Deen — answers rooted in authentic sources.';

  @override
  String get investFeaturePrayerModeTitle => 'Full-Screen Prayer Mode';

  @override
  String get investFeaturePrayerModeBody =>
      'A calm, distraction-free screen that calls you to Salah.';

  @override
  String get investFeatureAppBlockingTitle => 'Advanced App Blocking';

  @override
  String get investFeatureAppBlockingBody =>
      'Granular control over which apps lock, and exactly when.';

  @override
  String get investFeatureNightModeTitle => 'Night Discipline Mode';

  @override
  String get investFeatureNightModeBody =>
      'Wind down on time, sleep better, and wake up for Fajr.';

  @override
  String get investFeaturePlannerTitle => 'Prayer Planner & Progress';

  @override
  String get investFeaturePlannerBody =>
      'Streaks, insights and journals that keep you consistent.';

  @override
  String get investFeatureToolsTitle => 'Exclusive Islamic Tools';

  @override
  String get investFeatureToolsBody =>
      'Hijri calendar, Duas, Tasbih, 99 Names and more.';

  @override
  String get investFeatureThemesTitle => 'Premium Themes & Updates';

  @override
  String get investFeatureThemesBody =>
      'Beautiful themes plus every new feature we ship.';

  @override
  String get investFeatureTajweedTitle => 'Master Tajweed';

  @override
  String get investFeatureTajweedBody =>
      'Improve your recitation with guided lessons and real-time feedback.';

  @override
  String get socialProofPrefix => 'Join ';

  @override
  String get socialProofHighlight => '10,000+';

  @override
  String get socialProofSuffix => ' Muslims growing with DeenFocus';

  @override
  String get mostPopular => 'Most Popular';

  @override
  String get monthlyLabel => 'Monthly';

  @override
  String get yearlyLabel => 'Yearly';

  @override
  String get lifetimeLabel => 'Lifetime';

  @override
  String get featureNoAds => 'Removes all ads';

  @override
  String get featureSupport => 'Priority support';

  @override
  String get homeTitle => 'Deenly Home';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback => 'Indeed, with hardship comes ease.';

  @override
  String get homeAppsLocked => 'Apps Locked';

  @override
  String get homeAppsUnlocked => 'Apps Unlocked';

  @override
  String get homeTapToUnlock => 'Tap to unlock apps temporarily';

  @override
  String get homeTapToRelock => 'Tap to relock blocked apps now';

  @override
  String get homeRelock => 'Relock';

  @override
  String get homeUnlock => 'Unlock';

  @override
  String get homePrayerModeActive => 'Prayer Mode Active';

  @override
  String get homeActivatePrayerMode => 'Activate Prayer Mode';

  @override
  String get homeAppsBlockedSubtitle => 'Apps are blocked. Tap to deactivate.';

  @override
  String get homeBlockDistractingApps => 'Block distracting apps during Salah.';

  @override
  String get homeQiblaDirection => 'Qibla Direction';

  @override
  String get homeLocationMissingForQibla =>
      'Enable location to calculate Qibla direction.';

  @override
  String get homeQiblaSubtitleGuiding => 'Guiding you toward the Qibla';

  @override
  String get homeToMakkah => 'to Makkah';

  @override
  String get homeFindMasjid => 'Find Masjid Near Me';

  @override
  String get quickActionsMasjidFinder => 'Masjid Finder';

  @override
  String get homeSearchNearbyMosques => 'Search nearby mosques.';

  @override
  String get homePrayerStreak => 'Prayer Streak';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Insights';

  @override
  String get homeOpenStreakDetails => 'Open streak details.';

  @override
  String get homeTodaysPrayers => 'Today\'s Prayers';

  @override
  String get homePrayerTimesUnavailable =>
      'Prayer times are unavailable right now.';

  @override
  String get homeNextPrayerIn => 'Next prayer in';

  @override
  String get homeTapPrayerToMark =>
      'Tap a prayer to mark it prayed, qada, or missed.';

  @override
  String get homeSetLocation => 'Set location';

  @override
  String get homeEditPrayerSettings => 'Edit prayer settings';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Sunrise';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Maghrib';

  @override
  String get homePrayerIsha => 'Isha';

  @override
  String get homeWeek => 'Week';

  @override
  String get homeMonth => 'Month';

  @override
  String get homeThisWeek => 'Deen Highlights This Week';

  @override
  String get homeJummahMubarak => 'Jummah Mubarak';

  @override
  String get homeJummahReminder => 'Don\'t forget Surah Al-Kahf.';

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
  String get cycleModeActiveTitle => 'Your cycle is a pause, not a stop.';

  @override
  String get cycleModeActiveSubtitle => 'Dhikr • Tasbih • Quran listening';

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
  String get cycleModeSettingsTitle => 'Cycle Mode';

  @override
  String get cycleModeStartDateLabel => 'Start date';

  @override
  String get cycleModeLengthLabel => 'Cycle length';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Protect prayer streak';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'Exclude from statistics';

  @override
  String get cycleModeSaveButton => 'Save';

  @override
  String get cycleModeEditButton => 'Edit';

  @override
  String get cycleModeChangeStartDateTitle => 'Change start date?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Changing the start date will recalculate your active Cycle Mode window. Days outside the new range may no longer be treated as cycle days.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Change start date';

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
  String get prayerNotificationSubtitleFajr =>
      '“Indeed, the recitation of dawn is ever witnessed.” — Qur’an 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '“Establish prayer at the decline of the sun...” — Qur’an 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '“Guard strictly the prayers, especially the middle prayer.” — Qur’an 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '“So glorify Allah when you reach the evening...” — Qur’an 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '“Establish prayer -  until the darkness of the night.” — Qur’an 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'It\'s time for $prayerName';
  }

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
  String get homeLivePrayerUpdatesTitle => 'Live Prayer Updates';

  @override
  String get homeLivePrayerUpdatesBody =>
      'See your current and next prayer on your Lock Screen & Dynamic Island.';

  @override
  String get homeLivePrayerUpdatesCta => 'Enable Live Updates';

  @override
  String get homeWidgetsPromoTitle => 'Widgets';

  @override
  String get homeWidgetsPromoBody =>
      'See your daily verse and prayer times on your Home Screen.';

  @override
  String get homeWidgetsPromoCta => 'Add Widget';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Night';

  @override
  String get focusModeShortChild => 'Child';

  @override
  String get focusModeLabelSalah => 'Salah mode';

  @override
  String get focusModeLabelNight => 'Night mode';

  @override
  String get focusModeLabelChild => 'Child mode';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return '$first and $second Modes are enabled';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return '$first, $second, and $third Modes are enabled';
  }

  @override
  String get cycleModeTitle => 'Cycle Mode';

  @override
  String get cycleModeSubtitle =>
      'For menstruation — pause prayers, keep your streak';

  @override
  String get dailyChecklistTitle => 'Daily Checklist';

  @override
  String get dailyChecklistSubtitle => 'Track your daily spiritual goals';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed of $total completed';
  }

  @override
  String get dailyChecklistSectionPrayer => 'Prayer';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Quran & Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Good deeds';

  @override
  String get dailyChecklistSectionDistraction => 'Personal discipline';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Evening Adhkar';

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
  String get focusScoreTitle => 'Today\'s Focus Score';

  @override
  String get focusScorePrayer => 'Prayer';

  @override
  String get focusScoreQuran => 'Quran';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Distraction control';

  @override
  String get insightsBack => 'Back';

  @override
  String get insightsTitle => 'My Insights';

  @override
  String get insightsSubtitle => 'Track your Deen progress';

  @override
  String get insightsPrayerRate => 'Prayer rate';

  @override
  String get insightsDayStreak => 'Day streak';

  @override
  String get insightsBestStreak => 'Best streak';

  @override
  String get insightsWeekly => 'Weekly';

  @override
  String get insightsMonthly => 'Monthly';

  @override
  String get insightsPrayersCompleted => 'Prayers completed';

  @override
  String get insightsRestoreStreak => 'Restore my streak — last 24 hours';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Prayer $prayerPercent% · Quran $quranPercent% · Dhikr $dhikrPercent% · Distraction control $distractionPercent%';
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
  String get supportUsHeroTitle => 'Support DeenFocus';

  @override
  String get supportUsHeroBody =>
      'Your support helps us keep improving DeenFocus and contribute to meaningful causes.';

  @override
  String get supportUsFundSection => 'Your support helps fund';

  @override
  String get supportUsFundSectionSubtitle =>
      'We use your support to create more good.';

  @override
  String get supportUsFundFeature1Title => 'New Features';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Build and improve meaningful DeenFocus features.';

  @override
  String get supportUsFundFeature2Title => 'Bug Fixes';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Keep the app stable, fast and reliable for everyone.';

  @override
  String get supportUsFundFeature3Title => 'People in Need';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Support efforts that help people facing hardship and difficult times.';

  @override
  String get supportUsFundFeature4Title => 'Charity & Community';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Contribute towards charitable initiatives and community support.';

  @override
  String get supportUsNeedHelp => 'NEED HELP?';

  @override
  String get supportUsWhatsApp => 'Chat on WhatsApp';

  @override
  String get supportUsEmailSupport => 'Email Support';

  @override
  String get supportUsChooseAmountTitle => 'Choose a support amount';

  @override
  String get supportUsChooseAmountSubtitle => 'You can support multiple times.';

  @override
  String get supportUsSecurePaymentNote =>
      'Secure one-time payment · No recurring charges';

  @override
  String get supportUsTrustBanner =>
      'Secure • One-time Support • You can support multiple times';

  @override
  String get supportUsImpactSectionTitle =>
      'Where your support makes a difference';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Every contribution has a lasting impact.';

  @override
  String get supportUsImpactPalestine => 'Support & Awareness for Palestine';

  @override
  String get supportUsImpactNeedy => 'Helping Those in Need';

  @override
  String get supportUsImpactCommunity => 'Charity & Community Support';

  @override
  String get supportUsImpactExperience => 'Better DeenFocus Experience';

  @override
  String get supportUsImpactFeatures => 'New Features & Upgrades';

  @override
  String get supportUsImpactQuran => 'Quran & Islamic Learning';

  @override
  String get supportUsImpactServers => 'Servers & App Reliability';

  @override
  String supportUsCta(String amount) {
    return 'Support DeenFocus with $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, I need help with DeenFocus.';

  @override
  String get supportUsWhatsAppQuestionHowTo => 'How do I use DeenFocus?';

  @override
  String get supportUsWhatsAppQuestionFeature => 'I need help with a feature';

  @override
  String get supportUsWhatsAppQuestionSubscription =>
      'I have a problem with my subscription';

  @override
  String get supportUsEmailSubject => 'DeenFocus support request';

  @override
  String get supportUsLaunchUnavailable =>
      'Could not open that app on this device.';

  @override
  String get supportUsLaunchFailed => 'Something went wrong. Please try again.';

  @override
  String get supportUsThankYouTitle => 'JazakAllah khair';

  @override
  String get supportUsThankYouBody =>
      'Thank you for supporting DeenFocus. You can support again anytime.';

  @override
  String get supportUsPurchasePending =>
      'Your support is pending. We\'ll confirm it once Apple completes the purchase.';

  @override
  String get supportUsPurchaseFailed =>
      'We couldn\'t complete your support payment. Please try again.';

  @override
  String get supportUsProductUnavailable =>
      'This support amount isn\'t available right now. Please try again later.';

  @override
  String get homeAiChatDescription =>
      'Ask anything about prayer times, Quran, and Islamic guidance.';

  @override
  String get homeDay => 'Day';

  @override
  String get homeDays => 'Days';

  @override
  String get homeNoEventsFoundForDay => 'No events found for this day.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — mark as';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Prayed on time';

  @override
  String get homeMarkPrayerQada => 'Qada (made up)';

  @override
  String get homeMarkPrayerMissed => 'Missed';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return '$prayerName Settings';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Prayer Time';

  @override
  String get homePrayerSettingsNotification => 'Notification';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Virtues, rulings and more';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'These settings are only for $prayerName. You can set different preferences for each prayer.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'Edit $prayerName Time';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Current Time';

  @override
  String get homeEditPrayerTimeSelectNew => 'Select new time';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'This custom time applies only to $prayerName. Adjust it if your local masjid or calculation differs.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Save Time';

  @override
  String get homeEditPrayerTimeReset => 'Reset to calculated time';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Notification for $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Notification Sound';

  @override
  String get homeNotificationSoundFullAdhan => 'Full Adhan';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Play the complete Adhan';

  @override
  String get homeNotificationSoundBeep => 'Beep';

  @override
  String get homeNotificationSoundBeepSubtitle => 'A short notification tone';

  @override
  String get homeNotificationSoundMute => 'Mute';

  @override
  String get homeNotificationSoundMuteSubtitle => 'No sound';

  @override
  String get homeNotificationEnableLabel => 'Enable Notification';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Get notified at $prayerName time';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'About $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Time';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakat';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Virtues';

  @override
  String get homeAboutPrayerReferenceLabel => 'Reference';

  @override
  String get homeAboutFajrTiming =>
      'Begins at true dawn (Fajr Sadiq) and ends at sunrise.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Whoever prays Fajr is under the protection of Allah.';

  @override
  String get homeAboutFajrReference =>
      '\"The two rak\'ahs of Fajr are better than the world and all it contains.\" (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Begins once the sun passes its zenith and lasts until Asr begins.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Part of the 12 voluntary rak\'ahs a day for which Allah builds a house in Paradise.';

  @override
  String get homeAboutDhuhrReference =>
      '\"Whoever prays twelve rak\'ahs during a day and a night will have a house built for him in Paradise.\" (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Begins when an object\'s shadow equals its length and lasts until sunset.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Guarding this prayer is singled out for special reward and warning.';

  @override
  String get homeAboutAsrReference =>
      '\"Whoever misses the Asr prayer, it is as if he lost his family and his wealth.\" (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Begins right after sunset and lasts until the red twilight disappears.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'A time when supplications are especially encouraged.';

  @override
  String get homeAboutMaghribReference =>
      '\"There are two occasions when a fasting person rejoices... when he breaks his fast.\" (Sahih al-Bukhari, on the Maghrib fast-breaking)';

  @override
  String get homeAboutIshaTiming =>
      'Begins once the twilight fully disappears and lasts until midnight (or Fajr, per some views).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Praying Isha in congregation is equivalent to standing half the night in prayer.';

  @override
  String get homeAboutIshaReference =>
      '\"Whoever prays Isha in congregation, it is as if he prayed half the night.\" (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Back to Onboarding';

  @override
  String get settings => 'Settings';

  @override
  String get appLanguage => 'App Language';

  @override
  String get tabHome => 'Home';

  @override
  String get tabFocus => 'Focus';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Learn';

  @override
  String get tabLearn => 'Learn';

  @override
  String get quranLoadFailed => 'Failed to load Quran data';

  @override
  String get quranTabSubtitle => 'Read and explore the Holy Quran';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Search surah...';

  @override
  String get quranSearchHintExtended => 'Search surah or meaning...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranNoSurahsFound => 'No surahs found';

  @override
  String get quranVersesLabel => 'verses';

  @override
  String quranSurahHeaderSubtitle(String name, int count) {
    return '$name • $count verses';
  }

  @override
  String get quranTextOptions => 'Text options';

  @override
  String get quranEnglishAndArabic => 'English and Arabic';

  @override
  String get quranArabicOnly => 'Arabic only';

  @override
  String get quranIncreaseFont => 'Increase font';

  @override
  String get quranDecreaseFont => 'Decrease font';

  @override
  String get quranPause => 'Pause';

  @override
  String get quranPlaySurah => 'Play surah';

  @override
  String get quranAudioNoInternet =>
      'No internet connection. Audio requires internet.';

  @override
  String get quranAudioTimeout =>
      'Audio load timed out. Check your connection.';

  @override
  String get quranSurahLabel => 'Surah';

  @override
  String get quranModeSurah => 'Surah';

  @override
  String get quranModeJuz => 'Juz';

  @override
  String get quranModePage => 'Page';

  @override
  String get quranSwitchToPageView => 'Page view';

  @override
  String get quranSwitchToSurahView => 'Surah view';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => 'Continue Reading';

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
    return '$percent% of Juz $juz';
  }

  @override
  String get quranBookmarksTitle => 'Bookmarks';

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
    return '$count saved';
  }

  @override
  String get quranQuickTajweed => 'Tajweed drill';

  @override
  String get quranQuickTajweedSub => 'Recite & score';

  @override
  String get quranLastListened => 'Last listened';

  @override
  String get quranNoneYet => 'None yet';

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
  String get readingSettingsTajweedPractice => 'AI Quran Tajweed';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Recite ayahs and get feedback';

  @override
  String get readingSettingsTajweedSeeHowItWorks => 'See how it works';

  @override
  String get quranSeeHowAiQuranTajweedWorks => 'see how AI Quran Tajweed works';

  @override
  String get readingSettingsTajweedDeleteModel => 'Delete AI model';

  @override
  String get readingSettingsTajweedDeleteConfirmTitle =>
      'Delete AI Quran Tajweed model?';

  @override
  String get readingSettingsTajweedDeleteConfirmBody =>
      'You won\'t be able to practice tajweed until you download the AI model again. This also frees storage on your device.';

  @override
  String get readingSettingsTajweedDeleteConfirmAction => 'Delete';

  @override
  String get readingSettingsTajweedDeleted => 'AI Tajweed model deleted';

  @override
  String get readingSettingsTajweedDeleteFailed =>
      'Could not delete the AI Tajweed model';

  @override
  String get readingSettingsTajweedFreePreviewTranslation =>
      'In the name of Allah, the Entirely Merciful, the Especially Merciful.';

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
  String get readingSettingsTitle => 'Reading Settings';

  @override
  String get readingSettingsArabicFontSize => 'Arabic font size';

  @override
  String get readingSettingsTranslationFontSize => 'Translation font size';

  @override
  String get readingSettingsLineSpacing => 'Line spacing';

  @override
  String get readingSettingsDefaultMode => 'Default reading mode';

  @override
  String get readingSettingsRememberPosition => 'Remember last position';

  @override
  String get readingSettingsScript => 'Arabic script';

  @override
  String get readingSettingsScriptUthmani => 'Uthmani (Hafs)';

  @override
  String get readingSettingsScriptIndopak => 'IndoPak (Hafs)';

  @override
  String get readingSettingsArabicFont => 'Arabic font';

  @override
  String get readingSettingsFontUthmanic => 'Uthmanic Hafs';

  @override
  String get readingSettingsFontNooreHuda => 'Noore Huda';

  @override
  String get readingSettingsFontSystem => 'System (native)';

  @override
  String get readingSettingsShowTranslation => 'Show translation';

  @override
  String get readingSettingsShowTransliteration => 'Show transliteration';

  @override
  String get readingSettingsTranslationSection => 'Translation';

  @override
  String get readingSettingsTranslationLabel => 'Translation';

  @override
  String get readingSettingsTranslationCurrent => 'Current';

  @override
  String get readingSettingsInstalledTranslations => 'Installed';

  @override
  String get readingSettingsAvailableTranslations => 'Available';

  @override
  String get readingSettingsTranslationInstalled => 'Installed';

  @override
  String get readingSettingsTranslationSelected => 'Selected';

  @override
  String get readingSettingsTranslationDownload => 'Download';

  @override
  String get readingSettingsTranslationInstalling => 'Installing…';

  @override
  String get readingSettingsTranslationDownloading => 'Downloading…';

  @override
  String get readingSettingsLayoutTheme => 'Quran layout';

  @override
  String get readingSettingsLayoutClassic => 'Mushaf';

  @override
  String get readingSettingsLayoutSimple => 'Simple';

  @override
  String get readingSettingsLayoutColor => 'Color Quran';

  @override
  String get readingSettingsColorTheme => 'Reading theme';

  @override
  String get readingSettingsColorThemeParchment => 'Parchment';

  @override
  String get readingSettingsColorThemeEmerald => 'Emerald';

  @override
  String get readingSettingsColorThemeMidnight => 'Midnight';

  @override
  String get readingSettingsPreview => 'Preview';

  @override
  String get readingSettingsResetHistoryTitle => 'Reset reading data';

  @override
  String get readingSettingsResetHistorySubtitle =>
      'Clears continue reading, page progress, bookmarks, and quick actions';

  @override
  String get readingSettingsResetHistoryConfirmTitle => 'Reset reading data?';

  @override
  String get readingSettingsResetHistoryConfirmBody =>
      'This removes continue reading, page completion progress, bookmarks, last listened, and last Tajweed shortcuts. Your display and translation settings are kept.';

  @override
  String get readingSettingsResetHistoryDone => 'Reading data cleared';

  @override
  String get readingSettingsResetHistoryButton => 'Reset';

  @override
  String readingSettingsTranslationDownloadFailed(String name) {
    return 'Could not download $name. Try again when online.';
  }

  @override
  String readingSettingsTranslationSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => 'Start reciting';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'WORD ACCURACY';

  @override
  String get tajweedWordReviewLabel => 'WORD REVIEW';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Recite & check tajweed';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nasal hold, 2 counts';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Echo bounce';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Prolong the vowel';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Merge letters';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Hide the noon';

  @override
  String get save => 'Save';

  @override
  String get tasbihBack => 'Back';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle => 'Select a dhikr or create your own';

  @override
  String get tasbihAddCustomTitle => 'Add Dhikr';

  @override
  String get tasbihEditCustomTitle => 'Edit Custom Dhikr';

  @override
  String get tasbihArabicOrDhikrHint => 'Arabic text or any dhikr';

  @override
  String get tasbihTransliterationOptionalHint => 'Transliteration (optional)';

  @override
  String get tasbihMeaningOptionalHint => 'Meaning (optional)';

  @override
  String get tasbihNoTransliteration => 'No transliteration';

  @override
  String get tasbihTotalCount => 'Total Count';

  @override
  String get tasbihGrandTotalLabel => 'Total Tasbih';

  @override
  String get tasbihTapMe => 'Tap Me';

  @override
  String get tasbihReset => 'Reset';

  @override
  String get tasbihRestart => 'Restart';

  @override
  String get tasbihCurrentCount => 'Current Count';

  @override
  String get tasbihResetTotal => 'Clear History';

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
  String get focusModeActivated => 'Focus Mode Activated';

  @override
  String get focusSetUpHomeCardTitle => 'Set up Focus mode';

  @override
  String get focusTabSubtitle => 'Stay focused when it matters most';

  @override
  String get focusChooseAppsEnableMode => 'Choose apps and enable focus mode';

  @override
  String get focusNotifAppsLockedTitle => 'Apps Locked';

  @override
  String get focusNotifAppsUnlockedTitle => 'Apps Unlocked';

  @override
  String get focusNotifNightModeTitle => 'Night Mode On';

  @override
  String get focusNotifGoodMorningTitle => 'Good Morning';

  @override
  String get focusNotifAppsNowAvailableBody => 'Apps are now available.';

  @override
  String get focusNotifSalahLockedBody => 'Apps are locked during Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah Complete';

  @override
  String get focusNotifSalahCompleteBody =>
      'Apps are now unlocked. May your prayer be accepted.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return '$prayerName Time';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Take a moment for $prayerName prayer.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Night mode is on. Let your mind and body rest.';

  @override
  String get focusNotifGenericLockedBody => 'Selected apps are locked.';

  @override
  String get focusNotifMorningUnlockBody =>
      'Good morning! Apps are now available.';

  @override
  String get widgetDailyVerseTitle => 'Daily Verse';

  @override
  String get widgetOpenAppTimelineHint =>
      'Open Deen Focus to prepare your daily verse and prayer widget data.';

  @override
  String get widgetSetLocationForPrayers =>
      'Set your location in Deen Focus to load prayers and the daily verse.';

  @override
  String get widgetPrayerProgressTitle => 'Your Prayer Progress';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed of $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'prayers completed.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Keep going — $count prayers left today';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — all prayers complete today';

  @override
  String get focusChildModeActive => 'Child Mode Active';

  @override
  String get focusSalahAndNightModeActive => 'Salah and Night Mode Active';

  @override
  String get focusSalahModeActive => 'Salah Mode Active';

  @override
  String get focusNightModeActive => 'Night Mode Active';

  @override
  String get focusAppsToBlockTitle => 'Apps to Block';

  @override
  String get focusAppliesAllModes => 'Applies to all focus modes';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Screen Time access is required to view and select apps.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Please accept the accessibility disclosure to continue.';

  @override
  String get focusSelectAppsToBlock => 'Select apps to block';

  @override
  String get focusLoading => 'Loading...';

  @override
  String get focusOpen => 'Open';

  @override
  String get focusHide => 'Hide';

  @override
  String get focusLoad => 'Load';

  @override
  String get focusShow => 'Show';

  @override
  String get focusSalahFocusModeTitle => 'Salah Focus Mode';

  @override
  String get focusBlockAppsDuringPrayer => 'Block apps during prayer';

  @override
  String get focusNightDisciplineTitle => 'Night Discipline';

  @override
  String get focusSleepLabel => 'Sleep';

  @override
  String get focusWakeLabel => 'Wake';

  @override
  String get focusBlockAppsImmediately => 'Block apps immediately';

  @override
  String get focusEnableAndroidAppBlocking => 'Enable Android app blocking';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'To block other apps on Android, Deenly needs its accessibility permission turned on. We will open the correct settings screen for you.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Accessibility permission disclosure';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly uses Android Accessibility to enforce Focus mode app blocking.\n\nWhy we need it: to detect when you open an app you selected for blocking.\n\nHow we use it: only to identify the foreground app and show the Focus block screen for selected apps. We do not use it to read typed text or personal content.';

  @override
  String get focusNotNow => 'Not now';

  @override
  String get focusIUnderstand => 'I understand';

  @override
  String get focusDone => 'Done';

  @override
  String get focusNightDisciplineCardSubtitle => 'Build better night habits';

  @override
  String get focusPrayerBlockingDescription =>
      'Apps will be blocked during prayer and unlock automatically after 15 minutes, or you can unlock them anytime from the home screen.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Apps will be blocked during prayer, or you can unlock them anytime from the home screen.';

  @override
  String get focusNightBlockingDescription =>
      'Apps will be blocked during your sleep cycle and unlock automatically, or you can unlock them anytime from the home screen';

  @override
  String get focusChildBlockingDescription =>
      'Apps are blocked instantly in Child Mode. Unlock them using the toggle or from the home screen';

  @override
  String get settingsEditUsername => 'Edit Username';

  @override
  String get settingsEnterYourName => 'Enter your name';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Unlock all features';

  @override
  String get settingsManageSubscriptionTitle => 'Manage subscription';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'View plan or update billing';

  @override
  String get settingsUsernameLabel => 'Username';

  @override
  String get settingsLocationLabel => 'Location';

  @override
  String get settingsDarkModeLabel => 'Dark Mode';

  @override
  String get settingsAboutTitle => 'About Deen Focus';

  @override
  String get settingsRateDeenFocus => 'Rate DeenFocus ⭐';

  @override
  String get settingsContactUsTitle => 'Contact Us';

  @override
  String get settingsSavingLocation => 'Saving...';

  @override
  String get settingsSaveLocation => 'Save Location';

  @override
  String get settingsAboutTagline => 'Focus. Discipline. Consistency.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus helps you stay connected to your faith while managing daily distractions in a modern world.';

  @override
  String get settingsAboutFeature1 => 'Prayer times with reminders';

  @override
  String get settingsAboutFeature2 => 'Qibla direction anytime';

  @override
  String get settingsAboutFeature3 => 'Quran and Tasbih for daily dhikr';

  @override
  String get settingsAboutFeature4 => 'Nearby mosques';

  @override
  String get settingsAboutFeature5 =>
      'Smart focus modes for Salah, sleep, and family time';

  @override
  String get settingsAboutFocusDescription =>
      'Smart focus modes help you block distractions during Salah, sleep, and important moments, so you can stay present and disciplined.';

  @override
  String get settingsAboutFooter =>
      'Stay consistent. Stay mindful. Stay connected to your Deen.';

  @override
  String get settingsAboutOffersHeading => 'What Deen Focus offers';

  @override
  String get settingsAboutNewBadge => 'New';

  @override
  String get settingsAboutFooterCard =>
      'Smart tools to help you stay mindful, consistent, and connected to your Deen — every day.';

  @override
  String get settingsAboutOfferPrayerTimesTitle => 'Accurate Prayer Times';

  @override
  String get settingsAboutOfferPrayerTimesSubtitle =>
      'Timely prayer alerts and beautiful widgets to keep you on track.';

  @override
  String get settingsAboutOfferPrayerStreaksTitle => 'Prayer Streaks';

  @override
  String get settingsAboutOfferPrayerStreaksSubtitle =>
      'Build consistency and grow in your Deen with daily and overall streak tracking.';

  @override
  String get settingsAboutOfferCycleModeTitle => 'Cycle Mode';

  @override
  String get settingsAboutOfferCycleModeSubtitle =>
      'For menstruation — pause prayers, keep your streak, and maintain your journey.';

  @override
  String get settingsAboutOfferQuranTajweedTitle => 'Al Quran Tajweed';

  @override
  String get settingsAboutOfferQuranTajweedSubtitle =>
      'Read, listen, and practice Tajweed with our AI-powered real-time feedback.';

  @override
  String get settingsAboutOfferLiveActivitiesTitle => 'Live Activities';

  @override
  String get settingsAboutOfferLiveActivitiesSubtitle =>
      'Stay updated with ongoing prayers and focus sessions right from your Lock Screen.';

  @override
  String get settingsAboutOfferQiblaTitle => 'Qibla & Masjid Finder';

  @override
  String get settingsAboutOfferQiblaSubtitle =>
      'Find Qibla direction anytime and discover nearby mosques wherever you are.';

  @override
  String get settingsAboutOfferFocusModesTitle => 'Focus Modes';

  @override
  String get settingsAboutOfferFocusModesSubtitle =>
      'Block distracting apps during Salah, sleep, study, or family time.';

  @override
  String get settingsAboutOfferTasbihTitle => 'Tasbih & Dhikr';

  @override
  String get settingsAboutOfferTasbihSubtitle =>
      'Digital Tasbih to help you remember Allah throughout the day.';

  @override
  String get settingsAboutOfferCalendarTitle => 'Islamic Calendar';

  @override
  String get settingsAboutOfferCalendarSubtitle =>
      'Hijri calendar with important Islamic dates and reminders.';

  @override
  String get settingsAboutGridNamesTitle => '99 Names of Allah';

  @override
  String get settingsAboutGridNamesSubtitle =>
      'Learn and reflect on Asma ul-Husna.';

  @override
  String get settingsAboutGridDuasTitle => 'Duas & Adhkar';

  @override
  String get settingsAboutGridDuasSubtitle =>
      'Morning, evening and daily duas.';

  @override
  String get settingsAboutGridPrayerTitle => 'Prayer & Methods';

  @override
  String get settingsAboutGridPrayerSubtitle =>
      'Learn Salah, Wudu, Hajj and more.';

  @override
  String get settingsAboutGridFiqhTitle => 'Fiqh & Traditions';

  @override
  String get settingsAboutGridFiqhSubtitle =>
      'Explore authentic Islamic knowledge.';

  @override
  String get settingsEnableSystemNotifications =>
      'Enable system notifications to turn this on.';

  @override
  String get appDemoTitle => 'App Demo';

  @override
  String get appDemoLoadFailed => 'Could not load the demo video.';

  @override
  String get appDemoRestartHint =>
      'Video needs a full app restart (hot restart can break playback).';

  @override
  String get appDemoPreviewLoadFailed => 'Could not load the demo.';

  @override
  String get appDemoTryAgain => 'Try again';

  @override
  String get appDemoWatchLabel => 'Watch demo';

  @override
  String get homeAiChatTitle => 'Deen Focus AI';

  @override
  String get homeAiAskQuestionHint => 'Ask a question...';

  @override
  String get homeAiSend => 'Send';

  @override
  String get homeAiErrorPrefix =>
      'Sorry, I ran into an issue while connecting to Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Ask anything about Islam';

  @override
  String get homeAiEmptySubtitle =>
      'Prayer times, Quran, Hadith, Islamic events, and spiritual guidance';

  @override
  String get onboardingTypeCityName => 'Type your city name..';

  @override
  String get onboardingNoLocationsFound => 'No locations found';

  @override
  String get onboardingTryAnotherCityName => 'Try another city name.';

  @override
  String get qiblaCompassUnavailable => 'Compass unavailable on this device';

  @override
  String get qiblaFacing => '✓ Facing Qibla';

  @override
  String get qiblaTurnToFind => 'Turn to find Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Distance to Makkah';

  @override
  String get qiblaFromNorth => 'from North';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Mosques found nearby';

  @override
  String get nearbyMosquesTryAgain => 'Try again';

  @override
  String get nearbyMosquesOpenGoogle => 'Open in Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Open in Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin => 'No mosques found within';

  @override
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Search radius: $radiusKm km';
  }

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Map preview unavailable right now.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Waiting for your location.';

  @override
  String get nearbyMosquesFetchingLocation => 'Fetching your location…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Current location';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Nearby mosques will appear here once results load.';

  @override
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'No mosques found within $radiusKm km';
  }

  @override
  String get nearbyMosquesLocationRequired =>
      'Location access is required to find nearby mosques.';

  @override
  String get nearbyMosquesPermissionOff =>
      'Location permission is turned off. Enable it in settings to see nearby mosques.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'We could not read your current location right now.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'Live update failed. Showing last saved results. Pull to refresh.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Location access was denied. Enable it in Settings to see nearby mosques.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'Location is turned off on this device. Turn it on in Settings, then try again.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'Location permission is still being processed. Please try again in a moment.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'The request took too long. Check your internet connection and try again.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'No internet connection or the service is unreachable. Check your connection and try again.';

  @override
  String get nearbyMosquesFormatError =>
      'We could not read the mosque list right now. Please try again later.';

  @override
  String get nearbyMosquesPlatformError =>
      'We could not complete that step. Check your connection and try again.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Something went wrong. Please try again.';

  @override
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'Nothing listed within $radiusKm km on OpenStreetMap for this spot. Try again later or move farther.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count mosques found within $radiusKm km';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count mosques nearby';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'Within $radiusKm km · Sorted by distance';
  }

  @override
  String get nearbyMosquesDirections => 'Directions';

  @override
  String get tasbihDeleteDhikrTitle => 'Delete dhikr?';

  @override
  String get tasbihDelete => 'Delete';

  @override
  String get focusAndroidBlockingNotReady =>
      'Android app blocking is still getting ready. Keep accessibility enabled and give it a moment to connect.';

  @override
  String get focusNoAppsSelectedSnack =>
      'No apps selected. Please select apps to block first.';

  @override
  String get focusDiagnosticButton => 'Diagnostic';

  @override
  String get focusDiagnosticTitle => 'Test App Lock';

  @override
  String get focusDiagnosticIntro =>
      'Temporarily lock your selected apps for 60 seconds using the same App Lock used by Focus mode. Open a blocked app to confirm the DeenFocus lock screen appears.';

  @override
  String focusDiagnosticIntroWithApp(String appName) {
    return 'Temporarily lock your selected apps for 60 seconds. Try opening $appName to confirm the DeenFocus lock screen appears.';
  }

  @override
  String get focusDiagnosticStart => 'Start Test';

  @override
  String get focusDiagnosticEndEarly => 'End Test';

  @override
  String focusDiagnosticRunning(int seconds) {
    return 'App Lock is on for ${seconds}s. Switch to a selected app to test the lock screen.';
  }

  @override
  String get focusDiagnosticSuccessTitle => 'Test completed';

  @override
  String get focusDiagnosticSuccessBody =>
      'App Lock was activated with your selected apps. If you saw the DeenFocus lock screen, App Lock is working.';

  @override
  String get focusDiagnosticCancelledTitle => 'Test ended';

  @override
  String get focusDiagnosticCancelledBody =>
      'The diagnostic lock was turned off. Your Focus modes and schedules were not changed.';

  @override
  String get focusDiagnosticMissingAppsTitle => 'Select apps first';

  @override
  String get focusDiagnosticMissingAppsBody =>
      'Choose at least one app to block before running the App Lock test.';

  @override
  String get focusDiagnosticMissingPermissionTitle => 'Permission needed';

  @override
  String get focusDiagnosticMissingPermissionBodyIos =>
      'Screen Time access is required to block apps. Allow Screen Time, then try again.';

  @override
  String get focusDiagnosticMissingPermissionBodyAndroid =>
      'Android Accessibility must be enabled for DeenFocus so App Lock can block selected apps.';

  @override
  String get focusDiagnosticFailedTitle => 'Could not start test';

  @override
  String get focusDiagnosticFailedBody =>
      'App Lock did not activate. Check permissions and selected apps, then try again.';

  @override
  String get focusDiagnosticClose => 'Done';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Screen Time access is required to block apps on iPhone.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Something went wrong while updating Focus mode. Please try again.';

  @override
  String get focusLoadingInstalledApps => 'Loading installed apps...';

  @override
  String get focusNoInstalledAppsToShow =>
      'No installed apps available to show.';

  @override
  String get homeAiSuggestion1 => 'What is Ramadan?';

  @override
  String get homeAiSuggestion2 => 'Prayer times';

  @override
  String get homeAiSuggestion3 => 'Quran reading plan';

  @override
  String get homeAiDeveloperPrompt =>
      'You are a knowledgeable and respectful Islamic scholar assistant. Help users learn about Islamic traditions, holidays, prayers, Quran study, and spiritual practices. Be warm, concise, educational, and culturally sensitive. If the user asks something outside Islamic guidance, answer helpfully without pretending religious certainty.';

  @override
  String get homeAiErrorMissingApiKey => 'Missing API configuration.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'API error $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse =>
      'No response returned from the assistant.';

  @override
  String get homeAiErrorEmptyContent => 'Empty response content.';

  @override
  String get settingsPrayerCalculationSection => 'Prayer Calculation';

  @override
  String get settingsCalculationMethodTitle => 'Calculation Method';

  @override
  String get settingsAsrCalculationTitle => 'Asr Calculation';

  @override
  String get calculationMethodSectionMajorOrgs => 'Major Islamic Organizations';

  @override
  String get calculationMethodSectionMiddleEast => 'Middle East';

  @override
  String get calculationMethodSectionAsiaPacific => 'Asia Pacific';

  @override
  String get calculationMethodSectionSpecial => 'Special Methods';

  @override
  String get asrMethodStandard => 'Standard';

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
  String insightsChipUpToday(int count) {
    return '↑ $count';
  }

  @override
  String get insightsChipDayUp => '↑ 1 today';

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
    return 'You completed $done out of $possible prayers.\nAlhamdulillah — keep going!';
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
  String get insightsMyProgress => 'My progress';

  @override
  String insightsLevelNumber(int level) {
    return 'Level $level';
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
    return '$xp XP to Level $level';
  }

  @override
  String get insightsMaxLevel => 'MAX LEVEL';

  @override
  String insightsAchievementsUnlocked(int unlocked, int total) {
    return '$unlocked / $total unlocked';
  }

  @override
  String get insightsAchievementUnlockedTitle => 'Achievement Unlocked';

  @override
  String get insightsLevelUpTitle => 'LEVEL UP';

  @override
  String get achievementFirstPrayer => 'First Prayer';

  @override
  String get achievementFajrChampion => 'Fajr Champion';

  @override
  String get achievementFiveADay => 'Five-a-Day';

  @override
  String get achievementPerfectWeek => 'Perfect Week';

  @override
  String get achievementPerfectMonth => 'Perfect Month';

  @override
  String get achievementQuranDevotee => 'Quran Devotee';

  @override
  String get achievementDhikrStarter => 'Dhikr Starter';

  @override
  String get achievementNightWorshipper => 'Night Worshipper';

  @override
  String get achievementMasjidCompanion => 'Masjid Companion';

  @override
  String get achievementDistractionDefender => 'Distraction Defender';

  @override
  String get achievementCycleGuardian => 'Cycle Guardian';

  @override
  String get achievementProtectedMonth => 'Protected Month';

  @override
  String get achievementSixMonthJourney => 'Six-Month Journey';

  @override
  String get achievementDeenFocusMaster => 'DeenFocus Master';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Cycle Mode days are protected and not counted as streak breaks. You have $days protected day(s) available.';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Enable Cycle Mode to protect your streak during rest days.';

  @override
  String get achievementFirstPrayerStreak => 'First Prayer';

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

  @override
  String get weekdayLetterMon => 'M';

  @override
  String get weekdayLetterTue => 'T';

  @override
  String get weekdayLetterWed => 'W';

  @override
  String get weekdayLetterThu => 'T';

  @override
  String get weekdayLetterFri => 'F';

  @override
  String get weekdayLetterSat => 'S';

  @override
  String get weekdayLetterSun => 'S';

  @override
  String get focusHomeBlockingNightAndSalah =>
      'Night Discipline and Salah mode are blocking selected apps.';

  @override
  String get focusHomeBlockingNight =>
      'Night Discipline is blocking selected apps.';

  @override
  String get focusHomeBlockingSalah => 'Salah mode is blocking selected apps.';

  @override
  String get focusHomeAppsBlockedNow => 'Selected apps are blocked right now.';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode is enabled.';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes are enabled.';
  }

  @override
  String get focusHomeChooseMode => 'Choose a mode to protect your attention.';

  @override
  String get focusStatusSelectApps => 'Select apps to start';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Night Discipline and Salah mode are blocking apps now';

  @override
  String get focusStatusBlockingNight =>
      'Night Discipline is blocking apps now';

  @override
  String get focusStatusBlockingSalah => 'Salah mode is blocking apps now';

  @override
  String get focusStatusAppsLocked => 'Apps are locked now';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Unlocked until $time';
  }

  @override
  String get focusStatusNoMode => 'No focus mode enabled';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Ready to lock $targets';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String get appLockDemoIntroTitle => 'See how App Lock works';

  @override
  String get appLockDemoIntroSubtitle =>
      'Stay in DeenFocus. On the next screen, tap Instagram to see it pause at prayer time.';

  @override
  String get appLockDemoStartButton => 'Start the demo';

  @override
  String get appLockDemoTryOpeningApp => 'Try opening Instagram';

  @override
  String get appLockDemoSalahModeBadge => 'SALAH MODE';

  @override
  String get appLockDemoTimeToPray => 'It’s time to pray';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Remaining time: $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'I’ve prayed $prayerName';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName completed';
  }

  @override
  String get appLockDemoStreakIncreased => 'Your prayer streak increased';

  @override
  String get appLockDemoPrayerStreakLabel => 'PRAYER STREAK';

  @override
  String get appLockDemoDayStreakLabel => 'DAY STREAK';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Next prayer in $minutes minutes';
  }

  @override
  String get appLockDemoStreakMotivation =>
      'Keep going! Your consistency brings you closer to Allah.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Pray. Check in once.\nGet back to your day.';

  @override
  String get appLockDemoCompletionBody =>
      'App Lock gently pauses selected apps during Salah so you can focus on prayer — then continue when you’re ready.';

  @override
  String get appLockDemoContinueSetup => 'Continue setup';

  @override
  String get appLockDemoAppMessages => 'Messages';

  @override
  String get appLockDemoAppCalendar => 'Calendar';

  @override
  String get appLockDemoAppPhotos => 'Photos';

  @override
  String get appLockDemoAppCamera => 'Camera';

  @override
  String get appLockDemoAppMail => 'Mail';

  @override
  String get appLockDemoAppMaps => 'Maps';

  @override
  String get appLockDemoAppWeather => 'Weather';

  @override
  String get appLockDemoAppClock => 'Clock';

  @override
  String get appLockDemoAppNotes => 'Notes';

  @override
  String get appLockDemoAppSettings => 'Settings';

  @override
  String get appLockDemoAppMusic => 'Music';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Prayer Updates';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live Activity for your next prayer on the Lock Screen';

  @override
  String get liveActivitySectionTitle => 'Live Activities';

  @override
  String get liveActivityStayUpdatedTitle => 'Stay updated at a glance';

  @override
  String get liveActivityStayUpdatedBody =>
      'See your next prayer and its time directly on your Lock Screen.';

  @override
  String get liveActivityEnableLabel => 'Enable Live Activity';

  @override
  String get liveActivityPromptNotNow => 'Not now';

  @override
  String get liveActivityUnsupported =>
      'Live Activities are not available on this device.';

  @override
  String get liveActivityPermissionNeeded =>
      'Allow notifications so prayer updates can appear on your Lock Screen.';

  @override
  String get liveActivityPermissionButton => 'Allow notifications';

  @override
  String get liveActivityStatusActive => 'Live Activity is on';

  @override
  String get liveActivityStatusOff => 'Live Activity is off';

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
  String get liveActivityNowLabel => 'Now';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Updated at $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer at $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Prayer Alarms';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Full prayer alarms that can break through Silent Mode';

  @override
  String get prayerAlarmsMasterLabel => 'Enable Prayer Alarms';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Schedule a native alarm for each selected prayer';

  @override
  String get prayerAlarmsSnoozeLabel => 'Snooze duration';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Alarms by prayer';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Allow alarm permission so prayer alarms can fire on time.';

  @override
  String get prayerAlarmsPermissionButton => 'Allow alarms';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Allow full-screen alarms so they can appear over the lock screen. Without this, alarms still notify as a banner.';

  @override
  String get prayerAlarmsFsiButton => 'Full-screen settings';

  @override
  String get prayerAlarmsUnsupported =>
      'Native prayer alarms are not available on this device. Soft prayer notifications still work.';

  @override
  String get prayerAlarmsIosFallback =>
      'On this iOS version, soft prayer notifications are used instead of AlarmKit.';

  @override
  String get prayerAlarmsDeniedTitle => 'Alarm permission required';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Prayer Alarms stay off until you allow alarm permission. Soft prayer notifications are unaffected.';

  @override
  String get prayerAlarmsOpenSettings => 'Open Settings';

  @override
  String get prayerAlarmsStatusReady => 'Alarms are ready to schedule';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Permission needed — alarms are not active';

  @override
  String get prayerAlarmsStatusFallback =>
      'Using soft notifications on this device';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Alarms are on. Enable full-screen for lock-screen takeover.';

  @override
  String get prayerAlarmsCancel => 'Not now';

  @override
  String get homePrayerAlarmEnableLabel => 'Prayer Alarm';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Ring a native alarm at $prayerName';
  }

  @override
  String get prayerAlarmBadge => 'Prayer Alarm';

  @override
  String get prayerAlarmSubtitle => 'Time to Pray';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — Time to Pray';
  }

  @override
  String get prayerAlarmIvePrayed => 'I\'ve Prayed';

  @override
  String get prayerAlarmDismiss => 'Dismiss';

  @override
  String get prayerAlarmSnooze => 'Snooze';

  @override
  String get appLockDemoAppPhone => 'Phone';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Reminders';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Books';

  @override
  String get appLockDemoAppHealth => 'Health';

  @override
  String get appLockDemoAppWallet => 'Wallet';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'App Demo';

  @override
  String get settingsAppDemoChooseModeTitle => 'Experience App Lock';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Choose a Focus Mode and see how selected apps pause — without leaving DeenFocus.';

  @override
  String get appLockDemoDone => 'Done';

  @override
  String get appLockDemoSleepIntroTitle => 'See how Sleep Mode works';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Stay in DeenFocus. On the next screen, tap Instagram to see it pause at bedtime.';

  @override
  String get appLockDemoSleepModeBadge => 'SLEEP MODE';

  @override
  String get appLockDemoSleepLockTitle => 'Time to wind down';

  @override
  String get appLockDemoSleepLockCta => 'I’m ready to rest';

  @override
  String get appLockDemoSleepCompleted => 'Sleep Mode protected';

  @override
  String get appLockDemoSleepRewardSubtitle =>
      'Your night protection increased';

  @override
  String get appLockDemoSleepStreakLabel => 'NIGHT STREAK';

  @override
  String get appLockDemoSleepRewardFooter => 'Fajr reminder set for morning';

  @override
  String get appLockDemoSleepMotivation =>
      'Rest well tonight so you can rise for Fajr with energy.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Quiet nights.\nClear mornings.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'Sleep Mode gently pauses selected apps at night so you can rest — then continue when you’re ready.';

  @override
  String get appLockDemoChildIntroTitle => 'See how Child Mode works';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Stay in DeenFocus. On the next screen, tap Instagram to see it lock when Child Mode is on.';

  @override
  String get appLockDemoChildModeBadge => 'CHILD MODE';

  @override
  String get appLockDemoChildLockTitle => 'Apps are protected';

  @override
  String get appLockDemoChildLockDetail =>
      'Selected apps stay locked while Child Mode is on';

  @override
  String get appLockDemoChildLockCta => 'Got it';

  @override
  String get appLockDemoChildCompleted => 'Child Mode active';

  @override
  String get appLockDemoChildRewardSubtitle =>
      'Your protection streak increased';

  @override
  String get appLockDemoChildStreakLabel => 'SAFE STREAK';

  @override
  String get appLockDemoChildRewardFooter => 'Exit anytime with your passcode';

  @override
  String get appLockDemoChildMotivation =>
      'Peace of mind every time you hand over your phone.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'One tap safe mode.\nOnly what you allow.';

  @override
  String get appLockDemoChildCompletionBody =>
      'Child Mode locks selected apps so your child only sees what’s safe — then you unlock when you’re ready.';

  @override
  String get appLockDemoSleepCompletionTitle => 'Rest well tonight';

  @override
  String get appLockDemoChildCompletionTitle => 'Peace of mind';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Pause distractions at Salah so you can pray with presence.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Protect your nights so rest comes easier — and Fajr feels lighter.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Hand over your phone knowing only allowed apps stay open.';

  @override
  String get settingsAppDemoHomeFeaturesTitle => 'Stay connected at a glance';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'See how Home Screen widgets and Live Activity keep prayer times close — without opening the app.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Daily verse and prayer times on your Home Screen, always up to date.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Current and next prayer on your Lock Screen and Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Recite an ayah and get instant tajweed feedback.';

  @override
  String get featureDemoTajweedTitle => 'Tajweed';

  @override
  String get featureDemoTajweedIntroTitle => 'See how Tajweed practice works';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Stay in DeenFocus. Open Tajweed drill, recite an ayah, and see word-by-word feedback.';

  @override
  String get featureDemoTajweedQuranCallout => 'Tap Tajweed drill to start';

  @override
  String get featureDemoTajweedLegendCallout =>
      'Color highlights show tajweed rules as you read';

  @override
  String get featureDemoTajweedReciteCallout => 'Tap Recite & check tajweed';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'One-time download so practice works offline';

  @override
  String get featureDemoTajweedMicCallout => 'Tap the mic and start reciting';

  @override
  String get featureDemoTajweedResultCallout =>
      'See which words were correct, missed, or need work';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tajweed, ready';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Recite with confidence, anytime.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Open Quran → Tajweed drill to practice any ayah with on-device scoring — fully offline after the first download.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 verses • Meccan';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 verses • Medinan';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => 'Al-Fatihah • 7 verses';

  @override
  String get featureDemoTajweedSurahMeta => 'SURAH 1 • MECCAN';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'In the name of Allah, the Entirely Merciful, the Especially Merciful.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatihah · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'Preparing AI model';

  @override
  String get featureDemoTajweedPreparingBody =>
      'One-time download so Tajweed practice works fully offline afterwards. This only happens once.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Keep practicing — listen to the reference and try again.';

  @override
  String get featureDemoTajweedStatCorrect => 'Correct';

  @override
  String get featureDemoTajweedStatPronunciation => 'Pronunciation';

  @override
  String get featureDemoTajweedStatWrong => 'Wrong word';

  @override
  String get featureDemoTajweedStatMissed => 'Missed';

  @override
  String get featureDemoTajweedStatExtra => 'Extra';

  @override
  String get featureDemoContinue => 'Continue';

  @override
  String get featureDemoSampleStatusTime => '9:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      'Your device doesn’t allow apps to place widgets automatically. Add the Large DeenFocus widget from your Home Screen widget gallery.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Add the widget from your Home Screen';

  @override
  String get featureDemoOfferNo => 'No';

  @override
  String get featureDemoOfferYes => 'Yes';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      'Want to enable Live Activity on your device?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      'Want to add this widget to your Home Screen?';

  @override
  String get featureDemoWidgetsTitle => 'Widgets';

  @override
  String get featureDemoWidgetsIntroTitle => 'See your Home Screen widgets';

  @override
  String get featureDemoWidgetsIntroSubtitle =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsShowcaseCallout =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsDetailsTitle => 'Glanceable prayer guidance';

  @override
  String get featureDemoWidgetsDetailsBody =>
      'Your Medium widget shows today’s verse and all five prayer times — refreshed when you open DeenFocus.';

  @override
  String get featureDemoWidgetsCompletionTitle => 'Widgets, ready';

  @override
  String get featureDemoWidgetsCompletionSubtitle =>
      'Faith reminders on your Home Screen.';

  @override
  String get featureDemoWidgetsCompletionBody =>
      'Add DeenFocus widgets from your phone’s widget gallery after this demo — then open the app once to sync.';

  @override
  String get featureDemoWidgetsHomeHint => 'Wednesday, 13 August';

  @override
  String get featureDemoWidgetSampleDate => 'Wed, Aug 13';

  @override
  String get featureDemoWidgetSampleVerse =>
      'It is You we worship and You we ask for help.';

  @override
  String get featureDemoWidgetSampleSource => 'Surah 1:5';

  @override
  String get featureDemoLiveActivityTitle => 'Live Activity';

  @override
  String get featureDemoLiveActivityIntroTitle => 'See Live Activity in action';

  @override
  String get featureDemoLiveActivityIntroSubtitle =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityShowcaseCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveActivityDetailsTitle =>
      'Prayer updates, always visible';

  @override
  String get featureDemoLiveActivityDetailsBody =>
      'Live Activity keeps Maghrib, Isha, and the countdown close on your Lock Screen — turn it on in Settings anytime.';

  @override
  String get featureDemoLiveActivityCompletionTitle => 'Live Activity, ready';

  @override
  String get featureDemoLiveActivityCompletionSubtitle =>
      'Next prayer, always nearby.';

  @override
  String get featureDemoLiveActivityCompletionBody =>
      'Enable Live Activity in Settings → Prayer Calculation to show prayer updates on your Lock Screen.';

  @override
  String get featureDemoLiveActivityLockHint => 'Wednesday, 13 August';

  @override
  String get featureDemoLiveActivitySampleTime => '6:48 PM';

  @override
  String get featureDemoLiveActivitySampleNextTime => '8:11 PM';

  @override
  String get featureDemoWidgetsIntroSubtitleIos =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsIntroSubtitleAndroid =>
      'Stay in DeenFocus. Long-press the Home Screen, open the widget picker, and try all three sizes.';

  @override
  String get featureDemoWidgetsLongPressCalloutIos =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsLongPressCalloutAndroid =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsAddCallout =>
      'Tap + to choose a DeenFocus widget';

  @override
  String get featureDemoWidgetsAddSlotLabel => 'Add Widget';

  @override
  String get featureDemoWidgetsGalleryTitle => 'Choose a DeenFocus widget';

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
  String get featureDemoWidgetSizeSmall => 'Small';

  @override
  String get featureDemoWidgetSizeMedium => 'Medium';

  @override
  String get featureDemoWidgetSizeLarge => 'Large';

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
  String get featureDemoLiveOpenPrayerCalcCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveEnableToggleCallout =>
      'Turn on Enable Live Activity';

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
  String get featureDemoAndroidOpenShadeCta => 'Open notification shade';

  @override
  String get featureDemoAndroidShadeTitle => 'Notification shade';

  @override
  String get featureDemoAndroidShadeCallout =>
      'Expand to see the full current and next prayer status';

  @override
  String get featureDemoAndroidOngoingBadge => 'Ongoing';

  @override
  String get appLockDemoOfferPrayerTitle => 'Ready to try Prayer Mode?';

  @override
  String get appLockDemoOfferSleepTitle => 'Ready to try Sleep Mode?';

  @override
  String get appLockDemoOfferChildTitle => 'Ready to try Child Mode?';

  @override
  String get appLockDemoOfferPrayerCta => 'Enable Prayer Mode';

  @override
  String get appLockDemoOfferSleepCta => 'Enable Sleep Mode';

  @override
  String get appLockDemoOfferChildCta => 'Enable Child Mode';

  @override
  String get appLockDemoOfferNotNow => 'Not now';

  @override
  String get nightlyWrapUpPrayersTitle => 'Finish today\'s prayers';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Mark any unfinished or missed prayers to protect your Prayer Streak.';

  @override
  String get nightlyWrapUpChecklistTitle => 'Complete your Daily Checklist';

  @override
  String get nightlyWrapUpChecklistBody =>
      'A few checklist items are still open — wrap up your day with intention.';

  @override
  String get nightlyWrapUpBothTitle => 'Wrap up your day';

  @override
  String get nightlyWrapUpBothBody =>
      'Mark remaining prayers and finish your Daily Checklist before the day ends.';

  @override
  String get cycleModeEndedNotificationTitle => 'Cycle Mode has ended';

  @override
  String get cycleModeEndedNotificationBody =>
      'Your Cycle Mode is now off. You can resume praying. If you want to change your Cycle Mode dates, tap here to edit them.';

  @override
  String get libraryHomeTitle => 'Islamic Library';

  @override
  String get libraryHomeSubtitle =>
      'Learn Hadith, duas, the 99 Names, and more';

  @override
  String get libraryHubTitle => 'Islamic Library';

  @override
  String get libraryModuleQuran => 'Quran';

  @override
  String get libraryModuleQuranSub => 'Read, listen, and practice tajweed';

  @override
  String get libraryModuleHadith => 'Hadith';

  @override
  String get libraryModuleHadithSub => 'Collections from authentic sources';

  @override
  String get libraryModuleDuas => 'Duas & Adhkar';

  @override
  String get libraryModuleDuasSub => 'Morning, evening, and daily remembrance';

  @override
  String get libraryModulePrayerMethods => 'Prayer & Islamic Methods';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, salah, hajj, and more';

  @override
  String get libraryModuleFiqh => 'Fiqh & Traditions';

  @override
  String get libraryModuleFiqhSub =>
      'Sunni, Shia, madhabs, Ahl-e Hadith, and more';

  @override
  String get libraryModuleNames => '99 Names of Allah';

  @override
  String get libraryModuleNamesSub => 'Learn and reflect on Asma ul-Husna';

  @override
  String get libraryModulePillarsIslam => 'Pillars of Islam';

  @override
  String get libraryModulePillarsIslamSub =>
      'The five foundations of faith in action';

  @override
  String get libraryModulePillarsIman => 'Pillars of Iman';

  @override
  String get libraryModulePillarsImanSub => 'The six articles of belief';

  @override
  String get libraryModuleProphets => 'Prophet Muhammad';

  @override
  String get libraryModuleProphetsSub =>
      'His life, mission, and timeless lessons';

  @override
  String get libraryModuleOccasions => 'Islamic Occasions';

  @override
  String get libraryModuleOccasionsSub => 'Ramadan, Eid, Hajj, and sacred days';

  @override
  String get libraryKeyLesson => 'Key lesson';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get libraryPrevious => 'Previous';

  @override
  String get libraryNext => 'Next';

  @override
  String get libraryBookmark => 'Bookmark';

  @override
  String get libraryCopy => 'Copy';

  @override
  String get libraryShare => 'Share';

  @override
  String get libraryCopied => 'Copied to clipboard';

  @override
  String get libraryShareCopiedHint => 'Copied — paste to share';

  @override
  String get libraryShareReference => 'Reference';

  @override
  String get contentShareIntro =>
      'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍';

  @override
  String get contentShareExplore => 'Explore DeenFocus:';

  @override
  String get contentShareFailed =>
      'Couldn’t share right now. Please try again.';

  @override
  String get libraryBookmarkSaved => 'Bookmark saved';

  @override
  String get libraryBookmarkRemoved => 'Bookmark removed';

  @override
  String get libraryTranslation => 'Translation';

  @override
  String get libraryTransliteration => 'Transliteration';

  @override
  String get libraryMeaning => 'Meaning';

  @override
  String get libraryBookmarksTitle => 'Saved learning items';

  @override
  String get libraryBookmarksSubtitle => 'Hadith, duas, names, fiqh, and more';

  @override
  String get libraryBookmarksEmpty =>
      'No saved items yet. Tap Bookmark on any learning item to save it here.';

  @override
  String get libraryMarkCompleted => 'Mark completed';

  @override
  String get librarySectionCompleted => 'Completed';

  @override
  String get libraryReflection => 'Reflection';

  @override
  String get libraryComingSoonTitle => 'Coming soon';

  @override
  String get libraryComingSoonBody =>
      'This module is being prepared. Check back in a future update.';

  @override
  String get librarySearchHint => 'Search…';

  @override
  String get libraryHubSearchHint => 'Search Learning…';

  @override
  String get libraryHubSearchSections => 'Sections';

  @override
  String get libraryHubSearchTopics => 'Topics';

  @override
  String get librarySearchEmpty => 'No matching items';

  @override
  String libraryItemCount(int count) {
    return '$count items';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown of $total';
  }

  @override
  String libraryContinueFrom(int number) {
    return 'Continue · $number';
  }

  @override
  String get libraryInProgress => 'In progress';

  @override
  String libraryReference(String source) {
    return 'Reference: $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count duas';
  }

  @override
  String get libraryDuaCategoryMorning => 'Morning';

  @override
  String get libraryDuaCategoryEvening => 'Evening';

  @override
  String get libraryDuaCategoryDailyLife => 'Daily Life';

  @override
  String get libraryDuaCategorySleep => 'Sleep';

  @override
  String get libraryDuaCategoryFood => 'Food';

  @override
  String get libraryDuaCategoryTravel => 'Travel';

  @override
  String get libraryDuaCategoryIllness => 'Illness';

  @override
  String get libraryDuaCategoryProtection => 'Protection';

  @override
  String get libraryDuaCategoryForgiveness => 'Forgiveness';

  @override
  String get libraryDuaCategoryParents => 'Parents';

  @override
  String libraryHadithCount(int count) {
    return '$count hadith';
  }

  @override
  String get libraryHadithNarrator => 'Narrator:';

  @override
  String get libraryHadithSource => 'Source:';

  @override
  String get libraryHadithCollectionBukhari => 'Sahih al-Bukhari';

  @override
  String get libraryHadithCollectionMuslim => 'Sahih Muslim';

  @override
  String get libraryHadithCollectionRiyad => 'Riyad us-Saliheen';

  @override
  String get libraryHadithCollectionNawawi => '40 Hadith Nawawi';

  @override
  String get libraryHadithCollectionHisnul => 'Hisnul Muslim';

  @override
  String libraryGuideStepCount(int count) {
    return '$count steps';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Step $current of $total';
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
  String get libraryGuideJanazah => 'Janazah Prayer';

  @override
  String get libraryGuideUmrah => 'Umrah';

  @override
  String get libraryGuideHajj => 'Hajj';

  @override
  String get libraryGuideFasting => 'Fasting';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawbah';

  @override
  String get libraryOccasionImportance => 'Importance';

  @override
  String get libraryOccasionVirtues => 'Virtues';

  @override
  String get libraryOccasionRecommendedActs => 'Recommended acts';

  @override
  String get libraryFiqhOverview => 'Overview';

  @override
  String get libraryFiqhKeyPoints => 'Key points';

  @override
  String get libraryFiqhDifferences => 'Notable differences';

  @override
  String get libraryFiqhCommonGround => 'Common ground';

  @override
  String get insightsCompleted => 'Completed';

  @override
  String get insightsInProgress => 'In Progress';

  @override
  String get insightsKeepGoingTitle => 'Keep going!';

  @override
  String get insightsKeepGoingBody =>
      'You\'re making great progress. Every prayer counts.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Achievements Unlocked';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer => 'Prayed your first prayer.';

  @override
  String get achievementDescSevenPrayerStreak => 'Complete 7 prayers in a row.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Complete 30 prayers in a row.';

  @override
  String get achievementDescFajrWarrior => 'Pray Fajr on 14 days.';

  @override
  String get achievementDescFajrChampion => 'Pray Fajr on 30 days.';

  @override
  String get achievementDescFiveADay => 'Complete all five prayers in one day.';

  @override
  String get achievementDescPerfectWeek =>
      'Complete every prayer for 7 days in a row.';

  @override
  String get achievementDescPerfectMonth =>
      'Complete every prayer for 30 days in a row.';

  @override
  String get achievementDescQuranReader => 'Read Quran on 7 days.';

  @override
  String get achievementDescQuranDevotee => 'Read Quran on 30 days.';

  @override
  String get achievementDescDhikrStarter => 'Complete dhikr on 7 days.';

  @override
  String get achievementDescDhikrMaster => 'Complete dhikr on 30 days.';

  @override
  String get achievementDescNightWorshipper => 'Pray Tahajjud on 7 days.';

  @override
  String get achievementDescMasjidCompanion => 'Visit the masjid 7 times.';

  @override
  String get achievementDescDistractionDefender =>
      'Stay distraction-free for 7 days.';

  @override
  String get achievementDescCycleGuardian =>
      'Protect your streak with Cycle Mode for 7 days.';

  @override
  String get achievementDescProtectedMonth =>
      'Protect your streak with Cycle Mode for 30 days.';

  @override
  String get achievementDescConsistencyChampion =>
      'Stay consistent for 100 days.';

  @override
  String get achievementDescSixMonthJourney => 'Keep going for 180 days.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Reach DeenFocus Master (Level 15).';

  @override
  String get dailyChecklistOptional => 'Optional';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Control anger / Speak kindly';

  @override
  String get digitalBalanceTitle => 'Digital Balance';

  @override
  String get digitalBalanceSubtitle => 'See where your time is going';

  @override
  String get digitalBalanceViewCta => 'View Digital Balance →';

  @override
  String get digitalBalanceTodayLabel => 'Today';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Other apps';

  @override
  String get digitalBalanceTodayPhoneTime => 'Today\'s Phone Time';

  @override
  String get digitalBalanceWhereTimeGoes => 'Where Your Time Goes';

  @override
  String get digitalBalanceViewAllApps => 'View All Apps';

  @override
  String get digitalBalanceAllAppsTitle => 'All Apps';

  @override
  String get digitalBalanceNoApps => 'No app usage recorded for today yet.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen vs. Digital Time';

  @override
  String get digitalBalanceYourWeek => 'Your Week';

  @override
  String get digitalBalanceThisWeek => 'This week';

  @override
  String get digitalBalancePhoneUsageLegend => 'Phone usage';

  @override
  String get digitalBalanceDailyInsight => 'Daily Insight';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Every minute spent strengthening your Deen matters.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'Your DeenFocus time is higher this week than last week. MashaAllah!';

  @override
  String get digitalBalanceInsightQuietDay =>
      'A quiet day so far. Time in DeenFocus will appear here.';

  @override
  String get digitalBalanceGoalTitle => 'Your Deen Time Goal';

  @override
  String get digitalBalanceAdjustGoal => 'Adjust Goal';

  @override
  String get digitalBalanceGoalReached =>
      'You reached today\'s Deen time goal. MashaAllah!';

  @override
  String get digitalBalanceGoalSheetTitle => 'Daily Deen time';

  @override
  String get digitalBalanceGoalCustomHint => 'Minutes per day';

  @override
  String get digitalBalanceGoalSave => 'Save';

  @override
  String get digitalBalanceGoal15 => '15 min';

  @override
  String get digitalBalanceGoal30 => '30 min';

  @override
  String get digitalBalanceGoal45 => '45 min';

  @override
  String get digitalBalanceGoal60 => '1 hour';

  @override
  String get digitalBalancePermissionTitle => 'Understand Your Digital Habits';

  @override
  String get digitalBalancePermissionBody =>
      'Allow DeenFocus to access your app usage information so you can see where your time goes and how much time you\'re giving to your Deen.';

  @override
  String get digitalBalanceEnableUsage => 'Enable App Usage';

  @override
  String get digitalBalanceMaybeLater => 'Maybe Later';

  @override
  String get digitalBalanceUnavailableTitle =>
      'App usage isn\'t available here';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple does not let DeenFocus read other apps\' Screen Time on this iPhone, so Digital Balance cannot show usage totals yet. Your prayers, streaks, Focus blocking, and DeenFocus insights still work as usual.';

  @override
  String get digitalBalanceInfoTitle => 'About Digital Balance';

  @override
  String get digitalBalanceInfoBody =>
      'Digital Balance helps you see where your time is going and how much of it you\'re giving to your Deen. Usage stays on your device.';

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
    return 'DeenFocus · $percent% of phone time';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% of your phone time';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% of today\'s phone time';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% more DeenFocus time than last week';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'You spent $duration in DeenFocus today. Keep building the habit.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'Your DeenFocus time increased by $percent% compared with yesterday.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / day';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return '$minutes minutes to reach today\'s goal';
  }

  @override
  String get tajweedPracticeTitle => 'Tajweed Practice';

  @override
  String tajweedPracticeAyahTitle(String surah, String ref) {
    return '$surah · $ref';
  }

  @override
  String get tajweedDownloadTitle => 'Preparing AI model';

  @override
  String get tajweedDownloadFailedTitle => 'Could not prepare AI model';

  @override
  String get tajweedDownloadBody =>
      'One-time download so Tajweed practice works fully offline afterwards. This only happens once.';

  @override
  String get tajweedDownloadFinishing => 'Finishing setup…';

  @override
  String get tajweedDownloadCanLeave =>
      'You can leave this screen — the download continues in the background.';

  @override
  String get tajweedDownloadTryAgain => 'Try again';

  @override
  String get tajweedDownloadPleaseTryAgain => 'Please try again.';

  @override
  String get tajweedErrorFeatureDisabled =>
      'AI Tajweed practice is turned off. Enable it in Settings first.';

  @override
  String get tajweedErrorModelMissing => 'The AI model is not installed yet.';

  @override
  String get tajweedErrorModelDownloadFailed =>
      'Downloading the AI model failed. Check your connection and try again.';

  @override
  String get tajweedErrorModelLoadFailed =>
      'The AI model could not be loaded on this device.';

  @override
  String get tajweedErrorCouldNotPrepare => 'Could not prepare the AI model.';

  @override
  String get tajweedErrorUnsupported =>
      'AI Tajweed practice is not available on this device.';

  @override
  String get sharePromoTitle => 'Check out this on DeenFocus 🌙';

  @override
  String get sharePromoBody =>
      'A simple app to help you stay focused on your Deen, pray on time and build better habits.';

  @override
  String get sharePromoDownloadHeading => 'Download DeenFocus:';

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
      'Your companion for a better Deen, every day.';

  @override
  String get shareDownloadCta => 'Download DeenFocus';

  @override
  String get shareAppStoreBadge => 'App Store';

  @override
  String get sharePlayStoreBadge => 'Google Play';

  @override
  String get shareFailed => 'Unable to share. Please try again.';

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
  String get insightsLevelName1 => 'New Beginning';

  @override
  String get insightsLevelName2 => 'Getting Started';

  @override
  String get insightsLevelName3 => 'Building the Habit';

  @override
  String get insightsLevelName4 => 'Steady Worshipper';

  @override
  String get insightsLevelName5 => 'Consistent Heart';

  @override
  String get insightsLevelName6 => 'Prayer Keeper';

  @override
  String get insightsLevelName7 => 'Dedicated Servant';

  @override
  String get insightsLevelName8 => 'Strong Routine';

  @override
  String get insightsLevelName9 => 'Devoted Worshipper';

  @override
  String get insightsLevelName10 => 'Steadfast';

  @override
  String get insightsLevelName11 => 'Deepening Faith';

  @override
  String get insightsLevelName12 => 'Strong Consistency';

  @override
  String get insightsLevelName13 => 'Devotion Leader';

  @override
  String get insightsLevelName14 => 'Exceptional Consistency';

  @override
  String get insightsLevelName15 => 'DeenFocus Master';

  @override
  String get lockScreenOptionsTitle => 'Lock Screen Style';

  @override
  String get lockScreenOptionsSubtitle => 'Choose how prayer reminders appear';

  @override
  String get lockScreenOptionsHint =>
      'Tap a style to open the full-screen layout.';

  @override
  String get lockScreenDefaultBadge => 'Default';

  @override
  String get lockScreenSelectedBadge => 'Selected';

  @override
  String get lockScreenPreviewLabel => 'Preview';

  @override
  String get lockScreenStyleClassic => 'Prayer reminder';

  @override
  String get lockScreenStyleTasbih => 'Tasbih counter';

  @override
  String get lockScreenStyleVerse => 'Daily verse';

  @override
  String get lockScreenStyleDua => 'Daily du\'a';

  @override
  String get lockScreenStyleQuiz => 'Knowledge check';

  @override
  String get lockScreenStyleTimes => 'Prayer times';

  @override
  String get lockScreenStyleCountdown => 'Countdown';

  @override
  String get lockScreenStyleHold => 'Hold to confirm';

  @override
  String get lockScreenStyleType => 'Type to confirm';

  @override
  String get lockScreenStyleMinimal => 'Minimal Focus';

  @override
  String get lockScreenItsTimeToPray => 'It\'s time to pray:';

  @override
  String lockScreenRemainingTime(String time) {
    return 'Remaining time: $time';
  }

  @override
  String get lockScreenRemindLater => 'Remind Me Later';

  @override
  String get lockScreenNextVerse => 'Next verse';

  @override
  String get lockScreenVerseForToday => 'Verse for today';

  @override
  String get lockScreenDuaForToday => 'Du\'a for today';

  @override
  String get lockScreenTapToCount => 'Tap anywhere to count';

  @override
  String get lockScreenHoldHint => 'Press and hold to confirm';

  @override
  String lockScreenTypeHint(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get lockScreenTypeWord => 'ALHAMDULILLAH';

  @override
  String get lockScreenConfirmBeforeAllah =>
      'Confirm before Allah that you have prayed.';

  @override
  String get lockScreenQuizCategory => 'Prayer';

  @override
  String get lockScreenQuizQuestion => 'How many daily prayers are obligatory?';

  @override
  String get lockScreenQuizA => 'Three';

  @override
  String get lockScreenQuizB => 'Four';

  @override
  String get lockScreenQuizC => 'Five';

  @override
  String get lockScreenQuizCorrect => 'Correct';

  @override
  String get lockScreenQuizIncorrect => 'Incorrect';

  @override
  String get lockScreenQuizComplete => 'Knowledge check complete';

  @override
  String get lockScreenQuizCategoryFasting => 'Fasting';

  @override
  String get lockScreenQuizCategoryPillars => 'Pillars';

  @override
  String get lockScreenQuizQ2 => 'In which month do Muslims fast?';

  @override
  String get lockScreenQuizQ2A => 'Shawwal';

  @override
  String get lockScreenQuizQ2B => 'Ramadan';

  @override
  String get lockScreenQuizQ2C => 'Muharram';

  @override
  String get lockScreenQuizQ3 => 'Which is the first pillar of Islam?';

  @override
  String get lockScreenQuizQ3A => 'Salah';

  @override
  String get lockScreenQuizQ3B => 'Shahada';

  @override
  String get lockScreenQuizQ3C => 'Hajj';

  @override
  String get lockScreenTimeUp => 'Time\'s up';

  @override
  String get lockScreenHoldRelease => 'Keep holding to confirm';

  @override
  String lockScreenCountProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get lockScreenVerseTranslation =>
      'So remember Me; I will remember you.';

  @override
  String get lockScreenVerseRef => 'Quran 2:152';

  @override
  String get lockScreenDuaTransliteration => 'Rabbana atina fid-dunya hasanah';

  @override
  String get lockScreenDuaTranslation =>
      'Our Lord, give us good in this world and good in the Hereafter.';

  @override
  String get lockScreenDuaSource => 'Al-Baqarah 2:201';

  @override
  String get lockScreenSampleRemaining => '2h 34m';

  @override
  String get lockScreenDhikrAstaghfirullah => 'Astaghfirullah';

  @override
  String get lockScreenDhikrSubhanAllah => 'SubhanAllah';

  @override
  String get lockScreenDhikrAlhamdulillah => 'Alhamdulillah';

  @override
  String get lockScreenDhikrAllahuAkbar => 'Allahu Akbar';

  @override
  String get homeTajweedPromoTitle => 'Quran AI Tajweed';

  @override
  String get homeTajweedPromoBody =>
      'Recite any verse and get instant AI feedback on your Tajweed.';

  @override
  String get homeTajweedPromoCta => 'Practice Tajweed';

  @override
  String get homeTajweedPromoAiFeedback => 'AI Feedback';

  @override
  String homeTajweedPromoWordAccuracy(int percent) {
    return '$percent% Word Accuracy';
  }

  @override
  String get homeLockScreenPromoTitle => 'Lock Screen Styles';

  @override
  String get homeLockScreenPromoBody =>
      'Personalize your lock screen with beautiful Islamic designs and helpful reminders.';

  @override
  String get homeLockScreenPromoCta => 'Explore Styles';

  @override
  String get homePromoNewBadge => 'NEW';

  @override
  String get homeReadQuranPromoTitle => 'Read Quran';

  @override
  String get homeReadQuranPromoSubtitle => 'Read, listen & practice tajweed';

  @override
  String get homeReadQuranPromoCta => 'Open Quran';

  @override
  String get homeReadQuranPromoNewBadge => 'New';

  @override
  String cycleModeActiveStatus(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Streak protected • Ends in $days days',
      one: 'Streak protected • Ends tomorrow',
      zero: 'Streak protected • Ends today',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeProtectPrayerStreakSubtitle =>
      'Keep your streak intact during cycle days';

  @override
  String get cycleModeExcludeFromStatisticsSubtitle =>
      'Don\'t count cycle days in your prayer stats';

  @override
  String get homePromoPreviewCity => 'Lahore';

  @override
  String get focusScreenTimeAuthPasscodeRequired =>
      'This iPhone needs a device passcode before Apple will allow Screen Time access. Set a passcode in iPhone Settings, then try again.';

  @override
  String get focusScreenTimeAuthCanceled =>
      'Screen Time access was canceled before Apple finished granting it. Please try again and complete the Apple prompt.';

  @override
  String get focusScreenTimeAuthConflict =>
      'Another app is already managing Family Controls on this iPhone. Turn that off first, then try again.';

  @override
  String get focusScreenTimeAuthInvalidAccount =>
      'Sign in with a valid iCloud account on this iPhone, then try Screen Time access again.';

  @override
  String get focusScreenTimeAuthNetwork =>
      'This iPhone needs an internet connection before Apple can grant Screen Time access.';

  @override
  String get focusScreenTimeAuthRestricted =>
      'Family Controls is restricted on this iPhone, so DeenFocus cannot request Screen Time access here.';

  @override
  String get focusScreenTimeAuthUnavailable =>
      'Family Controls is currently unavailable on this iPhone.';

  @override
  String get focusScreenTimeAuthIosVersion =>
      'Screen Time app blocking requires iOS 16 or later.';

  @override
  String get focusScreenTimeAuthInvalidArgument =>
      'The Screen Time authorization request was invalid. Please try again.';

  @override
  String get focusScreenTimeAuthFailedGeneric =>
      'Screen Time access could not be granted on this iPhone.';

  @override
  String widgetLockCountdownHoursMinutes(String hours, String minutes) {
    return 'In ${hours}h ${minutes}m';
  }

  @override
  String widgetLockCountdownMinutes(String minutes) {
    return 'In ${minutes}m';
  }

  @override
  String get lockScreenRecommendedBadge => 'Recommended';
}
