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
  String get continueForFree => 'Talvez depois — explore o app primeiro';

  @override
  String get getStarted => 'Começar meu teste grátis de 7 dias';

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
  String get locationTitle => 'Encontre a sua Qibla';

  @override
  String get locationSubtitle =>
      'Ative a localização para Qibla, horários de oração e mesquitas próximas precisos.';

  @override
  String get locationButton => 'Permitir acesso ao local';

  @override
  String get locationManualEntry => 'Ou introduza a sua cidade';

  @override
  String get locationPrivacyNote => 'Fica no seu dispositivo';

  @override
  String get locationFeaturePrayerTimesTitle => 'Horários de oração';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Mesquitas';

  @override
  String get notificationsTitle => 'Não perca nenhuma oração';

  @override
  String get notificationsSubtitle =>
      'Alertas de adhan, lembretes de foco e dhikr diário — exatamente quando precisa.';

  @override
  String get notificationsButton => 'Habilitar notificações';

  @override
  String get notificationsEnabled => 'As notificações estão ativadas';

  @override
  String get notificationsPreviewDate => 'Sexta-feira, 10 de julho';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'agora';

  @override
  String get notificationsPreviewMinutesAgo => 'há 2 min';

  @override
  String get notificationsPreviewHourAgo => 'há 1 h';

  @override
  String get notificationsPreviewAdhanTitle => 'Adhan do Maghrib';

  @override
  String get notificationsPreviewAdhanBody =>
      'É hora de orar. As apps estão em pausa.';

  @override
  String get notificationsPreviewDhikrTitle => 'DHIKR DIÁRIO';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — reserve um minuto para recordar.';

  @override
  String get notificationsPreviewStreakTitle => 'SEQUÊNCIA';

  @override
  String get notificationsPreviewStreakBody =>
      '7 dias de orações completas. Continue!';

  @override
  String get screenTimeTitle => 'Ativar Tempo de Uso';

  @override
  String get screenTimeSubtitle =>
      'Isso permite que o Deen Focus pause apps que distraem durante Salah, sono e modo criança.';

  @override
  String get screenTimeButton => 'Permitir acesso ao Tempo de Uso';

  @override
  String get screenTimePrivacyNote =>
      'O Deen Focus nunca lê seus dados — ele apenas pausa os apps que você escolher.';

  @override
  String screenTimeStepOf(int current, int total) {
    return 'PASSO $current DE $total';
  }

  @override
  String get screenTimeStep1Title => 'Abrir o aviso de Tempo de Uso';

  @override
  String get screenTimeStep1Body =>
      'Toque em «Permitir acesso ao Tempo de Uso» — seu dispositivo mostrará a própria solicitação de permissão.';

  @override
  String get screenTimeStep2Title => 'Toque em Continuar e depois Permitir';

  @override
  String get screenTimeStep2Body =>
      'Aprove a solicitação para o Deen Focus pausar apps nos momentos certos.';

  @override
  String get screenTimeStep3Title => 'Escolher apps para bloquear';

  @override
  String get screenTimeStep3Body =>
      'Escolha os apps que mais distraem — redes, jogos, vídeo, qualquer um.';

  @override
  String get screenTimeStep4Title => 'Você está protegido';

  @override
  String get screenTimeStep4Body =>
      'Os apps bloqueiam automaticamente durante Salah, sono e modo criança.';

  @override
  String get screenTimePromptTitle => 'Tempo de Uso';

  @override
  String screenTimePromptMessage(String appName) {
    return '«$appName» gostaria de acessar o Tempo de Uso';
  }

  @override
  String get screenTimeDontAllow => 'Não permitir';

  @override
  String get screenTimePromptContinue => 'Continuar';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Jogos';

  @override
  String get screenTimeAndroidStep1Title => 'Abrir Acesso de uso';

  @override
  String get screenTimeAndroidStep1Body =>
      'Toque em «Permitir acesso ao Tempo de Uso» — seu dispositivo abrirá o Acesso de uso para o Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Ativar Acessibilidade';

  @override
  String get screenTimeAndroidStep2Body =>
      'Ative o serviço do Deen Focus para pausar apps durante Salah, sono e modo criança.';

  @override
  String get screenTimeAndroidStep3Title => 'Escolher apps para bloquear';

  @override
  String get screenTimeAndroidStep3Body =>
      'Escolha os apps que mais distraem — redes, jogos, vídeo, qualquer um.';

  @override
  String get screenTimeAndroidStep4Title => 'Você está protegido';

  @override
  String get screenTimeAndroidStep4Body =>
      'Os apps bloqueiam automaticamente durante Salah, sono e modo criança.';

  @override
  String get screenTimeAndroidUsageTitle => 'Acesso de uso';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Permitir que o Deen Focus rastreie quais outros apps estão em uso.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Acessibilidade';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'O Deen Focus precisa de Acessibilidade para pausar apps que distraem durante as sessões de foco.';

  @override
  String get screenTimeAndroidPermit => 'Permitir';

  @override
  String get screenTimeAndroidEnable => 'Ativar';

  @override
  String get screenTimeAndroidNotNow => 'Agora não';

  @override
  String get focusModesTitle => 'Tudo em um só app';

  @override
  String get focusModesSubtitle =>
      'Explore tudo o que o Deen Focus oferece. Toque num modo de foco para ver como funciona.';

  @override
  String get focusModesSectionLabel => 'MODOS DE FOCO · TOQUE PARA SABER MAIS';

  @override
  String get focusPrayerTrackingSectionLabel => 'ORAÇÃO E ACOMPANHAMENTO';

  @override
  String get focusLearningHubSectionLabel => 'CENTRO DE APRENDIZAGEM';

  @override
  String get focusMoreSectionLabel => 'MAIS';

  @override
  String get focusPrayerModeTitle => 'Modo de Oração';

  @override
  String get focusPrayerModeDescription =>
      'Bloqueie apps que distraem automaticamente durante a Salah para orar com pleno khushu.';

  @override
  String get focusPrayerModeBullet1 => 'Trava apps no horário da oração';

  @override
  String get focusPrayerModeBullet2 => 'Desbloqueia quando você termina';

  @override
  String get focusPrayerModeBullet3 => 'Fortalece foco e constância';

  @override
  String get focusSleepModeTitle => 'Modo de suspensão';

  @override
  String get focusSleepModeDescription =>
      'Desacelere de forma halal. Bloqueie apps na hora de dormir para descansar bem e acordar para o Fajr.';

  @override
  String get focusSleepModeBullet1 =>
      'Bloqueia apps automaticamente na hora de dormir';

  @override
  String get focusSleepModeBullet2 => 'Lembretes suaves para acordar no Fajr';

  @override
  String get focusSleepModeBullet3 => 'Protege seu sono e o Fajr';

  @override
  String get focusChildModeTitle => 'Modo infantil';

  @override
  String get focusChildModeDescription =>
      'Vai entregar o celular ao seu filho? Trave apps na hora para que ele só veja o que é seguro.';

  @override
  String get focusChildModeBullet1 => 'Modo seguro com um toque';

  @override
  String get focusChildModeBullet2 => 'Saída protegida por senha';

  @override
  String get focusChildModeBullet3 => 'Tranquilidade, sempre';

  @override
  String get focusModeGotIt => 'Entendi';

  @override
  String get focusFeaturePrayerTimesTitle => 'Horários de oração precisos';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan e lembretes';

  @override
  String get focusFeatureStreaksTitle => 'Sequências';

  @override
  String get focusFeatureStreaksSubtitle => 'Mantenha a constância';

  @override
  String get focusFeatureChecklistTitle => 'Lista diária';

  @override
  String get focusFeatureChecklistSubtitle => 'Crie bons hábitos';

  @override
  String get focusFeatureQiblaTitle => 'Qibla e mesquita';

  @override
  String get focusFeatureQiblaSubtitle => 'Direção e mesquitas';

  @override
  String get focusFeatureQuranTitle => 'Alcorão';

  @override
  String get focusFeatureQuranSubtitle => 'Traduções, juz e páginas';

  @override
  String get focusFeatureHadithTitle => 'Hadith';

  @override
  String get focusFeatureHadithSubtitle => 'Coleções autênticas';

  @override
  String get focusFeatureDuasTitle => 'Duas';

  @override
  String get focusFeatureDuasSubtitle => 'Súplicas diárias';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Contador digital de dhikr';

  @override
  String get focusFeatureAiTitle => 'Companheiro de IA';

  @override
  String get focusFeatureAiSubtitle => 'Pergunte sobre o seu din';

  @override
  String get focusFeatureInsightsTitle => 'Estatísticas';

  @override
  String get focusFeatureInsightsSubtitle => 'Dados semanais e mensais';

  @override
  String get investTitle => 'Invista no Deen';

  @override
  String get investSubtitle =>
      'O melhor investimento não é no que se desfaz — é no que te aproxima de Allah. Experimente tudo grátis por 7 dias.';

  @override
  String get investPremiumUnlocked => 'PREMIUM DESBLOQUEADO';

  @override
  String get investTrialPill =>
      '✨ 7 dias grátis — cancele a qualquer momento antes do fim';

  @override
  String get investFeatureAiTitle => 'Assistente islâmico com IA';

  @override
  String get investFeatureAiBody =>
      'Pergunte qualquer coisa sobre o seu Deen — respostas baseadas em fontes autênticas.';

  @override
  String get investFeaturePrayerModeTitle => 'Modo de oração em tela cheia';

  @override
  String get investFeaturePrayerModeBody =>
      'Uma tela calma e sem distrações que te chama para a Salah.';

  @override
  String get investFeatureAppBlockingTitle => 'Bloqueio avançado de apps';

  @override
  String get investFeatureAppBlockingBody =>
      'Controle preciso sobre quais apps bloqueiam e exatamente quando.';

  @override
  String get investFeatureNightModeTitle => 'Modo de disciplina noturna';

  @override
  String get investFeatureNightModeBody =>
      'Relaxe no horário, durma melhor e acorde para o Fajr.';

  @override
  String get investFeaturePlannerTitle => 'Planejador de oração e progresso';

  @override
  String get investFeaturePlannerBody =>
      'Sequências, insights e diários que te mantêm consistente.';

  @override
  String get investFeatureToolsTitle => 'Ferramentas islâmicas exclusivas';

  @override
  String get investFeatureToolsBody =>
      'Calendário hijri, duas, tasbih, 99 Nomes e mais.';

  @override
  String get investFeatureThemesTitle => 'Temas premium e atualizações';

  @override
  String get investFeatureThemesBody =>
      'Temas lindos mais cada novo recurso que lançamos.';

  @override
  String get investFeatureTajweedTitle => 'Domine o Tajweed';

  @override
  String get investFeatureTajweedBody =>
      'Melhore sua recitação com lições guiadas e feedback em tempo real.';

  @override
  String get socialProofPrefix => 'Junte-se a ';

  @override
  String get socialProofHighlight => 'Mais de 10.000';

  @override
  String get socialProofSuffix => ' muçulmanos crescendo com DeenFocus';

  @override
  String get mostPopular => 'Mais populares';

  @override
  String get monthlyLabel => 'Mensal';

  @override
  String get yearlyLabel => 'Anual';

  @override
  String get lifetimeLabel => 'Vida';

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
  String get hijriMonthRamadan => 'Ramadão';

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
  String get calendarEventJumuahDesc => 'Oração de sexta-feira';

  @override
  String get calendarEventWhiteDays => 'Dias brancos';

  @override
  String get calendarEventWhiteDaysDesc => 'Do dia 13 ao 15 de cada mês';

  @override
  String get cycleModeActiveTitle =>
      '«Allah deseja para vós a facilidade e não deseja para vós a dificuldade.» — Alcorão 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'Durante este período, a sua sequência está protegida. Os dias do ciclo ficam destacados a rosa e o Modo ciclo desliga-se automaticamente no fim do ciclo.';

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
      other: 'Termina automaticamente em $days dias',
      one: 'Termina automaticamente amanhã',
      zero: 'Termina hoje',
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
    return 'Você rezou $prayer?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Mantenha sua sequência registrando sua oração.';

  @override
  String get prayerReminderYesButton => 'Sim, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'Marcarei depois';

  @override
  String get homeTrialBannerTitle =>
      'Grátis por 7 dias — torne-se um muçulmano melhor ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Todos os recursos desbloqueados. Comece sua jornada hoje.';

  @override
  String get homeFocusModeTitle => 'Modo foco';

  @override
  String get homeFocusModeSubtitle =>
      'Bloqueie apps que distraem durante a Salah';

  @override
  String get cycleModeTitle => 'Modo ciclo';

  @override
  String get cycleModeSubtitle =>
      'Para a menstruação — pause as orações, mantenha a sequência';

  @override
  String get dailyChecklistTitle => 'Lista diária';

  @override
  String get dailyChecklistSubtitle =>
      'Acompanhe seus objetivos espirituais diários';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed de $total concluídos';
  }

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
  String get dailyChecklistQuran => 'Alcorão';

  @override
  String get dailyChecklistMorningAdhkar => 'Adhkar da manhã';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar da tarde';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Caridade';

  @override
  String get dailyChecklistSmileAtSomeone => 'Sorria a alguém';

  @override
  String get dailyChecklistFamilyCall => 'Chamada à família';

  @override
  String get dailyChecklistNoMusicToday => 'Sem música hoje';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'Sem redes sociais antes de Isha';

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
  String get quickActionsCalendar => 'Calendário';

  @override
  String get quickActionsCalendarSubtitle => 'Ver datas islâmicas';

  @override
  String get quickActionsSupportUs => 'Apoie-nos';

  @override
  String get quickActionsSupportUsSubtitle => 'Ajude-nos a crescer';

  @override
  String get quickActionsSupportUsMessage =>
      'Obrigado por considerar apoiar o DeenFocus! As funções de apoio chegarão em breve.';

  @override
  String get supportUsTitle => 'Apoie o DeenFocus';

  @override
  String get supportUsHeroTitle => 'Apoie o DeenFocus';

  @override
  String get supportUsHeroBody =>
      'Seu apoio nos ajuda a melhorar o DeenFocus e contribuir para causas significativas.';

  @override
  String get supportUsFundSection => 'Seu apoio ajuda a financiar';

  @override
  String get supportUsFundSectionSubtitle =>
      'Usamos seu apoio para criar mais bem.';

  @override
  String get supportUsFundFeature1Title => 'Novos recursos';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Criar e melhorar recursos significativos do DeenFocus.';

  @override
  String get supportUsFundFeature2Title => 'Correções de bugs';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Manter o app estável, rápido e confiável para todos.';

  @override
  String get supportUsFundFeature3Title => 'Pessoas necessitadas';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Apoiar esforços que ajudam quem enfrenta dificuldades.';

  @override
  String get supportUsFundFeature4Title => 'Caridade e comunidade';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Contribuir para iniciativas de caridade e apoio comunitário.';

  @override
  String get supportUsNeedHelp => 'PRECISA DE AJUDA?';

  @override
  String get supportUsWhatsApp => 'Conversar no WhatsApp';

  @override
  String get supportUsEmailSupport => 'Suporte por e-mail';

  @override
  String get supportUsChooseAmountTitle => 'Escolha um valor de apoio';

  @override
  String get supportUsChooseAmountSubtitle => 'Você pode apoiar várias vezes.';

  @override
  String get supportUsSecurePaymentNote =>
      'Pagamento único seguro · Sem cobranças recorrentes';

  @override
  String get supportUsTrustBanner =>
      'Seguro • Apoio único • Você pode apoiar várias vezes';

  @override
  String get supportUsImpactSectionTitle => 'Onde seu apoio faz diferença';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Cada contribuição tem impacto duradouro.';

  @override
  String get supportUsImpactPalestine =>
      'Apoio e conscientização pela Palestina';

  @override
  String get supportUsImpactNeedy => 'Ajudar quem precisa';

  @override
  String get supportUsImpactCommunity => 'Caridade e apoio comunitário';

  @override
  String get supportUsImpactExperience => 'Melhor experiência DeenFocus';

  @override
  String get supportUsImpactFeatures => 'Novos recursos e atualizações';

  @override
  String get supportUsImpactQuran => 'Alcorão e aprendizado islâmico';

  @override
  String get supportUsImpactServers => 'Servidores e confiabilidade do app';

  @override
  String supportUsCta(String amount) {
    return 'Apoiar o DeenFocus com $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, preciso de ajuda com o DeenFocus.';

  @override
  String get supportUsEmailSubject => 'Pedido de suporte DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'Não foi possível abrir esse app neste dispositivo.';

  @override
  String get supportUsLaunchFailed => 'Algo deu errado. Tente novamente.';

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
  String get insightsPrayerStreak => 'Sequência de oração';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => 'Orações seguidas';

  @override
  String get insightsDaysInARow => 'Dias seguidos';

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
  String get insightsFocusExcellent => 'Excelente — continue!';

  @override
  String get insightsFocusKeepGoing => 'Continue a construir o seu foco';

  @override
  String get insightsTodaysPrayers => 'Orações de hoje';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Modo ciclo ativo';

  @override
  String get insightsProtectedByCycleMode => 'A sua sequência está protegida.';

  @override
  String get insightsCurrentPrayerStreak => 'Sequência de oração atual';

  @override
  String get insightsBestPrayerStreak => 'Melhor sequência de oração';

  @override
  String get insightsCurrentDayStreak => 'Sequência de dias atual';

  @override
  String get insightsCycleProtectedDays => 'Dias protegidos pelo ciclo';

  @override
  String get insightsAchievements => 'Conquistas';

  @override
  String get insightsAchieved => 'Alcançado';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Cycle Mode days are protected and not counted as streak breaks. You have $days protected day(s) available.';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Ative o Modo ciclo para proteger sua sequência nos dias de descanso.';

  @override
  String get achievementFirstPrayerStreak => 'Primeira sequência de oração';

  @override
  String get achievementSevenPrayerStreak => 'Sequência de sete orações';

  @override
  String get achievementThirtyPrayerStreak => 'Sequência de trinta orações';

  @override
  String get achievementFajrWarrior => 'Guerreiro do Fajr';

  @override
  String get achievementQuranReader => 'Leitor do Alcorão';

  @override
  String get achievementDhikrMaster => 'Mestre do Dhikr';

  @override
  String get achievementConsistencyChampion => 'Campeão da constância';

  @override
  String get prayerCompletionAlhamdulillah => 'Alhamdulillah!';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer foi concluída';
  }

  @override
  String get prayerCompletionStreakIncreased =>
      'A sua sequência de oração aumentou';

  @override
  String get prayerCompletionKeepGoing =>
      'Cada oração aproxima-o de Allah. Continue!';

  @override
  String get prayerCompletionContinue => 'Continuar';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Próxima oração em $when';
  }

  @override
  String prayerCompletionMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String prayerCompletionHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get weekdayLetterMon => 'S';

  @override
  String get weekdayLetterTue => 'T';

  @override
  String get weekdayLetterWed => 'Q';

  @override
  String get weekdayLetterThu => 'Q';

  @override
  String get weekdayLetterFri => 'S';

  @override
  String get weekdayLetterSat => 'S';

  @override
  String get weekdayLetterSun => 'D';

  @override
  String get focusHomeBlockingNightAndSalah =>
      'Disciplina noturna e modo Salah estão a bloquear as apps selecionadas.';

  @override
  String get focusHomeBlockingNight =>
      'Disciplina noturna está a bloquear as apps selecionadas.';

  @override
  String get focusHomeBlockingSalah =>
      'O modo Salah está a bloquear as apps selecionadas.';

  @override
  String get focusHomeAppsBlockedNow =>
      'As apps selecionadas estão bloqueadas agora.';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode está ativado.';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes estão ativados.';
  }

  @override
  String get focusHomeChooseMode =>
      'Escolha um modo para proteger a sua atenção';

  @override
  String get focusStatusSelectApps => 'Selecione apps para começar';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Disciplina noturna e modo Salah estão a bloquear apps agora';

  @override
  String get focusStatusBlockingNight =>
      'Disciplina noturna está a bloquear apps agora';

  @override
  String get focusStatusBlockingSalah =>
      'O modo Salah está a bloquear apps agora';

  @override
  String get focusStatusAppsLocked => 'As apps estão bloqueadas agora';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Desbloqueado até $time';
  }

  @override
  String get focusStatusNoMode => 'Nenhum modo de foco ativado';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Pronto para bloquear $targets';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s';
  }
}
