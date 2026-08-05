// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'Foi. Se concentrer. Cohérence';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Mode prière. Mode enfant. Mode veille.';

  @override
  String get welcomeDescription =>
      'Suivez vos prières, lisez le Coran, comptez Tasbih et créez des séquences significatives, le tout au même endroit.';

  @override
  String get skip => 'Sauter';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get continueButton => 'Continuer';

  @override
  String get continueForFree => 'Continuer avec le plan gratuit';

  @override
  String get getStarted => 'Débloquer Premium';

  @override
  String get language => 'Langue';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'D\'ACCORD';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get locationRequired => 'Emplacement requis';

  @override
  String get locationRequiredMessage =>
      'L\'accès à la localisation est nécessaire pour calculer les heures de prière précises et la direction de la Qibla. Vous devez l\'activer pour utiliser l\'application.';

  @override
  String get notificationsRequired => 'Notifications requises';

  @override
  String get notificationsRequiredMessage =>
      'Des notifications sont nécessaires pour recevoir des alertes et des rappels d\'heure de prière.';

  @override
  String get sectTitle => 'Choisissez votre secte';

  @override
  String get sectSubtitle => 'Cela nous aide à personnaliser votre expérience';

  @override
  String get sectSunni => 'Sunnite';

  @override
  String get sectShia => 'Chiite';

  @override
  String get sectPreferNotToSay => 'Je préfère ne pas dire';

  @override
  String get nameTitle => 'Quel est ton nom?';

  @override
  String get nameSubtitle => 'Personnalisons votre message d\'accueil';

  @override
  String get namePlaceholder => 'Votre nom';

  @override
  String get locationTitle => 'Trouvez votre Qibla';

  @override
  String get locationSubtitle =>
      'Activez la localisation pour une Qibla précise, les horaires de prière et les mosquées proches.';

  @override
  String get locationButton => 'Autoriser l\'accès à la localisation';

  @override
  String get locationManualEntry => 'Ou saisissez votre ville';

  @override
  String get locationPrivacyNote => 'Reste sur votre appareil';

  @override
  String get locationFeaturePrayerTimesTitle => 'Horaires de prière';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Mosquées';

  @override
  String get notificationsTitle => 'Ne manquez jamais une prière';

  @override
  String get notificationsSubtitle =>
      'Alertes Adhan, rappels de focus et dhikr quotidien — au bon moment.';

  @override
  String get notificationsButton => 'Activer les notifications';

  @override
  String get notificationsEnabled => 'Les notifications sont activées';

  @override
  String get notificationsPreviewDate => 'Vendredi 10 juillet';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'maintenant';

  @override
  String get notificationsPreviewMinutesAgo => '2 min';

  @override
  String get notificationsPreviewHourAgo => '1 h';

  @override
  String get notificationsPreviewAdhanTitle => 'Adhan Maghrib';

  @override
  String get notificationsPreviewAdhanBody =>
      'C\'est l\'heure de prier. Les apps sont en pause.';

  @override
  String get notificationsPreviewDhikrTitle => 'Dhikr quotidien';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — prenez une minute.';

  @override
  String get notificationsPreviewStreakTitle => 'Série';

  @override
  String get notificationsPreviewStreakBody =>
      '7 jours de prières complètes. Continuez !';

  @override
  String get screenTimeTitle => 'Activer Temps d\'écran';

  @override
  String get screenTimeSubtitle =>
      'C\'est ce qui permet à Deen Focus de mettre en pause les apps distrayantes pendant la Salah, le sommeil et le mode enfant.';

  @override
  String get screenTimeButton => 'Autoriser l\'accès au Temps d\'écran';

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
  String get focusModesTitle => 'Tout dans une seule app';

  @override
  String get focusModesSubtitle =>
      'Découvrez tout ce que Deen Focus offre. Appuyez sur un mode de focus pour voir comment il fonctionne.';

  @override
  String get focusModesSectionLabel =>
      'MODES FOCUS · APPUYEZ POUR EN SAVOIR PLUS';

  @override
  String get focusPrayerTrackingSectionLabel => 'PRIÈRE ET SUIVI';

  @override
  String get focusLearningHubSectionLabel => 'CENTRE D\'APPRENTISSAGE';

  @override
  String get focusMoreSectionLabel => 'PLUS';

  @override
  String get focusPrayerModeTitle => 'Mode prière';

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
  String get focusSleepModeTitle => 'Mode veille';

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
  String get focusChildModeTitle => 'Mode enfant';

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
  String get focusModeGotIt => 'Compris';

  @override
  String get focusFeaturePrayerTimesTitle => 'Horaires de prière précis';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan et rappels';

  @override
  String get focusFeatureStreaksTitle => 'Séries';

  @override
  String get focusFeatureStreaksSubtitle => 'Restez régulier';

  @override
  String get focusFeatureChecklistTitle => 'Liste quotidienne';

  @override
  String get focusFeatureChecklistSubtitle => 'Créez de bonnes habitudes';

  @override
  String get focusFeatureQiblaTitle => 'Qibla et mosquée';

  @override
  String get focusFeatureQiblaSubtitle => 'Direction et mosquées';

  @override
  String get focusFeatureQuranTitle => 'Coran';

  @override
  String get focusFeatureQuranSubtitle => 'Traductions, juz\' et pages';

  @override
  String get focusFeatureHadithTitle => 'Hadith';

  @override
  String get focusFeatureHadithSubtitle => 'Collections authentiques';

  @override
  String get focusFeatureDuasTitle => 'Douas';

  @override
  String get focusFeatureDuasSubtitle => 'Invocations quotidiennes';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Compteur de dhikr numérique';

  @override
  String get focusFeatureAiTitle => 'Compagnon IA';

  @override
  String get focusFeatureAiSubtitle => 'Posez des questions sur votre Deen';

  @override
  String get focusFeatureInsightsTitle => 'Analyses';

  @override
  String get focusFeatureInsightsSubtitle =>
      'Stats hebdomadaires et mensuelles';

  @override
  String get investTitle => 'Investissez dans votre Deen';

  @override
  String get investSubtitle =>
      'Vous n\'hésitez pas à dépenser en café ou en collations...';

  @override
  String get investComparisonTitle =>
      'Passer Premium ou continuer gratuitement';

  @override
  String get investDailyCoffee => 'Café quotidien';

  @override
  String get investDailyCoffeePrice => '5\$/jour';

  @override
  String get investFastFood => 'Restauration rapide';

  @override
  String get investFastFoodPrice => '10\$/repas';

  @override
  String get investYourDeen => 'Votre Deen';

  @override
  String get investYourDeenPrice => '4,99 \$/mois';

  @override
  String get investComparisonQuote =>
      'Vous dépensez 10 \$ pour de petites choses sans réfléchir : pourquoi ne pas investir dans votre Deen ?';

  @override
  String get bestValueTag => 'MEILLEURE VALEUR';

  @override
  String get mostPopularChoice => 'Choix le plus populaire';

  @override
  String get monthlyPriceValue => '4,99 \$';

  @override
  String get monthlyPriceSuffix => '/mois';

  @override
  String get monthlyPlanSubtitle =>
      'Facturé mensuellement • Annulez à tout moment';

  @override
  String get yearlyPriceValue => '24,99 \$';

  @override
  String get yearlyPriceSuffix => '/année';

  @override
  String get yearlyPlanSubtitle => 'Économisez 50 % • Facturé annuellement';

  @override
  String get lifetimePriceValue => '79,99 \$';

  @override
  String get lifetimePriceSuffix => 'durée de vie';

  @override
  String get lifetimePlanSubtitle => 'Achat unique • Accès permanent';

  @override
  String get everythingYouGet => 'Tout ce que vous obtenez';

  @override
  String get featureFocusModeAllModes =>
      'Mode de mise au point illimité avec les 3 modes';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'Analyses et séries de prières avancées';

  @override
  String get featureAiAssistant => 'Assistant islamique IA';

  @override
  String get featurePrioritySupportEarlyAccess =>
      'Assistance prioritaire et accès anticipé';

  @override
  String get socialProofPrefix => 'Rejoindre';

  @override
  String get socialProofHighlight => '10 000+';

  @override
  String get socialProofSuffix =>
      'Les musulmans grandissent déjà avec Deen Focus';

  @override
  String get mostPopular => 'Les plus populaires';

  @override
  String get monthlyLabel => 'Mensuel';

  @override
  String get monthlyPrice =>
      '4,99 \$/mois · facturé mensuellement · annuler à tout moment';

  @override
  String get yearlyLabel => 'Annuel';

  @override
  String get yearlyPrice =>
      '24,99 \$/an · économisez 50 % · facturé annuellement';

  @override
  String get lifetimeLabel => 'Durée de vie';

  @override
  String get lifetimePrice => '79,99 \$ à vie · achat unique · accès permanent';

  @override
  String get featurePrayerAnalytics => 'Analyse avancée des prières';

  @override
  String get featureFocusMode => 'Mode de mise au point illimité';

  @override
  String get featureMasjidMode => 'Mode automatique de la mosquée';

  @override
  String get featureNoAds => 'Supprime toutes les annonces';

  @override
  String get featureSupport => 'Assistance prioritaire';

  @override
  String get homeTitle => 'Maison Deenly';

  @override
  String get homeSalam => 'Assalamu Alaikoum';

  @override
  String get homeDailyVerseFallback =>
      'En effet, les difficultés viennent avec la facilité.';

  @override
  String get homeAppsLocked => 'Applications verrouillées';

  @override
  String get homeAppsUnlocked => 'Applications débloquées';

  @override
  String get homeTapToUnlock =>
      'Appuyez pour déverrouiller temporairement les applications';

  @override
  String get homeTapToRelock =>
      'Appuyez pour reverrouiller les applications bloquées maintenant';

  @override
  String get homeRelock => 'Reverrouiller';

  @override
  String get homeUnlock => 'Ouvrir';

  @override
  String get homePrayerModeActive => 'Mode prière actif';

  @override
  String get homeActivatePrayerMode => 'Activer le mode prière';

  @override
  String get homeAppsBlockedSubtitle =>
      'Les applications sont bloquées. Appuyez pour désactiver.';

  @override
  String get homeBlockDistractingApps =>
      'Bloquez les applications distrayantes pendant Salah.';

  @override
  String get homeQiblaDirection => 'Direction de la Qibla';

  @override
  String get homeLocationMissingForQibla =>
      'Activer la localisation pour calculer la direction de la Qibla.';

  @override
  String get homeQiblaSubtitleGuiding => 'Vous guider vers la Qibla';

  @override
  String get homeToMakkah => 'à La Mecque';

  @override
  String get homeFindMasjid => 'Trouver une mosquée près de chez moi';

  @override
  String get quickActionsMasjidFinder => 'Trouver une mosquée';

  @override
  String get homeSearchNearbyMosques => 'Recherchez les mosquées à proximité.';

  @override
  String get homePrayerStreak => 'Séries de prières';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Aperçus';

  @override
  String get homeOpenStreakDetails => 'Détails de la séquence ouverte.';

  @override
  String get homeTodaysPrayers => 'Les prières d\'aujourd\'hui';

  @override
  String get homePrayerTimesUnavailable =>
      'Les horaires de prière ne sont pas disponibles pour le moment.';

  @override
  String get homeNextPrayerIn => 'Prochaine prière à';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Lever du soleil';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'asr';

  @override
  String get homePrayerMaghrib => 'Maghreb';

  @override
  String get homePrayerIsha => 'Icha';

  @override
  String get homeWeek => 'Semaine';

  @override
  String get homeMonth => 'Mois';

  @override
  String get homeThisWeek => 'Faits saillants de Deen cette semaine';

  @override
  String get homeJummahMubarak => 'Joumma Moubarak';

  @override
  String get homeJummahReminder => 'N\'oubliez pas la sourate Al-Kahf.';

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
      '« Allah veut pour vous la facilité, Il ne veut pas pour vous la difficulté » — Coran 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'Pendant cette période, votre série est protégée. Les jours du cycle sont en rose, et le Mode cycle s\'éteint automatiquement à la fin du cycle.';

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
  String get cycleModeSettingsTitle => 'Mode cycle';

  @override
  String get cycleModeStartDateLabel => 'Date de début';

  @override
  String get cycleModeLengthLabel => 'Durée du cycle';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Mettre les séries en pause';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'Exclure des statistiques';

  @override
  String get cycleModeSaveButton => 'Enregistrer';

  @override
  String get cycleModeEditButton => 'Modifier';

  @override
  String get cycleModeChangeStartDateTitle => 'Modifier la date de début ?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Modifier la date de début recalculera la fenêtre active du Mode cycle. Les jours hors de la nouvelle plage peuvent ne plus être traités comme des jours de cycle.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Modifier la date de début';

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
  String get homeFocusModeTitle => 'Mode Focus';

  @override
  String get homeFocusModeSubtitle =>
      'Bloquez les apps distrayantes pendant la Salah';

  @override
  String get cycleModeTitle => 'Mode cycle';

  @override
  String get cycleModeSubtitle =>
      'Pour les menstruations — pausez les prières, gardez votre série';

  @override
  String get dailyChecklistTitle => 'Daily Checklist';

  @override
  String get dailyChecklistSectionPrayer => 'Prière';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Coran et Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Bonnes actions';

  @override
  String get dailyChecklistSectionDistraction => 'Contrôle des distractions';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar du soir';

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
  String get focusScoreTitle => 'Score de focus d\'aujourd\'hui';

  @override
  String get focusScorePrayer => 'Prière';

  @override
  String get focusScoreQuran => 'Coran';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Contrôle des distractions';

  @override
  String get insightsBack => 'Retour';

  @override
  String get insightsTitle => 'Mes aperçus';

  @override
  String get insightsSubtitle => 'Suivez votre progression dans le Deen';

  @override
  String get insightsPrayerRate => 'Taux de prière';

  @override
  String get insightsDayStreak => 'Série de jours';

  @override
  String get insightsBestStreak => 'Meilleure série';

  @override
  String get insightsWeekly => 'Hebdomadaire';

  @override
  String get insightsMonthly => 'Mensuel';

  @override
  String get insightsPrayersCompleted => 'Prières accomplies';

  @override
  String get insightsRestoreStreak =>
      'Restaurer ma série — dernières 24 heures';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Prière $prayerPercent% · Coran $quranPercent% · Dhikr $dhikrPercent% · Distraction control $distractionPercent%';
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
      'Demandez n\'importe quoi sur les heures de prière, le Coran et les conseils islamiques.';

  @override
  String get homeDay => 'Jour';

  @override
  String get homeDays => 'Jours';

  @override
  String get homeNoEventsFoundForDay => 'Aucun événement trouvé pour ce jour.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — marquer comme';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Priée à l\'heure';

  @override
  String get homeMarkPrayerQada => 'Qada (rattrapée)';

  @override
  String get homeMarkPrayerMissed => 'Manquée';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return 'Paramètres de $prayerName';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Heure de prière';

  @override
  String get homePrayerSettingsNotification => 'Notification';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Vertus, règles et plus';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Ces paramètres concernent uniquement $prayerName. Vous pouvez définir des préférences différentes pour chaque prière.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'Modifier l\'heure de $prayerName';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Heure actuelle';

  @override
  String get homeEditPrayerTimeSelectNew => 'Choisir une nouvelle heure';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Cette heure personnalisée s\'applique uniquement à $prayerName. Ajustez-la si votre mosquée locale ou le calcul diffère.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Enregistrer l\'heure';

  @override
  String get homeEditPrayerTimeReset => 'Réinitialiser à l\'heure calculée';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Notification pour $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Son de notification';

  @override
  String get homeNotificationSoundFullAdhan => 'Adhan complet';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Lire l\'Adhan en entier';

  @override
  String get homeNotificationSoundBeep => 'Bip';

  @override
  String get homeNotificationSoundBeepSubtitle =>
      'Un ton de notification court';

  @override
  String get homeNotificationSoundMute => 'Muet';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Aucun son';

  @override
  String get homeNotificationEnableLabel => 'Activer la notification';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Être notifié à l\'heure de $prayerName';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'À propos de $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Heure';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakaats';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Vertus';

  @override
  String get homeAboutPrayerReferenceLabel => 'Référence';

  @override
  String get homeAboutFajrTiming =>
      'Commence à l\'aube véritable (Fajr Sadiq) et se termine au lever du soleil.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Celui qui prie le Fajr est sous la protection d\'Allah.';

  @override
  String get homeAboutFajrReference =>
      '« Les deux rakʿāt du Fajr valent mieux que le monde et tout ce qu\'il contient. » (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Commence dès que le soleil dépasse son zénith et dure jusqu\'au début de l\'Asr.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Fait partie des 12 rakʿāt volontaires quotidiennes pour lesquelles Allah bâtit une maison au Paradis.';

  @override
  String get homeAboutDhuhrReference =>
      '« Quiconque prie douze rakʿāt pendant un jour et une nuit aura une maison construite pour lui au Paradis. » (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Commence lorsque l\'ombre d\'un objet égale sa longueur et dure jusqu\'au coucher du soleil.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Préserver cette prière est particulièrement récompensé et mis en garde.';

  @override
  String get homeAboutAsrReference =>
      '« Quiconque rate la prière de l\'Asr, c\'est comme s\'il avait perdu sa famille et ses biens. » (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Commence juste après le coucher du soleil et dure jusqu\'à la disparition du crépuscule rouge.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Un moment où les invocations sont particulièrement encouragées.';

  @override
  String get homeAboutMaghribReference =>
      '« Il y a deux joies pour celui qui jeûne… lorsqu\'il rompt son jeûne. » (Sahih al-Bukhari, sur l\'iftar du Maghrib)';

  @override
  String get homeAboutIshaTiming =>
      'Commence une fois le crépuscule entièrement disparu et dure jusqu\'à minuit (ou jusqu\'au Fajr, selon certains avis).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Prier l\'Isha en communauté équivaut à passer la moitié de la nuit en prière.';

  @override
  String get homeAboutIshaReference =>
      '« Quiconque prie l\'Isha en communauté, c\'est comme s\'il avait prié la moitié de la nuit. » (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Retour à l\'intégration';

  @override
  String get settings => 'Paramètres';

  @override
  String get appLanguage => 'Langue de l\'application';

  @override
  String get tabHome => 'Maison';

  @override
  String get tabFocus => 'Se concentrer';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Coran';

  @override
  String get tabLearn => 'Apprendre';

  @override
  String get quranLoadFailed => 'Échec du chargement des données du Coran';

  @override
  String get quranTabSubtitle => 'Lisez et explorez le Saint Coran';

  @override
  String get quranSearchHint => 'Rechercher sourate...';

  @override
  String get quranNoSurahsFound => 'Aucune sourate trouvée';

  @override
  String get quranVersesLabel => 'versets';

  @override
  String get quranTextOptions => 'Options de texte';

  @override
  String get quranEnglishAndArabic => 'Anglais et arabe';

  @override
  String get quranArabicOnly => 'Arabe uniquement';

  @override
  String get quranIncreaseFont => 'Augmenter la police';

  @override
  String get quranDecreaseFont => 'Diminuer la police';

  @override
  String get quranPause => 'Pause';

  @override
  String get quranPlaySurah => 'Jouer la sourate';

  @override
  String get quranAudioNoInternet =>
      'Pas de connexion internet. L\'audio nécessite internet.';

  @override
  String get quranAudioTimeout =>
      'Le chargement audio a expiré. Vérifiez votre connexion.';

  @override
  String get quranSurahLabel => 'Sourate';

  @override
  String get save => 'Sauvegarder';

  @override
  String get tasbihBack => 'Dos';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Sélectionnez un dhikr ou créez le vôtre';

  @override
  String get tasbihAddCustomTitle => 'Ajouter le dhikr';

  @override
  String get tasbihEditCustomTitle => 'Modifier le dhikr personnalisé';

  @override
  String get tasbihArabicOrDhikrHint => 'Texte arabe ou n\'importe quel dhikr';

  @override
  String get tasbihTransliterationOptionalHint =>
      'Translittération (facultatif)';

  @override
  String get tasbihMeaningOptionalHint => 'Signification (facultatif)';

  @override
  String get tasbihNoTransliteration => 'Pas de translittération';

  @override
  String get tasbihTotalCount => 'Nombre total';

  @override
  String get tasbihGrandTotalLabel => 'Total du tasbih';

  @override
  String get tasbihTapMe => 'Appuyez-moi';

  @override
  String get tasbihReset => 'Réinitialiser';

  @override
  String get tasbihRestart => 'Redémarrage';

  @override
  String get tasbihCurrentCount => 'Nombre actuel';

  @override
  String get tasbihResetTotal => 'Effacer l\'historique';

  @override
  String get focusModeActivated => 'Mode de mise au point activé';

  @override
  String get focusSetUpHomeCardTitle => 'Configurer le mode Concentration';

  @override
  String get focusTabSubtitle => 'Restez concentré quand cela compte le plus';

  @override
  String get focusChooseAppsEnableMode =>
      'Choisissez des apps et activez le mode Concentration';

  @override
  String get focusNotifAppsLockedTitle => 'Apps verrouillées';

  @override
  String get focusNotifAppsUnlockedTitle => 'Apps déverrouillées';

  @override
  String get focusNotifNightModeTitle => 'Mode nuit';

  @override
  String get focusNotifGoodMorningTitle => 'Bonjour !';

  @override
  String get focusNotifAppsNowAvailableBody =>
      'Les applications sont maintenant disponibles.';

  @override
  String get focusNotifSalahLockedBody =>
      'Les applications sont verrouillées pendant la Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah terminée';

  @override
  String get focusNotifSalahCompleteBody =>
      'Les apps sont déverrouillées. Que votre prière soit acceptée.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return 'Heure de $prayerName';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Prenez un moment pour la prière de $prayerName.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Le mode nuit est activé. Laissez votre esprit et votre corps se reposer.';

  @override
  String get focusNotifGenericLockedBody =>
      'Les applications sélectionnées sont verrouillées.';

  @override
  String get focusNotifMorningUnlockBody =>
      'Les applications ne sont pas disponibles.';

  @override
  String get widgetDailyVerseTitle => 'Verset du jour';

  @override
  String get widgetOpenAppTimelineHint =>
      'Ouvrez Deen Focus pour préparer le verset du jour et les données du widget de prière.';

  @override
  String get widgetSetLocationForPrayers =>
      'Définissez votre position dans Deen Focus pour charger les prières et le verset du jour.';

  @override
  String get focusChildModeActive => 'Mode enfant actif';

  @override
  String get focusSalahAndNightModeActive => 'Salah et mode nuit actifs';

  @override
  String get focusSalahModeActive => 'Mode Salah actif';

  @override
  String get focusNightModeActive => 'Mode nuit actif';

  @override
  String get focusAppsToBlockTitle => 'Applications à bloquer';

  @override
  String get focusAppliesAllModes =>
      'S\'applique à tous les modes de mise au point';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'L\'accès à Screen Time est requis pour afficher et sélectionner des applications.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Veuillez accepter la divulgation d\'accessibilité pour continuer.';

  @override
  String get focusSelectAppsToBlock =>
      'Sélectionnez les applications à bloquer';

  @override
  String get focusLoading => 'Chargement...';

  @override
  String get focusOpen => 'Ouvrir';

  @override
  String get focusHide => 'Cacher';

  @override
  String get focusLoad => 'Charger';

  @override
  String get focusShow => 'Montrer';

  @override
  String get focusSalahFocusModeTitle => 'Mode de mise au point Salah';

  @override
  String get focusBlockAppsDuringPrayer =>
      'Bloquer les applications pendant la prière';

  @override
  String get focusNightDisciplineTitle => 'Discipline de nuit';

  @override
  String get focusSleepLabel => 'Dormir';

  @override
  String get focusWakeLabel => 'Se réveiller';

  @override
  String get focusBlockAppsImmediately =>
      'Bloquer les applications immédiatement';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Activer le blocage des applications Android';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Pour bloquer d\'autres applications sur Android, Deenly doit activer son autorisation d\'accessibilité. Nous ouvrirons l’écran de paramètres approprié pour vous.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Divulgation des autorisations d\'accessibilité';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly utilise Android Accessibility pour appliquer le blocage des applications en mode Focus.\n\nPourquoi nous en avons besoin : pour détecter lorsque vous ouvrez une application que vous avez sélectionnée pour le blocage.\n\nComment nous l\'utilisons : uniquement pour identifier l\'application de premier plan et afficher l\'écran de bloc Focus pour les applications sélectionnées. Nous ne l\'utilisons pas pour lire du texte tapé ou du contenu personnel.';

  @override
  String get focusNotNow => 'Pas maintenant';

  @override
  String get focusIUnderstand => 'Je comprends';

  @override
  String get focusDone => 'Fait';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Développez de meilleures habitudes nocturnes';

  @override
  String get focusPrayerBlockingDescription =>
      'Les applications seront bloquées pendant la prière et se déverrouilleront automatiquement après 15 minutes, ou vous pourrez les déverrouiller à tout moment depuis l\'écran d\'accueil.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Les applications seront bloquées pendant la prière, ou vous pourrez les déverrouiller à tout moment depuis l\'écran d\'accueil.';

  @override
  String get focusNightBlockingDescription =>
      'Les applications seront bloquées pendant votre cycle de sommeil et se déverrouilleront automatiquement, ou vous pourrez les déverrouiller à tout moment depuis l\'écran d\'accueil';

  @override
  String get focusChildBlockingDescription =>
      'Les applications sont bloquées instantanément en mode enfant. Déverrouillez-les à l\'aide de la bascule ou depuis l\'écran d\'accueil';

  @override
  String get settingsEditUsername => 'Modifier le nom d\'utilisateur';

  @override
  String get settingsEnterYourName => 'Entrez votre nom';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Débloquez toutes les fonctionnalités';

  @override
  String get settingsManageSubscriptionTitle => 'Gérer l’abonnement';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Voir le forfait ou mettre à jour la facturation';

  @override
  String get settingsUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get settingsLocationLabel => 'Emplacement';

  @override
  String get settingsDarkModeLabel => 'Mode sombre';

  @override
  String get settingsAboutTitle => 'À propos de Deen Focus';

  @override
  String get settingsContactUsTitle => 'Nous contacter';

  @override
  String get settingsSavingLocation => 'Économie...';

  @override
  String get settingsSaveLocation => 'Enregistrer l\'emplacement';

  @override
  String get settingsAboutTagline => 'Se concentrer. Discipline. Cohérence.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus vous aide à rester connecté à votre foi tout en gérant les distractions quotidiennes dans un monde moderne.';

  @override
  String get settingsAboutFeature1 => 'Heures de prière avec rappels';

  @override
  String get settingsAboutFeature2 => 'Direction de la Qibla à tout moment';

  @override
  String get settingsAboutFeature3 => 'Coran et Tasbih pour le dhikr quotidien';

  @override
  String get settingsAboutFeature4 => 'Mosquées à proximité';

  @override
  String get settingsAboutFeature5 =>
      'Modes de concentration intelligents pour Salah, le sommeil et le temps en famille';

  @override
  String get settingsAboutFocusDescription =>
      'Les modes de concentration intelligents vous aident à bloquer les distractions pendant Salah, le sommeil et les moments importants, afin que vous puissiez rester présent et discipliné.';

  @override
  String get settingsAboutFooter =>
      'Restez constant. Restez attentif.\nRestez connecté à votre Deen.';

  @override
  String get settingsEnableSystemNotifications =>
      'Activez les notifications système pour activer cela.';

  @override
  String get appDemoTitle => 'Démo de l\'application';

  @override
  String get appDemoLoadFailed =>
      'Impossible de charger la vidéo de démonstration.';

  @override
  String get appDemoRestartHint =>
      'La vidéo nécessite un redémarrage complet de l\'application (un redémarrage à chaud peut interrompre la lecture).';

  @override
  String get appDemoPreviewLoadFailed => 'Impossible de charger la démo.';

  @override
  String get appDemoTryAgain => 'Essayer à nouveau';

  @override
  String get appDemoWatchLabel => 'Regarder la démo';

  @override
  String get homeAiChatTitle => 'IA Deen Focus';

  @override
  String get homeAiAskQuestionHint => 'Posez une question...';

  @override
  String get homeAiSend => 'Envoyer';

  @override
  String get homeAiErrorPrefix =>
      'Désolé, j\'ai rencontré un problème lors de la connexion à Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Demandez n\'importe quoi sur l\'Islam';

  @override
  String get homeAiEmptySubtitle =>
      'Horaires de prière, Coran, Hadith, événements islamiques et conseils spirituels';

  @override
  String get onboardingTypeCityName => 'Tapez le nom de votre ville..';

  @override
  String get onboardingNoLocationsFound => 'Aucun emplacement trouvé';

  @override
  String get onboardingTryAnotherCityName => 'Essayez un autre nom de ville.';

  @override
  String get qiblaCompassUnavailable =>
      'Boussole indisponible sur cet appareil';

  @override
  String get qiblaFacing => '✓ Face à la Qibla';

  @override
  String get qiblaTurnToFind => 'Tournez-vous pour trouver la Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Distance à La Mecque';

  @override
  String get qiblaFromNorth => 'du Nord';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Mosquées à proximité';

  @override
  String get nearbyMosquesTryAgain => 'Essayer à nouveau';

  @override
  String get nearbyMosquesOpenGoogle => 'Ouvrir dans Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Ouvrir dans Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'Aucune mosquée trouvée à l\'intérieur';

  @override
  String get nearbyMosquesSearchRadius => 'Rayon de recherche : 5 km';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'L\'aperçu de la carte n\'est pas disponible pour le moment.';

  @override
  String get nearbyMosquesWaitingForLocation =>
      'En attente de votre emplacement.';

  @override
  String get nearbyMosquesFetchingLocation => 'Récupération de votre position…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Position actuelle';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Les mosquées à proximité apparaîtront ici une fois les résultats chargés.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'Aucune mosquée trouvée à moins de 5 km';

  @override
  String get nearbyMosquesLocationRequired =>
      'L\'accès à la localisation est nécessaire pour trouver les mosquées à proximité.';

  @override
  String get nearbyMosquesPermissionOff =>
      'L\'autorisation de localisation est désactivée. Activez-le dans les paramètres pour voir les mosquées à proximité.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'Nous n\'avons pas pu lire votre position actuelle pour le moment.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'La mise à jour en direct a échoué. Affichage des derniers résultats enregistrés. Tirez pour rafraîchir.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'L\'accès à la localisation a été refusé. Activez-le dans Paramètres pour voir les mosquées à proximité.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'La localisation est désactivée sur cet appareil. Activez-le dans Paramètres, puis réessayez.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'L\'autorisation de localisation est toujours en cours de traitement. Veuillez réessayer dans un instant.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'La demande a pris trop de temps. Vérifiez votre connexion Internet et réessayez.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Aucune connexion Internet ou le service est inaccessible. Vérifiez votre connexion et réessayez.';

  @override
  String get nearbyMosquesFormatError =>
      'Nous ne pouvons pas lire la liste des mosquées pour le moment. Veuillez réessayer plus tard.';

  @override
  String get nearbyMosquesPlatformError =>
      'Nous n\'avons pas pu terminer cette étape. Vérifiez votre connexion et réessayez.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';

  @override
  String get nearbyMosquesEmptyHint =>
      'Rien n\'est répertorié à moins de 5 km sur OpenStreetMap pour ce spot. Réessayez plus tard ou déplacez la carte.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count mosquées trouvées dans un rayon de 5 km';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Supprimer le dhikr ?';

  @override
  String get tasbihDelete => 'Supprimer';

  @override
  String get focusAndroidBlockingNotReady =>
      'Le blocage d’apps Android n’est pas encore prêt. Gardez l’accessibilité activée et attendez un instant la connexion.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Aucune app sélectionnée. Choisissez d’abord les apps à bloquer.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'L’accès au Temps d’écran est requis pour bloquer des apps sur iPhone.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Une erreur s’est produite lors de la mise à jour du mode Concentration. Réessayez.';

  @override
  String get focusLoadingInstalledApps => 'Chargement des apps installées...';

  @override
  String get focusNoInstalledAppsToShow => 'Aucune app installée à afficher.';

  @override
  String get homeAiSuggestion1 => 'Qu’est-ce que le Ramadan ?';

  @override
  String get homeAiSuggestion2 => 'Horaires de prière';

  @override
  String get homeAiSuggestion3 => 'Plan de lecture du Coran';

  @override
  String get homeAiDeveloperPrompt =>
      'Vous êtes un assistant savant et respectueux en islam. Aidez les utilisateurs à découvrir les traditions islamiques, les fêtes, la prière, l’étude du Coran et les pratiques spirituelles. Soyez chaleureux, concis, pédagogique et sensible culturellement. Hors sujet islamique, répondez utilement sans feindre une certitude religieuse.';

  @override
  String get homeAiErrorMissingApiKey => 'Configuration de l’API manquante.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'Erreur API $statusCode : $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Aucune réponse de l’assistant.';

  @override
  String get homeAiErrorEmptyContent => 'Contenu de réponse vide.';

  @override
  String get settingsPrayerCalculationSection => 'Calcul de Prière';

  @override
  String get settingsCalculationMethodTitle => 'Méthode de Calcul';

  @override
  String get settingsAsrCalculationTitle => 'Calcul de l\'Asr';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Grandes Organisations Islamiques';

  @override
  String get calculationMethodSectionMiddleEast => 'Moyen-Orient';

  @override
  String get calculationMethodSectionAsiaPacific => 'Asie-Pacifique';

  @override
  String get calculationMethodSectionSpecial => 'Méthodes Spéciales';

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
}
