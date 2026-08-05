// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'İnam. Fokus. Ardıcıllıq';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Namaz rejimi. Uşaq rejimi. Yuxu rejimi.';

  @override
  String get welcomeDescription =>
      'Namazlarınızı izləyin, Quranı oxuyun, Təsbihləri sayın və mənalı xətlər yaradın - hamısı bir yerdə.';

  @override
  String get skip => 'Keç';

  @override
  String get notNow => 'İndi yox';

  @override
  String get continueButton => 'Davam et';

  @override
  String get continueForFree => 'Pulsuz plan ilə davam et';

  @override
  String get getStarted => 'Premiumu aç';

  @override
  String get language => 'Dil';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get ok => 'OK';

  @override
  String get openSettings => 'Parametrləri açın';

  @override
  String get locationRequired => 'Məkan Tələb olunur';

  @override
  String get locationRequiredMessage =>
      'Dəqiq namaz vaxtlarını və qiblə istiqamətini hesablamaq üçün məkana giriş tələb olunur. Proqramdan istifadə etmək üçün onu aktivləşdirməlisiniz.';

  @override
  String get notificationsRequired => 'Bildirişlər Tələb olunur';

  @override
  String get notificationsRequiredMessage =>
      'Namaz vaxtı xəbərdarlığı və xatırlatmaları almaq üçün bildirişlər tələb olunur.';

  @override
  String get sectTitle => 'Təriqətinizi seçin';

  @override
  String get sectSubtitle => 'Bu, təcrübənizi fərdiləşdirməyə kömək edir';

  @override
  String get sectSunni => 'sünni';

  @override
  String get sectShia => 'şiə';

  @override
  String get sectPreferNotToSay => 'deməməyə üstünlük verin';

  @override
  String get nameTitle => 'Adınız nədir?';

  @override
  String get nameSubtitle => 'Gəlin təbrikinizi fərdiləşdirək';

  @override
  String get namePlaceholder => 'Adınız';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => 'Məkan Girişinə icazə verin';

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
  String get notificationsButton => 'Bildirişləri aktivləşdirin';

  @override
  String get notificationsEnabled => 'Bildirişlər aktivləşdirilib';

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
  String get screenTimeTitle => 'Ekran Vaxtını Aktivləşdir';

  @override
  String get screenTimeSubtitle =>
      'Bu, Deen Focus-un namaz, yuxu vaxtı və uşaq rejimi zamanı diqqəti yayındıran tətbiqləri dayandırmasına imkan verir.';

  @override
  String get screenTimeButton => 'Ekran Vaxtına İcazə Ver';

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
  String get focusPrayerModeTitle => 'Namaz rejimi';

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
  String get focusSleepModeTitle => 'Yuxu rejimi';

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
  String get focusChildModeTitle => 'Uşaq rejimi';

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
  String get investTitle => 'Dininizə investisiya edin';

  @override
  String get investSubtitle =>
      'Qəhvə və ya qəlyanaltılara xərcləmək barədə iki dəfə düşünmürsən...';

  @override
  String get investComparisonTitle => 'Premium al və ya pulsuz davam et';

  @override
  String get investDailyCoffee => 'Gündəlik qəhvə';

  @override
  String get investDailyCoffeePrice => '\$5/gün';

  @override
  String get investFastFood => 'Fast food';

  @override
  String get investFastFoodPrice => '10 dollar/yemək';

  @override
  String get investYourDeen => 'Sənin dinin';

  @override
  String get investYourDeenPrice => '\$4,99/ay';

  @override
  String get investComparisonQuote =>
      'Düşünmədən xırda şeylərə 10 dollar xərcləyirsiniz - niyə dininizə investisiya qoymayasınız?';

  @override
  String get bestValueTag => 'ƏN YAXŞI DƏYƏR';

  @override
  String get mostPopularChoice => 'Ən populyar seçim';

  @override
  String get monthlyPriceValue => '4,99 dollar';

  @override
  String get monthlyPriceSuffix => '/ay';

  @override
  String get monthlyPlanSubtitle =>
      'Hər ay ödənilir • İstənilən vaxt ləğv edin';

  @override
  String get yearlyPriceValue => '24,99 dollar';

  @override
  String get yearlyPriceSuffix => '/il';

  @override
  String get yearlyPlanSubtitle => '50% qənaət edin • İllik hesablanır';

  @override
  String get lifetimePriceValue => '\$79.99';

  @override
  String get lifetimePriceSuffix => 'ömür boyu';

  @override
  String get lifetimePlanSubtitle => 'Birdəfəlik alış • Daimi giriş';

  @override
  String get everythingYouGet => 'Aldığınız hər şey';

  @override
  String get featureFocusModeAllModes =>
      'Bütün 3 rejimi ilə limitsiz Fokus rejimi';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'Qabaqcıl dua analitikası və xətlər';

  @override
  String get featureAiAssistant => 'AI İslam köməkçisi';

  @override
  String get featurePrioritySupportEarlyAccess =>
      'Prioritet dəstək və erkən giriş';

  @override
  String get socialProofPrefix => 'Qoşulun';

  @override
  String get socialProofHighlight => '10.000+';

  @override
  String get socialProofSuffix => 'Müsəlmanlar artıq Deen Focus ilə böyüyür';

  @override
  String get mostPopular => 'Ən Populyar';

  @override
  String get monthlyLabel => 'Aylıq';

  @override
  String get monthlyPrice =>
      'Ayda \$4.99 · aylıq ödəniş edilir · istənilən vaxt ləğv edin';

  @override
  String get yearlyLabel => 'İllik';

  @override
  String get yearlyPrice => '\$24.99/il · 50% qənaət · illik hesablanır';

  @override
  String get lifetimeLabel => 'Ömür boyu';

  @override
  String get lifetimePrice =>
      '\$79,99 ömür boyu · birdəfəlik alış · əbədi giriş';

  @override
  String get featurePrayerAnalytics => 'Təkmil dua analitikası';

  @override
  String get featureFocusMode => 'Limitsiz fokus rejimi';

  @override
  String get featureMasjidMode => 'Məscidin avtomatik rejimi';

  @override
  String get featureNoAds => 'Bütün reklamları silir';

  @override
  String get featureSupport => 'Prioritet dəstək';

  @override
  String get homeTitle => 'Deenly Ev';

  @override
  String get homeSalam => 'Assalamu aleykum';

  @override
  String get homeDailyVerseFallback =>
      'Həqiqətən, çətinliklə birlikdə asanlıq da gəlir.';

  @override
  String get homeAppsLocked => 'Proqramlar Kilidi';

  @override
  String get homeAppsUnlocked => 'Proqramlar Kilidi Açıldı';

  @override
  String get homeTapToUnlock =>
      'Tətbiqləri müvəqqəti olaraq açmaq üçün toxunun';

  @override
  String get homeTapToRelock =>
      'Bloklanmış tətbiqləri indi yenidən kilidləmək üçün toxunun';

  @override
  String get homeRelock => 'Yenidən kilidləyin';

  @override
  String get homeUnlock => 'Kilidi aç';

  @override
  String get homePrayerModeActive => 'Namaz Rejimi Aktivdir';

  @override
  String get homeActivatePrayerMode => 'Namaz rejimini aktivləşdirin';

  @override
  String get homeAppsBlockedSubtitle =>
      'Proqramlar bloklanıb. Deaktiv etmək üçün toxunun.';

  @override
  String get homeBlockDistractingApps =>
      'Namaz zamanı diqqəti yayındıran proqramları bloklayın.';

  @override
  String get homeQiblaDirection => 'Qiblə istiqaməti';

  @override
  String get homeLocationMissingForQibla =>
      'Qiblə istiqamətini hesablamaq üçün məkanı aktivləşdirin.';

  @override
  String get homeQiblaSubtitleGuiding => 'Sizi qibləyə doğru yönəldir';

  @override
  String get homeToMakkah => 'Məkkəyə';

  @override
  String get homeFindMasjid => 'Mənə Yaxın Məscidi tapın';

  @override
  String get quickActionsMasjidFinder => 'Məscid Axtarışı';

  @override
  String get homeSearchNearbyMosques => 'Yaxınlıqdakı məscidləri axtarın.';

  @override
  String get homePrayerStreak => 'Namaz xətləri';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'İcmal';

  @override
  String get homeOpenStreakDetails => 'Açıq zolaq təfərrüatları.';

  @override
  String get homeTodaysPrayers => 'Bu günün duaları';

  @override
  String get homePrayerTimesUnavailable =>
      'Namaz vaxtları hazırda əlçatan deyil.';

  @override
  String get homeNextPrayerIn => 'Növbəti namaz';

  @override
  String get homePrayerFajr => 'Sübh';

  @override
  String get homePrayerSunrise => 'Günəşin doğuşu';

  @override
  String get homePrayerDhuhr => 'Zöhr';

  @override
  String get homePrayerAsr => 'Əsr';

  @override
  String get homePrayerMaghrib => 'Mağrib';

  @override
  String get homePrayerIsha => 'İşa';

  @override
  String get homeWeek => 'Həftə';

  @override
  String get homeMonth => 'ay';

  @override
  String get homeThisWeek => 'Bu Həftənin Diqqətini çəkir';

  @override
  String get homeJummahMubarak => 'Cümə Mübarək';

  @override
  String get homeJummahReminder => 'Kəhf surəsini unutma.';

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
      'Bu dövrdə namaz seriyanız qorunur. Sikl günləri çəhrayı rənglə vurğulanır və Sikl rejimi sikl bitəndə avtomatik sönür.';

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
  String get cycleModeSettingsTitle => 'Sikl Rejimi';

  @override
  String get cycleModeStartDateLabel => 'Başlama tarixi';

  @override
  String get cycleModeLengthLabel => 'Sikl uzunluğu';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '1 gün',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Seriyaları dayandır';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'Statistikadan çıxar';

  @override
  String get cycleModeSaveButton => 'Yadda saxla';

  @override
  String get cycleModeEditButton => 'Redaktə et';

  @override
  String get cycleModeChangeStartDateTitle => 'Başlama tarixi dəyişdirilsin?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Başlama tarixini dəyişmək aktiv Sikl rejimi pəncərəsini yenidən hesablayacaq. Yeni aralıqdan kənar günlər artıq sikl günü sayıla bilməz.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Başlama tarixini dəyiş';

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
  String get dailyChecklistSectionPrayer => 'Namaz';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Quran və Zikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Yaxşı əməllər';

  @override
  String get dailyChecklistSectionDistraction => 'Diqqət nəzarəti';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Təhəccüd';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Axşam əzkari';

  @override
  String get dailyChecklistDhikr => 'Zikr';

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
  String get focusScorePrayer => 'Namaz';

  @override
  String get focusScoreQuran => 'Quran';

  @override
  String get focusScoreDhikr => 'Zikr';

  @override
  String get focusScoreDistraction => 'Diqqət nəzarəti';

  @override
  String get insightsBack => 'Geri';

  @override
  String get insightsTitle => 'İcmallarım';

  @override
  String get insightsSubtitle => 'Din tərəqqinizi izləyin';

  @override
  String get insightsPrayerRate => 'Namaz faizi';

  @override
  String get insightsDayStreak => 'Gün seriyası';

  @override
  String get insightsBestStreak => 'Ən yaxşı seriya';

  @override
  String get insightsWeekly => 'Həftəlik';

  @override
  String get insightsMonthly => 'Aylıq';

  @override
  String get insightsPrayersCompleted => 'Tamamlanan namazlar';

  @override
  String get insightsRestoreStreak => 'Seriyamı bərpa et — son 24 saat';

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
      'Namaz vaxtları, Quran və İslami rəhbər haqqında hər şeyi soruşun.';

  @override
  String get homeDay => 'gün';

  @override
  String get homeDays => 'Günlər';

  @override
  String get homeNoEventsFoundForDay => 'Bu gün üçün tədbir tapılmadı.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — belə qeyd et';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Vaxtında qılındı';

  @override
  String get homeMarkPrayerQada => 'Qəza (sonra qılındı)';

  @override
  String get homeMarkPrayerMissed => 'Buraxıldı';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return '$prayerName ayarları';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Namaz vaxtı';

  @override
  String get homePrayerSettingsNotification => 'Bildiriş';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Fəzilətlər, hökmlər və digər';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Bu ayarlar yalnız $prayerName üçündür. Hər namaz üçün fərqli seçimlər təyin edə bilərsiniz.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return '$prayerName vaxtını redaktə et';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Cari vaxt';

  @override
  String get homeEditPrayerTimeSelectNew => 'Yeni vaxt seçin';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Bu xüsusi vaxt yalnız $prayerName üçün keçərlidir. Yerli məscidiniz və ya hesablama fərqlidirsə, düzəldin.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Vaxtı yadda saxla';

  @override
  String get homeEditPrayerTimeReset => 'Hesablanmış vaxta sıfırla';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return '$prayerName üçün bildiriş';
  }

  @override
  String get homeNotificationSoundLabel => 'Bildiriş səsi';

  @override
  String get homeNotificationSoundFullAdhan => 'Tam azan';

  @override
  String get homeNotificationSoundFullAdhanSubtitle => 'Tam azanı oxut';

  @override
  String get homeNotificationSoundBeep => 'Siqnal';

  @override
  String get homeNotificationSoundBeepSubtitle => 'Qısa bildiriş tonu';

  @override
  String get homeNotificationSoundMute => 'Səssiz';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Səs yoxdur';

  @override
  String get homeNotificationEnableLabel => 'Bildirişi aktiv et';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return '$prayerName vaxtında bildiriş al';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return '$prayerName haqqında';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Vaxt';

  @override
  String get homeAboutPrayerRakatLabel => 'Rəkətlər';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Fəzilətlər';

  @override
  String get homeAboutPrayerReferenceLabel => 'İstinad';

  @override
  String get homeAboutFajrTiming =>
      'Həqiqi səhərdən (Fəcr-i Sadiq) başlayır və günəş çıxana qədər davam edir.';

  @override
  String get homeAboutFajrRakat => '2 sünnət + 2 fərz';

  @override
  String get homeAboutFajrVirtue =>
      'Kim sübh namazını qılarsa, Allahın himayəsindədir.';

  @override
  String get homeAboutFajrReference =>
      '«Sübhün iki rəkəti dünya və ondakılardan daha xeyirlidir.» (Səhih Müslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Günəş zeniti keçdikdən sonra başlayır və Əsrə qədər davam edir.';

  @override
  String get homeAboutDhuhrRakat => '4 sünnət + 4 fərz + 2 sünnət';

  @override
  String get homeAboutDhuhrVirtue =>
      'Allahın Cənnətdə ev tikdiyi gündəlik 12 nafil rəkətin bir hissəsidir.';

  @override
  String get homeAboutDhuhrReference =>
      '«Kim gündüz və gecə on iki rəkət qılarsa, onun üçün Cənnətdə bir ev tikilir.» (Səhih Müslim)';

  @override
  String get homeAboutAsrTiming =>
      'Bir əşyanın kölgəsi öz uzunluğuna bərabər olanda başlayır və gün batana qədər davam edir.';

  @override
  String get homeAboutAsrRakat => '4 fərz';

  @override
  String get homeAboutAsrVirtue =>
      'Bu namazı qorumaq xüsusi mükafat və xəbərdarlıqla seçilmişdir.';

  @override
  String get homeAboutAsrReference =>
      '«Kim əsr namazını qaçırarsa, sanki ailəsini və malını itirmiş kimidir.» (Səhih Buxari)';

  @override
  String get homeAboutMaghribTiming =>
      'Günəş batdıqdan dərhal sonra başlayır və qırmızı şəfəq yox olana qədər davam edir.';

  @override
  String get homeAboutMaghribRakat => '3 fərz + 2 sünnət';

  @override
  String get homeAboutMaghribVirtue =>
      'Duaların xüsusilə təşviq olunduğu vaxtdır.';

  @override
  String get homeAboutMaghribReference =>
      '«Oruc tutanın iki sevinci var... iftar etdikdə.» (Səhih Buxari, məğrib iftarı haqqında)';

  @override
  String get homeAboutIshaTiming =>
      'Şəfəq tam yox olduqdan sonra başlayır və gecə yarısına (bəzi görüşlərə görə Fəcrə) qədər davam edir.';

  @override
  String get homeAboutIshaRakat => '4 fərz + 2 sünnət + Vitir';

  @override
  String get homeAboutIshaVirtue =>
      'İşa namazını camaatla qılmaq gecənin yarısını ibadətlə keçirməyə bərabərdir.';

  @override
  String get homeAboutIshaReference =>
      '«Kim işanı camaatla qılarsa, sanki gecənin yarısını qılmış kimidir.» (Səhih Müslim)';

  @override
  String get backToOnboarding => 'Onboarding səhifəsinə qayıt';

  @override
  String get settings => 'Parametrlər';

  @override
  String get appLanguage => 'Proqram dili';

  @override
  String get tabHome => 'Ev';

  @override
  String get tabFocus => 'Fokus';

  @override
  String get tabTasbih => 'Təsbih';

  @override
  String get tabQuran => 'Quran';

  @override
  String get tabLearn => 'Öyrən';

  @override
  String get quranLoadFailed => 'Quran datasını yükləmək alınmadı';

  @override
  String get quranTabSubtitle => 'Qurani-Kərimi oxuyun və araşdırın';

  @override
  String get quranSearchHint => 'surə axtar...';

  @override
  String get quranNoSurahsFound => 'Heç bir surə tapılmadı';

  @override
  String get quranVersesLabel => 'misralar';

  @override
  String get quranTextOptions => 'Mətn seçimləri';

  @override
  String get quranEnglishAndArabic => 'İngilis və ərəb';

  @override
  String get quranArabicOnly => 'Yalnız ərəb';

  @override
  String get quranIncreaseFont => 'Şrifti artırın';

  @override
  String get quranDecreaseFont => 'Şrifti azaldın';

  @override
  String get quranPause => 'Fasilə';

  @override
  String get quranPlaySurah => 'Surə çalın';

  @override
  String get quranAudioNoInternet =>
      'İnternet bağlantısı yoxdur. Səs üçün internet lazımdır.';

  @override
  String get quranAudioTimeout =>
      'Səs yükləmə vaxtı bitdi. Bağlantınızı yoxlayın.';

  @override
  String get quranSurahLabel => 'surə';

  @override
  String get save => 'Saxla';

  @override
  String get tasbihBack => 'Geri';

  @override
  String get tasbihTabTitle => 'Təsbih';

  @override
  String get tasbihChooseOrAddSubtitle => 'Zikr seçin və ya özünüz yaradın';

  @override
  String get tasbihAddCustomTitle => 'Zikr əlavə edin';

  @override
  String get tasbihEditCustomTitle => 'Fərdi zikri redaktə edin';

  @override
  String get tasbihArabicOrDhikrHint => 'Ərəb mətni və ya hər hansı zikr';

  @override
  String get tasbihTransliterationOptionalHint =>
      'Transliterasiya (isteğe bağlı)';

  @override
  String get tasbihMeaningOptionalHint => 'Mənası (isteğe bağlı)';

  @override
  String get tasbihNoTransliteration => 'Transliterasiya yoxdur';

  @override
  String get tasbihTotalCount => 'Ümumi sayı';

  @override
  String get tasbihGrandTotalLabel => 'Ümumi təsbih';

  @override
  String get tasbihTapMe => 'Mənə toxunun';

  @override
  String get tasbihReset => 'Sıfırlayın';

  @override
  String get tasbihRestart => 'Yenidən başladın';

  @override
  String get tasbihCurrentCount => 'Cari say';

  @override
  String get tasbihResetTotal => 'Tarixçəni təmizləyin';

  @override
  String get focusModeActivated => 'Fokus rejimi aktivləşdirildi';

  @override
  String get focusSetUpHomeCardTitle => 'Fokus rejimini quraşdırın';

  @override
  String get focusTabSubtitle => 'Ən vacib məqamda diqqətinizi cəmləyin';

  @override
  String get focusChooseAppsEnableMode =>
      'Tətbiqləri seçin və fokus rejimini aktivləşdirin';

  @override
  String get focusNotifAppsLockedTitle => 'Tətbiqlər kilidlənib';

  @override
  String get focusNotifAppsUnlockedTitle => 'Tətbiqlər açılıb';

  @override
  String get focusNotifNightModeTitle => 'Gecə rejimi';

  @override
  String get focusNotifGoodMorningTitle => 'Sabahınız xeyir!';

  @override
  String get focusNotifAppsNowAvailableBody => 'Tətbiqlər indi əlçatandır.';

  @override
  String get focusNotifSalahLockedBody => 'Namaz zamanı tətbiqlər kilidlənir.';

  @override
  String get focusNotifSalahCompleteTitle => 'Namaz tamamlandı';

  @override
  String get focusNotifSalahCompleteBody =>
      'Tətbiqlər açıldı. Namazınız qəbul olsun.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return '$prayerName vaxtı';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return '$prayerName namazı üçün bir an ayırın.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Gecə rejimi aktivdir. Zehninizə və bədənizə istirahət verin.';

  @override
  String get focusNotifGenericLockedBody => 'Seçilmiş tətbiqlər kilidlənib.';

  @override
  String get focusNotifMorningUnlockBody => 'Tətbiqlər əlçatan deyil.';

  @override
  String get widgetDailyVerseTitle => 'Günün ayəsi';

  @override
  String get widgetOpenAppTimelineHint =>
      'Gündəlik ayə və namaz vidcet məlumatı üçün Deen Focus-u açın.';

  @override
  String get widgetSetLocationForPrayers =>
      'Namazlar və gündəlik ayə üçün Deen Focus-da yerinizi təyin edin.';

  @override
  String get focusChildModeActive => 'Uşaq Rejimi Aktivdir';

  @override
  String get focusSalahAndNightModeActive => 'Namaz və Gecə Rejimi Aktivdir';

  @override
  String get focusSalahModeActive => 'Salah rejimi aktivdir';

  @override
  String get focusNightModeActive => 'Gecə Rejimi Aktivdir';

  @override
  String get focusAppsToBlockTitle => 'Blok ediləcək proqramlar';

  @override
  String get focusAppliesAllModes => 'Bütün fokus rejimlərinə aiddir';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Proqramlara baxmaq və seçmək üçün Ekran Vaxtına giriş tələb olunur.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Davam etmək üçün əlçatanlıq açıqlamasını qəbul edin.';

  @override
  String get focusSelectAppsToBlock => 'Blok etmək üçün proqramları seçin';

  @override
  String get focusLoading => 'Yüklənir...';

  @override
  String get focusOpen => 'Açıq';

  @override
  String get focusHide => 'Gizlət';

  @override
  String get focusLoad => 'yük';

  @override
  String get focusShow => 'Göstər';

  @override
  String get focusSalahFocusModeTitle => 'Salah Fokus rejimi';

  @override
  String get focusBlockAppsDuringPrayer => 'Namaz zamanı proqramları bloklayın';

  @override
  String get focusNightDisciplineTitle => 'Gecə nizam-intizamı';

  @override
  String get focusSleepLabel => 'yatmaq';

  @override
  String get focusWakeLabel => 'Oyan';

  @override
  String get focusBlockAppsImmediately => 'Tətbiqləri dərhal bloklayın';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Android tətbiqinin bloklanmasını aktivləşdirin';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Android-də digər tətbiqləri bloklamaq üçün Deenly əlçatanlıq icazəsini aktiv etməlidir. Sizin üçün düzgün parametrlər ekranını açacağıq.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Əlçatanlıq icazəsinin açıqlanması';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly Fokus rejimi tətbiqinin bloklanmasını tətbiq etmək üçün Android Accessibility-dən istifadə edir.\n\nNiyə bizə lazımdır: bloklamaq üçün seçdiyiniz proqramı açdığınız zaman aşkar etmək.\n\nOnu necə istifadə edirik: yalnız ön planda olan tətbiqi müəyyən etmək və seçilmiş proqramlar üçün Fokus blok ekranını göstərmək üçün. Biz ondan çap olunmuş mətni və ya şəxsi məzmunu oxumaq üçün istifadə etmirik.';

  @override
  String get focusNotNow => 'İndi yox';

  @override
  String get focusIUnderstand => 'başa düşürəm';

  @override
  String get focusDone => 'Bitdi';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Daha yaxşı gecə vərdişləri yaradın';

  @override
  String get focusPrayerBlockingDescription =>
      'Tətbiqlər dua zamanı bloklanacaq və 15 dəqiqədən sonra avtomatik olaraq açılacaq və ya siz onları istənilən vaxt əsas ekrandan aça bilərsiniz.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Tətbiqlər dua zamanı bloklanacaq və ya siz onları istənilən vaxt əsas ekrandan aça bilərsiniz.';

  @override
  String get focusNightBlockingDescription =>
      'Tətbiqlər yuxu dövrünüz ərzində bloklanacaq və avtomatik kiliddən çıxarılacaq və ya siz onları istənilən vaxt əsas ekrandan aça bilərsiniz';

  @override
  String get focusChildBlockingDescription =>
      'Uşaq rejimində proqramlar dərhal bloklanır. Dəyişdiricidən və ya əsas ekrandan istifadə edərək onları kiliddən çıxarın';

  @override
  String get settingsEditUsername => 'İstifadəçi adını redaktə edin';

  @override
  String get settingsEnterYourName => 'Adınızı daxil edin';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Bütün xüsusiyyətlərin kilidini açın';

  @override
  String get settingsManageSubscriptionTitle => 'Abunəliyi idarə et';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Planı görün və ya ödənişi yeniləyin';

  @override
  String get settingsUsernameLabel => 'İstifadəçi adı';

  @override
  String get settingsLocationLabel => 'Məkan';

  @override
  String get settingsDarkModeLabel => 'Qaranlıq rejim';

  @override
  String get settingsAboutTitle => 'Deen Focus haqqında';

  @override
  String get settingsContactUsTitle => 'Bizimlə Əlaqə';

  @override
  String get settingsSavingLocation => 'Yadda saxlanılır...';

  @override
  String get settingsSaveLocation => 'Məkanı Saxla';

  @override
  String get settingsAboutTagline => 'Fokus. İntizam. Ardıcıllıq.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus müasir dünyada gündəlik diqqət yayındırıcıları idarə edərkən imanınıza bağlı qalmağınıza kömək edir.';

  @override
  String get settingsAboutFeature1 => 'Xatırlatmalarla namaz vaxtları';

  @override
  String get settingsAboutFeature2 => 'İstənilən vaxt qiblə istiqaməti';

  @override
  String get settingsAboutFeature3 => 'Gündəlik zikr üçün Quran və təsbih';

  @override
  String get settingsAboutFeature4 => 'Yaxınlıqdakı məscidlər';

  @override
  String get settingsAboutFeature5 =>
      'Namaz, yuxu və ailə vaxtı üçün ağıllı fokus rejimləri';

  @override
  String get settingsAboutFocusDescription =>
      'Ağıllı fokus rejimləri namaz, yuxu və mühüm anlar zamanı diqqət yayındırıcıları bloklamağa kömək edir ki, siz hazır və intizamlı qala biləsiniz.';

  @override
  String get settingsAboutFooter =>
      'Ardıcıl olun. Diqqətli olun.\nDininizə bağlı qalın.';

  @override
  String get settingsEnableSystemNotifications =>
      'Bunu aktiv etmək üçün sistem bildirişlərini aktiv edin.';

  @override
  String get appDemoTitle => 'Tətbiq Demo';

  @override
  String get appDemoLoadFailed => 'Demo videonu yükləmək mümkün olmadı.';

  @override
  String get appDemoRestartHint =>
      'Videonun tam tətbiqi yenidən başlatması lazımdır (isti yenidən başladın oxutma prosesini poza bilər).';

  @override
  String get appDemoPreviewLoadFailed => 'Demonu yükləmək mümkün olmadı.';

  @override
  String get appDemoTryAgain => 'Yenidən cəhd edin';

  @override
  String get appDemoWatchLabel => 'Demoya baxın';

  @override
  String get homeAiChatTitle => 'Deen Focus Süni İntellekt';

  @override
  String get homeAiAskQuestionHint => 'Sual verin...';

  @override
  String get homeAiSend => 'Göndər';

  @override
  String get homeAiErrorPrefix =>
      'Bağışlayın, Deen Focus AI-ə qoşularkən problemlə üzləşdim.';

  @override
  String get homeAiEmptyTitle => 'İslam haqqında hər şeyi soruşun';

  @override
  String get homeAiEmptySubtitle =>
      'Namaz vaxtları, Quran, Hədis, İslami hadisələr və mənəvi hidayət';

  @override
  String get onboardingTypeCityName => 'Şəhər adınızı yazın..';

  @override
  String get onboardingNoLocationsFound => 'Heç bir yer tapılmadı';

  @override
  String get onboardingTryAnotherCityName => 'Başqa bir şəhər adını sınayın.';

  @override
  String get qiblaCompassUnavailable => 'Kompas bu cihazda mövcud deyil';

  @override
  String get qiblaFacing => '✓ Üzü qibləyə';

  @override
  String get qiblaTurnToFind => 'Qibləni tapmaq üçün dönün';

  @override
  String get qiblaDistanceToMakkah => 'Məkkəyə olan məsafə';

  @override
  String get qiblaFromNorth => 'şimaldan';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Yaxınlıqda Məscidlər';

  @override
  String get nearbyMosquesTryAgain => 'Yenidən cəhd edin';

  @override
  String get nearbyMosquesOpenGoogle => 'Google Xəritədə açın';

  @override
  String get nearbyMosquesOpenApple => 'Apple Xəritələrində açın';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'İçərisində heç bir məscid tapılmadı';

  @override
  String get nearbyMosquesSearchRadius => 'Axtarış radiusu: 5 km';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Xəritənin önizləməsi hazırda əlçatan deyil.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Məkanınızı gözləyirik.';

  @override
  String get nearbyMosquesFetchingLocation => 'Məkanınız müəyyən edilir…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Cari məkan';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Nəticələr yükləndikdən sonra yaxınlıqdakı məscidlər burada görünəcək.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      '5 km məsafədə heç bir məscid tapılmadı';

  @override
  String get nearbyMosquesLocationRequired =>
      'Yaxınlıqdakı məscidləri tapmaq üçün məkana giriş tələb olunur.';

  @override
  String get nearbyMosquesPermissionOff =>
      'Məkan icazəsi söndürülüb. Yaxınlıqdakı məscidləri görmək üçün onu parametrlərdə aktiv edin.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'Hazırda mövcud yerinizi oxuya bilmədik.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'Canlı yeniləmə alınmadı. Son saxlanmış nəticələr göstərilir. Yeniləmək üçün çəkin.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Məkan girişi rədd edildi. Yaxınlıqdakı məscidləri görmək üçün onu Parametrlərdə aktiv edin.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'Məkan bu cihazda deaktiv edilib. Parametrlərdə onu yandırın, sonra yenidən cəhd edin.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'Məkan icazəsi hələ də işlənir. Lütfən, bir az sonra yenidən cəhd edin.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'Sorğu çox uzun çəkdi. İnternet bağlantınızı yoxlayın və yenidən cəhd edin.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'İnternet bağlantısı yoxdur və ya xidmət əlçatmazdır. Bağlantınızı yoxlayın və yenidən cəhd edin.';

  @override
  String get nearbyMosquesFormatError =>
      'Hazırda məscid siyahısını oxuya bilmirdik. Lütfən, sonra yenidən cəhd edin.';

  @override
  String get nearbyMosquesPlatformError =>
      'Biz bu addımı tamamlaya bilmədik. Bağlantınızı yoxlayın və yenidən cəhd edin.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Nəsə xəta baş verdi. Yenidən cəhd edin.';

  @override
  String get nearbyMosquesEmptyHint =>
      'Bu yer üçün OpenStreetMap-da 5 km məsafədə heç nə qeyd edilməyib. Daha sonra yenidən cəhd edin və ya xəritəni köçürün.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count məscidlər 5 km məsafədə tapıldı';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Zikr silinsin?';

  @override
  String get tasbihDelete => 'Sil';

  @override
  String get focusAndroidBlockingNotReady =>
      'Android tətbiq bloklaması hələ hazırlanır. Əlçatanlığı aktiv saxlayın və qoşulana qədər bir az gözləyin.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Tətbiq seçilməyib. Əvvəlcə bloklamaq üçün tətbiqləri seçin.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'iPhone-da tətbiqləri bloklamaq üçün Ekran vaxtına giriş tələb olunur.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Fokus rejimi yenilənərkən xəta baş verdi. Yenidən cəhd edin.';

  @override
  String get focusLoadingInstalledApps => 'Quraşdırılmış tətbiqlər yüklənir...';

  @override
  String get focusNoInstalledAppsToShow =>
      'Göstəriləcək quraşdırılmış tətbiq yoxdur.';

  @override
  String get homeAiSuggestion1 => 'Ramazan nədir?';

  @override
  String get homeAiSuggestion2 => 'Namaz vaxtları';

  @override
  String get homeAiSuggestion3 => 'Qur\'an oxuma planı';

  @override
  String get homeAiDeveloperPrompt =>
      'Siz bilikli və hörmətli bir islam alimi köməkçisisiniz. İstifadəçilərə islami ənənələr, bayramlar, namaz, Qur\'an təhsili və mənəvi təcrübələr öyrətməyə kömək edin. İsti, qısa, təhsilverici və mədəni həssas olun. İslami rəhbərlikdən kənar suallarda faydalı cavab verin, dini əminlik təqlid etməyin.';

  @override
  String get homeAiErrorMissingApiKey => 'API konfiqurasiyası yoxdur.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'API xətası $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Köməkçidən cavab gəlmədi.';

  @override
  String get homeAiErrorEmptyContent => 'Boş cavab məzmunu.';

  @override
  String get settingsPrayerCalculationSection => 'Namaz Hesabı';

  @override
  String get settingsCalculationMethodTitle => 'Hesab Metodu';

  @override
  String get settingsAsrCalculationTitle => 'Əsr Hesabı';

  @override
  String get calculationMethodSectionMajorOrgs => 'Əsas İslam Təşkilatları';

  @override
  String get calculationMethodSectionMiddleEast => 'Yaxın Şərq';

  @override
  String get calculationMethodSectionAsiaPacific => 'Asiya-Sakit Okean';

  @override
  String get calculationMethodSectionSpecial => 'Xüsusi Metodlar';

  @override
  String get asrMethodStandard => 'Standart';

  @override
  String get asrMethodStandardSubtitle => 'Şafi, Maliki, Hənbəli';

  @override
  String get asrMethodHanafi => 'Hənəfi';

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
