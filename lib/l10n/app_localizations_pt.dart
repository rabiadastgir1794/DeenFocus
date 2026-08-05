// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Deen Foco';

  @override
  String get appTagline => 'Fé. Foco. Consistência';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline =>
      'Modo de oração. Modo infantil. Modo de suspensão.';

  @override
  String get welcomeDescription =>
      'Acompanhe suas orações, leia o Alcorão, conte Tasbih e crie sequências significativas - tudo em um só lugar.';

  @override
  String get skip => 'Pular';

  @override
  String get notNow => 'Agora não';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueForFree => 'Continuar com o plano gratuito';

  @override
  String get getStarted => 'Desbloquear Premium';

  @override
  String get language => 'Linguagem';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get openSettings => 'Abra Configurações';

  @override
  String get locationRequired => 'Localização obrigatória';

  @override
  String get locationRequiredMessage =>
      'O acesso ao local é necessário para calcular tempos de oração precisos e direção Qibla. Você deve habilitá-lo para usar o aplicativo.';

  @override
  String get notificationsRequired => 'Notificações necessárias';

  @override
  String get notificationsRequiredMessage =>
      'As notificações são necessárias para receber alertas e lembretes de momentos de oração.';

  @override
  String get sectTitle => 'Escolha sua seita';

  @override
  String get sectSubtitle => 'Isso nos ajuda a personalizar sua experiência';

  @override
  String get sectSunni => 'Sunita';

  @override
  String get sectShia => 'Xiita';

  @override
  String get sectPreferNotToSay => 'Prefiro não dizer';

  @override
  String get nameTitle => 'Qual o seu nome?';

  @override
  String get nameSubtitle => 'Vamos personalizar sua saudação';

  @override
  String get namePlaceholder => 'Seu nome';

  @override
  String get locationTitle => 'Find Your Qibla';

  @override
  String get locationSubtitle =>
      'Enable location for accurate Qibla, prayer times and nearby masjids.';

  @override
  String get locationButton => 'Permitir acesso ao local';

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
  String get notificationsButton => 'Habilitar notificações';

  @override
  String get notificationsEnabled => 'As notificações estão ativadas';

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
  String get screenTimeTitle => 'Ativar Tempo de Uso';

  @override
  String get screenTimeSubtitle =>
      'Isso permite que o Deen Focus pause apps que distraem durante Salah, sono e modo criança.';

  @override
  String get screenTimeButton => 'Permitir acesso ao Tempo de Uso';

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
  String get focusPrayerModeTitle => 'Modo de Oração';

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
  String get focusSleepModeTitle => 'Modo de suspensão';

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
  String get focusChildModeTitle => 'Modo infantil';

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
  String get investTitle => 'Invista no seu Deen';

  @override
  String get investSubtitle =>
      'Você não pensa duas vezes antes de gastar com café ou lanches...';

  @override
  String get investComparisonTitle =>
      'Assine o Premium ou continue gratuitamente';

  @override
  String get investDailyCoffee => 'Café diário';

  @override
  String get investDailyCoffeePrice => 'US\$ 5/dia';

  @override
  String get investFastFood => 'Comida rápida';

  @override
  String get investFastFoodPrice => 'US\$ 10/refeição';

  @override
  String get investYourDeen => 'Seu Deen';

  @override
  String get investYourDeenPrice => 'US\$ 4,99/mês';

  @override
  String get investComparisonQuote =>
      'Você gasta US\$ 10 em pequenas coisas sem pensar – por que não investir no seu Deen?';

  @override
  String get bestValueTag => 'MELHOR VALOR';

  @override
  String get mostPopularChoice => 'Escolha mais popular';

  @override
  String get monthlyPriceValue => 'US\$ 4,99';

  @override
  String get monthlyPriceSuffix => '/mês';

  @override
  String get monthlyPlanSubtitle =>
      'Faturado mensalmente • Cancele a qualquer momento';

  @override
  String get yearlyPriceValue => 'US\$ 24,99';

  @override
  String get yearlyPriceSuffix => '/ano';

  @override
  String get yearlyPlanSubtitle => 'Economize 50% • Faturado anualmente';

  @override
  String get lifetimePriceValue => 'US\$ 79,99';

  @override
  String get lifetimePriceSuffix => 'vida';

  @override
  String get lifetimePlanSubtitle => 'Compra única • Acesso permanente';

  @override
  String get everythingYouGet => 'Tudo que você consegue';

  @override
  String get featureFocusModeAllModes =>
      'Modo de foco ilimitado com todos os 3 modos';

  @override
  String get featurePrayerAnalyticsStreaks =>
      'Análises e sequências avançadas de oração';

  @override
  String get featureAiAssistant => 'Assistente islâmico de IA';

  @override
  String get featurePrioritySupportEarlyAccess =>
      'Suporte prioritário e acesso antecipado';

  @override
  String get socialProofPrefix => 'Juntar';

  @override
  String get socialProofHighlight => 'Mais de 10.000';

  @override
  String get socialProofSuffix =>
      'Muçulmanos já estão crescendo com Deen Focus';

  @override
  String get mostPopular => 'Mais populares';

  @override
  String get monthlyLabel => 'Mensal';

  @override
  String get monthlyPrice =>
      'US\$ 4,99/mês · cobrança mensal · cancelamento a qualquer momento';

  @override
  String get yearlyLabel => 'Anual';

  @override
  String get yearlyPrice =>
      'US\$ 24,99/ano · economize 50% · faturado anualmente';

  @override
  String get lifetimeLabel => 'Vida';

  @override
  String get lifetimePrice =>
      'US\$ 79,99 vitalícios · compra única · acesso eterno';

  @override
  String get featurePrayerAnalytics => 'Análise avançada de oração';

  @override
  String get featureFocusMode => 'Modo de foco ilimitado';

  @override
  String get featureMasjidMode => 'Modo automático Masjid';

  @override
  String get featureNoAds => 'Remove todos os anúncios';

  @override
  String get featureSupport => 'Suporte prioritário';

  @override
  String get homeTitle => 'Casa Deenly';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback =>
      'Na verdade, com as dificuldades vem a facilidade.';

  @override
  String get homeAppsLocked => 'Aplicativos bloqueados';

  @override
  String get homeAppsUnlocked => 'Aplicativos desbloqueados';

  @override
  String get homeTapToUnlock =>
      'Toque para desbloquear aplicativos temporariamente';

  @override
  String get homeTapToRelock =>
      'Toque para bloquear novamente aplicativos bloqueados agora';

  @override
  String get homeRelock => 'Bloquear novamente';

  @override
  String get homeUnlock => 'Desbloquear';

  @override
  String get homePrayerModeActive => 'Modo Oração Ativo';

  @override
  String get homeActivatePrayerMode => 'Ative o modo de oração';

  @override
  String get homeAppsBlockedSubtitle =>
      'Os aplicativos estão bloqueados. Toque para desativar.';

  @override
  String get homeBlockDistractingApps =>
      'Bloqueie aplicativos que distraem durante o Salah.';

  @override
  String get homeQiblaDirection => 'Direção Qibla';

  @override
  String get homeLocationMissingForQibla =>
      'Ative a localização para calcular a direção Qibla.';

  @override
  String get homeQiblaSubtitleGuiding => 'Guiando você em direção à Qibla';

  @override
  String get homeToMakkah => 'para Meca';

  @override
  String get homeFindMasjid => 'Encontre Masjid perto de mim';

  @override
  String get quickActionsMasjidFinder => 'Encontrar mesquita';

  @override
  String get homeSearchNearbyMosques => 'Pesquise mesquitas próximas.';

  @override
  String get homePrayerStreak => 'Sequências de Oração';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Insights';

  @override
  String get homeOpenStreakDetails => 'Detalhes da sequência aberta.';

  @override
  String get homeTodaysPrayers => 'Orações de hoje';

  @override
  String get homePrayerTimesUnavailable =>
      'Os horários de oração não estão disponíveis no momento.';

  @override
  String get homeNextPrayerIn => 'Próxima oração em';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Nascer do sol';

  @override
  String get homePrayerDhuhr => 'Duhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Magreb';

  @override
  String get homePrayerIsha => 'Isha';

  @override
  String get homeWeek => 'Semana';

  @override
  String get homeMonth => 'Mês';

  @override
  String get homeThisWeek => 'Destaques de Deen esta semana';

  @override
  String get homeJummahMubarak => 'Jummah Mubarak';

  @override
  String get homeJummahReminder => 'Não se esqueça da Surata Al-Kahf.';

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
      'Durante este período, a sua sequência está protegida. Os dias do ciclo ficam destacados a rosa e o Modo ciclo desliga-se automaticamente no fim do ciclo.';

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
  String get cycleModeSettingsTitle => 'Modo ciclo';

  @override
  String get cycleModeStartDateLabel => 'Data de início';

  @override
  String get cycleModeLengthLabel => 'Duração do ciclo';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Pausar sequências';

  @override
  String get cycleModeExcludeFromStatisticsLabel => 'Excluir das estatísticas';

  @override
  String get cycleModeSaveButton => 'Guardar';

  @override
  String get cycleModeEditButton => 'Editar';

  @override
  String get cycleModeChangeStartDateTitle => 'Alterar a data de início?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Alterar a data de início irá recalcular a janela ativa do Modo ciclo. Os dias fora do novo intervalo podem deixar de ser tratados como dias de ciclo.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Alterar data de início';

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
  String get dailyChecklistSectionPrayer => 'Oração';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Alcorão e Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Boas ações';

  @override
  String get dailyChecklistSectionDistraction => 'Controle de distração';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Quran';

  @override
  String get dailyChecklistMorningAdhkar => 'Morning Adhkar';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar da noite';

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
  String get focusScoreTitle => 'Pontuação de foco de hoje';

  @override
  String get focusScorePrayer => 'Oração';

  @override
  String get focusScoreQuran => 'Alcorão';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Controle de distração';

  @override
  String get insightsBack => 'Voltar';

  @override
  String get insightsTitle => 'Meus insights';

  @override
  String get insightsSubtitle => 'Acompanhe seu progresso no Deen';

  @override
  String get insightsPrayerRate => 'Taxa de oração';

  @override
  String get insightsDayStreak => 'Sequência diária';

  @override
  String get insightsBestStreak => 'Melhor sequência';

  @override
  String get insightsWeekly => 'Semanal';

  @override
  String get insightsMonthly => 'Mensal';

  @override
  String get insightsPrayersCompleted => 'Orações concluídas';

  @override
  String get insightsRestoreStreak =>
      'Restaurar minha sequência — últimas 24 horas';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Oração $prayerPercent% · Alcorão $quranPercent% · Dhikr $dhikrPercent% · Distração $distractionPercent%';
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
      'Pergunte qualquer coisa sobre momentos de oração, Alcorão e orientação islâmica.';

  @override
  String get homeDay => 'Dia';

  @override
  String get homeDays => 'Dias';

  @override
  String get homeNoEventsFoundForDay =>
      'Nenhum evento encontrado para este dia.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — marcar como';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Rezada no horário';

  @override
  String get homeMarkPrayerQada => 'Qada (recuperada)';

  @override
  String get homeMarkPrayerMissed => 'Perdida';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return 'Configurações de $prayerName';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Horário da oração';

  @override
  String get homePrayerSettingsNotification => 'Notificação';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Virtudes, regras e mais';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Estas configurações são apenas para $prayerName. Você pode definir preferências diferentes para cada oração.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'Editar horário de $prayerName';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Horário atual';

  @override
  String get homeEditPrayerTimeSelectNew => 'Selecionar novo horário';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Este horário personalizado se aplica apenas a $prayerName. Ajuste se sua mesquita local ou o cálculo forem diferentes.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Salvar horário';

  @override
  String get homeEditPrayerTimeReset => 'Redefinir para o horário calculado';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Notificação de $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Som da notificação';

  @override
  String get homeNotificationSoundFullAdhan => 'Adhan completo';

  @override
  String get homeNotificationSoundFullAdhanSubtitle => 'Tocar o Adhan completo';

  @override
  String get homeNotificationSoundBeep => 'Bipe';

  @override
  String get homeNotificationSoundBeepSubtitle => 'Um tom curto de notificação';

  @override
  String get homeNotificationSoundMute => 'Mudo';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Sem som';

  @override
  String get homeNotificationEnableLabel => 'Ativar notificação';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Ser notificado no horário de $prayerName';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'Sobre $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Horário';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakats';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Virtudes';

  @override
  String get homeAboutPrayerReferenceLabel => 'Referência';

  @override
  String get homeAboutFajrTiming =>
      'Começa no verdadeiro amanhecer (Fajr Sadiq) e termina ao nascer do sol.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Quem reza o Fajr está sob a proteção de Allah.';

  @override
  String get homeAboutFajrReference =>
      '«As duas rakʿāt do Fajr são melhores do que o mundo e tudo o que ele contém.» (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Começa quando o sol passa do zênite e dura até o início do Asr.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Parte das 12 rakʿāt voluntárias diárias pelas quais Allah constrói uma casa no Paraíso.';

  @override
  String get homeAboutDhuhrReference =>
      '«Quem rezar doze rakʿāt durante um dia e uma noite terá uma casa construída para si no Paraíso.» (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Começa quando a sombra de um objeto iguala o seu comprimento e dura até o pôr do sol.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Guardar esta oração é destacada com recompensa e aviso especiais.';

  @override
  String get homeAboutAsrReference =>
      '«Quem perde a oração do Asr é como se tivesse perdido a família e a riqueza.» (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Começa logo após o pôr do sol e dura até o crepúsculo vermelho desaparecer.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Um momento em que as súplicas são especialmente incentivadas.';

  @override
  String get homeAboutMaghribReference =>
      '«Há duas ocasiões em que quem jejua se alegra… quando quebra o jejum.» (Sahih al-Bukhari, sobre o iftar do Maghrib)';

  @override
  String get homeAboutIshaTiming =>
      'Começa quando o crepúsculo desaparece por completo e dura até meia-noite (ou até o Fajr, segundo algumas opiniões).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Rezar Isha em congregação equivale a ficar de pé metade da noite em oração.';

  @override
  String get homeAboutIshaReference =>
      '«Quem rezar Isha em congregação é como se tivesse orado metade da noite.» (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Voltar para integração';

  @override
  String get settings => 'Configurações';

  @override
  String get appLanguage => 'Idioma do aplicativo';

  @override
  String get tabHome => 'Lar';

  @override
  String get tabFocus => 'Foco';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Alcorão';

  @override
  String get tabLearn => 'Aprender';

  @override
  String get quranLoadFailed => 'Falha ao carregar dados do Alcorão';

  @override
  String get quranTabSubtitle => 'Leia e explore o Alcorão Sagrado';

  @override
  String get quranSearchHint => 'Pesquisar surata...';

  @override
  String get quranNoSurahsFound => 'Nenhuma surata encontrada';

  @override
  String get quranVersesLabel => 'versos';

  @override
  String get quranTextOptions => 'Opções de texto';

  @override
  String get quranEnglishAndArabic => 'Inglês e árabe';

  @override
  String get quranArabicOnly => 'Apenas árabe';

  @override
  String get quranIncreaseFont => 'Aumentar fonte';

  @override
  String get quranDecreaseFont => 'Diminuir fonte';

  @override
  String get quranPause => 'Pausa';

  @override
  String get quranPlaySurah => 'Jogue surata';

  @override
  String get quranAudioNoInternet =>
      'Sem conexão com a internet. O áudio requer internet.';

  @override
  String get quranAudioTimeout =>
      'Tempo limite de carregamento de áudio. Verifique sua conexão.';

  @override
  String get quranSurahLabel => 'Surata';

  @override
  String get save => 'Salvar';

  @override
  String get tasbihBack => 'Voltar';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Selecione um dhikr ou crie o seu próprio';

  @override
  String get tasbihAddCustomTitle => 'Adicionar Dhikr';

  @override
  String get tasbihEditCustomTitle => 'Editar Dhikr personalizado';

  @override
  String get tasbihArabicOrDhikrHint => 'Texto árabe ou qualquer dhikr';

  @override
  String get tasbihTransliterationOptionalHint => 'Transliteração (opcional)';

  @override
  String get tasbihMeaningOptionalHint => 'Significado (opcional)';

  @override
  String get tasbihNoTransliteration => 'Sem transliteração';

  @override
  String get tasbihTotalCount => 'Contagem total';

  @override
  String get tasbihGrandTotalLabel => 'Total do tasbih';

  @override
  String get tasbihTapMe => 'Toque em mim';

  @override
  String get tasbihReset => 'Reiniciar';

  @override
  String get tasbihRestart => 'Reiniciar';

  @override
  String get tasbihCurrentCount => 'Contagem atual';

  @override
  String get tasbihResetTotal => 'Limpar histórico';

  @override
  String get focusModeActivated => 'Modo de foco ativado';

  @override
  String get focusSetUpHomeCardTitle => 'Configurar o modo Foco';

  @override
  String get focusTabSubtitle => 'Mantenha o foco quando for mais importante';

  @override
  String get focusChooseAppsEnableMode => 'Escolha apps e ative o modo Foco';

  @override
  String get focusNotifAppsLockedTitle => 'Apps bloqueados';

  @override
  String get focusNotifAppsUnlockedTitle => 'Apps desbloqueados';

  @override
  String get focusNotifNightModeTitle => 'Modo noturno';

  @override
  String get focusNotifGoodMorningTitle => 'Bom dia!';

  @override
  String get focusNotifAppsNowAvailableBody =>
      'Os aplicativos já estão disponíveis.';

  @override
  String get focusNotifSalahLockedBody =>
      'Os aplicativos ficam bloqueados durante a Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah concluída';

  @override
  String get focusNotifSalahCompleteBody =>
      'Os apps foram desbloqueados. Que a sua oração seja aceita.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return 'Hora de $prayerName';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Reserve um momento para a oração de $prayerName.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'O modo noturno está ativo. Deixe sua mente e corpo descansarem.';

  @override
  String get focusNotifGenericLockedBody =>
      'Os aplicativos selecionados estão bloqueados.';

  @override
  String get focusNotifMorningUnlockBody =>
      'Os aplicativos não estão disponíveis.';

  @override
  String get widgetDailyVerseTitle => 'Verso do dia';

  @override
  String get widgetOpenAppTimelineHint =>
      'Abra o Deen Focus para preparar o verso do dia e os dados do widget de oração.';

  @override
  String get widgetSetLocationForPrayers =>
      'Defina sua localização no Deen Focus para carregar orações e o verso do dia.';

  @override
  String get focusChildModeActive => 'Modo infantil ativo';

  @override
  String get focusSalahAndNightModeActive => 'Salah e modo noturno ativos';

  @override
  String get focusSalahModeActive => 'Modo Salah ativo';

  @override
  String get focusNightModeActive => 'Modo noturno ativo';

  @override
  String get focusAppsToBlockTitle => 'Aplicativos para bloquear';

  @override
  String get focusAppliesAllModes => 'Aplica-se a todos os modos de foco';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'O acesso ao tempo de tela é necessário para visualizar e selecionar aplicativos.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Aceite a divulgação de acessibilidade para continuar.';

  @override
  String get focusSelectAppsToBlock => 'Selecione aplicativos para bloquear';

  @override
  String get focusLoading => 'Carregando...';

  @override
  String get focusOpen => 'Abrir';

  @override
  String get focusHide => 'Esconder';

  @override
  String get focusLoad => 'Carregar';

  @override
  String get focusShow => 'Mostrar';

  @override
  String get focusSalahFocusModeTitle => 'Modo de foco Salah';

  @override
  String get focusBlockAppsDuringPrayer =>
      'Bloquear aplicativos durante a oração';

  @override
  String get focusNightDisciplineTitle => 'Disciplina Noturna';

  @override
  String get focusSleepLabel => 'Dormir';

  @override
  String get focusWakeLabel => 'Acordar';

  @override
  String get focusBlockAppsImmediately => 'Bloqueie aplicativos imediatamente';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Ative o bloqueio de aplicativos Android';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Para bloquear outros aplicativos no Android, o Deenly precisa que sua permissão de acessibilidade esteja ativada. Abriremos a tela de configurações correta para você.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Divulgação de permissão de acessibilidade';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly usa o Android Accessibility para impor o bloqueio de aplicativos no modo Focus.\n\nPor que precisamos disso: para detectar quando você abre um aplicativo selecionado para bloqueio.\n\nComo o usamos: apenas para identificar o aplicativo em primeiro plano e mostrar a tela do bloco Focus para aplicativos selecionados. Não o utilizamos para ler texto digitado ou conteúdo pessoal.';

  @override
  String get focusNotNow => 'Agora não';

  @override
  String get focusIUnderstand => 'Eu entendo';

  @override
  String get focusDone => 'Feito';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Crie melhores hábitos noturnos';

  @override
  String get focusPrayerBlockingDescription =>
      'Os aplicativos serão bloqueados durante a oração e desbloqueados automaticamente após 15 minutos, ou você pode desbloqueá-los a qualquer momento na tela inicial.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Os aplicativos serão bloqueados durante a oração, ou você pode desbloqueá-los a qualquer momento na tela inicial.';

  @override
  String get focusNightBlockingDescription =>
      'Os aplicativos serão bloqueados durante o seu ciclo de sono e desbloqueados automaticamente, ou você pode desbloqueá-los a qualquer momento na tela inicial';

  @override
  String get focusChildBlockingDescription =>
      'Os aplicativos são bloqueados instantaneamente no modo infantil. Desbloqueie-os usando o botão de alternância ou na tela inicial';

  @override
  String get settingsEditUsername => 'Editar nome de usuário';

  @override
  String get settingsEnterYourName => 'Digite seu nome';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Desbloqueie todos os recursos';

  @override
  String get settingsManageSubscriptionTitle => 'Gerenciar assinatura';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Ver plano ou atualizar cobrança';

  @override
  String get settingsUsernameLabel => 'Nome de usuário';

  @override
  String get settingsLocationLabel => 'Localização';

  @override
  String get settingsDarkModeLabel => 'Modo escuro';

  @override
  String get settingsAboutTitle => 'Sobre Deen Focus';

  @override
  String get settingsContactUsTitle => 'Contate-Nos';

  @override
  String get settingsSavingLocation => 'Salvando...';

  @override
  String get settingsSaveLocation => 'Salvar localização';

  @override
  String get settingsAboutTagline => 'Foco. Disciplina. Consistência.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus ajuda você a permanecer conectado à sua fé enquanto gerencia distrações diárias em um mundo moderno.';

  @override
  String get settingsAboutFeature1 => 'Horários de oração com lembretes';

  @override
  String get settingsAboutFeature2 => 'Direção da Qibla a qualquer momento';

  @override
  String get settingsAboutFeature3 => 'Alcorão e Tasbih para dhikr diário';

  @override
  String get settingsAboutFeature4 => 'Mesquitas próximas';

  @override
  String get settingsAboutFeature5 =>
      'Modos de foco inteligentes para Salah, sono e tempo em família';

  @override
  String get settingsAboutFocusDescription =>
      'Os modos de foco inteligentes ajudam você a bloquear distrações durante Salah, sono e momentos importantes, para que você possa permanecer presente e disciplinado.';

  @override
  String get settingsAboutFooter =>
      'Permaneça consistente. Permaneça atento.\nPermaneça conectado ao seu Deen.';

  @override
  String get settingsEnableSystemNotifications =>
      'Ative as notificações do sistema para ativar isso.';

  @override
  String get appDemoTitle => 'Demonstração do aplicativo';

  @override
  String get appDemoLoadFailed =>
      'Não foi possível carregar o vídeo de demonstração.';

  @override
  String get appDemoRestartHint =>
      'O vídeo precisa de uma reinicialização completa do aplicativo (a reinicialização a quente pode interromper a reprodução).';

  @override
  String get appDemoPreviewLoadFailed =>
      'Não foi possível carregar a demonstração.';

  @override
  String get appDemoTryAgain => 'Tente novamente';

  @override
  String get appDemoWatchLabel => 'Assista à demonstração';

  @override
  String get homeAiChatTitle => 'IA Deen Focus';

  @override
  String get homeAiAskQuestionHint => 'Faça uma pergunta...';

  @override
  String get homeAiSend => 'Enviar';

  @override
  String get homeAiErrorPrefix =>
      'Desculpe, tive um problema ao me conectar ao Deen Focus AI.';

  @override
  String get homeAiEmptyTitle => 'Pergunte qualquer coisa sobre o Islã';

  @override
  String get homeAiEmptySubtitle =>
      'Momentos de oração, Alcorão, Hadith, eventos islâmicos e orientação espiritual';

  @override
  String get onboardingTypeCityName => 'Digite o nome da sua cidade..';

  @override
  String get onboardingNoLocationsFound => 'Nenhum local encontrado';

  @override
  String get onboardingTryAnotherCityName => 'Tente outro nome de cidade.';

  @override
  String get qiblaCompassUnavailable =>
      'Bússola indisponível neste dispositivo';

  @override
  String get qiblaFacing => '✓ Enfrentando Qibla';

  @override
  String get qiblaTurnToFind => 'Vire-se para encontrar Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Distância até Meca';

  @override
  String get qiblaFromNorth => 'do Norte';

  @override
  String get qiblaNorthShort => 'N';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'E';

  @override
  String get qiblaWestShort => 'C';

  @override
  String get nearbyMosquesTitle => 'Mesquitas próximas';

  @override
  String get nearbyMosquesTryAgain => 'Tente novamente';

  @override
  String get nearbyMosquesOpenGoogle => 'Abrir no Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Abrir no Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'Nenhuma mesquita encontrada dentro';

  @override
  String get nearbyMosquesSearchRadius => 'Raio de pesquisa: 5 km';

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'Visualização do mapa indisponível no momento.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Aguardando sua localização.';

  @override
  String get nearbyMosquesFetchingLocation => 'A obter a sua localização…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Localização atual';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'As mesquitas próximas aparecerão aqui assim que os resultados forem carregados.';

  @override
  String get nearbyMosquesNoneWithinRadius =>
      'Nenhuma mesquita encontrada num raio de 5 km';

  @override
  String get nearbyMosquesLocationRequired =>
      'O acesso ao local é necessário para encontrar mesquitas próximas.';

  @override
  String get nearbyMosquesPermissionOff =>
      'A permissão de localização está desativada. Ative-o nas configurações para ver as mesquitas próximas.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'Não foi possível ler sua localização atual no momento.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'A atualização ao vivo falhou. Mostrando os últimos resultados salvos. Puxe para atualizar.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'O acesso ao local foi negado. Ative-o em Configurações para ver mesquitas próximas.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'A localização está desativada neste dispositivo. Ative-o em Configurações e tente novamente.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'A permissão de localização ainda está sendo processada. Por favor, tente novamente em alguns instantes.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'A solicitação demorou muito. Verifique sua conexão com a Internet e tente novamente.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Não há conexão com a Internet ou o serviço está inacessível. Verifique sua conexão e tente novamente.';

  @override
  String get nearbyMosquesFormatError =>
      'Não conseguimos ler a lista das mesquitas neste momento. Por favor, tente novamente mais tarde.';

  @override
  String get nearbyMosquesPlatformError =>
      'Não conseguimos concluir essa etapa. Verifique sua conexão e tente novamente.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Algo deu errado. Por favor, tente novamente.';

  @override
  String get nearbyMosquesEmptyHint =>
      'Nada listado dentro de 5 km no OpenStreetMap para este local. Tente novamente mais tarde ou mova o mapa.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count mesquitas encontradas num raio de 5 km';
  }

  @override
  String get tasbihDeleteDhikrTitle => 'Excluir dhikr?';

  @override
  String get tasbihDelete => 'Excluir';

  @override
  String get focusAndroidBlockingNotReady =>
      'O bloqueio de apps no Android ainda não está pronto. Mantenha a acessibilidade ativada e aguarde a conexão.';

  @override
  String get focusNoAppsSelectedSnack =>
      'Nenhum app selecionado. Escolha primeiro os apps a bloquear.';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'É necessário acesso ao Tempo de Uso para bloquear apps no iPhone.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Algo deu errado ao atualizar o modo Foco. Tente novamente.';

  @override
  String get focusLoadingInstalledApps => 'Carregando apps instalados...';

  @override
  String get focusNoInstalledAppsToShow => 'Nenhum app instalado para mostrar.';

  @override
  String get homeAiSuggestion1 => 'O que é Ramadã?';

  @override
  String get homeAiSuggestion2 => 'Horários de oração';

  @override
  String get homeAiSuggestion3 => 'Plano de leitura do Alcorão';

  @override
  String get homeAiDeveloperPrompt =>
      'Você é um assistente erudito e respeitoso em estudos islâmicos. Ajude os usuários a aprender tradições islâmicas, feriados, oração, estudo do Alcorão e práticas espirituais. Seja caloroso, objetivo, educativo e culturalmente sensível. Fora do tema islâmico, responda com utilidade sem fingir certeza religiosa.';

  @override
  String get homeAiErrorMissingApiKey => 'Configuração da API ausente.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'Erro de API $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'Nenhuma resposta do assistente.';

  @override
  String get homeAiErrorEmptyContent => 'Conteúdo da resposta vazio.';

  @override
  String get settingsPrayerCalculationSection => 'Cálculo de Oração';

  @override
  String get settingsCalculationMethodTitle => 'Método de Cálculo';

  @override
  String get settingsAsrCalculationTitle => 'Cálculo do Asr';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Principais Organizações Islâmicas';

  @override
  String get calculationMethodSectionMiddleEast => 'Oriente Médio';

  @override
  String get calculationMethodSectionAsiaPacific => 'Ásia-Pacífico';

  @override
  String get calculationMethodSectionSpecial => 'Métodos Especiais';

  @override
  String get asrMethodStandard => 'Padrão';

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
