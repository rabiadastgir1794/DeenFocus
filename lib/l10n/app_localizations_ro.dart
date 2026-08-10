// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Deen Focus';

  @override
  String get appTagline => 'Credinţă. Concentrează-te. Consecvență';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline => 'Modul de rugăciune. Modul copil. Modul Sleep.';

  @override
  String get welcomeDescription =>
      'Urmăriți-vă rugăciunile, citiți Coranul, numărați Tasbih și construiți linii semnificative - totul într-un singur loc.';

  @override
  String get skip => 'Sari peste';

  @override
  String get notNow => 'Nu acum';

  @override
  String get continueButton => 'Continua';

  @override
  String get continueForFree =>
      'Poate mai târziu — explorează mai întâi aplicația';

  @override
  String get getStarted =>
      'Începe perioada mea de încercare gratuită de 7 zile';

  @override
  String get language => 'Limbă';

  @override
  String get cancel => 'Anula';

  @override
  String get ok => 'Bine';

  @override
  String get openSettings => 'Deschide Setări';

  @override
  String get locationRequired => 'Locație obligatorie';

  @override
  String get locationRequiredMessage =>
      'Accesul la locație este necesar pentru a calcula cu precizie orele de rugăciune și direcția Qibla. Trebuie să îl activați pentru a utiliza aplicația.';

  @override
  String get notificationsRequired => 'Notificări necesare';

  @override
  String get notificationsRequiredMessage =>
      'Notificările sunt necesare pentru a primi alerte de rugăciune și mementouri.';

  @override
  String get sectTitle => 'Alege-ți Secta';

  @override
  String get sectSubtitle =>
      'Acest lucru ne ajută să vă personalizăm experiența';

  @override
  String get sectSunni => 'Sunniți';

  @override
  String get sectShia => 'Shia';

  @override
  String get sectPreferNotToSay => 'Prefer să nu spun';

  @override
  String get nameTitle => 'Care e numele tău?';

  @override
  String get nameSubtitle => 'Să vă personalizăm salutul';

  @override
  String get namePlaceholder => 'Numele dumneavoastră';

  @override
  String get locationTitle => 'Găsește-ți Qibla';

  @override
  String get locationSubtitle =>
      'Activează locația pentru Qibla, ore de rugăciune și moschei din apropiere precise.';

  @override
  String get locationButton => 'Permiteți accesul la locație';

  @override
  String get locationManualEntry => 'Sau introdu orașul tău';

  @override
  String get locationPrivacyNote => 'Rămâne pe dispozitivul tău';

  @override
  String get locationFeaturePrayerTimesTitle => 'Ore de rugăciune';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Moschei';

  @override
  String get notificationsTitle => 'Nu rata nicio rugăciune';

  @override
  String get notificationsSubtitle =>
      'Alerte adhan, memento-uri de focus și dhikr zilnic — exact când ai nevoie.';

  @override
  String get notificationsButton => 'Activați notificările';

  @override
  String get notificationsEnabled => 'Notificările sunt activate';

  @override
  String get notificationsPreviewDate => 'Vineri, 10 iulie';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'acum';

  @override
  String get notificationsPreviewMinutesAgo => 'acum 2 min';

  @override
  String get notificationsPreviewHourAgo => 'acum 1 oră';

  @override
  String get notificationsPreviewAdhanTitle => 'Adhan Maghrib';

  @override
  String get notificationsPreviewAdhanBody =>
      'Este timpul să te rogi. Aplicațiile sunt întrerupte.';

  @override
  String get notificationsPreviewDhikrTitle => 'DHIKR ZILNIC';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — ia-ți un minut să-ți amintești.';

  @override
  String get notificationsPreviewStreakTitle => 'SERIE';

  @override
  String get notificationsPreviewStreakBody =>
      '7 zile de rugăciuni complete. Continuă!';

  @override
  String get screenTimeTitle => 'Activează Timp ecran';

  @override
  String get screenTimeSubtitle =>
      'Asta îi permite Deen Focus să oprească aplicațiile care distrag în timpul Salah, somnului și modului copil.';

  @override
  String get screenTimeButton => 'Permite accesul la Timp ecran';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus nu îți citește niciodată datele — doar pune în pauză aplicațiile pe care le alegi.';

  @override
  String screenTimeStepOf(int current, int total) {
    return 'PASUL $current DIN $total';
  }

  @override
  String get screenTimeStep1Title => 'Deschide solicitarea Timp ecran';

  @override
  String get screenTimeStep1Body =>
      'Atinge «Permite accesul la Timp ecran» — dispozitivul va afișa propria solicitare de permisiune.';

  @override
  String get screenTimeStep2Title => 'Atinge Continuă, apoi Permite';

  @override
  String get screenTimeStep2Body =>
      'Aprobă solicitarea pentru ca Deen Focus să poată pune aplicațiile în pauză la momentul potrivit.';

  @override
  String get screenTimeStep3Title => 'Alege aplicațiile de blocat';

  @override
  String get screenTimeStep3Body =>
      'Alege aplicațiile care te distrag cel mai mult — social, jocuri, video, orice.';

  @override
  String get screenTimeStep4Title => 'Ești protejat';

  @override
  String get screenTimeStep4Body =>
      'Aplicațiile se blochează automat în timpul Salah, somnului și modului copil.';

  @override
  String get screenTimePromptTitle => 'Timp ecran';

  @override
  String screenTimePromptMessage(String appName) {
    return '«$appName» dorește acces la Timp ecran';
  }

  @override
  String get screenTimeDontAllow => 'Nu permite';

  @override
  String get screenTimePromptContinue => 'Continuă';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Jocuri';

  @override
  String get screenTimeAndroidStep1Title => 'Deschide Acces utilizare';

  @override
  String get screenTimeAndroidStep1Body =>
      'Atinge «Permite accesul la Timp ecran» — dispozitivul va deschide Acces utilizare pentru Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Activează Accesibilitatea';

  @override
  String get screenTimeAndroidStep2Body =>
      'Pornește serviciul Deen Focus pentru a pune aplicațiile în pauză în timpul Salah, somnului și modului copil.';

  @override
  String get screenTimeAndroidStep3Title => 'Alege aplicațiile de blocat';

  @override
  String get screenTimeAndroidStep3Body =>
      'Alege aplicațiile care te distrag cel mai mult — social, jocuri, video, orice.';

  @override
  String get screenTimeAndroidStep4Title => 'Ești protejat';

  @override
  String get screenTimeAndroidStep4Body =>
      'Aplicațiile se blochează automat în timpul Salah, somnului și modului copil.';

  @override
  String get screenTimeAndroidUsageTitle => 'Acces utilizare';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Permite Deen Focus să urmărească ce alte aplicații sunt folosite.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Accesibilitate';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus are nevoie de Accesibilitate pentru a pune în pauză aplicațiile care distrag în timpul sesiunilor de focus.';

  @override
  String get screenTimeAndroidPermit => 'Permite';

  @override
  String get screenTimeAndroidEnable => 'Activează';

  @override
  String get screenTimeAndroidNotNow => 'Nu acum';

  @override
  String get focusModesTitle => 'Totul într-o singură aplicație';

  @override
  String get focusModesSubtitle =>
      'Explorează tot ce oferă Deen Focus. Atinge un mod de focus pentru a vedea cum funcționează.';

  @override
  String get focusModesSectionLabel => 'MODURI FOCUS · ATINGE PENTRU MAI MULTE';

  @override
  String get focusPrayerTrackingSectionLabel => 'RUGĂCIUNE ȘI URMĂRIRE';

  @override
  String get focusLearningHubSectionLabel => 'CENTRU DE ÎNVĂȚARE';

  @override
  String get focusMoreSectionLabel => 'MAI MULT';

  @override
  String get focusPrayerModeTitle => 'Modul de rugăciune';

  @override
  String get focusPrayerModeDescription =>
      'Blochează automat aplicațiile care distrag în timpul Salah, ca să te poți ruga cu khushu deplin.';

  @override
  String get focusPrayerModeBullet1 =>
      'Blochează aplicațiile la ora rugăciunii';

  @override
  String get focusPrayerModeBullet2 => 'Se deblochează când ai terminat';

  @override
  String get focusPrayerModeBullet3 => 'Construiește focus și consecvență';

  @override
  String get focusSleepModeTitle => 'Modul Sleep';

  @override
  String get focusSleepModeDescription =>
      'Relaxează-te într-un mod halal. Blochează aplicațiile la culcare ca să te odihnești bine și să te trezești pentru Fajr.';

  @override
  String get focusSleepModeBullet1 =>
      'Blochează aplicațiile automat la culcare';

  @override
  String get focusSleepModeBullet2 =>
      'Memento-uri blânde pentru trezirea la Fajr';

  @override
  String get focusSleepModeBullet3 => 'Îți protejează somnul și Fajr-ul';

  @override
  String get focusChildModeTitle => 'Modul copil';

  @override
  String get focusChildModeDescription =>
      'Dai telefonul copilului? Blochează imediat aplicațiile ca să vadă doar ce e sigur.';

  @override
  String get focusChildModeBullet1 => 'Mod sigur dintr-o atingere';

  @override
  String get focusChildModeBullet2 => 'Ieșire protejată cu cod';

  @override
  String get focusChildModeBullet3 => 'Liniște, de fiecare dată';

  @override
  String get focusModeGotIt => 'Am înțeles';

  @override
  String get focusFeaturePrayerTimesTitle => 'Ore de rugăciune precise';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan și memento-uri';

  @override
  String get focusFeatureStreaksTitle => 'Serii';

  @override
  String get focusFeatureStreaksSubtitle => 'Rămâi constant';

  @override
  String get focusFeatureChecklistTitle => 'Listă zilnică';

  @override
  String get focusFeatureChecklistSubtitle => 'Construiește obiceiuri bune';

  @override
  String get focusFeatureQiblaTitle => 'Qibla și moschee';

  @override
  String get focusFeatureQiblaSubtitle => 'Direcție și moschei';

  @override
  String get focusFeatureQuranTitle => 'Coran';

  @override
  String get focusFeatureQuranSubtitle => 'Traduceri, juz și pagini';

  @override
  String get focusFeatureHadithTitle => 'Hadith';

  @override
  String get focusFeatureHadithSubtitle => 'Colecții autentice';

  @override
  String get focusFeatureDuasTitle => 'Dua';

  @override
  String get focusFeatureDuasSubtitle => 'Suplicații zilnice';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Contor digital de dhikr';

  @override
  String get focusFeatureAiTitle => 'Companion AI';

  @override
  String get focusFeatureAiSubtitle => 'Întreabă despre dinul tău';

  @override
  String get focusFeatureInsightsTitle => 'Statistici';

  @override
  String get focusFeatureInsightsSubtitle => 'Date săptămânale și lunare';

  @override
  String get investTitle => 'Investește în Deen';

  @override
  String get investSubtitle =>
      'Cea mai bună investiție nu e în ce se estompează — ci în ce te apropie de Allah. Încearcă totul gratuit 7 zile.';

  @override
  String get investPremiumUnlocked => 'PREMIUM DEBLOCAT';

  @override
  String get investTrialPill =>
      '✨ 7 zile gratuite — anulează oricând înainte să se termine';

  @override
  String get investFeatureAiTitle => 'Asistent islamic AI';

  @override
  String get investFeatureAiBody =>
      'Întreabă orice despre Deenul tău — răspunsuri bazate pe surse autentice.';

  @override
  String get investFeaturePrayerModeTitle => 'Mod rugăciune pe ecran complet';

  @override
  String get investFeaturePrayerModeBody =>
      'Un ecran calm, fără distrageri, care te cheamă la Salah.';

  @override
  String get investFeatureAppBlockingTitle => 'Blocare avansată a aplicațiilor';

  @override
  String get investFeatureAppBlockingBody =>
      'Control precis asupra aplicațiilor care se blochează și când exact.';

  @override
  String get investFeatureNightModeTitle => 'Mod disciplină de noapte';

  @override
  String get investFeatureNightModeBody =>
      'Relaxează-te la timp, dormi mai bine și trezește-te pentru Fajr.';

  @override
  String get investFeaturePlannerTitle =>
      'Planificator de rugăciune și progres';

  @override
  String get investFeaturePlannerBody =>
      'Serii, perspective și jurnale care te țin consecvent.';

  @override
  String get investFeatureToolsTitle => 'Instrumente islamice exclusive';

  @override
  String get investFeatureToolsBody =>
      'Calendar hijri, dua-uri, tasbih, 99 de Nume și altele.';

  @override
  String get investFeatureThemesTitle => 'Teme premium și actualizări';

  @override
  String get investFeatureThemesBody =>
      'Teme frumoase plus fiecare funcție nouă pe care o lansăm.';

  @override
  String get investFeatureTajweedTitle => 'Stăpânește Tajweed-ul';

  @override
  String get investFeatureTajweedBody =>
      'Îmbunătățește recitarea cu lecții ghidate și feedback în timp real.';

  @override
  String get socialProofPrefix => 'Alătură-te la ';

  @override
  String get socialProofHighlight => '10.000+';

  @override
  String get socialProofSuffix => ' musulmani care cresc cu DeenFocus';

  @override
  String get mostPopular => 'Cele mai populare';

  @override
  String get monthlyLabel => 'Lunar';

  @override
  String get yearlyLabel => 'Anual';

  @override
  String get lifetimeLabel => 'Durata de viață';

  @override
  String get featureNoAds => 'Elimină toate reclamele';

  @override
  String get featureSupport => 'Sprijin prioritar';

  @override
  String get homeTitle => 'Deenly Home';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback =>
      'Într-adevăr, cu greutățile vine ușurința.';

  @override
  String get homeAppsLocked => 'Aplicații blocate';

  @override
  String get homeAppsUnlocked => 'Aplicații deblocate';

  @override
  String get homeTapToUnlock =>
      'Atingeți pentru a debloca temporar aplicațiile';

  @override
  String get homeTapToRelock =>
      'Atingeți pentru a rebloca aplicațiile blocate acum';

  @override
  String get homeRelock => 'Reblochează';

  @override
  String get homeUnlock => 'Deblocați';

  @override
  String get homePrayerModeActive => 'Mod de rugăciune activ';

  @override
  String get homeActivatePrayerMode => 'Activați modul Rugăciune';

  @override
  String get homeAppsBlockedSubtitle =>
      'Aplicațiile sunt blocate. Atingeți pentru a dezactiva.';

  @override
  String get homeBlockDistractingApps =>
      'Blocați aplicațiile care distrag atenția în timpul Salah.';

  @override
  String get homeQiblaDirection => 'Direcția Qibla';

  @override
  String get homeLocationMissingForQibla =>
      'Activați locația pentru a calcula direcția Qibla.';

  @override
  String get homeQiblaSubtitleGuiding => 'Îndrumându-te către Qibla';

  @override
  String get homeToMakkah => 'la Mecca';

  @override
  String get homeFindMasjid => 'Găsiți Masjid lângă mine';

  @override
  String get quickActionsMasjidFinder => 'Găsește moschee';

  @override
  String get homeSearchNearbyMosques => 'Căutați moscheile din apropiere.';

  @override
  String get homePrayerStreak => 'Dâre de rugăciune';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Perspective';

  @override
  String get homeOpenStreakDetails => 'Deschideți detaliile seriei.';

  @override
  String get homeTodaysPrayers => 'Rugăciunile de azi';

  @override
  String get homePrayerTimesUnavailable =>
      'Momentele de rugăciune nu sunt disponibile momentan.';

  @override
  String get homeNextPrayerIn => 'Următoarea rugăciune în';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Răsărit de soare';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Magrib';

  @override
  String get homePrayerIsha => 'Isha';

  @override
  String get homeWeek => 'Săptămână';

  @override
  String get homeMonth => 'Lună';

  @override
  String get homeThisWeek => 'Deen Highlights Săptămâna aceasta';

  @override
  String get homeJummahMubarak => 'Jummah Mubarak';

  @override
  String get homeJummahReminder => 'Nu uitați de Sura Al-Kahf.';

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
  String get calendarEventJumuahDesc => 'Rugăciunea de vineri';

  @override
  String get calendarEventWhiteDays => 'Zilele albe';

  @override
  String get calendarEventWhiteDaysDesc =>
      'Din 13 până în 15 ale fiecărei luni';

  @override
  String get cycleModeActiveTitle =>
      '„Allah dorește pentru voi ușurința și nu dorește pentru voi greutatea.” — Coran 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'În această perioadă, seria ta este protejată. Zilele ciclului sunt evidențiate în roz, iar Modul ciclu se oprește automat la finalul ciclului.';

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
      other: 'Se termină automat în $days zile',
      one: 'Se termină automat mâine',
      zero: 'Se termină azi',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeSettingsTitle => 'Mod ciclu';

  @override
  String get cycleModeStartDateLabel => 'Data de început';

  @override
  String get cycleModeLengthLabel => 'Durata ciclului';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zile',
      one: '1 zi',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Pauzează seriile';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'Exclude din statistici';

  @override
  String get cycleModeSaveButton => 'Salvează';

  @override
  String get cycleModeEditButton => 'Editează';

  @override
  String get cycleModeChangeStartDateTitle => 'Schimbi data de început?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Schimbarea datei de început va recalcula fereastra activă a Modului ciclu. Zilele din afara noului interval ar putea să nu mai fie tratate ca zile de ciclu.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Schimbă data de început';

  @override
  String prayerReminderTitle(String prayer) {
    return 'Ai făcut $prayer?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Păstrează-ți seria înregistrând rugăciunea.';

  @override
  String get prayerReminderYesButton => 'Da, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'Voi marca mai târziu';

  @override
  String get homeTrialBannerTitle =>
      'Gratuit 7 zile — deveniți un musulman mai bun ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Toate funcțiile deblocate. Începeți călătoria astăzi.';

  @override
  String get homeFocusModeTitle => 'Mod focus';

  @override
  String get homeFocusModeSubtitle =>
      'Blochează aplicațiile care distrag în timpul Salah';

  @override
  String get cycleModeTitle => 'Mod ciclu';

  @override
  String get cycleModeSubtitle =>
      'Pentru menstruație — pune pe pauză rugăciunile, păstrează seria';

  @override
  String get dailyChecklistTitle => 'Listă zilnică';

  @override
  String get dailyChecklistSubtitle =>
      'Urmărește-ți obiectivele spirituale zilnice';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed din $total finalizate';
  }

  @override
  String get dailyChecklistSectionPrayer => 'Rugăciune';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Coran și Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Fapte bune';

  @override
  String get dailyChecklistSectionDistraction => 'Controlul distragerii';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Coran';

  @override
  String get dailyChecklistMorningAdhkar => 'Adhkar de dimineață';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar de seară';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Caritate';

  @override
  String get dailyChecklistSmileAtSomeone => 'Zâmbește cuiva';

  @override
  String get dailyChecklistFamilyCall => 'Apel familiei';

  @override
  String get dailyChecklistNoMusicToday => 'Fără muzică azi';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'Fără social media înainte de Isha';

  @override
  String get focusScoreTitle => 'Scorul de focus de azi';

  @override
  String get focusScorePrayer => 'Rugăciune';

  @override
  String get focusScoreQuran => 'Coran';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Controlul distragerii';

  @override
  String get insightsBack => 'Înapoi';

  @override
  String get insightsTitle => 'Perspectivele mele';

  @override
  String get insightsSubtitle => 'Urmărește-ți progresul în Deen';

  @override
  String get insightsPrayerRate => 'Rata rugăciunilor';

  @override
  String get insightsDayStreak => 'Serie de zile';

  @override
  String get insightsBestStreak => 'Cea mai bună serie';

  @override
  String get insightsWeekly => 'Săptămânal';

  @override
  String get insightsMonthly => 'Lunar';

  @override
  String get insightsPrayersCompleted => 'Rugăciuni finalizate';

  @override
  String get insightsRestoreStreak => 'Restaurează seria — ultimele 24 de ore';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Rugăciune $prayerPercent% · Coran $quranPercent% · Dhikr $dhikrPercent% · Distragere $distractionPercent%';
  }

  @override
  String get quickActionsCalendar => 'Calendar';

  @override
  String get quickActionsCalendarSubtitle => 'Vezi datele islamice';

  @override
  String get quickActionsSupportUs => 'Sprijină-ne';

  @override
  String get quickActionsSupportUsSubtitle => 'Ajută-ne să creștem';

  @override
  String get quickActionsSupportUsMessage =>
      'Mulțumim că te gândești să sprijini DeenFocus! Funcțiile de suport vor apărea în curând.';

  @override
  String get supportUsTitle => 'Sprijină DeenFocus';

  @override
  String get supportUsHeroTitle => 'Susține DeenFocus';

  @override
  String get supportUsHeroBody =>
      'Sprijinul tău ne ajută să îmbunătățim DeenFocus și să contribuim la cauze semnificative.';

  @override
  String get supportUsFundSection => 'Sprijinul tău ajută la finanțarea';

  @override
  String get supportUsFundSectionSubtitle =>
      'Folosim sprijinul tău pentru a crea mai mult bine.';

  @override
  String get supportUsFundFeature1Title => 'Funcții noi';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Construim și îmbunătățim funcții semnificative DeenFocus.';

  @override
  String get supportUsFundFeature2Title => 'Corectări de erori';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Menținem aplicația stabilă, rapidă și de încredere.';

  @override
  String get supportUsFundFeature3Title => 'Oameni în nevoie';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Susținem eforturile care ajută oamenii aflați în dificultate.';

  @override
  String get supportUsFundFeature4Title => 'Caritate și comunitate';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Contribuim la inițiative caritabile și sprijin comunitar.';

  @override
  String get supportUsNeedHelp => 'AI NEVOIE DE AJUTOR?';

  @override
  String get supportUsWhatsApp => 'Discută pe WhatsApp';

  @override
  String get supportUsEmailSupport => 'Suport prin e-mail';

  @override
  String get supportUsChooseAmountTitle => 'Alege o sumă de sprijin';

  @override
  String get supportUsChooseAmountSubtitle => 'Poți sprijini de mai multe ori.';

  @override
  String get supportUsSecurePaymentNote =>
      'Plată unică sigură · Fără taxe recurente';

  @override
  String get supportUsTrustBanner =>
      'Sigur • Sprijin unic • Poți sprijini de mai multe ori';

  @override
  String get supportUsImpactSectionTitle => 'Unde sprijinul tău face diferența';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Fiecare contribuție are un impact durabil.';

  @override
  String get supportUsImpactPalestine =>
      'Sprijin și conștientizare pentru Palestina';

  @override
  String get supportUsImpactNeedy => 'Ajutor pentru cei în nevoie';

  @override
  String get supportUsImpactCommunity => 'Caritate și sprijin comunitar';

  @override
  String get supportUsImpactExperience => 'Experiență DeenFocus mai bună';

  @override
  String get supportUsImpactFeatures => 'Funcții noi și actualizări';

  @override
  String get supportUsImpactQuran => 'Coran și învățare islamică';

  @override
  String get supportUsImpactServers => 'Servere și fiabilitatea aplicației';

  @override
  String supportUsCta(String amount) {
    return 'Susține DeenFocus cu $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, am nevoie de ajutor cu DeenFocus.';

  @override
  String get supportUsEmailSubject => 'Cerere de suport DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'Nu s-a putut deschide acea aplicație pe acest dispozitiv.';

  @override
  String get supportUsLaunchFailed => 'Ceva nu a mers bine. Încearcă din nou.';

  @override
  String get homeAiChatDescription =>
      'Întrebați orice despre orele de rugăciune, Coran și îndrumări islamice.';

  @override
  String get homeDay => 'Zi';

  @override
  String get homeDays => 'Zile';

  @override
  String get homeNoEventsFoundForDay =>
      'Nu s-au găsit evenimente pentru această zi.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — marchează ca';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Rugată la timp';

  @override
  String get homeMarkPrayerQada => 'Qada (recuperată)';

  @override
  String get homeMarkPrayerMissed => 'Ratată';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return 'Setări $prayerName';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Ora rugăciunii';

  @override
  String get homePrayerSettingsNotification => 'Notificare';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Virtuți, reguli și altele';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Aceste setări sunt doar pentru $prayerName. Poți seta preferințe diferite pentru fiecare rugăciune.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'Editează ora $prayerName';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Ora curentă';

  @override
  String get homeEditPrayerTimeSelectNew => 'Selectează o oră nouă';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Această oră personalizată se aplică doar pentru $prayerName. Ajusteaz-o dacă moscheea locală sau calculul diferă.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Salvează ora';

  @override
  String get homeEditPrayerTimeReset => 'Resetează la ora calculată';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Notificare pentru $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Sunetul notificării';

  @override
  String get homeNotificationSoundFullAdhan => 'Adhan complet';

  @override
  String get homeNotificationSoundFullAdhanSubtitle => 'Redă Adhanul complet';

  @override
  String get homeNotificationSoundBeep => 'Bip';

  @override
  String get homeNotificationSoundBeepSubtitle => 'Un ton scurt de notificare';

  @override
  String get homeNotificationSoundMute => 'Mut';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Fără sunet';

  @override
  String get homeNotificationEnableLabel => 'Activează notificarea';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Primește notificare la ora $prayerName';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'Despre $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Ora';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakat';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Virtuți';

  @override
  String get homeAboutPrayerReferenceLabel => 'Referință';

  @override
  String get homeAboutFajrTiming =>
      'Începe la adevărata zori (Fajr Sadiq) și se termină la răsărit.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Cine se roagă Fajr este sub protecția lui Allah.';

  @override
  String get homeAboutFajrReference =>
      '«Cele două rakʿāt ale Fajrului sunt mai bune decât lumea și tot ce conține.» (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Începe odată ce soarele trece de zenit și durează până începe Asr.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Parte din cele 12 rakʿāt voluntare zilnice pentru care Allah construiește o casă în Paradis.';

  @override
  String get homeAboutDhuhrReference =>
      '«Cine se roagă douăsprezece rakʿāt într-o zi și o noapte va avea o casă construită pentru el în Paradis.» (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Începe când umbra unui obiect egală lungimea sa și durează până la apus.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Păstrarea acestei rugăciuni este evidențiată cu răsplată și avertizare speciale.';

  @override
  String get homeAboutAsrReference =>
      '«Cine pierde rugăciunea Asr este ca și cum și-ar fi pierdut familia și averea.» (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Începe imediat după apus și durează până dispare amurgul roșu.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Un moment în care rugăciunile de cerere sunt deosebit de încurajate.';

  @override
  String get homeAboutMaghribReference =>
      '«Există două momente când cel care postește se bucură… când își întrerupe postul.» (Sahih al-Bukhari, despre iftarul Maghrib)';

  @override
  String get homeAboutIshaTiming =>
      'Începe odată ce amurgul dispare complet și durează până la miezul nopții (sau până la Fajr, după unele păreri).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'A te ruga Isha în congregație echivalează cu a sta în picioare jumătate din noapte în rugăciune.';

  @override
  String get homeAboutIshaReference =>
      '«Cine se roagă Isha în congregație este ca și cum ar fi rugat jumătate din noapte.» (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Înapoi la Onboarding';

  @override
  String get settings => 'Setări';

  @override
  String get appLanguage => 'Limba aplicației';

  @override
  String get tabHome => 'Acasă';

  @override
  String get tabFocus => 'Concentrează-te';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Coranul';

  @override
  String get tabLearn => 'Învață';

  @override
  String get quranLoadFailed => 'Nu s-au încărcat datele Coranului';

  @override
  String get quranTabSubtitle => 'Citiți și explorați Sfântul Coran';

  @override
  String get quranSearchHint => 'Caută sura...';

  @override
  String get quranNoSurahsFound => 'Nu s-au găsit sure';

  @override
  String get quranVersesLabel => 'versuri';

  @override
  String get quranTextOptions => 'Opțiuni de text';

  @override
  String get quranEnglishAndArabic => 'engleză și arabă';

  @override
  String get quranArabicOnly => 'Numai arabă';

  @override
  String get quranIncreaseFont => 'Măriți fontul';

  @override
  String get quranDecreaseFont => 'Reduceți fontul';

  @override
  String get quranPause => 'Pauză';

  @override
  String get quranPlaySurah => 'Joacă sura';

  @override
  String get quranAudioNoInternet =>
      'Fără conexiune la internet. Audio necesită internet.';

  @override
  String get quranAudioTimeout =>
      'Timp de încărcare audio depășit. Verificați conexiunea.';

  @override
  String get quranSurahLabel => 'Sura';

  @override
  String get save => 'Salva';

  @override
  String get tasbihBack => 'Spate';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Selectează un dhikr sau creează-l pe al tău';

  @override
  String get tasbihAddCustomTitle => 'Adăugați Dhikr';

  @override
  String get tasbihEditCustomTitle => 'Editați Dhikr personalizat';

  @override
  String get tasbihArabicOrDhikrHint => 'Text arab sau orice dhikr';

  @override
  String get tasbihTransliterationOptionalHint => 'Transliterare (opțional)';

  @override
  String get tasbihMeaningOptionalHint => 'Semnificație (opțional)';

  @override
  String get tasbihNoTransliteration => 'Fără transliterare';

  @override
  String get tasbihTotalCount => 'Număr total';

  @override
  String get tasbihGrandTotalLabel => 'Total tasbih';

  @override
  String get tasbihTapMe => 'Atingeți-mă';

  @override
  String get tasbihReset => 'Resetați';

  @override
  String get tasbihRestart => 'Repornire';

  @override
  String get tasbihCurrentCount => 'Număr curent';

  @override
  String get tasbihResetTotal => 'Ștergeți istoricul';

  @override
  String get focusModeActivated => 'Modul de focalizare activat';

  @override
  String get focusSetUpHomeCardTitle => 'Configurează modul Focus';

  @override
  String get focusTabSubtitle =>
      'Rămâi concentrat atunci când contează cel mai mult';

  @override
  String get focusChooseAppsEnableMode =>
      'Alege aplicații și activează modul Focus';

  @override
  String get focusNotifAppsLockedTitle => 'Aplicații blocate';

  @override
  String get focusNotifAppsUnlockedTitle => 'Aplicații deblocate';

  @override
  String get focusNotifNightModeTitle => 'Mod nocturn';

  @override
  String get focusNotifGoodMorningTitle => 'Bună dimineața!';

  @override
  String get focusNotifAppsNowAvailableBody =>
      'Aplicațiile sunt acum disponibile.';

  @override
  String get focusNotifSalahLockedBody =>
      'Aplicațiile sunt blocate în timpul Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah finalizată';

  @override
  String get focusNotifSalahCompleteBody =>
      'Aplicațiile sunt deblocate. Fie ca rugăciunea ta să fie acceptată.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return 'Ora $prayerName';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Acordă-ți un moment pentru rugăciunea $prayerName.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'Modul nocturn este activ. Lasă-ți mintea și corpul să se odihnească.';

  @override
  String get focusNotifGenericLockedBody =>
      'Aplicațiile selectate sunt blocate.';

  @override
  String get focusNotifMorningUnlockBody => 'Aplicațiile nu sunt disponibile.';

  @override
  String get widgetDailyVerseTitle => 'Versetul zilei';

  @override
  String get widgetOpenAppTimelineHint =>
      'Deschide Deen Focus pentru a pregăti versetul zilei și datele widgetului de rugăciune.';

  @override
  String get widgetSetLocationForPrayers =>
      'Setează locația în Deen Focus pentru a încărca rugăciunile și versetul zilei.';

  @override
  String get focusChildModeActive => 'Mod copil activ';

  @override
  String get focusSalahAndNightModeActive => 'Salah și modul noapte activ';

  @override
  String get focusSalahModeActive => 'Modul Salah activ';

  @override
  String get focusNightModeActive => 'Mod noapte activ';

  @override
  String get focusAppsToBlockTitle => 'Aplicații de blocat';

  @override
  String get focusAppliesAllModes =>
      'Se aplică tuturor modurilor de focalizare';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Este necesar accesul în timpul ecranului pentru a vizualiza și selecta aplicații.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Vă rugăm să acceptați dezvăluirea accesibilității pentru a continua.';

  @override
  String get focusSelectAppsToBlock => 'Selectați aplicațiile de blocat';

  @override
  String get focusLoading => 'Încărcare...';

  @override
  String get focusOpen => 'Deschide';

  @override
  String get focusHide => 'Ascunde';

  @override
  String get focusLoad => 'Încărca';

  @override
  String get focusShow => 'Spectacol';

  @override
  String get focusSalahFocusModeTitle => 'Modul de focalizare Salah';

  @override
  String get focusBlockAppsDuringPrayer =>
      'Blocați aplicațiile în timpul rugăciunii';

  @override
  String get focusNightDisciplineTitle => 'Disciplina de noapte';

  @override
  String get focusSleepLabel => 'Dormi';

  @override
  String get focusWakeLabel => 'Trezi';

  @override
  String get focusBlockAppsImmediately => 'Blocați imediat aplicațiile';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Activați blocarea aplicațiilor Android';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Pentru a bloca alte aplicații pe Android, Deenly are nevoie de permisiunea de accesibilitate activată. Vom deschide ecranul de setări corect pentru dvs.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Dezvăluirea permisiunii de accesibilitate';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly folosește Accesibilitatea Android pentru a impune blocarea aplicației în modul Focus.\n\nDe ce avem nevoie de el: pentru a detecta când deschideți o aplicație pe care ați selectat-o ​​pentru blocare.\n\nCum îl folosim: doar pentru a identifica aplicația din prim-plan și pentru a afișa ecranul de blocare Focus pentru aplicațiile selectate. Nu îl folosim pentru a citi text scris sau conținut personal.';

  @override
  String get focusNotNow => 'Nu acum';

  @override
  String get focusIUnderstand => 'Am înțeles';

  @override
  String get focusDone => 'Făcut';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Creați obiceiuri de noapte mai bune';

  @override
  String get focusPrayerBlockingDescription =>
      'Aplicațiile vor fi blocate în timpul rugăciunii și se vor debloca automat după 15 minute sau le puteți debloca oricând din ecranul de pornire.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Aplicațiile vor fi blocate în timpul rugăciunii sau le puteți debloca oricând din ecranul de pornire.';

  @override
  String get focusNightBlockingDescription =>
      'Aplicațiile vor fi blocate în timpul ciclului de somn și se vor debloca automat sau le puteți debloca oricând de pe ecranul de pornire';

  @override
  String get focusChildBlockingDescription =>
      'Aplicațiile sunt blocate instantaneu în modul Copil. Deblocați-le folosind comutatorul sau de pe ecranul de pornire';

  @override
  String get settingsEditUsername => 'Editați numele de utilizator';

  @override
  String get settingsEnterYourName => 'Introduceți numele dvs';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Deblocați toate funcțiile';

  @override
  String get settingsManageSubscriptionTitle => 'Gestionează abonamentul';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Vezi planul sau actualizează facturarea';

  @override
  String get settingsUsernameLabel => 'Nume de utilizator';

  @override
  String get settingsLocationLabel => 'Locaţie';

  @override
  String get settingsDarkModeLabel => 'Modul întunecat';

  @override
  String get settingsAboutTitle => 'Despre Deen Focus';

  @override
  String get settingsContactUsTitle => 'Contactați-ne';

  @override
  String get settingsSavingLocation => 'Economisire...';

  @override
  String get settingsSaveLocation => 'Salvați locația';

  @override
  String get settingsAboutTagline =>
      'Concentrează-te. Disciplina. Consecvență.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus te ajută să rămâi conectat la credința ta în timp ce gestionezi distragerile zilnice într-o lume modernă.';

  @override
  String get settingsAboutFeature1 => 'Orele de rugăciune cu memento-uri';

  @override
  String get settingsAboutFeature2 => 'Direcția Qibla oricând';

  @override
  String get settingsAboutFeature3 => 'Coran și Tasbih pentru dhikr zilnic';

  @override
  String get settingsAboutFeature4 => 'Moschei din apropiere';

  @override
  String get settingsAboutFeature5 =>
      'Moduri de focalizare inteligente pentru Salah, somn și timp petrecut cu familia';

  @override
  String get settingsAboutFocusDescription =>
      'Modurile de focalizare inteligente te ajută să blochezi distragerile în timpul Salah, somnului și momentelor importante, pentru a putea rămâne prezent și disciplinat.';

  @override
  String get settingsAboutFooter =>
      'Rămâi constant. Rămâi conștient.\nRămâi conectat la Deen-ul tău.';

  @override
  String get settingsEnableSystemNotifications =>
      'Activați notificările de sistem pentru a activa acest lucru.';

  @override
  String get appDemoTitle => 'Demo aplicație';

  @override
  String get appDemoLoadFailed =>
      'Nu s-a putut încărca videoclipul demonstrativ.';

  @override
  String get appDemoRestartHint =>
      'Videoclipul necesită o repornire completă a aplicației (repornirea la cald poate întrerupe redarea).';

  @override
  String get appDemoPreviewLoadFailed => 'Demo-ul nu a putut fi încărcat.';

  @override
  String get appDemoTryAgain => 'Încearcă din nou';

  @override
  String get appDemoWatchLabel => 'Urmăriți demonstrația';

  @override
  String get homeAiChatTitle => 'Deen Focus AI';

  @override
  String get homeAiAskQuestionHint => 'Pune o intrebare...';

  @override
  String get homeAiSend => 'Trimite';

  @override
  String get homeAiErrorPrefix =>
      'Ne pare rău, am întâmpinat o problemă în timp ce mă conectez la Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Întrebați orice despre islam';

  @override
  String get homeAiEmptySubtitle =>
      'Orele de rugăciune, Coran, Hadith, evenimente islamice și îndrumări spirituale';

  @override
  String get onboardingTypeCityName => 'Introduceți numele orașului dvs..';

  @override
  String get onboardingNoLocationsFound => 'Nu s-au găsit locații';

  @override
  String get onboardingTryAnotherCityName => 'Încercați un alt nume de oraș.';

  @override
  String get qiblaCompassUnavailable =>
      'Busola indisponibilă pe acest dispozitiv';

  @override
  String get qiblaFacing => '✓ Cu fața la Qibla';

  @override
  String get qiblaTurnToFind => 'Întoarceți-vă pentru a găsi Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Distanța până la Mecca';

  @override
  String get qiblaFromNorth => 'din Nord';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'W';

  @override
  String get nearbyMosquesTitle => 'Moscheile din apropiere';

  @override
  String get nearbyMosquesTryAgain => 'Încearcă din nou';

  @override
  String get nearbyMosquesOpenGoogle => 'Deschideți în Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Deschideți în Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'Nu s-au găsit moschei înăuntru';

  @override
  String get nearbyMosquesSearchRadius => 'Raza de cautare: 5 km';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Previzualizarea hărții nu este disponibilă momentan.';

  @override
  String get nearbyMosquesWaitingForLocation => 'În așteptarea locației dvs.';

  @override
  String get nearbyMosquesFetchingLocation => 'Se preia locația…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Locația curentă';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Moscheile din apropiere vor apărea aici odată ce rezultatele se încarcă.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'Nu s-au găsit moschei pe o rază de 5 km';

  @override
  String get nearbyMosquesLocationRequired =>
      'Accesul la locație este necesar pentru a găsi moscheile din apropiere.';

  @override
  String get nearbyMosquesPermissionOff =>
      'Permisiunea pentru locație este dezactivată. Activați-l în setări pentru a vedea moscheile din apropiere.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'Nu am putut citi locația dvs. actuală în acest moment.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'Actualizarea live a eșuat. Se afișează ultimele rezultate salvate. Trageți pentru a reîmprospăta.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Accesul la locație a fost interzis. Activați-l în Setări pentru a vedea moscheile din apropiere.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'Locația este dezactivată pe acest dispozitiv. Activați-l în Setări, apoi încercați din nou.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'Permisiunea pentru locație este încă în curs de procesare. Vă rugăm să încercați din nou peste un moment.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'Solicitarea a durat prea mult. Verificați-vă conexiunea la internet și încercați din nou.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Nu există conexiune la internet sau serviciul este inaccesibil. Verificați conexiunea și încercați din nou.';

  @override
  String get nearbyMosquesFormatError =>
      'Nu am putut citi lista moscheilor chiar acum. Vă rugăm să încercați din nou mai târziu.';

  @override
  String get nearbyMosquesPlatformError =>
      'Nu am putut finaliza acel pas. Verificați conexiunea și încercați din nou.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Ceva a mers prost. Vă rugăm să încercați din nou.';

  @override
  String get nearbyMosquesEmptyHint =>
      'Nimic nu este listat în termen de 5 km pe OpenStreetMap pentru acest loc. Încercați din nou mai târziu sau mutați harta.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count moschei găsite pe o rază de 5 km';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Ștergeți dhikr?';

  @override
  String get tasbihDelete => 'Şterge';

  @override
  String get focusAndroidBlockingNotReady =>
      'Blocarea aplicațiilor pe Android nu e încă gata. Păstrează accesibilitatea activă și așteaptă conectarea.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Nicio aplicație selectată. Alege mai întâi aplicațiile de blocat.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Este necesar accesul la Timp ecran pentru a bloca aplicații pe iPhone.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Ceva nu a mers la actualizarea modului Focus. Încearcă din nou.';

  @override
  String get focusLoadingInstalledApps => 'Se încarcă aplicațiile instalate...';

  @override
  String get focusNoInstalledAppsToShow =>
      'Nu există aplicații instalate de afișat.';

  @override
  String get homeAiSuggestion1 => 'Ce este Ramadanul?';

  @override
  String get homeAiSuggestion2 => 'Ore de rugăciune';

  @override
  String get homeAiSuggestion3 => 'Plan de citire a Coranului';

  @override
  String get homeAiDeveloperPrompt =>
      'Ești un asistent învățat și respectuos în studii islamice. Ajută utilizatorii să învețe tradiții islamice, sărbători, rugăciune, studiul Coranului și practici spirituale. Fii cald, concis, educativ și sensibil cultural. În afara ghidării islamice, răspunde util fără a pretinde certitudine religioasă.';

  @override
  String get homeAiErrorMissingApiKey => 'Lipsește configurarea API.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'Eroare API $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Niciun răspuns de la asistent.';

  @override
  String get homeAiErrorEmptyContent => 'Conținut gol al răspunsului.';

  @override
  String get settingsPrayerCalculationSection => 'Calcul Rugăciune';

  @override
  String get settingsCalculationMethodTitle => 'Metodă de Calcul';

  @override
  String get settingsAsrCalculationTitle => 'Calcul Asr';

  @override
  String get calculationMethodSectionMajorOrgs => 'Organizații Islamice Majore';

  @override
  String get calculationMethodSectionMiddleEast => 'Orientul Mijlociu';

  @override
  String get calculationMethodSectionAsiaPacific => 'Asia-Pacific';

  @override
  String get calculationMethodSectionSpecial => 'Metode Speciale';

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
  String get insightsPrayerStreak => 'Serie de rugăciuni';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => 'Rugăciuni consecutive';

  @override
  String get insightsDaysInARow => 'Zile consecutive';

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
  String get insightsFocusExcellent => 'Excelent — continuă!';

  @override
  String get insightsFocusKeepGoing => 'Continuă să-ți construiești focusul';

  @override
  String get insightsTodaysPrayers => 'Rugăciunile de azi';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Mod ciclu activ';

  @override
  String get insightsProtectedByCycleMode => 'Seria ta este protejată.';

  @override
  String get insightsCurrentPrayerStreak => 'Seria actuală de rugăciuni';

  @override
  String get insightsBestPrayerStreak => 'Cea mai bună serie de rugăciuni';

  @override
  String get insightsCurrentDayStreak => 'Serie actuală de zile';

  @override
  String get insightsCycleProtectedDays => 'Zile protejate de ciclu';

  @override
  String get insightsAchievements => 'Realizări';

  @override
  String get insightsAchieved => 'Realizat';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Cycle Mode days are protected and not counted as streak breaks. You have $days protected day(s) available.';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Activează Modul ciclu pentru a-ți proteja seria în zilele de odihnă.';

  @override
  String get achievementFirstPrayerStreak => 'Prima serie de rugăciuni';

  @override
  String get achievementSevenPrayerStreak => 'Serie de șapte rugăciuni';

  @override
  String get achievementThirtyPrayerStreak => 'Serie de treizeci de rugăciuni';

  @override
  String get achievementFajrWarrior => 'Războinic al Fajr';

  @override
  String get achievementQuranReader => 'Cititor al Coranului';

  @override
  String get achievementDhikrMaster => 'Maestru al Dhikr';

  @override
  String get achievementConsistencyChampion => 'Campion al constanței';

  @override
  String get prayerCompletionAlhamdulillah => 'Alhamdulillah!';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer a fost îndeplinită';
  }

  @override
  String get prayerCompletionStreakIncreased =>
      'Seria ta de rugăciuni a crescut';

  @override
  String get prayerCompletionKeepGoing =>
      'Fiecare rugăciune te apropie de Allah. Continuă!';

  @override
  String get prayerCompletionContinue => 'Continuă';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Următoarea rugăciune în $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes minute';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get weekdayLetterMon => 'L';

  @override
  String get weekdayLetterTue => 'Ma';

  @override
  String get weekdayLetterWed => 'Mi';

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
      'Disciplina de noapte și modul Salah blochează aplicațiile selectate.';

  @override
  String get focusHomeBlockingNight =>
      'Disciplina de noapte blochează aplicațiile selectate.';

  @override
  String get focusHomeBlockingSalah =>
      'Modul Salah blochează aplicațiile selectate.';

  @override
  String get focusHomeAppsBlockedNow =>
      'Aplicațiile selectate sunt blocate acum.';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode este activat.';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes sunt activate.';
  }

  @override
  String get focusHomeChooseMode => 'Alege un mod pentru a-ți proteja atenția';

  @override
  String get focusStatusSelectApps => 'Selectează aplicații pentru a începe';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Disciplina de noapte și modul Salah blochează aplicațiile acum';

  @override
  String get focusStatusBlockingNight =>
      'Disciplina de noapte blochează aplicațiile acum';

  @override
  String get focusStatusBlockingSalah =>
      'Modul Salah blochează aplicațiile acum';

  @override
  String get focusStatusAppsLocked => 'Aplicațiile sunt blocate acum';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Deblocat până la $time';
  }

  @override
  String get focusStatusNoMode => 'Niciun mod focus activat';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Gata să blocheze $targets';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s';
  }
}
