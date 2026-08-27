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
  String get continueForFree => 'Forse più tardi — esplora prima l\'app';

  @override
  String get getStarted => 'Inizia la mia prova gratuita di 7 giorni';

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
  String get locationTitle => 'Trova la tua Qibla';

  @override
  String get locationSubtitle =>
      'Attiva la posizione per Qibla, orari di preghiera e moschee vicine accurate.';

  @override
  String get locationButton => 'Consenti accesso alla posizione';

  @override
  String get locationManualEntry => 'Inserisci la tua città manualmente';

  @override
  String get locationOrDivider => 'o';

  @override
  String get locationPrivacyNote => 'Resta sul tuo dispositivo';

  @override
  String get locationFeaturePrayerTimesTitle => 'Orari di preghiera';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Moschee';

  @override
  String get notificationsTitle => 'Non perdere nessuna preghiera';

  @override
  String get notificationsSubtitle =>
      'Avvisi adhan, promemoria focus e dhikr quotidiano — proprio quando ti servono.';

  @override
  String get notificationsButton => 'Abilita notifiche';

  @override
  String get notificationsMaybeLater => 'Forse più tardi';

  @override
  String get notificationsEnabled => 'Le notifiche sono abilitate';

  @override
  String get notificationsPreviewDate => 'Venerdì 10 luglio';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'ora';

  @override
  String get notificationsPreviewMinutesAgo => '2 min fa';

  @override
  String get notificationsPreviewHourAgo => '1 ora fa';

  @override
  String get notificationsPreviewAdhanTitle => 'Adhan del Maghrib';

  @override
  String get notificationsPreviewAdhanBody => 'È tempo di pregare.';

  @override
  String get notificationsPreviewDhikrTitle => 'Dhikr quotidiano';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — prenditi un momento.';

  @override
  String get notificationsPreviewStreakTitle => 'Serie';

  @override
  String get notificationsPreviewStreakBody =>
      '7 giorni di preghiere complete.';

  @override
  String get screenTimeTitle => 'Attiva Tempo di utilizzo';

  @override
  String get screenTimeSubtitle =>
      'Questo consente a Deen Focus di mettere in pausa le app che distraggono durante Salah, il sonno e la modalità bambino.';

  @override
  String get screenTimeButton => 'Consenti accesso a Tempo di utilizzo';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus non legge mai i tuoi dati — mette in pausa solo le app che scegli.';

  @override
  String get onboardingSelectAppsTitlePrefix => 'Seleziona';

  @override
  String get onboardingSelectAppsTitleAccent => 'app da bloccare';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Seleziona le app da bloccare quando è ora di pregare.';

  @override
  String get onboardingSelectAppsButton => 'Seleziona app';

  @override
  String get onboardingSelectAppsSkipForNow => 'Salta per ora';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'Sei tu al comando';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'Non leggiamo mai i tuoi dati. Blocchiamo solo le app che scegli.';

  @override
  String get onboardingSelectAppsMockAllApps => 'Tutte le app e categorie';

  @override
  String get onboardingSelectAppsMockPhotos => 'Foto';

  @override
  String get onboardingSelectAppsMockNotes => 'Note';

  @override
  String get onboardingSelectAppsMockMusic => 'Musica';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => 'Podcast';

  @override
  String screenTimeStepOf(int current, int total) {
    return 'PASSAGGIO $current DI $total';
  }

  @override
  String get screenTimeStep1Title => 'Apri la richiesta di Tempo di utilizzo';

  @override
  String get screenTimeStep1Body =>
      'Tocca «Consenti accesso a Tempo di utilizzo» — il dispositivo mostrerà la propria richiesta di autorizzazione.';

  @override
  String get screenTimeStep2Title => 'Tocca Continua, poi Consenti';

  @override
  String get screenTimeStep2Body =>
      'Approva la richiesta così Deen Focus può mettere in pausa le app al momento giusto.';

  @override
  String get screenTimeStep3Title => 'Scegli le app da bloccare';

  @override
  String get screenTimeStep3Body =>
      'Scegli le app che ti distraggono di più — social, giochi, video, qualsiasi cosa.';

  @override
  String get screenTimeStep4Title => 'Sei protetto';

  @override
  String get screenTimeStep4Body =>
      'Le app si bloccano automaticamente durante Salah, il sonno e la modalità bambino.';

  @override
  String get screenTimePromptTitle => 'Tempo di utilizzo';

  @override
  String screenTimePromptMessage(String appName) {
    return '«$appName» vorrebbe accedere a Tempo di utilizzo';
  }

  @override
  String get screenTimeDontAllow => 'Non consentire';

  @override
  String get screenTimePromptContinue => 'Continua';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Giochi';

  @override
  String get screenTimeAndroidStep1Title => 'Apri Accesso utilizzo';

  @override
  String get screenTimeAndroidStep1Body =>
      'Tocca «Consenti accesso a Tempo di utilizzo» — il dispositivo aprirà Accesso utilizzo per Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Attiva Accessibilità';

  @override
  String get screenTimeAndroidStep2Body =>
      'Attiva il servizio Deen Focus per mettere in pausa le app durante Salah, sonno e modalità bambino.';

  @override
  String get screenTimeAndroidStep3Title => 'Scegli le app da bloccare';

  @override
  String get screenTimeAndroidStep3Body =>
      'Scegli le app che ti distraggono di più — social, giochi, video, qualsiasi cosa.';

  @override
  String get screenTimeAndroidStep4Title => 'Sei protetto';

  @override
  String get screenTimeAndroidStep4Body =>
      'Le app si bloccano automaticamente durante Salah, il sonno e la modalità bambino.';

  @override
  String get screenTimeAndroidUsageTitle => 'Accesso utilizzo';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Consenti a Deen Focus di rilevare quali altre app vengono usate.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Accessibilità';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus necessita dell\'Accessibilità per mettere in pausa le app che distraggono durante le sessioni di focus.';

  @override
  String get screenTimeAndroidPermit => 'Consenti';

  @override
  String get screenTimeAndroidEnable => 'Attiva';

  @override
  String get screenTimeAndroidNotNow => 'Non ora';

  @override
  String get focusModesTitle => 'Tutto in un\'unica app';

  @override
  String get focusModesSubtitle =>
      'Scopri tutto ciò che offre Deen Focus. Tocca una modalità focus per vedere come funziona.';

  @override
  String get onboardingWidgetsLiveTitle =>
      'Le tue preghiere, sempre a portata di mano';

  @override
  String get onboardingWidgetsLiveSubtitle =>
      'Resta connesso a ciò che conta di più — dalla Home o dalla Lock Screen.';

  @override
  String get onboardingWidgetsSectionTitle => 'Widget';

  @override
  String get onboardingWidgetsSectionBodyPrefix =>
      'Controlla la prossima preghiera, le serie e i progressi ';

  @override
  String get onboardingWidgetsSectionBodyEmphasis => 'a colpo d’occhio.';

  @override
  String get onboardingLiveActivitiesSectionTitle => 'Live Activity';

  @override
  String get onboardingLiveActivitiesSectionBodyPrefix =>
      'Vedi gli aggiornamenti della prossima preghiera in ';

  @override
  String get onboardingLiveActivitiesSectionBodyEmphasis => 'tempo reale';

  @override
  String get onboardingLiveActivitiesSectionBodySuffix =>
      ' su Lock Screen e Dynamic Island.';

  @override
  String get onboardingWidgetsLiveTrustPrefix =>
      'Pensato per aiutarti a restare ';

  @override
  String get onboardingWidgetsLiveTrustEmphasis => 'costante';

  @override
  String get onboardingWidgetsLiveTrustSuffix =>
      ' e a non perdere ciò che conta di più.';

  @override
  String get onboardingWidgetsMockStreak => 'Serie';

  @override
  String get onboardingWidgetsMockStreakValue => '12 giorni';

  @override
  String get onboardingWidgetsMockFocus => 'Focus';

  @override
  String get onboardingWidgetsMockFocusValue => '25 min';

  @override
  String get onboardingWidgetsLiveLockDate => 'Martedì 6 maggio';

  @override
  String get onboardingWidgetsLiveLockTime => '9:41';

  @override
  String get onboardingWidgetsLiveNextPrayer => 'Dhuhr 12:45, tra 02:15:32';

  @override
  String get focusModesSectionLabel =>
      'MODALITÀ FOCUS · TOCCA PER SAPERNE DI PIÙ';

  @override
  String get focusPrayerTrackingSectionLabel => 'PREGHIERA E MONITORAGGIO';

  @override
  String get focusLearningHubSectionLabel => 'HUB DI APPRENDIMENTO';

  @override
  String get focusMoreSectionLabel => 'ALTRO';

  @override
  String get focusPrayerModeTitle => 'Modalità di preghiera';

  @override
  String get focusPrayerModeDescription =>
      'Blocca automaticamente le app che distraggono durante la Salah per pregare con pieno khushu.';

  @override
  String get focusPrayerModeBullet1 => 'Blocca le app all\'ora della preghiera';

  @override
  String get focusPrayerModeBullet2 => 'Si sblocca quando hai finito';

  @override
  String get focusPrayerModeBullet3 => 'Costruisce focus e costanza';

  @override
  String get focusSleepModeTitle => 'Modalità di sospensione';

  @override
  String get focusSleepModeDescription =>
      'Rilassati in modo halal. Blocca le app a ora di nanna per riposare bene e svegliarti per il Fajr.';

  @override
  String get focusSleepModeBullet1 =>
      'Blocca le app automaticamente a ora di nanna';

  @override
  String get focusSleepModeBullet2 =>
      'Dolci promemoria per il risveglio del Fajr';

  @override
  String get focusSleepModeBullet3 => 'Protegge il sonno e il Fajr';

  @override
  String get focusChildModeTitle => 'Modalità bambino';

  @override
  String get focusChildModeDescription =>
      'Dai il telefono a tuo figlio? Blocca subito le app così vede solo ciò che è sicuro.';

  @override
  String get focusChildModeBullet1 => 'Modalità sicura con un tocco';

  @override
  String get focusChildModeBullet2 => 'Uscita protetta da codice';

  @override
  String get focusChildModeBullet3 => 'Tranquillità, ogni volta';

  @override
  String get focusModeGotIt => 'Capito';

  @override
  String get focusFeaturePrayerTimesTitle => 'Orari di preghiera precisi';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan e promemoria';

  @override
  String get focusFeatureStreaksTitle => 'Serie';

  @override
  String get focusFeatureStreaksSubtitle => 'Resta costante';

  @override
  String get focusFeatureChecklistTitle => 'Lista giornaliera';

  @override
  String get focusFeatureChecklistSubtitle => 'Crea buone abitudini';

  @override
  String get focusFeatureQiblaTitle => 'Qibla e moschea';

  @override
  String get focusFeatureQiblaSubtitle => 'Direzione e moschee';

  @override
  String get focusFeatureQuranTitle => 'Corano';

  @override
  String get focusFeatureQuranSubtitle => 'Traduzioni, juz e pagine';

  @override
  String get focusFeatureHadithTitle => 'Hadith';

  @override
  String get focusFeatureHadithSubtitle => 'Collezioni autentiche';

  @override
  String get focusFeatureDuasTitle => 'Dua';

  @override
  String get focusFeatureDuasSubtitle => 'Suppliche quotidiane';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Contatore digitale di dhikr';

  @override
  String get focusFeatureAiTitle => 'Compagno IA';

  @override
  String get focusFeatureAiSubtitle => 'Fai domande sul tuo din';

  @override
  String get focusFeatureInsightsTitle => 'Statistiche';

  @override
  String get focusFeatureInsightsSubtitle => 'Dati settimanali e mensili';

  @override
  String get investTitle => 'Investi nel Deen';

  @override
  String get investSubtitle =>
      'Il miglior investimento non è in ciò che svanisce — è in ciò che ti avvicina ad Allah. Prova tutto gratis per 7 giorni.';

  @override
  String get investPremiumUnlocked => 'PREMIUM SBLOCCATO';

  @override
  String get investTrialPill =>
      '✨ 7 giorni gratis — annulla in qualsiasi momento prima della fine';

  @override
  String get investNoCommitment => 'Nessun impegno. Annulla quando vuoi.';

  @override
  String get investFeatureAiTitle => 'Assistente islamico IA';

  @override
  String get investFeatureAiBody =>
      'Chiedi qualsiasi cosa sul tuo Deen — risposte radicate in fonti autentiche.';

  @override
  String get investFeaturePrayerModeTitle =>
      'Modalità preghiera a schermo intero';

  @override
  String get investFeaturePrayerModeBody =>
      'Uno schermo calmo e senza distrazioni che ti chiama alla Salah.';

  @override
  String get investFeatureAppBlockingTitle => 'Blocco app avanzato';

  @override
  String get investFeatureAppBlockingBody =>
      'Controllo preciso su quali app si bloccano e quando esattamente.';

  @override
  String get investFeatureNightModeTitle => 'Modalità disciplina notturna';

  @override
  String get investFeatureNightModeBody =>
      'Rilassati in tempo, dormi meglio e svegliati per il Fajr.';

  @override
  String get investFeaturePlannerTitle => 'Planner della preghiera e progressi';

  @override
  String get investFeaturePlannerBody =>
      'Serie, approfondimenti e diari che ti tengono costante.';

  @override
  String get investFeatureToolsTitle => 'Strumenti islamici esclusivi';

  @override
  String get investFeatureToolsBody =>
      'Calendario hijri, dua, tasbih, 99 Nomi e altro.';

  @override
  String get investFeatureThemesTitle => 'Temi premium e aggiornamenti';

  @override
  String get investFeatureThemesBody =>
      'Temi bellissimi più ogni nuova funzione che rilasciamo.';

  @override
  String get investFeatureTajweedTitle => 'Padroneggia il Tajweed';

  @override
  String get investFeatureTajweedBody =>
      'Migliora la tua recitazione con lezioni guidate e feedback in tempo reale.';

  @override
  String get socialProofPrefix => 'Unisciti a ';

  @override
  String get socialProofHighlight => '10.000+';

  @override
  String get socialProofSuffix => ' musulmani che crescono con DeenFocus';

  @override
  String get mostPopular => 'Il più popolare';

  @override
  String get monthlyLabel => 'Mensile';

  @override
  String get yearlyLabel => 'Annuale';

  @override
  String get lifetimeLabel => 'Tutta la vita';

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
  String get homeSearchNearbyMosques =>
      'Trova moschee vicine da OpenStreetMap.';

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
  String get homeTapPrayerToMark =>
      'Tocca una preghiera per segnarla come pregata, qada o mancata.';

  @override
  String get homeSetLocation => 'Imposta posizione';

  @override
  String get homeEditPrayerSettings => 'Modifica impostazioni preghiera';

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
  String get hijriYear => 'H';

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
  String get calendarTitle => 'Calendario islamico';

  @override
  String get calendarBack => 'Indietro';

  @override
  String get calendarToday => 'Oggi';

  @override
  String get calendarTomorrow => 'Domani';

  @override
  String calendarDaysAway(int days) {
    return '$days giorni';
  }

  @override
  String get calendarNoEventsThisWeek =>
      'Nessun evento islamico questa settimana.';

  @override
  String get calendarNoEventsBlessing =>
      'Che Allah benedica la tua settimana con pace e bontà.';

  @override
  String get calendarNoUpcomingEvents => 'Nessun evento islamico in programma.';

  @override
  String get calendarUpcomingEvents => 'Prossimi eventi islamici';

  @override
  String get calendarUpcomingThisYear => 'In arrivo quest\'anno';

  @override
  String get calendarThisWeekObservances => 'Questa settimana';

  @override
  String get calendarLegendCycleDays => 'Giorni del ciclo (serie protetta)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% illuminata';
  }

  @override
  String get calendarMoonNew => 'Luna nuova';

  @override
  String get calendarMoonWaxingCrescent => 'Luna crescente';

  @override
  String get calendarMoonFirstQuarter => 'Primo quarto';

  @override
  String get calendarMoonWaxingGibbous => 'Gibbosa crescente';

  @override
  String get calendarMoonFull => 'Luna piena';

  @override
  String get calendarMoonWaningGibbous => 'Gibbosa calante';

  @override
  String get calendarMoonLastQuarter => 'Ultimo quarto';

  @override
  String get calendarMoonWaningCrescent => 'Luna calante';

  @override
  String get calendarEventRamadanBegins => 'Inizio del Ramadan';

  @override
  String get calendarEventRamadanBeginsDesc => 'Mese del digiuno';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Notte del Destino';

  @override
  String get calendarEventEidAlFitr => 'Eid al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc => 'Festa della rottura del digiuno';

  @override
  String get calendarEventDayOfArafah => 'Giorno di Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Giorno della stazione ad Arafah';

  @override
  String get calendarEventEidAlAdha => 'Eid al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Festa del sacrificio';

  @override
  String get calendarEventIslamicNewYear => 'Capodanno islamico';

  @override
  String get calendarEventIslamicNewYearDesc => '1° di Muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Nascita del Profeta';

  @override
  String get calendarEventAshura => 'Ashura';

  @override
  String get calendarEventAshuraDesc => '10 di Muharram';

  @override
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Preghiera congregazionale del venerdì';

  @override
  String get calendarEventWhiteDays => 'Giorni bianchi';

  @override
  String get calendarEventWhiteDaysDesc => 'Giorni di digiuno raccomandati';

  @override
  String get cycleModeActiveTitle =>
      '«Allah vuole per voi la facilità e non vuole per voi la difficoltà.» — Corano 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'Durante questo periodo la tua serie è protetta. I giorni del ciclo sono evidenziati in rosa e la Modalità ciclo si disattiva automaticamente al termine del ciclo.';

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
      other: 'Termina automaticamente tra $days giorni',
      one: 'Termina automaticamente domani',
      zero: 'Termina oggi',
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
    return 'Hai pregato $prayer?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Mantieni la serie registrando la tua preghiera.';

  @override
  String get prayerReminderYesButton => 'Sì, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'Segnerò più tardi';

  @override
  String get prayerNotificationSubtitleFajr =>
      '“In verità, la recitazione dell’alba è sempre testimoniata.” — Corano 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '“Stabilisci la preghiera al declino del sole...” — Corano 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '“Custodite strettamente le preghiere, specialmente la preghiera di mezzo.” — Corano 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '“Glorificate dunque Allah quando giungete alla sera...” — Corano 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '“Stabilisci la preghiera -  fino all’oscurità della notte.” — Corano 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'È ora di $prayerName';
  }

  @override
  String get homeTrialBannerTitle =>
      'Gratis per 7 giorni — diventa un musulmano migliore ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Tutte le funzioni sbloccate. Inizia il tuo percorso oggi.';

  @override
  String get homeFocusModeTitle => 'Modalità focus';

  @override
  String get homeFocusModeSubtitle =>
      'Blocca le app che distraggono durante la Salah';

  @override
  String get homeLivePrayerUpdatesTitle => 'Aggiornamenti preghiera in diretta';

  @override
  String get homeLivePrayerUpdatesBody =>
      'Vedi la preghiera attuale e successiva su Lock Screen e Dynamic Island.';

  @override
  String get homeLivePrayerUpdatesCta => 'Attiva aggiornamenti live';

  @override
  String get homeWidgetsPromoTitle => 'Widget';

  @override
  String get homeWidgetsPromoBody =>
      'Vedi il versetto del giorno e gli orari di preghiera sulla schermata Home.';

  @override
  String get homeWidgetsPromoCta => 'Aggiungi widget';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Notte';

  @override
  String get focusModeShortChild => 'Bambino';

  @override
  String get focusModeLabelSalah => 'Modalità Salah';

  @override
  String get focusModeLabelNight => 'Modalità notte';

  @override
  String get focusModeLabelChild => 'Modalità bambino';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return 'Le modalità $first e $second sono attive';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return 'Le modalità $first, $second e $third sono attive';
  }

  @override
  String get cycleModeTitle => 'Modalità ciclo';

  @override
  String get cycleModeSubtitle =>
      'Per il ciclo mestruale — metti in pausa le preghiere, mantieni la serie';

  @override
  String get dailyChecklistTitle => 'Lista giornaliera';

  @override
  String get dailyChecklistSubtitle =>
      'Monitora i tuoi obiettivi spirituali quotidiani';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed di $total completati';
  }

  @override
  String get dailyChecklistSectionPrayer => 'Preghiera';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Corano e Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Buone azioni';

  @override
  String get dailyChecklistSectionDistraction => 'Disciplina personale';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Corano';

  @override
  String get dailyChecklistMorningAdhkar => 'Adhkar del mattino';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar della sera';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Carità';

  @override
  String get dailyChecklistSmileAtSomeone => 'Sorridi a qualcuno';

  @override
  String get dailyChecklistFamilyCall => 'Chiamata in famiglia';

  @override
  String get dailyChecklistNoMusicToday => 'Niente musica oggi';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'Niente social prima di Isha';

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
  String get quickActionsCalendar => 'Calendario';

  @override
  String get quickActionsCalendarSubtitle => 'Vedi le date islamiche';

  @override
  String get quickActionsSupportUs => 'Sostienici';

  @override
  String get quickActionsSupportUsSubtitle => 'Aiutaci a crescere';

  @override
  String get quickActionsSupportUsMessage =>
      'Grazie per aver pensato di sostenere DeenFocus! Le funzioni di supporto arriveranno presto.';

  @override
  String get supportUsTitle => 'Sostieni DeenFocus';

  @override
  String get supportUsHeroTitle => 'Supporta DeenFocus';

  @override
  String get supportUsHeroBody =>
      'Il tuo supporto ci aiuta a migliorare DeenFocus e a contribuire a cause significative.';

  @override
  String get supportUsFundSection => 'Il tuo supporto aiuta a finanziare';

  @override
  String get supportUsFundSectionSubtitle =>
      'Usiamo il tuo supporto per creare più bene.';

  @override
  String get supportUsFundFeature1Title => 'Nuove funzionalità';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Creare e migliorare funzionalità significative di DeenFocus.';

  @override
  String get supportUsFundFeature2Title => 'Correzioni di bug';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Mantenere l’app stabile, veloce e affidabile per tutti.';

  @override
  String get supportUsFundFeature3Title => 'Persone in difficoltà';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Sostenere chi affronta momenti difficili.';

  @override
  String get supportUsFundFeature4Title => 'Carità e comunità';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Contribuire a iniziative di carità e supporto comunitario.';

  @override
  String get supportUsNeedHelp => 'HAI BISOGNO DI AIUTO?';

  @override
  String get supportUsWhatsApp => 'Chatta su WhatsApp';

  @override
  String get supportUsEmailSupport => 'Supporto e-mail';

  @override
  String get supportUsChooseAmountTitle => 'Scegli un importo di supporto';

  @override
  String get supportUsChooseAmountSubtitle => 'Puoi supportare più volte.';

  @override
  String get supportUsSecurePaymentNote =>
      'Pagamento unico sicuro · Nessun addebito ricorrente';

  @override
  String get supportUsTrustBanner =>
      'Sicuro • Supporto unico • Puoi supportare più volte';

  @override
  String get supportUsImpactSectionTitle =>
      'Dove il tuo supporto fa la differenza';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Ogni contributo ha un impatto duraturo.';

  @override
  String get supportUsImpactPalestine =>
      'Supporto e consapevolezza per la Palestina';

  @override
  String get supportUsImpactNeedy => 'Aiutare chi ha bisogno';

  @override
  String get supportUsImpactCommunity => 'Carità e supporto comunitario';

  @override
  String get supportUsImpactExperience => 'Esperienza DeenFocus migliore';

  @override
  String get supportUsImpactFeatures => 'Nuove funzionalità e aggiornamenti';

  @override
  String get supportUsImpactQuran => 'Corano e apprendimento islamico';

  @override
  String get supportUsImpactServers => 'Server e affidabilità dell’app';

  @override
  String supportUsCta(String amount) {
    return 'Supporta DeenFocus con $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, ho bisogno di aiuto con DeenFocus.';

  @override
  String get supportUsWhatsAppQuestionHowTo => 'Come si usa DeenFocus?';

  @override
  String get supportUsWhatsAppQuestionFeature =>
      'Ho bisogno di aiuto con una funzione';

  @override
  String get supportUsWhatsAppQuestionSubscription =>
      'Ho un problema con l\'abbonamento';

  @override
  String get supportUsEmailSubject => 'Richiesta di supporto DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'Impossibile aprire quell\'app su questo dispositivo.';

  @override
  String get supportUsLaunchFailed => 'Qualcosa è andato storto. Riprova.';

  @override
  String get supportUsThankYouTitle => 'JazakAllah khair';

  @override
  String get supportUsThankYouBody =>
      'Grazie per aver sostenuto DeenFocus. Puoi sostenere di nuovo in qualsiasi momento.';

  @override
  String get supportUsPurchasePending =>
      'Il tuo sostegno è in sospeso. Lo confermeremo quando Apple completerà l\'acquisto.';

  @override
  String get supportUsPurchaseFailed =>
      'Non è stato possibile completare il pagamento di sostegno. Riprova.';

  @override
  String get supportUsProductUnavailable =>
      'Questo importo di sostegno non è disponibile in questo momento. Riprova più tardi.';

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
  String get tabQuran => 'Impara';

  @override
  String get tabLearn => 'Impara';

  @override
  String get quranLoadFailed => 'Impossibile caricare i dati del Corano';

  @override
  String get quranTabSubtitle => 'Leggere ed esplorare il Sacro Corano';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Cerca sura...';

  @override
  String get quranSearchHintExtended => 'Cerca sura o significato...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranNoSurahsFound => 'Nessuna Sura trovata';

  @override
  String get quranVersesLabel => 'versi';

  @override
  String quranSurahHeaderSubtitle(String name, int count) {
    return '$name • $count versi';
  }

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
  String get quranModeSurah => 'Sura';

  @override
  String get quranModeJuz => 'Juz';

  @override
  String get quranModePage => 'Pagina';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => 'Continua a leggere';

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
    return '$percent% del juz $juz';
  }

  @override
  String get quranBookmarksTitle => 'Segnalibri';

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
    return '$count salvati';
  }

  @override
  String get quranQuickTajweed => 'Esercizio di tajwid';

  @override
  String get quranQuickTajweedSub => 'Recita e valuta';

  @override
  String get quranLastListened => 'Ultimo ascolto';

  @override
  String get quranNoneYet => 'Ancora nessuno';

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
  String get readingSettingsTajweedPractice => 'Tajweed del Corano con IA';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Recita i versi e ricevi un feedback';

  @override
  String get readingSettingsTajweedSeeHowItWorks => 'Scopri come funziona';

  @override
  String get quranSeeHowAiQuranTajweedWorks => 'see how AI Quran Tajweed works';

  @override
  String get readingSettingsTajweedDeleteModel => 'Elimina modello IA';

  @override
  String get readingSettingsTajweedDeleteConfirmTitle =>
      'Eliminare il modello IA Tajweed del Corano?';

  @override
  String get readingSettingsTajweedDeleteConfirmBody =>
      'Non potrai praticare il tajweed finché non scarichi di nuovo il modello IA. Questo libera anche spazio sul dispositivo.';

  @override
  String get readingSettingsTajweedDeleteConfirmAction => 'Elimina';

  @override
  String get readingSettingsTajweedDeleted => 'Modello IA Tajweed eliminato';

  @override
  String get readingSettingsTajweedDeleteFailed =>
      'Impossibile eliminare il modello IA Tajweed';

  @override
  String get readingSettingsTajweedFreePreviewTranslation =>
      'Nel nome di Allah, il Compassionevole, il Misericordioso.';

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
  String get readingSettingsTitle => 'Impostazioni di lettura';

  @override
  String get readingSettingsArabicFontSize => 'Dimensione carattere arabo';

  @override
  String get readingSettingsTranslationFontSize =>
      'Dimensione carattere traduzione';

  @override
  String get readingSettingsLineSpacing => 'Interlinea';

  @override
  String get readingSettingsDefaultMode => 'Modalità di lettura predefinita';

  @override
  String get readingSettingsRememberPosition => 'Ricorda l’ultima posizione';

  @override
  String get readingSettingsScript => 'Scrittura araba';

  @override
  String get readingSettingsScriptUthmani => 'Uthmani (Hafs)';

  @override
  String get readingSettingsScriptIndopak => 'IndoPak (Hafs)';

  @override
  String get readingSettingsArabicFont => 'Carattere arabo';

  @override
  String get readingSettingsFontUthmanic => 'Uthmanic Hafs';

  @override
  String get readingSettingsFontNooreHuda => 'Noore Huda';

  @override
  String get readingSettingsFontSystem => 'Sistema (nativo)';

  @override
  String get readingSettingsShowTranslation => 'Mostra traduzione';

  @override
  String get readingSettingsShowTransliteration => 'Mostra traslitterazione';

  @override
  String get readingSettingsTranslationSection => 'Traduzione';

  @override
  String get readingSettingsTranslationLabel => 'Traduzione';

  @override
  String get readingSettingsTranslationCurrent => 'Attuale';

  @override
  String get readingSettingsInstalledTranslations => 'Installate';

  @override
  String get readingSettingsAvailableTranslations => 'Disponibili';

  @override
  String get readingSettingsTranslationInstalled => 'Installata';

  @override
  String get readingSettingsTranslationSelected => 'Selezionata';

  @override
  String get readingSettingsTranslationDownload => 'Scarica';

  @override
  String get readingSettingsTranslationInstalling => 'Installazione…';

  @override
  String get readingSettingsTranslationDownloading => 'Download…';

  @override
  String get readingSettingsLayoutTheme => 'Layout del Corano';

  @override
  String get readingSettingsLayoutClassic => 'Mushaf';

  @override
  String get readingSettingsLayoutSimple => 'Semplice';

  @override
  String get readingSettingsLayoutColor => 'Corano a colori';

  @override
  String get readingSettingsColorTheme => 'Tema di lettura';

  @override
  String get readingSettingsColorThemeParchment => 'Pergamena';

  @override
  String get readingSettingsColorThemeEmerald => 'Smeraldo';

  @override
  String get readingSettingsColorThemeMidnight => 'Mezzanotte';

  @override
  String get readingSettingsPreview => 'Anteprima';

  @override
  String get readingSettingsResetHistoryTitle => 'Reimposta i dati di lettura';

  @override
  String get readingSettingsResetHistorySubtitle =>
      'Cancella continua a leggere, progresso pagine, segnalibri e azioni rapide';

  @override
  String get readingSettingsResetHistoryConfirmTitle =>
      'Reimpostare i dati di lettura?';

  @override
  String get readingSettingsResetHistoryConfirmBody =>
      'Questo rimuove continua a leggere, il progresso delle pagine, i segnalibri, l’ultimo ascolto e i collegamenti Tajweed. Le impostazioni di visualizzazione e traduzione restano.';

  @override
  String get readingSettingsResetHistoryDone => 'Dati di lettura cancellati';

  @override
  String get readingSettingsResetHistoryButton => 'Reimposta';

  @override
  String readingSettingsTranslationDownloadFailed(String name) {
    return 'Impossibile scaricare $name. Riprova quando sei online.';
  }

  @override
  String readingSettingsTranslationSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => 'Inizia a recitare';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'PRECISIONE DELLE PAROLE';

  @override
  String get tajweedWordReviewLabel => 'REVISIONE DELLE PAROLE';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Recita e controlla il tajwid';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nasale, 2 tempi';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Rimbalzo d’eco';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Prolunga la vocale';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Unisci le lettere';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Nascondi la nun';

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
  String get widgetPrayerProgressTitle => 'Il tuo progresso nelle preghiere';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed di $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'preghiere completate.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Continua così — oggi restano $count preghiere';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — tutte le preghiere di oggi sono complete';

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
  String get settingsRateDeenFocus => 'Rate DeenFocus ⭐';

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
  String get nearbyMosquesTitle => 'Moschee trovate nelle vicinanze';

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
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Raggio di ricerca: $radiusKm km';
  }

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
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'Nessuna moschea trovata nel raggio di $radiusKm km';
  }

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
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'Non è elencato nulla nel raggio di $radiusKm km su OpenStreetMap per questo luogo. Riprova più tardi o amplia l’area.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count moschee trovate nel raggio di $radiusKm km';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count moschee nelle vicinanze';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'Entro $radiusKm km · Ordinate per distanza';
  }

  @override
  String get nearbyMosquesDirections => 'Indicazioni';

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
  String get focusDiagnosticButton => 'Diagnostic';

  @override
  String get focusDiagnosticTitle => 'Test App Lock';

  @override
  String get focusDiagnosticIntro =>
      'Temporarily lock your selected apps for 60 seconds using the same App Lock used by Focus mode. Open a blocked app to confirm the DeenFocus lock screen appears.';

  @override
  String focusDiagnosticIntroWithApp(String appName) {
    return 'Temporarily lock your selected apps for 60 seconds. Try opening $appName to confirm the DeenFocus lock screen appears.';
  }

  @override
  String get focusDiagnosticStart => 'Start Test';

  @override
  String get focusDiagnosticEndEarly => 'End Test';

  @override
  String focusDiagnosticRunning(int seconds) {
    return 'App Lock is on for ${seconds}s. Switch to a selected app to test the lock screen.';
  }

  @override
  String get focusDiagnosticSuccessTitle => 'Test completed';

  @override
  String get focusDiagnosticSuccessBody =>
      'App Lock was activated with your selected apps. If you saw the DeenFocus lock screen, App Lock is working.';

  @override
  String get focusDiagnosticCancelledTitle => 'Test ended';

  @override
  String get focusDiagnosticCancelledBody =>
      'The diagnostic lock was turned off. Your Focus modes and schedules were not changed.';

  @override
  String get focusDiagnosticMissingAppsTitle => 'Select apps first';

  @override
  String get focusDiagnosticMissingAppsBody =>
      'Choose at least one app to block before running the App Lock test.';

  @override
  String get focusDiagnosticMissingPermissionTitle => 'Permission needed';

  @override
  String get focusDiagnosticMissingPermissionBodyIos =>
      'Screen Time access is required to block apps. Allow Screen Time, then try again.';

  @override
  String get focusDiagnosticMissingPermissionBodyAndroid =>
      'Android Accessibility must be enabled for DeenFocus so App Lock can block selected apps.';

  @override
  String get focusDiagnosticFailedTitle => 'Could not start test';

  @override
  String get focusDiagnosticFailedBody =>
      'App Lock did not activate. Check permissions and selected apps, then try again.';

  @override
  String get focusDiagnosticClose => 'Done';

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
  String get insightsPrayerStreak => 'Serie di preghiere';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count preghiere';
  }

  @override
  String get insightsPrayersInARow => 'Preghiere di seguito';

  @override
  String get insightsDaysInARow => 'Giorni di seguito';

  @override
  String insightsChipUpToday(int count) {
    return '↑ $count';
  }

  @override
  String get insightsChipDayUp => '↑ 1 oggi';

  @override
  String get insightsWeeklyCompletion => 'Completamento settimanale';

  @override
  String get insightsMonthlyCompletion => 'Completamento mensile';

  @override
  String get insightsThisWeek => 'Questa settimana';

  @override
  String get insightsThisMonth => 'Questo mese';

  @override
  String get insightsOverall => 'Complessivo';

  @override
  String get insightsRateExcellent => 'Eccellente';

  @override
  String get insightsRateGood => 'Buono';

  @override
  String get insightsRateFair => 'Discreto';

  @override
  String get insightsRateStart => 'Continua così';

  @override
  String get insightsPrayersCompletedWeekly =>
      'Preghiere completate (settimana)';

  @override
  String get insightsPrayersCompletedMonthly => 'Preghiere completate (mese)';

  @override
  String insightsCompletionSummary(int done, int possible) {
    return 'Hai completato $done preghiere su $possible.\nAlhamdulillah — continua così!';
  }

  @override
  String get insightsFocusExcellent => 'Eccellente — continua così!';

  @override
  String get insightsFocusKeepGoing => 'Continua a costruire il tuo focus';

  @override
  String get insightsTodaysPrayers => 'Preghiere di oggi';

  @override
  String get insightsPrayersCompletedLabel =>
      'Preghiere completate — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Modalità ciclo attiva';

  @override
  String get insightsProtectedByCycleMode => 'La tua serie è protetta.';

  @override
  String get insightsCurrentPrayerStreak => 'Serie di preghiere attuale';

  @override
  String get insightsBestPrayerStreak => 'Migliore serie di preghiere';

  @override
  String get insightsCurrentDayStreak => 'Serie di giorni attuale';

  @override
  String get insightsCycleProtectedDays => 'Giorni protetti dal ciclo';

  @override
  String get insightsAchievements => 'Traguardi';

  @override
  String get insightsAchieved => 'Raggiunto';

  @override
  String get insightsMyProgress => 'I miei progressi';

  @override
  String insightsLevelNumber(int level) {
    return 'Livello $level';
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
    return '$xp XP al livello $level';
  }

  @override
  String get insightsMaxLevel => 'LIVELLO MASSIMO';

  @override
  String insightsAchievementsUnlocked(int unlocked, int total) {
    return '$unlocked / $total sbloccati';
  }

  @override
  String get insightsAchievementUnlockedTitle => 'Obiettivo sbloccato';

  @override
  String get insightsLevelUpTitle => 'LIVELLO SUCCESSIVO';

  @override
  String get achievementFirstPrayer => 'Prima preghiera';

  @override
  String get achievementFajrChampion => 'Campione del Fajr';

  @override
  String get achievementFiveADay => 'Cinque al giorno';

  @override
  String get achievementPerfectWeek => 'Settimana perfetta';

  @override
  String get achievementPerfectMonth => 'Mese perfetto';

  @override
  String get achievementQuranDevotee => 'Devoto del Corano';

  @override
  String get achievementDhikrStarter => 'Inizio del dhikr';

  @override
  String get achievementNightWorshipper => 'Adoratore notturno';

  @override
  String get achievementMasjidCompanion => 'Compagno della moschea';

  @override
  String get achievementDistractionDefender => 'Difensore della concentrazione';

  @override
  String get achievementCycleGuardian => 'Guardiano del ciclo';

  @override
  String get achievementProtectedMonth => 'Mese protetto';

  @override
  String get achievementSixMonthJourney => 'Percorso di sei mesi';

  @override
  String get achievementDeenFocusMaster => 'DeenFocus Master';

  @override
  String insightsCycleModeFooter(int days) {
    return 'I giorni del ciclo sono protetti e non interrompono la serie. Hai $days giorno/i protetto/i.';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Attiva la Modalità ciclo per proteggere la tua serie nei giorni di riposo.';

  @override
  String get achievementFirstPrayerStreak => 'Prima serie di preghiere';

  @override
  String get achievementSevenPrayerStreak => 'Serie di sette preghiere';

  @override
  String get achievementThirtyPrayerStreak => 'Serie di trenta preghiere';

  @override
  String get achievementFajrWarrior => 'Guerriero del Fajr';

  @override
  String get achievementQuranReader => 'Lettore del Corano';

  @override
  String get achievementDhikrMaster => 'Maestro del Dhikr';

  @override
  String get achievementConsistencyChampion => 'Campione della costanza';

  @override
  String get prayerCompletionAlhamdulillah => 'Alhamdulillah!';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer è stata completata';
  }

  @override
  String get prayerCompletionStreakIncreased =>
      'La tua serie di preghiere è aumentata';

  @override
  String get prayerCompletionKeepGoing =>
      'Ogni preghiera ti avvicina ad Allah. Continua così!';

  @override
  String get prayerCompletionContinue => 'Continua';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Prossima preghiera tra $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes minuti';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get weekdayLetterMon => 'L';

  @override
  String get weekdayLetterTue => 'M';

  @override
  String get weekdayLetterWed => 'M';

  @override
  String get weekdayLetterThu => 'G';

  @override
  String get weekdayLetterFri => 'V';

  @override
  String get weekdayLetterSat => 'S';

  @override
  String get weekdayLetterSun => 'D';

  @override
  String get focusHomeBlockingNightAndSalah =>
      'Disciplina notturna e modalità Salah stanno bloccando le app selezionate.';

  @override
  String get focusHomeBlockingNight =>
      'Disciplina notturna sta bloccando le app selezionate.';

  @override
  String get focusHomeBlockingSalah =>
      'La modalità Salah sta bloccando le app selezionate.';

  @override
  String get focusHomeAppsBlockedNow => 'Le app selezionate sono bloccate ora.';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode è attivo.';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes sono attivi.';
  }

  @override
  String get focusHomeChooseMode =>
      'Scegli una modalità per proteggere la tua attenzione';

  @override
  String get focusStatusSelectApps => 'Seleziona le app per iniziare';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Disciplina notturna e modalità Salah stanno bloccando le app ora';

  @override
  String get focusStatusBlockingNight =>
      'Disciplina notturna sta bloccando le app ora';

  @override
  String get focusStatusBlockingSalah =>
      'La modalità Salah sta bloccando le app ora';

  @override
  String get focusStatusAppsLocked => 'Le app sono bloccate ora';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Sbloccato fino alle $time';
  }

  @override
  String get focusStatusNoMode => 'Nessuna modalità focus attiva';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Pronto a bloccare $targets';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String get appLockDemoIntroTitle => 'Scopri come funziona il blocco app';

  @override
  String get appLockDemoIntroSubtitle =>
      'Resta in DeenFocus. Nella schermata successiva tocca Instagram per vedere la pausa all’ora della preghiera.';

  @override
  String get appLockDemoStartButton => 'Avvia la demo';

  @override
  String get appLockDemoTryOpeningApp => 'Prova ad aprire Instagram';

  @override
  String get appLockDemoSalahModeBadge => 'MODALITÀ SALAH';

  @override
  String get appLockDemoTimeToPray => 'È ora di pregare';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Tempo rimanente: $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'Ho pregato $prayerName';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName completata';
  }

  @override
  String get appLockDemoStreakIncreased =>
      'La tua serie di preghiere è aumentata';

  @override
  String get appLockDemoPrayerStreakLabel => 'SERIE PREGHIERA';

  @override
  String get appLockDemoDayStreakLabel => 'SERIE GIORNI';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Prossima preghiera tra $minutes minuti';
  }

  @override
  String get appLockDemoStreakMotivation =>
      'Continua così! La costanza ti avvicina ad Allah.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Prega. Conferma una volta.\nTorna alla tua giornata.';

  @override
  String get appLockDemoCompletionBody =>
      'Il blocco app mette in pausa delicatamente le app selezionate durante la Salah così puoi concentrarti — poi continui quando sei pronto.';

  @override
  String get appLockDemoContinueSetup => 'Continua configurazione';

  @override
  String get appLockDemoAppMessages => 'Messaggi';

  @override
  String get appLockDemoAppCalendar => 'Calendario';

  @override
  String get appLockDemoAppPhotos => 'Foto';

  @override
  String get appLockDemoAppCamera => 'Fotocamera';

  @override
  String get appLockDemoAppMail => 'Mail';

  @override
  String get appLockDemoAppMaps => 'Mappe';

  @override
  String get appLockDemoAppWeather => 'Meteo';

  @override
  String get appLockDemoAppClock => 'Orologio';

  @override
  String get appLockDemoAppNotes => 'Note';

  @override
  String get appLockDemoAppSettings => 'Impostazioni';

  @override
  String get appLockDemoAppMusic => 'Musica';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Aggiornamenti preghiere';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live Activity per la prossima preghiera sulla Lock Screen';

  @override
  String get liveActivitySectionTitle => 'Live Activities';

  @override
  String get liveActivityStayUpdatedTitle =>
      'Resta aggiornato a colpo d’occhio';

  @override
  String get liveActivityStayUpdatedBody =>
      'Vedi la prossima preghiera e il suo orario direttamente sulla Lock Screen.';

  @override
  String get liveActivityEnableLabel => 'Attiva Live Activity';

  @override
  String get liveActivityPromptNotNow => 'Non ora';

  @override
  String get liveActivityUnsupported =>
      'Le Live Activities non sono disponibili su questo dispositivo.';

  @override
  String get liveActivityPermissionNeeded =>
      'Consenti le notifiche per mostrare gli aggiornamenti delle preghiere sulla Lock Screen.';

  @override
  String get liveActivityPermissionButton => 'Consenti notifiche';

  @override
  String get liveActivityStatusActive => 'Live Activity attiva';

  @override
  String get liveActivityStatusOff => 'Live Activity disattivata';

  @override
  String get liveActivityEnabledPromptTitle => 'Live Activity is on';

  @override
  String get liveActivityEnabledPromptBodyIos =>
      'Prayer updates are now on your Lock Screen and Dynamic Island. Lock your phone to see your current and next prayer anytime.';

  @override
  String get liveActivityEnabledPromptBodyAndroid =>
      'Prayer updates now show as an ongoing notification. Lock your phone or pull down the notification shade to check anytime.';

  @override
  String get liveActivityEnabledPromptButton => 'Got it';

  @override
  String get liveActivityNowLabel => 'Ora';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Aggiornato alle $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer alle $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Sveglie di preghiera';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Sveglie complete che possono superare la modalità silenziosa';

  @override
  String get prayerAlarmsMasterLabel => 'Attiva sveglie di preghiera';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Programma una sveglia nativa per ogni preghiera selezionata';

  @override
  String get prayerAlarmsSnoozeLabel => 'Durata snooze';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes minuti';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Sveglie per preghiera';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Consenti l\'autorizzazione sveglia affinché suonino in orario.';

  @override
  String get prayerAlarmsPermissionButton => 'Consenti sveglie';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Consenti sveglie a schermo intero per la schermata di blocco. Altrimenti restano come banner.';

  @override
  String get prayerAlarmsFsiButton => 'Impostazioni schermo intero';

  @override
  String get prayerAlarmsUnsupported =>
      'Le sveglie native non sono disponibili su questo dispositivo. Restano le notifiche soft.';

  @override
  String get prayerAlarmsIosFallback =>
      'Su questa versione iOS si usano notifiche soft al posto di AlarmKit.';

  @override
  String get prayerAlarmsDeniedTitle => 'Autorizzazione sveglia richiesta';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Le sveglie di preghiera restano disattivate finché non consenti l’autorizzazione. Le notifiche soft non sono interessate.';

  @override
  String get prayerAlarmsOpenSettings => 'Apri Impostazioni';

  @override
  String get prayerAlarmsStatusReady => 'Le sveglie sono pronte da programmare';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Autorizzazione necessaria — sveglie non attive';

  @override
  String get prayerAlarmsStatusFallback =>
      'Su questo dispositivo si usano notifiche soft';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Sveglie attive. Abilita lo schermo intero per il blocco schermo.';

  @override
  String get prayerAlarmsCancel => 'Non ora';

  @override
  String get homePrayerAlarmEnableLabel => 'Sveglia di preghiera';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Suona una sveglia nativa a $prayerName';
  }

  @override
  String get prayerAlarmBadge => 'Sveglia di preghiera';

  @override
  String get prayerAlarmSubtitle => 'È ora di pregare';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — È ora di pregare';
  }

  @override
  String get prayerAlarmIvePrayed => 'Ho pregato';

  @override
  String get prayerAlarmDismiss => 'Ignora';

  @override
  String get prayerAlarmSnooze => 'Posticipa';

  @override
  String get appLockDemoAppPhone => 'Telefono';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Promemoria';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Libri';

  @override
  String get appLockDemoAppHealth => 'Salute';

  @override
  String get appLockDemoAppWallet => 'Wallet';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'Demo dell’app';

  @override
  String get settingsAppDemoChooseModeTitle => 'Prova il blocco app';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Scegli una modalità Focus e vedi come le app selezionate si mettono in pausa — senza uscire da DeenFocus.';

  @override
  String get appLockDemoDone => 'Fatto';

  @override
  String get appLockDemoSleepIntroTitle =>
      'Scopri come funziona la modalità Sonno';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Resta in DeenFocus. Nella schermata successiva tocca Instagram per vedere la pausa all’ora di dormire.';

  @override
  String get appLockDemoSleepModeBadge => 'MODALITÀ SONNO';

  @override
  String get appLockDemoSleepLockTitle => 'È ora di riposare';

  @override
  String get appLockDemoSleepLockCta => 'Sono pronto a riposare';

  @override
  String get appLockDemoSleepCompleted => 'Modalità Sonno protetta';

  @override
  String get appLockDemoSleepRewardSubtitle =>
      'La tua protezione notturna è aumentata';

  @override
  String get appLockDemoSleepStreakLabel => 'SERIE NOTTE';

  @override
  String get appLockDemoSleepRewardFooter =>
      'Promemoria Fajr impostato per la mattina';

  @override
  String get appLockDemoSleepMotivation =>
      'Riposa bene stasera per alzarti con energia per Fajr.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Notti tranquille.\nMattine chiare.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'La modalità Sonno mette in pausa delicatamente le app selezionate di notte così puoi riposare — poi continui quando sei pronto.';

  @override
  String get appLockDemoChildIntroTitle =>
      'Scopri come funziona la modalità Bambino';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Resta in DeenFocus. Nella schermata successiva tocca Instagram per vedere il blocco con la modalità Bambino.';

  @override
  String get appLockDemoChildModeBadge => 'MODALITÀ BAMBINO';

  @override
  String get appLockDemoChildLockTitle => 'Le app sono protette';

  @override
  String get appLockDemoChildLockDetail =>
      'Le app selezionate restano bloccate con la modalità Bambino';

  @override
  String get appLockDemoChildLockCta => 'Ho capito';

  @override
  String get appLockDemoChildCompleted => 'Modalità Bambino attiva';

  @override
  String get appLockDemoChildRewardSubtitle =>
      'La tua serie di protezione è aumentata';

  @override
  String get appLockDemoChildStreakLabel => 'SERIE SICURA';

  @override
  String get appLockDemoChildRewardFooter =>
      'Esci in qualsiasi momento con il tuo codice';

  @override
  String get appLockDemoChildMotivation =>
      'Tranquillità ogni volta che presti il telefono.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'Modalità sicura con un tocco.\nSolo ciò che permetti.';

  @override
  String get appLockDemoChildCompletionBody =>
      'La modalità Bambino blocca le app selezionate così tuo figlio vede solo ciò che è sicuro — poi sblocchi quando sei pronto.';

  @override
  String get appLockDemoSleepCompletionTitle => 'Riposa bene stasera';

  @override
  String get appLockDemoChildCompletionTitle => 'Tranquillità';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Metti in pausa le distrazioni durante la Salah per pregare con presenza.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Proteggi le tue notti per riposare meglio — e un Fajr più leggero.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Consegna il telefono con serenità: restano aperte solo le app consentite.';

  @override
  String get settingsAppDemoHomeFeaturesTitle =>
      'Resta aggiornato a colpo d’occhio';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'Scopri come widget e Live Activity tengono vicine le ore di preghiera — senza aprire l’app.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Versetto del giorno e orari di preghiera sulla Home, sempre aggiornati.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Preghiera attuale e successiva su Lock Screen e Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Recita un versetto e ricevi feedback tajwid immediato.';

  @override
  String get featureDemoTajweedTitle => 'Tajwid';

  @override
  String get featureDemoTajweedIntroTitle => 'Scopri la pratica del tajwid';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Resta in DeenFocus. Apri l’esercizio tajwid, recita un versetto e vedi il feedback parola per parola.';

  @override
  String get featureDemoTajweedQuranCallout =>
      'Tocca Esercizio tajwid per iniziare';

  @override
  String get featureDemoTajweedLegendCallout =>
      'I colori mostrano le regole del tajwid durante la lettura';

  @override
  String get featureDemoTajweedReciteCallout =>
      'Tocca Recita e controlla il tajwid';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'Download unico per praticare offline';

  @override
  String get featureDemoTajweedMicCallout =>
      'Tocca il microfono e inizia a recitare';

  @override
  String get featureDemoTajweedResultCallout =>
      'Vedi quali parole sono corrette, mancanti o da rivedere';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tajwid, pronto';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Recita con sicurezza, quando vuoi.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Apri Corano → Esercizio tajwid per esercitarti su qualsiasi versetto con punteggio sul dispositivo — completamente offline dopo il primo download.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 versetti • Meccani';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 versetti • Medinesi';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => 'Al-Fatiha • 7 versetti';

  @override
  String get featureDemoTajweedSurahMeta => 'SURA 1 • MECCANA';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'Nel nome di Allah, il Compassionevole, il Misericordioso.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatihah · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'Preparazione del modello IA';

  @override
  String get featureDemoTajweedPreparingBody =>
      'Download unico così la pratica del tajwid funziona completamente offline. Succede una sola volta.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Continua a esercitarti: ascolta il riferimento e riprova.';

  @override
  String get featureDemoTajweedStatCorrect => 'Corretto';

  @override
  String get featureDemoTajweedStatPronunciation => 'Pronuncia';

  @override
  String get featureDemoTajweedStatWrong => 'Parola errata';

  @override
  String get featureDemoTajweedStatMissed => 'Mancata';

  @override
  String get featureDemoTajweedStatExtra => 'In più';

  @override
  String get featureDemoContinue => 'Continua';

  @override
  String get featureDemoSampleStatusTime => '9:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      'Il dispositivo non consente alle app di posizionare i widget automaticamente. Aggiungi il widget Large di DeenFocus dalla galleria widget della Home.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Aggiungi il widget dalla schermata Home';

  @override
  String get featureDemoOfferNo => 'No';

  @override
  String get featureDemoOfferYes => 'Sì';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      'Vuoi attivare Live Activity sul tuo dispositivo?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      'Vuoi aggiungere questo widget alla schermata Home?';

  @override
  String get featureDemoWidgetsTitle => 'Widget';

  @override
  String get featureDemoWidgetsIntroTitle => 'Guarda i widget sulla Home';

  @override
  String get featureDemoWidgetsIntroSubtitle =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsShowcaseCallout =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsDetailsTitle =>
      'Guida alla preghiera a colpo d’occhio';

  @override
  String get featureDemoWidgetsDetailsBody =>
      'Il widget medio mostra il versetto del giorno e le cinque preghiere — si aggiorna aprendo DeenFocus.';

  @override
  String get featureDemoWidgetsCompletionTitle => 'Widget pronti';

  @override
  String get featureDemoWidgetsCompletionSubtitle =>
      'Promemoria di fede sulla Home.';

  @override
  String get featureDemoWidgetsCompletionBody =>
      'Aggiungi i widget DeenFocus dalla galleria, poi apri l’app una volta per sincronizzare.';

  @override
  String get featureDemoWidgetsHomeHint => 'Wednesday, 13 August';

  @override
  String get featureDemoWidgetSampleDate => 'Wed, Aug 13';

  @override
  String get featureDemoWidgetSampleVerse =>
      'It is You we worship and You we ask for help.';

  @override
  String get featureDemoWidgetSampleSource => 'Surah 1:5';

  @override
  String get featureDemoLiveActivityTitle => 'Live Activity';

  @override
  String get featureDemoLiveActivityIntroTitle => 'Vedi la Live Activity';

  @override
  String get featureDemoLiveActivityIntroSubtitle =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityShowcaseCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveActivityDetailsTitle =>
      'Aggiornamenti preghiera sempre visibili';

  @override
  String get featureDemoLiveActivityDetailsBody =>
      'La Live Activity tiene Maghrib, Isha e il conto alla rovescia sulla Lock Screen — attivala nelle Impostazioni.';

  @override
  String get featureDemoLiveActivityCompletionTitle => 'Live Activity pronta';

  @override
  String get featureDemoLiveActivityCompletionSubtitle =>
      'La prossima preghiera, sempre vicina.';

  @override
  String get featureDemoLiveActivityCompletionBody =>
      'Attiva la Live Activity in Impostazioni → Calcolo preghiera per mostrarla sulla Lock Screen.';

  @override
  String get featureDemoLiveActivityLockHint => 'Wednesday, 13 August';

  @override
  String get featureDemoLiveActivitySampleTime => '6:48 PM';

  @override
  String get featureDemoLiveActivitySampleNextTime => '8:11 PM';

  @override
  String get featureDemoWidgetsIntroSubtitleIos =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsIntroSubtitleAndroid =>
      'Stay in DeenFocus. Long-press the Home Screen, open the widget picker, and try all three sizes.';

  @override
  String get featureDemoWidgetsLongPressCalloutIos =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsLongPressCalloutAndroid =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsAddCallout =>
      'Tap + to choose a DeenFocus widget';

  @override
  String get featureDemoWidgetsAddSlotLabel => 'Add Widget';

  @override
  String get featureDemoWidgetsGalleryTitle => 'Choose a DeenFocus widget';

  @override
  String get featureDemoWidgetsGallerySubtitle =>
      'Switch between Small, Medium, and Large — then add it to your Home Screen.';

  @override
  String get featureDemoWidgetsAddCta => 'Add Widget';

  @override
  String get featureDemoWidgetsAddCtaAndroid => 'Add widget';

  @override
  String get featureDemoWidgetsChangeCta => 'Change size';

  @override
  String get featureDemoWidgetSizeSmall => 'Small';

  @override
  String get featureDemoWidgetSizeMedium => 'Medium';

  @override
  String get featureDemoWidgetSizeLarge => 'Large';

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
  String get featureDemoLiveOpenPrayerCalcCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveEnableToggleCallout =>
      'Turn on Enable Live Activity';

  @override
  String get featureDemoLiveLockScreenCallout =>
      'Your prayer Live Activity on the Lock Screen';

  @override
  String get featureDemoLiveCompactTitle => 'Compact Dynamic Island';

  @override
  String get featureDemoLiveCompactCallout =>
      'Current prayer stays visible at the top';

  @override
  String get featureDemoLiveExpandCta => 'Expand Dynamic Island';

  @override
  String get featureDemoLiveExpandedTitle => 'Expanded Dynamic Island';

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
  String get featureDemoAndroidOngoingTitle => 'Live prayer notification';

  @override
  String get featureDemoAndroidOngoingCallout =>
      'Silent ongoing update — current and next prayer';

  @override
  String get featureDemoAndroidOpenShadeCta => 'Open notification shade';

  @override
  String get featureDemoAndroidShadeTitle => 'Notification shade';

  @override
  String get featureDemoAndroidShadeCallout =>
      'Expand to see the full current and next prayer status';

  @override
  String get featureDemoAndroidOngoingBadge => 'Ongoing';

  @override
  String get appLockDemoOfferPrayerTitle =>
      'Pronto a provare la Modalità Preghiera?';

  @override
  String get appLockDemoOfferSleepTitle =>
      'Pronto a provare la Modalità Sonno?';

  @override
  String get appLockDemoOfferChildTitle =>
      'Pronto a provare la Modalità Bambino?';

  @override
  String get appLockDemoOfferPrayerCta => 'Attiva Modalità Preghiera';

  @override
  String get appLockDemoOfferSleepCta => 'Attiva Modalità Sonno';

  @override
  String get appLockDemoOfferChildCta => 'Attiva Modalità Bambino';

  @override
  String get appLockDemoOfferNotNow => 'Non ora';

  @override
  String get nightlyWrapUpPrayersTitle => 'Completa le preghiere di oggi';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Segna le preghiere incomplete o mancate per proteggere la tua serie di preghiere.';

  @override
  String get nightlyWrapUpChecklistTitle => 'Completa la checklist giornaliera';

  @override
  String get nightlyWrapUpChecklistBody =>
      'Alcuni elementi sono ancora aperti — chiudi la giornata con intenzione.';

  @override
  String get nightlyWrapUpBothTitle => 'Chiudi la giornata';

  @override
  String get nightlyWrapUpBothBody =>
      'Segna le preghiere rimanenti e completa la checklist prima della fine della giornata.';

  @override
  String get cycleModeEndedNotificationTitle => 'La modalità ciclo è terminata';

  @override
  String get cycleModeEndedNotificationBody =>
      'La modalità ciclo è ora disattivata. Puoi riprendere a pregare. Se vuoi modificare le date della modalità ciclo, tocca qui per modificarle.';

  @override
  String get libraryHomeTitle => 'Biblioteca islamica';

  @override
  String get libraryHomeSubtitle => 'Impara hadith, dua, i 99 Nomi e altro';

  @override
  String get libraryHubTitle => 'Biblioteca islamica';

  @override
  String get libraryModuleQuran => 'Corano';

  @override
  String get libraryModuleQuranSub => 'Leggi, ascolta e pratica il tajwid';

  @override
  String get libraryModuleHadith => 'Hadith';

  @override
  String get libraryModuleHadithSub => 'Raccolte da fonti autentiche';

  @override
  String get libraryModuleDuas => 'Dua e adhkar';

  @override
  String get libraryModuleDuasSub =>
      'Ricordo del mattino, della sera e quotidiano';

  @override
  String get libraryModulePrayerMethods => 'Preghiera e metodi islamici';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, salah, hajj e altro';

  @override
  String get libraryModuleFiqh => 'Fiqh e tradizioni';

  @override
  String get libraryModuleFiqhSub =>
      'Sunni, sciiti, madhhab, Ahl-e Hadith e altro';

  @override
  String get libraryModuleNames => '99 Nomi di Allah';

  @override
  String get libraryModuleNamesSub => 'Impara e rifletti su Asma ul-Husna';

  @override
  String get libraryModulePillarsIslam => 'Pilastri dell’Islam';

  @override
  String get libraryModulePillarsIslamSub =>
      'I cinque fondamenti della fede in azione';

  @override
  String get libraryModulePillarsIman => 'Pilastri della fede';

  @override
  String get libraryModulePillarsImanSub => 'I sei articoli della credenza';

  @override
  String get libraryModuleProphets => 'Profeta Muhammad';

  @override
  String get libraryModuleProphetsSub =>
      'La sua vita, missione e lezioni senza tempo';

  @override
  String get libraryModuleOccasions => 'Occasioni islamiche';

  @override
  String get libraryModuleOccasionsSub => 'Ramadan, Eid, Hajj e giorni sacri';

  @override
  String get libraryKeyLesson => 'Lezione chiave';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current di $total';
  }

  @override
  String get libraryPrevious => 'Precedente';

  @override
  String get libraryNext => 'Successivo';

  @override
  String get libraryBookmark => 'Segnalibro';

  @override
  String get libraryCopy => 'Copia';

  @override
  String get libraryShare => 'Condividi';

  @override
  String get libraryCopied => 'Copiato negli appunti';

  @override
  String get libraryShareCopiedHint => 'Copiato — incolla per condividere';

  @override
  String get libraryShareReference => 'Riferimento';

  @override
  String get contentShareIntro =>
      'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍';

  @override
  String get contentShareExplore => 'Scopri DeenFocus:';

  @override
  String get contentShareFailed => 'Impossibile condividere ora. Riprova.';

  @override
  String get libraryBookmarkSaved => 'Segnalibro salvato';

  @override
  String get libraryBookmarkRemoved => 'Segnalibro rimosso';

  @override
  String get libraryTranslation => 'Traduzione';

  @override
  String get libraryTransliteration => 'Traslitterazione';

  @override
  String get libraryMeaning => 'Significato';

  @override
  String get libraryBookmarksTitle => 'Elementi di apprendimento salvati';

  @override
  String get libraryBookmarksSubtitle => 'Hadith, dua, nomi, fiqh e altro';

  @override
  String get libraryBookmarksEmpty =>
      'Nessun elemento salvato. Tocca Segnalibro su un elemento di apprendimento per salvarlo qui.';

  @override
  String get libraryMarkCompleted => 'Segna come completato';

  @override
  String get librarySectionCompleted => 'Completato';

  @override
  String get libraryReflection => 'Riflessione';

  @override
  String get libraryComingSoonTitle => 'Prossimamente';

  @override
  String get libraryComingSoonBody =>
      'Questo modulo è in preparazione. Controlla in un aggiornamento futuro.';

  @override
  String get librarySearchHint => 'Cerca…';

  @override
  String get libraryHubSearchHint => 'Cerca in Apprendimento…';

  @override
  String get libraryHubSearchSections => 'Sezioni';

  @override
  String get libraryHubSearchTopics => 'Argomenti';

  @override
  String get librarySearchEmpty => 'Nessun risultato';

  @override
  String libraryItemCount(int count) {
    return '$count elementi';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown di $total';
  }

  @override
  String libraryContinueFrom(int number) {
    return 'Continua · $number';
  }

  @override
  String get libraryInProgress => 'In corso';

  @override
  String libraryReference(String source) {
    return 'Riferimento: $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count dua';
  }

  @override
  String get libraryDuaCategoryMorning => 'Mattina';

  @override
  String get libraryDuaCategoryEvening => 'Sera';

  @override
  String get libraryDuaCategoryDailyLife => 'Vita quotidiana';

  @override
  String get libraryDuaCategorySleep => 'Sonno';

  @override
  String get libraryDuaCategoryFood => 'Cibo';

  @override
  String get libraryDuaCategoryTravel => 'Viaggio';

  @override
  String get libraryDuaCategoryIllness => 'Malattia';

  @override
  String get libraryDuaCategoryProtection => 'Protezione';

  @override
  String get libraryDuaCategoryForgiveness => 'Perdono';

  @override
  String get libraryDuaCategoryParents => 'Genitori';

  @override
  String libraryHadithCount(int count) {
    return '$count hadith';
  }

  @override
  String get libraryHadithNarrator => 'Narratore:';

  @override
  String get libraryHadithSource => 'Fonte:';

  @override
  String get libraryHadithCollectionBukhari => 'Sahih al-Bukhari';

  @override
  String get libraryHadithCollectionMuslim => 'Sahih Muslim';

  @override
  String get libraryHadithCollectionRiyad => 'Riyad us-Saliheen';

  @override
  String get libraryHadithCollectionNawawi => '40 Hadith Nawawi';

  @override
  String get libraryHadithCollectionHisnul => 'Hisnul Muslim';

  @override
  String libraryGuideStepCount(int count) {
    return '$count passi';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Passo $current di $total';
  }

  @override
  String get libraryGuideWudu => 'Wudu';

  @override
  String get libraryGuideSalah => 'Salah';

  @override
  String get libraryGuideGhusl => 'Ghusl';

  @override
  String get libraryGuideTayammum => 'Tayammum';

  @override
  String get libraryGuideJanazah => 'Preghiera funebre';

  @override
  String get libraryGuideUmrah => 'Umrah';

  @override
  String get libraryGuideHajj => 'Hajj';

  @override
  String get libraryGuideFasting => 'Digiuno';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawba';

  @override
  String get libraryOccasionImportance => 'Importanza';

  @override
  String get libraryOccasionVirtues => 'Virtù';

  @override
  String get libraryOccasionRecommendedActs => 'Azioni raccomandate';

  @override
  String get libraryFiqhOverview => 'Panoramica';

  @override
  String get libraryFiqhKeyPoints => 'Punti chiave';

  @override
  String get libraryFiqhDifferences => 'Differenze importanti';

  @override
  String get libraryFiqhCommonGround => 'Punti in comune';

  @override
  String get insightsCompleted => 'Completati';

  @override
  String get insightsInProgress => 'In corso';

  @override
  String get insightsKeepGoingTitle => 'Continua così!';

  @override
  String get insightsKeepGoingBody =>
      'Stai facendo grandi progressi. Ogni preghiera conta.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Traguardi sbloccati';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer =>
      'Hai compiuto la tua prima preghiera.';

  @override
  String get achievementDescSevenPrayerStreak =>
      'Completa 7 preghiere di fila.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Completa 30 preghiere di fila.';

  @override
  String get achievementDescFajrWarrior => 'Prega il Fajr per 14 giorni.';

  @override
  String get achievementDescFajrChampion => 'Prega il Fajr per 30 giorni.';

  @override
  String get achievementDescFiveADay =>
      'Completa tutte e cinque le preghiere in un giorno.';

  @override
  String get achievementDescPerfectWeek =>
      'Completa ogni preghiera per 7 giorni di fila.';

  @override
  String get achievementDescPerfectMonth =>
      'Completa ogni preghiera per 30 giorni di fila.';

  @override
  String get achievementDescQuranReader => 'Leggi il Corano per 7 giorni.';

  @override
  String get achievementDescQuranDevotee => 'Leggi il Corano per 30 giorni.';

  @override
  String get achievementDescDhikrStarter => 'Completa il dhikr per 7 giorni.';

  @override
  String get achievementDescDhikrMaster => 'Completa il dhikr per 30 giorni.';

  @override
  String get achievementDescNightWorshipper =>
      'Prega il Tahajjud per 7 giorni.';

  @override
  String get achievementDescMasjidCompanion => 'Visita la moschea 7 volte.';

  @override
  String get achievementDescDistractionDefender =>
      'Resta senza distrazioni per 7 giorni.';

  @override
  String get achievementDescCycleGuardian =>
      'Proteggi la serie con la modalità ciclo per 7 giorni.';

  @override
  String get achievementDescProtectedMonth =>
      'Proteggi la serie con la modalità ciclo per 30 giorni.';

  @override
  String get achievementDescConsistencyChampion =>
      'Resta costante per 100 giorni.';

  @override
  String get achievementDescSixMonthJourney => 'Continua per 180 giorni.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Raggiungi DeenFocus Master (livello 15).';

  @override
  String get dailyChecklistOptional => 'Facoltativo';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Controlla la rabbia / Parla con gentilezza';

  @override
  String get digitalBalanceTitle => 'Equilibrio digitale';

  @override
  String get digitalBalanceSubtitle => 'Scopri dove va il tuo tempo';

  @override
  String get digitalBalanceViewCta => 'Vedi l\'equilibrio digitale →';

  @override
  String get digitalBalanceTodayLabel => 'Oggi';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Altre app';

  @override
  String get digitalBalanceTodayPhoneTime => 'Tempo telefono di oggi';

  @override
  String get digitalBalanceWhereTimeGoes => 'Dove va il tuo tempo';

  @override
  String get digitalBalanceViewAllApps => 'Vedi tutte le app';

  @override
  String get digitalBalanceAllAppsTitle => 'Tutte le app';

  @override
  String get digitalBalanceNoApps =>
      'Nessun utilizzo delle app registrato oggi.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen vs tempo digitale';

  @override
  String get digitalBalanceYourWeek => 'La tua settimana';

  @override
  String get digitalBalanceThisWeek => 'Questa settimana';

  @override
  String get digitalBalancePhoneUsageLegend => 'Uso del telefono';

  @override
  String get digitalBalanceDailyInsight => 'Nota del giorno';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Ogni minuto che rafforza il tuo Deen conta.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'Il tuo tempo DeenFocus è più alto questa settimana rispetto alla scorsa. MashaAllah!';

  @override
  String get digitalBalanceInsightQuietDay =>
      'Una giornata tranquilla per ora. Il tempo DeenFocus apparirà qui.';

  @override
  String get digitalBalanceGoalTitle => 'Il tuo obiettivo di tempo Deen';

  @override
  String get digitalBalanceAdjustGoal => 'Modifica obiettivo';

  @override
  String get digitalBalanceGoalReached =>
      'Hai raggiunto l\'obiettivo di oggi. MashaAllah!';

  @override
  String get digitalBalanceGoalSheetTitle => 'Tempo Deen quotidiano';

  @override
  String get digitalBalanceGoalCustomHint => 'Minuti al giorno';

  @override
  String get digitalBalanceGoalSave => 'Salva';

  @override
  String get digitalBalanceGoal15 => '15 min';

  @override
  String get digitalBalanceGoal30 => '30 min';

  @override
  String get digitalBalanceGoal45 => '45 min';

  @override
  String get digitalBalanceGoal60 => '1 ora';

  @override
  String get digitalBalancePermissionTitle =>
      'Comprendi le tue abitudini digitali';

  @override
  String get digitalBalancePermissionBody =>
      'Consenti a DeenFocus di accedere all\'uso delle app per vedere dove va il tuo tempo e quanto ne dai al tuo Deen.';

  @override
  String get digitalBalanceEnableUsage => 'Attiva uso delle app';

  @override
  String get digitalBalanceMaybeLater => 'Forse più tardi';

  @override
  String get digitalBalanceUnavailableTitle =>
      'L\'uso delle app non è disponibile qui';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple non condivide Tempo di utilizzo con altre app, quindi Digital Balance non può ancora mostrare l\'uso iPhone. Preghiere, serie e insight funzionano come sempre.';

  @override
  String get digitalBalanceInfoTitle =>
      'Informazioni sull\'equilibrio digitale';

  @override
  String get digitalBalanceInfoBody =>
      'L\'equilibrio digitale ti aiuta a vedere dove va il tuo tempo e quanto ne dai al tuo Deen. L\'uso resta sul dispositivo.';

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
    return 'DeenFocus · $percent% del tempo telefono';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% del tuo tempo telefono';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% del tempo telefono di oggi';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% di tempo DeenFocus in più rispetto alla scorsa settimana';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'Hai trascorso $duration in DeenFocus oggi. Continua l\'abitudine.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'Il tuo tempo DeenFocus è aumentato del $percent% rispetto a ieri.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / giorno';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return '$minutes minuti per raggiungere l\'obiettivo di oggi';
  }

  @override
  String get tajweedPracticeTitle => 'Pratica del tajweed';

  @override
  String tajweedPracticeAyahTitle(String surah, String ref) {
    return '$surah · $ref';
  }

  @override
  String get tajweedDownloadTitle => 'Preparazione del modello IA';

  @override
  String get tajweedDownloadFailedTitle =>
      'Impossibile preparare il modello IA';

  @override
  String get tajweedDownloadBody =>
      'Download una tantum così la pratica del tajweed funziona poi completamente offline. Succede solo una volta.';

  @override
  String get tajweedDownloadFinishing => 'Completamento della configurazione…';

  @override
  String get tajweedDownloadCanLeave =>
      'Puoi lasciare questa schermata: il download continua in background.';

  @override
  String get tajweedDownloadTryAgain => 'Riprova';

  @override
  String get tajweedDownloadPleaseTryAgain => 'Riprova.';

  @override
  String get tajweedErrorFeatureDisabled =>
      'La pratica tajweed IA è disattivata. Attivala prima nelle Impostazioni.';

  @override
  String get tajweedErrorModelMissing =>
      'Il modello IA non è ancora installato.';

  @override
  String get tajweedErrorModelDownloadFailed =>
      'Download del modello IA non riuscito. Controlla la connessione e riprova.';

  @override
  String get tajweedErrorModelLoadFailed =>
      'Impossibile caricare il modello IA su questo dispositivo.';

  @override
  String get tajweedErrorCouldNotPrepare =>
      'Impossibile preparare il modello IA.';

  @override
  String get tajweedErrorUnsupported =>
      'La pratica tajweed IA non è disponibile su questo dispositivo.';

  @override
  String get sharePromoTitle => 'Guarda questo su DeenFocus 🌙';

  @override
  String get sharePromoBody =>
      'Un’app semplice per restare concentrato sul tuo Deen, pregare in orario e costruire abitudini migliori.';

  @override
  String get sharePromoDownloadHeading => 'Scarica DeenFocus:';

  @override
  String sharePromoAppStoreLine(String url) {
    return '🍎 App Store: $url';
  }

  @override
  String sharePromoPlayStoreLine(String url) {
    return '🤖 Google Play: $url';
  }

  @override
  String get shareBrandName => 'DeenFocus';

  @override
  String get shareBrandTagline =>
      'Il tuo compagno per un Deen migliore, ogni giorno.';

  @override
  String get shareDownloadCta => 'Scarica DeenFocus';

  @override
  String get shareAppStoreBadge => 'App Store';

  @override
  String get sharePlayStoreBadge => 'Google Play';

  @override
  String get shareFailed => 'Impossibile condividere. Riprova.';

  @override
  String insightsRatio(int done, int possible) {
    return '$done / $possible';
  }

  @override
  String insightsCompactRatio(int done, int possible) {
    return '$done/$possible';
  }

  @override
  String insightsPercent(int value) {
    return '$value%';
  }

  @override
  String insightsFocusScoreValue(int score) {
    return '$score / 100';
  }

  @override
  String insightsWeekNumber(int week) {
    return 'S$week';
  }

  @override
  String get insightsLevelName1 => 'Nuovo inizio';

  @override
  String get insightsLevelName2 => 'Primi passi';

  @override
  String get insightsLevelName3 => 'Costruire l’abitudine';

  @override
  String get insightsLevelName4 => 'Orante costante';

  @override
  String get insightsLevelName5 => 'Cuore costante';

  @override
  String get insightsLevelName6 => 'Custode della preghiera';

  @override
  String get insightsLevelName7 => 'Servo dedicato';

  @override
  String get insightsLevelName8 => 'Routine solida';

  @override
  String get insightsLevelName9 => 'Orante devoto';

  @override
  String get insightsLevelName10 => 'Saldo';

  @override
  String get insightsLevelName11 => 'Fede più profonda';

  @override
  String get insightsLevelName12 => 'Forte costanza';

  @override
  String get insightsLevelName13 => 'Guida nella devozione';

  @override
  String get insightsLevelName14 => 'Costanza eccezionale';

  @override
  String get insightsLevelName15 => 'DeenFocus Master';

  @override
  String get lockScreenOptionsTitle => 'Stile schermata di blocco';

  @override
  String get lockScreenOptionsSubtitle =>
      'Scegli come appaiono i promemoria di preghiera';

  @override
  String get lockScreenOptionsHint =>
      'Tocca uno stile per aprire il layout a schermo intero.';

  @override
  String get lockScreenDefaultBadge => 'Predefinito';

  @override
  String get lockScreenSelectedBadge => 'Selezionato';

  @override
  String get lockScreenPreviewLabel => 'Anteprima';

  @override
  String get lockScreenStyleClassic => 'Promemoria di preghiera';

  @override
  String get lockScreenStyleTasbih => 'Contatore tasbih';

  @override
  String get lockScreenStyleVerse => 'Versetto del giorno';

  @override
  String get lockScreenStyleDua => 'Du\'a del giorno';

  @override
  String get lockScreenStyleQuiz => 'Verifica delle conoscenze';

  @override
  String get lockScreenStyleTimes => 'Orari di preghiera';

  @override
  String get lockScreenStyleCountdown => 'Conto alla rovescia';

  @override
  String get lockScreenStyleHold => 'Tieni premuto per confermare';

  @override
  String get lockScreenStyleType => 'Digita per confermare';

  @override
  String get lockScreenStyleMinimal => 'Focus minimale';

  @override
  String get lockScreenItsTimeToPray => 'È ora di pregare:';

  @override
  String lockScreenRemainingTime(String time) {
    return 'Tempo rimanente: $time';
  }

  @override
  String get lockScreenRemindLater => 'Ricordamelo più tardi';

  @override
  String get lockScreenNextVerse => 'Versetto successivo';

  @override
  String get lockScreenVerseForToday => 'Versetto di oggi';

  @override
  String get lockScreenDuaForToday => 'Du\'a di oggi';

  @override
  String get lockScreenTapToCount => 'Tocca ovunque per contare';

  @override
  String get lockScreenHoldHint => 'Tieni premuto per confermare';

  @override
  String lockScreenTypeHint(String word) {
    return 'Digita $word per confermare';
  }

  @override
  String get lockScreenTypeWord => 'ALHAMDULILLAH';

  @override
  String get lockScreenConfirmBeforeAllah =>
      'Conferma davanti ad Allah di aver pregato.';

  @override
  String get lockScreenQuizCategory => 'Preghiera';

  @override
  String get lockScreenQuizQuestion =>
      'Quante preghiere quotidiane sono obbligatorie?';

  @override
  String get lockScreenQuizA => 'Tre';

  @override
  String get lockScreenQuizB => 'Quattro';

  @override
  String get lockScreenQuizC => 'Cinque';

  @override
  String get lockScreenQuizCorrect => 'Corretto';

  @override
  String get lockScreenQuizIncorrect => 'Errato';

  @override
  String get lockScreenQuizComplete => 'Verifica delle conoscenze completata';

  @override
  String get lockScreenQuizCategoryFasting => 'Digiuno';

  @override
  String get lockScreenQuizCategoryPillars => 'Pilastri';

  @override
  String get lockScreenQuizQ2 => 'In quale mese digiunano i musulmani?';

  @override
  String get lockScreenQuizQ2A => 'Shawwal';

  @override
  String get lockScreenQuizQ2B => 'Ramadan';

  @override
  String get lockScreenQuizQ2C => 'Muharram';

  @override
  String get lockScreenQuizQ3 => 'Qual è il primo pilastro dell\'Islam?';

  @override
  String get lockScreenQuizQ3A => 'Salah';

  @override
  String get lockScreenQuizQ3B => 'Shahada';

  @override
  String get lockScreenQuizQ3C => 'Hajj';

  @override
  String get lockScreenTimeUp => 'Tempo scaduto';

  @override
  String get lockScreenHoldRelease =>
      'Continua a tenere premuto per confermare';

  @override
  String lockScreenCountProgress(int current, int total) {
    return '$current di $total';
  }

  @override
  String get lockScreenVerseTranslation =>
      'Ricordatevi di Me, Io Mi ricorderò di voi.';

  @override
  String get lockScreenVerseRef => 'Corano 2:152';

  @override
  String get lockScreenDuaTransliteration => 'Rabbana atina fid-dunya hasanah';

  @override
  String get lockScreenDuaTranslation =>
      'Signore nostro, donaci un bene in questa vita e un bene nell\'Aldilà.';

  @override
  String get lockScreenDuaSource => 'Al-Baqara 2:201';

  @override
  String get lockScreenSampleRemaining => '2h 34m';

  @override
  String get lockScreenDhikrAstaghfirullah => 'Astaghfirullah';

  @override
  String get lockScreenDhikrSubhanAllah => 'SubhanAllah';

  @override
  String get lockScreenDhikrAlhamdulillah => 'Alhamdulillah';

  @override
  String get lockScreenDhikrAllahuAkbar => 'Allahu Akbar';
}
