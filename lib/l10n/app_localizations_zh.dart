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
  String get welcomeGreeting => '安塞拉姆·阿莱库姆';

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
  String get continueForFree => '稍后再说 — 先探索应用';

  @override
  String get getStarted => '开始我的7天免费试用';

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
  String get locationTitle => '找到你的朝拜方向';

  @override
  String get locationSubtitle => '开启定位以获取准确的朝拜方向、礼拜时间与附近清真寺。';

  @override
  String get locationButton => '允许位置访问';

  @override
  String get locationManualEntry => '手动输入你的城市';

  @override
  String get locationOrDivider => '或';

  @override
  String get locationPrivacyNote => '仅保存在你的设备上';

  @override
  String get locationFeaturePrayerTimesTitle => '礼拜时间';

  @override
  String get locationFeatureQiblaTitle => '朝拜方向';

  @override
  String get locationFeatureMasjidsTitle => '清真寺';

  @override
  String get notificationsTitle => '不错过每一次礼拜';

  @override
  String get notificationsSubtitle => '唤礼提醒、专注提醒与每日记主——在你需要时送达。';

  @override
  String get notificationsButton => '启用通知';

  @override
  String get notificationsMaybeLater => '稍后再说';

  @override
  String get notificationsEnabled => '通知已启用';

  @override
  String get notificationsPreviewDate => '7月10日，星期五';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => '现在';

  @override
  String get notificationsPreviewMinutesAgo => '2分钟前';

  @override
  String get notificationsPreviewHourAgo => '1小时前';

  @override
  String get notificationsPreviewAdhanTitle => '昏礼唤礼';

  @override
  String get notificationsPreviewAdhanBody => '礼拜时间到了。';

  @override
  String get notificationsPreviewDhikrTitle => '每日记主';

  @override
  String get notificationsPreviewDhikrBody => 'سبحان الله — 静心片刻。';

  @override
  String get notificationsPreviewStreakTitle => '连续记录';

  @override
  String get notificationsPreviewStreakBody => '已连续完整礼拜 7 天。';

  @override
  String get screenTimeTitle => '启用屏幕使用时间';

  @override
  String get screenTimeSubtitle => '这让 Deen Focus 能在礼拜、睡眠时间和儿童模式下暂停分心应用。';

  @override
  String get screenTimeButton => '允许屏幕使用时间访问';

  @override
  String get screenTimePrivacyNote => 'Deen Focus 绝不会读取你的数据——只会暂停你选择的应用。';

  @override
  String get onboardingSelectAppsTitlePrefix => '选择';

  @override
  String get onboardingSelectAppsTitleAccent => '要锁定的应用';

  @override
  String get onboardingSelectAppsSubtitle => '选择祷告时要锁定的应用。';

  @override
  String get onboardingSelectAppsButton => '选择应用';

  @override
  String get onboardingSelectAppsSkipForNow => '暂时跳过';

  @override
  String get onboardingSelectAppsPrivacyTitle => '由你掌控';

  @override
  String get onboardingSelectAppsPrivacyBody => '我们从不读取你的数据。只会锁定你选择的应用。';

  @override
  String get onboardingSelectAppsMockAllApps => '所有应用和类别';

  @override
  String get onboardingSelectAppsMockPhotos => '照片';

  @override
  String get onboardingSelectAppsMockNotes => '备忘录';

  @override
  String get onboardingSelectAppsMockMusic => '音乐';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => '播客';

  @override
  String screenTimeStepOf(int current, int total) {
    return '第 $current 步，共 $total 步';
  }

  @override
  String get screenTimeStep1Title => '打开屏幕使用时间提示';

  @override
  String get screenTimeStep1Body => '点按「允许屏幕使用时间访问」——设备会显示自己的权限请求。';

  @override
  String get screenTimeStep2Title => '点按继续，然后允许';

  @override
  String get screenTimeStep2Body => '批准请求，以便 Deen Focus 能在合适的时机暂停应用。';

  @override
  String get screenTimeStep3Title => '选择要锁定的应用';

  @override
  String get screenTimeStep3Body => '挑选最容易让你分心的应用——社交、游戏、视频等。';

  @override
  String get screenTimeStep4Title => '你已受保护';

  @override
  String get screenTimeStep4Body => '应用会在礼拜、睡眠时间和儿童模式下自动锁定。';

  @override
  String get screenTimePromptTitle => '屏幕使用时间';

  @override
  String screenTimePromptMessage(String appName) {
    return '「$appName」想访问屏幕使用时间';
  }

  @override
  String get screenTimeDontAllow => '不允许';

  @override
  String get screenTimePromptContinue => '继续';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => '游戏';

  @override
  String get screenTimeAndroidStep1Title => '打开使用情况访问权限';

  @override
  String get screenTimeAndroidStep1Body =>
      '点按「允许屏幕使用时间访问」——设备将为 Deen Focus 打开使用情况访问。';

  @override
  String get screenTimeAndroidStep2Title => '启用无障碍功能';

  @override
  String get screenTimeAndroidStep2Body =>
      '开启 Deen Focus 服务，以便在礼拜、睡眠和儿童模式下暂停应用。';

  @override
  String get screenTimeAndroidStep3Title => '选择要锁定的应用';

  @override
  String get screenTimeAndroidStep3Body => '挑选最容易让你分心的应用——社交、游戏、视频等。';

  @override
  String get screenTimeAndroidStep4Title => '你已受保护';

  @override
  String get screenTimeAndroidStep4Body => '应用会在礼拜、睡眠时间和儿童模式下自动锁定。';

  @override
  String get screenTimeAndroidUsageTitle => '使用情况访问权限';

  @override
  String get screenTimeAndroidUsageMessage => '允许 Deen Focus 跟踪其他应用的使用情况。';

  @override
  String get screenTimeAndroidAccessibilityTitle => '无障碍';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus 需要无障碍权限，才能在专注时段暂停分心应用。';

  @override
  String get screenTimeAndroidPermit => '允许';

  @override
  String get screenTimeAndroidEnable => '启用';

  @override
  String get screenTimeAndroidNotNow => '暂不';

  @override
  String get focusModesTitle => '一站式功能合集';

  @override
  String get focusModesSubtitle => '探索 Deen Focus 提供的一切。点按专注模式了解其工作方式。';

  @override
  String get focusModesSectionLabel => '专注模式 · 点按了解更多';

  @override
  String get focusPrayerTrackingSectionLabel => '礼拜与追踪';

  @override
  String get focusLearningHubSectionLabel => '学习中心';

  @override
  String get focusMoreSectionLabel => '更多';

  @override
  String get focusPrayerModeTitle => '祈祷模式';

  @override
  String get focusPrayerModeDescription => '在礼拜期间自动屏蔽分心应用，让你能以充分的专注（khushu）祈祷。';

  @override
  String get focusPrayerModeBullet1 => '礼拜时间自动锁定应用';

  @override
  String get focusPrayerModeBullet2 => '完成后自动解锁';

  @override
  String get focusPrayerModeBullet3 => '培养专注与坚持';

  @override
  String get focusSleepModeTitle => '睡眠模式';

  @override
  String get focusSleepModeDescription => '以清真的方式放松。睡前屏蔽应用，好好休息并按时起床做晨礼。';

  @override
  String get focusSleepModeBullet1 => '睡前自动屏蔽应用';

  @override
  String get focusSleepModeBullet2 => '温和的晨礼起床提醒';

  @override
  String get focusSleepModeBullet3 => '守护你的睡眠与晨礼';

  @override
  String get focusChildModeTitle => '儿童模式';

  @override
  String get focusChildModeDescription => '要把手机给孩子？立即锁定应用，让他们只能看到安全内容。';

  @override
  String get focusChildModeBullet1 => '一键安全模式';

  @override
  String get focusChildModeBullet2 => '密码保护退出';

  @override
  String get focusChildModeBullet3 => '每次都安心';

  @override
  String get focusModeGotIt => '知道了';

  @override
  String get focusFeaturePrayerTimesTitle => '精准礼拜时间';

  @override
  String get focusFeaturePrayerTimesSubtitle => '唤礼与提醒';

  @override
  String get focusFeatureStreaksTitle => '连续记录';

  @override
  String get focusFeatureStreaksSubtitle => '保持坚持';

  @override
  String get focusFeatureChecklistTitle => '每日清单';

  @override
  String get focusFeatureChecklistSubtitle => '培养好习惯';

  @override
  String get focusFeatureQiblaTitle => '朝拜与清真寺';

  @override
  String get focusFeatureQiblaSubtitle => '方向与清真寺';

  @override
  String get focusFeatureQuranTitle => '古兰经';

  @override
  String get focusFeatureQuranSubtitle => '译文、卷次与页码';

  @override
  String get focusFeatureHadithTitle => '圣训';

  @override
  String get focusFeatureHadithSubtitle => '可靠圣训集';

  @override
  String get focusFeatureDuasTitle => '都阿';

  @override
  String get focusFeatureDuasSubtitle => '日常祈祷';

  @override
  String get focusFeatureTasbihTitle => '赞珠';

  @override
  String get focusFeatureTasbihSubtitle => '电子记主计数器';

  @override
  String get focusFeatureAiTitle => 'AI 伙伴';

  @override
  String get focusFeatureAiSubtitle => '询问有关信仰的问题';

  @override
  String get focusFeatureInsightsTitle => '洞察';

  @override
  String get focusFeatureInsightsSubtitle => '每周与每月统计';

  @override
  String get investTitle => '投资于迪尼';

  @override
  String get investSubtitle => '最好的投资不是转瞬即逝之物，而是能让你更亲近真主的事物。免费试用全部功能7天。';

  @override
  String get investPremiumUnlocked => '高级版已解锁';

  @override
  String get investTrialPill => '✨ 7天免费 — 结束前可随时取消';

  @override
  String get investNoCommitment => '无承诺。随时取消。';

  @override
  String get investFeatureAiTitle => 'AI伊斯兰助手';

  @override
  String get investFeatureAiBody => '关于信仰的任何问题均可提问 — 答案基于可靠来源。';

  @override
  String get investFeaturePrayerModeTitle => '全屏礼拜模式';

  @override
  String get investFeaturePrayerModeBody => '平静、无干扰的界面，提醒你礼拜。';

  @override
  String get investFeatureAppBlockingTitle => '高级应用锁定';

  @override
  String get investFeatureAppBlockingBody => '精细控制哪些应用在何时锁定。';

  @override
  String get investFeatureNightModeTitle => '夜间自律模式';

  @override
  String get investFeatureNightModeBody => '按时放松、睡得更好，并为晨礼醒来。';

  @override
  String get investFeaturePlannerTitle => '礼拜规划与进度';

  @override
  String get investFeaturePlannerBody => '连续记录、洞察与日记，助你保持坚持。';

  @override
  String get investFeatureToolsTitle => '专属伊斯兰工具';

  @override
  String get investFeatureToolsBody => '希吉来历、都阿、赞珠、99美名等。';

  @override
  String get investFeatureThemesTitle => '高级主题与更新';

  @override
  String get investFeatureThemesBody => '精美主题，以及我们推出的每一项新功能。';

  @override
  String get investFeatureTajweedTitle => '掌握泰吉维德';

  @override
  String get investFeatureTajweedBody => '通过引导课程与实时反馈提升诵读。';

  @override
  String get socialProofPrefix => '加入 ';

  @override
  String get socialProofHighlight => '10,000+';

  @override
  String get socialProofSuffix => ' 位穆斯林与 DeenFocus 一同成长';

  @override
  String get mostPopular => '最受欢迎';

  @override
  String get monthlyLabel => '每月';

  @override
  String get yearlyLabel => '每年';

  @override
  String get lifetimeLabel => '寿命';

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
  String get homeSearchNearbyMosques => '通过 OpenStreetMap 查找附近清真寺。';

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
  String get homeTapPrayerToMark => '点按礼拜以标记为已礼、补礼或错过。';

  @override
  String get homeSetLocation => '设置位置';

  @override
  String get homeEditPrayerSettings => '编辑礼拜设置';

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
  String get hijriYear => '希吉来';

  @override
  String get hijriMonthMuharram => '穆哈兰姆月';

  @override
  String get hijriMonthSafar => '赛法尔月';

  @override
  String get hijriMonthRabiAlAwwal => '赖比尔·敖外鲁月';

  @override
  String get hijriMonthRabiAlThani => '赖比尔·阿色尼月';

  @override
  String get hijriMonthJumadaAlAwwal => '主马达·敖外鲁月';

  @override
  String get hijriMonthJumadaAlThani => '主马达·阿色尼月';

  @override
  String get hijriMonthRajab => '赖哲卜月';

  @override
  String get hijriMonthShaban => '舍尔邦月';

  @override
  String get hijriMonthRamadan => '莱麦丹月';

  @override
  String get hijriMonthShawwal => '闪瓦鲁月';

  @override
  String get hijriMonthDhuAlQadah => '都尔·喀尔德月';

  @override
  String get hijriMonthDhuAlHijjah => '都尔·黑哲月';

  @override
  String get calendarTitle => '伊斯兰日历';

  @override
  String get calendarBack => '返回';

  @override
  String get calendarToday => '今天';

  @override
  String get calendarTomorrow => '明天';

  @override
  String calendarDaysAway(int days) {
    return '$days 天';
  }

  @override
  String get calendarNoEventsThisWeek => '本周没有伊斯兰节日。';

  @override
  String get calendarNoEventsBlessing => '愿真主以平安与美好祝福你的一周。';

  @override
  String get calendarNoUpcomingEvents => '未找到即将到来的伊斯兰节日。';

  @override
  String get calendarUpcomingEvents => '即将到来的伊斯兰节日';

  @override
  String get calendarUpcomingThisYear => '今年即将到来';

  @override
  String get calendarThisWeekObservances => '本周';

  @override
  String get calendarLegendCycleDays => '经期日（连续记录受保护）';

  @override
  String calendarMoonIlluminated(int percent) {
    return '亮度 $percent%';
  }

  @override
  String get calendarMoonNew => '新月';

  @override
  String get calendarMoonWaxingCrescent => '蛾眉月（盈）';

  @override
  String get calendarMoonFirstQuarter => '上弦月';

  @override
  String get calendarMoonWaxingGibbous => '盈凸月';

  @override
  String get calendarMoonFull => '满月';

  @override
  String get calendarMoonWaningGibbous => '亏凸月';

  @override
  String get calendarMoonLastQuarter => '下弦月';

  @override
  String get calendarMoonWaningCrescent => '残月';

  @override
  String get calendarEventRamadanBegins => '斋月开始';

  @override
  String get calendarEventRamadanBeginsDesc => '斋戒之月';

  @override
  String get calendarEventLaylatAlQadr => '盖德尔夜';

  @override
  String get calendarEventLaylatAlQadrDesc => '高贵之夜';

  @override
  String get calendarEventEidAlFitr => '开斋节';

  @override
  String get calendarEventEidAlFitrDesc => '开斋的节日';

  @override
  String get calendarEventDayOfArafah => '阿拉法日';

  @override
  String get calendarEventDayOfArafahDesc => '驻阿拉法特之日';

  @override
  String get calendarEventEidAlAdha => '宰牲节';

  @override
  String get calendarEventEidAlAdhaDesc => '献祭的节日';

  @override
  String get calendarEventIslamicNewYear => '伊斯兰新年';

  @override
  String get calendarEventIslamicNewYearDesc => '穆哈兰姆月1日';

  @override
  String get calendarEventMawlid => '圣纪';

  @override
  String get calendarEventMawlidDesc => '先知诞辰';

  @override
  String get calendarEventAshura => '阿舒拉';

  @override
  String get calendarEventAshuraDesc => '穆哈兰姆月10日';

  @override
  String get calendarEventJumuah => '主麻';

  @override
  String get calendarEventJumuahDesc => '周五集体礼拜';

  @override
  String get calendarEventWhiteDays => '白昼日';

  @override
  String get calendarEventWhiteDaysDesc => '推荐封斋日';

  @override
  String get cycleModeActiveTitle => '“真主欲你们便利，不要你们困难。” — 古兰经 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      '在此期间，您的礼拜连续记录会受到保护。经期日以粉色标示，周期结束后周期模式会自动关闭。';

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
      other: '将在 $days 天后自动结束',
      one: '明天自动结束',
      zero: '今天结束',
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
    return '你完成$prayer了吗？';
  }

  @override
  String get prayerReminderSubtitle => '记录礼拜，保持你的连续记录。';

  @override
  String get prayerReminderYesButton => '是的，艾哈迈杜里拉';

  @override
  String get prayerReminderLaterButton => '稍后再标记';

  @override
  String get prayerNotificationSubtitleFajr => '“晨礼的诵读确是被见证的。” — 古兰经 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr => '“当太阳偏西时当谨守拜功……” — 古兰经 17:78';

  @override
  String get prayerNotificationSubtitleAsr => '“你们当谨守拜功，尤其是中间的拜功。” — 古兰经 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib => '“故你们在傍晚当赞颂真主……” — 古兰经 30:17';

  @override
  String get prayerNotificationSubtitleIsha => '“当谨守拜功 — 直到黑夜降临。” — 古兰经 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return '$prayerName时间到了';
  }

  @override
  String get homeTrialBannerTitle => '免费 7 天 — 成为更好的穆斯林 ✨';

  @override
  String get homeTrialBannerSubtitle => '所有功能已解锁。今天开始你的旅程。';

  @override
  String get homeFocusModeTitle => '专注模式';

  @override
  String get homeFocusModeSubtitle => '礼拜期间屏蔽分心应用';

  @override
  String get focusModeShortSalah => '礼拜';

  @override
  String get focusModeShortNight => '夜间';

  @override
  String get focusModeShortChild => '儿童';

  @override
  String get focusModeLabelSalah => '礼拜模式';

  @override
  String get focusModeLabelNight => '夜间模式';

  @override
  String get focusModeLabelChild => '儿童模式';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return '$first和$second模式已开启';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return '$first、$second和$third模式已开启';
  }

  @override
  String get cycleModeTitle => '生理期模式';

  @override
  String get cycleModeSubtitle => '月经期间 — 暂停礼拜，保留连续记录';

  @override
  String get dailyChecklistTitle => '每日清单';

  @override
  String get dailyChecklistSubtitle => '追踪你的每日精神目标';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '已完成 $completed/$total';
  }

  @override
  String get dailyChecklistSectionPrayer => '礼拜';

  @override
  String get dailyChecklistSectionQuranDhikr => '古兰经与记念';

  @override
  String get dailyChecklistSectionGoodDeeds => '善行';

  @override
  String get dailyChecklistSectionDistraction => '个人自律';

  @override
  String get dailyChecklistFajr => '晨礼';

  @override
  String get dailyChecklistTahajjud => '夜功拜';

  @override
  String get dailyChecklistQuran => '古兰经';

  @override
  String get dailyChecklistMorningAdhkar => '晨间记主词';

  @override
  String get dailyChecklistEveningAdhkar => '晚间记主词';

  @override
  String get dailyChecklistDhikr => '记念';

  @override
  String get dailyChecklistCharity => '施舍';

  @override
  String get dailyChecklistSmileAtSomeone => '对他人微笑';

  @override
  String get dailyChecklistFamilyCall => '给家人打电话';

  @override
  String get dailyChecklistNoMusicToday => '今天不听歌';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha => '宵礼前不上社交媒体';

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
  String get quickActionsCalendar => '日历';

  @override
  String get quickActionsCalendarSubtitle => '查看伊斯兰日期';

  @override
  String get quickActionsSupportUs => '支持我们';

  @override
  String get quickActionsSupportUsSubtitle => '帮助我们成长';

  @override
  String get quickActionsSupportUsMessage => '感谢你考虑支持 DeenFocus！支持功能即将推出。';

  @override
  String get supportUsTitle => '支持 DeenFocus';

  @override
  String get supportUsHeroTitle => '支持 DeenFocus';

  @override
  String get supportUsHeroBody => '你的支持帮助我们持续改进 DeenFocus，并为有意义的事业贡献力量。';

  @override
  String get supportUsFundSection => '你的支持用于资助';

  @override
  String get supportUsFundSectionSubtitle => '我们用你的支持创造更多善举。';

  @override
  String get supportUsFundFeature1Title => '新功能';

  @override
  String get supportUsFundFeature1Subtitle => '构建并改进有意义的 DeenFocus 功能。';

  @override
  String get supportUsFundFeature2Title => '漏洞修复';

  @override
  String get supportUsFundFeature2Subtitle => '让应用对每个人都保持稳定、快速、可靠。';

  @override
  String get supportUsFundFeature3Title => '帮助有需要的人';

  @override
  String get supportUsFundFeature3Subtitle => '支持帮助困境中人们的行动。';

  @override
  String get supportUsFundFeature4Title => '慈善与社区';

  @override
  String get supportUsFundFeature4Subtitle => '为慈善项目和社区支持做出贡献。';

  @override
  String get supportUsNeedHelp => '需要帮助？';

  @override
  String get supportUsWhatsApp => '通过 WhatsApp 聊天';

  @override
  String get supportUsEmailSupport => '邮件支持';

  @override
  String get supportUsChooseAmountTitle => '选择支持金额';

  @override
  String get supportUsChooseAmountSubtitle => '你可以多次支持。';

  @override
  String get supportUsSecurePaymentNote => '安全的一次性付款 · 无定期扣费';

  @override
  String get supportUsTrustBanner => '安全 • 一次性支持 • 可多次支持';

  @override
  String get supportUsImpactSectionTitle => '你的支持带来的改变';

  @override
  String get supportUsImpactSectionSubtitle => '每一份贡献都有持久影响。';

  @override
  String get supportUsImpactPalestine => '支持与关注巴勒斯坦';

  @override
  String get supportUsImpactNeedy => '帮助有需要的人';

  @override
  String get supportUsImpactCommunity => '慈善与社区支持';

  @override
  String get supportUsImpactExperience => '更好的 DeenFocus 体验';

  @override
  String get supportUsImpactFeatures => '新功能与升级';

  @override
  String get supportUsImpactQuran => '古兰经与伊斯兰学习';

  @override
  String get supportUsImpactServers => '服务器与应用可靠性';

  @override
  String supportUsCta(String amount) {
    return '以 $amount 支持 DeenFocus';
  }

  @override
  String get supportUsWhatsAppPrefill => '安塞拉姆·阿莱库姆，我需要 DeenFocus 的帮助。';

  @override
  String get supportUsEmailSubject => 'DeenFocus 支持请求';

  @override
  String get supportUsLaunchUnavailable => '无法在此设备上打开该应用。';

  @override
  String get supportUsLaunchFailed => '出了点问题，请重试。';

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
  String get tabQuran => '学习';

  @override
  String get tabLearn => '学习';

  @override
  String get quranLoadFailed => '无法加载古兰经数据';

  @override
  String get quranTabSubtitle => '阅读并探索《古兰经》';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => '搜索古兰经...';

  @override
  String get quranSearchHintExtended => '搜索章节或含义...';

  @override
  String get quranNoResults => 'No results found';

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
  String get quranModeSurah => '章';

  @override
  String get quranModeJuz => '卷';

  @override
  String get quranModePage => '页';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => '继续阅读';

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
    return '第 $juz 卷的 $percent%';
  }

  @override
  String get quranBookmarksTitle => '书签';

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
    return '已保存 $count 个';
  }

  @override
  String get quranQuickTajweed => '读经练习';

  @override
  String get quranQuickTajweedSub => '诵读并评分';

  @override
  String get quranLastListened => '上次收听';

  @override
  String get quranNoneYet => '暂无';

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
  String get readingSettingsTajweedPractice => 'AI Tajweed Practice';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Recite ayahs and get feedback';

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
  String get readingSettingsTitle => '阅读设置';

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
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => '开始诵读';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => '词语准确度';

  @override
  String get tajweedWordReviewLabel => '词语回顾';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => '诵读并检查读经';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => '鼻音，两拍';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => '回弹音';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => '延长元音';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => '合并字母';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => '隐藏努恩';

  @override
  String get save => '节省';

  @override
  String get tasbihBack => '返回';

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
  String get widgetPrayerProgressTitle => '你的礼拜进度';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => '已完成礼拜。';

  @override
  String widgetPrayersLeftToday(int count) {
    return '继续加油 — 今天还剩 $count 次礼拜';
  }

  @override
  String get widgetAllPrayersDoneToday => '艾哈姆杜利拉 — 今天所有礼拜已完成';

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
  String get settingsRateDeenFocus => 'Rate DeenFocus ⭐';

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
  String get nearbyMosquesTitle => '找到的附近清真寺';

  @override
  String get nearbyMosquesTryAgain => '再试一次';

  @override
  String get nearbyMosquesOpenGoogle => '在 Google 地图中打开';

  @override
  String get nearbyMosquesOpenApple => '在苹果地图中打开';

  @override
  String get nearbyMosquesNoMosquesFoundWithin => '境内未发现清真寺';

  @override
  String nearbyMosquesSearchRadius(int radiusKm) {
    return '搜索半径：$radiusKm 公里';
  }

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
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return '$radiusKm 公里内未发现清真寺';
  }

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
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'OpenStreetMap 上 $radiusKm 公里范围内没有列出该地点的清真寺。稍后重试或扩大范围。';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$radiusKm 公里内发现 $count 座清真寺';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '附近 $count 座清真寺';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return '$radiusKm 公里内 · 按距离排序';
  }

  @override
  String get nearbyMosquesDirections => '路线';

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
  String get insightsPrayerStreak => '礼拜连续';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => '连续礼拜次数';

  @override
  String get insightsDaysInARow => '连续天数';

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
  String get insightsFocusExcellent => '很棒 — 继续保持！';

  @override
  String get insightsFocusKeepGoing => '继续提升你的专注';

  @override
  String get insightsTodaysPrayers => '今日礼拜';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => '生理期模式已开启';

  @override
  String get insightsProtectedByCycleMode => '你的连续记录已受保护。';

  @override
  String get insightsCurrentPrayerStreak => '当前礼拜连续';

  @override
  String get insightsBestPrayerStreak => '最佳礼拜连续';

  @override
  String get insightsCurrentDayStreak => '当前日连续';

  @override
  String get insightsCycleProtectedDays => '生理期保护天数';

  @override
  String get insightsAchievements => '成就';

  @override
  String get insightsAchieved => '已达成';

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
  String get insightsCycleModeFooterOff => '开启生理期模式，在休息日保护你的连续记录。';

  @override
  String get achievementFirstPrayerStreak => '首次礼拜连续';

  @override
  String get achievementSevenPrayerStreak => '七次礼拜连续';

  @override
  String get achievementThirtyPrayerStreak => '三十次礼拜连续';

  @override
  String get achievementFajrWarrior => '晨礼勇士';

  @override
  String get achievementQuranReader => '古兰经读者';

  @override
  String get achievementDhikrMaster => '记主大师';

  @override
  String get achievementConsistencyChampion => '坚持冠军';

  @override
  String get prayerCompletionAlhamdulillah => '艾哈迈杜里拉！';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer 已完成';
  }

  @override
  String get prayerCompletionStreakIncreased => '你的礼拜连续记录已增加';

  @override
  String get prayerCompletionKeepGoing => '每一次礼拜都让你更亲近真主。继续加油！';

  @override
  String get prayerCompletionContinue => '继续';

  @override
  String prayerCompletionNextPrayer(String when) {
    return '下一个祷告在 $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '$hours小时 $minutes分';
  }

  @override
  String get weekdayLetterMon => '一';

  @override
  String get weekdayLetterTue => '二';

  @override
  String get weekdayLetterWed => '三';

  @override
  String get weekdayLetterThu => '四';

  @override
  String get weekdayLetterFri => '五';

  @override
  String get weekdayLetterSat => '六';

  @override
  String get weekdayLetterSun => '日';

  @override
  String get focusHomeBlockingNightAndSalah => '夜间自律与礼拜模式正在屏蔽所选应用。';

  @override
  String get focusHomeBlockingNight => '夜间自律模式正在屏蔽所选应用。';

  @override
  String get focusHomeBlockingSalah => '礼拜模式正在屏蔽所选应用。';

  @override
  String get focusHomeAppsBlockedNow => '所选应用当前已被屏蔽。';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode 已开启。';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes 已开启。';
  }

  @override
  String get focusHomeChooseMode => '选择一种模式来保护你的专注';

  @override
  String get focusStatusSelectApps => '选择应用以开始';

  @override
  String get focusStatusBlockingNightAndSalah => '夜间自律与礼拜模式正在屏蔽应用';

  @override
  String get focusStatusBlockingNight => '夜间自律模式正在屏蔽应用';

  @override
  String get focusStatusBlockingSalah => '礼拜模式正在屏蔽应用';

  @override
  String get focusStatusAppsLocked => '应用当前已锁定';

  @override
  String focusStatusUnlockedUntil(String time) {
    return '解锁至 $time';
  }

  @override
  String get focusStatusNoMode => '未启用专注模式';

  @override
  String focusStatusReadyToLock(String targets) {
    return '准备锁定 $targets';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '$hours小时 $minutes分 $seconds秒';
  }

  @override
  String get appLockDemoIntroTitle => '看看应用锁定如何运作';

  @override
  String get appLockDemoIntroSubtitle =>
      '留在 DeenFocus。下一屏点击 Instagram，看看礼拜时间如何暂停应用。';

  @override
  String get appLockDemoStartButton => '开始演示';

  @override
  String get appLockDemoTryOpeningApp => '试着打开 Instagram';

  @override
  String get appLockDemoSalahModeBadge => '礼拜模式';

  @override
  String get appLockDemoTimeToPray => '礼拜时间到了';

  @override
  String appLockDemoRemainingTime(String time) {
    return '剩余时间：$time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return '我已完成 $prayerName';
  }

  @override
  String get appLockDemoAlhamdulillah => 'الحمد لله';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName 已完成';
  }

  @override
  String get appLockDemoStreakIncreased => '你的礼拜连续记录增加了';

  @override
  String get appLockDemoPrayerStreakLabel => '礼拜连续';

  @override
  String get appLockDemoDayStreakLabel => '日连续';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return '$minutes 分钟后下一次礼拜';
  }

  @override
  String get appLockDemoStreakMotivation => '继续加油！你的坚持让你更接近真主。';

  @override
  String get appLockDemoCompletionSubtitle => '礼拜。确认一次。\n然后回到你的一天。';

  @override
  String get appLockDemoCompletionBody => '应用锁定会在礼拜期间轻柔暂停所选应用，让你专注礼拜——准备好后再继续。';

  @override
  String get appLockDemoContinueSetup => '继续设置';

  @override
  String get appLockDemoAppMessages => '信息';

  @override
  String get appLockDemoAppCalendar => '日历';

  @override
  String get appLockDemoAppPhotos => '照片';

  @override
  String get appLockDemoAppCamera => '相机';

  @override
  String get appLockDemoAppMail => '邮件';

  @override
  String get appLockDemoAppMaps => '地图';

  @override
  String get appLockDemoAppWeather => '天气';

  @override
  String get appLockDemoAppClock => '时钟';

  @override
  String get appLockDemoAppNotes => '备忘录';

  @override
  String get appLockDemoAppSettings => '设置';

  @override
  String get appLockDemoAppMusic => '音乐';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => '礼拜更新';

  @override
  String get settingsPrayerUpdatesSubtitle => '在锁定屏幕上查看下一场礼拜的实时活动';

  @override
  String get liveActivitySectionTitle => '实时活动';

  @override
  String get liveActivityStayUpdatedTitle => '一眼掌握最新动态';

  @override
  String get liveActivityStayUpdatedBody => '在锁定屏幕上直接查看下一场礼拜及其时间。';

  @override
  String get liveActivityEnableLabel => '启用实时活动';

  @override
  String get liveActivityPromptNotNow => '暂不';

  @override
  String get liveActivityUnsupported => '此设备不支持实时活动。';

  @override
  String get liveActivityPermissionNeeded => '请允许通知，以便在锁定屏幕上显示礼拜更新。';

  @override
  String get liveActivityPermissionButton => '允许通知';

  @override
  String get liveActivityStatusActive => '实时活动已开启';

  @override
  String get liveActivityStatusOff => '实时活动已关闭';

  @override
  String get liveActivityNowLabel => '现在';

  @override
  String liveActivityUpdatedAt(String time) {
    return '更新于 $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => '礼拜闹钟';

  @override
  String get settingsPrayerAlarmsSubtitle => '可突破静音模式的完整礼拜闹钟';

  @override
  String get prayerAlarmsMasterLabel => '启用礼拜闹钟';

  @override
  String get prayerAlarmsMasterSubtitle => '为每个所选礼拜安排系统闹钟';

  @override
  String get prayerAlarmsSnoozeLabel => '贪睡时长';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get prayerAlarmsPerPrayerSection => '按礼拜设置闹钟';

  @override
  String get prayerAlarmsPermissionNeeded => '请允许闹钟权限，以便准时响起。';

  @override
  String get prayerAlarmsPermissionButton => '允许闹钟';

  @override
  String get prayerAlarmsFsiNeeded => '请允许全屏闹钟以便显示在锁屏上。否则将以横幅通知提醒。';

  @override
  String get prayerAlarmsFsiButton => '全屏设置';

  @override
  String get prayerAlarmsUnsupported => '此设备不支持原生礼拜闹钟。轻提醒通知仍然可用。';

  @override
  String get prayerAlarmsIosFallback => '在此 iOS 版本上，使用轻提醒通知代替 AlarmKit。';

  @override
  String get prayerAlarmsDeniedTitle => '需要闹钟权限';

  @override
  String get prayerAlarmsDeniedMessage => '在允许闹钟权限之前，礼拜闹钟保持关闭。轻柔通知不受影响。';

  @override
  String get prayerAlarmsOpenSettings => '打开设置';

  @override
  String get prayerAlarmsStatusReady => '闹钟已准备好安排';

  @override
  String get prayerAlarmsStatusNeedsPermission => '需要权限 — 闹钟未启用';

  @override
  String get prayerAlarmsStatusFallback => '此设备使用轻柔通知';

  @override
  String get prayerAlarmsStatusFsiOptional => '闹钟已开启。启用全屏以覆盖锁屏。';

  @override
  String get prayerAlarmsCancel => '暂时不用';

  @override
  String get homePrayerAlarmEnableLabel => '礼拜闹钟';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return '在$prayerName响起系统闹钟';
  }

  @override
  String get prayerAlarmBadge => '礼拜闹钟';

  @override
  String get prayerAlarmSubtitle => '礼拜时间到了';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — 礼拜时间到了';
  }

  @override
  String get prayerAlarmIvePrayed => '我已礼拜';

  @override
  String get prayerAlarmDismiss => '关闭';

  @override
  String get prayerAlarmSnooze => '稍后提醒';

  @override
  String get appLockDemoAppPhone => '电话';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => '提醒事项';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => '图书';

  @override
  String get appLockDemoAppHealth => '健康';

  @override
  String get appLockDemoAppWallet => '钱包';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => '应用演示';

  @override
  String get settingsAppDemoChooseModeTitle => '体验应用锁定';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      '选择一种专注模式，看看所选应用如何暂停——无需离开 DeenFocus。';

  @override
  String get appLockDemoDone => '完成';

  @override
  String get appLockDemoSleepIntroTitle => '看看睡眠模式如何运作';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      '留在 DeenFocus。下一屏点击 Instagram，看看就寝时如何暂停应用。';

  @override
  String get appLockDemoSleepModeBadge => '睡眠模式';

  @override
  String get appLockDemoSleepLockTitle => '该放松休息了';

  @override
  String get appLockDemoSleepLockCta => '我准备休息了';

  @override
  String get appLockDemoSleepCompleted => '睡眠模式已保护';

  @override
  String get appLockDemoSleepRewardSubtitle => '你的夜间保护增加了';

  @override
  String get appLockDemoSleepStreakLabel => '夜间连续';

  @override
  String get appLockDemoSleepRewardFooter => '已设置晨礼提醒';

  @override
  String get appLockDemoSleepMotivation => '今晚好好休息，以便精力充沛地醒来做晨礼。';

  @override
  String get appLockDemoSleepCompletionSubtitle => '安静的夜晚。\n清爽的早晨。';

  @override
  String get appLockDemoSleepCompletionBody =>
      '睡眠模式会在夜间轻柔暂停所选应用，让你休息——准备好后再继续。';

  @override
  String get appLockDemoChildIntroTitle => '看看儿童模式如何运作';

  @override
  String get appLockDemoChildIntroSubtitle =>
      '留在 DeenFocus。下一屏点击 Instagram，看看儿童模式开启时如何锁定。';

  @override
  String get appLockDemoChildModeBadge => '儿童模式';

  @override
  String get appLockDemoChildLockTitle => '应用已受保护';

  @override
  String get appLockDemoChildLockDetail => '开启儿童模式时，所选应用保持锁定';

  @override
  String get appLockDemoChildLockCta => '知道了';

  @override
  String get appLockDemoChildCompleted => '儿童模式已开启';

  @override
  String get appLockDemoChildRewardSubtitle => '你的保护连续记录增加了';

  @override
  String get appLockDemoChildStreakLabel => '安全连续';

  @override
  String get appLockDemoChildRewardFooter => '随时可用密码退出';

  @override
  String get appLockDemoChildMotivation => '每次交出手机都更安心。';

  @override
  String get appLockDemoChildCompletionSubtitle => '一键安全模式。\n只显示你允许的内容。';

  @override
  String get appLockDemoChildCompletionBody =>
      '儿童模式会锁定所选应用，让孩子只看到安全内容——准备好后再解锁。';

  @override
  String get appLockDemoSleepCompletionTitle => '今晚好好休息';

  @override
  String get appLockDemoChildCompletionTitle => '安心无用';

  @override
  String get settingsAppDemoPrayerCardSubtitle => '在礼拜时暂停干扰，让你专心祈祷。';

  @override
  String get settingsAppDemoSleepCardSubtitle => '守护夜晚，让休息更轻松——晨礼也更轻盈。';

  @override
  String get settingsAppDemoChildCardSubtitle => '安心交出手机：只有你允许的应用保持可用。';

  @override
  String get settingsAppDemoHomeFeaturesTitle => '一眼掌握动态';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      '看看主屏幕小组件和实时活动如何让礼拜时间近在咫尺——无需打开应用。';

  @override
  String get settingsAppDemoWidgetsCardSubtitle => '主屏幕上的每日经文与礼拜时间，始终最新。';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle => '锁屏与灵动岛上的当前与下一场礼拜。';

  @override
  String get settingsAppDemoTajweedCardSubtitle => '诵读一节经文，立即获得读经反馈。';

  @override
  String get featureDemoTajweedTitle => '读经';

  @override
  String get featureDemoTajweedIntroTitle => '了解读经练习如何运作';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      '留在 DeenFocus。打开读经练习，诵读一节经文，并逐词查看反馈。';

  @override
  String get featureDemoTajweedQuranCallout => '点按读经练习开始';

  @override
  String get featureDemoTajweedLegendCallout => '颜色高亮会在阅读时标示读经规则';

  @override
  String get featureDemoTajweedReciteCallout => '点按诵读并检查读经';

  @override
  String get featureDemoTajweedDownloadCallout => '一次性下载后即可离线练习';

  @override
  String get featureDemoTajweedMicCallout => '点按麦克风开始诵读';

  @override
  String get featureDemoTajweedResultCallout => '查看哪些词正确、遗漏或需要改进';

  @override
  String get featureDemoTajweedCompletionTitle => '读经已就绪';

  @override
  String get featureDemoTajweedCompletionSubtitle => '随时自信诵读。';

  @override
  String get featureDemoTajweedCompletionBody =>
      '打开古兰经 → 读经练习，在设备上为任意经文评分 — 首次下载后即可完全离线。';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 节 • 麦加章';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 节 • 麦地那章';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => '开端章 • 7 节';

  @override
  String get featureDemoTajweedSurahMeta => '第 1 章 • 麦加';

  @override
  String get featureDemoTajweedAyahTranslation => '奉至仁至慈的真主之名。';

  @override
  String get featureDemoTajweedPracticeTitle => '开端章 · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => '正在准备 AI 模型';

  @override
  String get featureDemoTajweedPreparingBody => '一次性下载，之后读经练习即可完全离线。只需一次。';

  @override
  String get featureDemoTajweedResultEncouragement => '继续练习 — 听参考音频再试一次。';

  @override
  String get featureDemoTajweedStatCorrect => '正确';

  @override
  String get featureDemoTajweedStatPronunciation => '发音';

  @override
  String get featureDemoTajweedStatWrong => '错词';

  @override
  String get featureDemoTajweedStatMissed => '遗漏';

  @override
  String get featureDemoTajweedStatExtra => '多余';

  @override
  String get featureDemoContinue => '继续';

  @override
  String get featureDemoSampleStatusTime => '9:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      '系统不允许应用自动添加小组件。请从主屏幕小组件图库中添加大型 DeenFocus 小组件。';

  @override
  String get featureDemoOfferWidgetManualTitle => '请从主屏幕添加小组件';

  @override
  String get featureDemoOfferNo => '否';

  @override
  String get featureDemoOfferYes => '是';

  @override
  String get featureDemoOfferLiveActivityTitle => '要在此设备上启用实时活动吗？';

  @override
  String get featureDemoOfferWidgetsTitle => '要将此小组件添加到主屏幕吗？';

  @override
  String get featureDemoWidgetsTitle => '小组件';

  @override
  String get featureDemoWidgetsIntroTitle => '查看主屏幕小组件';

  @override
  String get featureDemoWidgetsIntroSubtitle =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsShowcaseCallout =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsDetailsTitle => '一目了然的礼拜指引';

  @override
  String get featureDemoWidgetsDetailsBody =>
      '中号小组件显示今日经文与五番礼拜时间——打开 DeenFocus 后会刷新。';

  @override
  String get featureDemoWidgetsCompletionTitle => '小组件已就绪';

  @override
  String get featureDemoWidgetsCompletionSubtitle => '信仰提醒就在主屏幕上。';

  @override
  String get featureDemoWidgetsCompletionBody =>
      '演示结束后从手机小组件库添加 DeenFocus 小组件，并打开应用一次以同步。';

  @override
  String get featureDemoWidgetsHomeHint => '8月13日星期三';

  @override
  String get featureDemoWidgetSampleDate => '周三，8月13日';

  @override
  String get featureDemoWidgetSampleVerse => '我们只崇拜你，只向你求助。';

  @override
  String get featureDemoWidgetSampleSource => '古兰经 1:5';

  @override
  String get featureDemoLiveActivityTitle => '实时活动';

  @override
  String get featureDemoLiveActivityIntroTitle => '体验实时活动';

  @override
  String get featureDemoLiveActivityIntroSubtitle =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityShowcaseCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveActivityDetailsTitle => '礼拜更新始终可见';

  @override
  String get featureDemoLiveActivityDetailsBody =>
      '实时活动在锁屏上显示昏礼、宵礼与倒计时——可随时在设置中开启。';

  @override
  String get featureDemoLiveActivityCompletionTitle => '实时活动已就绪';

  @override
  String get featureDemoLiveActivityCompletionSubtitle => '下一场礼拜始终在身边。';

  @override
  String get featureDemoLiveActivityCompletionBody =>
      '在设置 → 礼拜计算中启用实时活动，即可在锁屏显示礼拜更新。';

  @override
  String get featureDemoLiveActivityLockHint => '8月13日星期三';

  @override
  String get featureDemoLiveActivitySampleTime => '下午 6:48';

  @override
  String get featureDemoLiveActivitySampleNextTime => '晚上 8:11';

  @override
  String get featureDemoWidgetsIntroSubtitleIos =>
      '留在 DeenFocus。长按主屏幕，添加小组件，并试用全部 3 种尺寸。';

  @override
  String get featureDemoWidgetsIntroSubtitleAndroid =>
      '留在 DeenFocus。长按主屏幕，打开小组件选择器，试用全部 3 种尺寸。';

  @override
  String get featureDemoWidgetsLongPressCalloutIos => '长按主屏幕以编辑小组件';

  @override
  String get featureDemoWidgetsLongPressCalloutAndroid => '长按主屏幕以编辑小组件';

  @override
  String get featureDemoWidgetsAddCallout => '点击 + 选择 DeenFocus 小组件';

  @override
  String get featureDemoWidgetsAddSlotLabel => '添加小组件';

  @override
  String get featureDemoWidgetsGalleryTitle => '选择 DeenFocus 小组件';

  @override
  String get featureDemoWidgetsGallerySubtitle =>
      'Switch between Small, Medium, and Large — then add it to your Home Screen.';

  @override
  String get featureDemoWidgetsAddCta => 'Add Widget';

  @override
  String get featureDemoWidgetsAddCtaAndroid => 'Add widget';

  @override
  String get featureDemoWidgetsChangeCta => '更换尺寸';

  @override
  String get featureDemoWidgetSizeSmall => '小号';

  @override
  String get featureDemoWidgetSizeMedium => '中号';

  @override
  String get featureDemoWidgetSizeLarge => '大号';

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
  String get featureDemoLiveOpenPrayerCalcCallout => '点击礼拜计算';

  @override
  String get featureDemoLiveEnableToggleCallout => '打开“启用实时活动”';

  @override
  String get featureDemoLiveLockScreenCallout =>
      'Your prayer Live Activity on the Lock Screen';

  @override
  String get featureDemoLiveCompactTitle => '紧凑灵动岛';

  @override
  String get featureDemoLiveCompactCallout =>
      'Current prayer stays visible at the top';

  @override
  String get featureDemoLiveExpandCta => '展开灵动岛';

  @override
  String get featureDemoLiveExpandedTitle => '展开的灵动岛';

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
  String get featureDemoAndroidOngoingTitle => '实时礼拜通知';

  @override
  String get featureDemoAndroidOngoingCallout =>
      'Silent ongoing update — current and next prayer';

  @override
  String get featureDemoAndroidOpenShadeCta => '打开通知栏';

  @override
  String get featureDemoAndroidShadeTitle => '通知栏';

  @override
  String get featureDemoAndroidShadeCallout =>
      'Expand to see the full current and next prayer status';

  @override
  String get featureDemoAndroidOngoingBadge => '进行中';

  @override
  String get appLockDemoOfferPrayerTitle => '准备试试礼拜模式吗？';

  @override
  String get appLockDemoOfferSleepTitle => '准备试试睡眠模式吗？';

  @override
  String get appLockDemoOfferChildTitle => '准备试试儿童模式吗？';

  @override
  String get appLockDemoOfferPrayerCta => '启用礼拜模式';

  @override
  String get appLockDemoOfferSleepCta => '启用睡眠模式';

  @override
  String get appLockDemoOfferChildCta => '启用儿童模式';

  @override
  String get appLockDemoOfferNotNow => '暂时不要';

  @override
  String get nightlyWrapUpPrayersTitle => '完成今天的礼拜';

  @override
  String get nightlyWrapUpPrayersBody => '标记未完成或错过的礼拜，以保护你的礼拜连续记录。';

  @override
  String get nightlyWrapUpChecklistTitle => '完成今日清单';

  @override
  String get nightlyWrapUpChecklistBody => '还有几项未完成——有意识地结束今天。';

  @override
  String get nightlyWrapUpBothTitle => '结束你的一天';

  @override
  String get nightlyWrapUpBothBody => '标记剩余礼拜，并在今天结束前完成每日清单。';

  @override
  String get cycleModeEndedNotificationTitle => '周期模式已结束';

  @override
  String get cycleModeEndedNotificationBody =>
      '您的周期模式现已关闭。您可以继续礼拜。若要更改周期模式日期，请点按此处进行编辑。';

  @override
  String get libraryHomeTitle => '伊斯兰图书馆';

  @override
  String get libraryHomeSubtitle => '学习圣训、祷词、九十九个美名等';

  @override
  String get libraryHubTitle => '伊斯兰图书馆';

  @override
  String get libraryModuleQuran => '古兰经';

  @override
  String get libraryModuleQuranSub => '阅读、聆听并练习泰吉威德';

  @override
  String get libraryModuleHadith => '圣训';

  @override
  String get libraryModuleHadithSub => '来自可靠来源的合集';

  @override
  String get libraryModuleDuas => '祷词与赞念';

  @override
  String get libraryModuleDuasSub => '晨礼、昏礼与日常记念';

  @override
  String get libraryModulePrayerMethods => '礼拜与伊斯兰方法';

  @override
  String get libraryModulePrayerMethodsSub => '小净、礼拜、朝觐等';

  @override
  String get libraryModuleFiqh => '教法与传统';

  @override
  String get libraryModuleFiqhSub => '逊尼、什叶、学派、圣训派等';

  @override
  String get libraryModuleNames => '安拉的九十九个美名';

  @override
  String get libraryModuleNamesSub => '学习并思考至美之名';

  @override
  String get libraryModulePillarsIslam => '伊斯兰五功';

  @override
  String get libraryModulePillarsIslamSub => '信仰实践的五大基础';

  @override
  String get libraryModulePillarsIman => '信仰六信';

  @override
  String get libraryModulePillarsImanSub => '信仰的六大信条';

  @override
  String get libraryModuleProphets => '先知穆罕默德';

  @override
  String get libraryModuleProphetsSub => '他的生平、使命与永恒教诲';

  @override
  String get libraryModuleOccasions => '伊斯兰节日';

  @override
  String get libraryModuleOccasionsSub => '斋月、尔德、朝觐与神圣日子';

  @override
  String get libraryKeyLesson => '关键一课';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get libraryPrevious => '上一张';

  @override
  String get libraryNext => '下一张';

  @override
  String get libraryBookmark => '书签';

  @override
  String get libraryCopy => '复制';

  @override
  String get libraryShare => '分享';

  @override
  String get libraryCopied => '已复制到剪贴板';

  @override
  String get libraryShareCopiedHint => '已复制 — 粘贴即可分享';

  @override
  String get libraryBookmarkSaved => '书签已保存';

  @override
  String get libraryBookmarkRemoved => '书签已移除';

  @override
  String get libraryTranslation => '译文';

  @override
  String get libraryTransliteration => '音译';

  @override
  String get libraryMeaning => '含义';

  @override
  String get libraryBookmarksTitle => '已保存的学习内容';

  @override
  String get libraryBookmarksSubtitle => '圣训、祷词、美名、教法等';

  @override
  String get libraryBookmarksEmpty => '暂无已保存内容。在任意学习条目上点按书签即可保存在此。';

  @override
  String get libraryMarkCompleted => '标记为已完成';

  @override
  String get librarySectionCompleted => '已完成';

  @override
  String get libraryReflection => '思考';

  @override
  String get libraryComingSoonTitle => '即将推出';

  @override
  String get libraryComingSoonBody => '此模块正在准备中。请在后续更新中查看。';

  @override
  String get librarySearchHint => '搜索…';

  @override
  String get librarySearchEmpty => '无匹配项';

  @override
  String libraryItemCount(int count) {
    return '$count 项';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown/$total';
  }

  @override
  String libraryContinueFrom(int number) {
    return '继续 · $number';
  }

  @override
  String get libraryInProgress => '进行中';

  @override
  String libraryReference(String source) {
    return '出处：$source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count 条祷词';
  }

  @override
  String get libraryDuaCategoryMorning => '早晨';

  @override
  String get libraryDuaCategoryEvening => '傍晚';

  @override
  String get libraryDuaCategoryDailyLife => '日常生活';

  @override
  String get libraryDuaCategorySleep => '睡眠';

  @override
  String get libraryDuaCategoryFood => '饮食';

  @override
  String get libraryDuaCategoryTravel => '旅行';

  @override
  String get libraryDuaCategoryIllness => '疾病';

  @override
  String get libraryDuaCategoryProtection => '护佑';

  @override
  String get libraryDuaCategoryForgiveness => '宽恕';

  @override
  String get libraryDuaCategoryParents => '父母';

  @override
  String libraryHadithCount(int count) {
    return '$count 条圣训';
  }

  @override
  String get libraryHadithNarrator => '传述者：';

  @override
  String get libraryHadithSource => '出处：';

  @override
  String get libraryHadithCollectionBukhari => '布哈里圣训实录';

  @override
  String get libraryHadithCollectionMuslim => '穆斯林圣训实录';

  @override
  String get libraryHadithCollectionRiyad => '圣训园地';

  @override
  String get libraryHadithCollectionNawawi => '纳瓦维四十圣训';

  @override
  String get libraryHadithCollectionHisnul => '穆斯林堡垒';

  @override
  String libraryGuideStepCount(int count) {
    return '$count 步';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return '第 $current 步，共 $total 步';
  }

  @override
  String get libraryGuideWudu => '小净';

  @override
  String get libraryGuideSalah => '礼拜';

  @override
  String get libraryGuideGhusl => '大净';

  @override
  String get libraryGuideTayammum => '土净';

  @override
  String get libraryGuideJanazah => '殡礼';

  @override
  String get libraryGuideUmrah => '副朝';

  @override
  String get libraryGuideHajj => '正朝';

  @override
  String get libraryGuideFasting => '斋戒';

  @override
  String get libraryGuideZakat => '天课';

  @override
  String get libraryGuideTawbah => '忏悔';

  @override
  String get libraryOccasionImportance => '重要性';

  @override
  String get libraryOccasionVirtues => '美德';

  @override
  String get libraryOccasionRecommendedActs => '推荐行为';

  @override
  String get libraryFiqhOverview => '概述';

  @override
  String get libraryFiqhKeyPoints => '要点';

  @override
  String get libraryFiqhDifferences => '主要差异';

  @override
  String get libraryFiqhCommonGround => '共同点';

  @override
  String get insightsCompleted => '已完成';

  @override
  String get insightsInProgress => '进行中';

  @override
  String get insightsKeepGoingTitle => '继续加油！';

  @override
  String get insightsKeepGoingBody => '你进步很大。每一次礼拜都很重要。';

  @override
  String get insightsAchievementsUnlockedLabel => '已解锁成就';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer => '你完成了第一次礼拜。';

  @override
  String get achievementDescSevenPrayerStreak => '连续完成 7 次礼拜。';

  @override
  String get achievementDescThirtyPrayerStreak => '连续完成 30 次礼拜。';

  @override
  String get achievementDescFajrWarrior => '在 14 天完成晨礼。';

  @override
  String get achievementDescFajrChampion => '在 30 天完成晨礼。';

  @override
  String get achievementDescFiveADay => '在一天内完成全部五番礼拜。';

  @override
  String get achievementDescPerfectWeek => '连续 7 天完成每一次礼拜。';

  @override
  String get achievementDescPerfectMonth => '连续 30 天完成每一次礼拜。';

  @override
  String get achievementDescQuranReader => '在 7 天阅读古兰经。';

  @override
  String get achievementDescQuranDevotee => '在 30 天阅读古兰经。';

  @override
  String get achievementDescDhikrStarter => '在 7 天完成记主。';

  @override
  String get achievementDescDhikrMaster => '在 30 天完成记主。';

  @override
  String get achievementDescNightWorshipper => '在 7 天完成泰罕朱德。';

  @override
  String get achievementDescMasjidCompanion => '前往清真寺 7 次。';

  @override
  String get achievementDescDistractionDefender => '保持 7 天不受干扰。';

  @override
  String get achievementDescCycleGuardian => '使用周期模式保护连续记录 7 天。';

  @override
  String get achievementDescProtectedMonth => '使用周期模式保护连续记录 30 天。';

  @override
  String get achievementDescConsistencyChampion => '坚持 100 天。';

  @override
  String get achievementDescSixMonthJourney => '坚持 180 天。';

  @override
  String get achievementDescDeenFocusMaster => '达到 DeenFocus Master（第 15 级）。';

  @override
  String get dailyChecklistOptional => '可选';

  @override
  String get dailyChecklistIstighfar => '求饶（Istighfar）';

  @override
  String get dailyChecklistSalawat => '赞圣 / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly => '克制怒气 / 友善说话';

  @override
  String get digitalBalanceTitle => '数字平衡';

  @override
  String get digitalBalanceSubtitle => '看看你的时间花在哪里';

  @override
  String get digitalBalanceViewCta => '查看数字平衡 →';

  @override
  String get digitalBalanceTodayLabel => '今天';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => '其他应用';

  @override
  String get digitalBalanceTodayPhoneTime => '今日手机使用';

  @override
  String get digitalBalanceWhereTimeGoes => '时间花在哪里';

  @override
  String get digitalBalanceViewAllApps => '查看全部应用';

  @override
  String get digitalBalanceAllAppsTitle => '全部应用';

  @override
  String get digitalBalanceNoApps => '今天还没有应用使用记录。';

  @override
  String get digitalBalanceDeenVsDigital => '信仰时间与数字时间';

  @override
  String get digitalBalanceYourWeek => '本周';

  @override
  String get digitalBalanceThisWeek => '本周';

  @override
  String get digitalBalancePhoneUsageLegend => '手机使用';

  @override
  String get digitalBalanceDailyInsight => '今日提示';

  @override
  String get digitalBalanceInsightKeepGoing => '每一分钟用于加强信仰都很重要。';

  @override
  String get digitalBalanceInsightWeekHigher =>
      '本周的 DeenFocus 时间高于上周。MashaAllah！';

  @override
  String get digitalBalanceInsightQuietDay => '今天暂时很安静。DeenFocus 时间会显示在这里。';

  @override
  String get digitalBalanceGoalTitle => '你的信仰时间目标';

  @override
  String get digitalBalanceAdjustGoal => '调整目标';

  @override
  String get digitalBalanceGoalReached => '你已达成今日目标。MashaAllah！';

  @override
  String get digitalBalanceGoalSheetTitle => '每日信仰时间';

  @override
  String get digitalBalanceGoalCustomHint => '每天分钟数';

  @override
  String get digitalBalanceGoalSave => '保存';

  @override
  String get digitalBalanceGoal15 => '15 分钟';

  @override
  String get digitalBalanceGoal30 => '30 分钟';

  @override
  String get digitalBalanceGoal45 => '45 分钟';

  @override
  String get digitalBalanceGoal60 => '1 小时';

  @override
  String get digitalBalancePermissionTitle => '了解你的数字习惯';

  @override
  String get digitalBalancePermissionBody =>
      '允许 DeenFocus 访问应用使用情况，以便了解时间花在哪里、以及你给信仰多少时间。';

  @override
  String get digitalBalanceEnableUsage => '开启应用使用';

  @override
  String get digitalBalanceMaybeLater => '稍后再说';

  @override
  String get digitalBalanceUnavailableTitle => '此处无法查看应用使用';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple 不会与其他应用共享屏幕使用时间，因此暂时无法显示 iPhone 使用情况。礼拜、连续记录和 DeenFocus 洞察仍可正常使用。';

  @override
  String get digitalBalanceInfoTitle => '关于数字平衡';

  @override
  String get digitalBalanceInfoBody => '数字平衡帮助你了解时间花在哪里、以及你给信仰多少时间。使用数据保存在本机。';

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
    return 'DeenFocus · 占手机时间的 $percent%';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = 占手机时间的 $percent%';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '占今日手机时间的 $percent%';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ 比上周多 $percent% 的 DeenFocus 时间';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return '你今天在 DeenFocus 度过了 $duration。继续保持。';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return '你的 DeenFocus 时间比昨天增加了 $percent%。';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / 天';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return '距今日目标还差 $minutes 分钟';
  }
}
