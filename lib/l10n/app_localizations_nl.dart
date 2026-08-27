// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'Vertrouwen. Focus. Samenhang';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Gebedsmodus. Kindmodus. Slaapmodus.';

  @override
  String get welcomeDescription =>
      'Houd uw gebeden bij, lees de Koran, tel Tasbih en bouw betekenisvolle streaks op - allemaal op één plek.';

  @override
  String get skip => 'Overslaan';

  @override
  String get notNow => 'Niet nu';

  @override
  String get continueButton => 'Doorgaan';

  @override
  String get continueForFree => 'Misschien later — verken eerst de app';

  @override
  String get getStarted => 'Start mijn 7-dagen gratis proefperiode';

  @override
  String get language => 'Taal';

  @override
  String get cancel => 'Annuleren';

  @override
  String get ok => 'OK';

  @override
  String get openSettings => 'Instellingen openen';

  @override
  String get locationRequired => 'Locatie vereist';

  @override
  String get locationRequiredMessage =>
      'Locatietoegang is vereist om nauwkeurige gebedstijden en Qibla-richting te berekenen. U moet dit inschakelen om de app te kunnen gebruiken.';

  @override
  String get notificationsRequired => 'Meldingen vereist';

  @override
  String get notificationsRequiredMessage =>
      'Meldingen zijn vereist om waarschuwingen en herinneringen voor gebedstijd te ontvangen.';

  @override
  String get sectTitle => 'Kies uw sekte';

  @override
  String get sectSubtitle => 'Dit helpt ons uw ervaring te personaliseren';

  @override
  String get sectSunni => 'Soennieten';

  @override
  String get sectShia => 'Sjiieten';

  @override
  String get sectPreferNotToSay => 'Zeg het liever niet';

  @override
  String get nameTitle => 'Wat is jouw naam?';

  @override
  String get nameSubtitle => 'Laten we uw begroeting personaliseren';

  @override
  String get namePlaceholder => 'Jouw naam';

  @override
  String get locationTitle => 'Vind je Qibla';

  @override
  String get locationSubtitle =>
      'Schakel locatie in voor nauwkeurige Qibla, gebedstijden en moskeeën in de buurt.';

  @override
  String get locationButton => 'Locatietoegang toestaan';

  @override
  String get locationManualEntry => 'Voer je stad handmatig in';

  @override
  String get locationOrDivider => 'of';

  @override
  String get locationPrivacyNote => 'Blijft op je apparaat';

  @override
  String get locationFeaturePrayerTimesTitle => 'Gebedstijden';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Moskeeën';

  @override
  String get notificationsTitle => 'Mis geen enkel gebed';

  @override
  String get notificationsSubtitle =>
      'Adhan-meldingen, focusherinneringen en dagelijkse dhikr — precies wanneer je ze nodig hebt.';

  @override
  String get notificationsButton => 'Meldingen inschakelen';

  @override
  String get notificationsMaybeLater => 'Misschien later';

  @override
  String get notificationsEnabled => 'Meldingen zijn ingeschakeld';

  @override
  String get notificationsPreviewDate => 'Vrijdag 10 juli';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'nu';

  @override
  String get notificationsPreviewMinutesAgo => '2 min geleden';

  @override
  String get notificationsPreviewHourAgo => '1 uur geleden';

  @override
  String get notificationsPreviewAdhanTitle => 'Maghrib-adhan';

  @override
  String get notificationsPreviewAdhanBody => 'Het is tijd om te bidden.';

  @override
  String get notificationsPreviewDhikrTitle => 'Dagelijkse dhikr';

  @override
  String get notificationsPreviewDhikrBody => 'SubhanAllah — neem een moment.';

  @override
  String get notificationsPreviewStreakTitle => 'Reeks';

  @override
  String get notificationsPreviewStreakBody => '7 dagen volledige gebeden.';

  @override
  String get screenTimeTitle => 'Schermtijd inschakelen';

  @override
  String get screenTimeSubtitle =>
      'Hiermee kan Deen Focus afleidende apps pauzeren tijdens Salah, slaaptijd en kindermodus.';

  @override
  String get screenTimeButton => 'Toegang tot Schermtijd toestaan';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus leest nooit je gegevens — het pauzeert alleen de apps die je kiest.';

  @override
  String get onboardingSelectAppsTitlePrefix => 'Selecteer';

  @override
  String get onboardingSelectAppsTitleAccent => 'apps om te vergrendelen';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Selecteer de apps die je wilt vergrendelen tijdens gebedstijd.';

  @override
  String get onboardingSelectAppsButton => 'Apps selecteren';

  @override
  String get onboardingSelectAppsSkipForNow => 'Nu overslaan';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'Jij hebt de controle';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'We lezen je gegevens nooit. We vergrendelen alleen de apps die jij kiest.';

  @override
  String get onboardingSelectAppsMockAllApps => 'Alle apps & categorieën';

  @override
  String get onboardingSelectAppsMockPhotos => 'Foto’s';

  @override
  String get onboardingSelectAppsMockNotes => 'Notities';

  @override
  String get onboardingSelectAppsMockMusic => 'Muziek';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => 'Podcasts';

  @override
  String screenTimeStepOf(int current, int total) {
    return 'STAP $current VAN $total';
  }

  @override
  String get screenTimeStep1Title => 'Open de Schermtijd-prompt';

  @override
  String get screenTimeStep1Body =>
      'Tik op ‘Toegang tot Schermtijd toestaan’ — je apparaat toont zijn eigen toestemmingsverzoek.';

  @override
  String get screenTimeStep2Title => 'Tik op Doorgaan, dan Toestaan';

  @override
  String get screenTimeStep2Body =>
      'Keur het verzoek goed zodat Deen Focus apps op het juiste moment kan pauzeren.';

  @override
  String get screenTimeStep3Title => 'Kies apps om te vergrendelen';

  @override
  String get screenTimeStep3Body =>
      'Kies de apps die je het meest afleiden — social, games, video, wat je wilt.';

  @override
  String get screenTimeStep4Title => 'Je bent beschermd';

  @override
  String get screenTimeStep4Body =>
      'Apps vergrendelen automatisch tijdens Salah, slaaptijd en kindermodus.';

  @override
  String get screenTimePromptTitle => 'Schermtijd';

  @override
  String screenTimePromptMessage(String appName) {
    return '‘$appName’ wil toegang tot Schermtijd';
  }

  @override
  String get screenTimeDontAllow => 'Niet toestaan';

  @override
  String get screenTimePromptContinue => 'Doorgaan';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Games';

  @override
  String get screenTimeAndroidStep1Title => 'Open Gebruikstoegang';

  @override
  String get screenTimeAndroidStep1Body =>
      'Tik op ‘Toegang tot Schermtijd toestaan’ — je apparaat opent Gebruikstoegang voor Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Toegankelijkheid inschakelen';

  @override
  String get screenTimeAndroidStep2Body =>
      'Schakel de Deen Focus-service in zodat apps pauzeren tijdens Salah, slaap en kindermodus.';

  @override
  String get screenTimeAndroidStep3Title => 'Kies apps om te vergrendelen';

  @override
  String get screenTimeAndroidStep3Body =>
      'Kies de apps die je het meest afleiden — social, games, video, wat je wilt.';

  @override
  String get screenTimeAndroidStep4Title => 'Je bent beschermd';

  @override
  String get screenTimeAndroidStep4Body =>
      'Apps vergrendelen automatisch tijdens Salah, slaaptijd en kindermodus.';

  @override
  String get screenTimeAndroidUsageTitle => 'Gebruikstoegang';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Sta Deen Focus toe te zien welke andere apps worden gebruikt.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Toegankelijkheid';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus heeft Toegankelijkheid nodig om afleidende apps te pauzeren tijdens focussessies.';

  @override
  String get screenTimeAndroidPermit => 'Toestaan';

  @override
  String get screenTimeAndroidEnable => 'Inschakelen';

  @override
  String get screenTimeAndroidNotNow => 'Niet nu';

  @override
  String get focusModesTitle => 'Alles in één app';

  @override
  String get focusModesSubtitle =>
      'Ontdek alles wat Deen Focus te bieden heeft. Tik op een focusmodus om te zien hoe het werkt.';

  @override
  String get onboardingWidgetsLiveTitle =>
      'Je gebeden, altijd binnen handbereik';

  @override
  String get onboardingWidgetsLiveSubtitle =>
      'Blijf verbonden met wat het meest telt — vanaf je beginscherm of vergrendelscherm.';

  @override
  String get onboardingWidgetsSectionTitle => 'Widgets';

  @override
  String get onboardingWidgetsSectionBodyPrefix =>
      'Bekijk je volgende gebed, reeksen en voortgang ';

  @override
  String get onboardingWidgetsSectionBodyEmphasis => 'in één oogopslag.';

  @override
  String get onboardingLiveActivitiesSectionTitle => 'Live Activity';

  @override
  String get onboardingLiveActivitiesSectionBodyPrefix =>
      'Bekijk aankomende gebedsupdates in ';

  @override
  String get onboardingLiveActivitiesSectionBodyEmphasis => 'realtime';

  @override
  String get onboardingLiveActivitiesSectionBodySuffix =>
      ' op je vergrendelscherm en Dynamic Island.';

  @override
  String get onboardingWidgetsLiveTrustPrefix => 'Ontworpen om je te helpen ';

  @override
  String get onboardingWidgetsLiveTrustEmphasis => 'consistent';

  @override
  String get onboardingWidgetsLiveTrustSuffix =>
      ' te blijven en nooit te missen wat het meest telt.';

  @override
  String get onboardingWidgetsMockStreak => 'Reeks';

  @override
  String get onboardingWidgetsMockStreakValue => '12 dagen';

  @override
  String get onboardingWidgetsMockFocus => 'Focus';

  @override
  String get onboardingWidgetsMockFocusValue => '25 min';

  @override
  String get onboardingWidgetsLiveLockDate => 'Dinsdag 6 mei';

  @override
  String get onboardingWidgetsLiveLockTime => '9:41';

  @override
  String get onboardingWidgetsLiveNextPrayer => 'Dhuhr 12:45, over 02:15:32';

  @override
  String get focusModesSectionLabel => 'FOCUSMODI · TIK VOOR MEER';

  @override
  String get focusPrayerTrackingSectionLabel => 'GEBED & TRACKING';

  @override
  String get focusLearningHubSectionLabel => 'LEERHUB';

  @override
  String get focusMoreSectionLabel => 'MEER';

  @override
  String get focusPrayerModeTitle => 'Gebedsmodus';

  @override
  String get focusPrayerModeDescription =>
      'Blokkeer afleidende apps automatisch tijdens Salah zodat je met volle khushu kunt bidden.';

  @override
  String get focusPrayerModeBullet1 => 'Vergrendelt apps op gebedstijd';

  @override
  String get focusPrayerModeBullet2 => 'Ontgrendelt wanneer je klaar bent';

  @override
  String get focusPrayerModeBullet3 => 'Bouwt focus en consistentie op';

  @override
  String get focusSleepModeTitle => 'Slaapmodus';

  @override
  String get focusSleepModeDescription =>
      'Kom tot rust op een halal manier. Blokkeer apps bij bedtijd zodat je goed rust en wakker wordt voor Fajr.';

  @override
  String get focusSleepModeBullet1 => 'Blokkeert apps automatisch bij bedtijd';

  @override
  String get focusSleepModeBullet2 => 'Zachte Fajr-wekkers';

  @override
  String get focusSleepModeBullet3 => 'Beschermt je slaap en Fajr';

  @override
  String get focusChildModeTitle => 'Kindmodus';

  @override
  String get focusChildModeDescription =>
      'Geef je je telefoon aan je kind? Vergrendel apps direct zodat ze alleen zien wat veilig is.';

  @override
  String get focusChildModeBullet1 => 'Veilige modus met één tik';

  @override
  String get focusChildModeBullet2 => 'Uitgang beschermd met toegangscode';

  @override
  String get focusChildModeBullet3 => 'Gersteld gevoel, elke keer';

  @override
  String get focusModeGotIt => 'Begrepen';

  @override
  String get focusFeaturePrayerTimesTitle => 'Nauwkeurige gebedstijden';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan & herinneringen';

  @override
  String get focusFeatureStreaksTitle => 'Reeksen';

  @override
  String get focusFeatureStreaksSubtitle => 'Blijf consistent';

  @override
  String get focusFeatureChecklistTitle => 'Dagelijkse checklist';

  @override
  String get focusFeatureChecklistSubtitle => 'Bouw goede gewoontes';

  @override
  String get focusFeatureQiblaTitle => 'Qibla & moskee';

  @override
  String get focusFeatureQiblaSubtitle => 'Richting & moskeeën';

  @override
  String get focusFeatureQuranTitle => 'Koran';

  @override
  String get focusFeatureQuranSubtitle => 'Vertalingen, djoez & pagina\'s';

  @override
  String get focusFeatureHadithTitle => 'Hadith';

  @override
  String get focusFeatureHadithSubtitle => 'Authentieke verzamelingen';

  @override
  String get focusFeatureDuasTitle => 'Dua\'s';

  @override
  String get focusFeatureDuasSubtitle => 'Dagelijkse smeekbeden';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Digitale dhikr-teller';

  @override
  String get focusFeatureAiTitle => 'AI-metgezel';

  @override
  String get focusFeatureAiSubtitle => 'Stel vragen over je din';

  @override
  String get focusFeatureInsightsTitle => 'Inzichten';

  @override
  String get focusFeatureInsightsSubtitle =>
      'Wekelijkse & maandelijkse statistieken';

  @override
  String get investTitle => 'Investeer in Deen';

  @override
  String get investSubtitle =>
      'De beste investering zit niet in wat verdwijnt — maar in wat je dichter bij Allah brengt. Probeer alles 7 dagen gratis.';

  @override
  String get investPremiumUnlocked => 'PREMIUM ONTGRENDELD';

  @override
  String get investTrialPill =>
      '✨ 7 dagen gratis — annuleer wanneer je wilt vóór het einde';

  @override
  String get investNoCommitment => 'Geen verplichtingen. Altijd opzegbaar.';

  @override
  String get investFeatureAiTitle => 'AI islamitische assistent';

  @override
  String get investFeatureAiBody =>
      'Vraag alles over je Deen — antwoorden gebaseerd op authentieke bronnen.';

  @override
  String get investFeaturePrayerModeTitle => 'Volledig scherm gebedsmodus';

  @override
  String get investFeaturePrayerModeBody =>
      'Een kalm, afleidingsvrij scherm dat je naar de Salah roept.';

  @override
  String get investFeatureAppBlockingTitle => 'Geavanceerde app-blokkering';

  @override
  String get investFeatureAppBlockingBody =>
      'Gedetailleerde controle over welke apps vergrendelen en precies wanneer.';

  @override
  String get investFeatureNightModeTitle => 'Nachtelijke discipline-modus';

  @override
  String get investFeatureNightModeBody =>
      'Op tijd tot rust komen, beter slapen en wakker worden voor Fajr.';

  @override
  String get investFeaturePlannerTitle => 'Gebedsplanner & voortgang';

  @override
  String get investFeaturePlannerBody =>
      'Reeksen, inzichten en journals die je consistent houden.';

  @override
  String get investFeatureToolsTitle => 'Exclusieve islamitische tools';

  @override
  String get investFeatureToolsBody =>
      'Hidjri-kalender, dua\'s, tasbih, 99 Namen en meer.';

  @override
  String get investFeatureThemesTitle => 'Premium thema\'s & updates';

  @override
  String get investFeatureThemesBody =>
      'Mooie thema\'s plus elke nieuwe functie die we uitbrengen.';

  @override
  String get investFeatureTajweedTitle => 'Beheers Tajweed';

  @override
  String get investFeatureTajweedBody =>
      'Verbeter je recitatie met begeleide lessen en realtime feedback.';

  @override
  String get socialProofPrefix => 'Sluit je aan bij ';

  @override
  String get socialProofHighlight => '10.000+';

  @override
  String get socialProofSuffix => ' moslims die groeien met DeenFocus';

  @override
  String get mostPopular => 'Meest populair';

  @override
  String get monthlyLabel => 'Maandelijks';

  @override
  String get yearlyLabel => 'Jaarlijks';

  @override
  String get lifetimeLabel => 'Levensduur';

  @override
  String get featureNoAds => 'Verwijdert alle advertenties';

  @override
  String get featureSupport => 'Prioritaire ondersteuning';

  @override
  String get homeTitle => 'Deenly Thuis';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback => 'Met ontberingen komt inderdaad gemak.';

  @override
  String get homeAppsLocked => 'Apps vergrendeld';

  @override
  String get homeAppsUnlocked => 'Apps ontgrendeld';

  @override
  String get homeTapToUnlock => 'Tik om apps tijdelijk te ontgrendelen';

  @override
  String get homeTapToRelock =>
      'Tik om geblokkeerde apps nu opnieuw te vergrendelen';

  @override
  String get homeRelock => 'Opnieuw vergrendelen';

  @override
  String get homeUnlock => 'Ontgrendelen';

  @override
  String get homePrayerModeActive => 'Gebedsmodus actief';

  @override
  String get homeActivatePrayerMode => 'Activeer de gebedsmodus';

  @override
  String get homeAppsBlockedSubtitle =>
      'Apps zijn geblokkeerd. Tik om te deactiveren.';

  @override
  String get homeBlockDistractingApps =>
      'Blokkeer afleidende apps tijdens Salah.';

  @override
  String get homeQiblaDirection => 'Qibla-richting';

  @override
  String get homeLocationMissingForQibla =>
      'Schakel locatie in om de Qibla-richting te berekenen.';

  @override
  String get homeQiblaSubtitleGuiding => 'Ik begeleid je naar de Qibla';

  @override
  String get homeToMakkah => 'naar Mekka';

  @override
  String get homeFindMasjid => 'Vind moskee bij mij in de buurt';

  @override
  String get quickActionsMasjidFinder => 'Moskeezoeker';

  @override
  String get homeSearchNearbyMosques =>
      'Vind moskeeën in de buurt via OpenStreetMap.';

  @override
  String get homePrayerStreak => 'Gebedsreeksen';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Inzichten';

  @override
  String get homeOpenStreakDetails => 'Open streak-details.';

  @override
  String get homeTodaysPrayers => 'De gebeden van vandaag';

  @override
  String get homePrayerTimesUnavailable =>
      'Gebedstijden zijn momenteel niet beschikbaar.';

  @override
  String get homeNextPrayerIn => 'Volgende gebed binnen';

  @override
  String get homeTapPrayerToMark =>
      'Tik op een gebed om het te markeren als gebeden, qada of gemist.';

  @override
  String get homeSetLocation => 'Locatie instellen';

  @override
  String get homeEditPrayerSettings => 'Gebedsinstellingen bewerken';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Zonsopgang';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Maghreb';

  @override
  String get homePrayerIsha => 'Isja';

  @override
  String get homeWeek => 'Week';

  @override
  String get homeMonth => 'Maand';

  @override
  String get homeThisWeek => 'Hoogtepunten van Deen deze week';

  @override
  String get homeJummahMubarak => 'Jummah Moebarak';

  @override
  String get homeJummahReminder => 'Vergeet Surah Al-Kahf niet.';

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
  String get calendarTitle => 'Islamitische kalender';

  @override
  String get calendarBack => 'Terug';

  @override
  String get calendarToday => 'Vandaag';

  @override
  String get calendarTomorrow => 'Morgen';

  @override
  String calendarDaysAway(int days) {
    return '$days dagen';
  }

  @override
  String get calendarNoEventsThisWeek =>
      'Geen islamitische gebeurtenissen deze week.';

  @override
  String get calendarNoEventsBlessing =>
      'Moge Allah je week zegenen met vrede en goedheid.';

  @override
  String get calendarNoUpcomingEvents =>
      'Geen aankomende islamitische gebeurtenissen gevonden.';

  @override
  String get calendarUpcomingEvents => 'Aankomende islamitische gebeurtenissen';

  @override
  String get calendarUpcomingThisYear => 'Aankomend dit jaar';

  @override
  String get calendarThisWeekObservances => 'Deze week';

  @override
  String get calendarLegendCycleDays => 'Cyclusdagen (reeks beschermd)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% verlicht';
  }

  @override
  String get calendarMoonNew => 'Nieuwe maan';

  @override
  String get calendarMoonWaxingCrescent => 'Wassende sikkel';

  @override
  String get calendarMoonFirstQuarter => 'Eerste kwartier';

  @override
  String get calendarMoonWaxingGibbous => 'Wassende maan';

  @override
  String get calendarMoonFull => 'Volle maan';

  @override
  String get calendarMoonWaningGibbous => 'Afnemende maan';

  @override
  String get calendarMoonLastQuarter => 'Laatste kwartier';

  @override
  String get calendarMoonWaningCrescent => 'Afnemende sikkel';

  @override
  String get calendarEventRamadanBegins => 'Ramadan begint';

  @override
  String get calendarEventRamadanBeginsDesc => 'Maand van vasten';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Nacht van de Beschikking';

  @override
  String get calendarEventEidAlFitr => 'Eid al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc =>
      'Feest van het verbreken van het vasten';

  @override
  String get calendarEventDayOfArafah => 'Dag van Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Dag van staan op Arafah';

  @override
  String get calendarEventEidAlAdha => 'Eid al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Offerfeest';

  @override
  String get calendarEventIslamicNewYear => 'Islamitisch Nieuwjaar';

  @override
  String get calendarEventIslamicNewYearDesc => '1 Muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Geboorte van de Profeet';

  @override
  String get calendarEventAshura => 'Ashura';

  @override
  String get calendarEventAshuraDesc => '10 Muharram';

  @override
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Vrijdaggebed in congregatie';

  @override
  String get calendarEventWhiteDays => 'Witte dagen';

  @override
  String get calendarEventWhiteDaysDesc => 'Aanbevolen vastendagen';

  @override
  String get cycleModeActiveTitle =>
      '„Allah wil voor jullie gemak en wil voor jullie geen moeilijkheid.” — Koran 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'In deze periode is je reeks beschermd. Cyclusdagen zijn roze gemarkeerd en Cyclusmodus schakelt automatisch uit wanneer de cyclus eindigt.';

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
      other: 'Eindigt automatisch over $days dagen',
      one: 'Eindigt automatisch morgen',
      zero: 'Eindigt vandaag',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeSettingsTitle => 'Cyclusmodus';

  @override
  String get cycleModeStartDateLabel => 'Startdatum';

  @override
  String get cycleModeLengthLabel => 'Cyclusduur';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '1 dag',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Reeksen pauzeren';

  @override
  String get cycleModeExcludeFromStatisticsLabel =>
      'Uitsluiten van statistieken';

  @override
  String get cycleModeSaveButton => 'Opslaan';

  @override
  String get cycleModeEditButton => 'Bewerken';

  @override
  String get cycleModeChangeStartDateTitle => 'Startdatum wijzigen?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Als je de startdatum wijzigt, wordt het actieve Cyclusmodus-venster herberekend. Dagen buiten het nieuwe bereik worden mogelijk niet meer als cyclusdagen behandeld.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Startdatum wijzigen';

  @override
  String prayerReminderTitle(String prayer) {
    return 'Heb je $prayer gebeden?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Houd je reeks levend door je gebed te loggen.';

  @override
  String get prayerReminderYesButton => 'Ja, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'Ik markeer later';

  @override
  String get prayerNotificationSubtitleFajr =>
      '“Voorwaar, de recitatie van de dageraad wordt altijd bijgewoond.” — Koran 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '“Verricht het gebed bij het dalen van de zon...” — Koran 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '“Waak strikt over de gebeden, vooral het middelste gebed.” — Koran 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '“Verheerlijk Allah dus wanneer jullie de avond bereiken...” — Koran 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '“Verricht het gebed -  tot de duisternis van de nacht.” — Koran 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'Het is tijd voor $prayerName';
  }

  @override
  String get homeTrialBannerTitle =>
      '7 dagen gratis — word een betere moslim ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Alle functies ontgrendeld. Begin vandaag je reis.';

  @override
  String get homeFocusModeTitle => 'Focusmodus';

  @override
  String get homeFocusModeSubtitle => 'Blokkeer afleidende apps tijdens Salah';

  @override
  String get homeLivePrayerUpdatesTitle => 'Live gebedsupdates';

  @override
  String get homeLivePrayerUpdatesBody =>
      'Zie je huidige en volgende gebed op het vergrendelscherm & Dynamic Island.';

  @override
  String get homeLivePrayerUpdatesCta => 'Live-updates inschakelen';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Nacht';

  @override
  String get focusModeShortChild => 'Kind';

  @override
  String get focusModeLabelSalah => 'Salah-modus';

  @override
  String get focusModeLabelNight => 'Nachtmodus';

  @override
  String get focusModeLabelChild => 'Kindmodus';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return '$first- en $second-modi zijn ingeschakeld';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return '$first-, $second- en $third-modi zijn ingeschakeld';
  }

  @override
  String get cycleModeTitle => 'Cyclusmodus';

  @override
  String get cycleModeSubtitle =>
      'Voor menstruatie — pauzeer gebeden, behoud je reeks';

  @override
  String get dailyChecklistTitle => 'Dagelijkse checklist';

  @override
  String get dailyChecklistSubtitle => 'Volg je dagelijkse spirituele doelen';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed van $total voltooid';
  }

  @override
  String get dailyChecklistSectionPrayer => 'Gebed';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Koran & Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Goede daden';

  @override
  String get dailyChecklistSectionDistraction => 'Persoonlijke discipline';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Koran';

  @override
  String get dailyChecklistMorningAdhkar => 'Ochtend-adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Avond-adhkar';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Liefdadigheid';

  @override
  String get dailyChecklistSmileAtSomeone => 'Glimlach naar iemand';

  @override
  String get dailyChecklistFamilyCall => 'Familie bellen';

  @override
  String get dailyChecklistNoMusicToday => 'Vandaag geen muziek';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'Geen social media voor Isha';

  @override
  String get focusScoreTitle => 'Focusscore van vandaag';

  @override
  String get focusScorePrayer => 'Gebed';

  @override
  String get focusScoreQuran => 'Koran';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Afleidingscontrole';

  @override
  String get insightsBack => 'Terug';

  @override
  String get insightsTitle => 'Mijn inzichten';

  @override
  String get insightsSubtitle => 'Volg je Deen-voortgang';

  @override
  String get insightsPrayerRate => 'Gebedspercentage';

  @override
  String get insightsDayStreak => 'Dagreeks';

  @override
  String get insightsBestStreak => 'Beste reeks';

  @override
  String get insightsWeekly => 'Wekelijks';

  @override
  String get insightsMonthly => 'Maandelijks';

  @override
  String get insightsPrayersCompleted => 'Voltooide gebeden';

  @override
  String get insightsRestoreStreak => 'Herstel mijn reeks — laatste 24 uur';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Gebed $prayerPercent% · Koran $quranPercent% · Dhikr $dhikrPercent% · Afleiding $distractionPercent%';
  }

  @override
  String get quickActionsCalendar => 'Kalender';

  @override
  String get quickActionsCalendarSubtitle => 'Islamitische datums bekijken';

  @override
  String get quickActionsSupportUs => 'Steun ons';

  @override
  String get quickActionsSupportUsSubtitle => 'Help ons groeien';

  @override
  String get quickActionsSupportUsMessage =>
      'Bedankt dat je DeenFocus wilt steunen! Ondersteuningsfuncties komen binnenkort.';

  @override
  String get supportUsTitle => 'Steun DeenFocus';

  @override
  String get supportUsHeroTitle => 'Steun DeenFocus';

  @override
  String get supportUsHeroBody =>
      'Jouw steun helpt ons DeenFocus te verbeteren en bij te dragen aan zinvolle doelen.';

  @override
  String get supportUsFundSection => 'Jouw steun helpt financieren';

  @override
  String get supportUsFundSectionSubtitle =>
      'We gebruiken jouw steun om meer goed te doen.';

  @override
  String get supportUsFundFeature1Title => 'Nieuwe functies';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Zinvolle DeenFocus-functies bouwen en verbeteren.';

  @override
  String get supportUsFundFeature2Title => 'Bugfixes';

  @override
  String get supportUsFundFeature2Subtitle =>
      'De app stabiel, snel en betrouwbaar houden voor iedereen.';

  @override
  String get supportUsFundFeature3Title => 'Mensen in nood';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Steun voor mensen in moeilijke omstandigheden.';

  @override
  String get supportUsFundFeature4Title => 'Liefdadigheid & gemeenschap';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Bijdragen aan goede doelen en community-steun.';

  @override
  String get supportUsNeedHelp => 'HULP NODIG?';

  @override
  String get supportUsWhatsApp => 'Chat via WhatsApp';

  @override
  String get supportUsEmailSupport => 'E-mailondersteuning';

  @override
  String get supportUsChooseAmountTitle => 'Kies een steunbedrag';

  @override
  String get supportUsChooseAmountSubtitle => 'Je kunt meerdere keren steunen.';

  @override
  String get supportUsSecurePaymentNote =>
      'Veilige eenmalige betaling · Geen terugkerende kosten';

  @override
  String get supportUsTrustBanner =>
      'Veilig • Eenmalige steun • Meerdere keren mogelijk';

  @override
  String get supportUsImpactSectionTitle => 'Waar jouw steun verschil maakt';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Elke bijdrage heeft blijvende impact.';

  @override
  String get supportUsImpactPalestine => 'Steun & bewustzijn voor Palestina';

  @override
  String get supportUsImpactNeedy => 'Mensen in nood helpen';

  @override
  String get supportUsImpactCommunity => 'Liefdadigheid & community-steun';

  @override
  String get supportUsImpactExperience => 'Betere DeenFocus-ervaring';

  @override
  String get supportUsImpactFeatures => 'Nieuwe functies & upgrades';

  @override
  String get supportUsImpactQuran => 'Koran & islamitisch leren';

  @override
  String get supportUsImpactServers => 'Servers & app-betrouwbaarheid';

  @override
  String supportUsCta(String amount) {
    return 'Steun DeenFocus met $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, ik heb hulp nodig met DeenFocus.';

  @override
  String get supportUsEmailSubject => 'DeenFocus ondersteuningsverzoek';

  @override
  String get supportUsLaunchUnavailable =>
      'Kon die app niet openen op dit apparaat.';

  @override
  String get supportUsLaunchFailed => 'Er ging iets mis. Probeer het opnieuw.';

  @override
  String get supportUsThankYouTitle => 'JazakAllah khair';

  @override
  String get supportUsThankYouBody =>
      'Dank je voor het steunen van DeenFocus. Je kunt altijd opnieuw steunen.';

  @override
  String get supportUsPurchasePending =>
      'Je steun is in behandeling. We bevestigen hem zodra Apple de aankoop afrondt.';

  @override
  String get supportUsPurchaseFailed =>
      'We konden je steunbetaling niet afronden. Probeer het opnieuw.';

  @override
  String get supportUsProductUnavailable =>
      'Dit steunbedrag is nu niet beschikbaar. Probeer het later opnieuw.';

  @override
  String get homeAiChatDescription =>
      'Vraag alles over gebedstijden, de Koran en islamitische richtlijnen.';

  @override
  String get homeDay => 'Dag';

  @override
  String get homeDays => 'Dagen';

  @override
  String get homeNoEventsFoundForDay =>
      'Er zijn geen evenementen gevonden voor deze dag.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — markeer als';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Op tijd gebeden';

  @override
  String get homeMarkPrayerQada => 'Qada (ingehaald)';

  @override
  String get homeMarkPrayerMissed => 'Gemist';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return '$prayerName-instellingen';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Gebedstijd';

  @override
  String get homePrayerSettingsNotification => 'Melding';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Deugden, regels en meer';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Deze instellingen gelden alleen voor $prayerName. Je kunt per gebed andere voorkeuren instellen.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return '$prayerName-tijd bewerken';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Huidige tijd';

  @override
  String get homeEditPrayerTimeSelectNew => 'Nieuwe tijd selecteren';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Deze aangepaste tijd geldt alleen voor $prayerName. Pas hem aan als je lokale moskee of berekening afwijkt.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Tijd opslaan';

  @override
  String get homeEditPrayerTimeReset => 'Terugzetten naar berekende tijd';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Melding voor $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Meldingsgeluid';

  @override
  String get homeNotificationSoundFullAdhan => 'Volledige Adhan';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Speel de volledige Adhan af';

  @override
  String get homeNotificationSoundBeep => 'Pieptoon';

  @override
  String get homeNotificationSoundBeepSubtitle => 'Een korte meldingstoon';

  @override
  String get homeNotificationSoundMute => 'Gedempt';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Geen geluid';

  @override
  String get homeNotificationEnableLabel => 'Melding inschakelen';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Krijg een melding op $prayerName-tijd';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'Over $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Tijd';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakat';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Deugden';

  @override
  String get homeAboutPrayerReferenceLabel => 'Referentie';

  @override
  String get homeAboutFajrTiming =>
      'Begint bij de ware dageraad (Fajr Sadiq) en eindigt bij zonsopgang.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Wie Fajr bidt, staat onder de bescherming van Allah.';

  @override
  String get homeAboutFajrReference =>
      '«De twee rakʿāt van Fajr zijn beter dan de wereld en alles wat zij bevat.» (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Begint zodra de zon haar zenit passeert en duurt tot Asr begint.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Onderdeel van de 12 vrijwillige rakʿāt per dag waarvoor Allah een huis in het Paradijs bouwt.';

  @override
  String get homeAboutDhuhrReference =>
      '«Wie twaalf rakʿāt bidt tijdens een dag en een nacht, krijgt een huis in het Paradijs gebouwd.» (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Begint wanneer de schaduw van een voorwerp gelijk is aan zijn lengte en duurt tot zonsondergang.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Dit gebed bewaken wordt bijzonder beloond en gewaarschuwd.';

  @override
  String get homeAboutAsrReference =>
      '«Wie het Asr-gebed mist, is alsof hij zijn familie en bezit verloor.» (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Begint meteen na zonsondergang en duurt tot de rode schemering verdwijnt.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Een tijd waarin smeekbeden bijzonder worden aangemoedigd.';

  @override
  String get homeAboutMaghribReference =>
      '«Er zijn twee momenten waarop een vastende zich verheugt… wanneer hij het vasten verbreekt.» (Sahih al-Bukhari, over Maghrib-iftar)';

  @override
  String get homeAboutIshaTiming =>
      'Begint wanneer de schemering volledig verdwijnt en duurt tot middernacht (of tot Fajr, volgens sommige meningen).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Isha in congregatie bidden staat gelijk aan het staan van een half nacht in gebed.';

  @override
  String get homeAboutIshaReference =>
      '«Wie Isha in congregatie bidt, is alsof hij de helft van de nacht heeft gebeden.» (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Terug naar Onboarding';

  @override
  String get settings => 'Instellingen';

  @override
  String get appLanguage => 'App-taal';

  @override
  String get tabHome => 'Thuis';

  @override
  String get tabFocus => 'Focus';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Leren';

  @override
  String get tabLearn => 'Leren';

  @override
  String get quranLoadFailed => 'Kan Korangegevens niet laden';

  @override
  String get quranTabSubtitle => 'Lees en verken de Heilige Koran';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Zoek soera...';

  @override
  String get quranSearchHintExtended => 'Zoek soera of betekenis...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranNoSurahsFound => 'Geen soera\'s gevonden';

  @override
  String get quranVersesLabel => 'verzen';

  @override
  String quranSurahHeaderSubtitle(String name, int count) {
    return '$name • $count verzen';
  }

  @override
  String get quranTextOptions => 'Tekst opties';

  @override
  String get quranEnglishAndArabic => 'Engels en Arabisch';

  @override
  String get quranArabicOnly => 'Alleen Arabisch';

  @override
  String get quranIncreaseFont => 'Lettertype vergroten';

  @override
  String get quranDecreaseFont => 'Lettertype verkleinen';

  @override
  String get quranPause => 'Pauze';

  @override
  String get quranPlaySurah => 'Speel soera';

  @override
  String get quranAudioNoInternet =>
      'Geen internetverbinding. Audio vereist internet.';

  @override
  String get quranAudioTimeout =>
      'Audio laden verlopen. Controleer uw verbinding.';

  @override
  String get quranSurahLabel => 'Soera';

  @override
  String get quranModeSurah => 'Soera';

  @override
  String get quranModeJuz => 'Djoez';

  @override
  String get quranModePage => 'Pagina';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => 'Verder lezen';

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
    return '$percent% van djoez $juz';
  }

  @override
  String get quranBookmarksTitle => 'Bladwijzers';

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
    return '$count opgeslagen';
  }

  @override
  String get quranQuickTajweed => 'Tajweed-oefening';

  @override
  String get quranQuickTajweedSub => 'Reciteer en beoordeel';

  @override
  String get quranLastListened => 'Laatst beluisterd';

  @override
  String get quranNoneYet => 'Nog geen';

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
  String get readingSettingsTajweedPractice => 'AI Koran-tajweed';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Reciteer verzen en krijg feedback';

  @override
  String get readingSettingsTajweedSeeHowItWorks => 'Bekijk hoe het werkt';

  @override
  String get quranSeeHowAiQuranTajweedWorks => 'see how AI Quran Tajweed works';

  @override
  String get readingSettingsTajweedDeleteModel => 'AI-model verwijderen';

  @override
  String get readingSettingsTajweedDeleteConfirmTitle =>
      'AI Koran-tajweedmodel verwijderen?';

  @override
  String get readingSettingsTajweedDeleteConfirmBody =>
      'Je kunt tajweed pas weer oefenen nadat je het AI-model opnieuw downloadt. Dit maakt ook opslagruimte vrij op je apparaat.';

  @override
  String get readingSettingsTajweedDeleteConfirmAction => 'Verwijderen';

  @override
  String get readingSettingsTajweedDeleted => 'AI-tajweedmodel verwijderd';

  @override
  String get readingSettingsTajweedDeleteFailed =>
      'AI-tajweedmodel kon niet worden verwijderd';

  @override
  String get readingSettingsTajweedFreePreviewTranslation =>
      'In de naam van Allah, de Erbarmer, de Barmhartige.';

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
  String get readingSettingsTitle => 'Leesinstellingen';

  @override
  String get readingSettingsArabicFontSize => 'Arabische lettergrootte';

  @override
  String get readingSettingsTranslationFontSize => 'Lettergrootte vertaling';

  @override
  String get readingSettingsLineSpacing => 'Regelafstand';

  @override
  String get readingSettingsDefaultMode => 'Standaard leesmodus';

  @override
  String get readingSettingsRememberPosition => 'Laatste positie onthouden';

  @override
  String get readingSettingsScript => 'Arabisch schrift';

  @override
  String get readingSettingsScriptUthmani => 'Uthmani (Hafs)';

  @override
  String get readingSettingsScriptIndopak => 'IndoPak (Hafs)';

  @override
  String get readingSettingsArabicFont => 'Arabisch lettertype';

  @override
  String get readingSettingsFontUthmanic => 'Uthmanic Hafs';

  @override
  String get readingSettingsFontNooreHuda => 'Noore Huda';

  @override
  String get readingSettingsFontSystem => 'Systeem (native)';

  @override
  String get readingSettingsShowTranslation => 'Vertaling tonen';

  @override
  String get readingSettingsShowTransliteration => 'Transliteratie tonen';

  @override
  String get readingSettingsTranslationSection => 'Vertaling';

  @override
  String get readingSettingsTranslationLabel => 'Vertaling';

  @override
  String get readingSettingsTranslationCurrent => 'Huidig';

  @override
  String get readingSettingsInstalledTranslations => 'Geïnstalleerd';

  @override
  String get readingSettingsAvailableTranslations => 'Beschikbaar';

  @override
  String get readingSettingsTranslationInstalled => 'Geïnstalleerd';

  @override
  String get readingSettingsTranslationSelected => 'Geselecteerd';

  @override
  String get readingSettingsTranslationDownload => 'Downloaden';

  @override
  String get readingSettingsTranslationInstalling => 'Installeren…';

  @override
  String get readingSettingsTranslationDownloading => 'Downloaden…';

  @override
  String get readingSettingsLayoutTheme => 'Koran-indeling';

  @override
  String get readingSettingsLayoutClassic => 'Mushaf';

  @override
  String get readingSettingsLayoutSimple => 'Eenvoudig';

  @override
  String get readingSettingsLayoutColor => 'Kleur-Koran';

  @override
  String get readingSettingsColorTheme => 'Leesthema';

  @override
  String get readingSettingsColorThemeParchment => 'Perkament';

  @override
  String get readingSettingsColorThemeEmerald => 'Smaragd';

  @override
  String get readingSettingsColorThemeMidnight => 'Middernacht';

  @override
  String get readingSettingsPreview => 'Voorbeeld';

  @override
  String get readingSettingsResetHistoryTitle => 'Leesgegevens resetten';

  @override
  String get readingSettingsResetHistorySubtitle =>
      'Wist verder lezen, paginavoortgang, bladwijzers en snelle acties';

  @override
  String get readingSettingsResetHistoryConfirmTitle =>
      'Leesgegevens resetten?';

  @override
  String get readingSettingsResetHistoryConfirmBody =>
      'Dit verwijdert verder lezen, paginavoortgang, bladwijzers, laatst beluisterd en tajweed-snelkoppelingen. Weergave- en vertaalinstellingen blijven behouden.';

  @override
  String get readingSettingsResetHistoryDone => 'Leesgegevens gewist';

  @override
  String get readingSettingsResetHistoryButton => 'Resetten';

  @override
  String readingSettingsTranslationDownloadFailed(String name) {
    return 'Kon $name niet downloaden. Probeer opnieuw wanneer je online bent.';
  }

  @override
  String readingSettingsTranslationSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => 'Begin met reciteren';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'WOORDNAUWKEURIGHEID';

  @override
  String get tajweedWordReviewLabel => 'WOORDOVERZICHT';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Reciteer en controleer tajweed';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nasaal, 2 tellen';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Echo-stuitering';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Verleng de klinker';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Letters samenvoegen';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Verberg de nūn';

  @override
  String get save => 'Redden';

  @override
  String get tasbihBack => 'Terug';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Selecteer een dhikr of maak er zelf een';

  @override
  String get tasbihAddCustomTitle => 'Voeg Dhikr toe';

  @override
  String get tasbihEditCustomTitle => 'Aangepaste Dhikr bewerken';

  @override
  String get tasbihArabicOrDhikrHint => 'Arabische tekst of een dhikr';

  @override
  String get tasbihTransliterationOptionalHint => 'Transliteratie (optioneel)';

  @override
  String get tasbihMeaningOptionalHint => 'Betekenis (optioneel)';

  @override
  String get tasbihNoTransliteration => 'Geen transliteratie';

  @override
  String get tasbihTotalCount => 'Totaal aantal';

  @override
  String get tasbihGrandTotalLabel => 'Tasbih totaal';

  @override
  String get tasbihTapMe => 'Tik op mij';

  @override
  String get tasbihReset => 'Opnieuw instellen';

  @override
  String get tasbihRestart => 'Opnieuw opstarten';

  @override
  String get tasbihCurrentCount => 'Huidige telling';

  @override
  String get tasbihResetTotal => 'Geschiedenis wissen';

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
  String get focusModeActivated => 'Focusmodus geactiveerd';

  @override
  String get focusSetUpHomeCardTitle => 'Focusmodus instellen';

  @override
  String get focusTabSubtitle =>
      'Blijf gefocust wanneer het er het meest toe doet';

  @override
  String get focusChooseAppsEnableMode =>
      'Kies apps en schakel de focusmodus in';

  @override
  String get focusNotifAppsLockedTitle => 'Apps vergrendeld';

  @override
  String get focusNotifAppsUnlockedTitle => 'Apps ontgrendeld';

  @override
  String get focusNotifNightModeTitle => 'Nachtmodus';

  @override
  String get focusNotifGoodMorningTitle => 'Goedemorgen!';

  @override
  String get focusNotifAppsNowAvailableBody => 'Apps zijn nu beschikbaar.';

  @override
  String get focusNotifSalahLockedBody =>
      'Apps zijn vergrendeld tijdens Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah voltooid';

  @override
  String get focusNotifSalahCompleteBody =>
      'Apps zijn nu ontgrendeld. Moge je gebed worden aangenomen.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return '$prayerName-tijd';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Neem een moment voor het $prayerName-gebed.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Nachtmodus staat aan. Laat geest en lichaam rusten.';

  @override
  String get focusNotifGenericLockedBody =>
      'Geselecteerde apps zijn vergrendeld.';

  @override
  String get focusNotifMorningUnlockBody => 'Apps zijn niet beschikbaar.';

  @override
  String get widgetDailyVerseTitle => 'Dagvers';

  @override
  String get widgetOpenAppTimelineHint =>
      'Open Deen Focus om je dagvers en gebed-widgetgegevens klaar te zetten.';

  @override
  String get widgetSetLocationForPrayers =>
      'Stel je locatie in Deen Focus in om gebeden en het dagvers te laden.';

  @override
  String get widgetPrayerProgressTitle => 'Jouw gebedsvoortgang';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed van $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'gebeden voltooid.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Ga zo door — vandaag nog $count gebeden';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — alle gebeden vandaag voltooid';

  @override
  String get focusChildModeActive => 'Kindmodus actief';

  @override
  String get focusSalahAndNightModeActive => 'Salah- en nachtmodus actief';

  @override
  String get focusSalahModeActive => 'Salah-modus actief';

  @override
  String get focusNightModeActive => 'Nachtmodus actief';

  @override
  String get focusAppsToBlockTitle => 'Apps om te blokkeren';

  @override
  String get focusAppliesAllModes => 'Geldt voor alle scherpstelmodi';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Toegang tot Screen Time is vereist om apps te bekijken en te selecteren.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Accepteer de openbaarmaking van de toegankelijkheid om door te gaan.';

  @override
  String get focusSelectAppsToBlock => 'Selecteer apps om te blokkeren';

  @override
  String get focusLoading => 'Laden...';

  @override
  String get focusOpen => 'Open';

  @override
  String get focusHide => 'Verbergen';

  @override
  String get focusLoad => 'Laden';

  @override
  String get focusShow => 'Show';

  @override
  String get focusSalahFocusModeTitle => 'Salah-focusmodus';

  @override
  String get focusBlockAppsDuringPrayer => 'Blokkeer apps tijdens het gebed';

  @override
  String get focusNightDisciplineTitle => 'Nachtdiscipline';

  @override
  String get focusSleepLabel => 'Slaap';

  @override
  String get focusWakeLabel => 'Wakker worden';

  @override
  String get focusBlockAppsImmediately => 'Blokkeer apps onmiddellijk';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Schakel Android-app-blokkering in';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Om andere apps op Android te kunnen blokkeren, moet de toegankelijkheidstoestemming van Deenly zijn ingeschakeld. Wij openen het juiste instellingenscherm voor u.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Openbaarmaking van toegankelijkheidsrechten';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly gebruikt Android-toegankelijkheid om app-blokkering in de Focus-modus af te dwingen.\n\nWaarom we het nodig hebben: om te detecteren wanneer u een app opent die u hebt geselecteerd voor blokkering.\n\nHoe we het gebruiken: alleen om de app op de voorgrond te identificeren en het Focus-blokscherm voor geselecteerde apps weer te geven. We gebruiken het niet om getypte tekst of persoonlijke inhoud te lezen.';

  @override
  String get focusNotNow => 'Niet nu';

  @override
  String get focusIUnderstand => 'Ik begrijp';

  @override
  String get focusDone => 'Klaar';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Ontwikkel betere nachtgewoonten';

  @override
  String get focusPrayerBlockingDescription =>
      'Apps worden tijdens het gebed geblokkeerd en na 15 minuten automatisch ontgrendeld, of je kunt ze op elk gewenst moment ontgrendelen vanaf het startscherm.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Apps worden tijdens het gebed geblokkeerd, of je kunt ze op elk gewenst moment ontgrendelen vanaf het startscherm.';

  @override
  String get focusNightBlockingDescription =>
      'Apps worden tijdens uw slaapcyclus geblokkeerd en automatisch ontgrendeld, of u kunt ze op elk gewenst moment ontgrendelen vanaf het startscherm';

  @override
  String get focusChildBlockingDescription =>
      'Apps worden onmiddellijk geblokkeerd in de kindermodus. Ontgrendel ze met de schakelaar of vanaf het startscherm';

  @override
  String get settingsEditUsername => 'Gebruikersnaam bewerken';

  @override
  String get settingsEnterYourName => 'Voer uw naam in';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Ontgrendel alle functies';

  @override
  String get settingsManageSubscriptionTitle => 'Abonnement beheren';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Bekijk plan of werk facturatie bij';

  @override
  String get settingsUsernameLabel => 'Gebruikersnaam';

  @override
  String get settingsLocationLabel => 'Locatie';

  @override
  String get settingsDarkModeLabel => 'Donkere modus';

  @override
  String get settingsAboutTitle => 'Over Deen Focus';

  @override
  String get settingsRateDeenFocus => 'Rate DeenFocus ⭐';

  @override
  String get settingsContactUsTitle => 'Neem contact met ons op';

  @override
  String get settingsSavingLocation => 'Besparing...';

  @override
  String get settingsSaveLocation => 'Locatie opslaan';

  @override
  String get settingsAboutTagline => 'Focus. Discipline. Samenhang.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus helpt je verbonden te blijven met je geloof terwijl je dagelijkse afleidingen beheert in een moderne wereld.';

  @override
  String get settingsAboutFeature1 => 'Gebedstijden met herinneringen';

  @override
  String get settingsAboutFeature2 => 'Qibla-richting op elk moment';

  @override
  String get settingsAboutFeature3 => 'Koran en Tasbih voor dagelijkse dhikr';

  @override
  String get settingsAboutFeature4 => 'Nabijgelegen moskeeën';

  @override
  String get settingsAboutFeature5 =>
      'Slimme focusmodi voor Salah, slaap en familietijd';

  @override
  String get settingsAboutFocusDescription =>
      'Slimme focusmodi helpen je afleidingen te blokkeren tijdens Salah, slaap en belangrijke momenten, zodat je aanwezig en gedisciplineerd kunt blijven.';

  @override
  String get settingsAboutFooter =>
      'Blijf consistent. Blijf bewust.\nBlijf verbonden met je Deen.';

  @override
  String get settingsEnableSystemNotifications =>
      'Schakel systeemmeldingen in om dit in te schakelen.';

  @override
  String get appDemoTitle => 'App-demo';

  @override
  String get appDemoLoadFailed => 'Kan de demovideo niet laden.';

  @override
  String get appDemoRestartHint =>
      'Video heeft een volledige herstart van de app nodig (een warme herstart kan het afspelen onderbreken).';

  @override
  String get appDemoPreviewLoadFailed => 'Kan de demo niet laden.';

  @override
  String get appDemoTryAgain => 'Probeer het opnieuw';

  @override
  String get appDemoWatchLabel => 'Bekijk de demo';

  @override
  String get homeAiChatTitle => 'Deen Focus AI';

  @override
  String get homeAiAskQuestionHint => 'Stel een vraag...';

  @override
  String get homeAiSend => 'Versturen';

  @override
  String get homeAiErrorPrefix =>
      'Sorry, ik kwam een ​​probleem tegen tijdens het verbinden met Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Vraag alles over de Islam';

  @override
  String get homeAiEmptySubtitle =>
      'Gebedstijden, koran, hadith, islamitische evenementen en spirituele begeleiding';

  @override
  String get onboardingTypeCityName => 'Typ uw stadsnaam..';

  @override
  String get onboardingNoLocationsFound => 'Geen locaties gevonden';

  @override
  String get onboardingTryAnotherCityName => 'Probeer een andere plaatsnaam.';

  @override
  String get qiblaCompassUnavailable =>
      'Kompas niet beschikbaar op dit apparaat';

  @override
  String get qiblaFacing => '✓ Kijkend naar Qibla';

  @override
  String get qiblaTurnToFind => 'Draai je om en vind Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Afstand tot Mekka';

  @override
  String get qiblaFromNorth => 'uit Noord';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Moskeeën in de buurt gevonden';

  @override
  String get nearbyMosquesTryAgain => 'Probeer het opnieuw';

  @override
  String get nearbyMosquesOpenGoogle => 'Openen in Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Openen in Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'Geen moskeeën gevonden binnen';

  @override
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Zoekradius: $radiusKm km';
  }

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Kaartvoorbeeld momenteel niet beschikbaar.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Wachten op uw locatie.';

  @override
  String get nearbyMosquesFetchingLocation => 'Je locatie ophalen…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Huidige locatie';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Moskeeën in de buurt verschijnen hier zodra de resultaten zijn geladen.';

  @override
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'Geen moskeeën gevonden binnen $radiusKm km';
  }

  @override
  String get nearbyMosquesLocationRequired =>
      'Locatietoegang is vereist om nabijgelegen moskeeën te vinden.';

  @override
  String get nearbyMosquesPermissionOff =>
      'Locatietoestemming is uitgeschakeld. Schakel het in de instellingen in om nabijgelegen moskeeën te zien.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'We kunnen uw huidige locatie momenteel niet lezen.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'Live-update mislukt. Laatst opgeslagen resultaten weergeven. Trek om te vernieuwen.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Locatietoegang is geweigerd. Schakel dit in Instellingen in om nabijgelegen moskeeën te zien.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'Locatie is uitgeschakeld op dit apparaat. Schakel het in via Instellingen en probeer het opnieuw.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'Locatietoestemming wordt nog verwerkt. Probeer het over enkele ogenblikken opnieuw.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'Het verzoek duurde te lang. Controleer uw internetverbinding en probeer het opnieuw.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Geen internetverbinding of de dienst is onbereikbaar. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get nearbyMosquesFormatError =>
      'We konden de moskeelijst momenteel niet lezen. Probeer het later opnieuw.';

  @override
  String get nearbyMosquesPlatformError =>
      'Die stap konden we niet voltooien. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Er is iets misgegaan. Probeer het opnieuw.';

  @override
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'Niets vermeld binnen een straal van $radiusKm km op OpenStreetMap voor deze plek. Probeer later opnieuw of vergroot het gebied.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count moskeeën gevonden binnen een straal van $radiusKm km';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count moskeeën in de buurt';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'Binnen $radiusKm km · Gesorteerd op afstand';
  }

  @override
  String get nearbyMosquesDirections => 'Route';

  @override
  String get tasbihDeleteDhikrTitle => 'Dikr verwijderen?';

  @override
  String get tasbihDelete => 'Verwijderen';

  @override
  String get focusAndroidBlockingNotReady =>
      'Android-appblokkering is nog niet klaar. Houd toegankelijkheid aan en wacht even op de verbinding.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Geen apps geselecteerd. Kies eerst apps om te blokkeren.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Schermtijd-toegang is vereist om apps op de iPhone te blokkeren.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Er ging iets mis bij het bijwerken van de Focus-modus. Probeer het opnieuw.';

  @override
  String get focusLoadingInstalledApps => 'Geïnstalleerde apps laden...';

  @override
  String get focusNoInstalledAppsToShow =>
      'Geen geïnstalleerde apps om te tonen.';

  @override
  String get homeAiSuggestion1 => 'Wat is Ramadan?';

  @override
  String get homeAiSuggestion2 => 'Gebedstijden';

  @override
  String get homeAiSuggestion3 => 'Koran leesplan';

  @override
  String get homeAiDeveloperPrompt =>
      'Je bent een kundige en respectvolle islamitische geleerde-assistent. Help gebruikers islamitische tradities, feestdagen, gebed, Koranstudie en spirituele praktijken te leren. Wees warm, beknopt, educatief en cultureel sensitief. Buiten islamitische begeleiding: antwoord nuttig zonder religieuze zekerheid voor te wenden.';

  @override
  String get homeAiErrorMissingApiKey => 'API-configuratie ontbreekt.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'API-fout $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Geen antwoord van de assistent.';

  @override
  String get homeAiErrorEmptyContent => 'Lege antwoordinhoud.';

  @override
  String get settingsPrayerCalculationSection => 'Gebedberekening';

  @override
  String get settingsCalculationMethodTitle => 'Berekeningsmethode';

  @override
  String get settingsAsrCalculationTitle => 'Asr-berekening';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Grote islamitische organisaties';

  @override
  String get calculationMethodSectionMiddleEast => 'Midden-Oosten';

  @override
  String get calculationMethodSectionAsiaPacific => 'Azië-Pacific';

  @override
  String get calculationMethodSectionSpecial => 'Speciale methoden';

  @override
  String get asrMethodStandard => 'Standaard';

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
  String get insightsPrayerStreak => 'Gebedsreeks';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count gebeden';
  }

  @override
  String get insightsPrayersInARow => 'Gebeden achter elkaar';

  @override
  String get insightsDaysInARow => 'Dagen achter elkaar';

  @override
  String insightsChipUpToday(int count) {
    return '↑ $count';
  }

  @override
  String get insightsChipDayUp => '↑ 1 vandaag';

  @override
  String get insightsWeeklyCompletion => 'Wekelijkse voortgang';

  @override
  String get insightsMonthlyCompletion => 'Maandelijkse voortgang';

  @override
  String get insightsThisWeek => 'Deze week';

  @override
  String get insightsThisMonth => 'Deze maand';

  @override
  String get insightsOverall => 'Totaal';

  @override
  String get insightsRateExcellent => 'Uitstekend';

  @override
  String get insightsRateGood => 'Goed';

  @override
  String get insightsRateFair => 'Redelijk';

  @override
  String get insightsRateStart => 'Ga door';

  @override
  String get insightsPrayersCompletedWeekly => 'Gebeden voltooid (week)';

  @override
  String get insightsPrayersCompletedMonthly => 'Gebeden voltooid (maand)';

  @override
  String insightsCompletionSummary(int done, int possible) {
    return 'Je hebt $done van $possible gebeden voltooid.\nAlhamdulillah — ga door!';
  }

  @override
  String get insightsFocusExcellent => 'Uitstekend — ga zo door!';

  @override
  String get insightsFocusKeepGoing => 'Bouw je focus verder uit';

  @override
  String get insightsTodaysPrayers => 'Gebeden van vandaag';

  @override
  String get insightsPrayersCompletedLabel =>
      'Gebeden voltooid — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Cyclusmodus actief';

  @override
  String get insightsProtectedByCycleMode => 'Je reeks is beschermd.';

  @override
  String get insightsCurrentPrayerStreak => 'Huidige gebedsreeks';

  @override
  String get insightsBestPrayerStreak => 'Beste gebedsreeks';

  @override
  String get insightsCurrentDayStreak => 'Huidige dagenreeks';

  @override
  String get insightsCycleProtectedDays => 'Cyclus-beschermde dagen';

  @override
  String get insightsAchievements => 'Prestaties';

  @override
  String get insightsAchieved => 'Behaald';

  @override
  String get insightsMyProgress => 'Mijn voortgang';

  @override
  String insightsLevelNumber(int level) {
    return 'Niveau $level';
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
    return '$xp XP tot niveau $level';
  }

  @override
  String get insightsMaxLevel => 'MAXIMAAL NIVEAU';

  @override
  String insightsAchievementsUnlocked(int unlocked, int total) {
    return '$unlocked / $total ontgrendeld';
  }

  @override
  String get insightsAchievementUnlockedTitle => 'Prestatie ontgrendeld';

  @override
  String get insightsLevelUpTitle => 'NIVEAU OMHOOG';

  @override
  String get achievementFirstPrayer => 'Eerste gebed';

  @override
  String get achievementFajrChampion => 'Fajr-kampioen';

  @override
  String get achievementFiveADay => 'Vijf per dag';

  @override
  String get achievementPerfectWeek => 'Perfecte week';

  @override
  String get achievementPerfectMonth => 'Perfecte maand';

  @override
  String get achievementQuranDevotee => 'Koranvriend';

  @override
  String get achievementDhikrStarter => 'Start met dhikr';

  @override
  String get achievementNightWorshipper => 'Nachtelijke aanbidder';

  @override
  String get achievementMasjidCompanion => 'Moskeemetgezel';

  @override
  String get achievementDistractionDefender => 'Focusbewaker';

  @override
  String get achievementCycleGuardian => 'Cyclusbewaker';

  @override
  String get achievementProtectedMonth => 'Beschermde maand';

  @override
  String get achievementSixMonthJourney => 'Zes maanden reis';

  @override
  String get achievementDeenFocusMaster => 'DeenFocus Master';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Cyclusdagen zijn beschermd en tellen niet als reeksonderbreking. Je hebt $days beschermde dag(en).';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Schakel Cyclusmodus in om je reeks te beschermen op rustdagen.';

  @override
  String get achievementFirstPrayerStreak => 'Eerste gebedsreeks';

  @override
  String get achievementSevenPrayerStreak => 'Zeven-gebedsreeks';

  @override
  String get achievementThirtyPrayerStreak => 'Dertig-gebedsreeks';

  @override
  String get achievementFajrWarrior => 'Fajr-strijder';

  @override
  String get achievementQuranReader => 'Koranlezer';

  @override
  String get achievementDhikrMaster => 'Dhikr-meester';

  @override
  String get achievementConsistencyChampion => 'Consistentiekampioen';

  @override
  String get prayerCompletionAlhamdulillah => 'Alhamdulillah!';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer is voltooid';
  }

  @override
  String get prayerCompletionStreakIncreased => 'Je gebedsreeks is gestegen';

  @override
  String get prayerCompletionKeepGoing =>
      'Elk gebed brengt je dichter bij Allah. Ga zo door!';

  @override
  String get prayerCompletionContinue => 'Doorgaan';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Volgend gebed over $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes minuten';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '${hours}u ${minutes}m';
  }

  @override
  String get weekdayLetterMon => 'M';

  @override
  String get weekdayLetterTue => 'D';

  @override
  String get weekdayLetterWed => 'W';

  @override
  String get weekdayLetterThu => 'D';

  @override
  String get weekdayLetterFri => 'V';

  @override
  String get weekdayLetterSat => 'Z';

  @override
  String get weekdayLetterSun => 'Z';

  @override
  String get focusHomeBlockingNightAndSalah =>
      'Nachtdiscipline en Salah-modus blokkeren geselecteerde apps.';

  @override
  String get focusHomeBlockingNight =>
      'Nachtdiscipline blokkeert geselecteerde apps.';

  @override
  String get focusHomeBlockingSalah =>
      'Salah-modus blokkeert geselecteerde apps.';

  @override
  String get focusHomeAppsBlockedNow =>
      'Geselecteerde apps zijn nu geblokkeerd.';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode is ingeschakeld.';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes zijn ingeschakeld.';
  }

  @override
  String get focusHomeChooseMode =>
      'Kies een modus om je aandacht te beschermen';

  @override
  String get focusStatusSelectApps => 'Selecteer apps om te beginnen';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Nachtdiscipline en Salah-modus blokkeren nu apps';

  @override
  String get focusStatusBlockingNight => 'Nachtdiscipline blokkeert nu apps';

  @override
  String get focusStatusBlockingSalah => 'Salah-modus blokkeert nu apps';

  @override
  String get focusStatusAppsLocked => 'Apps zijn nu vergrendeld';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Ontgrendeld tot $time';
  }

  @override
  String get focusStatusNoMode => 'Geen focusmodus ingeschakeld';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Klaar om $targets te vergrendelen';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '${hours}u ${minutes}m ${seconds}s';
  }

  @override
  String get appLockDemoIntroTitle => 'Zo werkt App-vergrendeling';

  @override
  String get appLockDemoIntroSubtitle =>
      'Blijf in DeenFocus. Tik op het volgende scherm op Instagram om te zien hoe het pauzeert tijdens gebedstijd.';

  @override
  String get appLockDemoStartButton => 'Demo starten';

  @override
  String get appLockDemoTryOpeningApp => 'Probeer Instagram te openen';

  @override
  String get appLockDemoSalahModeBadge => 'SALAH-MODUS';

  @override
  String get appLockDemoTimeToPray => 'Het is tijd om te bidden';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Resterende tijd: $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'Ik heb $prayerName gebeden';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName voltooid';
  }

  @override
  String get appLockDemoStreakIncreased => 'Je gebedsreeks is gestegen';

  @override
  String get appLockDemoPrayerStreakLabel => 'GEBEDSREEKS';

  @override
  String get appLockDemoDayStreakLabel => 'DAGREEKS';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Volgend gebed over $minutes minuten';
  }

  @override
  String get appLockDemoStreakMotivation =>
      'Ga zo door! Jouw consistentie brengt je dichter bij Allah.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Bid. Check één keer in.\nGa verder met je dag.';

  @override
  String get appLockDemoCompletionBody =>
      'App-vergrendeling pauzeert geselecteerde apps zachtjes tijdens Salah zodat je kunt focussen — daarna ga je verder wanneer je klaar bent.';

  @override
  String get appLockDemoContinueSetup => 'Setup voortzetten';

  @override
  String get appLockDemoAppMessages => 'Berichten';

  @override
  String get appLockDemoAppCalendar => 'Agenda';

  @override
  String get appLockDemoAppPhotos => 'Foto’s';

  @override
  String get appLockDemoAppCamera => 'Camera';

  @override
  String get appLockDemoAppMail => 'Mail';

  @override
  String get appLockDemoAppMaps => 'Kaarten';

  @override
  String get appLockDemoAppWeather => 'Weer';

  @override
  String get appLockDemoAppClock => 'Klok';

  @override
  String get appLockDemoAppNotes => 'Notities';

  @override
  String get appLockDemoAppSettings => 'Instellingen';

  @override
  String get appLockDemoAppMusic => 'Muziek';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Gebedsupdates';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live Activity voor je volgende gebed op het vergrendelscherm';

  @override
  String get liveActivitySectionTitle => 'Live Activities';

  @override
  String get liveActivityStayUpdatedTitle => 'In één oogopslag bijgewerkt';

  @override
  String get liveActivityStayUpdatedBody =>
      'Bekijk je volgende gebed en tijd direct op het vergrendelscherm.';

  @override
  String get liveActivityEnableLabel => 'Live Activity inschakelen';

  @override
  String get liveActivityPromptNotNow => 'Niet nu';

  @override
  String get liveActivityUnsupported =>
      'Live Activities zijn niet beschikbaar op dit apparaat.';

  @override
  String get liveActivityPermissionNeeded =>
      'Sta meldingen toe zodat gebedsupdates op het vergrendelscherm verschijnen.';

  @override
  String get liveActivityPermissionButton => 'Meldingen toestaan';

  @override
  String get liveActivityStatusActive => 'Live Activity is aan';

  @override
  String get liveActivityStatusOff => 'Live Activity is uit';

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
  String get liveActivityNowLabel => 'Nu';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Bijgewerkt om $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer om $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Gebedsalarmen';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Volledige gebedsalarmen die stille modus kunnen doorbreken';

  @override
  String get prayerAlarmsMasterLabel => 'Gebedsalarmen inschakelen';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Plan een native alarm voor elk geselecteerd gebed';

  @override
  String get prayerAlarmsSnoozeLabel => 'Snoozeduur';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes minuten';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Alarmen per gebed';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Sta alarmtoestemming toe zodat gebedsalarmen op tijd afgaan.';

  @override
  String get prayerAlarmsPermissionButton => 'Alarmen toestaan';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Sta full-screen alarmen toe voor het vergrendelscherm. Zonder dat verschijnen ze als banner.';

  @override
  String get prayerAlarmsFsiButton => 'Full-screen instellingen';

  @override
  String get prayerAlarmsUnsupported =>
      'Native gebedsalarmen zijn niet beschikbaar op dit apparaat. Softmeldingen blijven werken.';

  @override
  String get prayerAlarmsIosFallback =>
      'Op deze iOS-versie worden softmeldingen gebruikt in plaats van AlarmKit.';

  @override
  String get prayerAlarmsDeniedTitle => 'Alarmtoestemming vereist';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Gebedsalarmen blijven uit tot je alarmtoestemming geeft. Zachte meldingen blijven werken.';

  @override
  String get prayerAlarmsOpenSettings => 'Open Instellingen';

  @override
  String get prayerAlarmsStatusReady => 'Alarmen zijn klaar om te plannen';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Toestemming nodig — alarmen zijn niet actief';

  @override
  String get prayerAlarmsStatusFallback =>
      'Op dit apparaat worden zachte meldingen gebruikt';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Alarmen staan aan. Schakel full-screen in voor het vergrendelscherm.';

  @override
  String get prayerAlarmsCancel => 'Niet nu';

  @override
  String get homePrayerAlarmEnableLabel => 'Gebedsalarm';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Laat een native alarm afgaan bij $prayerName';
  }

  @override
  String get prayerAlarmBadge => 'Gebedsalarm';

  @override
  String get prayerAlarmSubtitle => 'Tijd om te bidden';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — Tijd om te bidden';
  }

  @override
  String get prayerAlarmIvePrayed => 'Ik heb gebeden';

  @override
  String get prayerAlarmDismiss => 'Sluiten';

  @override
  String get prayerAlarmSnooze => 'Snooze';

  @override
  String get appLockDemoAppPhone => 'Telefoon';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Herinneringen';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Boeken';

  @override
  String get appLockDemoAppHealth => 'Gezondheid';

  @override
  String get appLockDemoAppWallet => 'Wallet';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'App-demo';

  @override
  String get settingsAppDemoChooseModeTitle => 'Ervaar App Lock';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Kies een Focus-modus en zie hoe geselecteerde apps pauzeren — zonder DeenFocus te verlaten.';

  @override
  String get appLockDemoDone => 'Klaar';

  @override
  String get appLockDemoSleepIntroTitle => 'Zo werkt de Slaapmodus';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Blijf in DeenFocus. Tik op het volgende scherm op Instagram om te zien hoe het pauzeert bij bedtijd.';

  @override
  String get appLockDemoSleepModeBadge => 'SLAAPMODUS';

  @override
  String get appLockDemoSleepLockTitle => 'Tijd om tot rust te komen';

  @override
  String get appLockDemoSleepLockCta => 'Ik ben klaar om te rusten';

  @override
  String get appLockDemoSleepCompleted => 'Slaapmodus beschermd';

  @override
  String get appLockDemoSleepRewardSubtitle =>
      'Je nachtelijke bescherming is toegenomen';

  @override
  String get appLockDemoSleepStreakLabel => 'NACHTREEKS';

  @override
  String get appLockDemoSleepRewardFooter =>
      'Fajr-herinnering ingesteld voor de ochtend';

  @override
  String get appLockDemoSleepMotivation =>
      'Slaap lekker vannacht zodat je met energie opstaat voor Fajr.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Rustige nachten.\nHeldere ochtenden.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'Slaapmodus pauzeert geselecteerde apps ’s nachts zachtjes zodat je kunt rusten — daarna ga je verder wanneer je klaar bent.';

  @override
  String get appLockDemoChildIntroTitle => 'Zo werkt de Kindmodus';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Blijf in DeenFocus. Tik op het volgende scherm op Instagram om de vergrendeling met Kindmodus te zien.';

  @override
  String get appLockDemoChildModeBadge => 'KINDMODUS';

  @override
  String get appLockDemoChildLockTitle => 'Apps zijn beschermd';

  @override
  String get appLockDemoChildLockDetail =>
      'Geselecteerde apps blijven vergrendeld terwijl Kindmodus aan staat';

  @override
  String get appLockDemoChildLockCta => 'Begrepen';

  @override
  String get appLockDemoChildCompleted => 'Kindmodus actief';

  @override
  String get appLockDemoChildRewardSubtitle =>
      'Je beschermingsreeks is toegenomen';

  @override
  String get appLockDemoChildStreakLabel => 'VEILIGE REEKS';

  @override
  String get appLockDemoChildRewardFooter =>
      'Verlaat op elk moment met je toegangscode';

  @override
  String get appLockDemoChildMotivation =>
      'Gemoedsrust elke keer dat je je telefoon doorgeeft.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'Veilige modus met één tip.\nAlleen wat jij toelaat.';

  @override
  String get appLockDemoChildCompletionBody =>
      'Kindmodus vergrendelt geselecteerde apps zodat je kind alleen ziet wat veilig is — daarna ontgrendel je wanneer je klaar bent.';

  @override
  String get appLockDemoSleepCompletionTitle => 'Slaap lekker vannacht';

  @override
  String get appLockDemoChildCompletionTitle => 'Gemoedsrust';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Pauzeer afleidingen tijdens Salah zodat je met aanwezigheid kunt bidden.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Bescherm je nachten zodat rust makkelijker komt — en Fajr lichter voelt.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Geef je telefoon met vertrouwen door — alleen toegestane apps blijven open.';

  @override
  String get settingsAppDemoHomeFeaturesTitle => 'In één oogopslag verbonden';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'Zie hoe widgets en Live Activity gebedstijden dichtbij houden — zonder de app te openen.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Dagvers en gebedstijden op je beginscherm, altijd bijgewerkt.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Huidig en volgend gebed op het vergrendelscherm en Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Reciteer een aya en krijg direct tajweed-feedback.';

  @override
  String get featureDemoTajweedTitle => 'Tajweed';

  @override
  String get featureDemoTajweedIntroTitle => 'Zo werkt tajweed-oefening';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Blijf in DeenFocus. Open tajweed-oefening, reciteer een aya en zie feedback woord voor woord.';

  @override
  String get featureDemoTajweedQuranCallout =>
      'Tik op Tajweed-oefening om te starten';

  @override
  String get featureDemoTajweedLegendCallout =>
      'Kleuren tonen tajweed-regels tijdens het lezen';

  @override
  String get featureDemoTajweedReciteCallout =>
      'Tik op Reciteer en controleer tajweed';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'Eenmalige download zodat oefenen offline werkt';

  @override
  String get featureDemoTajweedMicCallout =>
      'Tik op de microfoon en begin te reciteren';

  @override
  String get featureDemoTajweedResultCallout =>
      'Zie welke woorden goed, gemist of te oefenen zijn';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tajweed, klaar';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Reciteer vol vertrouwen, wanneer je wilt.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Open Koran → Tajweed-oefening om elke aya op het apparaat te scoren — volledig offline na de eerste download.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 verzen • Mekkaans';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 verzen • Medinees';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => 'Al-Fatihah • 7 verzen';

  @override
  String get featureDemoTajweedSurahMeta => 'SOERA 1 • MEKKAANS';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'In de naam van Allah, de Erbarmer, de Barmhartige.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatihah · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'AI-model voorbereiden';

  @override
  String get featureDemoTajweedPreparingBody =>
      'Eenmalige download zodat tajweed-oefening daarna volledig offline werkt. Dit gebeurt maar één keer.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Blijf oefenen — luister naar de referentie en probeer opnieuw.';

  @override
  String get featureDemoTajweedStatCorrect => 'Juist';

  @override
  String get featureDemoTajweedStatPronunciation => 'Uitspraak';

  @override
  String get featureDemoTajweedStatWrong => 'Verkeerd woord';

  @override
  String get featureDemoTajweedStatMissed => 'Gemist';

  @override
  String get featureDemoTajweedStatExtra => 'Extra';

  @override
  String get featureDemoContinue => 'Doorgaan';

  @override
  String get featureDemoSampleStatusTime => '9:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      'Je apparaat staat apps niet toe om widgets automatisch te plaatsen. Voeg de grote DeenFocus-widget toe via de widgetgalerij van je startscherm.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Voeg de widget toe via je startscherm';

  @override
  String get featureDemoOfferNo => 'Nee';

  @override
  String get featureDemoOfferYes => 'Ja';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      'Wil je Live Activity op je apparaat inschakelen?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      'Wil je deze widget aan je startscherm toevoegen?';

  @override
  String get featureDemoWidgetsTitle => 'Widgets';

  @override
  String get featureDemoWidgetsIntroTitle => 'Bekijk je beginscherm-widgets';

  @override
  String get featureDemoWidgetsIntroSubtitle =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsShowcaseCallout =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsDetailsTitle => 'Glanceable prayer guidance';

  @override
  String get featureDemoWidgetsDetailsBody =>
      'Your Medium widget shows today’s verse and all five prayer times — refreshed when you open DeenFocus.';

  @override
  String get featureDemoWidgetsCompletionTitle => 'Widgets, ready';

  @override
  String get featureDemoWidgetsCompletionSubtitle =>
      'Faith reminders on your Home Screen.';

  @override
  String get featureDemoWidgetsCompletionBody =>
      'Add DeenFocus widgets from your phone’s widget gallery after this demo — then open the app once to sync.';

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
  String get featureDemoLiveActivityIntroTitle => 'Bekijk Live Activity';

  @override
  String get featureDemoLiveActivityIntroSubtitle =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityShowcaseCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveActivityDetailsTitle =>
      'Prayer updates, always visible';

  @override
  String get featureDemoLiveActivityDetailsBody =>
      'Live Activity keeps Maghrib, Isha, and the countdown close on your Lock Screen — turn it on in Settings anytime.';

  @override
  String get featureDemoLiveActivityCompletionTitle => 'Live Activity, ready';

  @override
  String get featureDemoLiveActivityCompletionSubtitle =>
      'Next prayer, always nearby.';

  @override
  String get featureDemoLiveActivityCompletionBody =>
      'Enable Live Activity in Settings → Prayer Calculation to show prayer updates on your Lock Screen.';

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
  String get appLockDemoOfferPrayerTitle => 'Klaar om Gebedsmodus te proberen?';

  @override
  String get appLockDemoOfferSleepTitle => 'Klaar om Slaapmodus te proberen?';

  @override
  String get appLockDemoOfferChildTitle => 'Klaar om Kindmodus te proberen?';

  @override
  String get appLockDemoOfferPrayerCta => 'Gebedsmodus inschakelen';

  @override
  String get appLockDemoOfferSleepCta => 'Slaapmodus inschakelen';

  @override
  String get appLockDemoOfferChildCta => 'Kindmodus inschakelen';

  @override
  String get appLockDemoOfferNotNow => 'Niet nu';

  @override
  String get nightlyWrapUpPrayersTitle => 'Rond de gebeden van vandaag af';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Markeer onvoltooide of gemiste gebeden om je gebedsreeks te beschermen.';

  @override
  String get nightlyWrapUpChecklistTitle => 'Voltooi je dagelijkse checklist';

  @override
  String get nightlyWrapUpChecklistBody =>
      'Er staan nog items open — rond je dag met intentie af.';

  @override
  String get nightlyWrapUpBothTitle => 'Rond je dag af';

  @override
  String get nightlyWrapUpBothBody =>
      'Markeer openstaande gebeden en voltooi je checklist voor het einde van de dag.';

  @override
  String get cycleModeEndedNotificationTitle => 'Cyclusmodus is beëindigd';

  @override
  String get cycleModeEndedNotificationBody =>
      'Je cyclusmodus staat nu uit. Je kunt weer bidden. Als je de data van de cyclusmodus wilt wijzigen, tik hier om ze te bewerken.';

  @override
  String get libraryHomeTitle => 'Islamitische bibliotheek';

  @override
  String get libraryHomeSubtitle => 'Leer hadith, dua’s, de 99 Namen en meer';

  @override
  String get libraryHubTitle => 'Islamitische bibliotheek';

  @override
  String get libraryModuleQuran => 'Koran';

  @override
  String get libraryModuleQuranSub => 'Lees, luister en oefen tajweed';

  @override
  String get libraryModuleHadith => 'Hadith';

  @override
  String get libraryModuleHadithSub => 'Verzamelingen uit authentieke bronnen';

  @override
  String get libraryModuleDuas => 'Dua’s & adhkar';

  @override
  String get libraryModuleDuasSub =>
      'Ochtend-, avond- en dagelijkse herinnering';

  @override
  String get libraryModulePrayerMethods => 'Gebed & islamitische methoden';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, salah, hadj en meer';

  @override
  String get libraryModuleFiqh => 'Fiqh & tradities';

  @override
  String get libraryModuleFiqhSub =>
      'Soennieten, sjiieten, madhhabs, Ahl-e Hadith en meer';

  @override
  String get libraryModuleNames => '99 Namen van Allah';

  @override
  String get libraryModuleNamesSub => 'Leer en reflecteer op Asma ul-Husna';

  @override
  String get libraryModulePillarsIslam => 'Zuilen van de islam';

  @override
  String get libraryModulePillarsIslamSub =>
      'De vijf fundamenten van geloof in actie';

  @override
  String get libraryModulePillarsIman => 'Zuilen van het geloof';

  @override
  String get libraryModulePillarsImanSub => 'De zes geloofsartikelen';

  @override
  String get libraryModuleProphets => 'Profeet Mohammed';

  @override
  String get libraryModuleProphetsSub =>
      'Zijn leven, missie en tijdloze lessen';

  @override
  String get libraryModuleOccasions => 'Islamitische gelegenheden';

  @override
  String get libraryModuleOccasionsSub => 'Ramadan, Eid, hadj en heilige dagen';

  @override
  String get libraryKeyLesson => 'Belangrijke les';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current van $total';
  }

  @override
  String get libraryPrevious => 'Vorige';

  @override
  String get libraryNext => 'Volgende';

  @override
  String get libraryBookmark => 'Bladwijzer';

  @override
  String get libraryCopy => 'Kopiëren';

  @override
  String get libraryShare => 'Delen';

  @override
  String get libraryCopied => 'Gekopieerd naar klembord';

  @override
  String get libraryShareCopiedHint => 'Gekopieerd — plakken om te delen';

  @override
  String get libraryBookmarkSaved => 'Bladwijzer opgeslagen';

  @override
  String get libraryBookmarkRemoved => 'Bladwijzer verwijderd';

  @override
  String get libraryTranslation => 'Vertaling';

  @override
  String get libraryTransliteration => 'Transliteratie';

  @override
  String get libraryMeaning => 'Betekenis';

  @override
  String get libraryBookmarksTitle => 'Opgeslagen leeritems';

  @override
  String get libraryBookmarksSubtitle => 'Hadith, dua’s, namen, fiqh en meer';

  @override
  String get libraryBookmarksEmpty =>
      'Nog geen opgeslagen items. Tik op Bladwijzer bij een leeritem om het hier op te slaan.';

  @override
  String get libraryMarkCompleted => 'Markeer als voltooid';

  @override
  String get librarySectionCompleted => 'Voltooid';

  @override
  String get libraryReflection => 'Reflectie';

  @override
  String get libraryComingSoonTitle => 'Binnenkort';

  @override
  String get libraryComingSoonBody =>
      'Deze module wordt voorbereid. Kom terug in een latere update.';

  @override
  String get librarySearchHint => 'Zoeken…';

  @override
  String get libraryHubSearchHint => 'Zoek in Leren…';

  @override
  String get libraryHubSearchSections => 'Onderdelen';

  @override
  String get libraryHubSearchTopics => 'Onderwerpen';

  @override
  String get librarySearchEmpty => 'Geen resultaten';

  @override
  String libraryItemCount(int count) {
    return '$count items';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown van $total';
  }

  @override
  String libraryContinueFrom(int number) {
    return 'Doorgaan · $number';
  }

  @override
  String get libraryInProgress => 'Bezig';

  @override
  String libraryReference(String source) {
    return 'Bron: $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count dua’s';
  }

  @override
  String get libraryDuaCategoryMorning => 'Ochtend';

  @override
  String get libraryDuaCategoryEvening => 'Avond';

  @override
  String get libraryDuaCategoryDailyLife => 'Dagelijks leven';

  @override
  String get libraryDuaCategorySleep => 'Slaap';

  @override
  String get libraryDuaCategoryFood => 'Eten';

  @override
  String get libraryDuaCategoryTravel => 'Reizen';

  @override
  String get libraryDuaCategoryIllness => 'Ziekte';

  @override
  String get libraryDuaCategoryProtection => 'Bescherming';

  @override
  String get libraryDuaCategoryForgiveness => 'Vergeving';

  @override
  String get libraryDuaCategoryParents => 'Ouders';

  @override
  String libraryHadithCount(int count) {
    return '$count hadith';
  }

  @override
  String get libraryHadithNarrator => 'Overleveraar:';

  @override
  String get libraryHadithSource => 'Bron:';

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
    return '$count stappen';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Stap $current van $total';
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
  String get libraryGuideJanazah => 'Janaza-gebed';

  @override
  String get libraryGuideUmrah => 'Umrah';

  @override
  String get libraryGuideHajj => 'Hadj';

  @override
  String get libraryGuideFasting => 'Vasten';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawba';

  @override
  String get libraryOccasionImportance => 'Belang';

  @override
  String get libraryOccasionVirtues => 'Deugden';

  @override
  String get libraryOccasionRecommendedActs => 'Aanbevolen daden';

  @override
  String get libraryFiqhOverview => 'Overzicht';

  @override
  String get libraryFiqhKeyPoints => 'Belangrijke punten';

  @override
  String get libraryFiqhDifferences => 'Belangrijke verschillen';

  @override
  String get libraryFiqhCommonGround => 'Gemeenschappelijke grond';

  @override
  String get insightsCompleted => 'Voltooid';

  @override
  String get insightsInProgress => 'Bezig';

  @override
  String get insightsKeepGoingTitle => 'Ga zo door!';

  @override
  String get insightsKeepGoingBody =>
      'Je maakt grote voortgang. Elk gebed telt.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Ontgrendelde prestaties';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer => 'Je hebt je eerste gebed verricht.';

  @override
  String get achievementDescSevenPrayerStreak =>
      'Voltooi 7 gebeden achter elkaar.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Voltooi 30 gebeden achter elkaar.';

  @override
  String get achievementDescFajrWarrior => 'Bid Fajr op 14 dagen.';

  @override
  String get achievementDescFajrChampion => 'Bid Fajr op 30 dagen.';

  @override
  String get achievementDescFiveADay => 'Voltooi alle vijf gebeden op één dag.';

  @override
  String get achievementDescPerfectWeek =>
      'Voltooi elk gebed 7 dagen achter elkaar.';

  @override
  String get achievementDescPerfectMonth =>
      'Voltooi elk gebed 30 dagen achter elkaar.';

  @override
  String get achievementDescQuranReader => 'Lees de Koran op 7 dagen.';

  @override
  String get achievementDescQuranDevotee => 'Lees de Koran op 30 dagen.';

  @override
  String get achievementDescDhikrStarter => 'Voltooi dhikr op 7 dagen.';

  @override
  String get achievementDescDhikrMaster => 'Voltooi dhikr op 30 dagen.';

  @override
  String get achievementDescNightWorshipper => 'Bid Tahajjud op 7 dagen.';

  @override
  String get achievementDescMasjidCompanion => 'Bezoek de moskee 7 keer.';

  @override
  String get achievementDescDistractionDefender =>
      'Blijf 7 dagen vrij van afleiding.';

  @override
  String get achievementDescCycleGuardian =>
      'Bescherm je reeks 7 dagen met cyclusmodus.';

  @override
  String get achievementDescProtectedMonth =>
      'Bescherm je reeks 30 dagen met cyclusmodus.';

  @override
  String get achievementDescConsistencyChampion =>
      'Blijf 100 dagen consistent.';

  @override
  String get achievementDescSixMonthJourney => 'Ga 180 dagen door.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Bereik DeenFocus Master (niveau 15).';

  @override
  String get dailyChecklistOptional => 'Optioneel';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Beheers woede / Spreek vriendelijk';

  @override
  String get digitalBalanceTitle => 'Digitale balans';

  @override
  String get digitalBalanceSubtitle => 'Zie waar je tijd naartoe gaat';

  @override
  String get digitalBalanceViewCta => 'Digitale balans bekijken →';

  @override
  String get digitalBalanceTodayLabel => 'Vandaag';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Andere apps';

  @override
  String get digitalBalanceTodayPhoneTime => 'Telefoontijd van vandaag';

  @override
  String get digitalBalanceWhereTimeGoes => 'Waar je tijd naartoe gaat';

  @override
  String get digitalBalanceViewAllApps => 'Alle apps bekijken';

  @override
  String get digitalBalanceAllAppsTitle => 'Alle apps';

  @override
  String get digitalBalanceNoApps => 'Nog geen app-gebruik voor vandaag.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen vs. digitale tijd';

  @override
  String get digitalBalanceYourWeek => 'Jouw week';

  @override
  String get digitalBalanceThisWeek => 'Deze week';

  @override
  String get digitalBalancePhoneUsageLegend => 'Telefoongebruik';

  @override
  String get digitalBalanceDailyInsight => 'Dagelijkse noot';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Elke minuut die je Deen versterkt, telt.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'Je DeenFocus-tijd is deze week hoger dan vorige week. MashaAllah!';

  @override
  String get digitalBalanceInsightQuietDay =>
      'Een rustige dag tot nu toe. DeenFocus-tijd verschijnt hier.';

  @override
  String get digitalBalanceGoalTitle => 'Je Deen-tijddoel';

  @override
  String get digitalBalanceAdjustGoal => 'Doel aanpassen';

  @override
  String get digitalBalanceGoalReached =>
      'Je hebt het doel van vandaag gehaald. MashaAllah!';

  @override
  String get digitalBalanceGoalSheetTitle => 'Dagelijkse Deen-tijd';

  @override
  String get digitalBalanceGoalCustomHint => 'Minuten per dag';

  @override
  String get digitalBalanceGoalSave => 'Opslaan';

  @override
  String get digitalBalanceGoal15 => '15 min';

  @override
  String get digitalBalanceGoal30 => '30 min';

  @override
  String get digitalBalanceGoal45 => '45 min';

  @override
  String get digitalBalanceGoal60 => '1 uur';

  @override
  String get digitalBalancePermissionTitle => 'Begrijp je digitale gewoonten';

  @override
  String get digitalBalancePermissionBody =>
      'Geef DeenFocus toegang tot je app-gebruik zodat je ziet waar je tijd naartoe gaat en hoeveel je aan je Deen geeft.';

  @override
  String get digitalBalanceEnableUsage => 'App-gebruik inschakelen';

  @override
  String get digitalBalanceMaybeLater => 'Misschien later';

  @override
  String get digitalBalanceUnavailableTitle =>
      'App-gebruik is hier niet beschikbaar';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple deelt Schermtijd niet met andere apps, dus Digital Balance kan iPhone-gebruik nog niet tonen. Je gebeden, reeksen en inzichten werken gewoon.';

  @override
  String get digitalBalanceInfoTitle => 'Over digitale balans';

  @override
  String get digitalBalanceInfoBody =>
      'Digitale balans helpt je zien waar je tijd naartoe gaat en hoeveel je aan je Deen geeft. Gebruik blijft op je apparaat.';

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
    return 'DeenFocus · $percent% van de telefoontijd';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% van je telefoontijd';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% van de telefoontijd van vandaag';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% meer DeenFocus-tijd dan vorige week';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'Je hebt vandaag $duration in DeenFocus doorgebracht. Blijf de gewoonte opbouwen.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'Je DeenFocus-tijd steeg met $percent% ten opzichte van gisteren.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / dag';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return 'Nog $minutes minuten tot het doel van vandaag';
  }

  @override
  String get tajweedPracticeTitle => 'Tajweed-oefening';

  @override
  String tajweedPracticeAyahTitle(String surah, String ref) {
    return '$surah · $ref';
  }

  @override
  String get tajweedDownloadTitle => 'AI-model voorbereiden';

  @override
  String get tajweedDownloadFailedTitle =>
      'AI-model kon niet worden voorbereid';

  @override
  String get tajweedDownloadBody =>
      'Eenmalige download zodat tajweed-oefening daarna volledig offline werkt. Dit gebeurt maar één keer.';

  @override
  String get tajweedDownloadFinishing => 'Installatie afronden…';

  @override
  String get tajweedDownloadCanLeave =>
      'Je kunt dit scherm verlaten — de download gaat op de achtergrond door.';

  @override
  String get tajweedDownloadTryAgain => 'Opnieuw proberen';

  @override
  String get tajweedDownloadPleaseTryAgain => 'Probeer het opnieuw.';

  @override
  String get tajweedErrorFeatureDisabled =>
      'AI-tajweed-oefening staat uit. Zet het eerst aan in Instellingen.';

  @override
  String get tajweedErrorModelMissing =>
      'Het AI-model is nog niet geïnstalleerd.';

  @override
  String get tajweedErrorModelDownloadFailed =>
      'Download van het AI-model mislukt. Controleer je verbinding en probeer opnieuw.';

  @override
  String get tajweedErrorModelLoadFailed =>
      'Het AI-model kon op dit apparaat niet worden geladen.';

  @override
  String get tajweedErrorCouldNotPrepare =>
      'Het AI-model kon niet worden voorbereid.';

  @override
  String get tajweedErrorUnsupported =>
      'AI-tajweed-oefening is niet beschikbaar op dit apparaat.';

  @override
  String get sharePromoTitle => 'Bekijk dit op DeenFocus 🌙';

  @override
  String get sharePromoBody =>
      'Een eenvoudige app om gefocust te blijven op je Deen, op tijd te bidden en betere gewoontes op te bouwen.';

  @override
  String get sharePromoDownloadHeading => 'Download DeenFocus:';

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
      'Jouw metgezel voor een beter Deen, elke dag.';

  @override
  String get shareDownloadCta => 'Download DeenFocus';

  @override
  String get shareAppStoreBadge => 'App Store';

  @override
  String get sharePlayStoreBadge => 'Google Play';

  @override
  String get shareFailed => 'Delen is mislukt. Probeer het opnieuw.';

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
    return 'W$week';
  }

  @override
  String get insightsLevelName1 => 'Nieuw begin';

  @override
  String get insightsLevelName2 => 'Eerste stappen';

  @override
  String get insightsLevelName3 => 'Gewoonte opbouwen';

  @override
  String get insightsLevelName4 => 'Regelmatige biddende';

  @override
  String get insightsLevelName5 => 'Standvastig hart';

  @override
  String get insightsLevelName6 => 'Bewaker van het gebed';

  @override
  String get insightsLevelName7 => 'Toegewijde dienaar';

  @override
  String get insightsLevelName8 => 'Sterke routine';

  @override
  String get insightsLevelName9 => 'Toegewijde biddende';

  @override
  String get insightsLevelName10 => 'Standvastig';

  @override
  String get insightsLevelName11 => 'Dieper geloof';

  @override
  String get insightsLevelName12 => 'Sterke consistentie';

  @override
  String get insightsLevelName13 => 'Gids in toewijding';

  @override
  String get insightsLevelName14 => 'Uitzonderlijke consistentie';

  @override
  String get insightsLevelName15 => 'DeenFocus Master';
}
