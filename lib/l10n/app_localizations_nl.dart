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
  String get locationManualEntry => 'Of voer je stad in';

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
  String get notificationsPreviewAdhanBody =>
      'Het is tijd om te bidden. Apps zijn gepauzeerd.';

  @override
  String get notificationsPreviewDhikrTitle => 'DAGELIJKSE DHIKR';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — neem een minuut om te gedenken.';

  @override
  String get notificationsPreviewStreakTitle => 'REEKS';

  @override
  String get notificationsPreviewStreakBody =>
      '7 dagen volledige gebeden. Ga zo door!';

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
  String get homeSearchNearbyMosques => 'Zoek nabijgelegen moskeeën.';

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
  String get calendarEventJumuahDesc => 'Vrijdaggebed';

  @override
  String get calendarEventWhiteDays => 'Witte dagen';

  @override
  String get calendarEventWhiteDaysDesc => '13–15 van elke maand';

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
  String get dailyChecklistSectionDistraction => 'Afleidingscontrole';

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
  String get tabQuran => 'Koran';

  @override
  String get tabLearn => 'Leren';

  @override
  String get quranLoadFailed => 'Kan Korangegevens niet laden';

  @override
  String get quranTabSubtitle => 'Lees en verken de Heilige Koran';

  @override
  String get quranSearchHint => 'Zoek soera...';

  @override
  String get quranNoSurahsFound => 'Geen soera\'s gevonden';

  @override
  String get quranVersesLabel => 'verzen';

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
  String get save => 'Redden';

  @override
  String get tasbihBack => 'Rug';

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
  String get nearbyMosquesTitle => 'Nabijgelegen moskeeën';

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
  String get nearbyMosquesSearchRadius => 'Zoekradius: 5 km';

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
  String get nearbyMosquesNoneWithinRadius =>
      'Geen moskeeën gevonden binnen 5 km';

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
  String get nearbyMosquesEmptyHint =>
      'Niets vermeld binnen een straal van 5 km op OpenStreetMap voor deze plek. Probeer het later opnieuw of verplaats de kaart.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count moskeeën gevonden binnen een straal van 5 km';
  }

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
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => 'Gebeden achter elkaar';

  @override
  String get insightsDaysInARow => 'Dagen achter elkaar';

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
  String get insightsFocusExcellent => 'Uitstekend — ga zo door!';

  @override
  String get insightsFocusKeepGoing => 'Bouw je focus verder uit';

  @override
  String get insightsTodaysPrayers => 'Gebeden van vandaag';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

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
  String insightsCycleModeFooter(int days) {
    return 'Cycle Mode days are protected and not counted as streak breaks. You have $days protected day(s) available.';
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
}
