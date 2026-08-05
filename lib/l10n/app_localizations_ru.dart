// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Дин Фокус';

  @override
  String get appTagline => 'Вера. Фокус. Последовательность';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Молитвенный режим. Детский режим. Режим сна.';

  @override
  String get welcomeDescription =>
      'Отслеживайте свои молитвы, читайте Коран, считайте Тасбих и создавайте значимые полосы — и все это в одном месте.';

  @override
  String get skip => 'Пропускать';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get continueButton => 'Продолжать';

  @override
  String get continueForFree => 'Продолжить с бесплатным планом';

  @override
  String get getStarted => 'Разблокировать Premium';

  @override
  String get language => 'Язык';

  @override
  String get cancel => 'Отмена';

  @override
  String get ok => 'ХОРОШО';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get locationRequired => 'Требуется местоположение';

  @override
  String get locationRequiredMessage =>
      'Доступ к местоположению необходим для расчета точного времени молитвы и направления Киблы. Вы должны включить его, чтобы использовать приложение.';

  @override
  String get notificationsRequired => 'Требуются уведомления';

  @override
  String get notificationsRequiredMessage =>
      'Уведомления необходимы для получения оповещений и напоминаний о времени молитвы.';

  @override
  String get sectTitle => 'Выберите свою секту';

  @override
  String get sectSubtitle => 'Это помогает нам персонализировать ваш опыт';

  @override
  String get sectSunni => 'сунниты';

  @override
  String get sectShia => 'Шииты';

  @override
  String get sectPreferNotToSay => 'Предпочитаю не говорить';

  @override
  String get nameTitle => 'Как тебя зовут?';

  @override
  String get nameSubtitle => 'Давайте персонализировать ваше поздравление';

  @override
  String get namePlaceholder => 'Ваше имя';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => 'Разрешить доступ к местоположению';

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
  String get notificationsButton => 'Включить уведомления';

  @override
  String get notificationsEnabled => 'Уведомления включены';

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
  String get screenTimeTitle => 'Включить Экранное время';

  @override
  String get screenTimeSubtitle =>
      'Это позволяет Deen Focus приостанавливать отвлекающие приложения во время намаза, сна и детского режима.';

  @override
  String get screenTimeButton => 'Разрешить доступ к Экранному времени';

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
  String get focusPrayerModeTitle => 'Молитвенный режим';

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
  String get focusSleepModeTitle => 'Спящий режим';

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
  String get focusChildModeTitle => 'Детский режим';

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
  String get investTitle => 'Инвестируйте в свою религию';

  @override
  String get investSubtitle =>
      'Вы не раздумываете дважды, прежде чем потратить деньги на кофе или закуски...';

  @override
  String get investComparisonTitle =>
      'Перейти на Premium или продолжить бесплатно';

  @override
  String get investDailyCoffee => 'Ежедневный кофе';

  @override
  String get investDailyCoffeePrice => '5 долларов США/день';

  @override
  String get investFastFood => 'Быстрое питание';

  @override
  String get investFastFoodPrice => '10 долларов США/еда';

  @override
  String get investYourDeen => 'Ваш Дин';

  @override
  String get investYourDeenPrice => '4,99 долл. США в месяц';

  @override
  String get investComparisonQuote =>
      'Вы тратите 10 долларов на мелочи, не задумываясь – почему бы не вложить их в свой Дин?';

  @override
  String get bestValueTag => 'ЛУЧШАЯ ЦЕНА';

  @override
  String get mostPopularChoice => 'Самый популярный выбор';

  @override
  String get monthlyPriceValue => '4,99 доллара США';

  @override
  String get monthlyPriceSuffix => '/месяц';

  @override
  String get monthlyPlanSubtitle =>
      'Оплата ежемесячно. • Отменить в любое время.';

  @override
  String get yearlyPriceValue => '\$24,99';

  @override
  String get yearlyPriceSuffix => '/год';

  @override
  String get yearlyPlanSubtitle =>
      'Сэкономьте 50 % • Оплата производится ежегодно.';

  @override
  String get lifetimePriceValue => '\$79,99';

  @override
  String get lifetimePriceSuffix => 'продолжительность жизни';

  @override
  String get lifetimePlanSubtitle => 'Разовая покупка • Доступ навсегда';

  @override
  String get everythingYouGet => 'Все, что вы получаете';

  @override
  String get featureFocusModeAllModes =>
      'Неограниченный режим фокусировки со всеми 3 режимами';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'Расширенная аналитика молитв и серии';

  @override
  String get featureAiAssistant => 'ИИ исламский помощник';

  @override
  String get featurePrioritySupportEarlyAccess =>
      'Приоритетная поддержка и ранний доступ';

  @override
  String get socialProofPrefix => 'Присоединиться';

  @override
  String get socialProofHighlight => '10 000+';

  @override
  String get socialProofSuffix => 'Мусульмане уже растут вместе с Deen Focus';

  @override
  String get mostPopular => 'Самый популярный';

  @override
  String get monthlyLabel => 'Ежемесячно';

  @override
  String get monthlyPrice =>
      '4,99 долл. США в месяц · оплата ежемесячно · отмена в любое время';

  @override
  String get yearlyLabel => 'Ежегодно';

  @override
  String get yearlyPrice =>
      '24,99 долларов США в год · экономия 50 % · оплата производится ежегодно';

  @override
  String get lifetimeLabel => 'Продолжительность жизни';

  @override
  String get lifetimePrice =>
      '\$79,99 на всю жизнь · единоразовая покупка · доступ навсегда';

  @override
  String get featurePrayerAnalytics => 'Расширенная аналитика молитв';

  @override
  String get featureFocusMode => 'Неограниченный режим фокусировки';

  @override
  String get featureMasjidMode => 'Автоматический режим Масджид';

  @override
  String get featureNoAds => 'Удаляет всю рекламу';

  @override
  String get featureSupport => 'Приоритетная поддержка';

  @override
  String get homeTitle => 'Динли Хоум';

  @override
  String get homeSalam => 'Ассаляму Алейкум';

  @override
  String get homeDailyVerseFallback =>
      'Действительно, за трудностями приходит облегчение.';

  @override
  String get homeAppsLocked => 'Приложения заблокированы';

  @override
  String get homeAppsUnlocked => 'Приложения разблокированы';

  @override
  String get homeTapToUnlock =>
      'Нажмите, чтобы временно разблокировать приложения';

  @override
  String get homeTapToRelock =>
      'Нажмите, чтобы разблокировать заблокированные приложения прямо сейчас';

  @override
  String get homeRelock => 'Повторная блокировка';

  @override
  String get homeUnlock => 'Разблокировать';

  @override
  String get homePrayerModeActive => 'Режим молитвы активен';

  @override
  String get homeActivatePrayerMode => 'Активировать режим молитвы';

  @override
  String get homeAppsBlockedSubtitle =>
      'Приложения заблокированы. Нажмите, чтобы отключить.';

  @override
  String get homeBlockDistractingApps =>
      'Блокируйте отвлекающие приложения во время намаза.';

  @override
  String get homeQiblaDirection => 'Направление Киблы';

  @override
  String get homeLocationMissingForQibla =>
      'Включите местоположение для расчета направления Киблы.';

  @override
  String get homeQiblaSubtitleGuiding => 'Направляя вас к Кибле';

  @override
  String get homeToMakkah => 'в Мекку';

  @override
  String get homeFindMasjid => 'Найдите мечеть рядом со мной';

  @override
  String get quickActionsMasjidFinder => 'Поиск мечети';

  @override
  String get homeSearchNearbyMosques => 'Найдите близлежащие мечети.';

  @override
  String get homePrayerStreak => 'Молитвенные полосы';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Аналитика';

  @override
  String get homeOpenStreakDetails => 'Открыть подробную информацию о полосе.';

  @override
  String get homeTodaysPrayers => 'Сегодняшние молитвы';

  @override
  String get homePrayerTimesUnavailable => 'Время молитв сейчас недоступно.';

  @override
  String get homeNextPrayerIn => 'Следующая молитва в';

  @override
  String get homePrayerFajr => 'Фаджр';

  @override
  String get homePrayerSunrise => 'Восход';

  @override
  String get homePrayerDhuhr => 'Зухр';

  @override
  String get homePrayerAsr => 'Аср';

  @override
  String get homePrayerMaghrib => 'Магриб';

  @override
  String get homePrayerIsha => 'Иша';

  @override
  String get homeWeek => 'Неделя';

  @override
  String get homeMonth => 'Месяц';

  @override
  String get homeThisWeek => 'Основные моменты Дина на этой неделе';

  @override
  String get homeJummahMubarak => 'Джума Мубарак';

  @override
  String get homeJummahReminder => 'Не забывайте суру Аль-Кахф.';

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
      'В этот период ваша серия намазов защищена. Дни цикла выделены розовым, а Режим цикла автоматически отключается по окончании цикла.';

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
  String get cycleModeSettingsTitle => 'Режим цикла';

  @override
  String get cycleModeStartDateLabel => 'Дата начала';

  @override
  String get cycleModeLengthLabel => 'Длительность цикла';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней',
      one: '1 день',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Приостановить серии';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'Исключить из статистики';

  @override
  String get cycleModeSaveButton => 'Сохранить';

  @override
  String get cycleModeEditButton => 'Изменить';

  @override
  String get cycleModeChangeStartDateTitle => 'Изменить дату начала?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Изменение даты начала пересчитает активное окно Режима цикла. Дни вне нового диапазона могут больше не считаться днями цикла.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Изменить дату начала';

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
  String get dailyChecklistSectionPrayer => 'Молитва';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Коран и зикр';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Добрые дела';

  @override
  String get dailyChecklistSectionDistraction => 'Контроль отвлечений';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Тахаджжуд';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Вечерние азкары';

  @override
  String get dailyChecklistDhikr => 'Зикр';

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
  String get focusScoreTitle => 'Сегодняшний фокус-балл';

  @override
  String get focusScorePrayer => 'Молитва';

  @override
  String get focusScoreQuran => 'Коран';

  @override
  String get focusScoreDhikr => 'Зикр';

  @override
  String get focusScoreDistraction => 'Контроль отвлечений';

  @override
  String get insightsBack => 'Назад';

  @override
  String get insightsTitle => 'Моя аналитика';

  @override
  String get insightsSubtitle => 'Отслеживайте прогресс в дине';

  @override
  String get insightsPrayerRate => 'Доля молитв';

  @override
  String get insightsDayStreak => 'Серия дней';

  @override
  String get insightsBestStreak => 'Лучшая серия';

  @override
  String get insightsWeekly => 'Неделя';

  @override
  String get insightsMonthly => 'Месяц';

  @override
  String get insightsPrayersCompleted => 'Совершённые молитвы';

  @override
  String get insightsRestoreStreak => 'Восстановить серию — последние 24 часа';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Молитва $prayerPercent% · Коран $quranPercent% · Зикр $dhikrPercent% · Отвлечение $distractionPercent%';
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
      'Спросите что-нибудь о времени молитв, Коране и исламском руководстве.';

  @override
  String get homeDay => 'День';

  @override
  String get homeDays => 'Дни';

  @override
  String get homeNoEventsFoundForDay => 'На этот день событий не найдено.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — отметить как';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Прочитан вовремя';

  @override
  String get homeMarkPrayerQada => 'Када (восполнен)';

  @override
  String get homeMarkPrayerMissed => 'Пропущен';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return 'Настройки $prayerName';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Время намаза';

  @override
  String get homePrayerSettingsNotification => 'Уведомление';

  @override
  String get homePrayerSettingsAboutSubtitle =>
      'Достоинства, постановления и другое';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Эти настройки только для $prayerName. Вы можете задать разные предпочтения для каждого намаза.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'Изменить время $prayerName';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Текущее время';

  @override
  String get homeEditPrayerTimeSelectNew => 'Выберите новое время';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Это пользовательское время применяется только к $prayerName. Измените его, если местная мечеть или расчёт отличаются.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Сохранить время';

  @override
  String get homeEditPrayerTimeReset => 'Сбросить к рассчитанному времени';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Уведомление для $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Звук уведомления';

  @override
  String get homeNotificationSoundFullAdhan => 'Полный азан';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Воспроизвести полный азан';

  @override
  String get homeNotificationSoundBeep => 'Сигнал';

  @override
  String get homeNotificationSoundBeepSubtitle => 'Короткий тон уведомления';

  @override
  String get homeNotificationSoundMute => 'Без звука';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Нет звука';

  @override
  String get homeNotificationEnableLabel => 'Включить уведомление';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Получать уведомление во время $prayerName';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'О намазе $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Время';

  @override
  String get homeAboutPrayerRakatLabel => 'Ракааты';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Достоинства';

  @override
  String get homeAboutPrayerReferenceLabel => 'Источник';

  @override
  String get homeAboutFajrTiming =>
      'Начинается с истинного рассвета (Фаджр Садик) и заканчивается на восходе солнца.';

  @override
  String get homeAboutFajrRakat => '2 сунны + 2 фарда';

  @override
  String get homeAboutFajrVirtue =>
      'Тот, кто совершает Фаджр, находится под защитой Аллаха.';

  @override
  String get homeAboutFajrReference =>
      '«Два ракаата Фаджра лучше мира и всего, что в нём.» (Сахих Муслим)';

  @override
  String get homeAboutDhuhrTiming =>
      'Начинается после прохождения солнцем зенита и длится до начала Аср.';

  @override
  String get homeAboutDhuhrRakat => '4 сунны + 4 фарда + 2 сунны';

  @override
  String get homeAboutDhuhrVirtue =>
      'Часть 12 добровольных ракаатов в день, за которые Аллах строит дом в Раю.';

  @override
  String get homeAboutDhuhrReference =>
      '«Кто совершит двенадцать ракаатов днём и ночью, тому будет построен дом в Раю.» (Сахих Муслим)';

  @override
  String get homeAboutAsrTiming =>
      'Начинается, когда тень предмета равна его длине, и длится до заката.';

  @override
  String get homeAboutAsrRakat => '4 фарда';

  @override
  String get homeAboutAsrVirtue =>
      'Сбережение этого намаза особо выделено наградой и предостережением.';

  @override
  String get homeAboutAsrReference =>
      '«Кто пропустил намаз Аср, тот словно лишился семьи и имущества.» (Сахих аль-Бухари)';

  @override
  String get homeAboutMaghribTiming =>
      'Начинается сразу после заката и длится до исчезновения красной зари.';

  @override
  String get homeAboutMaghribRakat => '3 фарда + 2 сунны';

  @override
  String get homeAboutMaghribVirtue =>
      'Время, когда особенно поощряются мольбы.';

  @override
  String get homeAboutMaghribReference =>
      '«У постящегося две радости… когда он разговляется.» (Сахих аль-Бухари, о разговении на Магриб)';

  @override
  String get homeAboutIshaTiming =>
      'Начинается после полного исчезновения зари и длится до полуночи (или до Фаджра, по некоторым мнениям).';

  @override
  String get homeAboutIshaRakat => '4 фарда + 2 сунны + Витр';

  @override
  String get homeAboutIshaVirtue =>
      'Совершение Иша в джамаате равносильно стоянию половину ночи в молитве.';

  @override
  String get homeAboutIshaReference =>
      '«Кто совершил Иша в джамаате, тот словно простоял половину ночи.» (Сахих Муслим)';

  @override
  String get backToOnboarding => 'Вернуться к онбордингу';

  @override
  String get settings => 'Настройки';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get tabHome => 'Дом';

  @override
  String get tabFocus => 'Фокус';

  @override
  String get tabTasbih => 'Тасбих';

  @override
  String get tabQuran => 'Коран';

  @override
  String get tabLearn => 'Обучение';

  @override
  String get quranLoadFailed => 'Не удалось загрузить данные Корана.';

  @override
  String get quranTabSubtitle => 'Читайте и изучайте Священный Коран';

  @override
  String get quranSearchHint => 'Искать суру...';

  @override
  String get quranNoSurahsFound => 'Суры не найдены';

  @override
  String get quranVersesLabel => 'стихи';

  @override
  String get quranTextOptions => 'Параметры текста';

  @override
  String get quranEnglishAndArabic => 'английский и арабский';

  @override
  String get quranArabicOnly => 'только арабский';

  @override
  String get quranIncreaseFont => 'Увеличить шрифт';

  @override
  String get quranDecreaseFont => 'Уменьшить шрифт';

  @override
  String get quranPause => 'Пауза';

  @override
  String get quranPlaySurah => 'Воспроизвести суру';

  @override
  String get quranAudioNoInternet =>
      'Нет подключения к интернету. Для аудио требуется интернет.';

  @override
  String get quranAudioTimeout =>
      'Время загрузки аудио истекло. Проверьте подключение.';

  @override
  String get quranSurahLabel => 'Сура';

  @override
  String get save => 'Сохранять';

  @override
  String get tasbihBack => 'Назад';

  @override
  String get tasbihTabTitle => 'Тасбих';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Выберите зикр или создайте свой собственный';

  @override
  String get tasbihAddCustomTitle => 'Добавить Зикр';

  @override
  String get tasbihEditCustomTitle => 'Редактировать индивидуальный зикр';

  @override
  String get tasbihArabicOrDhikrHint => 'Арабский текст или любой зикр';

  @override
  String get tasbihTransliterationOptionalHint =>
      'Транслитерация (необязательно)';

  @override
  String get tasbihMeaningOptionalHint => 'Значение (необязательно)';

  @override
  String get tasbihNoTransliteration => 'Нет транслитерации';

  @override
  String get tasbihTotalCount => 'Общее количество';

  @override
  String get tasbihGrandTotalLabel => 'Всего тасбихов';

  @override
  String get tasbihTapMe => 'Коснись меня';

  @override
  String get tasbihReset => 'Перезагрузить';

  @override
  String get tasbihRestart => 'Перезапуск';

  @override
  String get tasbihCurrentCount => 'Текущий счетчик';

  @override
  String get tasbihResetTotal => 'Очистить историю';

  @override
  String get focusModeActivated => 'Режим фокусировки активирован';

  @override
  String get focusSetUpHomeCardTitle => 'Настройте режим фокуса';

  @override
  String get focusTabSubtitle =>
      'Оставайтесь сосредоточенными, когда это важнее всего';

  @override
  String get focusChooseAppsEnableMode =>
      'Выберите приложения и включите режим фокуса';

  @override
  String get focusNotifAppsLockedTitle => 'Приложения заблокированы';

  @override
  String get focusNotifAppsUnlockedTitle => 'Приложения разблокированы';

  @override
  String get focusNotifNightModeTitle => 'Ночной режим';

  @override
  String get focusNotifGoodMorningTitle => 'Доброе утро!';

  @override
  String get focusNotifAppsNowAvailableBody => 'Приложения снова доступны.';

  @override
  String get focusNotifSalahLockedBody =>
      'Приложения заблокированы во время намаза.';

  @override
  String get focusNotifSalahCompleteTitle => 'Намаз завершён';

  @override
  String get focusNotifSalahCompleteBody =>
      'Приложения разблокированы. Пусть ваш намаз будет принят.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return 'Время $prayerName';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Уделите момент для намаза $prayerName.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Ночной режим включён. Дайте отдохнуть разуму и телу.';

  @override
  String get focusNotifGenericLockedBody =>
      'Выбранные приложения заблокированы.';

  @override
  String get focusNotifMorningUnlockBody => 'Приложения недоступны.';

  @override
  String get widgetDailyVerseTitle => 'Аят дня';

  @override
  String get widgetOpenAppTimelineHint =>
      'Откройте Deen Focus, чтобы подготовить аят дня и данные виджета намаза.';

  @override
  String get widgetSetLocationForPrayers =>
      'Укажите местоположение в Deen Focus, чтобы загрузить намазы и аят дня.';

  @override
  String get focusChildModeActive => 'Детский режим активен';

  @override
  String get focusSalahAndNightModeActive => 'Салах и ночной режим активны';

  @override
  String get focusSalahModeActive => 'Режим Салаха активен';

  @override
  String get focusNightModeActive => 'Ночной режим активен';

  @override
  String get focusAppsToBlockTitle => 'Приложения для блокировки';

  @override
  String get focusAppliesAllModes => 'Применяется ко всем режимам фокусировки';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Для просмотра и выбора приложений требуется доступ к экранному времени.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Пожалуйста, примите уведомление о доступности, чтобы продолжить.';

  @override
  String get focusSelectAppsToBlock => 'Выберите приложения для блокировки';

  @override
  String get focusLoading => 'Загрузка...';

  @override
  String get focusOpen => 'Открыть';

  @override
  String get focusHide => 'Скрывать';

  @override
  String get focusLoad => 'Нагрузка';

  @override
  String get focusShow => 'Показывать';

  @override
  String get focusSalahFocusModeTitle => 'Салах Режим фокусировки';

  @override
  String get focusBlockAppsDuringPrayer =>
      'Блокировка приложений во время молитвы';

  @override
  String get focusNightDisciplineTitle => 'Ночная дисциплина';

  @override
  String get focusSleepLabel => 'Спать';

  @override
  String get focusWakeLabel => 'Будить';

  @override
  String get focusBlockAppsImmediately => 'Немедленно блокируйте приложения';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Включить блокировку приложений Android';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Чтобы заблокировать другие приложения на Android, Deenly необходимо включить разрешение на доступ. Мы откроем для вас правильный экран настроек.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Раскрытие разрешения на доступность';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly использует специальные возможности Android для обеспечения блокировки приложений в режиме фокусировки.\n\nЗачем нам это нужно: чтобы обнаружить, когда вы открываете приложение, выбранное для блокировки.\n\nКак мы его используем: только для идентификации приложения на переднем плане и отображения экрана блокировки фокуса для выбранных приложений. Мы не используем его для чтения печатного текста или личного контента.';

  @override
  String get focusNotNow => 'Не сейчас';

  @override
  String get focusIUnderstand => 'Я понимаю';

  @override
  String get focusDone => 'Сделанный';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Выработайте лучшие ночные привычки';

  @override
  String get focusPrayerBlockingDescription =>
      'Приложения будут заблокированы во время молитвы и автоматически разблокируются через 15 минут. Вы также можете разблокировать их в любое время с главного экрана.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Приложения будут заблокированы во время молитвы. Вы также можете разблокировать их в любое время с главного экрана.';

  @override
  String get focusNightBlockingDescription =>
      'Приложения будут блокироваться во время сна и автоматически разблокироваться. Вы можете разблокировать их в любое время с главного экрана.';

  @override
  String get focusChildBlockingDescription =>
      'Приложения мгновенно блокируются в детском режиме. Разблокируйте их с помощью переключателя или с главного экрана.';

  @override
  String get settingsEditUsername => 'Изменить имя пользователя';

  @override
  String get settingsEnterYourName => 'Введите свое имя';

  @override
  String get settingsPremiumTitle => 'Премиум Deen Focus';

  @override
  String get settingsPremiumSubtitle => 'Разблокируйте все функции';

  @override
  String get settingsManageSubscriptionTitle => 'Управление подпиской';

  @override
  String get settingsManageSubscriptionSubtitle => 'План или способ оплаты';

  @override
  String get settingsUsernameLabel => 'Имя пользователя';

  @override
  String get settingsLocationLabel => 'Расположение';

  @override
  String get settingsDarkModeLabel => 'Темный режим';

  @override
  String get settingsAboutTitle => 'О Дин Фокус';

  @override
  String get settingsContactUsTitle => 'Свяжитесь с нами';

  @override
  String get settingsSavingLocation => 'Сохранение...';

  @override
  String get settingsSaveLocation => 'Сохранить местоположение';

  @override
  String get settingsAboutTagline => 'Фокус. Дисциплина. Последовательность.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus помогает вам оставаться на связи с вашей верой, управляя ежедневными отвлечениями в современном мире.';

  @override
  String get settingsAboutFeature1 => 'Время молитвы с напоминаниями';

  @override
  String get settingsAboutFeature2 => 'Направление Киблы в любое время';

  @override
  String get settingsAboutFeature3 => 'Коран и Тасбих для ежедневного зикра';

  @override
  String get settingsAboutFeature4 => 'Ближайшие мечети';

  @override
  String get settingsAboutFeature5 =>
      'Умные режимы фокусировки для Салаха, сна и семейного времени';

  @override
  String get settingsAboutFocusDescription =>
      'Умные режимы фокусировки помогают блокировать отвлекающие факторы во время Салаха, сна и важных моментов, чтобы вы могли оставаться сосредоточенными и дисциплинированными.';

  @override
  String get settingsAboutFooter =>
      'Оставайтесь последовательными. Оставайтесь внимательными.\nОставайтесь на связи с вашим Дином.';

  @override
  String get settingsEnableSystemNotifications =>
      'Включите системные уведомления, чтобы включить эту функцию.';

  @override
  String get appDemoTitle => 'Демо приложения';

  @override
  String get appDemoLoadFailed =>
      'Не удалось загрузить демонстрационное видео.';

  @override
  String get appDemoRestartHint =>
      'Для видео требуется полный перезапуск приложения (горячий перезапуск может привести к сбою воспроизведения).';

  @override
  String get appDemoPreviewLoadFailed => 'Не удалось загрузить демо-версию.';

  @override
  String get appDemoTryAgain => 'Попробуйте еще раз';

  @override
  String get appDemoWatchLabel => 'Посмотреть демо';

  @override
  String get homeAiChatTitle => 'ИИ Deen Focus';

  @override
  String get homeAiAskQuestionHint => 'Задайте вопрос...';

  @override
  String get homeAiSend => 'Отправлять';

  @override
  String get homeAiErrorPrefix =>
      'Извините, у меня возникла проблема при подключении к Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Спросите что-нибудь об Исламе';

  @override
  String get homeAiEmptySubtitle =>
      'Время молитв, Коран, хадисы, исламские события и духовное руководство';

  @override
  String get onboardingTypeCityName => 'Введите название города..';

  @override
  String get onboardingNoLocationsFound => 'Места не найдены';

  @override
  String get onboardingTryAnotherCityName =>
      'Попробуйте другое название города.';

  @override
  String get qiblaCompassUnavailable => 'Компас недоступен на этом устройстве';

  @override
  String get qiblaFacing => '✓ Лицом к Кибле';

  @override
  String get qiblaTurnToFind => 'Повернитесь, чтобы найти Киблу';

  @override
  String get qiblaDistanceToMakkah => 'Расстояние до Мекка';

  @override
  String get qiblaFromNorth => 'с севера';

  @override
  String get qiblaNorthShort => 'Н';

  @override
  String get qiblaSouthShort => 'С';

  @override
  String get qiblaEastShort => 'Э';

  @override
  String get qiblaWestShort => 'Вт';

  @override
  String get nearbyMosquesTitle => 'Близлежащие мечети';

  @override
  String get nearbyMosquesTryAgain => 'Попробуйте еще раз';

  @override
  String get nearbyMosquesOpenGoogle => 'Открыть в Google Картах';

  @override
  String get nearbyMosquesOpenApple => 'Открыть в Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'В пределах не обнаружено мечетей';

  @override
  String get nearbyMosquesSearchRadius => 'Радиус поиска: 5 км';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Предварительный просмотр карты сейчас недоступен.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Ждем вашего местоположения.';

  @override
  String get nearbyMosquesFetchingLocation => 'Определение местоположения…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Текущее местоположение';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Соседние мечети появятся здесь после загрузки результатов.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'В радиусе 5 км мечетей не обнаружено.';

  @override
  String get nearbyMosquesLocationRequired =>
      'Чтобы найти близлежащие мечети, необходим доступ к местоположению.';

  @override
  String get nearbyMosquesPermissionOff =>
      'Разрешение на определение местоположения отключено. Включите его в настройках, чтобы увидеть ближайшие мечети.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'Нам не удалось прочитать ваше текущее местоположение прямо сейчас.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'Оперативное обновление не удалось. Показаны последние сохраненные результаты. Потяните, чтобы обновить.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Доступ к местоположению запрещен. Включите его в настройках, чтобы увидеть ближайшие мечети.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'На этом устройстве отключена функция определения местоположения. Включите его в настройках и повторите попытку.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'Разрешение на определение местоположения все еще обрабатывается. Пожалуйста, повторите попытку через минуту.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'Запрос занял слишком много времени. Проверьте подключение к Интернету и повторите попытку.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Нет подключения к Интернету или услуга недоступна. Проверьте подключение и повторите попытку.';

  @override
  String get nearbyMosquesFormatError =>
      'Мы не смогли сейчас прочитать список мечетей. Пожалуйста, повторите попытку позже.';

  @override
  String get nearbyMosquesPlatformError =>
      'Мы не смогли завершить этот шаг. Проверьте подключение и повторите попытку.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Что-то пошло не так. Пожалуйста, попробуйте еще раз.';

  @override
  String get nearbyMosquesEmptyHint =>
      'На OpenStreetMap ничего не указано в радиусе 5 км для этого места. Повторите попытку позже или переместите карту.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count мечетей найдено в радиусе 5 км';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Удалить зикр?';

  @override
  String get tasbihDelete => 'Удалить';

  @override
  String get focusAndroidBlockingNotReady =>
      'Блокировка приложений на Android ещё готова не полностью. Оставьте спецвозможности включёнными и подождите подключения.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Приложения не выбраны. Сначала выберите, что блокировать.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Для блокировки приложений на iPhone нужен доступ к «Экранному времени».';

  @override
  String get focusModeUpdateFailedSnack =>
      'Не удалось обновить режим фокуса. Попробуйте снова.';

  @override
  String get focusLoadingInstalledApps =>
      'Загрузка установленных приложений...';

  @override
  String get focusNoInstalledAppsToShow =>
      'Нет установленных приложений для отображения.';

  @override
  String get homeAiSuggestion1 => 'Что такое Рамадан?';

  @override
  String get homeAiSuggestion2 => 'Время намаза';

  @override
  String get homeAiSuggestion3 => 'План чтения Корана';

  @override
  String get homeAiDeveloperPrompt =>
      'Ты — знающий и уважительный исламский учёный-помощник. Помогай пользователям узнавать об исламских традициях, праздниках, молитве, изучении Корана и духовной практике. Будь тёплым, кратким, познавательным и культурно деликатным. Вне исламской тематики отвечай полезно, не притворяясь религиозной уверенностью.';

  @override
  String get homeAiErrorMissingApiKey => 'Нет настройки API.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'Ошибка API $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Ассистент не вернул ответ.';

  @override
  String get homeAiErrorEmptyContent => 'Пустое содержимое ответа.';

  @override
  String get settingsPrayerCalculationSection => 'Расчёт намаза';

  @override
  String get settingsCalculationMethodTitle => 'Метод расчёта';

  @override
  String get settingsAsrCalculationTitle => 'Расчёт Асра';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Крупные исламские организации';

  @override
  String get calculationMethodSectionMiddleEast => 'Ближний Восток';

  @override
  String get calculationMethodSectionAsiaPacific =>
      'Азиатско-Тихоокеанский регион';

  @override
  String get calculationMethodSectionSpecial => 'Специальные методы';

  @override
  String get asrMethodStandard => 'Стандарт';

  @override
  String get asrMethodStandardSubtitle => 'Шафии, Малики, Ханбали';

  @override
  String get asrMethodHanafi => 'Ханафи';

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
