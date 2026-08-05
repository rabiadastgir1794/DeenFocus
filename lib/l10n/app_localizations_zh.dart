// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '德恩焦点';

  @override
  String get appTagline => '信仰。重点。一致性';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => '祈祷模式。儿童模式。睡眠模式。';

  @override
  String get welcomeDescription =>
      '跟踪您的祈祷、阅读《古兰经》、数数 Tasbih 并建立有意义的连续记录 — 所有这些都在一处完成。';

  @override
  String get skip => '跳过';

  @override
  String get notNow => '暂时不要';

  @override
  String get continueButton => '继续';

  @override
  String get continueForFree => '继续使用免费计划';

  @override
  String get getStarted => '解锁高级版';

  @override
  String get language => '语言';

  @override
  String get cancel => '取消';

  @override
  String get ok => '好的';

  @override
  String get openSettings => '打开设置';

  @override
  String get locationRequired => '需要位置';

  @override
  String get locationRequiredMessage =>
      '需要访问位置才能计算准确的祈祷时间和朝拜方向。您必须启用它才能使用该应用程序。';

  @override
  String get notificationsRequired => '需要通知';

  @override
  String get notificationsRequiredMessage => '需要通知才能接收祈祷时间警报和提醒。';

  @override
  String get sectTitle => '选择你的教派';

  @override
  String get sectSubtitle => '这有助于我们个性化您的体验';

  @override
  String get sectSunni => '逊尼派';

  @override
  String get sectShia => '什叶派';

  @override
  String get sectPreferNotToSay => '宁愿不说';

  @override
  String get nameTitle => '你叫什么名字？';

  @override
  String get nameSubtitle => '让我们个性化您的问候语';

  @override
  String get namePlaceholder => '你的名字';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => '允许位置访问';

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
  String get notificationsButton => '启用通知';

  @override
  String get notificationsEnabled => '通知已启用';

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
  String get screenTimeTitle => '启用屏幕使用时间';

  @override
  String get screenTimeSubtitle => '这让 Deen Focus 能在礼拜、睡眠时间和儿童模式下暂停分心应用。';

  @override
  String get screenTimeButton => '允许屏幕使用时间访问';

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
  String get focusPrayerModeTitle => '祈祷模式';

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
  String get focusSleepModeTitle => '睡眠模式';

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
  String get focusChildModeTitle => '儿童模式';

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
  String get investTitle => '投资你的迪恩';

  @override
  String get investSubtitle => '你不会三思而后行地花在咖啡或零食上......';

  @override
  String get investComparisonTitle => '升级高级版或继续免费使用';

  @override
  String get investDailyCoffee => '每日咖啡';

  @override
  String get investDailyCoffeePrice => '5 美元/天';

  @override
  String get investFastFood => '快餐';

  @override
  String get investFastFoodPrice => '\$10/餐';

  @override
  String get investYourDeen => '你的迪恩';

  @override
  String get investYourDeenPrice => '\$4.99/月';

  @override
  String get investComparisonQuote => '您不假思索地在小事上花费了 10 美元 - 为什么不投资您的 Deen 呢？';

  @override
  String get bestValueTag => '最超值';

  @override
  String get mostPopularChoice => '最受欢迎的选择';

  @override
  String get monthlyPriceValue => '4.99 美元';

  @override
  String get monthlyPriceSuffix => '/月';

  @override
  String get monthlyPlanSubtitle => '按月计费 • 随时取消';

  @override
  String get yearlyPriceValue => '24.99 美元';

  @override
  String get yearlyPriceSuffix => '/年';

  @override
  String get yearlyPlanSubtitle => '节省 50% • 按年计费';

  @override
  String get lifetimePriceValue => '79.99 美元';

  @override
  String get lifetimePriceSuffix => '寿命';

  @override
  String get lifetimePlanSubtitle => '一次性购买 • 永久访问';

  @override
  String get everythingYouGet => '你得到的一切';

  @override
  String get featureFocusModeAllModes => '具有全部 3 种模式的无限对焦模式';

  @override
  String get featurePrayerAnalyticsStreaks => '高级祷告分析和连续祷告';

  @override
  String get featureAiAssistant => 'AI伊斯兰助手';

  @override
  String get featurePrioritySupportEarlyAccess => '优先支持和抢先体验';

  @override
  String get socialProofPrefix => '加入';

  @override
  String get socialProofHighlight => '10,000+';

  @override
  String get socialProofSuffix => '穆斯林已经与 Deen Focus 一起成长';

  @override
  String get mostPopular => '最受欢迎';

  @override
  String get monthlyLabel => '每月';

  @override
  String get monthlyPrice => '4.99 美元/月 · 每月计费 · 随时取消';

  @override
  String get yearlyLabel => '每年';

  @override
  String get yearlyPrice => '24.99 美元/年 · 节省 50% · 按年计费';

  @override
  String get lifetimeLabel => '寿命';

  @override
  String get lifetimePrice => '终身使用 79.99 美元 · 一次性购买 · 永久使用';

  @override
  String get featurePrayerAnalytics => '高级祈祷分析';

  @override
  String get featureFocusMode => '无限对焦模式';

  @override
  String get featureMasjidMode => '清真寺自动模式';

  @override
  String get featureNoAds => '删除所有广告';

  @override
  String get featureSupport => '优先支持';

  @override
  String get homeTitle => '深利之家';

  @override
  String get homeSalam => '阿萨拉穆·阿拉库姆';

  @override
  String get homeDailyVerseFallback => '的确，有困难就会有轻松。';

  @override
  String get homeAppsLocked => '应用程序锁定';

  @override
  String get homeAppsUnlocked => '已解锁的应用程序';

  @override
  String get homeTapToUnlock => '点击可暂时解锁应用程序';

  @override
  String get homeTapToRelock => '立即点击即可重新锁定被阻止的应用程序';

  @override
  String get homeRelock => '重新锁定';

  @override
  String get homeUnlock => '开锁';

  @override
  String get homePrayerModeActive => '祈祷模式激活';

  @override
  String get homeActivatePrayerMode => '启动祈祷模式';

  @override
  String get homeAppsBlockedSubtitle => '应用程序被阻止。点击即可停用。';

  @override
  String get homeBlockDistractingApps => '在礼拜期间阻止分散注意力的应用程序。';

  @override
  String get homeQiblaDirection => '朝拜方向';

  @override
  String get homeLocationMissingForQibla => '启用位置来计算朝拜方向。';

  @override
  String get homeQiblaSubtitleGuiding => '引导您走向朝拜';

  @override
  String get homeToMakkah => '前往麦加';

  @override
  String get homeFindMasjid => '查找我附近的清真寺';

  @override
  String get quickActionsMasjidFinder => '找清真寺';

  @override
  String get homeSearchNearbyMosques => '搜索附近的清真寺。';

  @override
  String get homePrayerStreak => '祈祷连胜';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => '洞察';

  @override
  String get homeOpenStreakDetails => '打开条纹细节。';

  @override
  String get homeTodaysPrayers => '今天的祈祷';

  @override
  String get homePrayerTimesUnavailable => '目前无法进行祈祷时间。';

  @override
  String get homeNextPrayerIn => '下一个祷告在';

  @override
  String get homePrayerFajr => '晨曦';

  @override
  String get homePrayerSunrise => '日出';

  @override
  String get homePrayerDhuhr => '杜尔';

  @override
  String get homePrayerAsr => '晡气';

  @override
  String get homePrayerMaghrib => '昏礼';

  @override
  String get homePrayerIsha => '伊莎';

  @override
  String get homeWeek => '星期';

  @override
  String get homeMonth => '月';

  @override
  String get homeThisWeek => '迪恩本周亮点';

  @override
  String get homeJummahMubarak => '朱玛·穆巴拉克';

  @override
  String get homeJummahReminder => '不要忘记《Surah Al-Kahf》。';

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
      '在此期间，您的礼拜连续记录会受到保护。经期日以粉色标示，周期结束后周期模式会自动关闭。';

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
  String get cycleModeSettingsTitle => '周期模式';

  @override
  String get cycleModeStartDateLabel => '开始日期';

  @override
  String get cycleModeLengthLabel => '周期长度';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
      one: '1 天',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => '暂停连续记录';

  @override
  String get cycleModeExcludeFromStatisticsLabel => '不计入统计';

  @override
  String get cycleModeSaveButton => '保存';

  @override
  String get cycleModeEditButton => '编辑';

  @override
  String get cycleModeChangeStartDateTitle => '更改开始日期？';

  @override
  String get cycleModeChangeStartDateMessage =>
      '更改开始日期将重新计算当前的周期模式区间。新范围之外的日期可能不再被视为周期日。';

  @override
  String get cycleModeChangeStartDateConfirm => '更改开始日期';

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
  String get dailyChecklistSectionPrayer => '礼拜';

  @override
  String get dailyChecklistSectionQuranDhikr => '古兰经与记念';

  @override
  String get dailyChecklistSectionGoodDeeds => '善行';

  @override
  String get dailyChecklistSectionDistraction => '分心控制';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => '夜功拜';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => '晚间记主词';

  @override
  String get dailyChecklistDhikr => '记念';

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
  String get focusScoreTitle => '今日专注分数';

  @override
  String get focusScorePrayer => '礼拜';

  @override
  String get focusScoreQuran => '古兰经';

  @override
  String get focusScoreDhikr => '记念';

  @override
  String get focusScoreDistraction => '分心控制';

  @override
  String get insightsBack => '返回';

  @override
  String get insightsTitle => '我的洞察';

  @override
  String get insightsSubtitle => '追踪你的信仰进度';

  @override
  String get insightsPrayerRate => '礼拜完成率';

  @override
  String get insightsDayStreak => '连续天数';

  @override
  String get insightsBestStreak => '最佳连续';

  @override
  String get insightsWeekly => '每周';

  @override
  String get insightsMonthly => '每月';

  @override
  String get insightsPrayersCompleted => '已完成礼拜';

  @override
  String get insightsRestoreStreak => '恢复连续记录 — 最近 24 小时';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return '礼拜 $prayerPercent% · 古兰经 $quranPercent% · 记念 $dhikrPercent% · 分心 $distractionPercent%';
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
  String get homeAiChatDescription => '询问有关祈祷时间、古兰经和伊斯兰教指导的任何问题。';

  @override
  String get homeDay => '天';

  @override
  String get homeDays => '天';

  @override
  String get homeNoEventsFoundForDay => '没有找到这一天的活动。';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — 标记为';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => '按时完成';

  @override
  String get homeMarkPrayerQada => '补拜（卡达）';

  @override
  String get homeMarkPrayerMissed => '错过';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return '$prayerName设置';
  }

  @override
  String get homePrayerSettingsPrayerTime => '礼拜时间';

  @override
  String get homePrayerSettingsNotification => '通知';

  @override
  String get homePrayerSettingsAboutSubtitle => '美德、教法规定等';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return '这些设置仅适用于$prayerName。你可以为每番拜功设置不同偏好。';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return '编辑$prayerName时间';
  }

  @override
  String get homeEditPrayerTimeCurrent => '当前时间';

  @override
  String get homeEditPrayerTimeSelectNew => '选择新时间';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return '此自定义时间仅适用于$prayerName。若本地清真寺或计算结果不同，请调整。';
  }

  @override
  String get homeEditPrayerTimeSave => '保存时间';

  @override
  String get homeEditPrayerTimeReset => '重置为计算时间';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return '$prayerName通知';
  }

  @override
  String get homeNotificationSoundLabel => '通知声音';

  @override
  String get homeNotificationSoundFullAdhan => '完整唤拜';

  @override
  String get homeNotificationSoundFullAdhanSubtitle => '播放完整唤拜（阿赞）';

  @override
  String get homeNotificationSoundBeep => '提示音';

  @override
  String get homeNotificationSoundBeepSubtitle => '简短通知提示音';

  @override
  String get homeNotificationSoundMute => '静音';

  @override
  String get homeNotificationSoundMuteSubtitle => '无声音';

  @override
  String get homeNotificationEnableLabel => '启用通知';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return '在$prayerName时间收到通知';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return '关于$prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => '时间';

  @override
  String get homeAboutPrayerRakatLabel => '拜数';

  @override
  String get homeAboutPrayerVirtuesLabel => '美德';

  @override
  String get homeAboutPrayerReferenceLabel => '参考';

  @override
  String get homeAboutFajrTiming => '始于真正黎明（晨礼真光）并止于日出。';

  @override
  String get homeAboutFajrRakat => '2圣行 + 2主命';

  @override
  String get homeAboutFajrVirtue => '谁礼了晨礼，便在安拉的护佑之下。';

  @override
  String get homeAboutFajrReference => '「晨礼的两拜胜过整个世界及其所含。」（《穆斯林圣训实录》）';

  @override
  String get homeAboutDhuhrTiming => '始于太阳过中天，持续至晡礼开始。';

  @override
  String get homeAboutDhuhrRakat => '4圣行 + 4主命 + 2圣行';

  @override
  String get homeAboutDhuhrVirtue => '每日十二拜副功之一，安拉因此在乐园中为其建屋。';

  @override
  String get homeAboutDhuhrReference => '「谁昼夜礼十二拜，安拉便在乐园中为其建屋。」（《穆斯林圣训实录》）';

  @override
  String get homeAboutAsrTiming => '始于物体阴影等于其长度之时，持续至日落。';

  @override
  String get homeAboutAsrRakat => '4主命';

  @override
  String get homeAboutAsrVirtue => '守护此拜尤其受到嘉奖与警示。';

  @override
  String get homeAboutAsrReference => '「谁错过晡礼，犹如失去了家人和财产。」（《布哈里圣训实录》）';

  @override
  String get homeAboutMaghribTiming => '始于日落后即刻，持续至红色晚霞消失。';

  @override
  String get homeAboutMaghribRakat => '3主命 + 2圣行';

  @override
  String get homeAboutMaghribVirtue => '尤其鼓励祈祷（杜阿）的时辰。';

  @override
  String get homeAboutMaghribReference => '「斋戒者有两喜……开斋之时。」（《布哈里圣训实录》，关于昏礼开斋）';

  @override
  String get homeAboutIshaTiming => '始于晚霞完全消失，持续至午夜（一说至晨礼，观点有异）。';

  @override
  String get homeAboutIshaRakat => '4主命 + 2圣行 + 奇数年拜（维特尔）';

  @override
  String get homeAboutIshaVirtue => '集体礼宵礼等同于立站半夜。';

  @override
  String get homeAboutIshaReference => '「谁集体礼了宵礼，犹如立站了半夜。」（《穆斯林圣训实录》）';

  @override
  String get backToOnboarding => '返回入职';

  @override
  String get settings => '设置';

  @override
  String get appLanguage => '应用程序语言';

  @override
  String get tabHome => '家';

  @override
  String get tabFocus => '重点';

  @override
  String get tabTasbih => '塔斯比赫';

  @override
  String get tabQuran => '古兰经';

  @override
  String get tabLearn => '学习';

  @override
  String get quranLoadFailed => '无法加载古兰经数据';

  @override
  String get quranTabSubtitle => '阅读并探索《古兰经》';

  @override
  String get quranSearchHint => '搜索古兰经...';

  @override
  String get quranNoSurahsFound => '没有找到古兰经';

  @override
  String get quranVersesLabel => '诗句';

  @override
  String get quranTextOptions => '文本选项';

  @override
  String get quranEnglishAndArabic => '英语和阿拉伯语';

  @override
  String get quranArabicOnly => '仅限阿拉伯语';

  @override
  String get quranIncreaseFont => '增加字体';

  @override
  String get quranDecreaseFont => '减小字体';

  @override
  String get quranPause => '暂停';

  @override
  String get quranPlaySurah => '播放古兰经';

  @override
  String get quranAudioNoInternet => '无网络连接。播放音频需要网络。';

  @override
  String get quranAudioTimeout => '音频加载超时。请检查您的网络连接。';

  @override
  String get quranSurahLabel => '古兰经';

  @override
  String get save => '节省';

  @override
  String get tasbihBack => '后退';

  @override
  String get tasbihTabTitle => '塔斯比赫';

  @override
  String get tasbihChooseOrAddSubtitle => '选择一个dhikr或创建您自己的';

  @override
  String get tasbihAddCustomTitle => '添加迪克尔';

  @override
  String get tasbihEditCustomTitle => '编辑自定义迪克尔';

  @override
  String get tasbihArabicOrDhikrHint => '阿拉伯文字或任何 dhikr';

  @override
  String get tasbihTransliterationOptionalHint => '音译（可选）';

  @override
  String get tasbihMeaningOptionalHint => '含义（可选）';

  @override
  String get tasbihNoTransliteration => '无音译';

  @override
  String get tasbihTotalCount => '总计数';

  @override
  String get tasbihGrandTotalLabel => '总塔斯比赫';

  @override
  String get tasbihTapMe => '点按我';

  @override
  String get tasbihReset => '重置';

  @override
  String get tasbihRestart => '重新启动';

  @override
  String get tasbihCurrentCount => '当前计数';

  @override
  String get tasbihResetTotal => '清除历史记录';

  @override
  String get focusModeActivated => '对焦模式已激活';

  @override
  String get focusSetUpHomeCardTitle => '设置专注模式';

  @override
  String get focusTabSubtitle => '在最重要的时候保持专注';

  @override
  String get focusChooseAppsEnableMode => '选择应用并启用专注模式';

  @override
  String get focusNotifAppsLockedTitle => '应用已锁定';

  @override
  String get focusNotifAppsUnlockedTitle => '应用已解锁';

  @override
  String get focusNotifNightModeTitle => '夜间模式';

  @override
  String get focusNotifGoodMorningTitle => '早上好！';

  @override
  String get focusNotifAppsNowAvailableBody => '应用现在可用。';

  @override
  String get focusNotifSalahLockedBody => '礼拜期间应用已锁定。';

  @override
  String get focusNotifSalahCompleteTitle => '礼拜完成';

  @override
  String get focusNotifSalahCompleteBody => '应用已解锁。愿您的主接受您的礼拜。';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return '$prayerName时间';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return '为$prayerName礼拜留出片刻。';
  }

  @override
  String get focusNotifNightLockedBody => '夜间模式已开启。让身心休息。';

  @override
  String get focusNotifGenericLockedBody => '所选应用已锁定。';

  @override
  String get focusNotifMorningUnlockBody => '应用不可用。';

  @override
  String get widgetDailyVerseTitle => '每日经文';

  @override
  String get widgetOpenAppTimelineHint => '打开 Deen Focus 以准备每日经文和礼拜小组件数据。';

  @override
  String get widgetSetLocationForPrayers => '在 Deen Focus 中设置位置以加载礼拜和每日经文。';

  @override
  String get focusChildModeActive => '儿童模式激活';

  @override
  String get focusSalahAndNightModeActive => '萨拉赫和夜间模式激活';

  @override
  String get focusSalahModeActive => '萨拉赫模式激活';

  @override
  String get focusNightModeActive => '夜间模式激活';

  @override
  String get focusAppsToBlockTitle => '要阻止的应用程序';

  @override
  String get focusAppliesAllModes => '适用于所有对焦模式';

  @override
  String get focusScreenTimeRequiredSelectApps => '需要访问“屏幕时间”才能查看和选择应用程序。';

  @override
  String get focusAcceptAccessibilityDisclosure => '请接受无障碍披露以继续。';

  @override
  String get focusSelectAppsToBlock => '选择要阻止的应用程序';

  @override
  String get focusLoading => '加载中...';

  @override
  String get focusOpen => '打开';

  @override
  String get focusHide => '隐藏';

  @override
  String get focusLoad => '加载';

  @override
  String get focusShow => '展示';

  @override
  String get focusSalahFocusModeTitle => '萨拉赫聚焦模式';

  @override
  String get focusBlockAppsDuringPrayer => '祈祷期间阻止应用程序';

  @override
  String get focusNightDisciplineTitle => '夜间纪律';

  @override
  String get focusSleepLabel => '睡觉';

  @override
  String get focusWakeLabel => '唤醒';

  @override
  String get focusBlockAppsImmediately => '立即阻止应用程序';

  @override
  String get focusEnableAndroidAppBlocking => '启用 Android 应用程序阻止';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      '要阻止 Android 上的其他应用程序，Deenly 需要打开其辅助功能权限。我们将为您打开正确的设置屏幕。';

  @override
  String get focusAccessibilityDisclosureTitle => '无障碍权限披露';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly 使用 Android Accessibility 强制执行焦点模式应用程序阻止。\n\n为什么我们需要它：检测您何时打开选择阻止的应用程序。\n\n我们如何使用它：仅识别前台应用程序并显示所选应用程序的焦点块屏幕。我们不会用它来阅读键入的文本或个人内容。';

  @override
  String get focusNotNow => '现在不要';

  @override
  String get focusIUnderstand => '我明白';

  @override
  String get focusDone => '完毕';

  @override
  String get focusNightDisciplineCardSubtitle => '养成更好的夜间习惯';

  @override
  String get focusPrayerBlockingDescription =>
      '应用程序将在祈祷期间被阻止，并在 15 分钟后自动解锁，或者您可以随时从主屏幕解锁它们。';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      '应用程序将在祈祷期间被阻止，或者您可以随时从主屏幕解锁它们。';

  @override
  String get focusNightBlockingDescription =>
      '应用程序将在您的睡眠周期期间被阻止并自动解锁，或者您可以随时从主屏幕解锁它们';

  @override
  String get focusChildBlockingDescription =>
      '应用程序在儿童模式下会立即被阻止。使用切换开关或从主屏幕解锁它们';

  @override
  String get settingsEditUsername => '编辑用户名';

  @override
  String get settingsEnterYourName => '输入你的名字';

  @override
  String get settingsPremiumTitle => 'Deen Focus 高级版';

  @override
  String get settingsPremiumSubtitle => '解锁所有功能';

  @override
  String get settingsManageSubscriptionTitle => '管理订阅';

  @override
  String get settingsManageSubscriptionSubtitle => '查看方案或更新账单';

  @override
  String get settingsUsernameLabel => '用户名';

  @override
  String get settingsLocationLabel => '地点';

  @override
  String get settingsDarkModeLabel => '深色模式';

  @override
  String get settingsAboutTitle => '关于德恩焦点';

  @override
  String get settingsContactUsTitle => '联系我们';

  @override
  String get settingsSavingLocation => '保存...';

  @override
  String get settingsSaveLocation => '保存位置';

  @override
  String get settingsAboutTagline => '重点。纪律。一致性。';

  @override
  String get settingsAboutDescription =>
      'Deen Focus 帮助您在现代世界中管理日常干扰的同时保持与信仰的联系。';

  @override
  String get settingsAboutFeature1 => '祈祷时间提醒';

  @override
  String get settingsAboutFeature2 => '随时查看朝拜方向';

  @override
  String get settingsAboutFeature3 => '古兰经和塔斯比哈进行每日齐克尔';

  @override
  String get settingsAboutFeature4 => '附近的清真寺';

  @override
  String get settingsAboutFeature5 => '用于礼拜、睡眠和家庭时间的智能专注模式';

  @override
  String get settingsAboutFocusDescription =>
      '智能专注模式帮助您在礼拜、睡眠和重要时刻屏蔽干扰，让您保持专注和自律。';

  @override
  String get settingsAboutFooter => '保持一致。保持专注。\n保持与您的信仰的联系。';

  @override
  String get settingsEnableSystemNotifications => '启用系统通知以打开此功能。';

  @override
  String get appDemoTitle => '应用程序演示';

  @override
  String get appDemoLoadFailed => '无法加载演示视频。';

  @override
  String get appDemoRestartHint => '视频需要完全重启应用程序（热重启可能会中断播放）。';

  @override
  String get appDemoPreviewLoadFailed => '无法加载演示。';

  @override
  String get appDemoTryAgain => '再试一次';

  @override
  String get appDemoWatchLabel => '观看演示';

  @override
  String get homeAiChatTitle => 'Deen Focus 人工智能';

  @override
  String get homeAiAskQuestionHint => '问一个问题...';

  @override
  String get homeAiSend => '发送';

  @override
  String get homeAiErrorPrefix => '抱歉，我在连接 Deen Focus AI 时遇到了问题。';

  @override
  String get homeAiEmptyTitle => '询问有关伊斯兰教的任何问题';

  @override
  String get homeAiEmptySubtitle => '祈祷时间、古兰经、圣训、伊斯兰活动和精神指导';

  @override
  String get onboardingTypeCityName => '输入您的城市名称..';

  @override
  String get onboardingNoLocationsFound => '没有找到地点';

  @override
  String get onboardingTryAnotherCityName => '尝试另一个城市名称。';

  @override
  String get qiblaCompassUnavailable => '指南针在此设备上不可用';

  @override
  String get qiblaFacing => '✓ 面向朝拜';

  @override
  String get qiblaTurnToFind => '转身寻找朝拜';

  @override
  String get qiblaDistanceToMakkah => '到麦加的距离';

  @override
  String get qiblaFromNorth => '从北';

  @override
  String get qiblaNorthShort => '氮';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => '乙';

  @override
  String get qiblaWestShort => '瓦';

  @override
  String get nearbyMosquesTitle => '附近的清真寺';

  @override
  String get nearbyMosquesTryAgain => '再试一次';

  @override
  String get nearbyMosquesOpenGoogle => '在 Google 地图中打开';

  @override
  String get nearbyMosquesOpenApple => '在苹果地图中打开';

  @override
  String get nearbyMosquesNoMosquesFoundWithin => '境内未发现清真寺';

  @override
  String get nearbyMosquesSearchRadius => '搜索半径：5公里';

  @override
  String get nearbyMosquesMapPreviewUnavailable => '地图预览目前不可用。';

  @override
  String get nearbyMosquesWaitingForLocation => '等待你的位置。';

  @override
  String get nearbyMosquesFetchingLocation => '正在获取您的位置…';

  @override
  String get nearbyMosquesCurrentLocationLabel => '当前位置';

  @override
  String get nearbyMosquesAppearAfterLoad => '结果加载后，附近的清真寺将出现在此处。';

  @override
  String get nearbyMosquesNoneWithinRadius => '5公里内未发现清真寺';

  @override
  String get nearbyMosquesLocationRequired => '需要访问位置才能找到附近的清真寺。';

  @override
  String get nearbyMosquesPermissionOff => '位置权限已关闭。在设置中启用它即可查看附近的清真寺。';

  @override
  String get nearbyMosquesLocationUnavailable => '我们现在无法读取您当前的位置。';

  @override
  String get nearbyMosquesLiveUpdateFailed => '实时更新失败。显示最后保存的结果。拉动即可刷新。';

  @override
  String get nearbyMosquesPermissionDenied => '位置访问被拒绝。在“设置”中启用它即可查看附近的清真寺。';

  @override
  String get nearbyMosquesLocationTurnedOff => '此设备上的位置已关闭。在“设置”中将其打开，然后重试。';

  @override
  String get nearbyMosquesPermissionProcessing => '位置许可仍在处理中。请稍后重试。';

  @override
  String get nearbyMosquesRequestTimeout => '该请求花费的时间太长。检查您的互联网连接，然后重试。';

  @override
  String get nearbyMosquesOfflineOrUnreachable => '没有互联网连接或服务无法访问。检查您的连接并重试。';

  @override
  String get nearbyMosquesFormatError => '我们现在无法阅读清真寺列表。请稍后重试。';

  @override
  String get nearbyMosquesPlatformError => '我们无法完成这一步。检查您的连接并重试。';

  @override
  String get nearbyMosquesSomethingWentWrong => '出了点问题。请再试一次。';

  @override
  String get nearbyMosquesEmptyHint =>
      'OpenStreetMap 上 5 公里范围内没有列出该地点的信息。稍后重试或移动地图。';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '5 公里内发现 $count 座清真寺';
  }

  @override
  String get tasbihDeleteDhikrTitle => '删除迪克尔？';

  @override
  String get tasbihDelete => '删除';

  @override
  String get focusAndroidBlockingNotReady =>
      'Android 应用拦截仍在准备中。请保持无障碍已开启，稍等片刻以完成连接。';

  @override
  String get focusNoAppsSelectedSnack => '未选择应用。请先选择要拦截的应用。';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      '在 iPhone 上拦截应用需要“屏幕使用时间”权限。';

  @override
  String get focusModeUpdateFailedSnack => '更新专注模式时出错，请重试。';

  @override
  String get focusLoadingInstalledApps => '正在加载已安装应用...';

  @override
  String get focusNoInstalledAppsToShow => '没有可显示的已安装应用。';

  @override
  String get homeAiSuggestion1 => '什么是斋月？';

  @override
  String get homeAiSuggestion2 => '礼拜时间';

  @override
  String get homeAiSuggestion3 => '古兰经阅读计划';

  @override
  String get homeAiDeveloperPrompt =>
      '你是一位博学且恭敬的伊斯兰学者助手。帮助用户了解伊斯兰传统、节日、礼拜、古兰经学习与灵修实践。语气温暖、简洁、有教益并尊重文化差异。若问题超出伊斯兰指导范围，请务实作答，不要假装宗教上的定论。';

  @override
  String get homeAiErrorMissingApiKey => '缺少 API 配置。';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'API 错误 $statusCode：$detail';
  }

  @override
  String get homeAiErrorEmptyResponse => '助手未返回回复。';

  @override
  String get homeAiErrorEmptyContent => '回复内容为空。';

  @override
  String get settingsPrayerCalculationSection => '礼拜计算';

  @override
  String get settingsCalculationMethodTitle => '计算方法';

  @override
  String get settingsAsrCalculationTitle => '晡礼计算';

  @override
  String get calculationMethodSectionMajorOrgs => '主要伊斯兰组织';

  @override
  String get calculationMethodSectionMiddleEast => '中东';

  @override
  String get calculationMethodSectionAsiaPacific => '亚太地区';

  @override
  String get calculationMethodSectionSpecial => '特殊方法';

  @override
  String get asrMethodStandard => '标准';

  @override
  String get asrMethodStandardSubtitle => '沙菲仪、马立克、罕百里';

  @override
  String get asrMethodHanafi => '哈乃斐';

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
