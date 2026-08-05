// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'Fede. Messa a fuoco. Coerenza';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline =>
      'Modalità di preghiera. Modalità bambino. Modalità di sospensione.';

  @override
  String get welcomeDescription =>
      'Tieni traccia delle tue preghiere, leggi il Corano, conta Tasbih e crea serie significative, tutto in un unico posto.';

  @override
  String get skip => 'Saltare';

  @override
  String get notNow => 'Non ora';

  @override
  String get continueButton => 'Continuare';

  @override
  String get continueForFree => 'Continua con il piano gratuito';

  @override
  String get getStarted => 'Sblocca Premium';

  @override
  String get language => 'Lingua';

  @override
  String get cancel => 'Cancellare';

  @override
  String get ok => 'OK';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get locationRequired => 'Posizione richiesta';

  @override
  String get locationRequiredMessage =>
      'È necessario l\'accesso alla posizione per calcolare tempi di preghiera accurati e la direzione della Qibla. È necessario abilitarlo per utilizzare l\'app.';

  @override
  String get notificationsRequired => 'Notifiche obbligatorie';

  @override
  String get notificationsRequiredMessage =>
      'Le notifiche sono necessarie per ricevere avvisi e promemoria sui tempi di preghiera.';

  @override
  String get sectTitle => 'Scegli la tua setta';

  @override
  String get sectSubtitle =>
      'Questo ci aiuta a personalizzare la tua esperienza';

  @override
  String get sectSunni => 'Sunnita';

  @override
  String get sectShia => 'Sciita';

  @override
  String get sectPreferNotToSay => 'Preferisco non dirlo';

  @override
  String get nameTitle => 'Come ti chiami?';

  @override
  String get nameSubtitle => 'Personalizziamo il tuo saluto';

  @override
  String get namePlaceholder => 'Il tuo nome';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => 'Consenti accesso alla posizione';

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
  String get notificationsButton => 'Abilita notifiche';

  @override
  String get notificationsEnabled => 'Le notifiche sono abilitate';

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
  String get screenTimeTitle => 'Attiva Tempo di utilizzo';

  @override
  String get screenTimeSubtitle =>
      'Questo consente a Deen Focus di mettere in pausa le app che distraggono durante Salah, il sonno e la modalità bambino.';

  @override
  String get screenTimeButton => 'Consenti accesso a Tempo di utilizzo';

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
  String get focusPrayerModeTitle => 'Modalità di preghiera';

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
  String get focusSleepModeTitle => 'Modalità di sospensione';

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
  String get focusChildModeTitle => 'Modalità bambino';

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
  String get investTitle => 'Investi nel tuo Deen';

  @override
  String get investSubtitle =>
      'Non ci pensi due volte a spendere in caffè o snack...';

  @override
  String get investComparisonTitle =>
      'Vai Premium o continua con il piano gratuito';

  @override
  String get investDailyCoffee => 'Caffè quotidiano';

  @override
  String get investDailyCoffeePrice => '\$ 5 al giorno';

  @override
  String get investFastFood => 'Fast food';

  @override
  String get investFastFoodPrice => '\$ 10/pasto';

  @override
  String get investYourDeen => 'Il tuo Deen';

  @override
  String get investYourDeenPrice => '\$ 4,99/mese';

  @override
  String get investComparisonQuote =>
      'Spendi \$ 10 in piccole cose senza pensare: perché non investire nel tuo Deen?';

  @override
  String get bestValueTag => 'MIGLIOR VALORE';

  @override
  String get mostPopularChoice => 'La scelta più popolare';

  @override
  String get monthlyPriceValue => '\$ 4,99';

  @override
  String get monthlyPriceSuffix => '/mese';

  @override
  String get monthlyPlanSubtitle =>
      'Fatturazione mensile • Annulla in qualsiasi momento';

  @override
  String get yearlyPriceValue => '\$ 24,99';

  @override
  String get yearlyPriceSuffix => '/anno';

  @override
  String get yearlyPlanSubtitle => 'Risparmia il 50% • Fatturato annualmente';

  @override
  String get lifetimePriceValue => '\$ 79,99';

  @override
  String get lifetimePriceSuffix => 'tutta la vita';

  @override
  String get lifetimePlanSubtitle => 'Acquisto una tantum • Accesso per sempre';

  @override
  String get everythingYouGet => 'Tutto quello che ottieni';

  @override
  String get featureFocusModeAllModes =>
      'Modalità di messa a fuoco illimitata con tutte e 3 le modalità';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'Analisi e serie di preghiere avanzate';

  @override
  String get featureAiAssistant => 'Assistente islamico dell\'AI';

  @override
  String get featurePrioritySupportEarlyAccess =>
      'Supporto prioritario e accesso anticipato';

  @override
  String get socialProofPrefix => 'Giuntura';

  @override
  String get socialProofHighlight => '10.000+';

  @override
  String get socialProofSuffix =>
      'I musulmani stanno già crescendo con Deen Focus';

  @override
  String get mostPopular => 'Il più popolare';

  @override
  String get monthlyLabel => 'Mensile';

  @override
  String get monthlyPrice =>
      '\$ 4,99/mese · fatturazione mensile · annullamento in qualsiasi momento';

  @override
  String get yearlyLabel => 'Annuale';

  @override
  String get yearlyPrice =>
      '\$ 24,99/anno · risparmia il 50% · fatturazione annuale';

  @override
  String get lifetimeLabel => 'Tutta la vita';

  @override
  String get lifetimePrice =>
      '\$ 79,99 a vita · acquisto una tantum · accesso per sempre';

  @override
  String get featurePrayerAnalytics => 'Analisi avanzata della preghiera';

  @override
  String get featureFocusMode => 'Modalità di messa a fuoco illimitata';

  @override
  String get featureMasjidMode => 'Modalità automatica Masjid';

  @override
  String get featureNoAds => 'Rimuove tutti gli annunci';

  @override
  String get featureSupport => 'Supporto prioritario';

  @override
  String get homeTitle => 'Deenly Home';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback =>
      'In effetti, con le difficoltà arriva la facilità.';

  @override
  String get homeAppsLocked => 'App bloccate';

  @override
  String get homeAppsUnlocked => 'App sbloccate';

  @override
  String get homeTapToUnlock => 'Tocca per sbloccare temporaneamente le app';

  @override
  String get homeTapToRelock =>
      'Tocca per bloccare nuovamente le app bloccate adesso';

  @override
  String get homeRelock => 'Richiudere';

  @override
  String get homeUnlock => 'Sbloccare';

  @override
  String get homePrayerModeActive => 'Modalità Preghiera attiva';

  @override
  String get homeActivatePrayerMode => 'Attiva la modalità preghiera';

  @override
  String get homeAppsBlockedSubtitle =>
      'Le app sono bloccate. Tocca per disattivare.';

  @override
  String get homeBlockDistractingApps =>
      'Blocca le app che distraggono durante Salah.';

  @override
  String get homeQiblaDirection => 'Direzione Qibla';

  @override
  String get homeLocationMissingForQibla =>
      'Abilita la posizione per calcolare la direzione di Qibla.';

  @override
  String get homeQiblaSubtitleGuiding => 'Guidandoti verso la Qibla';

  @override
  String get homeToMakkah => 'alla Mecca';

  @override
  String get homeFindMasjid => 'Trova Moschea vicino a me';

  @override
  String get quickActionsMasjidFinder => 'Trova moschea';

  @override
  String get homeSearchNearbyMosques => 'Cerca moschee vicine.';

  @override
  String get homePrayerStreak => 'Strisce di preghiera';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Statistiche';

  @override
  String get homeOpenStreakDetails => 'Dettagli della serie aperta.';

  @override
  String get homeTodaysPrayers => 'Le preghiere di oggi';

  @override
  String get homePrayerTimesUnavailable =>
      'Gli orari di preghiera non sono disponibili al momento.';

  @override
  String get homeNextPrayerIn => 'Prossima preghiera';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Alba';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Maghreb';

  @override
  String get homePrayerIsha => 'Isha';

  @override
  String get homeWeek => 'Settimana';

  @override
  String get homeMonth => 'Mese';

  @override
  String get homeThisWeek => 'Punti salienti di Deen questa settimana';

  @override
  String get homeJummahMubarak => 'Jummah Mubarak';

  @override
  String get homeJummahReminder => 'Non dimenticare la Sura Al-Kahf.';

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
      'Durante questo periodo la tua serie è protetta. I giorni del ciclo sono evidenziati in rosa e la Modalità ciclo si disattiva automaticamente al termine del ciclo.';

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
  String get cycleModeSettingsTitle => 'Modalità ciclo';

  @override
  String get cycleModeStartDateLabel => 'Data di inizio';

  @override
  String get cycleModeLengthLabel => 'Durata del ciclo';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Metti in pausa le serie';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'Escludi dalle statistiche';

  @override
  String get cycleModeSaveButton => 'Salva';

  @override
  String get cycleModeEditButton => 'Modifica';

  @override
  String get cycleModeChangeStartDateTitle => 'Cambiare la data di inizio?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Modificare la data di inizio ricalcolerà la finestra attiva della Modalità ciclo. I giorni fuori dal nuovo intervallo potrebbero non essere più trattati come giorni del ciclo.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Cambia data di inizio';

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
  String get dailyChecklistSectionPrayer => 'Preghiera';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Corano e Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Buone azioni';

  @override
  String get dailyChecklistSectionDistraction => 'Controllo delle distrazioni';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar della sera';

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
  String get focusScoreTitle => 'Punteggio focus di oggi';

  @override
  String get focusScorePrayer => 'Preghiera';

  @override
  String get focusScoreQuran => 'Corano';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Controllo delle distrazioni';

  @override
  String get insightsBack => 'Indietro';

  @override
  String get insightsTitle => 'Le mie statistiche';

  @override
  String get insightsSubtitle => 'Monitora i progressi del tuo Deen';

  @override
  String get insightsPrayerRate => 'Tasso di preghiera';

  @override
  String get insightsDayStreak => 'Serie di giorni';

  @override
  String get insightsBestStreak => 'Migliore serie';

  @override
  String get insightsWeekly => 'Settimanale';

  @override
  String get insightsMonthly => 'Mensile';

  @override
  String get insightsPrayersCompleted => 'Preghiere completate';

  @override
  String get insightsRestoreStreak => 'Ripristina la mia serie — ultime 24 ore';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Preghiera $prayerPercent% · Corano $quranPercent% · Dhikr $dhikrPercent% · Distrazione $distractionPercent%';
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
      'Chiedi qualsiasi cosa sui tempi di preghiera, sul Corano e sulla guida islamica.';

  @override
  String get homeDay => 'Giorno';

  @override
  String get homeDays => 'Giorni';

  @override
  String get homeNoEventsFoundForDay =>
      'Nessun evento trovato per questo giorno.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — segna come';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Pregata in orario';

  @override
  String get homeMarkPrayerQada => 'Qada (recuperata)';

  @override
  String get homeMarkPrayerMissed => 'Mancata';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return 'Impostazioni di $prayerName';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Orario della preghiera';

  @override
  String get homePrayerSettingsNotification => 'Notifica';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Virtù, norme e altro';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Queste impostazioni valgono solo per $prayerName. Puoi impostare preferenze diverse per ogni preghiera.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'Modifica orario di $prayerName';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Orario attuale';

  @override
  String get homeEditPrayerTimeSelectNew => 'Seleziona un nuovo orario';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Questo orario personalizzato si applica solo a $prayerName. Regolalo se la moschea locale o il calcolo differiscono.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Salva orario';

  @override
  String get homeEditPrayerTimeReset => 'Ripristina l\'orario calcolato';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Notifica per $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Suono della notifica';

  @override
  String get homeNotificationSoundFullAdhan => 'Adhan completo';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Riproduci l\'Adhan completo';

  @override
  String get homeNotificationSoundBeep => 'Segnale acustico';

  @override
  String get homeNotificationSoundBeepSubtitle => 'Un breve tono di notifica';

  @override
  String get homeNotificationSoundMute => 'Silenzioso';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Nessun suono';

  @override
  String get homeNotificationEnableLabel => 'Attiva notifica';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Ricevi un avviso all\'orario di $prayerName';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'Informazioni su $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Orario';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakat';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Virtù';

  @override
  String get homeAboutPrayerReferenceLabel => 'Riferimento';

  @override
  String get homeAboutFajrTiming =>
      'Inizia all\'alba vera (Fajr Sadiq) e termina all\'alba del sole.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Chi prega il Fajr è sotto la protezione di Allah.';

  @override
  String get homeAboutFajrReference =>
      '«Le due rakʿāt del Fajr sono migliori del mondo e di tutto ciò che contiene.» (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Inizia quando il sole supera lo zenit e dura fino all\'inizio dell\'Asr.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Parte delle 12 rakʿāt volontarie giornaliere per cui Allah costruisce una casa in Paradiso.';

  @override
  String get homeAboutDhuhrReference =>
      '«Chi prega dodici rakʿāt in un giorno e una notte avrà una casa costruita per lui in Paradiso.» (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Inizia quando l\'ombra di un oggetto eguaglia la sua lunghezza e dura fino al tramonto.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Custodire questa preghiera è particolarmente premiato e ammonito.';

  @override
  String get homeAboutAsrReference =>
      '«Chi perde la preghiera dell\'Asr è come se avesse perso la famiglia e i beni.» (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Inizia subito dopo il tramonto e dura fino alla scomparsa del crepuscolo rosso.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Un momento in cui le invocazioni sono particolarmente incoraggiate.';

  @override
  String get homeAboutMaghribReference =>
      '«Ci sono due occasioni in cui digiunante gioisce… quando rompe il digiuno.» (Sahih al-Bukhari, sull\'iftar del Maghrib)';

  @override
  String get homeAboutIshaTiming =>
      'Inizia quando il crepuscolo scompare del tutto e dura fino a mezzanotte (o fino al Fajr, secondo alcune opinioni).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Pregare Isha in congregazione equivale a stare in piedi mezza notte in preghiera.';

  @override
  String get homeAboutIshaReference =>
      '«Chi prega Isha in congregazione è come se avesse pregato mezza notte.» (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Torniamo all\'onboarding';

  @override
  String get settings => 'Impostazioni';

  @override
  String get appLanguage => 'Lingua dell\'app';

  @override
  String get tabHome => 'Casa';

  @override
  String get tabFocus => 'Messa a fuoco';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Corano';

  @override
  String get tabLearn => 'Impara';

  @override
  String get quranLoadFailed => 'Impossibile caricare i dati del Corano';

  @override
  String get quranTabSubtitle => 'Leggere ed esplorare il Sacro Corano';

  @override
  String get quranSearchHint => 'Cerca sura...';

  @override
  String get quranNoSurahsFound => 'Nessuna Sura trovata';

  @override
  String get quranVersesLabel => 'versi';

  @override
  String get quranTextOptions => 'Opzioni di testo';

  @override
  String get quranEnglishAndArabic => 'Inglese e arabo';

  @override
  String get quranArabicOnly => 'Solo arabo';

  @override
  String get quranIncreaseFont => 'Aumenta il carattere';

  @override
  String get quranDecreaseFont => 'Diminuisci carattere';

  @override
  String get quranPause => 'Pausa';

  @override
  String get quranPlaySurah => 'Gioca a Sura';

  @override
  String get quranAudioNoInternet =>
      'Nessuna connessione internet. L\'audio richiede internet.';

  @override
  String get quranAudioTimeout =>
      'Timeout caricamento audio. Controlla la connessione.';

  @override
  String get quranSurahLabel => 'Sura';

  @override
  String get save => 'Salva';

  @override
  String get tasbihBack => 'Indietro';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle => 'Seleziona un dhikr o creane uno tuo';

  @override
  String get tasbihAddCustomTitle => 'Aggiungi Dhikr';

  @override
  String get tasbihEditCustomTitle => 'Modifica Dhikr personalizzato';

  @override
  String get tasbihArabicOrDhikrHint => 'Testo arabo o qualsiasi dhikr';

  @override
  String get tasbihTransliterationOptionalHint =>
      'Traslitterazione (facoltativa)';

  @override
  String get tasbihMeaningOptionalHint => 'Significato (facoltativo)';

  @override
  String get tasbihNoTransliteration => 'Nessuna traslitterazione';

  @override
  String get tasbihTotalCount => 'Conteggio totale';

  @override
  String get tasbihGrandTotalLabel => 'Totale tasbih';

  @override
  String get tasbihTapMe => 'Toccami';

  @override
  String get tasbihReset => 'Reset';

  @override
  String get tasbihRestart => 'Ricomincia';

  @override
  String get tasbihCurrentCount => 'Conteggio attuale';

  @override
  String get tasbihResetTotal => 'Cancella cronologia';

  @override
  String get focusModeActivated => 'Modalità di messa a fuoco attivata';

  @override
  String get focusSetUpHomeCardTitle => 'Imposta la modalità Focus';

  @override
  String get focusTabSubtitle => 'Rimani concentrato quando conta di più';

  @override
  String get focusChooseAppsEnableMode =>
      'Scegli le app e attiva la modalità Focus';

  @override
  String get focusNotifAppsLockedTitle => 'App bloccate';

  @override
  String get focusNotifAppsUnlockedTitle => 'App sbloccate';

  @override
  String get focusNotifNightModeTitle => 'Modalità notte';

  @override
  String get focusNotifGoodMorningTitle => 'Buongiorno!';

  @override
  String get focusNotifAppsNowAvailableBody => 'Le app sono ora disponibili.';

  @override
  String get focusNotifSalahLockedBody =>
      'Le app sono bloccate durante la Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah completata';

  @override
  String get focusNotifSalahCompleteBody =>
      'Le app sono ora sbloccate. Che la tua preghiera sia accolta.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return 'Ora di $prayerName';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Prenditi un momento per la preghiera di $prayerName.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'La modalità notte è attiva. Concedi riposo a mente e corpo.';

  @override
  String get focusNotifGenericLockedBody => 'Le app selezionate sono bloccate.';

  @override
  String get focusNotifMorningUnlockBody => 'Le app non sono disponibili.';

  @override
  String get widgetDailyVerseTitle => 'Versetto del giorno';

  @override
  String get widgetOpenAppTimelineHint =>
      'Apri Deen Focus per preparare il versetto del giorno e i dati del widget delle preghiere.';

  @override
  String get widgetSetLocationForPrayers =>
      'Imposta la posizione in Deen Focus per caricare preghiere e versetto del giorno.';

  @override
  String get focusChildModeActive => 'Modalità bambino attiva';

  @override
  String get focusSalahAndNightModeActive => 'Salah e modalità notturna attive';

  @override
  String get focusSalahModeActive => 'Modalità Salah attiva';

  @override
  String get focusNightModeActive => 'Modalità notturna attiva';

  @override
  String get focusAppsToBlockTitle => 'App da bloccare';

  @override
  String get focusAppliesAllModes =>
      'Si applica a tutte le modalità di messa a fuoco';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Per visualizzare e selezionare le app è necessario l\'accesso al Tempo di utilizzo.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Accetta l\'informativa sull\'accessibilità per continuare.';

  @override
  String get focusSelectAppsToBlock => 'Seleziona le app da bloccare';

  @override
  String get focusLoading => 'Caricamento...';

  @override
  String get focusOpen => 'Aprire';

  @override
  String get focusHide => 'Nascondere';

  @override
  String get focusLoad => 'Carico';

  @override
  String get focusShow => 'Spettacolo';

  @override
  String get focusSalahFocusModeTitle => 'Modalità di messa a fuoco Salah';

  @override
  String get focusBlockAppsDuringPrayer => 'Blocca le app durante la preghiera';

  @override
  String get focusNightDisciplineTitle => 'Disciplina notturna';

  @override
  String get focusSleepLabel => 'Sonno';

  @override
  String get focusWakeLabel => 'Veglia';

  @override
  String get focusBlockAppsImmediately => 'Blocca immediatamente le app';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Abilita il blocco delle app Android';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Per bloccare altre app su Android, Deenly necessita dell\'attivazione dell\'autorizzazione di accessibilità. Apriremo la schermata delle impostazioni corrette per te.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Divulgazione dei permessi di accessibilità';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Utilizza in modo approfondito l\'accessibilità Android per applicare il blocco delle app in modalità Focus.\n\nPerché ne abbiamo bisogno: per rilevare quando apri un\'app che hai selezionato per il blocco.\n\nCome lo utilizziamo: solo per identificare l\'app in primo piano e mostrare la schermata del blocco Focus per le app selezionate. Non lo usiamo per leggere testo digitato o contenuti personali.';

  @override
  String get focusNotNow => 'Non adesso';

  @override
  String get focusIUnderstand => 'Capisco';

  @override
  String get focusDone => 'Fatto';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Costruisci migliori abitudini notturne';

  @override
  String get focusPrayerBlockingDescription =>
      'Le app verranno bloccate durante la preghiera e si sbloccheranno automaticamente dopo 15 minuti, oppure potrai sbloccarle in qualsiasi momento dalla schermata principale.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Le app verranno bloccate durante la preghiera, oppure potrai sbloccarle in qualsiasi momento dalla schermata principale.';

  @override
  String get focusNightBlockingDescription =>
      'Le app verranno bloccate durante il ciclo di sonno e si sbloccheranno automaticamente oppure potrai sbloccarle in qualsiasi momento dalla schermata principale';

  @override
  String get focusChildBlockingDescription =>
      'Le app vengono bloccate immediatamente in modalità bambino. Sbloccali utilizzando l\'interruttore o dalla schermata principale';

  @override
  String get settingsEditUsername => 'Modifica nome utente';

  @override
  String get settingsEnterYourName => 'Inserisci il tuo nome';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Sblocca tutte le funzionalità';

  @override
  String get settingsManageSubscriptionTitle => 'Gestisci abbonamento';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Vedi piano o aggiorna fatturazione';

  @override
  String get settingsUsernameLabel => 'Nome utente';

  @override
  String get settingsLocationLabel => 'Posizione';

  @override
  String get settingsDarkModeLabel => 'Modalità oscura';

  @override
  String get settingsAboutTitle => 'A proposito di Deen Focus';

  @override
  String get settingsContactUsTitle => 'Contattaci';

  @override
  String get settingsSavingLocation => 'Risparmio...';

  @override
  String get settingsSaveLocation => 'Salva posizione';

  @override
  String get settingsAboutTagline => 'Messa a fuoco. Disciplina. Coerenza.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus ti aiuta a rimanere connesso alla tua fede mentre gestisci le distrazioni quotidiane in un mondo moderno.';

  @override
  String get settingsAboutFeature1 => 'Orari di preghiera con promemoria';

  @override
  String get settingsAboutFeature2 =>
      'Direzione della Qibla in qualsiasi momento';

  @override
  String get settingsAboutFeature3 => 'Corano e Tasbih per il dhikr quotidiano';

  @override
  String get settingsAboutFeature4 => 'Moschee vicine';

  @override
  String get settingsAboutFeature5 =>
      'Modalità di concentrazione intelligenti per Salah, sonno e tempo in famiglia';

  @override
  String get settingsAboutFocusDescription =>
      'Le modalità di concentrazione intelligenti ti aiutano a bloccare le distrazioni durante Salah, il sonno e i momenti importanti, in modo da poterti rimanere presente e disciplinato.';

  @override
  String get settingsAboutFooter =>
      'Rimani costante. Rimani consapevole.\nRimani connesso al tuo Deen.';

  @override
  String get settingsEnableSystemNotifications =>
      'Abilita le notifiche di sistema per attivarlo.';

  @override
  String get appDemoTitle => 'Demo dell\'applicazione';

  @override
  String get appDemoLoadFailed => 'Impossibile caricare il video dimostrativo.';

  @override
  String get appDemoRestartHint =>
      'Il video richiede il riavvio completo dell\'app (il riavvio a caldo può interrompere la riproduzione).';

  @override
  String get appDemoPreviewLoadFailed => 'Impossibile caricare la demo.';

  @override
  String get appDemoTryAgain => 'Riprova';

  @override
  String get appDemoWatchLabel => 'Guarda la dimostrazione';

  @override
  String get homeAiChatTitle => 'Deen Focus AI';

  @override
  String get homeAiAskQuestionHint => 'Fai una domanda...';

  @override
  String get homeAiSend => 'Inviare';

  @override
  String get homeAiErrorPrefix =>
      'Mi dispiace, ho riscontrato un problema durante la connessione a Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Chiedi qualsiasi cosa sull\'Islam';

  @override
  String get homeAiEmptySubtitle =>
      'Tempi di preghiera, Corano, Hadith, eventi islamici e guida spirituale';

  @override
  String get onboardingTypeCityName => 'Digita il nome della tua città..';

  @override
  String get onboardingNoLocationsFound => 'Nessuna posizione trovata';

  @override
  String get onboardingTryAnotherCityName => 'Prova un altro nome di città.';

  @override
  String get qiblaCompassUnavailable =>
      'Bussola non disponibile su questo dispositivo';

  @override
  String get qiblaFacing => '✓ Di fronte a Qibla';

  @override
  String get qiblaTurnToFind => 'Girati per trovare Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Distanza dalla Mecca';

  @override
  String get qiblaFromNorth => 'da Nord';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Moschee vicine';

  @override
  String get nearbyMosquesTryAgain => 'Riprova';

  @override
  String get nearbyMosquesOpenGoogle => 'Apri in Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Apri in Mappe di Apple';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'Nessuna moschea trovata all\'interno';

  @override
  String get nearbyMosquesSearchRadius => 'Raggio di ricerca: 5 km';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Anteprima della mappa non disponibile al momento.';

  @override
  String get nearbyMosquesWaitingForLocation =>
      'In attesa della tua posizione.';

  @override
  String get nearbyMosquesFetchingLocation => 'Recupero della posizione…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Posizione attuale';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Le moschee vicine appariranno qui una volta caricati i risultati.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'Nessuna moschea trovata nel raggio di 5 km';

  @override
  String get nearbyMosquesLocationRequired =>
      'Per trovare le moschee vicine è necessario l\'accesso alla posizione.';

  @override
  String get nearbyMosquesPermissionOff =>
      'L\'autorizzazione alla posizione è disattivata. Abilitalo nelle impostazioni per vedere le moschee vicine.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'Non è stato possibile leggere la tua posizione attuale in questo momento.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'L\'aggiornamento in tempo reale non è riuscito. Visualizzazione degli ultimi risultati salvati. Tirare per rinfrescare.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'L\'accesso alla posizione è stato negato. Abilitalo nelle Impostazioni per vedere le moschee vicine.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'La posizione è disattivata su questo dispositivo. Attivalo in Impostazioni, quindi riprova.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'L\'autorizzazione alla posizione è ancora in fase di elaborazione. Per favore riprova tra poco.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'La richiesta ha richiesto troppo tempo. Controlla la connessione Internet e riprova.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Nessuna connessione Internet o il servizio non è raggiungibile. Controlla la connessione e riprova.';

  @override
  String get nearbyMosquesFormatError =>
      'Non siamo riusciti a leggere l\'elenco delle moschee in questo momento. Per favore riprova più tardi.';

  @override
  String get nearbyMosquesPlatformError =>
      'Non è stato possibile completare questo passaggio. Controlla la connessione e riprova.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Qualcosa è andato storto. Per favore riprova.';

  @override
  String get nearbyMosquesEmptyHint =>
      'Non è elencato nulla nel raggio di 5 km su OpenStreetMap per questo luogo. Riprova più tardi o sposta la mappa.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count moschee trovate nel raggio di 5 km';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Eliminare dhikr?';

  @override
  String get tasbihDelete => 'Eliminare';

  @override
  String get focusAndroidBlockingNotReady =>
      'Il blocco app su Android non è ancora pronto. Tieni l’accessibilità attiva e attendi un attimo la connessione.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Nessuna app selezionata. Scegli prima le app da bloccare.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Per bloccare le app su iPhone serve l’accesso al Tempo di utilizzo.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Si è verificato un errore aggiornando la modalità Focus. Riprova.';

  @override
  String get focusLoadingInstalledApps => 'Caricamento app installate...';

  @override
  String get focusNoInstalledAppsToShow =>
      'Nessuna app installata da mostrare.';

  @override
  String get homeAiSuggestion1 => 'Cos’è il Ramadan?';

  @override
  String get homeAiSuggestion2 => 'Orari delle preghiere';

  @override
  String get homeAiSuggestion3 => 'Piano di lettura del Corano';

  @override
  String get homeAiDeveloperPrompt =>
      'Sei un assistente islamico colto e rispettoso. Aiuta gli utenti a conoscere tradizioni islamiche, festività, preghiera, studio del Corano e pratiche spirituali. Sii caloroso, conciso, educativo e culturalmente sensibile. Se la domanda esce dall’ambito religioso, rispondi in modo utile senza fingere certezze.';

  @override
  String get homeAiErrorMissingApiKey => 'Configurazione API mancante.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'Errore API $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Nessuna risposta dall’assistente.';

  @override
  String get homeAiErrorEmptyContent => 'Contenuto della risposta vuoto.';

  @override
  String get settingsPrayerCalculationSection => 'Calcolo Preghiera';

  @override
  String get settingsCalculationMethodTitle => 'Metodo di Calcolo';

  @override
  String get settingsAsrCalculationTitle => 'Calcolo Asr';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Principali Organizzazioni Islamiche';

  @override
  String get calculationMethodSectionMiddleEast => 'Medio Oriente';

  @override
  String get calculationMethodSectionAsiaPacific => 'Asia Pacifico';

  @override
  String get calculationMethodSectionSpecial => 'Metodi Speciali';

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
