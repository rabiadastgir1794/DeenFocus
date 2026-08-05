// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'दीन फोकस';

  @override
  String get appTagline => 'आस्था। केंद्र। स्थिरता';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'प्रार्थना विधा. बालक मोड। स्लीप मोड।';

  @override
  String get welcomeDescription =>
      'अपनी प्रार्थनाओं को ट्रैक करें, कुरान पढ़ें, तस्बीह गिनें, और सार्थक पंक्तियाँ बनाएँ - सब कुछ एक ही स्थान पर।';

  @override
  String get skip => 'छोडना';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get continueButton => 'जारी रखना';

  @override
  String get continueForFree => 'मुफ्त प्लान के साथ जारी रखें';

  @override
  String get getStarted => 'प्रीमियम अनलॉक करें';

  @override
  String get language => 'भाषा';

  @override
  String get cancel => 'रद्द करना';

  @override
  String get ok => 'ठीक है';

  @override
  String get openSettings => 'खुली सेटिंग';

  @override
  String get locationRequired => 'स्थान आवश्यक';

  @override
  String get locationRequiredMessage =>
      'सटीक प्रार्थना समय और क़िबला दिशा की गणना करने के लिए स्थान पहुंच की आवश्यकता होती है। ऐप का उपयोग करने के लिए आपको इसे सक्षम करना होगा।';

  @override
  String get notificationsRequired => 'सूचनाएं आवश्यक हैं';

  @override
  String get notificationsRequiredMessage =>
      'प्रार्थना के समय के अलर्ट और अनुस्मारक प्राप्त करने के लिए सूचनाओं की आवश्यकता होती है।';

  @override
  String get sectTitle => 'अपना संप्रदाय चुनें';

  @override
  String get sectSubtitle =>
      'इससे हमें आपके अनुभव को निजीकृत करने में मदद मिलती है';

  @override
  String get sectSunni => 'सुन्नी';

  @override
  String get sectShia => 'शिया';

  @override
  String get sectPreferNotToSay => 'नहीं कहना पसंद करते हैं';

  @override
  String get nameTitle => 'तुम्हारा नाम क्या है?';

  @override
  String get nameSubtitle => 'आइए आपके अभिवादन को वैयक्तिकृत करें';

  @override
  String get namePlaceholder => 'आपका नाम';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => 'स्थान पहुंच की अनुमति दें';

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
  String get notificationsButton => 'सूचनाएं सक्षम करें';

  @override
  String get notificationsEnabled => 'सूचनाएं सक्षम हैं';

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
  String get screenTimeTitle => 'स्क्रीन टाइम सक्षम करें';

  @override
  String get screenTimeSubtitle =>
      'इसी से Deen Focus सलाह, नींद के समय और चाइल्ड मोड के दौरान ध्यान भटकाने वाले ऐप्स को रोकता है।';

  @override
  String get screenTimeButton => 'स्क्रीन टाइम एक्सेस की अनुमति दें';

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
  String get focusPrayerModeTitle => 'प्रार्थना विधा';

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
  String get focusSleepModeTitle => 'स्लीप मोड';

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
  String get focusChildModeTitle => 'बालक मोड';

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
  String get investTitle => 'अपने दीन में निवेश करें';

  @override
  String get investSubtitle =>
      'आप कॉफी या स्नैक्स पर खर्च करने के बारे में दोबारा नहीं सोचते...';

  @override
  String get investComparisonTitle =>
      'प्रीमियम लें या मुफ्त प्लान के साथ जारी रखें';

  @override
  String get investDailyCoffee => 'दैनिक कॉफ़ी';

  @override
  String get investDailyCoffeePrice => '\$5/दिन';

  @override
  String get investFastFood => 'फास्ट फूड';

  @override
  String get investFastFoodPrice => '\$10/भोजन';

  @override
  String get investYourDeen => 'आपका दीन';

  @override
  String get investYourDeenPrice => '\$4.99/माह';

  @override
  String get investComparisonQuote =>
      'आप बिना सोचे-समझे छोटी-छोटी चीजों पर 10 डॉलर खर्च कर देते हैं - अपने दीन में निवेश क्यों नहीं करते?';

  @override
  String get bestValueTag => 'सबसे अच्छा मूल्य';

  @override
  String get mostPopularChoice => 'सबसे लोकप्रिय विकल्प';

  @override
  String get monthlyPriceValue => '\$4.99';

  @override
  String get monthlyPriceSuffix => '/महीना';

  @override
  String get monthlyPlanSubtitle =>
      'मासिक बिल भेजा गया • किसी भी समय रद्द करें';

  @override
  String get yearlyPriceValue => '\$24.99';

  @override
  String get yearlyPriceSuffix => '/वर्ष';

  @override
  String get yearlyPlanSubtitle => '50% बचाएं • सालाना बिल भेजा जाएगा';

  @override
  String get lifetimePriceValue => '\$79.99';

  @override
  String get lifetimePriceSuffix => 'जीवनभर';

  @override
  String get lifetimePlanSubtitle => 'एक बार की खरीदारी • हमेशा के लिए पहुंच';

  @override
  String get everythingYouGet => 'सब कुछ तुम्हें मिलता है';

  @override
  String get featureFocusModeAllModes => 'सभी 3 मोड के साथ असीमित फोकस मोड';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'उन्नत प्रार्थना विश्लेषण और स्ट्रीक्स';

  @override
  String get featureAiAssistant => 'एआई इस्लामिक सहायक';

  @override
  String get featurePrioritySupportEarlyAccess =>
      'प्राथमिकता समर्थन और शीघ्र पहुंच';

  @override
  String get socialProofPrefix => 'जोड़ना';

  @override
  String get socialProofHighlight => '10,000+';

  @override
  String get socialProofSuffix =>
      'मुसलमान पहले से ही दीन फोकस के साथ बढ़ रहे हैं';

  @override
  String get mostPopular => 'सबसे लोकप्रिय';

  @override
  String get monthlyLabel => 'महीने के';

  @override
  String get monthlyPrice =>
      '\$4.99/माह · मासिक बिल भेजा गया · किसी भी समय रद्द करें';

  @override
  String get yearlyLabel => 'सालाना';

  @override
  String get yearlyPrice => '\$24.99/वर्ष · 50% बचाएं · वार्षिक बिल';

  @override
  String get lifetimeLabel => 'जीवनभर';

  @override
  String get lifetimePrice =>
      '\$79.99 आजीवन · एकमुश्त खरीदारी · हमेशा के लिए पहुंच';

  @override
  String get featurePrayerAnalytics => 'उन्नत प्रार्थना विश्लेषण';

  @override
  String get featureFocusMode => 'असीमित फोकस मोड';

  @override
  String get featureMasjidMode => 'मस्जिद ऑटो मोड';

  @override
  String get featureNoAds => 'सभी विज्ञापन हटा देता है';

  @override
  String get featureSupport => 'प्राथमिकता समर्थन';

  @override
  String get homeTitle => 'डीनली होम';

  @override
  String get homeSalam => 'अस्सलामु अलैकुम';

  @override
  String get homeDailyVerseFallback => 'दरअसल, कठिनाई के साथ आसानी भी आती है।';

  @override
  String get homeAppsLocked => 'ऐप्स लॉक हो गए';

  @override
  String get homeAppsUnlocked => 'ऐप्स अनलॉक किए गए';

  @override
  String get homeTapToUnlock =>
      'ऐप्स को अस्थायी रूप से अनलॉक करने के लिए टैप करें';

  @override
  String get homeTapToRelock =>
      'ब्लॉक किए गए ऐप्स को अभी पुनः लॉक करने के लिए टैप करें';

  @override
  String get homeRelock => 'पुनः लॉक करें';

  @override
  String get homeUnlock => 'अनलॉक';

  @override
  String get homePrayerModeActive => 'प्रार्थना मोड सक्रिय';

  @override
  String get homeActivatePrayerMode => 'प्रार्थना मोड सक्रिय करें';

  @override
  String get homeAppsBlockedSubtitle =>
      'ऐप्स ब्लॉक कर दिए गए हैं. निष्क्रिय करने के लिए टैप करें.';

  @override
  String get homeBlockDistractingApps =>
      'सलाह के दौरान ध्यान भटकाने वाले ऐप्स को ब्लॉक करें।';

  @override
  String get homeQiblaDirection => 'किबला दिशा';

  @override
  String get homeLocationMissingForQibla =>
      'किबला दिशा की गणना करने के लिए स्थान सक्षम करें।';

  @override
  String get homeQiblaSubtitleGuiding => 'क़िबला की ओर आपका मार्गदर्शन करना';

  @override
  String get homeToMakkah => 'मक्का के लिए';

  @override
  String get homeFindMasjid => 'मेरे निकट मस्जिद खोजें';

  @override
  String get quickActionsMasjidFinder => 'मस्जिद खोजें';

  @override
  String get homeSearchNearbyMosques => 'आस-पास की मस्जिदें खोजें।';

  @override
  String get homePrayerStreak => 'प्रार्थना की धारियाँ';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'इनसाइट्स';

  @override
  String get homeOpenStreakDetails => 'स्ट्रीक विवरण खोलें.';

  @override
  String get homeTodaysPrayers => 'आज की प्रार्थनाएँ';

  @override
  String get homePrayerTimesUnavailable => 'प्रार्थना का समय अभी अनुपलब्ध है.';

  @override
  String get homeNextPrayerIn => 'अगली प्रार्थना में';

  @override
  String get homePrayerFajr => 'फज्र';

  @override
  String get homePrayerSunrise => 'सूर्योदय';

  @override
  String get homePrayerDhuhr => 'धुहर';

  @override
  String get homePrayerAsr => 'अस्र';

  @override
  String get homePrayerMaghrib => 'मग़रिब';

  @override
  String get homePrayerIsha => 'ईशा';

  @override
  String get homeWeek => 'सप्ताह';

  @override
  String get homeMonth => 'महीना';

  @override
  String get homeThisWeek => 'दीन इस सप्ताह पर प्रकाश डालता है';

  @override
  String get homeJummahMubarak => 'जुम्मा मुबारक';

  @override
  String get homeJummahReminder => 'सूरह अल-काहफ़ को मत भूलना।';

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
      'इस अवधि में आपकी नमाज़ स्ट्रीक सुरक्षित रहती है। साइकिल के दिन गुलाबी रंग में दिखते हैं, और साइकिल समाप्त होने पर साइकिल मोड अपने आप बंद हो जाता है।';

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
  String get cycleModeSettingsTitle => 'साइकिल मोड';

  @override
  String get cycleModeStartDateLabel => 'प्रारंभ तिथि';

  @override
  String get cycleModeLengthLabel => 'साइकिल अवधि';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'स्ट्रीक रोकें';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'आँकड़ों से बाहर रखें';

  @override
  String get cycleModeSaveButton => 'सहेजें';

  @override
  String get cycleModeEditButton => 'संपादित करें';

  @override
  String get cycleModeChangeStartDateTitle => 'प्रारंभ तिथि बदलें?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'प्रारंभ तिथि बदलने से आपका सक्रिय साइकिल मोड विंडो फिर से गणना होगा। नई सीमा के बाहर के दिन अब साइकिल दिन नहीं माने जा सकते।';

  @override
  String get cycleModeChangeStartDateConfirm => 'प्रारंभ तिथि बदलें';

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
  String get dailyChecklistSectionPrayer => 'नमाज़';

  @override
  String get dailyChecklistSectionQuranDhikr => 'क़ुरान और ज़िक्र';

  @override
  String get dailyChecklistSectionGoodDeeds => 'अच्छे काम';

  @override
  String get dailyChecklistSectionDistraction => 'विकर्षण नियंत्रण';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'तहज्जुद';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'शाम के अज़कार';

  @override
  String get dailyChecklistDhikr => 'ज़िक्र';

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
  String get focusScoreTitle => 'आज का फोकस स्कोर';

  @override
  String get focusScorePrayer => 'नमाज़';

  @override
  String get focusScoreQuran => 'क़ुरान';

  @override
  String get focusScoreDhikr => 'ज़िक्र';

  @override
  String get focusScoreDistraction => 'विकर्षण नियंत्रण';

  @override
  String get insightsBack => 'वापस';

  @override
  String get insightsTitle => 'मेरी इनसाइट्स';

  @override
  String get insightsSubtitle => 'अपनी दीन प्रगति ट्रैक करें';

  @override
  String get insightsPrayerRate => 'नमाज़ दर';

  @override
  String get insightsDayStreak => 'दिन स्ट्रीक';

  @override
  String get insightsBestStreak => 'सर्वश्रेष्ठ स्ट्रीक';

  @override
  String get insightsWeekly => 'साप्ताहिक';

  @override
  String get insightsMonthly => 'मासिक';

  @override
  String get insightsPrayersCompleted => 'पूरी की गई नमाज़ें';

  @override
  String get insightsRestoreStreak =>
      'मेरी स्ट्रीक पुनर्स्थापित करें — पिछले 24 घंटे';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'नमाज़ $prayerPercent% · क़ुरान $quranPercent% · ज़िक्र $dhikrPercent% · विचलन $distractionPercent%';
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
      'प्रार्थना के समय, कुरान और इस्लामी मार्गदर्शन के बारे में कुछ भी पूछें।';

  @override
  String get homeDay => 'दिन';

  @override
  String get homeDays => 'दिन';

  @override
  String get homeNoEventsFoundForDay => 'इस दिन के लिए कोई ईवेंट नहीं मिला.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — चिह्नित करें';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'समय पर पढ़ी';

  @override
  String get homeMarkPrayerQada => 'क़ज़ा (बाद में पढ़ी)';

  @override
  String get homeMarkPrayerMissed => 'छूटी';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return '$prayerName सेटिंग्स';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'नमाज़ का समय';

  @override
  String get homePrayerSettingsNotification => 'सूचना';

  @override
  String get homePrayerSettingsAboutSubtitle => 'फ़ज़ीलतें, अहकाम और अधिक';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'ये सेटिंग्स केवल $prayerName के लिए हैं। आप प्रत्येक नमाज़ के लिए अलग प्राथमिकताएँ सेट कर सकते हैं।';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return '$prayerName का समय संपादित करें';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'वर्तमान समय';

  @override
  String get homeEditPrayerTimeSelectNew => 'नया समय चुनें';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'यह कस्टम समय केवल $prayerName पर लागू होता है। यदि आपकी स्थानीय मस्जिद या गणना भिन्न हो तो इसे समायोजित करें।';
  }

  @override
  String get homeEditPrayerTimeSave => 'समय सहेजें';

  @override
  String get homeEditPrayerTimeReset => 'गणना किए गए समय पर रीसेट करें';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return '$prayerName के लिए सूचना';
  }

  @override
  String get homeNotificationSoundLabel => 'सूचना ध्वनि';

  @override
  String get homeNotificationSoundFullAdhan => 'पूरा अज़ान';

  @override
  String get homeNotificationSoundFullAdhanSubtitle => 'पूरा अज़ान चलाएँ';

  @override
  String get homeNotificationSoundBeep => 'बीप';

  @override
  String get homeNotificationSoundBeepSubtitle => 'एक छोटी सूचना ध्वनि';

  @override
  String get homeNotificationSoundMute => 'म्यूट';

  @override
  String get homeNotificationSoundMuteSubtitle => 'कोई ध्वनि नहीं';

  @override
  String get homeNotificationEnableLabel => 'सूचना सक्षम करें';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return '$prayerName के समय पर सूचित हों';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return '$prayerName के बारे में';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'समय';

  @override
  String get homeAboutPrayerRakatLabel => 'रकात';

  @override
  String get homeAboutPrayerVirtuesLabel => 'फ़ज़ीलतें';

  @override
  String get homeAboutPrayerReferenceLabel => 'संदर्भ';

  @override
  String get homeAboutFajrTiming =>
      'सच्चे भोर (फ़ज्र सादिक़) से शुरू होती है और सूर्योदय पर समाप्त होती है।';

  @override
  String get homeAboutFajrRakat => '२ सुन्नत + २ फ़र्ज़';

  @override
  String get homeAboutFajrVirtue =>
      'जो फ़ज्र पढ़ता है वह अल्लाह की सुरक्षा में होता है।';

  @override
  String get homeAboutFajrReference =>
      '«फ़ज्र की दो रकातें दुनिया और उसमें मौजूद हर चीज़ से बेहतर हैं।» (सहीह मुस्लिम)';

  @override
  String get homeAboutDhuhrTiming =>
      'सूरज के ज़ेनिथ पार करने के बाद शुरू होती है और अस्र शुरू होने तक रहती है।';

  @override
  String get homeAboutDhuhrRakat => '४ सुन्नत + ४ फ़र्ज़ + २ सुन्नत';

  @override
  String get homeAboutDhuhrVirtue =>
      'दिन की उन १२ नफ़्ल रकातों का भाग जिनके लिए अल्लाह जन्नत में घर बनाता है।';

  @override
  String get homeAboutDhuhrReference =>
      '«जो दिन-रात में बारह रकातें पढ़े, उसके लिए जन्नत में एक घर बनाया जाएगा।» (सहीह मुस्लिम)';

  @override
  String get homeAboutAsrTiming =>
      'जब किसी वस्तु की छाया उसकी लंबाई के बराबर हो जाए तब शुरू होती है और सूर्यास्त तक रहती है।';

  @override
  String get homeAboutAsrRakat => '४ फ़र्ज़';

  @override
  String get homeAboutAsrVirtue =>
      'इस नमाज़ की हिफ़ाज़त विशेष इनाम और चेतावनी के साथ कही गई है।';

  @override
  String get homeAboutAsrReference =>
      '«जिसकी अस्र नमाज़ छूट जाए, मानो उसने अपना परिवार और माल खो दिया।» (सहीह बुख़ारी)';

  @override
  String get homeAboutMaghribTiming =>
      'सूर्यास्त के तुरंत बाद शुरू होती है और लाल शफ़क़ ग़ायब होने तक रहती है।';

  @override
  String get homeAboutMaghribRakat => '३ फ़र्ज़ + २ सुन्नत';

  @override
  String get homeAboutMaghribVirtue =>
      'वह समय जब दुआएँ विशेष रूप से प्रोत्साहित की जाती हैं।';

  @override
  String get homeAboutMaghribReference =>
      '«रोज़ेदार के लिए दो ख़ुशियाँ हैं… जब वह इफ़्तार करता है।» (सहीह बुख़ारी, मग़रिब इफ़्तार पर)';

  @override
  String get homeAboutIshaTiming =>
      'शफ़क़ पूरी तरह ग़ायब होने के बाद शुरू होती है और आधी रात तक रहती है (कुछ राय के अनुसार फ़ज्र तक)।';

  @override
  String get homeAboutIshaRakat => '४ फ़र्ज़ + २ सुन्नत + वितर';

  @override
  String get homeAboutIshaVirtue =>
      'जमात में ईशा पढ़ना आधी रात तक क़याम के बराबर है।';

  @override
  String get homeAboutIshaReference =>
      '«जो ईशा जमात में पढ़े, मानो उसने आधी रात नमाज़ पढ़ी।» (सहीह मुस्लिम)';

  @override
  String get backToOnboarding => 'ऑनबोर्डिंग पर वापस जाएँ';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appLanguage => 'ऐप भाषा';

  @override
  String get tabHome => 'घर';

  @override
  String get tabFocus => 'केंद्र';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'कुरान';

  @override
  String get tabLearn => 'सीखें';

  @override
  String get quranLoadFailed => 'कुरान डेटा लोड करने में विफल';

  @override
  String get quranTabSubtitle => 'पवित्र कुरान पढ़ें और अन्वेषण करें';

  @override
  String get quranSearchHint => 'सुरा खोजें...';

  @override
  String get quranNoSurahsFound => 'कोई सूरह नहीं मिला';

  @override
  String get quranVersesLabel => 'छंद';

  @override
  String get quranTextOptions => 'पाठ विकल्प';

  @override
  String get quranEnglishAndArabic => 'अंग्रेजी और अरबी';

  @override
  String get quranArabicOnly => 'केवल अरबी';

  @override
  String get quranIncreaseFont => 'फ़ॉन्ट बढ़ाएँ';

  @override
  String get quranDecreaseFont => 'फ़ॉन्ट कम करें';

  @override
  String get quranPause => 'विराम';

  @override
  String get quranPlaySurah => 'सुरा खेलें';

  @override
  String get quranAudioNoInternet =>
      'इंटरनेट कनेक्शन नहीं है। ऑडियो के लिए इंटरनेट आवश्यक है।';

  @override
  String get quranAudioTimeout =>
      'ऑडियो लोड टाइमआउट हो गया। अपना कनेक्शन जांचें।';

  @override
  String get quranSurahLabel => 'सूरा';

  @override
  String get save => 'बचाना';

  @override
  String get tasbihBack => 'पीछे';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'एक धिक्कार चुनें या अपना खुद का बनाएं';

  @override
  String get tasbihAddCustomTitle => 'धिक्कार जोड़ें';

  @override
  String get tasbihEditCustomTitle => 'कस्टम धिक्कार संपादित करें';

  @override
  String get tasbihArabicOrDhikrHint => 'अरबी पाठ या कोई धिक्कार';

  @override
  String get tasbihTransliterationOptionalHint => 'लिप्यंतरण (वैकल्पिक)';

  @override
  String get tasbihMeaningOptionalHint => 'अर्थ (वैकल्पिक)';

  @override
  String get tasbihNoTransliteration => 'कोई लिप्यंतरण नहीं';

  @override
  String get tasbihTotalCount => 'कुल गिनती';

  @override
  String get tasbihGrandTotalLabel => 'कुल तस्बीह';

  @override
  String get tasbihTapMe => 'मुझे टैप करें';

  @override
  String get tasbihReset => 'रीसेट करें';

  @override
  String get tasbihRestart => 'पुनः आरंभ करें';

  @override
  String get tasbihCurrentCount => 'वर्तमान गणना';

  @override
  String get tasbihResetTotal => 'इतिहास मिटा दें';

  @override
  String get focusModeActivated => 'फोकस मोड सक्रिय';

  @override
  String get focusSetUpHomeCardTitle => 'फ़ोकस मोड सेट करें';

  @override
  String get focusTabSubtitle =>
      'जब यह सबसे ज्यादा मायने रखता हो तो ध्यान केंद्रित रखें';

  @override
  String get focusChooseAppsEnableMode => 'ऐप चुनें और फ़ोकस मोड चालू करें';

  @override
  String get focusNotifAppsLockedTitle => 'ऐप लॉक हैं';

  @override
  String get focusNotifAppsUnlockedTitle => 'ऐप अनलॉक हैं';

  @override
  String get focusNotifNightModeTitle => 'नाइट मोड';

  @override
  String get focusNotifGoodMorningTitle => 'सुप्रभात!';

  @override
  String get focusNotifAppsNowAvailableBody => 'ऐप अब उपलब्ध हैं।';

  @override
  String get focusNotifSalahLockedBody => 'नमाज़ के दौरान ऐप लॉक हैं।';

  @override
  String get focusNotifSalahCompleteTitle => 'नमाज़ पूरी';

  @override
  String get focusNotifSalahCompleteBody =>
      'ऐप अब अनलॉक हैं। अल्लाह आपकी नमाज़ कबूल करे।';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return '$prayerName का समय';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return '$prayerName की नमाज़ के लिए एक पल निकालें।';
  }

  @override
  String get focusNotifNightLockedBody =>
      'नाइट मोड चालू है। अपने मन और शरीर को आराम दें।';

  @override
  String get focusNotifGenericLockedBody => 'चुने गए ऐप लॉक हैं।';

  @override
  String get focusNotifMorningUnlockBody => 'ऐप उपलब्ध नहीं हैं।';

  @override
  String get widgetDailyVerseTitle => 'दैनिक आयत';

  @override
  String get widgetOpenAppTimelineHint =>
      'दैनिक आयत और प्रार्थना विजेट डेटा तैयार करने के लिए Deen Focus खोलें।';

  @override
  String get widgetSetLocationForPrayers =>
      'नमाज़ और दैनिक आयत लोड करने के लिए Deen Focus में अपना स्थान सेट करें।';

  @override
  String get focusChildModeActive => 'चाइल्ड मोड सक्रिय';

  @override
  String get focusSalahAndNightModeActive => 'सलाह और नाइट मोड सक्रिय';

  @override
  String get focusSalahModeActive => 'सलाह मोड सक्रिय';

  @override
  String get focusNightModeActive => 'रात्रि मोड सक्रिय';

  @override
  String get focusAppsToBlockTitle => 'ब्लॉक करने के लिए ऐप्स';

  @override
  String get focusAppliesAllModes => 'सभी फोकस मोड पर लागू होता है';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'ऐप्स देखने और चुनने के लिए स्क्रीन टाइम एक्सेस आवश्यक है।';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'जारी रखने के लिए कृपया पहुंच-योग्यता प्रकटीकरण स्वीकार करें।';

  @override
  String get focusSelectAppsToBlock => 'ब्लॉक करने के लिए ऐप्स चुनें';

  @override
  String get focusLoading => 'लोड हो रहा है...';

  @override
  String get focusOpen => 'खुला';

  @override
  String get focusHide => 'छिपाना';

  @override
  String get focusLoad => 'भार';

  @override
  String get focusShow => 'दिखाओ';

  @override
  String get focusSalahFocusModeTitle => 'सलाह फोकस मोड';

  @override
  String get focusBlockAppsDuringPrayer =>
      'प्रार्थना के दौरान ऐप्स को ब्लॉक करें';

  @override
  String get focusNightDisciplineTitle => 'रात्रि अनुशासन';

  @override
  String get focusSleepLabel => 'नींद';

  @override
  String get focusWakeLabel => 'जागो';

  @override
  String get focusBlockAppsImmediately => 'ऐप्स को तुरंत ब्लॉक करें';

  @override
  String get focusEnableAndroidAppBlocking => 'एंड्रॉइड ऐप ब्लॉकिंग सक्षम करें';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'एंड्रॉइड पर अन्य ऐप्स को ब्लॉक करने के लिए, डीनली को इसकी एक्सेसिबिलिटी अनुमति चालू करनी होगी। हम आपके लिए सही सेटिंग स्क्रीन खोलेंगे.';

  @override
  String get focusAccessibilityDisclosureTitle => 'अभिगम्यता अनुमति प्रकटीकरण';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'फोकस मोड ऐप ब्लॉकिंग को लागू करने के लिए डीनली एंड्रॉइड एक्सेसिबिलिटी का उपयोग करता है।\n\nहमें इसकी आवश्यकता क्यों है: यह पता लगाने के लिए कि आप किसी ऐप को कब खोलते हैं जिसे आपने ब्लॉक करने के लिए चुना है।\n\nहम इसका उपयोग कैसे करते हैं: केवल अग्रभूमि ऐप की पहचान करने और चयनित ऐप्स के लिए फ़ोकस ब्लॉक स्क्रीन दिखाने के लिए। हम इसका उपयोग टाइप किए गए पाठ या व्यक्तिगत सामग्री को पढ़ने के लिए नहीं करते हैं।';

  @override
  String get focusNotNow => 'अभी नहीं';

  @override
  String get focusIUnderstand => 'मैं समझता हूँ';

  @override
  String get focusDone => 'हो गया';

  @override
  String get focusNightDisciplineCardSubtitle => 'रात की बेहतर आदतें बनाएँ';

  @override
  String get focusPrayerBlockingDescription =>
      'प्रार्थना के दौरान ऐप्स ब्लॉक हो जाएंगे और 15 मिनट के बाद स्वचालित रूप से अनलॉक हो जाएंगे, या आप उन्हें होम स्क्रीन से कभी भी अनलॉक कर सकते हैं।';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'प्रार्थना के दौरान ऐप्स ब्लॉक हो जाएंगे, या आप उन्हें होम स्क्रीन से कभी भी अनलॉक कर सकते हैं।';

  @override
  String get focusNightBlockingDescription =>
      'आपके स्लीप साइकल के दौरान ऐप्स ब्लॉक हो जाएंगे और स्वचालित रूप से अनलॉक हो जाएंगे, या आप उन्हें होम स्क्रीन से किसी भी समय अनलॉक कर सकते हैं';

  @override
  String get focusChildBlockingDescription =>
      'चाइल्ड मोड में ऐप्स तुरंत ब्लॉक हो जाते हैं। टॉगल का उपयोग करके या होम स्क्रीन से उन्हें अनलॉक करें';

  @override
  String get settingsEditUsername => 'उपयोक्तानाम संपादित करें';

  @override
  String get settingsEnterYourName => 'अपना नाम दर्ज करें';

  @override
  String get settingsPremiumTitle => 'दीन फोकस प्रीमियम';

  @override
  String get settingsPremiumSubtitle => 'सभी सुविधाएं अनलॉक करें';

  @override
  String get settingsManageSubscriptionTitle => 'सदस्यता प्रबंधित करें';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'योजना देखें या बिलिंग अपडेट करें';

  @override
  String get settingsUsernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get settingsLocationLabel => 'जगह';

  @override
  String get settingsDarkModeLabel => 'डार्क मोड';

  @override
  String get settingsAboutTitle => 'दीन फोकस के बारे में';

  @override
  String get settingsContactUsTitle => 'हमसे संपर्क करें';

  @override
  String get settingsSavingLocation => 'सहेजा जा रहा है...';

  @override
  String get settingsSaveLocation => 'स्थान सहेजें';

  @override
  String get settingsAboutTagline => 'केंद्र। अनुशासन। स्थिरता।';

  @override
  String get settingsAboutDescription =>
      'दीन फोकस आधुनिक दुनिया में दैनिक विकर्षणों को प्रबंधित करते हुए आपको अपनी आस्था से जुड़े रहने में मदद करता है।';

  @override
  String get settingsAboutFeature1 => 'अनुस्मारक के साथ प्रार्थना समय';

  @override
  String get settingsAboutFeature2 => 'किसी भी समय क़िबला दिशा';

  @override
  String get settingsAboutFeature3 => 'दैनिक ज़िक्र के लिए कुरान और तस्बीह';

  @override
  String get settingsAboutFeature4 => 'आस-पास की मस्जिदें';

  @override
  String get settingsAboutFeature5 =>
      'सलाह, नींद और पारिवारिक समय के लिए स्मार्ट फोकस मोड';

  @override
  String get settingsAboutFocusDescription =>
      'स्मार्ट फोकस मोड आपको सलाह, नींद और महत्वपूर्ण क्षणों के दौरान विकर्षणों को अवरुद्ध करने में मदद करते हैं, ताकि आप उपस्थित और अनुशासित रह सकें।';

  @override
  String get settingsAboutFooter =>
      'सुसंगत रहें। सचेत रहें।\nअपनी दीन से जुड़े रहें।';

  @override
  String get settingsEnableSystemNotifications =>
      'इसे चालू करने के लिए सिस्टम नोटिफिकेशन सक्षम करें।';

  @override
  String get appDemoTitle => 'ऐप डेमो';

  @override
  String get appDemoLoadFailed => 'डेमो वीडियो लोड नहीं हो सका.';

  @override
  String get appDemoRestartHint =>
      'वीडियो को पूर्ण ऐप रीस्टार्ट की आवश्यकता है (हॉट रीस्टार्ट प्लेबैक को बाधित कर सकता है)।';

  @override
  String get appDemoPreviewLoadFailed => 'डेमो लोड नहीं हो सका.';

  @override
  String get appDemoTryAgain => 'पुनः प्रयास करें';

  @override
  String get appDemoWatchLabel => 'डेमो देखें';

  @override
  String get homeAiChatTitle => 'दीन फोकस एआई';

  @override
  String get homeAiAskQuestionHint => 'प्रश्न पूछें...';

  @override
  String get homeAiSend => 'भेजना';

  @override
  String get homeAiErrorPrefix =>
      'क्षमा करें, दीन फोकस एआई से कनेक्ट करते समय मुझे एक समस्या का सामना करना पड़ा।';

  @override
  String get homeAiEmptyTitle => 'इस्लाम के बारे में कुछ भी पूछें';

  @override
  String get homeAiEmptySubtitle =>
      'प्रार्थना का समय, कुरान, हदीस, इस्लामी घटनाएँ और आध्यात्मिक मार्गदर्शन';

  @override
  String get onboardingTypeCityName => 'अपने शहर का नाम टाइप करें..';

  @override
  String get onboardingNoLocationsFound => 'कोई स्थान नहीं मिला';

  @override
  String get onboardingTryAnotherCityName => 'किसी अन्य शहर का नाम आज़माएँ.';

  @override
  String get qiblaCompassUnavailable => 'इस डिवाइस पर कंपास अनुपलब्ध है';

  @override
  String get qiblaFacing => '✓ किबला की ओर मुख करना';

  @override
  String get qiblaTurnToFind => 'क़िबला खोजने के लिए मुड़ें';

  @override
  String get qiblaDistanceToMakkah => 'मक्का से दूरी';

  @override
  String get qiblaFromNorth => 'उत्तर से';

  @override
  String get qiblaNorthShort => 'एन';

  @override
  String get qiblaSouthShort => 'एस';

  @override
  String get qiblaEastShort => 'ई';

  @override
  String get qiblaWestShort => 'डब्ल्यू';

  @override
  String get nearbyMosquesTitle => 'आसपास की मस्जिदें';

  @override
  String get nearbyMosquesTryAgain => 'पुनः प्रयास करें';

  @override
  String get nearbyMosquesOpenGoogle => 'Google मानचित्र में खोलें';

  @override
  String get nearbyMosquesOpenApple => 'एप्पल मैप्स में खोलें';

  @override
  String get nearbyMosquesNoMosquesFoundWithin => 'भीतर कोई मस्जिद नहीं मिली';

  @override
  String get nearbyMosquesSearchRadius => 'खोज का दायरा: 5 किमी';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'मानचित्र पूर्वावलोकन अभी उपलब्ध नहीं है.';

  @override
  String get nearbyMosquesWaitingForLocation =>
      'आपके स्थान की प्रतीक्षा की जा रही है.';

  @override
  String get nearbyMosquesFetchingLocation =>
      'आपका स्थान प्राप्त किया जा रहा है…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'वर्तमान स्थान';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'परिणाम लोड होते ही आसपास की मस्जिदें यहां दिखाई देंगी।';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      '5 किमी के अंदर कोई मस्जिद नहीं मिली';

  @override
  String get nearbyMosquesLocationRequired =>
      'आस-पास की मस्जिदों को खोजने के लिए स्थान की पहुंच आवश्यक है।';

  @override
  String get nearbyMosquesPermissionOff =>
      'स्थान अनुमति बंद है. आस-पास की मस्जिदों को देखने के लिए इसे सेटिंग्स में सक्षम करें।';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'हम अभी आपका वर्तमान स्थान नहीं पढ़ सके।';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'लाइव अपडेट विफल. अंतिम सहेजे गए परिणाम दिखा रहा है. रीफ़्रेश करने के लिए खींचें।';

  @override
  String get nearbyMosquesPermissionDenied =>
      'स्थान पहुंच से इनकार कर दिया गया था. आस-पास की मस्जिदों को देखने के लिए इसे सेटिंग्स में सक्षम करें।';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'इस डिवाइस पर स्थान बंद है. इसे सेटिंग्स में चालू करें, फिर पुनः प्रयास करें।';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'स्थान अनुमति अभी भी संसाधित की जा रही है. कृपया एक क्षण में पुनः प्रयास करें.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'अनुरोध में बहुत लंबा समय लगा. अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'कोई इंटरनेट कनेक्शन नहीं है या सेवा पहुंच योग्य नहीं है. अपना कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get nearbyMosquesFormatError =>
      'हम अभी मस्जिद की सूची नहीं पढ़ सके। कृपया बाद में पुन: प्रयास करें।';

  @override
  String get nearbyMosquesPlatformError =>
      'हम वह चरण पूरा नहीं कर सके. अपना कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'कुछ गलत हो गया। कृपया पुन: प्रयास करें।';

  @override
  String get nearbyMosquesEmptyHint =>
      'इस स्थान के लिए OpenStreetMap पर 5 किमी के भीतर कुछ भी सूचीबद्ध नहीं है। बाद में पुनः प्रयास करें या मानचित्र को स्थानांतरित करें।';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count मस्जिदें 5 किमी के भीतर पाई गईं';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'धिक्कार हटाओ?';

  @override
  String get tasbihDelete => 'मिटाना';

  @override
  String get focusAndroidBlockingNotReady =>
      'Android ऐप ब्लॉकिंग अभी तैयार हो रही है। एक्सेसिबिलिटी चालू रखें और कनेक्ट होने तक थोड़ा इंतज़ार करें।';

  @override
  String get focusNoAppsSelectedSnack =>
      'कोई ऐप चयनित नहीं। पहले ब्लॉक करने के लिए ऐप चुनें।';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'iPhone पर ऐप ब्लॉक करने के लिए स्क्रीन टाइम एक्सेस ज़रूरी है।';

  @override
  String get focusModeUpdateFailedSnack =>
      'फ़ोकस मोड अपडेट करते समय कुछ गलत हुआ। फिर कोशिश करें।';

  @override
  String get focusLoadingInstalledApps => 'इंस्टॉल ऐप लोड हो रहे हैं...';

  @override
  String get focusNoInstalledAppsToShow => 'दिखाने के लिए कोई इंस्टॉल ऐप नहीं।';

  @override
  String get homeAiSuggestion1 => 'रमज़ान क्या है?';

  @override
  String get homeAiSuggestion2 => 'नमाज़ के समय';

  @override
  String get homeAiSuggestion3 => 'क़ुरआन पढ़ने की योजना';

  @override
  String get homeAiDeveloperPrompt =>
      'आप एक जानकार और सम्मानजनक इस्लामी विद्वान सहायक हैं। उपयोगकर्ताओं को इस्लामी परंपराओं, त्योहारों, नमाज़, क़ुरआन अध्ययन और आध्यात्मिक अभ्यास सीखने में मदद करें। गर्मजोशी, संक्षिप्तता, शिक्षाप्रद और सांस्कृतिक संवेदनशीलता रखें। इस्लामी मार्गदर्शन से बाहर पूछे जाने पर उपयोगी उत्तर दें, धार्मिक निश्चितता का दिखावा किए बिना।';

  @override
  String get homeAiErrorMissingApiKey => 'API कॉन्फ़िगरेशन गायब है।';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'API त्रुटि $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'सहायक से कोई प्रतिक्रिया नहीं मिली।';

  @override
  String get homeAiErrorEmptyContent => 'खाली प्रतिक्रिया सामग्री।';

  @override
  String get settingsPrayerCalculationSection => 'नमाज़ गणना';

  @override
  String get settingsCalculationMethodTitle => 'गणना विधि';

  @override
  String get settingsAsrCalculationTitle => 'असर गणना';

  @override
  String get calculationMethodSectionMajorOrgs => 'प्रमुख इस्लामी संगठन';

  @override
  String get calculationMethodSectionMiddleEast => 'मध्य पूर्व';

  @override
  String get calculationMethodSectionAsiaPacific => 'एशिया प्रशांत';

  @override
  String get calculationMethodSectionSpecial => 'विशेष विधियाँ';

  @override
  String get asrMethodStandard => 'मानक';

  @override
  String get asrMethodStandardSubtitle => 'शाफी, मालिकी, हनबली';

  @override
  String get asrMethodHanafi => 'हनफी';

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
