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
  String get continueForFree =>
      'Peut-être plus tard — explorer l\'app d\'abord';

  @override
  String get getStarted => 'Commencer mon essai gratuit de 7 jours';

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
      'Activez la localisation pour une Qibla, des horaires de prière et des mosquées proches précis.';

  @override
  String get locationButton => 'Autoriser l\'accès à la localisation';

  @override
  String get locationManualEntry => 'Saisissez votre ville manuellement';

  @override
  String get locationOrDivider => 'ou';

  @override
  String get locationPrivacyNote => 'Reste sur votre appareil';

  @override
  String get locationFeaturePrayerTimesTitle => 'Horaires de prière';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Mosquées';

  @override
  String get notificationsTitle => 'Ne manquez aucune prière';

  @override
  String get notificationsSubtitle =>
      'Alertes adhan, rappels focus et dhikr quotidien — au bon moment.';

  @override
  String get notificationsButton => 'Activer les notifications';

  @override
  String get notificationsMaybeLater => 'Peut-être plus tard';

  @override
  String get notificationsEnabled => 'Les notifications sont activées';

  @override
  String get notificationsPreviewDate => 'Vendredi 10 juillet';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'maintenant';

  @override
  String get notificationsPreviewMinutesAgo => 'il y a 2 min';

  @override
  String get notificationsPreviewHourAgo => 'il y a 1 h';

  @override
  String get notificationsPreviewAdhanTitle => 'Adhan du Maghrib';

  @override
  String get notificationsPreviewAdhanBody => 'Il est temps de prier.';

  @override
  String get notificationsPreviewDhikrTitle => 'Dhikr quotidien';

  @override
  String get notificationsPreviewDhikrBody => 'SubhanAllah — prenez un moment.';

  @override
  String get notificationsPreviewStreakTitle => 'Série';

  @override
  String get notificationsPreviewStreakBody => '7 jours de prières complètes.';

  @override
  String get screenTimeTitle => 'Activer Temps d\'écran';

  @override
  String get screenTimeSubtitle =>
      'C\'est ce qui permet à Deen Focus de mettre en pause les apps distrayantes pendant la Salah, le sommeil et le mode enfant.';

  @override
  String get screenTimeButton => 'Autoriser l\'accès au Temps d\'écran';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus ne lit jamais vos données — il met seulement en pause les apps que vous choisissez.';

  @override
  String get onboardingSelectAppsTitlePrefix => 'Sélectionnez';

  @override
  String get onboardingSelectAppsTitleAccent => 'les apps à verrouiller';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Sélectionnez les applications à verrouiller au moment de la prière.';

  @override
  String get onboardingSelectAppsButton => 'Sélectionner des apps';

  @override
  String get onboardingSelectAppsSkipForNow => 'Passer pour l’instant';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'Vous avez le contrôle';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'Nous ne lisons jamais vos données. Nous verrouillons uniquement les apps que vous choisissez.';

  @override
  String get onboardingSelectAppsMockAllApps => 'Toutes les apps et catégories';

  @override
  String get onboardingSelectAppsMockPhotos => 'Photos';

  @override
  String get onboardingSelectAppsMockNotes => 'Notes';

  @override
  String get onboardingSelectAppsMockMusic => 'Musique';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => 'Podcasts';

  @override
  String screenTimeStepOf(int current, int total) {
    return 'ÉTAPE $current SUR $total';
  }

  @override
  String get screenTimeStep1Title => 'Ouvrir l\'invite Temps d\'écran';

  @override
  String get screenTimeStep1Body =>
      'Appuyez sur « Autoriser l\'accès au Temps d\'écran » — votre appareil affichera sa propre demande d\'autorisation.';

  @override
  String get screenTimeStep2Title => 'Appuyez sur Continuer, puis Autoriser';

  @override
  String get screenTimeStep2Body =>
      'Approuvez la demande pour que Deen Focus puisse mettre en pause les apps au bon moment.';

  @override
  String get screenTimeStep3Title => 'Choisir les apps à verrouiller';

  @override
  String get screenTimeStep3Body =>
      'Sélectionnez les apps qui vous distraient le plus — réseaux sociaux, jeux, vidéo, etc.';

  @override
  String get screenTimeStep4Title => 'Vous êtes protégé';

  @override
  String get screenTimeStep4Body =>
      'Les apps se verrouillent automatiquement pendant la Salah, le sommeil et le mode enfant.';

  @override
  String get screenTimePromptTitle => 'Temps d\'écran';

  @override
  String screenTimePromptMessage(String appName) {
    return '« $appName » souhaite accéder à Temps d\'écran';
  }

  @override
  String get screenTimeDontAllow => 'Ne pas autoriser';

  @override
  String get screenTimePromptContinue => 'Continuer';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Jeux';

  @override
  String get screenTimeAndroidStep1Title => 'Ouvrir l\'accès d\'utilisation';

  @override
  String get screenTimeAndroidStep1Body =>
      'Appuyez sur « Autoriser l\'accès au Temps d\'écran » — votre appareil ouvrira l\'accès d\'utilisation pour Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Activer l\'accessibilité';

  @override
  String get screenTimeAndroidStep2Body =>
      'Activez le service Deen Focus pour mettre en pause les apps pendant la Salah, le sommeil et le mode enfant.';

  @override
  String get screenTimeAndroidStep3Title => 'Choisir les apps à verrouiller';

  @override
  String get screenTimeAndroidStep3Body =>
      'Sélectionnez les apps qui vous distraient le plus — réseaux sociaux, jeux, vidéo, etc.';

  @override
  String get screenTimeAndroidStep4Title => 'Vous êtes protégé';

  @override
  String get screenTimeAndroidStep4Body =>
      'Les apps se verrouillent automatiquement pendant la Salah, le sommeil et le mode enfant.';

  @override
  String get screenTimeAndroidUsageTitle => 'Accès d\'utilisation';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Autoriser Deen Focus à suivre les autres apps utilisées.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Accessibilité';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus a besoin de l\'accessibilité pour mettre en pause les apps distrayantes pendant les sessions de focus.';

  @override
  String get screenTimeAndroidPermit => 'Autoriser';

  @override
  String get screenTimeAndroidEnable => 'Activer';

  @override
  String get screenTimeAndroidNotNow => 'Pas maintenant';

  @override
  String get focusModesTitle => 'Tout dans une seule app';

  @override
  String get focusModesSubtitle =>
      'Découvrez tout ce que propose Deen Focus. Appuyez sur un mode focus pour voir comment il fonctionne.';

  @override
  String get focusModesSectionLabel =>
      'MODES FOCUS · APPUYER POUR EN SAVOIR PLUS';

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
      'Bloquez automatiquement les apps distrayantes pendant la Salah pour prier avec un plein khushu.';

  @override
  String get focusPrayerModeBullet1 =>
      'Verrouille les apps à l\'heure de la prière';

  @override
  String get focusPrayerModeBullet2 =>
      'Se déverrouille quand vous avez terminé';

  @override
  String get focusPrayerModeBullet3 => 'Renforce focus et régularité';

  @override
  String get focusSleepModeTitle => 'Mode veille';

  @override
  String get focusSleepModeDescription =>
      'Détendez-vous de façon halal. Bloquez les apps au coucher pour bien vous reposer et vous réveiller pour le Fajr.';

  @override
  String get focusSleepModeBullet1 =>
      'Bloque les apps automatiquement au coucher';

  @override
  String get focusSleepModeBullet2 => 'Rappels doux pour le réveil du Fajr';

  @override
  String get focusSleepModeBullet3 => 'Protège votre sommeil et le Fajr';

  @override
  String get focusChildModeTitle => 'Mode enfant';

  @override
  String get focusChildModeDescription =>
      'Vous donnez votre téléphone à votre enfant ? Verrouillez instantanément les apps pour qu\'il ne voie que ce qui est sûr.';

  @override
  String get focusChildModeBullet1 => 'Mode sécurisé en un tap';

  @override
  String get focusChildModeBullet2 => 'Sortie protégée par code';

  @override
  String get focusChildModeBullet3 => 'L\'esprit tranquille, à chaque fois';

  @override
  String get focusModeGotIt => 'Compris';

  @override
  String get focusFeaturePrayerTimesTitle => 'Horaires de prière précis';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan et rappels';

  @override
  String get focusFeatureStreaksTitle => 'Séries';

  @override
  String get focusFeatureStreaksSubtitle => 'Restez constant';

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
  String get focusFeatureQuranSubtitle => 'Traductions, jouz et pages';

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
  String get focusFeatureAiSubtitle => 'Posez des questions sur votre din';

  @override
  String get focusFeatureInsightsTitle => 'Statistiques';

  @override
  String get focusFeatureInsightsSubtitle =>
      'Données hebdomadaires et mensuelles';

  @override
  String get investTitle => 'Investir dans le Deen';

  @override
  String get investSubtitle =>
      'Le meilleur investissement n\'est pas dans ce qui s\'efface — c\'est dans ce qui vous rapproche d\'Allah. Essayez tout gratuitement pendant 7 jours.';

  @override
  String get investPremiumUnlocked => 'PREMIUM DÉBLOQUÉ';

  @override
  String get investTrialPill =>
      '✨ 7 jours gratuits — annulez à tout moment avant la fin';

  @override
  String get investNoCommitment => 'Sans engagement. Annulez à tout moment.';

  @override
  String get investFeatureAiTitle => 'Assistant islamique IA';

  @override
  String get investFeatureAiBody =>
      'Posez toute question sur votre Deen — des réponses ancrées dans des sources authentiques.';

  @override
  String get investFeaturePrayerModeTitle => 'Mode prière plein écran';

  @override
  String get investFeaturePrayerModeBody =>
      'Un écran calme et sans distraction qui vous appelle à la Salâh.';

  @override
  String get investFeatureAppBlockingTitle => 'Blocage d\'apps avancé';

  @override
  String get investFeatureAppBlockingBody =>
      'Un contrôle précis sur les apps verrouillées et le moment exact.';

  @override
  String get investFeatureNightModeTitle => 'Mode discipline nocturne';

  @override
  String get investFeatureNightModeBody =>
      'Détendez-vous à temps, dormez mieux et réveillez-vous pour le Fajr.';

  @override
  String get investFeaturePlannerTitle => 'Planificateur de prière et progrès';

  @override
  String get investFeaturePlannerBody =>
      'Séries, analyses et journaux qui vous gardent régulier.';

  @override
  String get investFeatureToolsTitle => 'Outils islamiques exclusifs';

  @override
  String get investFeatureToolsBody =>
      'Calendrier hijri, douas, tasbih, 99 Noms et plus.';

  @override
  String get investFeatureThemesTitle => 'Thèmes premium et mises à jour';

  @override
  String get investFeatureThemesBody =>
      'De beaux thèmes plus chaque nouvelle fonctionnalité que nous publions.';

  @override
  String get investFeatureTajweedTitle => 'Maîtriser le Tajweed';

  @override
  String get investFeatureTajweedBody =>
      'Améliorez votre récitation avec des leçons guidées et un retour en temps réel.';

  @override
  String get socialProofPrefix => 'Rejoignez ';

  @override
  String get socialProofHighlight => '10 000+';

  @override
  String get socialProofSuffix => ' musulmans qui grandissent avec DeenFocus';

  @override
  String get mostPopular => 'Les plus populaires';

  @override
  String get monthlyLabel => 'Mensuel';

  @override
  String get yearlyLabel => 'Annuel';

  @override
  String get lifetimeLabel => 'Durée de vie';

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
  String get homeSearchNearbyMosques =>
      'Trouvez des mosquées à proximité via OpenStreetMap.';

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
  String get homeTapPrayerToMark =>
      'Appuyez sur une prière pour la marquer comme accomplie, qada ou manquée.';

  @override
  String get homeSetLocation => 'Définir l\'emplacement';

  @override
  String get homeEditPrayerSettings => 'Modifier les paramètres de prière';

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
  String get hijriYear => 'H';

  @override
  String get hijriMonthMuharram => 'Mouharram';

  @override
  String get hijriMonthSafar => 'Safar';

  @override
  String get hijriMonthRabiAlAwwal => 'Rabi\' al-Awwal';

  @override
  String get hijriMonthRabiAlThani => 'Rabi\' al-Thani';

  @override
  String get hijriMonthJumadaAlAwwal => 'Joumada al-Oula';

  @override
  String get hijriMonthJumadaAlThani => 'Joumada al-Thania';

  @override
  String get hijriMonthRajab => 'Rajab';

  @override
  String get hijriMonthShaban => 'Cha\'ban';

  @override
  String get hijriMonthRamadan => 'Ramadan';

  @override
  String get hijriMonthShawwal => 'Chawwal';

  @override
  String get hijriMonthDhuAlQadah => 'Dhou al-Qi\'da';

  @override
  String get hijriMonthDhuAlHijjah => 'Dhou al-Hijja';

  @override
  String get calendarTitle => 'Calendrier islamique';

  @override
  String get calendarBack => 'Retour';

  @override
  String get calendarToday => 'Aujourd\'hui';

  @override
  String get calendarTomorrow => 'Demain';

  @override
  String calendarDaysAway(int days) {
    return '$days jours';
  }

  @override
  String get calendarNoEventsThisWeek =>
      'Aucun événement islamique cette semaine.';

  @override
  String get calendarNoEventsBlessing =>
      'Qu\'Allah bénisse votre semaine de paix et de bien.';

  @override
  String get calendarNoUpcomingEvents => 'Aucun événement islamique à venir.';

  @override
  String get calendarUpcomingEvents => 'Événements islamiques à venir';

  @override
  String get calendarUpcomingThisYear => 'À venir cette année';

  @override
  String get calendarThisWeekObservances => 'Cette semaine';

  @override
  String get calendarLegendCycleDays => 'Jours de cycle (série protégée)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent % illuminée';
  }

  @override
  String get calendarMoonNew => 'Nouvelle lune';

  @override
  String get calendarMoonWaxingCrescent => 'Croissant ascendant';

  @override
  String get calendarMoonFirstQuarter => 'Premier quartier';

  @override
  String get calendarMoonWaxingGibbous => 'Gibbeuse croissante';

  @override
  String get calendarMoonFull => 'Pleine lune';

  @override
  String get calendarMoonWaningGibbous => 'Gibbeuse décroissante';

  @override
  String get calendarMoonLastQuarter => 'Dernier quartier';

  @override
  String get calendarMoonWaningCrescent => 'Croissant descendant';

  @override
  String get calendarEventRamadanBegins => 'Début du Ramadan';

  @override
  String get calendarEventRamadanBeginsDesc => 'Mois du jeûne';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Nuit du Destin';

  @override
  String get calendarEventEidAlFitr => 'Aïd al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc => 'Fête de la rupture du jeûne';

  @override
  String get calendarEventDayOfArafah => 'Jour d\'Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Jour de la station à Arafah';

  @override
  String get calendarEventEidAlAdha => 'Aïd al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Fête du sacrifice';

  @override
  String get calendarEventIslamicNewYear => 'Nouvel An islamique';

  @override
  String get calendarEventIslamicNewYearDesc => '1er muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Naissance du Prophète';

  @override
  String get calendarEventAshura => 'Achoura';

  @override
  String get calendarEventAshuraDesc => '10 muharram';

  @override
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Prière du vendredi en congrégation';

  @override
  String get calendarEventWhiteDays => 'Jours blancs';

  @override
  String get calendarEventWhiteDaysDesc => 'Jours de jeûne recommandés';

  @override
  String get cycleModeActiveTitle =>
      '« Allah veut pour vous la facilité et ne veut pas pour vous la difficulté. » — Coran 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'Pendant cette période, votre série est protégée. Les jours du cycle sont en rose, et le Mode cycle s\'éteint automatiquement à la fin du cycle.';

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
      other: 'Se termine automatiquement dans $days jours',
      one: 'Se termine automatiquement demain',
      zero: 'Se termine aujourd\'hui',
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
    return 'Avez-vous prié $prayer ?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Gardez votre série en enregistrant votre prière.';

  @override
  String get prayerReminderYesButton => 'Oui, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'Je marquerai plus tard';

  @override
  String get prayerNotificationSubtitleFajr =>
      '« En vérité, la récitation de l’aube est toujours témoignée. » — Coran 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '« Accomplis la prière au déclin du soleil... » — Coran 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '« Soyez assidus aux prières, surtout à la prière médiane. » — Coran 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '« Glorifiez donc Allah lorsque vous atteignez le soir... » — Coran 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '« Accomplis la prière -  jusqu’à l’obscurité de la nuit. » — Coran 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'C\'est l\'heure de $prayerName';
  }

  @override
  String get homeTrialBannerTitle =>
      'Gratuit 7 jours — devenez un meilleur musulman ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Toutes les fonctionnalités débloquées. Commencez votre voyage aujourd\'hui.';

  @override
  String get homeFocusModeTitle => 'Mode focus';

  @override
  String get homeFocusModeSubtitle =>
      'Bloquez les apps distrayantes pendant la Salah';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Nuit';

  @override
  String get focusModeShortChild => 'Enfant';

  @override
  String get focusModeLabelSalah => 'Mode Salah';

  @override
  String get focusModeLabelNight => 'Mode nuit';

  @override
  String get focusModeLabelChild => 'Mode enfant';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return 'Les modes $first et $second sont activés';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return 'Les modes $first, $second et $third sont activés';
  }

  @override
  String get cycleModeTitle => 'Mode cycle';

  @override
  String get cycleModeSubtitle =>
      'Pour les menstruations — pausez les prières, gardez votre série';

  @override
  String get dailyChecklistTitle => 'Liste quotidienne';

  @override
  String get dailyChecklistSubtitle =>
      'Suivez vos objectifs spirituels quotidiens';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed sur $total terminés';
  }

  @override
  String get dailyChecklistSectionPrayer => 'Prière';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Coran et Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Bonnes actions';

  @override
  String get dailyChecklistSectionDistraction => 'Discipline personnelle';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Coran';

  @override
  String get dailyChecklistMorningAdhkar => 'Adhkar du matin';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar du soir';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Charité';

  @override
  String get dailyChecklistSmileAtSomeone => 'Sourire à quelqu\'un';

  @override
  String get dailyChecklistFamilyCall => 'Appel à la famille';

  @override
  String get dailyChecklistNoMusicToday => 'Pas de musique aujourd\'hui';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'Pas de réseaux sociaux avant Isha';

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
  String get quickActionsCalendar => 'Calendrier';

  @override
  String get quickActionsCalendarSubtitle => 'Voir les dates islamiques';

  @override
  String get quickActionsSupportUs => 'Nous soutenir';

  @override
  String get quickActionsSupportUsSubtitle => 'Aidez-nous à grandir';

  @override
  String get quickActionsSupportUsMessage =>
      'Merci d\'envisager de soutenir DeenFocus ! Les fonctions de soutien arrivent bientôt.';

  @override
  String get supportUsTitle => 'Soutenir DeenFocus';

  @override
  String get supportUsHeroTitle => 'Soutenir DeenFocus';

  @override
  String get supportUsHeroBody =>
      'Votre soutien nous aide à améliorer DeenFocus et à contribuer à des causes significatives.';

  @override
  String get supportUsFundSection => 'Votre soutien aide à financer';

  @override
  String get supportUsFundSectionSubtitle =>
      'Nous utilisons votre soutien pour créer plus de bien.';

  @override
  String get supportUsFundFeature1Title => 'Nouvelles fonctionnalités';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Créer et améliorer des fonctionnalités DeenFocus utiles.';

  @override
  String get supportUsFundFeature2Title => 'Corrections de bugs';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Garder l’app stable, rapide et fiable pour tous.';

  @override
  String get supportUsFundFeature3Title => 'Personnes dans le besoin';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Soutenir ceux qui traversent des moments difficiles.';

  @override
  String get supportUsFundFeature4Title => 'Charité et communauté';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Contribuer à des initiatives caritatives et au soutien communautaire.';

  @override
  String get supportUsNeedHelp => 'BESOIN D\'AIDE ?';

  @override
  String get supportUsWhatsApp => 'Discuter sur WhatsApp';

  @override
  String get supportUsEmailSupport => 'Assistance par e-mail';

  @override
  String get supportUsChooseAmountTitle => 'Choisir un montant de soutien';

  @override
  String get supportUsChooseAmountSubtitle =>
      'Vous pouvez soutenir plusieurs fois.';

  @override
  String get supportUsSecurePaymentNote =>
      'Paiement unique sécurisé · Aucun frais récurrent';

  @override
  String get supportUsTrustBanner =>
      'Sécurisé • Soutien unique • Soutien multiple possible';

  @override
  String get supportUsImpactSectionTitle =>
      'Où votre soutien fait la différence';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Chaque contribution a un impact durable.';

  @override
  String get supportUsImpactPalestine =>
      'Soutien et sensibilisation pour la Palestine';

  @override
  String get supportUsImpactNeedy => 'Aider ceux qui en ont besoin';

  @override
  String get supportUsImpactCommunity => 'Charité et soutien communautaire';

  @override
  String get supportUsImpactExperience => 'Meilleure expérience DeenFocus';

  @override
  String get supportUsImpactFeatures =>
      'Nouvelles fonctionnalités et mises à jour';

  @override
  String get supportUsImpactQuran => 'Coran et apprentissage islamique';

  @override
  String get supportUsImpactServers => 'Serveurs et fiabilité de l’app';

  @override
  String supportUsCta(String amount) {
    return 'Soutenir DeenFocus avec $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, j\'ai besoin d\'aide avec DeenFocus.';

  @override
  String get supportUsEmailSubject => 'Demande d\'assistance DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'Impossible d\'ouvrir cette application sur cet appareil.';

  @override
  String get supportUsLaunchFailed =>
      'Une erreur s\'est produite. Veuillez réessayer.';

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
  String get tabQuran => 'Apprendre';

  @override
  String get tabLearn => 'Apprendre';

  @override
  String get quranLoadFailed => 'Échec du chargement des données du Coran';

  @override
  String get quranTabSubtitle => 'Lisez et explorez le Saint Coran';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Rechercher sourate...';

  @override
  String get quranSearchHintExtended => 'Rechercher une sourate ou un sens...';

  @override
  String get quranNoResults => 'No results found';

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
  String get quranModeSurah => 'Sourate';

  @override
  String get quranModeJuz => 'Jouz';

  @override
  String get quranModePage => 'Page';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => 'Continuer la lecture';

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
    return '$percent % du jouz $juz';
  }

  @override
  String get quranBookmarksTitle => 'Signets';

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
    return '$count enregistrés';
  }

  @override
  String get quranQuickTajweed => 'Exercice de tajwid';

  @override
  String get quranQuickTajweedSub => 'Réciter et noter';

  @override
  String get quranLastListened => 'Dernière écoute';

  @override
  String get quranNoneYet => 'Aucun pour l’instant';

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
  String get readingSettingsTitle => 'Paramètres de lecture';

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
  String get tajweedStartReciting => 'Commencer à réciter';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'PRÉCISION DES MOTS';

  @override
  String get tajweedWordReviewLabel => 'REVUE DES MOTS';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Réciter et vérifier le tajwid';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nasale, 2 temps';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Rebond d’écho';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Prolonger la voyelle';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Fusionner les lettres';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Cacher le noun';

  @override
  String get save => 'Sauvegarder';

  @override
  String get tasbihBack => 'Retour';

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
  String get widgetPrayerProgressTitle => 'Votre progression de prière';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed sur $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'prières accomplies.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Continuez — $count prières restantes aujourd’hui';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — toutes les prières d’aujourd’hui sont faites';

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
  String get settingsRateDeenFocus => 'Rate DeenFocus ⭐';

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
  String get nearbyMosquesTitle => 'Mosquées trouvées à proximité';

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
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Rayon de recherche : $radiusKm km';
  }

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
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'Aucune mosquée trouvée à moins de $radiusKm km';
  }

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
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'Rien n’est répertorié à moins de $radiusKm km sur OpenStreetMap pour cet endroit. Réessayez plus tard ou élargissez la zone.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count mosquées trouvées dans un rayon de $radiusKm km';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count mosquées à proximité';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'Dans un rayon de $radiusKm km · Triées par distance';
  }

  @override
  String get nearbyMosquesDirections => 'Itinéraire';

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
  String get insightsPrayerStreak => 'Série de prières';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => 'Prières d\'affilée';

  @override
  String get insightsDaysInARow => 'Jours d\'affilée';

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
  String get insightsFocusExcellent => 'Excellent — continuez !';

  @override
  String get insightsFocusKeepGoing => 'Continuez à renforcer votre focus';

  @override
  String get insightsTodaysPrayers => 'Prières du jour';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Mode cycle actif';

  @override
  String get insightsProtectedByCycleMode => 'Votre série est protégée.';

  @override
  String get insightsCurrentPrayerStreak => 'Série de prières actuelle';

  @override
  String get insightsBestPrayerStreak => 'Meilleure série de prières';

  @override
  String get insightsCurrentDayStreak => 'Série de jours actuelle';

  @override
  String get insightsCycleProtectedDays => 'Jours protégés par le cycle';

  @override
  String get insightsAchievements => 'Succès';

  @override
  String get insightsAchieved => 'Atteint';

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
      'Activez le Mode cycle pour protéger votre série pendant les jours de repos.';

  @override
  String get achievementFirstPrayerStreak => 'Première série de prières';

  @override
  String get achievementSevenPrayerStreak => 'Série de sept prières';

  @override
  String get achievementThirtyPrayerStreak => 'Série de trente prières';

  @override
  String get achievementFajrWarrior => 'Guerrier du Fajr';

  @override
  String get achievementQuranReader => 'Lecteur du Coran';

  @override
  String get achievementDhikrMaster => 'Maître du Dhikr';

  @override
  String get achievementConsistencyChampion => 'Champion de la constance';

  @override
  String get prayerCompletionAlhamdulillah => 'Alhamdulillah !';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer est accomplie';
  }

  @override
  String get prayerCompletionStreakIncreased =>
      'Votre série de prières a augmenté';

  @override
  String get prayerCompletionKeepGoing =>
      'Chaque prière vous rapproche d\'Allah. Continuez !';

  @override
  String get prayerCompletionContinue => 'Continuer';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Prochaine prière dans $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get weekdayLetterMon => 'L';

  @override
  String get weekdayLetterTue => 'M';

  @override
  String get weekdayLetterWed => 'M';

  @override
  String get weekdayLetterThu => 'J';

  @override
  String get weekdayLetterFri => 'V';

  @override
  String get weekdayLetterSat => 'S';

  @override
  String get weekdayLetterSun => 'D';

  @override
  String get focusHomeBlockingNightAndSalah =>
      'La Discipline nocturne et le mode Salah bloquent les apps sélectionnées.';

  @override
  String get focusHomeBlockingNight =>
      'La Discipline nocturne bloque les apps sélectionnées.';

  @override
  String get focusHomeBlockingSalah =>
      'Le mode Salah bloque les apps sélectionnées.';

  @override
  String get focusHomeAppsBlockedNow =>
      'Les apps sélectionnées sont bloquées actuellement.';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode est activé.';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes sont activés.';
  }

  @override
  String get focusHomeChooseMode =>
      'Choisissez un mode pour protéger votre attention';

  @override
  String get focusStatusSelectApps => 'Sélectionnez des apps pour commencer';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Discipline nocturne et mode Salah bloquent les apps maintenant';

  @override
  String get focusStatusBlockingNight =>
      'Discipline nocturne bloque les apps maintenant';

  @override
  String get focusStatusBlockingSalah =>
      'Le mode Salah bloque les apps maintenant';

  @override
  String get focusStatusAppsLocked => 'Les apps sont verrouillées maintenant';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Déverrouillé jusqu\'à $time';
  }

  @override
  String get focusStatusNoMode => 'Aucun mode focus activé';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Prêt à verrouiller $targets';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '$hours h $minutes min $seconds s';
  }

  @override
  String get appLockDemoIntroTitle => 'Découvrez le verrouillage d’apps';

  @override
  String get appLockDemoIntroSubtitle =>
      'Restez dans DeenFocus. Sur l’écran suivant, touchez Instagram pour voir la pause à l’heure de la prière.';

  @override
  String get appLockDemoStartButton => 'Lancer la démo';

  @override
  String get appLockDemoTryOpeningApp => 'Essayez d’ouvrir Instagram';

  @override
  String get appLockDemoSalahModeBadge => 'MODE SALAH';

  @override
  String get appLockDemoTimeToPray => 'C’est l’heure de prier';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Temps restant : $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'J’ai prié $prayerName';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName terminée';
  }

  @override
  String get appLockDemoStreakIncreased => 'Votre série de prières a augmenté';

  @override
  String get appLockDemoPrayerStreakLabel => 'SÉRIE DE PRIÈRE';

  @override
  String get appLockDemoDayStreakLabel => 'SÉRIE DE JOURS';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Prochaine prière dans $minutes minutes';
  }

  @override
  String get appLockDemoStreakMotivation =>
      'Continuez ! Votre constance vous rapproche d’Allah.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Priez. Validez une fois.\nReprenez votre journée.';

  @override
  String get appLockDemoCompletionBody =>
      'Le verrouillage d’apps met en pause en douceur les apps choisies pendant la Salah pour que vous puissiez vous concentrer — puis vous continuez quand vous êtes prêt.';

  @override
  String get appLockDemoContinueSetup => 'Continuer la configuration';

  @override
  String get appLockDemoAppMessages => 'Messages';

  @override
  String get appLockDemoAppCalendar => 'Calendrier';

  @override
  String get appLockDemoAppPhotos => 'Photos';

  @override
  String get appLockDemoAppCamera => 'Appareil photo';

  @override
  String get appLockDemoAppMail => 'Mail';

  @override
  String get appLockDemoAppMaps => 'Plans';

  @override
  String get appLockDemoAppWeather => 'Météo';

  @override
  String get appLockDemoAppClock => 'Horloge';

  @override
  String get appLockDemoAppNotes => 'Notes';

  @override
  String get appLockDemoAppSettings => 'Réglages';

  @override
  String get appLockDemoAppMusic => 'Musique';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Mises à jour de prière';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live Activity pour votre prochaine prière sur l\'écran de verrouillage';

  @override
  String get liveActivitySectionTitle => 'Live Activities';

  @override
  String get liveActivityStayUpdatedTitle => 'Restez informé d\'un coup d\'œil';

  @override
  String get liveActivityStayUpdatedBody =>
      'Voyez votre prochaine prière et son heure directement sur l\'écran de verrouillage.';

  @override
  String get liveActivityEnableLabel => 'Activer la Live Activity';

  @override
  String get liveActivityPromptNotNow => 'Pas maintenant';

  @override
  String get liveActivityUnsupported =>
      'Les Live Activities ne sont pas disponibles sur cet appareil.';

  @override
  String get liveActivityPermissionNeeded =>
      'Autorisez les notifications pour afficher les mises à jour de prière sur l\'écran de verrouillage.';

  @override
  String get liveActivityPermissionButton => 'Autoriser les notifications';

  @override
  String get liveActivityStatusActive => 'Live Activity activée';

  @override
  String get liveActivityStatusOff => 'Live Activity désactivée';

  @override
  String get liveActivityNowLabel => 'Maintenant';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Mis à jour à $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer à $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Alarmes de prière';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Alarmes complètes pouvant passer le mode silencieux';

  @override
  String get prayerAlarmsMasterLabel => 'Activer les alarmes de prière';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Planifier une alarme native pour chaque prière sélectionnée';

  @override
  String get prayerAlarmsSnoozeLabel => 'Durée du report';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Alarmes par prière';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Autorisez les alarmes pour qu\'elles se déclenchent à l\'heure.';

  @override
  String get prayerAlarmsPermissionButton => 'Autoriser les alarmes';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Autorisez les alarmes plein écran pour l’écran de verrouillage. Sinon, elles s’affichent en bannière.';

  @override
  String get prayerAlarmsFsiButton => 'Réglages plein écran';

  @override
  String get prayerAlarmsUnsupported =>
      'Les alarmes natives ne sont pas disponibles sur cet appareil. Les notifications douces fonctionnent toujours.';

  @override
  String get prayerAlarmsIosFallback =>
      'Sur cette version d\'iOS, les notifications douces remplacent AlarmKit.';

  @override
  String get prayerAlarmsDeniedTitle => 'Autorisation d’alarme requise';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Les alarmes de prière restent désactivées jusqu’à l’autorisation. Les notifications douces ne sont pas affectées.';

  @override
  String get prayerAlarmsOpenSettings => 'Ouvrir Réglages';

  @override
  String get prayerAlarmsStatusReady =>
      'Les alarmes sont prêtes à être planifiées';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Autorisation requise — alarmes inactives';

  @override
  String get prayerAlarmsStatusFallback =>
      'Notifications douces utilisées sur cet appareil';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Alarmes activées. Activez le plein écran pour l’écran de verrouillage.';

  @override
  String get prayerAlarmsCancel => 'Pas maintenant';

  @override
  String get homePrayerAlarmEnableLabel => 'Alarme de prière';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Sonner une alarme native à $prayerName';
  }

  @override
  String get prayerAlarmBadge => 'Alarme de prière';

  @override
  String get prayerAlarmSubtitle => 'Il est temps de prier';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — Il est temps de prier';
  }

  @override
  String get prayerAlarmIvePrayed => 'J\'ai prié';

  @override
  String get prayerAlarmDismiss => 'Ignorer';

  @override
  String get prayerAlarmSnooze => 'Reporter';

  @override
  String get appLockDemoAppPhone => 'Téléphone';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Rappels';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Livres';

  @override
  String get appLockDemoAppHealth => 'Santé';

  @override
  String get appLockDemoAppWallet => 'Wallet';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'Démo de l’app';

  @override
  String get settingsAppDemoChooseModeTitle => 'Découvrez le verrouillage';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Choisissez un mode Focus et voyez comment les apps sélectionnées se mettent en pause — sans quitter DeenFocus.';

  @override
  String get appLockDemoDone => 'Terminé';

  @override
  String get appLockDemoSleepIntroTitle => 'Découvrez le mode Sommeil';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Restez dans DeenFocus. Sur l’écran suivant, touchez Instagram pour voir la pause à l’heure du coucher.';

  @override
  String get appLockDemoSleepModeBadge => 'MODE SOMMEIL';

  @override
  String get appLockDemoSleepLockTitle => 'Il est temps de se reposer';

  @override
  String get appLockDemoSleepLockCta => 'Je suis prêt à me reposer';

  @override
  String get appLockDemoSleepCompleted => 'Mode Sommeil protégé';

  @override
  String get appLockDemoSleepRewardSubtitle =>
      'Votre protection nocturne a augmenté';

  @override
  String get appLockDemoSleepStreakLabel => 'SÉRIE NUIT';

  @override
  String get appLockDemoSleepRewardFooter => 'Rappel Fajr prévu pour le matin';

  @override
  String get appLockDemoSleepMotivation =>
      'Reposez-vous bien ce soir pour vous lever pour Fajr avec énergie.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Nuits calmes.\nMatins clairs.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'Le mode Sommeil met en pause en douceur les apps choisies la nuit pour que vous puissiez vous reposer — puis vous continuez.';

  @override
  String get appLockDemoChildIntroTitle => 'Découvrez le mode Enfant';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Restez dans DeenFocus. Sur l’écran suivant, touchez Instagram pour voir le verrouillage en mode Enfant.';

  @override
  String get appLockDemoChildModeBadge => 'MODE ENFANT';

  @override
  String get appLockDemoChildLockTitle => 'Les apps sont protégées';

  @override
  String get appLockDemoChildLockDetail =>
      'Les apps sélectionnées restent verrouillées en mode Enfant';

  @override
  String get appLockDemoChildLockCta => 'Compris';

  @override
  String get appLockDemoChildCompleted => 'Mode Enfant actif';

  @override
  String get appLockDemoChildRewardSubtitle =>
      'Votre série de protection a augmenté';

  @override
  String get appLockDemoChildStreakLabel => 'SÉRIE SÉCURITÉ';

  @override
  String get appLockDemoChildRewardFooter =>
      'Quittez à tout moment avec votre code';

  @override
  String get appLockDemoChildMotivation =>
      'L’esprit tranquille chaque fois que vous prêtez votre téléphone.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'Mode sûr en un tap.\nSeulement ce que vous autorisez.';

  @override
  String get appLockDemoChildCompletionBody =>
      'Le mode Enfant verrouille les apps choisies pour que votre enfant ne voie que ce qui est sûr — puis vous déverrouillez.';

  @override
  String get appLockDemoSleepCompletionTitle => 'Reposez-vous bien ce soir';

  @override
  String get appLockDemoChildCompletionTitle => 'L’esprit tranquille';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Mettez les distractions en pause pendant la Salah pour prier avec présence.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Protégez vos nuits pour mieux vous reposer — et un Fajr plus léger.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Confiez votre téléphone en toute sérénité : seules les apps autorisées restent ouvertes.';

  @override
  String get settingsAppDemoHomeFeaturesTitle =>
      'Restez connecté d’un coup d’œil';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'Voyez comment les widgets et l’activité en direct gardent les heures de prière proches — sans ouvrir l’app.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Verset du jour et horaires de prière sur l’écran d’accueil, toujours à jour.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Prière actuelle et suivante sur l’écran de verrouillage et Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Récitez un verset et recevez un retour tajwid immédiat.';

  @override
  String get featureDemoTajweedTitle => 'Tajwid';

  @override
  String get featureDemoTajweedIntroTitle => 'Découvrez la pratique du tajwid';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Restez dans DeenFocus. Ouvrez l’exercice tajwid, récitez un verset et voyez le retour mot par mot.';

  @override
  String get featureDemoTajweedQuranCallout =>
      'Touchez Exercice tajwid pour commencer';

  @override
  String get featureDemoTajweedLegendCallout =>
      'Les couleurs montrent les règles de tajwid à la lecture';

  @override
  String get featureDemoTajweedReciteCallout =>
      'Touchez Réciter et vérifier le tajwid';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'Téléchargement unique pour pratiquer hors ligne';

  @override
  String get featureDemoTajweedMicCallout =>
      'Touchez le micro et commencez à réciter';

  @override
  String get featureDemoTajweedResultCallout =>
      'Voyez les mots justes, manqués ou à retravailler';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tajwid, prêt';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Récitez en confiance, à tout moment.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Ouvrez Coran → Exercice tajwid pour pratiquer n’importe quel verset avec un score sur l’appareil — entièrement hors ligne après le premier téléchargement.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 versets • Mecquoise';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 versets • Médinoise';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => 'Al-Fatiha • 7 versets';

  @override
  String get featureDemoTajweedSurahMeta => 'SOURATE 1 • MECQUOISE';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'Au nom d’Allah, le Tout Miséricordieux, le Très Miséricordieux.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatihah · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'Préparation du modèle d’IA';

  @override
  String get featureDemoTajweedPreparingBody =>
      'Téléchargement unique pour que la pratique du tajwid fonctionne ensuite entièrement hors ligne. Cela n’arrive qu’une fois.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Continuez à pratiquer — écoutez la référence et réessayez.';

  @override
  String get featureDemoTajweedStatCorrect => 'Correct';

  @override
  String get featureDemoTajweedStatPronunciation => 'Prononciation';

  @override
  String get featureDemoTajweedStatWrong => 'Mot incorrect';

  @override
  String get featureDemoTajweedStatMissed => 'Manqué';

  @override
  String get featureDemoTajweedStatExtra => 'En trop';

  @override
  String get featureDemoContinue => 'Continuer';

  @override
  String get featureDemoSampleStatusTime => '09:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      'Votre appareil n’autorise pas les apps à placer des widgets automatiquement. Ajoutez le grand widget DeenFocus depuis la galerie de widgets de l’écran d’accueil.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Ajoutez le widget depuis l’écran d’accueil';

  @override
  String get featureDemoOfferNo => 'Non';

  @override
  String get featureDemoOfferYes => 'Oui';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      'Voulez-vous activer l’activité en direct sur votre appareil ?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      'Voulez-vous ajouter ce widget à votre écran d’accueil ?';

  @override
  String get featureDemoWidgetsTitle => 'Widgets';

  @override
  String get featureDemoWidgetsIntroTitle => 'Découvrez vos widgets';

  @override
  String get featureDemoWidgetsIntroSubtitle =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsShowcaseCallout =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsDetailsTitle =>
      'Guidance de prière d’un coup d’œil';

  @override
  String get featureDemoWidgetsDetailsBody =>
      'Le widget moyen affiche le verset du jour et les cinq prières — mis à jour à l’ouverture de DeenFocus.';

  @override
  String get featureDemoWidgetsCompletionTitle => 'Widgets prêts';

  @override
  String get featureDemoWidgetsCompletionSubtitle =>
      'Des rappels de foi sur votre écran d’accueil.';

  @override
  String get featureDemoWidgetsCompletionBody =>
      'Ajoutez les widgets DeenFocus depuis la galerie, puis ouvrez l’app une fois pour synchroniser.';

  @override
  String get featureDemoWidgetsHomeHint => 'Mercredi 13 août';

  @override
  String get featureDemoWidgetSampleDate => 'Mer. 13 août';

  @override
  String get featureDemoWidgetSampleVerse =>
      'C’est Toi que nous adorons et c’est Toi dont nous implorons le secours.';

  @override
  String get featureDemoWidgetSampleSource => 'Sourate 1:5';

  @override
  String get featureDemoLiveActivityTitle => 'Activité en direct';

  @override
  String get featureDemoLiveActivityIntroTitle => 'Voir l’activité en direct';

  @override
  String get featureDemoLiveActivityIntroSubtitle =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityShowcaseCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveActivityDetailsTitle =>
      'Mises à jour de prière toujours visibles';

  @override
  String get featureDemoLiveActivityDetailsBody =>
      'L’activité en direct garde Maghrib, Isha et le compte à rebours sur l’écran de verrouillage — activez-la dans Réglages.';

  @override
  String get featureDemoLiveActivityCompletionTitle =>
      'Activité en direct prête';

  @override
  String get featureDemoLiveActivityCompletionSubtitle =>
      'La prochaine prière, toujours proche.';

  @override
  String get featureDemoLiveActivityCompletionBody =>
      'Activez l’activité en direct dans Réglages → Calcul de prière pour l’afficher sur l’écran de verrouillage.';

  @override
  String get featureDemoLiveActivityLockHint => 'Mercredi 13 août';

  @override
  String get featureDemoLiveActivitySampleTime => '18:48';

  @override
  String get featureDemoLiveActivitySampleNextTime => '20:11';

  @override
  String get featureDemoWidgetsIntroSubtitleIos =>
      'Restez dans DeenFocus. Appuyez longuement sur l’écran d’accueil, ajoutez un widget et essayez les 3 tailles.';

  @override
  String get featureDemoWidgetsIntroSubtitleAndroid =>
      'Restez dans DeenFocus. Appuyez longuement sur l’écran d’accueil, ouvrez le sélecteur et essayez les 3 tailles.';

  @override
  String get featureDemoWidgetsLongPressCalloutIos =>
      'Appuyez longuement sur l’écran d’accueil';

  @override
  String get featureDemoWidgetsLongPressCalloutAndroid =>
      'Appuyez longuement sur l’écran d’accueil';

  @override
  String get featureDemoWidgetsAddCallout =>
      'Touchez + pour choisir un widget DeenFocus';

  @override
  String get featureDemoWidgetsAddSlotLabel => 'Ajouter un widget';

  @override
  String get featureDemoWidgetsGalleryTitle => 'Choisissez un widget DeenFocus';

  @override
  String get featureDemoWidgetsGallerySubtitle =>
      'Passez de Petit à Moyen à Grand — puis ajoutez-le à l’écran d’accueil.';

  @override
  String get featureDemoWidgetsAddCta => 'Ajouter le widget';

  @override
  String get featureDemoWidgetsAddCtaAndroid => 'Ajouter le widget';

  @override
  String get featureDemoWidgetsChangeCta => 'Changer la taille';

  @override
  String get featureDemoWidgetSizeSmall => 'Petit';

  @override
  String get featureDemoWidgetSizeMedium => 'Moyen';

  @override
  String get featureDemoWidgetSizeLarge => 'Grand';

  @override
  String get featureDemoWidgetSizeSmallSubtitle =>
      'Horaires de prière compacts';

  @override
  String get featureDemoWidgetSizeMediumSubtitle =>
      'Verset du jour et les cinq prières';

  @override
  String get featureDemoWidgetSizeLargeSubtitle =>
      'Progression des prières et planning du jour';

  @override
  String get featureDemoLiveActivityIntroSubtitleIos =>
      'Restez dans DeenFocus. Activez l’activité en direct, puis voyez l’écran de verrouillage et Dynamic Island.';

  @override
  String get featureDemoLiveActivityIntroSubtitleAndroid =>
      'Restez dans DeenFocus. Activez l’activité en direct, puis voyez la notification permanente et le panneau.';

  @override
  String get featureDemoLiveOpenPrayerCalcCallout => 'Touchez Calcul de prière';

  @override
  String get featureDemoLiveEnableToggleCallout =>
      'Activez « Activer l’activité en direct »';

  @override
  String get featureDemoLiveLockScreenCallout =>
      'Votre activité de prière sur l’écran de verrouillage';

  @override
  String get featureDemoLiveCompactTitle => 'Dynamic Island compacte';

  @override
  String get featureDemoLiveCompactCallout =>
      'La prière actuelle reste visible en haut';

  @override
  String get featureDemoLiveExpandCta => 'Agrandir Dynamic Island';

  @override
  String get featureDemoLiveExpandedTitle => 'Dynamic Island agrandie';

  @override
  String get featureDemoLiveExpandedCallout =>
      'Heure actuelle et prochaine prière ensemble';

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
  String get featureDemoAndroidOngoingTitle =>
      'Notification de prière en direct';

  @override
  String get featureDemoAndroidOngoingCallout =>
      'Silent ongoing update — current and next prayer';

  @override
  String get featureDemoAndroidOpenShadeCta =>
      'Ouvrir le panneau de notifications';

  @override
  String get featureDemoAndroidShadeTitle => 'Panneau de notifications';

  @override
  String get featureDemoAndroidShadeCallout =>
      'Expand to see the full current and next prayer status';

  @override
  String get featureDemoAndroidOngoingBadge => 'En cours';

  @override
  String get appLockDemoOfferPrayerTitle => 'Prêt à essayer le Mode Prière ?';

  @override
  String get appLockDemoOfferSleepTitle => 'Prêt à essayer le Mode Sommeil ?';

  @override
  String get appLockDemoOfferChildTitle => 'Prêt à essayer le Mode Enfant ?';

  @override
  String get appLockDemoOfferPrayerCta => 'Activer le Mode Prière';

  @override
  String get appLockDemoOfferSleepCta => 'Activer le Mode Sommeil';

  @override
  String get appLockDemoOfferChildCta => 'Activer le Mode Enfant';

  @override
  String get appLockDemoOfferNotNow => 'Pas maintenant';

  @override
  String get nightlyWrapUpPrayersTitle => 'Terminez les prières d’aujourd’hui';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Marquez les prières incomplètes ou manquées pour protéger votre série de prières.';

  @override
  String get nightlyWrapUpChecklistTitle => 'Complétez votre liste du jour';

  @override
  String get nightlyWrapUpChecklistBody =>
      'Quelques éléments restent ouverts — concluez votre journée avec intention.';

  @override
  String get nightlyWrapUpBothTitle => 'Concluez votre journée';

  @override
  String get nightlyWrapUpBothBody =>
      'Marquez les prières restantes et terminez votre liste du jour avant la fin de la journée.';

  @override
  String get cycleModeEndedNotificationTitle => 'Le mode cycle est terminé';

  @override
  String get cycleModeEndedNotificationBody =>
      'Votre mode cycle est maintenant désactivé. Vous pouvez reprendre la prière. Si vous voulez modifier les dates du mode cycle, appuyez ici pour les éditer.';

  @override
  String get libraryHomeTitle => 'Bibliothèque islamique';

  @override
  String get libraryHomeSubtitle =>
      'Apprenez les hadiths, les invocations, les 99 Noms et plus';

  @override
  String get libraryHubTitle => 'Bibliothèque islamique';

  @override
  String get libraryModuleQuran => 'Coran';

  @override
  String get libraryModuleQuranSub => 'Lisez, écoutez et pratiquez le tajwid';

  @override
  String get libraryModuleHadith => 'Hadith';

  @override
  String get libraryModuleHadithSub => 'Collections de sources authentiques';

  @override
  String get libraryModuleDuas => 'Invocations et adhkar';

  @override
  String get libraryModuleDuasSub => 'Souvenir du matin, du soir et quotidien';

  @override
  String get libraryModulePrayerMethods => 'Prière et méthodes islamiques';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, salat, hajj et plus';

  @override
  String get libraryModuleFiqh => 'Fiqh et traditions';

  @override
  String get libraryModuleFiqhSub =>
      'Sunnisme, chiisme, madhabs, Ahl-e Hadith et plus';

  @override
  String get libraryModuleNames => '99 Noms d’Allah';

  @override
  String get libraryModuleNamesSub => 'Apprenez et méditez sur Asma ul-Husna';

  @override
  String get libraryModulePillarsIslam => 'Piliers de l’islam';

  @override
  String get libraryModulePillarsIslamSub =>
      'Les cinq fondements de la foi en action';

  @override
  String get libraryModulePillarsIman => 'Piliers de la foi';

  @override
  String get libraryModulePillarsImanSub => 'Les six articles de la croyance';

  @override
  String get libraryModuleProphets => 'Prophète Muhammad';

  @override
  String get libraryModuleProphetsSub =>
      'Sa vie, sa mission et ses leçons intemporelles';

  @override
  String get libraryModuleOccasions => 'Occasions islamiques';

  @override
  String get libraryModuleOccasionsSub => 'Ramadan, Aïd, Hajj et jours sacrés';

  @override
  String get libraryKeyLesson => 'Leçon clé';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get libraryPrevious => 'Précédent';

  @override
  String get libraryNext => 'Suivant';

  @override
  String get libraryBookmark => 'Signet';

  @override
  String get libraryCopy => 'Copier';

  @override
  String get libraryShare => 'Partager';

  @override
  String get libraryCopied => 'Copié dans le presse-papiers';

  @override
  String get libraryShareCopiedHint => 'Copié — collez pour partager';

  @override
  String get libraryBookmarkSaved => 'Signet enregistré';

  @override
  String get libraryBookmarkRemoved => 'Signet supprimé';

  @override
  String get libraryTranslation => 'Traduction';

  @override
  String get libraryTransliteration => 'Translittération';

  @override
  String get libraryMeaning => 'Signification';

  @override
  String get libraryBookmarksTitle => 'Éléments d’apprentissage enregistrés';

  @override
  String get libraryBookmarksSubtitle =>
      'Hadiths, invocations, noms, fiqh et plus';

  @override
  String get libraryBookmarksEmpty =>
      'Aucun élément enregistré. Appuyez sur Signet sur un élément d’apprentissage pour l’enregistrer ici.';

  @override
  String get libraryMarkCompleted => 'Marquer comme terminé';

  @override
  String get librarySectionCompleted => 'Terminé';

  @override
  String get libraryReflection => 'Réflexion';

  @override
  String get libraryComingSoonTitle => 'Bientôt';

  @override
  String get libraryComingSoonBody =>
      'Ce module est en préparation. Revenez dans une future mise à jour.';

  @override
  String get librarySearchHint => 'Rechercher…';

  @override
  String get librarySearchEmpty => 'Aucun résultat';

  @override
  String libraryItemCount(int count) {
    return '$count éléments';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown sur $total';
  }

  @override
  String libraryContinueFrom(int number) {
    return 'Continuer · $number';
  }

  @override
  String get libraryInProgress => 'En cours';

  @override
  String libraryReference(String source) {
    return 'Référence : $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count invocations';
  }

  @override
  String get libraryDuaCategoryMorning => 'Matin';

  @override
  String get libraryDuaCategoryEvening => 'Soir';

  @override
  String get libraryDuaCategoryDailyLife => 'Vie quotidienne';

  @override
  String get libraryDuaCategorySleep => 'Sommeil';

  @override
  String get libraryDuaCategoryFood => 'Nourriture';

  @override
  String get libraryDuaCategoryTravel => 'Voyage';

  @override
  String get libraryDuaCategoryIllness => 'Maladie';

  @override
  String get libraryDuaCategoryProtection => 'Protection';

  @override
  String get libraryDuaCategoryForgiveness => 'Pardon';

  @override
  String get libraryDuaCategoryParents => 'Parents';

  @override
  String libraryHadithCount(int count) {
    return '$count hadiths';
  }

  @override
  String get libraryHadithNarrator => 'Narrateur :';

  @override
  String get libraryHadithSource => 'Source :';

  @override
  String get libraryHadithCollectionBukhari => 'Sahih al-Bukhari';

  @override
  String get libraryHadithCollectionMuslim => 'Sahih Muslim';

  @override
  String get libraryHadithCollectionRiyad => 'Riyad us-Saliheen';

  @override
  String get libraryHadithCollectionNawawi => '40 Hadiths Nawawi';

  @override
  String get libraryHadithCollectionHisnul => 'Hisnul Muslim';

  @override
  String libraryGuideStepCount(int count) {
    return '$count étapes';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get libraryGuideWudu => 'Wudu';

  @override
  String get libraryGuideSalah => 'Salat';

  @override
  String get libraryGuideGhusl => 'Ghusl';

  @override
  String get libraryGuideTayammum => 'Tayammum';

  @override
  String get libraryGuideJanazah => 'Prière funéraire';

  @override
  String get libraryGuideUmrah => 'Omra';

  @override
  String get libraryGuideHajj => 'Hajj';

  @override
  String get libraryGuideFasting => 'Jeûne';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawba';

  @override
  String get libraryOccasionImportance => 'Importance';

  @override
  String get libraryOccasionVirtues => 'Vertus';

  @override
  String get libraryOccasionRecommendedActs => 'Actes recommandés';

  @override
  String get libraryFiqhOverview => 'Aperçu';

  @override
  String get libraryFiqhKeyPoints => 'Points clés';

  @override
  String get libraryFiqhDifferences => 'Différences notables';

  @override
  String get libraryFiqhCommonGround => 'Points communs';

  @override
  String get insightsCompleted => 'Terminés';

  @override
  String get insightsInProgress => 'En cours';

  @override
  String get insightsKeepGoingTitle => 'Continue !';

  @override
  String get insightsKeepGoingBody =>
      'Tu fais de grands progrès. Chaque prière compte.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Succès débloqués';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer => 'Tu as accompli ta première prière.';

  @override
  String get achievementDescSevenPrayerStreak =>
      'Accomplis 7 prières d’affilée.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Accomplis 30 prières d’affilée.';

  @override
  String get achievementDescFajrWarrior => 'Prie le Fajr pendant 14 jours.';

  @override
  String get achievementDescFajrChampion => 'Prie le Fajr pendant 30 jours.';

  @override
  String get achievementDescFiveADay =>
      'Accomplis les cinq prières en un jour.';

  @override
  String get achievementDescPerfectWeek =>
      'Accomplis chaque prière pendant 7 jours d’affilée.';

  @override
  String get achievementDescPerfectMonth =>
      'Accomplis chaque prière pendant 30 jours d’affilée.';

  @override
  String get achievementDescQuranReader => 'Lis le Coran pendant 7 jours.';

  @override
  String get achievementDescQuranDevotee => 'Lis le Coran pendant 30 jours.';

  @override
  String get achievementDescDhikrStarter =>
      'Accomplis le dhikr pendant 7 jours.';

  @override
  String get achievementDescDhikrMaster =>
      'Accomplis le dhikr pendant 30 jours.';

  @override
  String get achievementDescNightWorshipper =>
      'Prie le Tahajjud pendant 7 jours.';

  @override
  String get achievementDescMasjidCompanion => 'Visite la mosquée 7 fois.';

  @override
  String get achievementDescDistractionDefender =>
      'Reste sans distraction pendant 7 jours.';

  @override
  String get achievementDescCycleGuardian =>
      'Protège ta série avec le mode cycle pendant 7 jours.';

  @override
  String get achievementDescProtectedMonth =>
      'Protège ta série avec le mode cycle pendant 30 jours.';

  @override
  String get achievementDescConsistencyChampion =>
      'Reste constant pendant 100 jours.';

  @override
  String get achievementDescSixMonthJourney => 'Continue pendant 180 jours.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Atteins DeenFocus Master (niveau 15).';

  @override
  String get dailyChecklistOptional => 'Facultatif';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Maîtriser la colère / Parler avec douceur';

  @override
  String get digitalBalanceTitle => 'Équilibre numérique';

  @override
  String get digitalBalanceSubtitle => 'Voyez où va votre temps';

  @override
  String get digitalBalanceViewCta => 'Voir l\'équilibre numérique →';

  @override
  String get digitalBalanceTodayLabel => 'Aujourd\'hui';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Autres applis';

  @override
  String get digitalBalanceTodayPhoneTime => 'Temps d\'écran aujourd\'hui';

  @override
  String get digitalBalanceWhereTimeGoes => 'Où va votre temps';

  @override
  String get digitalBalanceViewAllApps => 'Voir toutes les applis';

  @override
  String get digitalBalanceAllAppsTitle => 'Toutes les applis';

  @override
  String get digitalBalanceNoApps =>
      'Aucune utilisation d\'appli enregistrée aujourd\'hui.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen vs temps numérique';

  @override
  String get digitalBalanceYourWeek => 'Votre semaine';

  @override
  String get digitalBalanceThisWeek => 'Cette semaine';

  @override
  String get digitalBalancePhoneUsageLegend => 'Usage du téléphone';

  @override
  String get digitalBalanceDailyInsight => 'Note du jour';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Chaque minute passée à renforcer votre Deen compte.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'Votre temps DeenFocus est plus élevé cette semaine que la semaine dernière. MashaAllah !';

  @override
  String get digitalBalanceInsightQuietDay =>
      'Une journée calme pour l\'instant. Le temps DeenFocus apparaîtra ici.';

  @override
  String get digitalBalanceGoalTitle => 'Votre objectif de temps Deen';

  @override
  String get digitalBalanceAdjustGoal => 'Ajuster l\'objectif';

  @override
  String get digitalBalanceGoalReached =>
      'Vous avez atteint l\'objectif du jour. MashaAllah !';

  @override
  String get digitalBalanceGoalSheetTitle => 'Temps Deen quotidien';

  @override
  String get digitalBalanceGoalCustomHint => 'Minutes par jour';

  @override
  String get digitalBalanceGoalSave => 'Enregistrer';

  @override
  String get digitalBalanceGoal15 => '15 min';

  @override
  String get digitalBalanceGoal30 => '30 min';

  @override
  String get digitalBalanceGoal45 => '45 min';

  @override
  String get digitalBalanceGoal60 => '1 heure';

  @override
  String get digitalBalancePermissionTitle =>
      'Comprenez vos habitudes numériques';

  @override
  String get digitalBalancePermissionBody =>
      'Autorisez DeenFocus à accéder à l\'usage de vos applis pour voir où va votre temps et combien vous donnez à votre Deen.';

  @override
  String get digitalBalanceEnableUsage => 'Activer l\'usage des applis';

  @override
  String get digitalBalanceMaybeLater => 'Plus tard';

  @override
  String get digitalBalanceUnavailableTitle =>
      'L\'usage des applis n\'est pas disponible ici';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple ne partage pas Temps d\'écran avec les autres applis, donc Digital Balance ne peut pas encore afficher l\'usage iPhone. Vos prières, séries et insights fonctionnent toujours.';

  @override
  String get digitalBalanceInfoTitle => 'À propos de l\'équilibre numérique';

  @override
  String get digitalBalanceInfoBody =>
      'L\'équilibre numérique vous aide à voir où va votre temps et combien vous donnez à votre Deen. L\'usage reste sur votre appareil.';

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
    return 'DeenFocus · $percent% du temps téléphone';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% de votre temps téléphone';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% du temps téléphone d\'aujourd\'hui';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% de temps DeenFocus en plus que la semaine dernière';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'Vous avez passé $duration dans DeenFocus aujourd\'hui. Continuez.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'Votre temps DeenFocus a augmenté de $percent% par rapport à hier.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / jour';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return 'Encore $minutes minutes pour atteindre l\'objectif du jour';
  }
}
