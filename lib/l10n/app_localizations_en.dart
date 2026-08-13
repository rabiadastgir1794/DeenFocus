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
  String get notificationsButton => 'Enable Notifications';

  @override
  String get notificationsEnabled => 'Notifications are enabled';

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
  String get notificationsPreviewDhikrTitle => 'DAILY DHIKR';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — take a minute to remember.';

  @override
  String get notificationsPreviewStreakTitle => 'STREAK';

  @override
  String get notificationsPreviewStreakBody =>
      '7 days of complete prayers. Keep going!';

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
  String get cycleModeActiveTitle =>
      '\"Allah intends ease for you and does not intend hardship for you.\" — Quran 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'During this period, your prayer streak is protected. Your cycle days are highlighted in pink, and Cycle Mode turns off automatically when the cycle ends.';

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
  String get cycleModePauseStreaksLabel => 'Pause streaks';

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
  String get dailyChecklistSectionDistraction => 'Distraction control';

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
  String get supportUsEmailSubject => 'DeenFocus support request';

  @override
  String get supportUsLaunchUnavailable =>
      'Could not open that app on this device.';

  @override
  String get supportUsLaunchFailed => 'Something went wrong. Please try again.';

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
  String get tabQuran => 'Quran';

  @override
  String get tabLearn => 'Learn';

  @override
  String get quranLoadFailed => 'Failed to load Quran data';

  @override
  String get quranTabSubtitle => 'Read and explore the Holy Quran';

  @override
  String get quranSearchHint => 'Search surah...';

  @override
  String get quranNoSurahsFound => 'No surahs found';

  @override
  String get quranVersesLabel => 'verses';

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
      'Stay consistent. Stay mindful.\nStay connected to your Deen.';

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
  String get nearbyMosquesTitle => 'Nearby Mosques';

  @override
  String get nearbyMosquesTryAgain => 'Try again';

  @override
  String get nearbyMosquesOpenGoogle => 'Open in Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Open in Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin => 'No mosques found within';

  @override
  String get nearbyMosquesSearchRadius => 'Search radius: 5 km';

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
  String get nearbyMosquesNoneWithinRadius => 'No mosques found within 5 km';

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
  String get nearbyMosquesEmptyHint =>
      'Nothing listed within 5 km on OpenStreetMap for this spot. Try again later or move the map.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count mosques found within 5 km';
  }

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
}
