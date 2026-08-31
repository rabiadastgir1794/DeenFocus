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
  String get locationManualEntry => 'Introdu orașul manual';

  @override
  String get locationOrDivider => 'sau';

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
  String get notificationsMaybeLater => 'Poate mai târziu';

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
  String get notificationsPreviewAdhanBody => 'Este timpul să te rogi.';

  @override
  String get notificationsPreviewDhikrTitle => 'Dhikr zilnic';

  @override
  String get notificationsPreviewDhikrBody => 'SubhanAllah — ia-ți un moment.';

  @override
  String get notificationsPreviewStreakTitle => 'Serie';

  @override
  String get notificationsPreviewStreakBody => '7 zile de rugăciuni complete.';

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
  String get onboardingSelectAppsTitlePrefix => 'Selectează';

  @override
  String get onboardingSelectAppsTitleAccent => 'aplicațiile de blocat';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Selectează aplicațiile pe care vrei să le blochezi la ora rugăciunii.';

  @override
  String get onboardingSelectAppsButton => 'Selectează aplicații';

  @override
  String get onboardingSelectAppsSkipForNow => 'Sari peste momentan';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'Tu ai controlul';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'Nu citim niciodată datele tale. Blocăm doar aplicațiile pe care le alegi.';

  @override
  String get onboardingSelectAppsMockAllApps =>
      'Toate aplicațiile și categoriile';

  @override
  String get onboardingSelectAppsMockPhotos => 'Poze';

  @override
  String get onboardingSelectAppsMockNotes => 'Note';

  @override
  String get onboardingSelectAppsMockMusic => 'Muzică';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => 'Podcasturi';

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
  String get onboardingWidgetsLiveTitle =>
      'Rugăciunile tale, mereu la îndemână';

  @override
  String get onboardingWidgetsLiveSubtitle =>
      'Rămâi conectat la ce contează cel mai mult — de pe ecranul principal sau de blocare.';

  @override
  String get onboardingWidgetsSectionTitle => 'Widgeturi';

  @override
  String get onboardingWidgetsSectionBodyPrefix =>
      'Vezi următoarea rugăciune, seriile și progresul ';

  @override
  String get onboardingWidgetsSectionBodyEmphasis => 'dintr-o privire.';

  @override
  String get onboardingLiveActivitiesSectionTitle => 'Live Activity';

  @override
  String get onboardingLiveActivitiesSectionBodyPrefix =>
      'Vezi actualizările rugăciunii următoare în ';

  @override
  String get onboardingLiveActivitiesSectionBodyEmphasis => 'timp real';

  @override
  String get onboardingLiveActivitiesSectionBodySuffix =>
      ' pe ecranul de blocare și Dynamic Island.';

  @override
  String get onboardingWidgetsLiveTrustPrefix =>
      'Creat ca să te ajute să rămâi ';

  @override
  String get onboardingWidgetsLiveTrustEmphasis => 'constant';

  @override
  String get onboardingWidgetsLiveTrustSuffix =>
      ' și să nu ratezi ce contează cel mai mult.';

  @override
  String get onboardingWidgetsMockStreak => 'Serie';

  @override
  String get onboardingWidgetsMockStreakValue => '12 zile';

  @override
  String get onboardingWidgetsMockFocus => 'Focus';

  @override
  String get onboardingWidgetsMockFocusValue => '25 min';

  @override
  String get onboardingWidgetsLiveLockDate => 'Marți, 6 mai';

  @override
  String get onboardingWidgetsLiveLockTime => '9:41';

  @override
  String get onboardingWidgetsLiveNextPrayer => 'Dhuhr 12:45, în 02:15:32';

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
  String get restrictedModeSalahTitle => 'Timpul Salah';

  @override
  String get restrictedModeSalahMessage =>
      'Îndepărtează-te de distrageri și răspunde chemării la rugăciune.';

  @override
  String get restrictedModeSalahInfo =>
      'Folosește acest moment ca să te conectezi cu Allah.';

  @override
  String get restrictedModeSalahQuote =>
      'Stabilește rugăciunea spre pomenirea Mea.';

  @override
  String get restrictedModeSalahQuoteSource => 'Coran 20:14';

  @override
  String get restrictedModeSalahCta => 'Începe Salah';

  @override
  String get restrictedModeChildTitle => 'Mod focus copil';

  @override
  String get restrictedModeChildMessage =>
      'Un spațiu mai sigur și mai echilibrat pentru timpul petrecut pe ecran.';

  @override
  String get restrictedModeChildInfo =>
      'Unele aplicații sunt temporar indisponibile.';

  @override
  String get restrictedModeChildQuote =>
      'Învățați-vă copiii rugăciunea la vârsta de șapte ani.';

  @override
  String get restrictedModeChildQuoteSource => 'Hadith - Abu Dawud';

  @override
  String get restrictedModeChildCta => 'Rămâi protejat';

  @override
  String get restrictedModeNightTitle => 'Mod focus noapte';

  @override
  String get restrictedModeNightMessage =>
      'E timpul să te odihnești și să te deconectezi de distragerile digitale.';

  @override
  String get restrictedModeNightInfo =>
      'Pune dispozitivul deoparte și bucură-te de o noapte liniștită.';

  @override
  String get restrictedModeNightQuote =>
      'Și am făcut somnul vostru un mijloc de odihnă.';

  @override
  String get restrictedModeNightQuoteSource => 'Coran 78:9';

  @override
  String get restrictedModeNightCta => 'Noapte bună';

  @override
  String get restrictedModeAppsUnavailable =>
      'Unele aplicații sunt temporar indisponibile.';

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
  String get investNoCommitment => 'Fără angajament. Anulează oricând.';

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
  String get homeSearchNearbyMosques =>
      'Găsiți moschei din apropiere prin OpenStreetMap.';

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
  String get homeTapPrayerToMark =>
      'Atinge o rugăciune pentru a o marca ca făcută, qada sau ratată.';

  @override
  String get homeSetLocation => 'Setează locația';

  @override
  String get homeEditPrayerSettings => 'Editează setările rugăciunii';

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
  String get calendarTitle => 'Calendar islamic';

  @override
  String get calendarBack => 'Înapoi';

  @override
  String get calendarToday => 'Astăzi';

  @override
  String get calendarTomorrow => 'Mâine';

  @override
  String calendarDaysAway(int days) {
    return '$days zile';
  }

  @override
  String get calendarNoEventsThisWeek =>
      'Niciun eveniment islamic săptămâna aceasta.';

  @override
  String get calendarNoEventsBlessing =>
      'Fie ca Allah să binecuvânteze săptămâna ta cu pace și bunătate.';

  @override
  String get calendarNoUpcomingEvents =>
      'Nu s-au găsit evenimente islamice viitoare.';

  @override
  String get calendarUpcomingEvents => 'Evenimente islamice viitoare';

  @override
  String get calendarUpcomingThisYear => 'Viitoare în acest an';

  @override
  String get calendarThisWeekObservances => 'Săptămâna aceasta';

  @override
  String get calendarLegendCycleDays => 'Zile de ciclu (serie protejată)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% iluminată';
  }

  @override
  String get calendarMoonNew => 'Lună nouă';

  @override
  String get calendarMoonWaxingCrescent => 'Semilună crescătoare';

  @override
  String get calendarMoonFirstQuarter => 'Primul pătrar';

  @override
  String get calendarMoonWaxingGibbous => 'Gibosă crescătoare';

  @override
  String get calendarMoonFull => 'Lună plină';

  @override
  String get calendarMoonWaningGibbous => 'Gibosă descrescătoare';

  @override
  String get calendarMoonLastQuarter => 'Ultimul pătrar';

  @override
  String get calendarMoonWaningCrescent => 'Semilună descrescătoare';

  @override
  String get calendarEventRamadanBegins => 'Începe Ramadanul';

  @override
  String get calendarEventRamadanBeginsDesc => 'Luna postului';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Noaptea Puterii';

  @override
  String get calendarEventEidAlFitr => 'Eid al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc => 'Sărbătoarea întreruperii postului';

  @override
  String get calendarEventDayOfArafah => 'Ziua Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Ziua staționării la Arafah';

  @override
  String get calendarEventEidAlAdha => 'Eid al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Sărbătoarea Sacrificiului';

  @override
  String get calendarEventIslamicNewYear => 'Anul Nou islamic';

  @override
  String get calendarEventIslamicNewYearDesc => '1 Muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Nașterea Profetului';

  @override
  String get calendarEventAshura => 'Ashura';

  @override
  String get calendarEventAshuraDesc => '10 Muharram';

  @override
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Rugăciunea de vineri în congregație';

  @override
  String get calendarEventWhiteDays => 'Zilele albe';

  @override
  String get calendarEventWhiteDaysDesc => 'Zile de post recomandate';

  @override
  String get cycleModeActiveTitle => 'Ciclul tău e o pauză, nu un stop.';

  @override
  String get cycleModeActiveSubtitle => 'Dhikr • Tasbih • Ascultare Coran';

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
  String get cycleModePauseStreaksLabel => 'Protejează seria de rugăciuni';

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
  String get prayerNotificationSubtitleFajr =>
      '„Într-adevăr, recitarea zorilor este întotdeauna martoră.” — Coran 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '„Stabilește rugăciunea la coborârea soarelui...” — Coran 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '„Păziți cu strictețe rugăciunile, mai ales rugăciunea de mijloc.” — Coran 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '„Așadar, slăviți-L pe Allah când ajungeți seara...” — Coran 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '„Stabilește rugăciunea -  până la întunericul nopții.” — Coran 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'Este timpul pentru $prayerName';
  }

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
  String get homeLivePrayerUpdatesTitle => 'Actualizări live pentru rugăciune';

  @override
  String get homeLivePrayerUpdatesBody =>
      'Vezi rugăciunea curentă și următoarea pe ecranul de blocare și Dynamic Island.';

  @override
  String get homeLivePrayerUpdatesCta => 'Activează actualizările live';

  @override
  String get homeWidgetsPromoTitle => 'Widgeturi';

  @override
  String get homeWidgetsPromoBody =>
      'Vezi versetul zilei și orele de rugăciune pe ecranul principal.';

  @override
  String get homeWidgetsPromoCta => 'Adaugă widget';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Noapte';

  @override
  String get focusModeShortChild => 'Copil';

  @override
  String get focusModeLabelSalah => 'Mod Salah';

  @override
  String get focusModeLabelNight => 'Mod noapte';

  @override
  String get focusModeLabelChild => 'Mod copil';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return 'Modurile $first și $second sunt activate';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return 'Modurile $first, $second și $third sunt activate';
  }

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
  String get dailyChecklistSectionDistraction => 'Disciplină personală';

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
  String get supportUsWhatsAppQuestionHowTo => 'Cum folosesc DeenFocus?';

  @override
  String get supportUsWhatsAppQuestionFeature =>
      'Am nevoie de ajutor cu o funcție';

  @override
  String get supportUsWhatsAppQuestionSubscription =>
      'Am o problemă cu abonamentul';

  @override
  String get supportUsEmailSubject => 'Cerere de suport DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'Nu s-a putut deschide acea aplicație pe acest dispozitiv.';

  @override
  String get supportUsLaunchFailed => 'Ceva nu a mers bine. Încearcă din nou.';

  @override
  String get supportUsThankYouTitle => 'JazakAllah khair';

  @override
  String get supportUsThankYouBody =>
      'Mulțumim că susții DeenFocus. Poți contribui din nou oricând.';

  @override
  String get supportUsPurchasePending =>
      'Sprijinul tău este în așteptare. Îl vom confirma după ce Apple finalizează achiziția.';

  @override
  String get supportUsPurchaseFailed =>
      'Nu am putut finaliza plata de sprijin. Te rugăm să încerci din nou.';

  @override
  String get supportUsProductUnavailable =>
      'Această sumă de sprijin nu este disponibilă acum. Te rugăm să încerci mai târziu.';

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
  String get tabQuran => 'Învață';

  @override
  String get tabLearn => 'Învață';

  @override
  String get quranLoadFailed => 'Nu s-au încărcat datele Coranului';

  @override
  String get quranTabSubtitle => 'Citiți și explorați Sfântul Coran';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Caută sura...';

  @override
  String get quranSearchHintExtended => 'Caută sură sau sens...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranNoSurahsFound => 'Nu s-au găsit sure';

  @override
  String get quranVersesLabel => 'versuri';

  @override
  String quranSurahHeaderSubtitle(String name, int count) {
    return '$name • $count versuri';
  }

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
  String get quranModeSurah => 'Sură';

  @override
  String get quranModeJuz => 'Juz';

  @override
  String get quranModePage => 'Pagină';

  @override
  String get quranSwitchToPageView => 'Vizualizare pagină';

  @override
  String get quranSwitchToSurahView => 'Vizualizare sură';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => 'Continuă lectura';

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
    return '$percent% din juz $juz';
  }

  @override
  String get quranBookmarksTitle => 'Marcaje';

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
    return '$count salvate';
  }

  @override
  String get quranQuickTajweed => 'Exercițiu tajwid';

  @override
  String get quranQuickTajweedSub => 'Recită și evaluează';

  @override
  String get quranLastListened => 'Ultima ascultare';

  @override
  String get quranNoneYet => 'Niciunul încă';

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
  String get readingSettingsTajweedPractice => 'Tajweed Coran cu IA';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Recită versete și primește feedback';

  @override
  String get readingSettingsTajweedSeeHowItWorks => 'Vezi cum funcționează';

  @override
  String get quranSeeHowAiQuranTajweedWorks => 'see how AI Quran Tajweed works';

  @override
  String get readingSettingsTajweedDeleteModel => 'Șterge modelul AI';

  @override
  String get readingSettingsTajweedDeleteConfirmTitle =>
      'Ștergi modelul AI Tajweed pentru Coran?';

  @override
  String get readingSettingsTajweedDeleteConfirmBody =>
      'Nu vei putea practica tajweed până nu descarci din nou modelul AI. Astfel se eliberează și spațiu pe dispozitiv.';

  @override
  String get readingSettingsTajweedDeleteConfirmAction => 'Șterge';

  @override
  String get readingSettingsTajweedDeleted => 'Modelul AI Tajweed a fost șters';

  @override
  String get readingSettingsTajweedDeleteFailed =>
      'Nu s-a putut șterge modelul AI Tajweed';

  @override
  String get readingSettingsTajweedFreePreviewTranslation =>
      'În numele lui Allah, Cel Milostiv, Cel Îndurător.';

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
  String get readingSettingsTitle => 'Setări de lectură';

  @override
  String get readingSettingsArabicFontSize => 'Mărimea fontului arab';

  @override
  String get readingSettingsTranslationFontSize =>
      'Mărimea fontului traducerii';

  @override
  String get readingSettingsLineSpacing => 'Spațiere între rânduri';

  @override
  String get readingSettingsDefaultMode => 'Mod de lectură implicit';

  @override
  String get readingSettingsRememberPosition => 'Reține ultima poziție';

  @override
  String get readingSettingsScript => 'Scriere arabă';

  @override
  String get readingSettingsScriptUthmani => 'Uthmani (Hafs)';

  @override
  String get readingSettingsScriptIndopak => 'IndoPak (Hafs)';

  @override
  String get readingSettingsArabicFont => 'Font arab';

  @override
  String get readingSettingsFontUthmanic => 'Uthmanic Hafs';

  @override
  String get readingSettingsFontNooreHuda => 'Noore Huda';

  @override
  String get readingSettingsFontSystem => 'Sistem (nativ)';

  @override
  String get readingSettingsShowTranslation => 'Afișează traducerea';

  @override
  String get readingSettingsShowTransliteration => 'Afișează transliterarea';

  @override
  String get readingSettingsTranslationSection => 'Traducere';

  @override
  String get readingSettingsTranslationLabel => 'Traducere';

  @override
  String get readingSettingsTranslationCurrent => 'Curentă';

  @override
  String get readingSettingsInstalledTranslations => 'Instalate';

  @override
  String get readingSettingsAvailableTranslations => 'Disponibile';

  @override
  String get readingSettingsTranslationInstalled => 'Instalată';

  @override
  String get readingSettingsTranslationSelected => 'Selectată';

  @override
  String get readingSettingsTranslationDownload => 'Descarcă';

  @override
  String get readingSettingsTranslationInstalling => 'Se instalează…';

  @override
  String get readingSettingsTranslationDownloading => 'Se descarcă…';

  @override
  String get readingSettingsLayoutTheme => 'Aspectul Coranului';

  @override
  String get readingSettingsLayoutClassic => 'Mushaf';

  @override
  String get readingSettingsLayoutSimple => 'Simplu';

  @override
  String get readingSettingsLayoutColor => 'Coran colorat';

  @override
  String get readingSettingsColorTheme => 'Temă de lectură';

  @override
  String get readingSettingsColorThemeParchment => 'Pergament';

  @override
  String get readingSettingsColorThemeEmerald => 'Smarald';

  @override
  String get readingSettingsColorThemeMidnight => 'Miezul nopții';

  @override
  String get readingSettingsPreview => 'Previzualizare';

  @override
  String get readingSettingsResetHistoryTitle => 'Resetează datele de lectură';

  @override
  String get readingSettingsResetHistorySubtitle =>
      'Șterge continuarea lecturii, progresul paginilor, semnele de carte și acțiunile rapide';

  @override
  String get readingSettingsResetHistoryConfirmTitle =>
      'Resetezi datele de lectură?';

  @override
  String get readingSettingsResetHistoryConfirmBody =>
      'Se șterg continuarea lecturii, progresul paginilor, semnele de carte, ultima ascultare și scurtăturile Tajweed. Setările de afișare și traducere sunt păstrate.';

  @override
  String get readingSettingsResetHistoryDone =>
      'Datele de lectură au fost șterse';

  @override
  String get readingSettingsResetHistoryButton => 'Resetează';

  @override
  String readingSettingsTranslationDownloadFailed(String name) {
    return 'Nu s-a putut descărca $name. Încearcă din nou când ești online.';
  }

  @override
  String readingSettingsTranslationSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => 'Începe să reciti';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'ACURATEȚEA CUVINTELOR';

  @override
  String get tajweedWordReviewLabel => 'REVIZUIREA CUVINTELOR';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Recită și verifică tajwid';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nazal, 2 timpi';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Rezonanță';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Prelungește vocala';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Unește literele';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Ascunde nun';

  @override
  String get save => 'Salva';

  @override
  String get tasbihBack => 'Înapoi';

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
  String get widgetPrayerProgressTitle => 'Progresul tău de rugăciune';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed din $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'rugăciuni finalizate.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Continuă — mai ai $count rugăciuni azi';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — toate rugăciunile de azi sunt complete';

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
  String get settingsRateDeenFocus => 'Evaluează DeenFocus ⭐';

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
      'Rămâi constant. Rămâi conștient. Rămâi conectat la Deen-ul tău.';

  @override
  String get settingsAboutOffersHeading => 'Ce oferă Deen Focus';

  @override
  String get settingsAboutNewBadge => 'Nou';

  @override
  String get settingsAboutFooterCard =>
      'Instrumente inteligente care te ajută să rămâi conștient, constant și conectat la Deen-ul tău — în fiecare zi.';

  @override
  String get settingsAboutOfferPrayerTimesTitle => 'Ore de rugăciune precise';

  @override
  String get settingsAboutOfferPrayerTimesSubtitle =>
      'Alerte la timp și widget-uri frumoase pentru a rămâne pe drumul cel bun.';

  @override
  String get settingsAboutOfferPrayerStreaksTitle => 'Serii de rugăciuni';

  @override
  String get settingsAboutOfferPrayerStreaksSubtitle =>
      'Construiește consecvență și crește în Deen-ul tău cu urmărirea seriilor zilnice și totale.';

  @override
  String get settingsAboutOfferCycleModeTitle => 'Mod ciclu';

  @override
  String get settingsAboutOfferCycleModeSubtitle =>
      'Pentru menstruație — pune rugăciunile pe pauză, păstrează seria și continuă drumul.';

  @override
  String get settingsAboutOfferQuranTajweedTitle => 'Tajweed Coranic';

  @override
  String get settingsAboutOfferQuranTajweedSubtitle =>
      'Citește, ascultă și exersează tajweed cu feedback în timp real bazat pe IA.';

  @override
  String get settingsAboutOfferLiveActivitiesTitle => 'Live Activities';

  @override
  String get settingsAboutOfferLiveActivitiesSubtitle =>
      'Rămâi la curent cu rugăciunile în desfășurare și sesiunile de focus direct de pe ecranul de blocare.';

  @override
  String get settingsAboutOfferQiblaTitle => 'Qibla și găsitor de moschei';

  @override
  String get settingsAboutOfferQiblaSubtitle =>
      'Găsește direcția Qibla oricând și descoperă moschei din apropiere.';

  @override
  String get settingsAboutOfferFocusModesTitle => 'Moduri de focus';

  @override
  String get settingsAboutOfferFocusModesSubtitle =>
      'Blochează aplicațiile distragătoare în timpul Salah, somnului, studiului sau timpului cu familia.';

  @override
  String get settingsAboutOfferTasbihTitle => 'Tasbih și dhikr';

  @override
  String get settingsAboutOfferTasbihSubtitle =>
      'Tasbih digital care te ajută să-L amintești pe Allah pe parcursul zilei.';

  @override
  String get settingsAboutOfferCalendarTitle => 'Calendar islamic';

  @override
  String get settingsAboutOfferCalendarSubtitle =>
      'Calendar hijri cu date islamice importante și memento-uri.';

  @override
  String get settingsAboutGridNamesTitle => '99 Nume ale lui Allah';

  @override
  String get settingsAboutGridNamesSubtitle =>
      'Învață și reflectează asupra Asma ul-Husna.';

  @override
  String get settingsAboutGridDuasTitle => 'Duas și adhkar';

  @override
  String get settingsAboutGridDuasSubtitle =>
      'Duas de dimineață, seară și zilnice.';

  @override
  String get settingsAboutGridPrayerTitle => 'Rugăciune și metode';

  @override
  String get settingsAboutGridPrayerSubtitle =>
      'Învață Salah, Wudu, Hajj și altele.';

  @override
  String get settingsAboutGridFiqhTitle => 'Fiqh și tradiții';

  @override
  String get settingsAboutGridFiqhSubtitle =>
      'Explorează cunoștințe islamice autentice.';

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
  String get nearbyMosquesTitle => 'Moschei găsite în apropiere';

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
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Raza de căutare: $radiusKm km';
  }

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
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'Nu s-au găsit moschei pe o rază de $radiusKm km';
  }

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
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'Nimic listat în $radiusKm km pe OpenStreetMap pentru acest loc. Încercați mai târziu sau extindeți zona.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count moschei găsite pe o rază de $radiusKm km';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count moschei în apropiere';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'În $radiusKm km · Sortate după distanță';
  }

  @override
  String get nearbyMosquesDirections => 'Indicații';

  @override
  String get nearbyMosquesDenominationSunni => 'Sunit';

  @override
  String get nearbyMosquesDenominationShia => 'Șiit';

  @override
  String get nearbyMosquesDenominationAhlEHadith => 'Ahl-e-Hadith';

  @override
  String get nearbyMosquesDenominationNotSpecified =>
      'Denominație nespecificată';

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
  String get focusDiagnosticButton => 'Diagnostic';

  @override
  String get focusDiagnosticTitle => 'Testează blocarea aplicațiilor';

  @override
  String get focusDiagnosticIntro =>
      'Blochează temporar aplicațiile selectate timp de 60 de secunde cu aceeași blocare ca în modul Focus. Deschide o aplicație blocată pentru a confirma ecranul de blocare DeenFocus.';

  @override
  String focusDiagnosticIntroWithApp(String appName) {
    return 'Blochează temporar aplicațiile selectate timp de 60 de secunde. Încearcă să deschizi $appName pentru a confirma ecranul de blocare DeenFocus.';
  }

  @override
  String get focusDiagnosticStart => 'Pornește testul';

  @override
  String get focusDiagnosticEndEarly => 'Oprește testul';

  @override
  String focusDiagnosticRunning(int seconds) {
    return 'Blocarea este activă ${seconds}s. Comută la o aplicație selectată pentru a testa ecranul de blocare.';
  }

  @override
  String get focusDiagnosticSuccessTitle => 'Test finalizat';

  @override
  String get focusDiagnosticSuccessBody =>
      'Blocarea a fost activată cu aplicațiile selectate. Dacă ai văzut ecranul DeenFocus, blocarea funcționează.';

  @override
  String get focusDiagnosticCancelledTitle => 'Test oprit';

  @override
  String get focusDiagnosticCancelledBody =>
      'Blocarea de diagnostic a fost oprită. Modurile Focus și programele nu au fost modificate.';

  @override
  String get focusDiagnosticMissingAppsTitle =>
      'Selectează aplicații mai întâi';

  @override
  String get focusDiagnosticMissingAppsBody =>
      'Alege cel puțin o aplicație de blocat înainte de test.';

  @override
  String get focusDiagnosticMissingPermissionTitle => 'Permisiune necesară';

  @override
  String get focusDiagnosticMissingPermissionBodyIos =>
      'Este necesar accesul la Timp de ecran. Permite accesul și încearcă din nou.';

  @override
  String get focusDiagnosticMissingPermissionBodyAndroid =>
      'Accesibilitatea Android trebuie activată pentru DeenFocus ca să blocheze aplicații.';

  @override
  String get focusDiagnosticFailedTitle => 'Testul nu a putut porni';

  @override
  String get focusDiagnosticFailedBody =>
      'Blocarea nu s-a activat. Verifică permisiunile și aplicațiile selectate, apoi încearcă din nou.';

  @override
  String get focusDiagnosticClose => 'Gata';

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
    return '$count rugăciuni';
  }

  @override
  String get insightsPrayersInARow => 'Rugăciuni consecutive';

  @override
  String get insightsDaysInARow => 'Zile consecutive';

  @override
  String insightsChipUpToday(int count) {
    return '↑ $count';
  }

  @override
  String get insightsChipDayUp => '↑ 1 astăzi';

  @override
  String get insightsWeeklyCompletion => 'Progres săptămânal';

  @override
  String get insightsMonthlyCompletion => 'Progres lunar';

  @override
  String get insightsThisWeek => 'Săptămâna aceasta';

  @override
  String get insightsThisMonth => 'Luna aceasta';

  @override
  String get insightsOverall => 'Total';

  @override
  String get insightsRateExcellent => 'Excelent';

  @override
  String get insightsRateGood => 'Bine';

  @override
  String get insightsRateFair => 'Acceptabil';

  @override
  String get insightsRateStart => 'Continuă';

  @override
  String get insightsPrayersCompletedWeekly =>
      'Rugăciuni îndeplinite (săptămână)';

  @override
  String get insightsPrayersCompletedMonthly => 'Rugăciuni îndeplinite (lună)';

  @override
  String insightsCompletionSummary(int done, int possible) {
    return 'Ai îndeplinit $done din $possible rugăciuni.\nAlhamdulillah — continuă!';
  }

  @override
  String get insightsFocusExcellent => 'Excelent — continuă!';

  @override
  String get insightsFocusKeepGoing => 'Continuă să-ți construiești focusul';

  @override
  String get insightsTodaysPrayers => 'Rugăciunile de azi';

  @override
  String get insightsPrayersCompletedLabel =>
      'Rugăciuni îndeplinite — Alhamdulillah!';

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
  String get insightsMyProgress => 'Progresul meu';

  @override
  String insightsLevelNumber(int level) {
    return 'Nivelul $level';
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
    return '$xp XP până la nivelul $level';
  }

  @override
  String get insightsMaxLevel => 'NIVEL MAXIM';

  @override
  String insightsAchievementsUnlocked(int unlocked, int total) {
    return '$unlocked / $total deblocate';
  }

  @override
  String get insightsAchievementUnlockedTitle => 'Realizare deblocată';

  @override
  String get insightsLevelUpTitle => 'NIVEL NOU';

  @override
  String get achievementFirstPrayer => 'Prima rugăciune';

  @override
  String get achievementFajrChampion => 'Campion Fajr';

  @override
  String get achievementFiveADay => 'Cinci pe zi';

  @override
  String get achievementPerfectWeek => 'Săptămână perfectă';

  @override
  String get achievementPerfectMonth => 'Lună perfectă';

  @override
  String get achievementQuranDevotee => 'Devotat Coranului';

  @override
  String get achievementDhikrStarter => 'Începutul dhikr-ului';

  @override
  String get achievementNightWorshipper => 'Adorator de noapte';

  @override
  String get achievementMasjidCompanion => 'Însoțitor al moscheii';

  @override
  String get achievementDistractionDefender => 'Apărător al concentrării';

  @override
  String get achievementCycleGuardian => 'Gardian al ciclului';

  @override
  String get achievementProtectedMonth => 'Lună protejată';

  @override
  String get achievementSixMonthJourney => 'Călătorie de șase luni';

  @override
  String get achievementDeenFocusMaster => 'DeenFocus Master';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Zilele de ciclu sunt protejate și nu întrerup seria. Ai $days zi(le) protejată/e.';
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

  @override
  String get appLockDemoIntroTitle =>
      'Vezi cum funcționează blocarea aplicațiilor';

  @override
  String get appLockDemoIntroSubtitle =>
      'Rămâi în DeenFocus. Pe ecranul următor, atinge Instagram ca să vezi pauza la ora rugăciunii.';

  @override
  String get appLockDemoStartButton => 'Pornește demo-ul';

  @override
  String get appLockDemoTryOpeningApp => 'Încearcă să deschizi Instagram';

  @override
  String get appLockDemoSalahModeBadge => 'MOD SALAH';

  @override
  String get appLockDemoTimeToPray => 'Este timpul să te rogi';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Timp rămas: $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'Am făcut $prayerName';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName finalizată';
  }

  @override
  String get appLockDemoStreakIncreased => 'Seria ta de rugăciuni a crescut';

  @override
  String get appLockDemoPrayerStreakLabel => 'SERIE RUGĂCIUNE';

  @override
  String get appLockDemoDayStreakLabel => 'SERIE ZILE';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Următoarea rugăciune în $minutes minute';
  }

  @override
  String get appLockDemoStreakMotivation =>
      'Continuă! Consistența te apropie de Allah.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Roagă-te. Confirmă o dată.\nRevino la ziua ta.';

  @override
  String get appLockDemoCompletionBody =>
      'Blocarea aplicațiilor pune ușor pe pauză aplicațiile selectate în timpul Salah ca să te concentrezi — apoi continui când ești gata.';

  @override
  String get appLockDemoContinueSetup => 'Continuă configurarea';

  @override
  String get appLockDemoAppMessages => 'Mesaje';

  @override
  String get appLockDemoAppCalendar => 'Calendar';

  @override
  String get appLockDemoAppPhotos => 'Poze';

  @override
  String get appLockDemoAppCamera => 'Cameră';

  @override
  String get appLockDemoAppMail => 'Mail';

  @override
  String get appLockDemoAppMaps => 'Hărți';

  @override
  String get appLockDemoAppWeather => 'Vreme';

  @override
  String get appLockDemoAppClock => 'Ceas';

  @override
  String get appLockDemoAppNotes => 'Note';

  @override
  String get appLockDemoAppSettings => 'Setări';

  @override
  String get appLockDemoAppMusic => 'Muzică';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Actualizări rugăciune';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live Activity pentru următoarea rugăciune pe ecranul de blocare';

  @override
  String get liveActivitySectionTitle => 'Live Activities';

  @override
  String get liveActivityStayUpdatedTitle => 'Rămâi la curent dintr-o privire';

  @override
  String get liveActivityStayUpdatedBody =>
      'Vezi următoarea rugăciune și ora ei direct pe ecranul de blocare.';

  @override
  String get liveActivityEnableLabel => 'Activează Live Activity';

  @override
  String get liveActivityPromptNotNow => 'Nu acum';

  @override
  String get liveActivityUnsupported =>
      'Live Activities nu sunt disponibile pe acest dispozitiv.';

  @override
  String get liveActivityPermissionNeeded =>
      'Permite notificările pentru actualizări de rugăciune pe ecranul de blocare.';

  @override
  String get liveActivityPermissionButton => 'Permite notificările';

  @override
  String get liveActivityStatusActive => 'Live Activity este activă';

  @override
  String get liveActivityStatusOff => 'Live Activity este dezactivată';

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
  String get liveActivityNowLabel => 'Acum';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Actualizat la $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer la $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Alarme de rugăciune';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Alarme complete care pot trece de modul silențios';

  @override
  String get prayerAlarmsMasterLabel => 'Activează alarmele de rugăciune';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Programează o alarmă nativă pentru fiecare rugăciune selectată';

  @override
  String get prayerAlarmsSnoozeLabel => 'Durata amânării';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes minute';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Alarme pe rugăciune';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Permite alarma pentru a suna la timp.';

  @override
  String get prayerAlarmsPermissionButton => 'Permite alarme';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Permite alarme pe ecran complet pentru ecranul de blocare. Fără asta apar ca banner.';

  @override
  String get prayerAlarmsFsiButton => 'Setări ecran complet';

  @override
  String get prayerAlarmsUnsupported =>
      'Alarmele native nu sunt disponibile pe acest dispozitiv. Notificările soft funcționează în continuare.';

  @override
  String get prayerAlarmsIosFallback =>
      'Pe această versiune iOS se folosesc notificări soft în loc de AlarmKit.';

  @override
  String get prayerAlarmsDeniedTitle => 'Este necesară permisiunea de alarmă';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Alarmele de rugăciune rămân oprite până acordați permisiunea. Notificările soft nu sunt afectate.';

  @override
  String get prayerAlarmsOpenSettings => 'Deschide Setări';

  @override
  String get prayerAlarmsStatusReady => 'Alarmele sunt gata de programare';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Permisiune necesară — alarmele nu sunt active';

  @override
  String get prayerAlarmsStatusFallback =>
      'Se folosesc notificări soft pe acest dispozitiv';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Alarmele sunt pornite. Activează ecranul complet pentru blocare.';

  @override
  String get prayerAlarmsCancel => 'Nu acum';

  @override
  String get homePrayerAlarmEnableLabel => 'Alarmă de rugăciune';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Sună o alarmă nativă la $prayerName';
  }

  @override
  String get prayerAlarmBadge => 'Alarmă de rugăciune';

  @override
  String get prayerAlarmSubtitle => 'Este timpul să te rogi';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — Este timpul să te rogi';
  }

  @override
  String get prayerAlarmIvePrayed => 'M-am rugat';

  @override
  String get prayerAlarmDismiss => 'Închide';

  @override
  String get prayerAlarmSnooze => 'Amână';

  @override
  String get appLockDemoAppPhone => 'Telefon';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Mementouri';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Cărți';

  @override
  String get appLockDemoAppHealth => 'Sănătate';

  @override
  String get appLockDemoAppWallet => 'Portofel';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'Demo aplicație';

  @override
  String get settingsAppDemoChooseModeTitle => 'Experimentează App Lock';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Alege un mod Focus și vezi cum aplicațiile selectate se pun pe pauză — fără să părăsești DeenFocus.';

  @override
  String get appLockDemoDone => 'Gata';

  @override
  String get appLockDemoSleepIntroTitle => 'Vezi cum funcționează Modul Somn';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Rămâi în DeenFocus. Pe ecranul următor, atinge Instagram ca să vezi pauza la ora de culcare.';

  @override
  String get appLockDemoSleepModeBadge => 'MOD SOMN';

  @override
  String get appLockDemoSleepLockTitle => 'E timpul să te odihnești';

  @override
  String get appLockDemoSleepLockCta => 'Sunt gata să mă odihnesc';

  @override
  String get appLockDemoSleepCompleted => 'Modul Somn protejat';

  @override
  String get appLockDemoSleepRewardSubtitle =>
      'Protecția ta de noapte a crescut';

  @override
  String get appLockDemoSleepStreakLabel => 'SERIE NOAPTE';

  @override
  String get appLockDemoSleepRewardFooter =>
      'Memento Fajr setat pentru dimineață';

  @override
  String get appLockDemoSleepMotivation =>
      'Odihnește-te bine în noaptea asta ca să te trezești cu energie pentru Fajr.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Nopți liniștite.\nDimineți clare.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'Modul Somn pune ușor pe pauză aplicațiile selectate noaptea ca să te odihnești — apoi continui când ești gata.';

  @override
  String get appLockDemoChildIntroTitle => 'Vezi cum funcționează Modul Copil';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Rămâi în DeenFocus. Pe ecranul următor, atinge Instagram ca să vezi blocarea cu Modul Copil.';

  @override
  String get appLockDemoChildModeBadge => 'MOD COPIL';

  @override
  String get appLockDemoChildLockTitle => 'Aplicațiile sunt protejate';

  @override
  String get appLockDemoChildLockDetail =>
      'Aplicațiile selectate rămân blocate cât timp Modul Copil este activ';

  @override
  String get appLockDemoChildLockCta => 'Am înțeles';

  @override
  String get appLockDemoChildCompleted => 'Modul Copil activ';

  @override
  String get appLockDemoChildRewardSubtitle =>
      'Seria ta de protecție a crescut';

  @override
  String get appLockDemoChildStreakLabel => 'SERIE SIGURĂ';

  @override
  String get appLockDemoChildRewardFooter => 'Ieși oricând cu codul tău';

  @override
  String get appLockDemoChildMotivation =>
      'Liniște de fiecare dată când dai telefonul.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'Mod sigur dintr-o atingere.\nDoar ce permiți tu.';

  @override
  String get appLockDemoChildCompletionBody =>
      'Modul Copil blochează aplicațiile selectate ca micuțul tău să vadă doar ce e sigur — apoi deblochezi când ești gata.';

  @override
  String get appLockDemoSleepCompletionTitle =>
      'Odihnește-te bine în noaptea asta';

  @override
  String get appLockDemoChildCompletionTitle => 'Liniște sufletească';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Pune pe pauză distragerile la Salah ca să te rogi cu prezență.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Protejează-ți nopțile ca odihna să vină mai ușor — iar Fajr să fie mai ușor.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Încredințează telefonul liniștit: rămân deschise doar aplicațiile permise.';

  @override
  String get settingsAppDemoHomeFeaturesTitle =>
      'Rămâi conectat dintr-o privire';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'Vezi cum widgeturile și Live Activity țin orele de rugăciune aproape — fără a deschide aplicația.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Daily verse and prayer times on your Home Screen, always up to date.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Current and next prayer on your Lock Screen and Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Recite an ayah and get instant tajweed feedback.';

  @override
  String get featureDemoTajweedTitle => 'Tajwid';

  @override
  String get featureDemoTajweedIntroTitle =>
      'Vezi cum funcționează exercițiul de tajwid';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Rămâi în DeenFocus. Deschide exercițiul de tajwid, recită un verset și vezi feedback cuvânt cu cuvânt.';

  @override
  String get featureDemoTajweedQuranCallout =>
      'Atinge Exercițiu tajwid pentru a începe';

  @override
  String get featureDemoTajweedLegendCallout =>
      'Culorile arată regulile de tajwid pe măsură ce citești';

  @override
  String get featureDemoTajweedReciteCallout =>
      'Atinge Recită și verifică tajwid';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'Descărcare unică pentru a practica offline';

  @override
  String get featureDemoTajweedMicCallout =>
      'Atinge microfonul și începe să reciti';

  @override
  String get featureDemoTajweedResultCallout =>
      'Vezi care cuvinte au fost corecte, omise sau de îmbunătățit';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tajwid, gata';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Recită cu încredere, oricând.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Deschide Coran → Exercițiu tajwid pentru a practica orice verset cu evaluare pe dispozitiv — complet offline după prima descărcare.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatiha';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqara';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 versete • Meccană';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 versete • Medineză';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => 'Al-Fatiha • 7 versete';

  @override
  String get featureDemoTajweedSurahMeta => 'SURA 1 • MECCANĂ';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'În numele lui Allah, Cel Milostiv, Cel Îndurător.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatiha · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'Se pregătește modelul AI';

  @override
  String get featureDemoTajweedPreparingBody =>
      'Descărcare unică pentru ca exercițiul de tajwid să funcționeze apoi complet offline. Se întâmplă o singură dată.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Continuă să exersezi — ascultă referința și încearcă din nou.';

  @override
  String get featureDemoTajweedStatCorrect => 'Corect';

  @override
  String get featureDemoTajweedStatPronunciation => 'Pronunție';

  @override
  String get featureDemoTajweedStatWrong => 'Cuvânt greșit';

  @override
  String get featureDemoTajweedStatMissed => 'Omis';

  @override
  String get featureDemoTajweedStatExtra => 'În plus';

  @override
  String get featureDemoContinue => 'Continuă';

  @override
  String get featureDemoSampleStatusTime => '9:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      'Dispozitivul nu permite aplicațiilor să plaseze widgeturi automat. Adaugă widgetul Large DeenFocus din galeria de pe ecranul principal.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Adaugă widgetul din ecranul principal';

  @override
  String get featureDemoOfferNo => 'Nu';

  @override
  String get featureDemoOfferYes => 'Da';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      'Vrei să activezi Live Activity pe dispozitiv?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      'Vrei să adaugi acest widget pe ecranul principal?';

  @override
  String get featureDemoWidgetsTitle => 'Widgeturi';

  @override
  String get featureDemoWidgetsIntroTitle => 'See your Home Screen widgets';

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
  String get featureDemoLiveActivityIntroTitle => 'See Live Activity in action';

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
  String get appLockDemoOfferPrayerTitle =>
      'Ești gata să încerci Modul Rugăciune?';

  @override
  String get appLockDemoOfferSleepTitle => 'Ești gata să încerci Modul Somn?';

  @override
  String get appLockDemoOfferChildTitle => 'Ești gata să încerci Modul Copil?';

  @override
  String get appLockDemoOfferPrayerCta => 'Activează Modul Rugăciune';

  @override
  String get appLockDemoOfferSleepCta => 'Activează Modul Somn';

  @override
  String get appLockDemoOfferChildCta => 'Activează Modul Copil';

  @override
  String get appLockDemoOfferNotNow => 'Nu acum';

  @override
  String get nightlyWrapUpPrayersTitle => 'Finalizează rugăciunile de azi';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Marchează rugăciunile neterminate sau ratate pentru a-ți proteja seria de rugăciune.';

  @override
  String get nightlyWrapUpChecklistTitle => 'Completează lista zilnică';

  @override
  String get nightlyWrapUpChecklistBody =>
      'Câteva elemente sunt încă deschise — încheie ziua cu intenție.';

  @override
  String get nightlyWrapUpBothTitle => 'Încheie-ți ziua';

  @override
  String get nightlyWrapUpBothBody =>
      'Marchează rugăciunile rămase și termină lista zilnică înainte de sfârșitul zilei.';

  @override
  String get cycleModeEndedNotificationTitle => 'Modul ciclu s-a încheiat';

  @override
  String get cycleModeEndedNotificationBody =>
      'Modul ciclu este acum dezactivat. Poți relua rugăciunea. Dacă vrei să schimbi datele modului ciclu, apasă aici pentru a le edita.';

  @override
  String get libraryHomeTitle => 'Biblioteca islamică';

  @override
  String get libraryHomeSubtitle =>
      'Învață hadithuri, dua, cele 99 de Nume și mai mult';

  @override
  String get libraryHubTitle => 'Biblioteca islamică';

  @override
  String get libraryModuleQuran => 'Coran';

  @override
  String get libraryModuleQuranSub => 'Citește, ascultă și exersează tajweed';

  @override
  String get libraryModuleHadith => 'Hadith';

  @override
  String get libraryModuleHadithSub => 'Colecții din surse autentice';

  @override
  String get libraryModuleDuas => 'Dua și adhkar';

  @override
  String get libraryModuleDuasSub => 'Aminitire de dimineață, seară și zilnică';

  @override
  String get libraryModulePrayerMethods => 'Rugăciune și metode islamice';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, salah, hajj și mai mult';

  @override
  String get libraryModuleFiqh => 'Fiqh și tradiții';

  @override
  String get libraryModuleFiqhSub =>
      'Suniți, șiiți, madhab-uri, Ahl-e Hadith și mai mult';

  @override
  String get libraryModuleNames => '99 Nume ale lui Allah';

  @override
  String get libraryModuleNamesSub =>
      'Învață și reflectează asupra Asma ul-Husna';

  @override
  String get libraryModulePillarsIslam => 'Stâlpii Islamului';

  @override
  String get libraryModulePillarsIslamSub =>
      'Cele cinci fundamente ale credinței în acțiune';

  @override
  String get libraryModulePillarsIman => 'Stâlpii credinței';

  @override
  String get libraryModulePillarsImanSub => 'Cele șase articole ale credinței';

  @override
  String get libraryModuleProphets => 'Profetul Muhammad';

  @override
  String get libraryModuleProphetsSub =>
      'Viața, misiunea și lecțiile sale veșnice';

  @override
  String get libraryModuleOccasions => 'Ocazii islamice';

  @override
  String get libraryModuleOccasionsSub => 'Ramadan, Eid, Hajj și zile sacre';

  @override
  String get libraryKeyLesson => 'Lecție cheie';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current din $total';
  }

  @override
  String get libraryPrevious => 'Anterior';

  @override
  String get libraryNext => 'Următor';

  @override
  String get libraryBookmark => 'Marcaj';

  @override
  String get libraryCopy => 'Copiază';

  @override
  String get libraryShare => 'Distribuie';

  @override
  String get libraryCopied => 'Copiat în clipboard';

  @override
  String get libraryShareCopiedHint => 'Copiat — lipește pentru a distribui';

  @override
  String get libraryShareReference => 'Referință';

  @override
  String get contentShareIntro =>
      'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍';

  @override
  String get contentShareExplore => 'Explorează DeenFocus:';

  @override
  String get contentShareFailed =>
      'Nu s-a putut distribui acum. Încearcă din nou.';

  @override
  String get libraryBookmarkSaved => 'Marcaj salvat';

  @override
  String get libraryBookmarkRemoved => 'Marcaj eliminat';

  @override
  String get libraryTranslation => 'Traducere';

  @override
  String get libraryTransliteration => 'Transliterare';

  @override
  String get libraryMeaning => 'Semnificație';

  @override
  String get libraryBookmarksTitle => 'Elemente de învățare salvate';

  @override
  String get libraryBookmarksSubtitle =>
      'Hadithuri, dua, nume, fiqh și mai mult';

  @override
  String get libraryBookmarksEmpty =>
      'Niciun element salvat încă. Atinge Marcaj pe orice element de învățare pentru a-l salva aici.';

  @override
  String get libraryMarkCompleted => 'Marchează ca finalizat';

  @override
  String get librarySectionCompleted => 'Finalizat';

  @override
  String get libraryReflection => 'Reflecție';

  @override
  String get libraryComingSoonTitle => 'În curând';

  @override
  String get libraryComingSoonBody =>
      'Acest modul este în pregătire. Revino într-o actualizare viitoare.';

  @override
  String get librarySearchHint => 'Caută…';

  @override
  String get libraryHubSearchHint => 'Caută în Învățare…';

  @override
  String get libraryHubSearchSections => 'Secțiuni';

  @override
  String get libraryHubSearchTopics => 'Subiecte';

  @override
  String get librarySearchEmpty => 'Niciun rezultat';

  @override
  String libraryItemCount(int count) {
    return '$count elemente';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown din $total';
  }

  @override
  String libraryContinueFrom(int number) {
    return 'Continuă · $number';
  }

  @override
  String get libraryInProgress => 'În curs';

  @override
  String libraryReference(String source) {
    return 'Referință: $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count dua';
  }

  @override
  String get libraryDuaCategoryMorning => 'Dimineață';

  @override
  String get libraryDuaCategoryEvening => 'Seară';

  @override
  String get libraryDuaCategoryDailyLife => 'Viața de zi cu zi';

  @override
  String get libraryDuaCategorySleep => 'Somn';

  @override
  String get libraryDuaCategoryFood => 'Mâncare';

  @override
  String get libraryDuaCategoryTravel => 'Călătorie';

  @override
  String get libraryDuaCategoryIllness => 'Boală';

  @override
  String get libraryDuaCategoryProtection => 'Protecție';

  @override
  String get libraryDuaCategoryForgiveness => 'Iertare';

  @override
  String get libraryDuaCategoryParents => 'Părinți';

  @override
  String libraryHadithCount(int count) {
    return '$count hadithuri';
  }

  @override
  String get libraryHadithNarrator => 'Narator:';

  @override
  String get libraryHadithSource => 'Sursă:';

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
    return '$count pași';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Pasul $current din $total';
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
  String get libraryGuideJanazah => 'Rugăciunea de înmormântare';

  @override
  String get libraryGuideUmrah => 'Umrah';

  @override
  String get libraryGuideHajj => 'Hajj';

  @override
  String get libraryGuideFasting => 'Post';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawba';

  @override
  String get libraryOccasionImportance => 'Importanță';

  @override
  String get libraryOccasionVirtues => 'Virtuți';

  @override
  String get libraryOccasionRecommendedActs => 'Fapte recomandate';

  @override
  String get libraryFiqhOverview => 'Prezentare generală';

  @override
  String get libraryFiqhKeyPoints => 'Puncte cheie';

  @override
  String get libraryFiqhDifferences => 'Diferențe notabile';

  @override
  String get libraryFiqhCommonGround => 'Puncte comune';

  @override
  String get insightsCompleted => 'Finalizate';

  @override
  String get insightsInProgress => 'În progres';

  @override
  String get insightsKeepGoingTitle => 'Ține-o tot așa!';

  @override
  String get insightsKeepGoingBody =>
      'Faci progrese mari. Fiecare rugăciune contează.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Realizări deblocate';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer => 'Ai făcut prima rugăciune.';

  @override
  String get achievementDescSevenPrayerStreak =>
      'Completează 7 rugăciuni la rând.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Completează 30 de rugăciuni la rând.';

  @override
  String get achievementDescFajrWarrior => 'Roagă Fajr în 14 zile.';

  @override
  String get achievementDescFajrChampion => 'Roagă Fajr în 30 de zile.';

  @override
  String get achievementDescFiveADay =>
      'Completează toate cele cinci rugăciuni într-o zi.';

  @override
  String get achievementDescPerfectWeek =>
      'Completează fiecare rugăciune 7 zile la rând.';

  @override
  String get achievementDescPerfectMonth =>
      'Completează fiecare rugăciune 30 de zile la rând.';

  @override
  String get achievementDescQuranReader => 'Citește Coranul în 7 zile.';

  @override
  String get achievementDescQuranDevotee => 'Citește Coranul în 30 de zile.';

  @override
  String get achievementDescDhikrStarter => 'Completează dhikr în 7 zile.';

  @override
  String get achievementDescDhikrMaster => 'Completează dhikr în 30 de zile.';

  @override
  String get achievementDescNightWorshipper => 'Roagă Tahajjud în 7 zile.';

  @override
  String get achievementDescMasjidCompanion => 'Vizitează moscheea de 7 ori.';

  @override
  String get achievementDescDistractionDefender =>
      'Stai fără distrageri 7 zile.';

  @override
  String get achievementDescCycleGuardian =>
      'Protejează seria cu modul ciclu 7 zile.';

  @override
  String get achievementDescProtectedMonth =>
      'Protejează seria cu modul ciclu 30 de zile.';

  @override
  String get achievementDescConsistencyChampion =>
      'Rămâi consecvent 100 de zile.';

  @override
  String get achievementDescSixMonthJourney => 'Continuă 180 de zile.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Ajungi la DeenFocus Master (nivelul 15).';

  @override
  String get dailyChecklistOptional => 'Opțional';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Controlează furia / Vorbește cu bunătate';

  @override
  String get digitalBalanceTitle => 'Echilibru digital';

  @override
  String get digitalBalanceSubtitle => 'Vezi unde ți se duce timpul';

  @override
  String get digitalBalanceViewCta => 'Vezi echilibrul digital →';

  @override
  String get digitalBalanceTodayLabel => 'Azi';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Alte aplicații';

  @override
  String get digitalBalanceTodayPhoneTime => 'Timpul de telefon de azi';

  @override
  String get digitalBalanceWhereTimeGoes => 'Unde ți se duce timpul';

  @override
  String get digitalBalanceViewAllApps => 'Vezi toate aplicațiile';

  @override
  String get digitalBalanceAllAppsTitle => 'Toate aplicațiile';

  @override
  String get digitalBalanceNoApps =>
      'Nu există încă utilizare de aplicații pentru azi.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen vs. timp digital';

  @override
  String get digitalBalanceYourWeek => 'Săptămâna ta';

  @override
  String get digitalBalanceThisWeek => 'Săptămâna aceasta';

  @override
  String get digitalBalancePhoneUsageLegend => 'Utilizarea telefonului';

  @override
  String get digitalBalanceDailyInsight => 'Nota zilei';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Fiecare minut care îți întărește Deen-ul contează.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'Timpul tău DeenFocus este mai mare săptămâna aceasta decât săptămâna trecută. MashaAllah!';

  @override
  String get digitalBalanceInsightQuietDay =>
      'O zi liniștită deocamdată. Timpul DeenFocus va apărea aici.';

  @override
  String get digitalBalanceGoalTitle => 'Obiectivul tău de timp Deen';

  @override
  String get digitalBalanceAdjustGoal => 'Ajustează obiectivul';

  @override
  String get digitalBalanceGoalReached =>
      'Ai atins obiectivul de azi. MashaAllah!';

  @override
  String get digitalBalanceGoalSheetTitle => 'Timp Deen zilnic';

  @override
  String get digitalBalanceGoalCustomHint => 'Minute pe zi';

  @override
  String get digitalBalanceGoalSave => 'Salvează';

  @override
  String get digitalBalanceGoal15 => '15 min';

  @override
  String get digitalBalanceGoal30 => '30 min';

  @override
  String get digitalBalanceGoal45 => '45 min';

  @override
  String get digitalBalanceGoal60 => '1 oră';

  @override
  String get digitalBalancePermissionTitle =>
      'Înțelege-ți obiceiurile digitale';

  @override
  String get digitalBalancePermissionBody =>
      'Permite DeenFocus să acceseze utilizarea aplicațiilor ca să vezi unde ți se duce timpul și cât dai Deen-ului tău.';

  @override
  String get digitalBalanceEnableUsage => 'Activează utilizarea aplicațiilor';

  @override
  String get digitalBalanceMaybeLater => 'Poate mai târziu';

  @override
  String get digitalBalanceUnavailableTitle =>
      'Utilizarea aplicațiilor nu este disponibilă aici';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple nu partajează Timpul de utilizare cu alte aplicații, așa că Digital Balance nu poate arăta încă utilizarea iPhone. Rugăciunile, seriile și insight-urile funcționează în continuare.';

  @override
  String get digitalBalanceInfoTitle => 'Despre echilibrul digital';

  @override
  String get digitalBalanceInfoBody =>
      'Echilibrul digital te ajută să vezi unde ți se duce timpul și cât dai Deen-ului. Utilizarea rămâne pe dispozitiv.';

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
    return 'DeenFocus · $percent% din timpul de telefon';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% din timpul tău de telefon';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% din timpul de telefon de azi';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% mai mult timp DeenFocus decât săptămâna trecută';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'Ai petrecut $duration în DeenFocus azi. Continuă obiceiul.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'Timpul tău DeenFocus a crescut cu $percent% față de ieri.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / zi';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return '$minutes minute până la obiectivul de azi';
  }

  @override
  String get tajweedPracticeTitle => 'Practică tajweed';

  @override
  String tajweedPracticeAyahTitle(String surah, String ref) {
    return '$surah · $ref';
  }

  @override
  String get tajweedDownloadTitle => 'Se pregătește modelul AI';

  @override
  String get tajweedDownloadFailedTitle => 'Nu s-a putut pregăti modelul AI';

  @override
  String get tajweedDownloadBody =>
      'Descărcare unică, ca practica tajweed să funcționeze apoi complet offline. Se întâmplă o singură dată.';

  @override
  String get tajweedDownloadFinishing => 'Se finalizează configurarea…';

  @override
  String get tajweedDownloadCanLeave =>
      'Poți părăsi acest ecran — descărcarea continuă în fundal.';

  @override
  String get tajweedDownloadTryAgain => 'Încearcă din nou';

  @override
  String get tajweedDownloadPleaseTryAgain => 'Te rugăm să încerci din nou.';

  @override
  String get tajweedErrorFeatureDisabled =>
      'Practica tajweed AI este dezactivată. Activeaz-o mai întâi în Setări.';

  @override
  String get tajweedErrorModelMissing => 'Modelul AI nu este încă instalat.';

  @override
  String get tajweedErrorModelDownloadFailed =>
      'Descărcarea modelului AI a eșuat. Verifică conexiunea și încearcă din nou.';

  @override
  String get tajweedErrorModelLoadFailed =>
      'Modelul AI nu a putut fi încărcat pe acest dispozitiv.';

  @override
  String get tajweedErrorCouldNotPrepare => 'Nu s-a putut pregăti modelul AI.';

  @override
  String get tajweedErrorUnsupported =>
      'Practica tajweed AI nu este disponibilă pe acest dispozitiv.';

  @override
  String get sharePromoTitle => 'Vezi asta pe DeenFocus 🌙';

  @override
  String get sharePromoBody =>
      'O aplicație simplă care te ajută să rămâi concentrat pe Deen, să te rogi la timp și să-ți formezi obiceiuri mai bune.';

  @override
  String get sharePromoDownloadHeading => 'Descarcă DeenFocus:';

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
      'Companionul tău pentru un Deen mai bun, în fiecare zi.';

  @override
  String get shareDownloadCta => 'Descarcă DeenFocus';

  @override
  String get shareAppStoreBadge => 'App Store';

  @override
  String get sharePlayStoreBadge => 'Google Play';

  @override
  String get shareFailed =>
      'Nu s-a putut distribui. Te rugăm să încerci din nou.';

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
  String get insightsLevelName1 => 'Un nou început';

  @override
  String get insightsLevelName2 => 'Primii pași';

  @override
  String get insightsLevelName3 => 'Formarea obiceiului';

  @override
  String get insightsLevelName4 => 'Rugător statornic';

  @override
  String get insightsLevelName5 => 'Inimă consecventă';

  @override
  String get insightsLevelName6 => 'Păzitor al rugăciunii';

  @override
  String get insightsLevelName7 => 'Servitor dedicat';

  @override
  String get insightsLevelName8 => 'Rutină solidă';

  @override
  String get insightsLevelName9 => 'Rugător devotat';

  @override
  String get insightsLevelName10 => 'Neclintit';

  @override
  String get insightsLevelName11 => 'Credință mai profundă';

  @override
  String get insightsLevelName12 => 'Consecvență puternică';

  @override
  String get insightsLevelName13 => 'Ghid al devotamentului';

  @override
  String get insightsLevelName14 => 'Consecvență excepțională';

  @override
  String get insightsLevelName15 => 'DeenFocus Master';

  @override
  String get lockScreenOptionsTitle => 'Stil ecran de blocare';

  @override
  String get lockScreenOptionsSubtitle =>
      'Alege cum apar mementourile de rugăciune';

  @override
  String get lockScreenOptionsHint =>
      'Atinge un stil pentru a deschide aspectul pe tot ecranul.';

  @override
  String get lockScreenDefaultBadge => 'Implicit';

  @override
  String get lockScreenSelectedBadge => 'Selectat';

  @override
  String get lockScreenPreviewLabel => 'Previzualizare';

  @override
  String get lockScreenStyleClassic => 'Memento de rugăciune';

  @override
  String get lockScreenStyleTasbih => 'Contor tasbih';

  @override
  String get lockScreenStyleVerse => 'Versetul zilei';

  @override
  String get lockScreenStyleDua => 'Dua zilei';

  @override
  String get lockScreenStyleQuiz => 'Verificare de cunoștințe';

  @override
  String get lockScreenStyleTimes => 'Ore de rugăciune';

  @override
  String get lockScreenStyleCountdown => 'Numărătoare inversă';

  @override
  String get lockScreenStyleHold => 'Ține apăsat pentru a confirma';

  @override
  String get lockScreenStyleType => 'Tastează pentru a confirma';

  @override
  String get lockScreenStyleMinimal => 'Focus minimal';

  @override
  String get lockScreenItsTimeToPray => 'Este timpul să te rogi:';

  @override
  String lockScreenRemainingTime(String time) {
    return 'Timp rămas: $time';
  }

  @override
  String get lockScreenRemindLater => 'Amintește-mi mai târziu';

  @override
  String get lockScreenNextVerse => 'Versetul următor';

  @override
  String get lockScreenVerseForToday => 'Versetul de azi';

  @override
  String get lockScreenDuaForToday => 'Dua de azi';

  @override
  String get lockScreenTapToCount => 'Atinge oriunde pentru a număra';

  @override
  String get lockScreenHoldHint => 'Apasă lung pentru a confirma';

  @override
  String lockScreenTypeHint(String word) {
    return 'Tastează $word pentru a confirma';
  }

  @override
  String get lockScreenTypeWord => 'ALHAMDULILLAH';

  @override
  String get lockScreenConfirmBeforeAllah =>
      'Confirmă înaintea lui Allah că te-ai rugat.';

  @override
  String get lockScreenQuizCategory => 'Rugăciune';

  @override
  String get lockScreenQuizQuestion =>
      'Câte rugăciuni zilnice sunt obligatorii?';

  @override
  String get lockScreenQuizA => 'Trei';

  @override
  String get lockScreenQuizB => 'Patru';

  @override
  String get lockScreenQuizC => 'Cinci';

  @override
  String get lockScreenQuizCorrect => 'Corect';

  @override
  String get lockScreenQuizIncorrect => 'Incorect';

  @override
  String get lockScreenQuizComplete => 'Verificarea de cunoștințe s-a încheiat';

  @override
  String get lockScreenQuizCategoryFasting => 'Post';

  @override
  String get lockScreenQuizCategoryPillars => 'Stâlpi';

  @override
  String get lockScreenQuizQ2 => 'În ce lună postesc musulmanii?';

  @override
  String get lockScreenQuizQ2A => 'Shawwal';

  @override
  String get lockScreenQuizQ2B => 'Ramadan';

  @override
  String get lockScreenQuizQ2C => 'Muharram';

  @override
  String get lockScreenQuizQ3 => 'Care este primul stâlp al islamului?';

  @override
  String get lockScreenQuizQ3A => 'Salah';

  @override
  String get lockScreenQuizQ3B => 'Shahada';

  @override
  String get lockScreenQuizQ3C => 'Hajj';

  @override
  String get lockScreenTimeUp => 'Timpul a expirat';

  @override
  String get lockScreenHoldRelease =>
      'Continuă să ții apăsat pentru a confirma';

  @override
  String lockScreenCountProgress(int current, int total) {
    return '$current din $total';
  }

  @override
  String get lockScreenVerseTranslation =>
      'Aduceți-vă aminte de Mine, și Eu Îmi voi aduce aminte de voi.';

  @override
  String get lockScreenVerseRef => 'Coran 2:152';

  @override
  String get lockScreenDuaTransliteration => 'Rabbana atina fid-dunya hasanah';

  @override
  String get lockScreenDuaTranslation =>
      'Doamne, dă-ne bine în această lume și bine în Viața de Apoi.';

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

  @override
  String get homeTajweedPromoTitle => 'Tajweed Coranic cu IA';

  @override
  String get homeTajweedPromoBody =>
      'Recită orice verset și primește feedback instant de la IA pentru tajweed.';

  @override
  String get homeTajweedPromoCta => 'Exersează tajweed';

  @override
  String get homeTajweedPromoAiFeedback => 'Feedback IA';

  @override
  String homeTajweedPromoWordAccuracy(int percent) {
    return '$percent% acuratețe cuvinte';
  }

  @override
  String get homeLockScreenPromoTitle => 'Stiluri ecran de blocare';

  @override
  String get homeLockScreenPromoBody =>
      'Personalizează ecranul de blocare cu designuri islamice frumoase și memento-uri utile.';

  @override
  String get homeLockScreenPromoCta => 'Explorează stiluri';

  @override
  String get homeFullScreenAlarmPromoTitle =>
      'Alarmă pe tot ecranul la ora rugăciunii';

  @override
  String get homeFullScreenAlarmPromoBody =>
      'Rămâi pe drumul cel bun cu o alertă calmă, fără distrageri, pe tot ecranul când e timpul să te rogi.';

  @override
  String get homeFullScreenAlarmPromoCta => 'Activează alarmele de rugăciune';

  @override
  String get homeFullScreenAlarmPromoSlideToStop => 'Glisează pentru oprire';

  @override
  String get homePromoNewBadge => 'NOU';

  @override
  String get homeReadQuranPromoTitle => 'Citește Coranul';

  @override
  String get homeReadQuranPromoSubtitle =>
      'Citește, ascultă și exersează tajweed';

  @override
  String get homeReadQuranPromoCta => 'Deschide Coranul';

  @override
  String get homeReadQuranPromoNewBadge => 'Nou';

  @override
  String cycleModeActiveStatus(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Serie protejată • Se termină în $days zile',
      one: 'Serie protejată • Se termină mâine',
      zero: 'Serie protejată • Se termină azi',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeProtectPrayerStreakSubtitle =>
      'Păstrează seria intactă în zilele de ciclu';

  @override
  String get cycleModeExcludeFromStatisticsSubtitle =>
      'Nu include zilele de ciclu în statisticile de rugăciune';

  @override
  String get homePromoPreviewCity => 'Lahore';

  @override
  String get focusScreenTimeAuthPasscodeRequired =>
      'Acest iPhone are nevoie de un cod de dispozitiv înainte ca Apple să permită accesul la Timp ecran. Setează-l în Setări, apoi încearcă din nou.';

  @override
  String get focusScreenTimeAuthCanceled =>
      'Accesul la Timp ecran a fost anulat înainte ca Apple să-l acorde. Încearcă din nou și finalizează solicitarea Apple.';

  @override
  String get focusScreenTimeAuthConflict =>
      'O altă aplicație gestionează deja Controalele parentale pe acest iPhone. Dezactiveaz-o mai întâi, apoi încearcă din nou.';

  @override
  String get focusScreenTimeAuthInvalidAccount =>
      'Autentifică-te cu un cont iCloud valid pe acest iPhone, apoi încearcă din nou accesul la Timp ecran.';

  @override
  String get focusScreenTimeAuthNetwork =>
      'Acest iPhone are nevoie de internet pentru ca Apple să poată acorda accesul la Timp ecran.';

  @override
  String get focusScreenTimeAuthRestricted =>
      'Controalele parentale sunt restricționate pe acest iPhone, deci DeenFocus nu poate solicita aici accesul la Timp ecran.';

  @override
  String get focusScreenTimeAuthUnavailable =>
      'Controalele parentale nu sunt disponibile momentan pe acest iPhone.';

  @override
  String get focusScreenTimeAuthIosVersion =>
      'Blocarea aplicațiilor prin Timp ecran necesită iOS 16 sau o versiune ulterioară.';

  @override
  String get focusScreenTimeAuthInvalidArgument =>
      'Cererea de autorizare Timp ecran este invalidă. Încearcă din nou.';

  @override
  String get focusScreenTimeAuthFailedGeneric =>
      'Accesul la Timp ecran nu a putut fi acordat pe acest iPhone.';

  @override
  String widgetLockCountdownHoursMinutes(String hours, String minutes) {
    return 'În $hours h $minutes min';
  }

  @override
  String widgetLockCountdownMinutes(String minutes) {
    return 'În $minutes min';
  }

  @override
  String get lockScreenRecommendedBadge => 'Recomandat';
}
