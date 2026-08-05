// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دين التركيز';

  @override
  String get appTagline => 'إيمان. ركز. تناسق';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'وضع الصلاة. وضع الطفل. وضع السكون.';

  @override
  String get welcomeDescription =>
      'يمكنك تتبع صلواتك، وقراءة القرآن، وعد التسبيح، وإنشاء خطوط ذات معنى - كل ذلك في مكان واحد.';

  @override
  String get skip => 'يتخطى';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get continueButton => 'يكمل';

  @override
  String get continueForFree => 'المتابعة بالخطة المجانية';

  @override
  String get getStarted => 'فتح النسخة المميزة';

  @override
  String get language => 'لغة';

  @override
  String get cancel => 'يلغي';

  @override
  String get ok => 'نعم';

  @override
  String get openSettings => 'افتح الإعدادات';

  @override
  String get locationRequired => 'الموقع مطلوب';

  @override
  String get locationRequiredMessage =>
      'مطلوب الوصول إلى الموقع لحساب أوقات الصلاة الدقيقة واتجاه القبلة. يجب عليك تمكينه لاستخدام التطبيق.';

  @override
  String get notificationsRequired => 'الإخطارات المطلوبة';

  @override
  String get notificationsRequiredMessage =>
      'الإخطارات مطلوبة لتلقي التنبيهات والتذكيرات بوقت الصلاة.';

  @override
  String get sectTitle => 'اختر طائفتك';

  @override
  String get sectSubtitle => 'وهذا يساعدنا على تخصيص تجربتك';

  @override
  String get sectSunni => 'سني';

  @override
  String get sectShia => 'الشيعة';

  @override
  String get sectPreferNotToSay => 'يفضل عدم القول';

  @override
  String get nameTitle => 'ما اسمك؟';

  @override
  String get nameSubtitle => 'دعونا تخصيص تحيتك';

  @override
  String get namePlaceholder => 'اسمك';

  @override
  String get locationTitle => 'اعثر على قبلتك';

  @override
  String get locationSubtitle =>
      'فعّل الموقع للحصول على قبلة دقيقة وأوقات صلاة ومساجد قريبة.';

  @override
  String get locationButton => 'السماح بالوصول إلى الموقع';

  @override
  String get locationManualEntry => 'أو أدخل مدينتك';

  @override
  String get locationPrivacyNote => 'يبقى على جهازك';

  @override
  String get locationFeaturePrayerTimesTitle => 'أوقات الصلاة';

  @override
  String get locationFeatureQiblaTitle => 'القبلة';

  @override
  String get locationFeatureMasjidsTitle => 'مساجد';

  @override
  String get notificationsTitle => 'لا تفوّت صلاة أبداً';

  @override
  String get notificationsSubtitle =>
      'تنبيهات الأذان وتذكيرات التركيز والذكر اليومي — في الوقت المناسب تماماً.';

  @override
  String get notificationsButton => 'تمكين الإخطارات';

  @override
  String get notificationsEnabled => 'تم تمكين الإخطارات';

  @override
  String get notificationsPreviewDate => 'الجمعة، 10 يوليو';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'الآن';

  @override
  String get notificationsPreviewMinutesAgo => '٢ د';

  @override
  String get notificationsPreviewHourAgo => '١ س';

  @override
  String get notificationsPreviewAdhanTitle => 'أذان المغرب';

  @override
  String get notificationsPreviewAdhanBody =>
      'حان وقت الصلاة. تم إيقاف التطبيقات.';

  @override
  String get notificationsPreviewDhikrTitle => 'الذكر اليومي';

  @override
  String get notificationsPreviewDhikrBody => 'سبحان الله — خذ دقيقة للذكر.';

  @override
  String get notificationsPreviewStreakTitle => 'السلسلة';

  @override
  String get notificationsPreviewStreakBody =>
      '٧ أيام من الصلوات الكاملة. واصل!';

  @override
  String get screenTimeTitle => 'تفعيل وقت الشاشة';

  @override
  String get screenTimeSubtitle =>
      'هذا ما يتيح لـ Deen Focus إيقاف التطبيقات المشتتة أثناء الصلاة ووقت النوم ووضع الطفل.';

  @override
  String get screenTimeButton => 'السماح بالوصول إلى وقت الشاشة';

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
  String get focusModesTitle => 'كل شيء في تطبيق واحد';

  @override
  String get focusModesSubtitle =>
      'استكشف كل ما يقدمه دين فوكس. اضغط على وضع التركيز لمعرفة كيف يعمل.';

  @override
  String get focusModesSectionLabel => 'أوضاع التركيز · اضغط لمعرفة المزيد';

  @override
  String get focusPrayerTrackingSectionLabel => 'الصلاة والمتابعة';

  @override
  String get focusLearningHubSectionLabel => 'مركز التعلم';

  @override
  String get focusMoreSectionLabel => 'المزيد';

  @override
  String get focusPrayerModeTitle => 'وضع الصلاة';

  @override
  String get focusPrayerModeDescription =>
      'احظر التطبيقات المشتتة تلقائيًا أثناء الصلاة لتصلّي بخشوع تام.';

  @override
  String get focusPrayerModeBullet1 => 'قفل التطبيقات تلقائيًا عند وقت الصلاة';

  @override
  String get focusPrayerModeBullet2 => 'يُفتح القفل عند الانتهاء';

  @override
  String get focusPrayerModeBullet3 => 'يبني التركيز والاستمرارية';

  @override
  String get focusSleepModeTitle => 'وضع السكون';

  @override
  String get focusSleepModeDescription =>
      'خذ راحة بالطريقة الحلال. احظر التطبيقات عند النوم لتنال راحة جيدة وتستيقظ للفجر.';

  @override
  String get focusSleepModeBullet1 => 'حظر التطبيقات تلقائيًا عند وقت النوم';

  @override
  String get focusSleepModeBullet2 => 'تذكيرات لطيفة للاستيقاظ للفجر';

  @override
  String get focusSleepModeBullet3 => 'يحمي نومك وصلاة الفجر';

  @override
  String get focusChildModeTitle => 'وضع الطفل';

  @override
  String get focusChildModeDescription =>
      'هل تسلّم هاتفك لطفلك؟ اقفل التطبيقات فورًا حتى يرى ما هو آمن فقط.';

  @override
  String get focusChildModeBullet1 => 'وضع آمن بنقرة واحدة';

  @override
  String get focusChildModeBullet2 => 'خروج محمي برمز مرور';

  @override
  String get focusChildModeBullet3 => 'راحة بال في كل مرة';

  @override
  String get focusModeGotIt => 'حسنًا';

  @override
  String get focusFeaturePrayerTimesTitle => 'أوقات صلاة دقيقة';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'الأذان والتذكيرات';

  @override
  String get focusFeatureStreaksTitle => 'السلاسل';

  @override
  String get focusFeatureStreaksSubtitle => 'حافظ على الاستمرارية';

  @override
  String get focusFeatureChecklistTitle => 'القائمة اليومية';

  @override
  String get focusFeatureChecklistSubtitle => 'ابنِ عادات جيدة';

  @override
  String get focusFeatureQiblaTitle => 'القبلة والمسجد';

  @override
  String get focusFeatureQiblaSubtitle => 'الاتجاه والمساجد';

  @override
  String get focusFeatureQuranTitle => 'القرآن';

  @override
  String get focusFeatureQuranSubtitle => 'ترجمات وأجزاء وصفحات';

  @override
  String get focusFeatureHadithTitle => 'الحديث';

  @override
  String get focusFeatureHadithSubtitle => 'مجموعات موثوقة';

  @override
  String get focusFeatureDuasTitle => 'الأدعية';

  @override
  String get focusFeatureDuasSubtitle => 'أدعية يومية';

  @override
  String get focusFeatureTasbihTitle => 'التسبيح';

  @override
  String get focusFeatureTasbihSubtitle => 'عداد ذكر رقمي';

  @override
  String get focusFeatureAiTitle => 'المرافق الذكي';

  @override
  String get focusFeatureAiSubtitle => 'اسأل عن دينك';

  @override
  String get focusFeatureInsightsTitle => 'الإحصاءات';

  @override
  String get focusFeatureInsightsSubtitle => 'إحصاءات أسبوعية وشهرية';

  @override
  String get investTitle => 'استثمر في دينك';

  @override
  String get investSubtitle =>
      'لا تفكر مرتين في الإنفاق على القهوة أو الوجبات الخفيفة...';

  @override
  String get investComparisonTitle => 'اشترك في النسخة المميزة أو تابع مجاناً';

  @override
  String get investDailyCoffee => 'القهوة اليومية';

  @override
  String get investDailyCoffeePrice => '5 دولارات في اليوم';

  @override
  String get investFastFood => 'الوجبات السريعة';

  @override
  String get investFastFoodPrice => '10 دولارات/وجبة';

  @override
  String get investYourDeen => 'دينك';

  @override
  String get investYourDeenPrice => '4.99 دولار/الشهر';

  @override
  String get investComparisonQuote =>
      'أنت تنفق 10 دولارات على أشياء صغيرة دون تفكير، فلماذا لا تستثمر في دينك؟';

  @override
  String get bestValueTag => 'أفضل قيمة';

  @override
  String get mostPopularChoice => 'الاختيار الأكثر شعبية';

  @override
  String get monthlyPriceValue => '4.99 دولار';

  @override
  String get monthlyPriceSuffix => '/شهر';

  @override
  String get monthlyPlanSubtitle =>
      'يتم إصدار الفاتورة شهريًا • الإلغاء في أي وقت';

  @override
  String get yearlyPriceValue => '24.99 دولارًا';

  @override
  String get yearlyPriceSuffix => '/سنة';

  @override
  String get yearlyPlanSubtitle => 'وفر 50% • يتم إصدار الفاتورة سنويًا';

  @override
  String get lifetimePriceValue => '79.99 دولارًا';

  @override
  String get lifetimePriceSuffix => 'حياة';

  @override
  String get lifetimePlanSubtitle => 'شراء لمرة واحدة • الوصول إلى الأبد';

  @override
  String get everythingYouGet => 'كل ما تحصل عليه';

  @override
  String get featureFocusModeAllModes =>
      'وضع تركيز غير محدود مع جميع الأوضاع الثلاثة';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'تحليلات الصلاة المتقدمة والشرائط';

  @override
  String get featureAiAssistant => 'مساعد إسلامي';

  @override
  String get featurePrioritySupportEarlyAccess => 'دعم الأولوية والوصول المبكر';

  @override
  String get socialProofPrefix => 'ينضم';

  @override
  String get socialProofHighlight => '10,000+';

  @override
  String get socialProofSuffix => 'المسلمون ينمون بالفعل مع التركيز على الدين';

  @override
  String get mostPopular => 'الأكثر شعبية';

  @override
  String get monthlyLabel => 'شهريا';

  @override
  String get monthlyPrice =>
      '4.99 دولارًا شهريًا · يتم إصدار الفاتورة شهريًا · يمكنك الإلغاء في أي وقت';

  @override
  String get yearlyLabel => 'سنوي';

  @override
  String get yearlyPrice =>
      '24.99 دولارًا سنويًا · وفر 50٪ · يتم إصدار الفاتورة سنويًا';

  @override
  String get lifetimeLabel => 'حياة';

  @override
  String get lifetimePrice =>
      '79.99 دولارًا أمريكيًا مدى الحياة · الشراء لمرة واحدة · الوصول إلى الأبد';

  @override
  String get featurePrayerAnalytics => 'تحليلات الصلاة المتقدمة';

  @override
  String get featureFocusMode => 'وضع تركيز غير محدود';

  @override
  String get featureMasjidMode => 'الوضع التلقائي للمسجد';

  @override
  String get featureNoAds => 'يزيل كافة الإعلانات';

  @override
  String get featureSupport => 'دعم الأولوية';

  @override
  String get homeTitle => 'منزل دينلي';

  @override
  String get homeSalam => 'السلام عليكم';

  @override
  String get homeDailyVerseFallback => 'والحقيقة أن مع العسر يسرا.';

  @override
  String get homeAppsLocked => 'التطبيقات مقفلة';

  @override
  String get homeAppsUnlocked => 'التطبيقات مقفلة';

  @override
  String get homeTapToUnlock => 'انقر لفتح التطبيقات مؤقتًا';

  @override
  String get homeTapToRelock => 'انقر لإعادة قفل التطبيقات المحظورة الآن';

  @override
  String get homeRelock => 'إعادة القفل';

  @override
  String get homeUnlock => 'فتح';

  @override
  String get homePrayerModeActive => 'وضع الصلاة نشط';

  @override
  String get homeActivatePrayerMode => 'تفعيل وضع الصلاة';

  @override
  String get homeAppsBlockedSubtitle =>
      'تم حظر التطبيقات. انقر لإلغاء التنشيط.';

  @override
  String get homeBlockDistractingApps => 'منع تشتيت التطبيقات أثناء الصلاة.';

  @override
  String get homeQiblaDirection => 'اتجاه القبلة';

  @override
  String get homeLocationMissingForQibla => 'تمكين الموقع لحساب اتجاه القبلة.';

  @override
  String get homeQiblaSubtitleGuiding => 'إرشادك نحو القبلة';

  @override
  String get homeToMakkah => 'إلى مكة';

  @override
  String get homeFindMasjid => 'البحث عن مسجد بالقرب مني';

  @override
  String get quickActionsMasjidFinder => 'البحث عن مسجد';

  @override
  String get homeSearchNearbyMosques => 'بحث المساجد القريبة.';

  @override
  String get homePrayerStreak => 'خطوط الصلاة';

  @override
  String homePrayersInARow(int count) {
    return '$count صلوات متتالية';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count أيام';
  }

  @override
  String get homeInsights => 'الرؤى';

  @override
  String get homeOpenStreakDetails => 'تفاصيل الخط المفتوح.';

  @override
  String get homeTodaysPrayers => 'صلوات اليوم';

  @override
  String get homePrayerTimesUnavailable => 'أوقات الصلاة غير متوفرة الآن.';

  @override
  String get homeNextPrayerIn => 'الصلاة القادمة في';

  @override
  String get homePrayerFajr => 'الفجر';

  @override
  String get homePrayerSunrise => 'شروق الشمس';

  @override
  String get homePrayerDhuhr => 'الظهر';

  @override
  String get homePrayerAsr => 'العصر';

  @override
  String get homePrayerMaghrib => 'المغرب';

  @override
  String get homePrayerIsha => 'العشاء';

  @override
  String get homeWeek => 'أسبوع';

  @override
  String get homeMonth => 'شهر';

  @override
  String get homeThisWeek => 'أبرز أحداث دين هذا الأسبوع';

  @override
  String get homeJummahMubarak => 'جمعة مبارك';

  @override
  String get homeJummahReminder => 'لا تنسوا سورة الكهف .';

  @override
  String get hijriYear => 'هـ';

  @override
  String get hijriMonthMuharram => 'محرم';

  @override
  String get hijriMonthSafar => 'صفر';

  @override
  String get hijriMonthRabiAlAwwal => 'ربيع الأول';

  @override
  String get hijriMonthRabiAlThani => 'ربيع الثاني';

  @override
  String get hijriMonthJumadaAlAwwal => 'جمادى الأولى';

  @override
  String get hijriMonthJumadaAlThani => 'جمادى الثانية';

  @override
  String get hijriMonthRajab => 'رجب';

  @override
  String get hijriMonthShaban => 'شعبان';

  @override
  String get hijriMonthRamadan => 'رمضان';

  @override
  String get hijriMonthShawwal => 'شوال';

  @override
  String get hijriMonthDhuAlQadah => 'ذو القعدة';

  @override
  String get hijriMonthDhuAlHijjah => 'ذو الحجة';

  @override
  String get calendarTitle => 'التقويم الإسلامي';

  @override
  String get calendarBack => 'رجوع';

  @override
  String get calendarToday => 'اليوم';

  @override
  String get calendarTomorrow => 'غداً';

  @override
  String calendarDaysAway(int days) {
    return '$days أيام';
  }

  @override
  String get calendarNoEventsThisWeek => 'لا توجد أحداث إسلامية هذا الأسبوع';

  @override
  String get calendarNoEventsBlessing => 'بارك الله أسبوعكم بالسلام والخير.';

  @override
  String get calendarNoUpcomingEvents => 'لا توجد مناسبات إسلامية قادمة.';

  @override
  String get calendarUpcomingEvents => 'الأحداث الإسلامية القادمة';

  @override
  String get calendarUpcomingThisYear => 'قادم هذا العام';

  @override
  String get calendarThisWeekObservances => 'هذا الأسبوع';

  @override
  String get calendarLegendCycleDays => 'أيام الدورة (السلسلة محمية)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% مضاء';
  }

  @override
  String get calendarMoonNew => 'محاق';

  @override
  String get calendarMoonWaxingCrescent => 'هلال متزايد';

  @override
  String get calendarMoonFirstQuarter => 'تربيع أول';

  @override
  String get calendarMoonWaxingGibbous => 'أحدب متزايد';

  @override
  String get calendarMoonFull => 'بدر';

  @override
  String get calendarMoonWaningGibbous => 'أحدب متناقص';

  @override
  String get calendarMoonLastQuarter => 'تربيع أخير';

  @override
  String get calendarMoonWaningCrescent => 'هلال متناقص';

  @override
  String get calendarEventRamadanBegins => 'بداية رمضان';

  @override
  String get calendarEventRamadanBeginsDesc => 'شهر الصيام';

  @override
  String get calendarEventLaylatAlQadr => 'ليلة القدر';

  @override
  String get calendarEventLaylatAlQadrDesc => 'ليلة القدر المباركة';

  @override
  String get calendarEventEidAlFitr => 'عيد الفطر';

  @override
  String get calendarEventEidAlFitrDesc => 'عيد الفطر المبارك';

  @override
  String get calendarEventDayOfArafah => 'يوم عرفة';

  @override
  String get calendarEventDayOfArafahDesc => 'يوم الوقوف بعرفة';

  @override
  String get calendarEventEidAlAdha => 'عيد الأضحى';

  @override
  String get calendarEventEidAlAdhaDesc => 'عيد التضحية';

  @override
  String get calendarEventIslamicNewYear => 'رأس السنة الهجرية';

  @override
  String get calendarEventIslamicNewYearDesc => '١ محرم';

  @override
  String get calendarEventMawlid => 'المولد النبوي';

  @override
  String get calendarEventMawlidDesc => 'مولد النبي ﷺ';

  @override
  String get calendarEventAshura => 'عاشوراء';

  @override
  String get calendarEventAshuraDesc => '١٠ محرم';

  @override
  String get calendarEventJumuah => 'الجمعة';

  @override
  String get calendarEventJumuahDesc => 'صلاة الجمعة';

  @override
  String get calendarEventWhiteDays => 'الأيام البيض';

  @override
  String get calendarEventWhiteDaysDesc => 'أيام الصيام المستحبة';

  @override
  String get cycleModeActiveTitle =>
      '«يريد الله بكم اليسر ولا يريد بكم العسر» — البقرة ١٨٥';

  @override
  String get cycleModeActiveSubtitle =>
      'خلال هذه الفترة، سلسلتك محمية. أيام الدورة مميزة بالوردي، ويتوقف وضع الدورة تلقائياً عند انتهاء الدورة.';

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
  String get cycleModeStreakProtected => 'سلسلة الصلاة محمية خلال فترتك';

  @override
  String get cycleModeCalendarHighlighted => 'أيام التقويم مميزة باللون الوردي';

  @override
  String cycleModeAutoEndInfo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ينتهي تلقائياً في $days أيام',
      one: 'ينتهي تلقائياً غداً',
      zero: 'ينتهي اليوم',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeSettingsTitle => 'وضع الدورة';

  @override
  String get cycleModeStartDateLabel => 'تاريخ البدء';

  @override
  String get cycleModeLengthLabel => 'مدة الدورة';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام',
      one: 'يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'إيقاف السلاسل مؤقتاً';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'استبعاد من الإحصائيات';

  @override
  String get cycleModeSaveButton => 'حفظ';

  @override
  String get cycleModeEditButton => 'تعديل';

  @override
  String get cycleModeChangeStartDateTitle => 'تغيير تاريخ البدء؟';

  @override
  String get cycleModeChangeStartDateMessage =>
      'سيؤدي تغيير تاريخ البدء إلى إعادة حساب نافذة وضع الدورة النشطة. قد لا تُعامل الأيام خارج النطاق الجديد كأيام دورة.';

  @override
  String get cycleModeChangeStartDateConfirm => 'تغيير تاريخ البدء';

  @override
  String prayerReminderTitle(String prayer) {
    return 'هل صليت $prayer؟';
  }

  @override
  String get prayerReminderSubtitle => 'حافظ على سلسلتك من خلال تسجيل صلاتك';

  @override
  String get prayerReminderYesButton => 'نعم، الحمد لله';

  @override
  String get prayerReminderLaterButton => 'سأسجلها لاحقاً';

  @override
  String get homeTrialBannerTitle => 'مجاناً لمدة ٧ أيام — كن مسلماً أفضل ✨';

  @override
  String get homeTrialBannerSubtitle => 'كل الميزات مفتوحة. ابدأ رحلتك اليوم.';

  @override
  String get homeFocusModeTitle => 'وضع التركيز';

  @override
  String get homeFocusModeSubtitle => 'احجب التطبيقات المشتتة أثناء الصلاة';

  @override
  String get cycleModeTitle => 'وضع الدورة';

  @override
  String get cycleModeSubtitle => 'للحيض — أوقفي الصلوات مع الحفاظ على سلسلتك';

  @override
  String get dailyChecklistTitle => 'قائمة المهام اليومية';

  @override
  String get dailyChecklistSectionPrayer => 'الصلاة';

  @override
  String get dailyChecklistSectionQuranDhikr => 'القرآن والذكر';

  @override
  String get dailyChecklistSectionGoodDeeds => 'أعمال صالحة';

  @override
  String get dailyChecklistSectionDistraction => 'التحكم في التشتيت';

  @override
  String get dailyChecklistFajr => 'الفجر';

  @override
  String get dailyChecklistTahajjud => 'التهجد';

  @override
  String get dailyChecklistQuran => 'القرآن';

  @override
  String get dailyChecklistMorningAdhkar => 'أذكار الصباح';

  @override
  String get dailyChecklistEveningAdhkar => 'أذكار المساء';

  @override
  String get dailyChecklistDhikr => 'الذكر';

  @override
  String get dailyChecklistCharity => 'صدقة';

  @override
  String get dailyChecklistSmileAtSomeone => 'ابتسم لأحد';

  @override
  String get dailyChecklistFamilyCall => 'اتصال بالعائلة';

  @override
  String get dailyChecklistNoMusicToday => 'بدون موسيقى اليوم';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'بدون وسائل تواصل قبل العشاء';

  @override
  String get focusScoreTitle => 'درجة التركيز اليوم';

  @override
  String get focusScorePrayer => 'الصلاة';

  @override
  String get focusScoreQuran => 'القرآن';

  @override
  String get focusScoreDhikr => 'الذكر';

  @override
  String get focusScoreDistraction => 'التحكم في التشتيت';

  @override
  String get insightsBack => 'رجوع';

  @override
  String get insightsTitle => 'رؤاي';

  @override
  String get insightsSubtitle => 'تتبع تقدّم دينك';

  @override
  String get insightsPrayerRate => 'معدل الصلاة';

  @override
  String get insightsDayStreak => 'سلسلة الأيام';

  @override
  String get insightsBestStreak => 'أفضل سلسلة';

  @override
  String get insightsWeekly => 'أسبوعي';

  @override
  String get insightsMonthly => 'شهري';

  @override
  String get insightsPrayersCompleted => 'الصلوات المكتملة';

  @override
  String get insightsRestoreStreak => 'استعادة سلسلتي — آخر ٢٤ ساعة';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'الصلاة $prayerPercent% · القرآن $quranPercent% · الذكر $dhikrPercent% · التشتت $distractionPercent%';
  }

  @override
  String get quickActionsCalendar => 'التقويم';

  @override
  String get quickActionsCalendarSubtitle => 'عرض التواريخ الهجرية';

  @override
  String get quickActionsSupportUs => 'ادعمني';

  @override
  String get quickActionsSupportUsSubtitle => 'ساعدنا على النمو';

  @override
  String get quickActionsSupportUsMessage =>
      'شكراً لتفكيرك في دعم DeenFocus! ميزات الدعم قادمة قريباً.';

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
      'اسأل أي شيء عن أوقات الصلاة والقرآن والإرشادات الإسلامية.';

  @override
  String get homeDay => 'يوم';

  @override
  String get homeDays => 'أيام';

  @override
  String get homeNoEventsFoundForDay => 'لم يتم العثور على أحداث لهذا اليوم.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — سجّل كـ';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'صُليت في وقتها';

  @override
  String get homeMarkPrayerQada => 'قضاء (تعويض)';

  @override
  String get homeMarkPrayerMissed => 'فائتة';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return 'إعدادات $prayerName';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'وقت الصلاة';

  @override
  String get homePrayerSettingsNotification => 'الإشعار';

  @override
  String get homePrayerSettingsAboutSubtitle => 'فضائل وأحكام والمزيد';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'هذه الإعدادات خاصة بصلاة $prayerName فقط. يمكنك تعيين تفضيلات مختلفة لكل صلاة.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'تعديل وقت $prayerName';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'الوقت الحالي';

  @override
  String get homeEditPrayerTimeSelectNew => 'اختر وقتًا جديدًا';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'هذا الوقت المخصص ينطبق على $prayerName فقط. عدّله إذا كان مسجدك المحلي أو طريقة الحساب مختلفين.';
  }

  @override
  String get homeEditPrayerTimeSave => 'حفظ الوقت';

  @override
  String get homeEditPrayerTimeReset => 'إعادة إلى الوقت المحسوب';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'إشعار $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'صوت الإشعار';

  @override
  String get homeNotificationSoundFullAdhan => 'الأذان الكامل';

  @override
  String get homeNotificationSoundFullAdhanSubtitle => 'تشغيل الأذان بالكامل';

  @override
  String get homeNotificationSoundBeep => 'صفير';

  @override
  String get homeNotificationSoundBeepSubtitle => 'نغمة إشعار قصيرة';

  @override
  String get homeNotificationSoundMute => 'صامت';

  @override
  String get homeNotificationSoundMuteSubtitle => 'بدون صوت';

  @override
  String get homeNotificationEnableLabel => 'تفعيل الإشعار';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'احصل على إشعار عند وقت $prayerName';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'عن صلاة $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'الوقت';

  @override
  String get homeAboutPrayerRakatLabel => 'الركعات';

  @override
  String get homeAboutPrayerVirtuesLabel => 'الفضائل';

  @override
  String get homeAboutPrayerReferenceLabel => 'المرجع';

  @override
  String get homeAboutFajrTiming =>
      'يبدأ من طلوع الفجر الصادق وينتهي بطلوع الشمس.';

  @override
  String get homeAboutFajrRakat => 'ركعتان سنة + ركعتان فرض';

  @override
  String get homeAboutFajrVirtue => 'من صلّى الفجر فهو في ذمة الله.';

  @override
  String get homeAboutFajrReference =>
      '«ركعتا الفجر خير من الدنيا وما فيها» (صحيح مسلم)';

  @override
  String get homeAboutDhuhrTiming =>
      'يبدأ بعد زوال الشمس ويستمر حتى يدخل وقت العصر.';

  @override
  String get homeAboutDhuhrRakat => '٤ سنة + ٤ فرض + ٢ سنة';

  @override
  String get homeAboutDhuhrVirtue =>
      'من اثنتي عشرة ركعة تطوعًا في اليوم والليلة يبني الله بها بيتًا في الجنة.';

  @override
  String get homeAboutDhuhrReference =>
      '«من صلّى اثنتي عشرة ركعة في يوم وليلة بُني له بهن بيت في الجنة» (صحيح مسلم)';

  @override
  String get homeAboutAsrTiming =>
      'يبدأ عندما يصير ظل الشيء مثله ويستمر حتى غروب الشمس.';

  @override
  String get homeAboutAsrRakat => '٤ فرض';

  @override
  String get homeAboutAsrVirtue =>
      'المحافظة على هذه الصلاة مخصوصة بثواب وتحذير عظيمين.';

  @override
  String get homeAboutAsrReference =>
      '«من فاتته صلاة العصر فكأنما وُتر أهله وماله» (صحيح البخاري)';

  @override
  String get homeAboutMaghribTiming =>
      'يبدأ بعد غروب الشمس مباشرة ويستمر حتى يغيب الشفق الأحمر.';

  @override
  String get homeAboutMaghribRakat => '٣ فرض + ٢ سنة';

  @override
  String get homeAboutMaghribVirtue => 'وقت يُستحب فيه الدعاء بشكل خاص.';

  @override
  String get homeAboutMaghribReference =>
      '«للصائم فرحتان... فرحة عند فطره» (صحيح البخاري، في الإفطار عند المغرب)';

  @override
  String get homeAboutIshaTiming =>
      'يبدأ بعد غياب الشفق تمامًا ويستمر حتى منتصف الليل (أو إلى الفجر عند بعض الآراء).';

  @override
  String get homeAboutIshaRakat => '٤ فرض + ٢ سنة + الوتر';

  @override
  String get homeAboutIshaVirtue => 'صلاة العشاء جماعة تعدل قيام نصف الليل.';

  @override
  String get homeAboutIshaReference =>
      '«من صلّى العشاء في جماعة فكأنما قام نصف الليل» (صحيح مسلم)';

  @override
  String get backToOnboarding => 'العودة إلى الإعداد';

  @override
  String get settings => 'إعدادات';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get tabHome => 'بيت';

  @override
  String get tabFocus => 'ركز';

  @override
  String get tabTasbih => 'التسبيح';

  @override
  String get tabQuran => 'القرآن';

  @override
  String get tabLearn => 'تعلّم';

  @override
  String get quranLoadFailed => 'فشل تحميل بيانات القرآن';

  @override
  String get quranTabSubtitle => 'قراءة واستكشاف القرآن الكريم';

  @override
  String get quranSearchHint => 'بحث في سورة...';

  @override
  String get quranNoSurahsFound => 'لم يتم العثور على سورة';

  @override
  String get quranVersesLabel => 'الآيات';

  @override
  String get quranTextOptions => 'خيارات النص';

  @override
  String get quranEnglishAndArabic => 'الإنجليزية والعربية';

  @override
  String get quranArabicOnly => 'العربية فقط';

  @override
  String get quranIncreaseFont => 'زيادة الخط';

  @override
  String get quranDecreaseFont => 'تقليل الخط';

  @override
  String get quranPause => 'يوقف';

  @override
  String get quranPlaySurah => 'لعب سورة';

  @override
  String get quranAudioNoInternet =>
      'لا يوجد اتصال بالإنترنت. الصوت يتطلب الإنترنت.';

  @override
  String get quranAudioTimeout => 'انتهت مهلة تحميل الصوت. تحقق من اتصالك.';

  @override
  String get quranSurahLabel => 'سورة';

  @override
  String get save => 'يحفظ';

  @override
  String get tasbihBack => 'خلف';

  @override
  String get tasbihTabTitle => 'التسبيح';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'اختر الذكر أو قم بإنشاء الذكر الخاص بك';

  @override
  String get tasbihAddCustomTitle => 'أضف الذكر';

  @override
  String get tasbihEditCustomTitle => 'تحرير الأذكار المخصصة';

  @override
  String get tasbihArabicOrDhikrHint => 'النص العربي أو أي الذكر';

  @override
  String get tasbihTransliterationOptionalHint => 'الترجمة الصوتية (اختياري)';

  @override
  String get tasbihMeaningOptionalHint => 'المعنى (اختياري)';

  @override
  String get tasbihNoTransliteration => 'لا الترجمة الصوتية';

  @override
  String get tasbihTotalCount => 'العدد الإجمالي';

  @override
  String get tasbihGrandTotalLabel => 'مجموع التسبيح';

  @override
  String get tasbihTapMe => 'اضغط علي';

  @override
  String get tasbihReset => 'إعادة ضبط';

  @override
  String get tasbihRestart => 'إعادة تشغيل';

  @override
  String get tasbihCurrentCount => 'العدد الحالي';

  @override
  String get tasbihResetTotal => 'مسح التاريخ';

  @override
  String get focusModeActivated => 'تم تنشيط وضع التركيز';

  @override
  String get focusSetUpHomeCardTitle => 'إعداد وضع التركيز';

  @override
  String get focusTabSubtitle => 'حافظ على تركيزك عندما يكون الأمر أكثر أهمية';

  @override
  String get focusChooseAppsEnableMode => 'اختر التطبيقات وفعّل وضع التركيز';

  @override
  String get focusNotifAppsLockedTitle => 'التطبيقات مقفلة';

  @override
  String get focusNotifAppsUnlockedTitle => 'التطبيقات متاحة';

  @override
  String get focusNotifNightModeTitle => 'الوضع الليلي';

  @override
  String get focusNotifGoodMorningTitle => 'صباح الخير!';

  @override
  String get focusNotifAppsNowAvailableBody => 'التطبيقات متاحة الآن.';

  @override
  String get focusNotifSalahLockedBody => 'التطبيقات مقفلة أثناء الصلاة.';

  @override
  String get focusNotifSalahCompleteTitle => 'اكتملت الصلاة';

  @override
  String get focusNotifSalahCompleteBody =>
      'التطبيقات متاحة الآن. تقبل الله صلاتك.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return 'وقت $prayerName';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'خذ لحظة لصلاة $prayerName.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'الوضع الليلي مفعّل. دع عقلك وجسمك يرتاحان.';

  @override
  String get focusNotifGenericLockedBody => 'التطبيقات المحددة مقفلة.';

  @override
  String get focusNotifMorningUnlockBody => 'التطبيقات غير متاحة.';

  @override
  String get widgetDailyVerseTitle => 'آية اليوم';

  @override
  String get widgetOpenAppTimelineHint =>
      'افتح Deen Focus لتحضير آية اليوم وبيانات أداة الصلاة.';

  @override
  String get widgetSetLocationForPrayers =>
      'حدد موقعك في Deen Focus لتحميل أوقات الصلاة وآية اليوم.';

  @override
  String get focusChildModeActive => 'وضع الطفل نشط';

  @override
  String get focusSalahAndNightModeActive => 'صلاح والوضع الليلي نشط';

  @override
  String get focusSalahModeActive => 'وضع صلاح نشط';

  @override
  String get focusNightModeActive => 'الوضع الليلي نشط';

  @override
  String get focusAppsToBlockTitle => 'تطبيقات للحظر';

  @override
  String get focusAppliesAllModes => 'ينطبق على جميع أوضاع التركيز';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'يلزم الوصول إلى \"مدة استخدام الجهاز\" لعرض التطبيقات وتحديدها.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'يُرجى قبول الإفصاح عن إمكانية الوصول للمتابعة.';

  @override
  String get focusSelectAppsToBlock => 'حدد التطبيقات المراد حظرها';

  @override
  String get focusLoading => 'تحميل...';

  @override
  String get focusOpen => 'يفتح';

  @override
  String get focusHide => 'يخفي';

  @override
  String get focusLoad => 'حمولة';

  @override
  String get focusShow => 'يعرض';

  @override
  String get focusSalahFocusModeTitle => 'وضع صلاح التركيز';

  @override
  String get focusBlockAppsDuringPrayer => 'حظر التطبيقات أثناء الصلاة';

  @override
  String get focusNightDisciplineTitle => 'الانضباط الليلي';

  @override
  String get focusSleepLabel => 'ينام';

  @override
  String get focusWakeLabel => 'استيقظ';

  @override
  String get focusBlockAppsImmediately => 'حظر التطبيقات على الفور';

  @override
  String get focusEnableAndroidAppBlocking => 'تفعيل حظر تطبيقات أندرويد';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'لحظر التطبيقات الأخرى على Android، يحتاج Deenly إلى تشغيل إذن الوصول الخاص به. سنفتح لك شاشة الإعدادات الصحيحة.';

  @override
  String get focusAccessibilityDisclosureTitle => 'الكشف عن إذن الوصول';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'يستخدم Deenly إمكانية الوصول إلى Android لفرض حظر تطبيق وضع التركيز.\n\nلماذا نحتاج إليه: لاكتشاف وقت فتح التطبيق الذي حددته للحظر.\n\nكيف نستخدمه: فقط لتحديد التطبيق الأمامي وإظهار شاشة كتلة التركيز للتطبيقات المحددة. نحن لا نستخدمه لقراءة النص المكتوب أو المحتوى الشخصي.';

  @override
  String get focusNotNow => 'ليس الآن';

  @override
  String get focusIUnderstand => 'أفهم';

  @override
  String get focusDone => 'منتهي';

  @override
  String get focusNightDisciplineCardSubtitle => 'بناء عادات ليلية أفضل';

  @override
  String get focusPrayerBlockingDescription =>
      'سيتم حظر التطبيقات أثناء الصلاة وسيتم فتحها تلقائيًا بعد 15 دقيقة، أو يمكنك فتحها في أي وقت من الشاشة الرئيسية.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'سيتم حظر التطبيقات أثناء الصلاة، أو يمكنك فتحها في أي وقت من الشاشة الرئيسية.';

  @override
  String get focusNightBlockingDescription =>
      'سيتم حظر التطبيقات أثناء دورة نومك وسيتم إلغاء قفلها تلقائيًا، أو يمكنك إلغاء قفلها في أي وقت من الشاشة الرئيسية';

  @override
  String get focusChildBlockingDescription =>
      'يتم حظر التطبيقات على الفور في وضع الطفل. قم بإلغاء قفلها باستخدام زر التبديل أو من الشاشة الرئيسية';

  @override
  String get settingsEditUsername => 'تحرير اسم المستخدم';

  @override
  String get settingsEnterYourName => 'أدخل اسمك';

  @override
  String get settingsPremiumTitle => 'دين فوكس بريميوم';

  @override
  String get settingsPremiumSubtitle => 'فتح كافة الميزات';

  @override
  String get settingsManageSubscriptionTitle => 'إدارة الاشتراك';

  @override
  String get settingsManageSubscriptionSubtitle => 'اعرض خطتك أو حدّث الفوترة';

  @override
  String get settingsUsernameLabel => 'اسم المستخدم';

  @override
  String get settingsLocationLabel => 'موقع';

  @override
  String get settingsDarkModeLabel => 'الوضع المظلم';

  @override
  String get settingsAboutTitle => 'نبذة عن دين فوكس';

  @override
  String get settingsContactUsTitle => 'اتصل بنا';

  @override
  String get settingsSavingLocation => 'توفير...';

  @override
  String get settingsSaveLocation => 'حفظ الموقع';

  @override
  String get settingsAboutTagline => 'ركز. تأديب. تناسق.';

  @override
  String get settingsAboutDescription =>
      'يساعدك دين فوكس على البقاء على اتصال بإيمانك أثناء إدارة المشتتات اليومية في عالم حديث.';

  @override
  String get settingsAboutFeature1 => 'أوقات الصلاة مع التذكيرات';

  @override
  String get settingsAboutFeature2 => 'اتجاه القبلة في أي وقت';

  @override
  String get settingsAboutFeature3 => 'القرآن والتسبيح للذكر اليومي';

  @override
  String get settingsAboutFeature4 => 'المساجد القريبة';

  @override
  String get settingsAboutFeature5 =>
      'أوضاع تركيز ذكية للصلاة والنوم ووقت العائلة';

  @override
  String get settingsAboutFocusDescription =>
      'تساعدك أوضاع التركيز الذكية على حظر المشتتات أثناء الصلاة والنوم واللحظات المهمة، حتى تتمكن من البقاء حاضرًا ومنضبطًا.';

  @override
  String get settingsAboutFooter =>
      'ابق متسقًا. ابق يقظًا.\nابق على اتصال بدينك.';

  @override
  String get settingsEnableSystemNotifications =>
      'قم بتمكين إشعارات النظام لتشغيل هذا.';

  @override
  String get appDemoTitle => 'عرض التطبيق';

  @override
  String get appDemoLoadFailed => 'تعذر تحميل الفيديو التجريبي.';

  @override
  String get appDemoRestartHint =>
      'يحتاج الفيديو إلى إعادة تشغيل التطبيق بالكامل (قد تؤدي إعادة التشغيل السريعة إلى انقطاع التشغيل).';

  @override
  String get appDemoPreviewLoadFailed => 'تعذر تحميل العرض التوضيحي.';

  @override
  String get appDemoTryAgain => 'حاول ثانية';

  @override
  String get appDemoWatchLabel => 'شاهد العرض التوضيحي';

  @override
  String get homeAiChatTitle => 'دين فوكس للذكاء الاصطناعي';

  @override
  String get homeAiAskQuestionHint => 'اطرح سؤالا...';

  @override
  String get homeAiSend => 'يرسل';

  @override
  String get homeAiErrorPrefix =>
      'عذرًا، لقد واجهت مشكلة أثناء الاتصال بـ Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'اسأل أي شيء عن الإسلام';

  @override
  String get homeAiEmptySubtitle =>
      'أوقات الصلاة، القرآن، الحديث، الأحداث الإسلامية، والإرشاد الروحي';

  @override
  String get onboardingTypeCityName => 'اكتب اسم مدينتك ..';

  @override
  String get onboardingNoLocationsFound => 'لم يتم العثور على مواقع';

  @override
  String get onboardingTryAnotherCityName => 'جرب اسم مدينة آخر.';

  @override
  String get qiblaCompassUnavailable => 'البوصلة غير متوفرة على هذا الجهاز';

  @override
  String get qiblaFacing => '✓ مواجهة القبلة';

  @override
  String get qiblaTurnToFind => 'أنتقل للعثور على القبلة';

  @override
  String get qiblaDistanceToMakkah => 'المسافة إلى مكة';

  @override
  String get qiblaFromNorth => 'من الشمال';

  @override
  String get qiblaNorthShort => 'ن';

  @override
  String get qiblaSouthShort => 'س';

  @override
  String get qiblaEastShort => 'ه';

  @override
  String get qiblaWestShort => 'دبليو';

  @override
  String get nearbyMosquesTitle => 'المساجد القريبة';

  @override
  String get nearbyMosquesTryAgain => 'حاول ثانية';

  @override
  String get nearbyMosquesOpenGoogle => 'افتح في خرائط جوجل';

  @override
  String get nearbyMosquesOpenApple => 'افتح في خرائط أبل';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'لم يتم العثور على أي مساجد في الداخل';

  @override
  String get nearbyMosquesSearchRadius => 'نصف قطر البحث: 5 كم';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'معاينة الخريطة غير متاحة الآن.';

  @override
  String get nearbyMosquesWaitingForLocation => 'في انتظار موقعك.';

  @override
  String get nearbyMosquesFetchingLocation => 'جارٍ تحديد موقعك…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'الموقع الحالي';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'ستظهر المساجد القريبة هنا بمجرد تحميل النتائج.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'لم يتم العثور على مساجد في نطاق 5 كم';

  @override
  String get nearbyMosquesLocationRequired =>
      'مطلوب الوصول إلى الموقع للعثور على المساجد القريبة.';

  @override
  String get nearbyMosquesPermissionOff =>
      'تم إيقاف إذن تحديد الموقع. قم بتفعيلها في الإعدادات لرؤية المساجد القريبة.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'لم نتمكن من قراءة موقعك الحالي الآن.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'فشل التحديث المباشر. عرض آخر النتائج المحفوظة. اسحب للتحديث.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'تم رفض الوصول إلى الموقع. قم بتفعيلها في الإعدادات لرؤية المساجد القريبة.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'تم إيقاف الموقع على هذا الجهاز. قم بتشغيله في الإعدادات، ثم حاول مرة أخرى.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'لا يزال إذن الموقع قيد المعالجة. الرجاء المحاولة مرة أخرى في لحظة.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'استغرق الطلب وقتا طويلا. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'لا يوجد اتصال بالإنترنت أو الخدمة غير قابلة للوصول. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get nearbyMosquesFormatError =>
      'لم نتمكن من قراءة قائمة المساجد في الوقت الحالي. يرجى المحاولة مرة أخرى في وقت لاحق.';

  @override
  String get nearbyMosquesPlatformError =>
      'لم نتمكن من إكمال تلك الخطوة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get nearbyMosquesEmptyHint =>
      'لا يوجد شيء مدرج على بعد 5 كم على OpenStreetMap لهذا المكان. حاول مرة أخرى لاحقًا أو انقل الخريطة.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count المساجد التي تم العثور عليها في نطاق 5 كم';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'حذف الذكر؟';

  @override
  String get tasbihDelete => 'يمسح';

  @override
  String get focusAndroidBlockingNotReady =>
      'حظر التطبيقات على أندرويد ما زال يجهّز. أبقِ خدمات إمكانية الوصول مفعّلة وانتظر قليلًا حتى يكتمل الاتصال.';

  @override
  String get focusNoAppsSelectedSnack =>
      'لم يُحدَّد أي تطبيق. اختر أولًا التطبيقات التي تريد حظرها.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'يلزم الوصول إلى «وقت الشاشة» لحظر التطبيقات على آيفون.';

  @override
  String get focusModeUpdateFailedSnack =>
      'حدث خطأ أثناء تحديث وضع التركيز. حاول مرة أخرى.';

  @override
  String get focusLoadingInstalledApps => 'جارٍ تحميل التطبيقات المثبتة...';

  @override
  String get focusNoInstalledAppsToShow => 'لا توجد تطبيقات مثبتة لعرضها.';

  @override
  String get homeAiSuggestion1 => 'ما هو رمضان؟';

  @override
  String get homeAiSuggestion2 => 'أوقات الصلاة';

  @override
  String get homeAiSuggestion3 => 'خطة لقراءة القرآن';

  @override
  String get homeAiDeveloperPrompt =>
      'أنت مساعد عالم إسلامي محترم. ساعد المستخدمين على تعلّم التقاليد الإسلامية والمناسبات والصلاة ودراسة القرآن والممارسات الروحية. كن دافئًا ومختصرًا وتعليميًا وحساسًا ثقافيًا. إن سُئل عن شيء خارج الإرشاد الإسلامي فأجب بفائدة دون ادّعاء يقين ديني.';

  @override
  String get homeAiErrorMissingApiKey => 'إعدادات واجهة البرمجة مفقودة.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'خطأ في واجهة البرمجة $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'لم يُرجَع أي رد من المساعد.';

  @override
  String get homeAiErrorEmptyContent => 'محتوى الرد فارغ.';

  @override
  String get settingsPrayerCalculationSection => 'حساب الصلاة';

  @override
  String get settingsCalculationMethodTitle => 'طريقة الحساب';

  @override
  String get settingsAsrCalculationTitle => 'حساب العصر';

  @override
  String get calculationMethodSectionMajorOrgs => 'المنظمات الإسلامية الكبرى';

  @override
  String get calculationMethodSectionMiddleEast => 'الشرق الأوسط';

  @override
  String get calculationMethodSectionAsiaPacific => 'آسيا والمحيط الهادئ';

  @override
  String get calculationMethodSectionSpecial => 'طرق خاصة';

  @override
  String get asrMethodStandard => 'القياسية';

  @override
  String get asrMethodStandardSubtitle => 'شافعي، مالكي، حنبلي';

  @override
  String get asrMethodHanafi => 'حنفي';

  @override
  String get homeLocationChangedTitle => 'تغير الموقع';

  @override
  String homeLocationChangedMessage(String city) {
    return 'يبدو أنك في $city. هل تريد تحديث موقع الصلاة لأوقات أدق؟';
  }

  @override
  String get homeLocationChangedNotNow => 'ليس الآن';

  @override
  String get homeLocationChangedUpdate => 'تحديث';

  @override
  String get homeYourNewLocation => 'موقعك الجديد';

  @override
  String get insightsPrayerStreak => 'سلسلة الصلاة';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count صلوات';
  }

  @override
  String get insightsPrayersInARow => 'صلوات متتالية';

  @override
  String get insightsDaysInARow => 'أيام متتالية';

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
  String get insightsAchievements => 'الإنجازات';

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
  String get achievementFirstPrayerStreak => 'أول سلسلة صلاة';

  @override
  String get achievementSevenPrayerStreak => 'سلسلة سبع صلوات';

  @override
  String get achievementThirtyPrayerStreak => 'سلسلة ثلاثين صلاة';

  @override
  String get achievementFajrWarrior => 'فارس الفجر';

  @override
  String get achievementQuranReader => 'قارئ القرآن';

  @override
  String get achievementDhikrMaster => 'سيد الذكر';

  @override
  String get achievementConsistencyChampion => 'بطل الاستمرارية';

  @override
  String get prayerCompletionAlhamdulillah => 'الحمد لله!';

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
  String get prayerCompletionContinue => 'متابعة';

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
