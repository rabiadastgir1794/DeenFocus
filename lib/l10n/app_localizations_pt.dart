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
  String get locationManualEntry => 'Introduza a sua cidade manualmente';

  @override
  String get locationOrDivider => 'ou';

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
  String get notificationsMaybeLater => 'Talvez depois';

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
  String get notificationsPreviewAdhanBody => 'É hora de orar.';

  @override
  String get notificationsPreviewDhikrTitle => 'Dhikr diário';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — reserve um momento.';

  @override
  String get notificationsPreviewStreakTitle => 'Sequência';

  @override
  String get notificationsPreviewStreakBody => '7 dias de orações completas.';

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
  String get onboardingSelectAppsTitlePrefix => 'Selecione';

  @override
  String get onboardingSelectAppsTitleAccent => 'apps para bloquear';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Selecione os apps que deseja bloquear na hora da oração.';

  @override
  String get onboardingSelectAppsButton => 'Selecionar apps';

  @override
  String get onboardingSelectAppsSkipForNow => 'Pular por agora';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'Você está no controle';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'Nunca lemos os seus dados. Só bloqueamos as apps que escolher.';

  @override
  String get onboardingSelectAppsMockAllApps => 'Todos os apps e categorias';

  @override
  String get onboardingSelectAppsMockPhotos => 'Fotos';

  @override
  String get onboardingSelectAppsMockNotes => 'Notas';

  @override
  String get onboardingSelectAppsMockMusic => 'Música';

  @override
  String get onboardingSelectAppsMockSafari => 'Safari';

  @override
  String get onboardingSelectAppsMockPodcasts => 'Podcasts';

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
  String get onboardingWidgetsLiveTitle => 'Suas orações, sempre ao alcance';

  @override
  String get onboardingWidgetsLiveSubtitle =>
      'Fique ligado ao que mais importa — direto da tela inicial ou de bloqueio.';

  @override
  String get onboardingWidgetsSectionTitle => 'Widgets';

  @override
  String get onboardingWidgetsSectionBodyPrefix =>
      'Veja a próxima oração, sequências e progresso ';

  @override
  String get onboardingWidgetsSectionBodyEmphasis => 'de relance.';

  @override
  String get onboardingLiveActivitiesSectionTitle => 'Live Activity';

  @override
  String get onboardingLiveActivitiesSectionBodyPrefix =>
      'Veja as atualizações da próxima oração em ';

  @override
  String get onboardingLiveActivitiesSectionBodyEmphasis => 'tempo real';

  @override
  String get onboardingLiveActivitiesSectionBodySuffix =>
      ' na tela de bloqueio e no Dynamic Island.';

  @override
  String get onboardingWidgetsLiveTrustPrefix =>
      'Feito para ajudar você a permanecer ';

  @override
  String get onboardingWidgetsLiveTrustEmphasis => 'consistente';

  @override
  String get onboardingWidgetsLiveTrustSuffix =>
      ' e nunca perder o que mais importa.';

  @override
  String get onboardingWidgetsMockStreak => 'Sequência';

  @override
  String get onboardingWidgetsMockStreakValue => '12 dias';

  @override
  String get onboardingWidgetsMockFocus => 'Foco';

  @override
  String get onboardingWidgetsMockFocusValue => '25 min';

  @override
  String get onboardingWidgetsLiveLockDate => 'Terça-feira, 6 de maio';

  @override
  String get onboardingWidgetsLiveLockTime => '9:41';

  @override
  String get onboardingWidgetsLiveNextPrayer => 'Dhuhr 12:45, em 02:15:32';

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
  String get restrictedModeSalahTitle => 'Hora do Salah';

  @override
  String get restrictedModeSalahMessage =>
      'Afaste-se das distrações e atenda ao chamado à oração.';

  @override
  String get restrictedModeSalahInfo =>
      'Aproveite este momento para se conectar com Allah.';

  @override
  String get restrictedModeSalahQuote =>
      'Estabelece a oração para a Minha lembrança.';

  @override
  String get restrictedModeSalahQuoteSource => 'Alcorão 20:14';

  @override
  String get restrictedModeSalahCta => 'Começar Salah';

  @override
  String get restrictedModeChildTitle => 'Modo foco infantil';

  @override
  String get restrictedModeChildMessage =>
      'Um espaço mais seguro e equilibrado para o tempo de tela focado.';

  @override
  String get restrictedModeChildInfo =>
      'Alguns apps estão temporariamente indisponíveis.';

  @override
  String get restrictedModeChildQuote =>
      'Ensinai vossos filhos a oração aos sete anos.';

  @override
  String get restrictedModeChildQuoteSource => 'Hadith - Abu Dawud';

  @override
  String get restrictedModeChildCta => 'Fique protegido';

  @override
  String get restrictedModeNightTitle => 'Modo foco noturno';

  @override
  String get restrictedModeNightMessage =>
      'É hora de descansar e desligar das distrações digitais.';

  @override
  String get restrictedModeNightInfo =>
      'Deixe o dispositivo de lado e aproveite uma noite tranquila.';

  @override
  String get restrictedModeNightQuote => 'E fizemos do vosso sono um descanso.';

  @override
  String get restrictedModeNightQuoteSource => 'Alcorão 78:9';

  @override
  String get restrictedModeNightCta => 'Boa noite';

  @override
  String get restrictedModeAppsUnavailable =>
      'Alguns apps estão temporariamente indisponíveis.';

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
  String get investNoCommitment => 'Sem compromisso. Cancele quando quiser.';

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
  String get homeSearchNearbyMosques =>
      'Encontre mesquitas próximas via OpenStreetMap.';

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
  String get homeTapPrayerToMark =>
      'Toque numa oração para a marcar como rezada, qada ou perdida.';

  @override
  String get homeSetLocation => 'Definir localização';

  @override
  String get homeEditPrayerSettings => 'Editar definições da oração';

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
  String get calendarTitle => 'Calendário islâmico';

  @override
  String get calendarBack => 'Voltar';

  @override
  String get calendarToday => 'Hoje';

  @override
  String get calendarTomorrow => 'Amanhã';

  @override
  String calendarDaysAway(int days) {
    return '$days dias';
  }

  @override
  String get calendarNoEventsThisWeek => 'Nenhum evento islâmico esta semana.';

  @override
  String get calendarNoEventsBlessing =>
      'Que Allah abençoe a sua semana com paz e bondade.';

  @override
  String get calendarNoUpcomingEvents =>
      'Nenhum evento islâmico próximo encontrado.';

  @override
  String get calendarUpcomingEvents => 'Próximos eventos islâmicos';

  @override
  String get calendarUpcomingThisYear => 'Próximos deste ano';

  @override
  String get calendarThisWeekObservances => 'Esta semana';

  @override
  String get calendarLegendCycleDays => 'Dias do ciclo (sequência protegida)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% iluminada';
  }

  @override
  String get calendarMoonNew => 'Lua nova';

  @override
  String get calendarMoonWaxingCrescent => 'Crescente';

  @override
  String get calendarMoonFirstQuarter => 'Quarto crescente';

  @override
  String get calendarMoonWaxingGibbous => 'Gibosa crescente';

  @override
  String get calendarMoonFull => 'Lua cheia';

  @override
  String get calendarMoonWaningGibbous => 'Gibosa minguante';

  @override
  String get calendarMoonLastQuarter => 'Quarto minguante';

  @override
  String get calendarMoonWaningCrescent => 'Minguante';

  @override
  String get calendarEventRamadanBegins => 'Início do Ramadão';

  @override
  String get calendarEventRamadanBeginsDesc => 'Mês do jejum';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Noite do Decreto';

  @override
  String get calendarEventEidAlFitr => 'Eid al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc => 'Festa da quebra do jejum';

  @override
  String get calendarEventDayOfArafah => 'Dia de Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Dia da estação em Arafah';

  @override
  String get calendarEventEidAlAdha => 'Eid al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Festa do sacrifício';

  @override
  String get calendarEventIslamicNewYear => 'Ano Novo islâmico';

  @override
  String get calendarEventIslamicNewYearDesc => '1 de Muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Nascimento do Profeta';

  @override
  String get calendarEventAshura => 'Ashura';

  @override
  String get calendarEventAshuraDesc => '10 de Muharram';

  @override
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Oração congregacional de sexta-feira';

  @override
  String get calendarEventWhiteDays => 'Dias brancos';

  @override
  String get calendarEventWhiteDaysDesc => 'Dias de jejum recomendados';

  @override
  String get cycleModeActiveTitle =>
      'O teu ciclo é uma pausa, não uma paragem.';

  @override
  String get cycleModeActiveSubtitle => 'Dhikr • Tasbih • Ouvir o Alcorão';

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
  String get cycleModePauseStreaksLabel => 'Proteger sequência de oração';

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
  String get prayerNotificationSubtitleFajr =>
      '“Em verdade, a recitação da aurora é sempre testemunhada.” — Alcorão 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '“Estabelece a oração no declínio do sol...” — Alcorão 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '“Guardai rigorosamente as orações, especialmente a oração do meio.” — Alcorão 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '“Glorificai Allah quando chegardes ao entardecer...” — Alcorão 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '“Estabelece a oração -  até a escuridão da noite.” — Alcorão 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'É hora de $prayerName';
  }

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
  String get homeLivePrayerUpdatesTitle => 'Atualizações de oração ao vivo';

  @override
  String get homeLivePrayerUpdatesBody =>
      'Veja a oração atual e a próxima na tela de bloqueio e Dynamic Island.';

  @override
  String get homeLivePrayerUpdatesCta => 'Ativar atualizações ao vivo';

  @override
  String get homeWidgetsPromoTitle => 'Widgets';

  @override
  String get homeWidgetsPromoBody =>
      'Veja o versículo do dia e os horários de oração na tela inicial.';

  @override
  String get homeWidgetsPromoCta => 'Adicionar widget';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Noite';

  @override
  String get focusModeShortChild => 'Infantil';

  @override
  String get focusModeLabelSalah => 'Modo Salah';

  @override
  String get focusModeLabelNight => 'Modo noite';

  @override
  String get focusModeLabelChild => 'Modo infantil';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return 'Os modos $first e $second estão ativados';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return 'Os modos $first, $second e $third estão ativados';
  }

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
  String get dailyChecklistSectionDistraction => 'Disciplina pessoal';

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
  String get supportUsWhatsAppQuestionHowTo => 'Como uso o DeenFocus?';

  @override
  String get supportUsWhatsAppQuestionFeature =>
      'Preciso de ajuda com um recurso';

  @override
  String get supportUsWhatsAppQuestionSubscription =>
      'Tenho um problema com a minha subscrição';

  @override
  String get supportUsEmailSubject => 'Pedido de suporte DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'Não foi possível abrir esse app neste dispositivo.';

  @override
  String get supportUsLaunchFailed => 'Algo deu errado. Tente novamente.';

  @override
  String get supportUsThankYouTitle => 'JazakAllah khair';

  @override
  String get supportUsThankYouBody =>
      'Obrigado por apoiar o DeenFocus. Você pode apoiar novamente a qualquer momento.';

  @override
  String get supportUsPurchasePending =>
      'Seu apoio está pendente. Confirmaremos quando a Apple concluir a compra.';

  @override
  String get supportUsPurchaseFailed =>
      'Não foi possível concluir seu pagamento de apoio. Tente novamente.';

  @override
  String get supportUsProductUnavailable =>
      'Este valor de apoio não está disponível agora. Tente novamente mais tarde.';

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
  String get tabQuran => 'Aprender';

  @override
  String get tabLearn => 'Aprender';

  @override
  String get quranLoadFailed => 'Falha ao carregar dados do Alcorão';

  @override
  String get quranTabSubtitle => 'Leia e explore o Alcorão Sagrado';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Pesquisar surata...';

  @override
  String get quranSearchHintExtended => 'Pesquisar sura ou significado...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranNoSurahsFound => 'Nenhuma surata encontrada';

  @override
  String get quranVersesLabel => 'versos';

  @override
  String quranSurahHeaderSubtitle(String name, int count) {
    return '$name • $count versos';
  }

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
  String get quranModeSurah => 'Sura';

  @override
  String get quranModeJuz => 'Juz';

  @override
  String get quranModePage => 'Página';

  @override
  String get quranSwitchToPageView => 'Vista de página';

  @override
  String get quranSwitchToSurahView => 'Vista de sura';

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get quranContinueReading => 'Continuar a ler';

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
    return '$percent% do juz $juz';
  }

  @override
  String get quranBookmarksTitle => 'Marcadores';

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
    return '$count guardados';
  }

  @override
  String get quranQuickTajweed => 'Exercício de tajweed';

  @override
  String get quranQuickTajweedSub => 'Recitar e pontuar';

  @override
  String get quranLastListened => 'Última escuta';

  @override
  String get quranNoneYet => 'Ainda nenhum';

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
  String get readingSettingsTajweedPractice => 'Tajweed do Alcorão com IA';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Recite aias e receba feedback';

  @override
  String get readingSettingsTajweedSeeHowItWorks => 'Veja como funciona';

  @override
  String get quranSeeHowAiQuranTajweedWorks => 'see how AI Quran Tajweed works';

  @override
  String get readingSettingsTajweedDeleteModel => 'Eliminar modelo de IA';

  @override
  String get readingSettingsTajweedDeleteConfirmTitle =>
      'Eliminar o modelo de IA de tajweed do Alcorão?';

  @override
  String get readingSettingsTajweedDeleteConfirmBody =>
      'Não poderá praticar tajweed até voltar a descarregar o modelo de IA. Isto também liberta espaço no seu dispositivo.';

  @override
  String get readingSettingsTajweedDeleteConfirmAction => 'Eliminar';

  @override
  String get readingSettingsTajweedDeleted =>
      'Modelo de tajweed de IA eliminado';

  @override
  String get readingSettingsTajweedDeleteFailed =>
      'Não foi possível eliminar o modelo de tajweed de IA';

  @override
  String get readingSettingsTajweedFreePreviewTranslation =>
      'Em nome de Allah, o Clemente, o Misericordioso.';

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
  String get readingSettingsTitle => 'Definições de leitura';

  @override
  String get readingSettingsArabicFontSize => 'Tamanho da fonte árabe';

  @override
  String get readingSettingsTranslationFontSize =>
      'Tamanho da fonte da tradução';

  @override
  String get readingSettingsLineSpacing => 'Espaçamento entre linhas';

  @override
  String get readingSettingsDefaultMode => 'Modo de leitura padrão';

  @override
  String get readingSettingsRememberPosition => 'Lembrar a última posição';

  @override
  String get readingSettingsScript => 'Escrita árabe';

  @override
  String get readingSettingsScriptUthmani => 'Uthmani (Hafs)';

  @override
  String get readingSettingsScriptIndopak => 'IndoPak (Hafs)';

  @override
  String get readingSettingsArabicFont => 'Fonte árabe';

  @override
  String get readingSettingsFontUthmanic => 'Uthmanic Hafs';

  @override
  String get readingSettingsFontNooreHuda => 'Noore Huda';

  @override
  String get readingSettingsFontSystem => 'Sistema (nativo)';

  @override
  String get readingSettingsShowTranslation => 'Mostrar tradução';

  @override
  String get readingSettingsShowTransliteration => 'Mostrar transliteração';

  @override
  String get readingSettingsTranslationSection => 'Tradução';

  @override
  String get readingSettingsTranslationLabel => 'Tradução';

  @override
  String get readingSettingsTranslationCurrent => 'Atual';

  @override
  String get readingSettingsInstalledTranslations => 'Instaladas';

  @override
  String get readingSettingsAvailableTranslations => 'Disponíveis';

  @override
  String get readingSettingsTranslationInstalled => 'Instalada';

  @override
  String get readingSettingsTranslationSelected => 'Selecionada';

  @override
  String get readingSettingsTranslationDownload => 'Transferir';

  @override
  String get readingSettingsTranslationInstalling => 'A instalar…';

  @override
  String get readingSettingsTranslationDownloading => 'A transferir…';

  @override
  String get readingSettingsLayoutTheme => 'Layout do Alcorão';

  @override
  String get readingSettingsLayoutClassic => 'Mushaf';

  @override
  String get readingSettingsLayoutSimple => 'Simples';

  @override
  String get readingSettingsLayoutColor => 'Alcorão colorido';

  @override
  String get readingSettingsColorTheme => 'Tema de leitura';

  @override
  String get readingSettingsColorThemeParchment => 'Pergaminho';

  @override
  String get readingSettingsColorThemeEmerald => 'Esmeralda';

  @override
  String get readingSettingsColorThemeMidnight => 'Meia-noite';

  @override
  String get readingSettingsPreview => 'Pré-visualização';

  @override
  String get readingSettingsResetHistoryTitle => 'Repor dados de leitura';

  @override
  String get readingSettingsResetHistorySubtitle =>
      'Limpa continuar a ler, progresso das páginas, marcadores e ações rápidas';

  @override
  String get readingSettingsResetHistoryConfirmTitle =>
      'Repor os dados de leitura?';

  @override
  String get readingSettingsResetHistoryConfirmBody =>
      'Isto remove continuar a ler, o progresso das páginas, marcadores, a última audição e os atalhos de Tajweed. As definições de visualização e tradução são mantidas.';

  @override
  String get readingSettingsResetHistoryDone => 'Dados de leitura limpos';

  @override
  String get readingSettingsResetHistoryButton => 'Repor';

  @override
  String readingSettingsTranslationDownloadFailed(String name) {
    return 'Não foi possível transferir $name. Tente novamente quando estiver online.';
  }

  @override
  String readingSettingsTranslationSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => 'Comece a recitar';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'PRECISÃO DAS PALAVRAS';

  @override
  String get tajweedWordReviewLabel => 'REVISÃO DAS PALAVRAS';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Recitar e verificar tajweed';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nasal, 2 tempos';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Eco de salto';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Prolongue a vogal';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Una as letras';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Oculte o nun';

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
  String get widgetPrayerProgressTitle => 'Seu progresso de oração';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed de $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'orações concluídas.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Continue — faltam $count orações hoje';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — todas as orações de hoje concluídas';

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
  String get settingsRateDeenFocus => 'Avaliar DeenFocus ⭐';

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
      'Mantenha a consistência. Mantenha a atenção plena. Mantenha-se conectado ao seu Deen.';

  @override
  String get settingsAboutOffersHeading => 'O que o Deen Focus oferece';

  @override
  String get settingsAboutNewBadge => 'Novo';

  @override
  String get settingsAboutFooterCard =>
      'Ferramentas inteligentes para ajudá-lo a manter a atenção plena, a consistência e a conexão com seu Deen — todos os dias.';

  @override
  String get settingsAboutOfferPrayerTimesTitle =>
      'Horários de oração precisos';

  @override
  String get settingsAboutOfferPrayerTimesSubtitle =>
      'Alertas oportunos de oração e widgets bonitos para mantê-lo no caminho certo.';

  @override
  String get settingsAboutOfferPrayerStreaksTitle => 'Sequências de oração';

  @override
  String get settingsAboutOfferPrayerStreaksSubtitle =>
      'Construa consistência e cresça no seu Deen com rastreamento de sequências diárias e totais.';

  @override
  String get settingsAboutOfferCycleModeTitle => 'Modo ciclo';

  @override
  String get settingsAboutOfferCycleModeSubtitle =>
      'Para menstruação — pause as orações, mantenha sua sequência e continue sua jornada.';

  @override
  String get settingsAboutOfferQuranTajweedTitle => 'Tajweed do Alcorão';

  @override
  String get settingsAboutOfferQuranTajweedSubtitle =>
      'Leia, ouça e pratique tajweed com nosso feedback em tempo real com IA.';

  @override
  String get settingsAboutOfferLiveActivitiesTitle => 'Live Activities';

  @override
  String get settingsAboutOfferLiveActivitiesSubtitle =>
      'Mantenha-se atualizado com orações em andamento e sessões de foco direto da tela de bloqueio.';

  @override
  String get settingsAboutOfferQiblaTitle => 'Qibla e buscador de mesquitas';

  @override
  String get settingsAboutOfferQiblaSubtitle =>
      'Encontre a direção da Qibla a qualquer momento e descubra mesquitas próximas.';

  @override
  String get settingsAboutOfferFocusModesTitle => 'Modos de foco';

  @override
  String get settingsAboutOfferFocusModesSubtitle =>
      'Bloqueie apps distratores durante Salah, sono, estudo ou tempo em família.';

  @override
  String get settingsAboutOfferTasbihTitle => 'Tasbih e dhikr';

  @override
  String get settingsAboutOfferTasbihSubtitle =>
      'Tasbih digital para ajudá-lo a lembrar de Allah ao longo do dia.';

  @override
  String get settingsAboutOfferCalendarTitle => 'Calendário islâmico';

  @override
  String get settingsAboutOfferCalendarSubtitle =>
      'Calendário hijri com datas islâmicas importantes e lembretes.';

  @override
  String get settingsAboutGridNamesTitle => '99 Nomes de Allah';

  @override
  String get settingsAboutGridNamesSubtitle =>
      'Aprenda e reflita sobre Asma ul-Husna.';

  @override
  String get settingsAboutGridDuasTitle => 'Duas e adhkar';

  @override
  String get settingsAboutGridDuasSubtitle =>
      'Duas da manhã, da tarde e diárias.';

  @override
  String get settingsAboutGridPrayerTitle => 'Oração e métodos';

  @override
  String get settingsAboutGridPrayerSubtitle =>
      'Aprenda Salah, Wudu, Hajj e mais.';

  @override
  String get settingsAboutGridFiqhTitle => 'Fiqh e tradições';

  @override
  String get settingsAboutGridFiqhSubtitle =>
      'Explore conhecimento islâmico autêntico.';

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
  String get nearbyMosquesTitle => 'Mesquitas encontradas por perto';

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
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Raio de pesquisa: $radiusKm km';
  }

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
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'Nenhuma mesquita encontrada num raio de $radiusKm km';
  }

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
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'Nada listado dentro de $radiusKm km no OpenStreetMap para este local. Tente novamente mais tarde ou amplie a área.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count mesquitas encontradas num raio de $radiusKm km';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count mesquitas por perto';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'Dentro de $radiusKm km · Ordenadas por distância';
  }

  @override
  String get nearbyMosquesDirections => 'Direções';

  @override
  String get nearbyMosquesDenominationSunni => 'Sunita';

  @override
  String get nearbyMosquesDenominationShia => 'Xiita';

  @override
  String get nearbyMosquesDenominationAhlEHadith => 'Ahl-e-Hadith';

  @override
  String get nearbyMosquesDenominationNotSpecified =>
      'Denominação não especificada';

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
  String get focusDiagnosticButton => 'Diagnóstico';

  @override
  String get focusDiagnosticTitle => 'Testar bloqueio de apps';

  @override
  String get focusDiagnosticIntro =>
      'Bloqueie temporariamente os apps selecionados por 60 segundos com o mesmo bloqueio do modo Foco. Abra um app bloqueado para confirmar a tela de bloqueio do DeenFocus.';

  @override
  String focusDiagnosticIntroWithApp(String appName) {
    return 'Bloqueie temporariamente os apps selecionados por 60 segundos. Tente abrir $appName para confirmar a tela de bloqueio do DeenFocus.';
  }

  @override
  String get focusDiagnosticStart => 'Iniciar teste';

  @override
  String get focusDiagnosticEndEarly => 'Encerrar teste';

  @override
  String focusDiagnosticRunning(int seconds) {
    return 'Bloqueio ativo por ${seconds}s. Mude para um app selecionado para testar a tela de bloqueio.';
  }

  @override
  String get focusDiagnosticSuccessTitle => 'Teste concluído';

  @override
  String get focusDiagnosticSuccessBody =>
      'O bloqueio foi ativado com seus apps selecionados. Se você viu a tela do DeenFocus, o bloqueio está funcionando.';

  @override
  String get focusDiagnosticCancelledTitle => 'Teste encerrado';

  @override
  String get focusDiagnosticCancelledBody =>
      'O bloqueio de diagnóstico foi desativado. Seus modos Foco e horários não foram alterados.';

  @override
  String get focusDiagnosticMissingAppsTitle => 'Selecione apps primeiro';

  @override
  String get focusDiagnosticMissingAppsBody =>
      'Escolha pelo menos um app para bloquear antes de iniciar o teste.';

  @override
  String get focusDiagnosticMissingPermissionTitle => 'Permissão necessária';

  @override
  String get focusDiagnosticMissingPermissionBodyIos =>
      'É necessário acesso ao Tempo de Uso. Permita e tente novamente.';

  @override
  String get focusDiagnosticMissingPermissionBodyAndroid =>
      'A acessibilidade do Android deve estar ativada para o DeenFocus bloquear apps.';

  @override
  String get focusDiagnosticFailedTitle => 'Não foi possível iniciar o teste';

  @override
  String get focusDiagnosticFailedBody =>
      'O bloqueio não foi ativado. Verifique permissões e apps selecionados e tente novamente.';

  @override
  String get focusDiagnosticClose => 'Concluir';

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
    return '$count orações';
  }

  @override
  String get insightsPrayersInARow => 'Orações seguidas';

  @override
  String get insightsDaysInARow => 'Dias seguidos';

  @override
  String insightsChipUpToday(int count) {
    return '↑ $count';
  }

  @override
  String get insightsChipDayUp => '↑ 1 hoje';

  @override
  String get insightsWeeklyCompletion => 'Progresso semanal';

  @override
  String get insightsMonthlyCompletion => 'Progresso mensal';

  @override
  String get insightsThisWeek => 'Esta semana';

  @override
  String get insightsThisMonth => 'Este mês';

  @override
  String get insightsOverall => 'Geral';

  @override
  String get insightsRateExcellent => 'Excelente';

  @override
  String get insightsRateGood => 'Bom';

  @override
  String get insightsRateFair => 'Razoável';

  @override
  String get insightsRateStart => 'Continua';

  @override
  String get insightsPrayersCompletedWeekly => 'Orações concluídas (semana)';

  @override
  String get insightsPrayersCompletedMonthly => 'Orações concluídas (mês)';

  @override
  String insightsCompletionSummary(int done, int possible) {
    return 'Concluíste $done de $possible orações.\nAlhamdulillah — continua!';
  }

  @override
  String get insightsFocusExcellent => 'Excelente — continue!';

  @override
  String get insightsFocusKeepGoing => 'Continue a construir o seu foco';

  @override
  String get insightsTodaysPrayers => 'Orações de hoje';

  @override
  String get insightsPrayersCompletedLabel =>
      'Orações concluídas — Alhamdulillah!';

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
  String get insightsMyProgress => 'O meu progresso';

  @override
  String insightsLevelNumber(int level) {
    return 'Nível $level';
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
    return '$xp XP para o nível $level';
  }

  @override
  String get insightsMaxLevel => 'NÍVEL MÁXIMO';

  @override
  String insightsAchievementsUnlocked(int unlocked, int total) {
    return '$unlocked / $total desbloqueadas';
  }

  @override
  String get insightsAchievementUnlockedTitle => 'Conquista desbloqueada';

  @override
  String get insightsLevelUpTitle => 'SUBISTE DE NÍVEL';

  @override
  String get achievementFirstPrayer => 'Primeira oração';

  @override
  String get achievementFajrChampion => 'Campeão do Fajr';

  @override
  String get achievementFiveADay => 'Cinco por dia';

  @override
  String get achievementPerfectWeek => 'Semana perfeita';

  @override
  String get achievementPerfectMonth => 'Mês perfeito';

  @override
  String get achievementQuranDevotee => 'Devoto do Alcorão';

  @override
  String get achievementDhikrStarter => 'Início do dhikr';

  @override
  String get achievementNightWorshipper => 'Adorador noturno';

  @override
  String get achievementMasjidCompanion => 'Companheiro da mesquita';

  @override
  String get achievementDistractionDefender => 'Defensor do foco';

  @override
  String get achievementCycleGuardian => 'Guardião do ciclo';

  @override
  String get achievementProtectedMonth => 'Mês protegido';

  @override
  String get achievementSixMonthJourney => 'Jornada de seis meses';

  @override
  String get achievementDeenFocusMaster => 'DeenFocus Master';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Os dias de ciclo estão protegidos e não quebram a sequência. Tens $days dia(s) protegido(s).';
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

  @override
  String get appLockDemoIntroTitle => 'Veja como o bloqueio de apps funciona';

  @override
  String get appLockDemoIntroSubtitle =>
      'Fique no DeenFocus. Na próxima tela, toque no Instagram para ver a pausa na hora da oração.';

  @override
  String get appLockDemoStartButton => 'Começar a demo';

  @override
  String get appLockDemoTryOpeningApp => 'Tente abrir o Instagram';

  @override
  String get appLockDemoSalahModeBadge => 'MODO SALAH';

  @override
  String get appLockDemoTimeToPray => 'É hora de orar';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Tempo restante: $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'Já rezei $prayerName';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName concluída';
  }

  @override
  String get appLockDemoStreakIncreased => 'Sua sequência de oração aumentou';

  @override
  String get appLockDemoPrayerStreakLabel => 'SEQUÊNCIA DE ORAÇÃO';

  @override
  String get appLockDemoDayStreakLabel => 'SEQUÊNCIA DE DIAS';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Próxima oração em $minutes minutos';
  }

  @override
  String get appLockDemoStreakMotivation =>
      'Continue! Sua consistência aproxima você de Allah.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Ore. Confirme uma vez.\nVolte ao seu dia.';

  @override
  String get appLockDemoCompletionBody =>
      'O bloqueio de apps pausa suavemente os apps selecionados durante a Salah para você se concentrar — depois continua quando estiver pronto.';

  @override
  String get appLockDemoContinueSetup => 'Continuar configuração';

  @override
  String get appLockDemoAppMessages => 'Mensagens';

  @override
  String get appLockDemoAppCalendar => 'Calendário';

  @override
  String get appLockDemoAppPhotos => 'Fotos';

  @override
  String get appLockDemoAppCamera => 'Câmera';

  @override
  String get appLockDemoAppMail => 'Mail';

  @override
  String get appLockDemoAppMaps => 'Mapas';

  @override
  String get appLockDemoAppWeather => 'Clima';

  @override
  String get appLockDemoAppClock => 'Relógio';

  @override
  String get appLockDemoAppNotes => 'Notas';

  @override
  String get appLockDemoAppSettings => 'Ajustes';

  @override
  String get appLockDemoAppMusic => 'Música';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Atualizações de oração';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live Activity da próxima oração na tela de bloqueio';

  @override
  String get liveActivitySectionTitle => 'Live Activities';

  @override
  String get liveActivityStayUpdatedTitle => 'Fique atualizado de relance';

  @override
  String get liveActivityStayUpdatedBody =>
      'Veja sua próxima oração e horário diretamente na tela de bloqueio.';

  @override
  String get liveActivityEnableLabel => 'Ativar Live Activity';

  @override
  String get liveActivityPromptNotNow => 'Agora não';

  @override
  String get liveActivityUnsupported =>
      'Live Activities não estão disponíveis neste dispositivo.';

  @override
  String get liveActivityPermissionNeeded =>
      'Permita notificações para mostrar atualizações de oração na tela de bloqueio.';

  @override
  String get liveActivityPermissionButton => 'Permitir notificações';

  @override
  String get liveActivityStatusActive => 'Live Activity ativada';

  @override
  String get liveActivityStatusOff => 'Live Activity desativada';

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
  String get liveActivityNowLabel => 'Agora';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Atualizado às $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer às $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Alarmes de oração';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Alarmes completos que podem ultrapassar o modo silencioso';

  @override
  String get prayerAlarmsMasterLabel => 'Ativar alarmes de oração';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Agendar um alarme nativo para cada oração selecionada';

  @override
  String get prayerAlarmsSnoozeLabel => 'Duração da soneca';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Alarmes por oração';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Permita o alarme para que toquem no horário.';

  @override
  String get prayerAlarmsPermissionButton => 'Permitir alarmes';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Permita alarmes em tela cheia na tela de bloqueio. Sem isso, avisam como banner.';

  @override
  String get prayerAlarmsFsiButton => 'Configurações de tela cheia';

  @override
  String get prayerAlarmsUnsupported =>
      'Alarmes nativos não estão disponíveis neste dispositivo. As notificações suaves ainda funcionam.';

  @override
  String get prayerAlarmsIosFallback =>
      'Nesta versão do iOS, usamos notificações suaves em vez do AlarmKit.';

  @override
  String get prayerAlarmsDeniedTitle => 'Permissão de alarme necessária';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Os alarmes de oração ficam desligados até você permitir. As notificações suaves não são afetadas.';

  @override
  String get prayerAlarmsOpenSettings => 'Abrir Ajustes';

  @override
  String get prayerAlarmsStatusReady => 'Alarmes prontos para agendar';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Permissão necessária — alarmes inativos';

  @override
  String get prayerAlarmsStatusFallback =>
      'Usando notificações suaves neste dispositivo';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Alarmes ligados. Ative a tela cheia para a tela de bloqueio.';

  @override
  String get prayerAlarmsCancel => 'Agora não';

  @override
  String get homePrayerAlarmEnableLabel => 'Alarme de oração';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Tocar um alarme nativo em $prayerName';
  }

  @override
  String get prayerAlarmBadge => 'Alarme de oração';

  @override
  String get prayerAlarmSubtitle => 'Hora de orar';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — Hora de orar';
  }

  @override
  String get prayerAlarmIvePrayed => 'Eu orei';

  @override
  String get prayerAlarmDismiss => 'Dispensar';

  @override
  String get prayerAlarmSnooze => 'Soneca';

  @override
  String get appLockDemoAppPhone => 'Telefone';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Lembretes';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Livros';

  @override
  String get appLockDemoAppHealth => 'Saúde';

  @override
  String get appLockDemoAppWallet => 'Carteira';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'Demo do app';

  @override
  String get settingsAppDemoChooseModeTitle => 'Experimente o bloqueio';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Escolha um modo Focus e veja como os apps selecionados pausam — sem sair do DeenFocus.';

  @override
  String get appLockDemoDone => 'Concluído';

  @override
  String get appLockDemoSleepIntroTitle => 'Veja como o Modo Sono funciona';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Fique no DeenFocus. Na próxima tela, toque no Instagram para ver a pausa na hora de dormir.';

  @override
  String get appLockDemoSleepModeBadge => 'MODO SONO';

  @override
  String get appLockDemoSleepLockTitle => 'Hora de descansar';

  @override
  String get appLockDemoSleepLockCta => 'Estou pronto para descansar';

  @override
  String get appLockDemoSleepCompleted => 'Modo Sono protegido';

  @override
  String get appLockDemoSleepRewardSubtitle => 'Sua proteção noturna aumentou';

  @override
  String get appLockDemoSleepStreakLabel => 'SEQUÊNCIA NOTURNA';

  @override
  String get appLockDemoSleepRewardFooter =>
      'Lembrete de Fajr definido para a manhã';

  @override
  String get appLockDemoSleepMotivation =>
      'Descanse bem esta noite para acordar com energia para o Fajr.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Noites tranquilas.\nManhãs claras.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'O Modo Sono pausa suavemente os apps selecionados à noite para você descansar — depois continua quando estiver pronto.';

  @override
  String get appLockDemoChildIntroTitle => 'Veja como o Modo Criança funciona';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Fique no DeenFocus. Na próxima tela, toque no Instagram para ver o bloqueio com o Modo Criança.';

  @override
  String get appLockDemoChildModeBadge => 'MODO CRIANÇA';

  @override
  String get appLockDemoChildLockTitle => 'Os apps estão protegidos';

  @override
  String get appLockDemoChildLockDetail =>
      'Os apps selecionados ficam bloqueados enquanto o Modo Criança está ativo';

  @override
  String get appLockDemoChildLockCta => 'Entendi';

  @override
  String get appLockDemoChildCompleted => 'Modo Criança ativo';

  @override
  String get appLockDemoChildRewardSubtitle =>
      'Sua sequência de proteção aumentou';

  @override
  String get appLockDemoChildStreakLabel => 'SEQUÊNCIA SEGURA';

  @override
  String get appLockDemoChildRewardFooter =>
      'Saia a qualquer momento com sua senha';

  @override
  String get appLockDemoChildMotivation =>
      'Tranquilidade sempre que você empresta o telefone.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'Modo seguro com um toque.\nSó o que você permite.';

  @override
  String get appLockDemoChildCompletionBody =>
      'O Modo Criança bloqueia os apps selecionados para seu filho ver só o que é seguro — depois você desbloqueia.';

  @override
  String get appLockDemoSleepCompletionTitle => 'Descanse bem esta noite';

  @override
  String get appLockDemoChildCompletionTitle => 'Tranquilidade';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Pause distrações no Salah para orar com presença.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Proteja suas noites para descansar melhor — e um Fajr mais leve.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Entregue o telefone com confiança: só os apps permitidos ficam abertos.';

  @override
  String get settingsAppDemoHomeFeaturesTitle => 'Fique por dentro de relance';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'Veja como widgets e Live Activity mantêm os horários de oração por perto — sem abrir o app.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Verso do dia e horários de oração na tela inicial, sempre atualizados.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Oração atual e seguinte na tela de bloqueio e Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Recite um versículo e receba feedback de tajweed na hora.';

  @override
  String get featureDemoTajweedTitle => 'Tajweed';

  @override
  String get featureDemoTajweedIntroTitle =>
      'Veja como funciona a prática de tajweed';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Fique no DeenFocus. Abra o exercício de tajweed, recite um versículo e veja o feedback palavra por palavra.';

  @override
  String get featureDemoTajweedQuranCallout =>
      'Toque em Exercício de tajweed para começar';

  @override
  String get featureDemoTajweedLegendCallout =>
      'As cores mostram as regras de tajweed na leitura';

  @override
  String get featureDemoTajweedReciteCallout =>
      'Toque em Recitar e verificar tajweed';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'Download único para praticar offline';

  @override
  String get featureDemoTajweedMicCallout =>
      'Toque no microfone e comece a recitar';

  @override
  String get featureDemoTajweedResultCallout =>
      'Veja quais palavras estavam corretas, omitidas ou a melhorar';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tajweed, pronto';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Recite com confiança, a qualquer hora.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Abra Alcorão → Exercício de tajweed para praticar qualquer versículo com pontuação no aparelho — totalmente offline após o primeiro download.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 versículos • Meca';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 versículos • Medina';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle =>
      'Al-Fatihah • 7 versículos';

  @override
  String get featureDemoTajweedSurahMeta => 'SURATA 1 • MECA';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'Em nome de Allah, o Clemente, o Misericordioso.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatihah · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'Preparando o modelo de IA';

  @override
  String get featureDemoTajweedPreparingBody =>
      'Download único para que a prática de tajweed funcione totalmente offline depois. Isso acontece só uma vez.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Continue praticando — ouça a referência e tente de novo.';

  @override
  String get featureDemoTajweedStatCorrect => 'Correto';

  @override
  String get featureDemoTajweedStatPronunciation => 'Pronúncia';

  @override
  String get featureDemoTajweedStatWrong => 'Palavra errada';

  @override
  String get featureDemoTajweedStatMissed => 'Omitida';

  @override
  String get featureDemoTajweedStatExtra => 'Extra';

  @override
  String get featureDemoContinue => 'Continuar';

  @override
  String get featureDemoSampleStatusTime => '9:41';

  @override
  String get featureDemoOfferWidgetManualBody =>
      'Seu dispositivo não permite que apps coloquem widgets automaticamente. Adicione o widget Grande do DeenFocus na galeria de widgets da tela inicial.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Adicione o widget pela tela inicial';

  @override
  String get featureDemoOfferNo => 'Não';

  @override
  String get featureDemoOfferYes => 'Sim';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      'Quer ativar o Live Activity no seu dispositivo?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      'Quer adicionar este widget à tela inicial?';

  @override
  String get featureDemoWidgetsTitle => 'Widgets';

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
      'Pronto para experimentar o Modo Oração?';

  @override
  String get appLockDemoOfferSleepTitle =>
      'Pronto para experimentar o Modo Sono?';

  @override
  String get appLockDemoOfferChildTitle =>
      'Pronto para experimentar o Modo Criança?';

  @override
  String get appLockDemoOfferPrayerCta => 'Ativar Modo Oração';

  @override
  String get appLockDemoOfferSleepCta => 'Ativar Modo Sono';

  @override
  String get appLockDemoOfferChildCta => 'Ativar Modo Criança';

  @override
  String get appLockDemoOfferNotNow => 'Agora não';

  @override
  String get nightlyWrapUpPrayersTitle => 'Conclua as orações de hoje';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Marque orações incompletas ou perdidas para proteger sua sequência de oração.';

  @override
  String get nightlyWrapUpChecklistTitle => 'Complete sua lista diária';

  @override
  String get nightlyWrapUpChecklistBody =>
      'Ainda há itens abertos — encerre o dia com intenção.';

  @override
  String get nightlyWrapUpBothTitle => 'Encerre o seu dia';

  @override
  String get nightlyWrapUpBothBody =>
      'Marque as orações restantes e termine sua lista diária antes do fim do dia.';

  @override
  String get cycleModeEndedNotificationTitle => 'O modo ciclo terminou';

  @override
  String get cycleModeEndedNotificationBody =>
      'Seu modo ciclo agora está desligado. Você pode retomar as orações. Se quiser alterar as datas do modo ciclo, toque aqui para editá-las.';

  @override
  String get libraryHomeTitle => 'Biblioteca islâmica';

  @override
  String get libraryHomeSubtitle => 'Aprenda hadith, duas, os 99 Nomes e mais';

  @override
  String get libraryHubTitle => 'Biblioteca islâmica';

  @override
  String get libraryModuleQuran => 'Alcorão';

  @override
  String get libraryModuleQuranSub => 'Leia, ouça e pratique o tajweed';

  @override
  String get libraryModuleHadith => 'Hadith';

  @override
  String get libraryModuleHadithSub => 'Coleções de fontes autênticas';

  @override
  String get libraryModuleDuas => 'Duas e adhkar';

  @override
  String get libraryModuleDuasSub => 'Lembrança da manhã, da noite e diária';

  @override
  String get libraryModulePrayerMethods => 'Oração e métodos islâmicos';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, salah, hajj e mais';

  @override
  String get libraryModuleFiqh => 'Fiqh e tradições';

  @override
  String get libraryModuleFiqhSub =>
      'Sunitas, xiitas, madhabs, Ahl-e Hadith e mais';

  @override
  String get libraryModuleNames => '99 Nomes de Allah';

  @override
  String get libraryModuleNamesSub => 'Aprenda e reflita sobre Asma ul-Husna';

  @override
  String get libraryModulePillarsIslam => 'Pilares do Islã';

  @override
  String get libraryModulePillarsIslamSub =>
      'Os cinco fundamentos da fé em ação';

  @override
  String get libraryModulePillarsIman => 'Pilares da fé';

  @override
  String get libraryModulePillarsImanSub => 'Os seis artigos da crença';

  @override
  String get libraryModuleProphets => 'Profeta Muhammad';

  @override
  String get libraryModuleProphetsSub => 'Sua vida, missão e lições eternas';

  @override
  String get libraryModuleOccasions => 'Ocasiões islâmicas';

  @override
  String get libraryModuleOccasionsSub => 'Ramadã, Eid, Hajj e dias sagrados';

  @override
  String get libraryKeyLesson => 'Lição principal';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current de $total';
  }

  @override
  String get libraryPrevious => 'Anterior';

  @override
  String get libraryNext => 'Próximo';

  @override
  String get libraryBookmark => 'Marcador';

  @override
  String get libraryCopy => 'Copiar';

  @override
  String get libraryShare => 'Partilhar';

  @override
  String get libraryCopied => 'Copiado para a área de transferência';

  @override
  String get libraryShareCopiedHint => 'Copiado — cole para partilhar';

  @override
  String get libraryShareReference => 'Referência';

  @override
  String get contentShareIntro =>
      'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍';

  @override
  String get contentShareExplore => 'Explorar o DeenFocus:';

  @override
  String get contentShareFailed =>
      'Não foi possível partilhar agora. Tente novamente.';

  @override
  String get libraryBookmarkSaved => 'Marcador guardado';

  @override
  String get libraryBookmarkRemoved => 'Marcador removido';

  @override
  String get libraryTranslation => 'Tradução';

  @override
  String get libraryTransliteration => 'Transliteração';

  @override
  String get libraryMeaning => 'Significado';

  @override
  String get libraryBookmarksTitle => 'Itens de aprendizagem guardados';

  @override
  String get libraryBookmarksSubtitle => 'Hadith, duas, nomes, fiqh e mais';

  @override
  String get libraryBookmarksEmpty =>
      'Ainda não há itens guardados. Toque em Marcador num item de aprendizagem para o guardar aqui.';

  @override
  String get libraryMarkCompleted => 'Marcar como concluído';

  @override
  String get librarySectionCompleted => 'Concluído';

  @override
  String get libraryReflection => 'Reflexão';

  @override
  String get libraryComingSoonTitle => 'Em breve';

  @override
  String get libraryComingSoonBody =>
      'Este módulo está sendo preparado. Volte em uma atualização futura.';

  @override
  String get librarySearchHint => 'Pesquisar…';

  @override
  String get libraryHubSearchHint => 'Pesquisar em Aprender…';

  @override
  String get libraryHubSearchSections => 'Secções';

  @override
  String get libraryHubSearchTopics => 'Tópicos';

  @override
  String get librarySearchEmpty => 'Nenhum resultado';

  @override
  String libraryItemCount(int count) {
    return '$count itens';
  }

  @override
  String librarySearchResultCount(int shown, int total) {
    return '$shown de $total';
  }

  @override
  String libraryContinueFrom(int number) {
    return 'Continuar · $number';
  }

  @override
  String get libraryInProgress => 'Em andamento';

  @override
  String libraryReference(String source) {
    return 'Referência: $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count duas';
  }

  @override
  String get libraryDuaCategoryMorning => 'Manhã';

  @override
  String get libraryDuaCategoryEvening => 'Noite';

  @override
  String get libraryDuaCategoryDailyLife => 'Vida diária';

  @override
  String get libraryDuaCategorySleep => 'Sono';

  @override
  String get libraryDuaCategoryFood => 'Comida';

  @override
  String get libraryDuaCategoryTravel => 'Viagem';

  @override
  String get libraryDuaCategoryIllness => 'Doença';

  @override
  String get libraryDuaCategoryProtection => 'Proteção';

  @override
  String get libraryDuaCategoryForgiveness => 'Perdão';

  @override
  String get libraryDuaCategoryParents => 'Pais';

  @override
  String libraryHadithCount(int count) {
    return '$count hadith';
  }

  @override
  String get libraryHadithNarrator => 'Narrador:';

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
    return '$count etapas';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Etapa $current de $total';
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
  String get libraryGuideJanazah => 'Oração fúnebre';

  @override
  String get libraryGuideUmrah => 'Umrah';

  @override
  String get libraryGuideHajj => 'Hajj';

  @override
  String get libraryGuideFasting => 'Jejum';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawba';

  @override
  String get libraryOccasionImportance => 'Importância';

  @override
  String get libraryOccasionVirtues => 'Virtudes';

  @override
  String get libraryOccasionRecommendedActs => 'Atos recomendados';

  @override
  String get libraryFiqhOverview => 'Visão geral';

  @override
  String get libraryFiqhKeyPoints => 'Pontos principais';

  @override
  String get libraryFiqhDifferences => 'Diferenças notáveis';

  @override
  String get libraryFiqhCommonGround => 'Pontos em comum';

  @override
  String get insightsCompleted => 'Concluídas';

  @override
  String get insightsInProgress => 'Em andamento';

  @override
  String get insightsKeepGoingTitle => 'Continue!';

  @override
  String get insightsKeepGoingBody =>
      'Você está progredindo muito. Cada oração conta.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Conquistas desbloqueadas';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer => 'Você fez sua primeira oração.';

  @override
  String get achievementDescSevenPrayerStreak => 'Complete 7 orações seguidas.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Complete 30 orações seguidas.';

  @override
  String get achievementDescFajrWarrior => 'Reze o Fajr em 14 dias.';

  @override
  String get achievementDescFajrChampion => 'Reze o Fajr em 30 dias.';

  @override
  String get achievementDescFiveADay => 'Complete as cinco orações em um dia.';

  @override
  String get achievementDescPerfectWeek =>
      'Complete todas as orações por 7 dias seguidos.';

  @override
  String get achievementDescPerfectMonth =>
      'Complete todas as orações por 30 dias seguidos.';

  @override
  String get achievementDescQuranReader => 'Leia o Alcorão em 7 dias.';

  @override
  String get achievementDescQuranDevotee => 'Leia o Alcorão em 30 dias.';

  @override
  String get achievementDescDhikrStarter => 'Complete o dhikr em 7 dias.';

  @override
  String get achievementDescDhikrMaster => 'Complete o dhikr em 30 dias.';

  @override
  String get achievementDescNightWorshipper => 'Reze o Tahajjud em 7 dias.';

  @override
  String get achievementDescMasjidCompanion => 'Visite a mesquita 7 vezes.';

  @override
  String get achievementDescDistractionDefender =>
      'Fique sem distrações por 7 dias.';

  @override
  String get achievementDescCycleGuardian =>
      'Proteja sua sequência com o modo ciclo por 7 dias.';

  @override
  String get achievementDescProtectedMonth =>
      'Proteja sua sequência com o modo ciclo por 30 dias.';

  @override
  String get achievementDescConsistencyChampion =>
      'Mantenha a constância por 100 dias.';

  @override
  String get achievementDescSixMonthJourney => 'Continue por 180 dias.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Alcance DeenFocus Master (nível 15).';

  @override
  String get dailyChecklistOptional => 'Opcional';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Controlar a raiva / Falar com gentileza';

  @override
  String get digitalBalanceTitle => 'Equilíbrio digital';

  @override
  String get digitalBalanceSubtitle => 'Veja para onde vai o seu tempo';

  @override
  String get digitalBalanceViewCta => 'Ver equilíbrio digital →';

  @override
  String get digitalBalanceTodayLabel => 'Hoje';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Outros apps';

  @override
  String get digitalBalanceTodayPhoneTime => 'Tempo de telefone de hoje';

  @override
  String get digitalBalanceWhereTimeGoes => 'Para onde vai o seu tempo';

  @override
  String get digitalBalanceViewAllApps => 'Ver todos os apps';

  @override
  String get digitalBalanceAllAppsTitle => 'Todos os apps';

  @override
  String get digitalBalanceNoApps => 'Ainda não há uso de apps registado hoje.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen vs. tempo digital';

  @override
  String get digitalBalanceYourWeek => 'A sua semana';

  @override
  String get digitalBalanceThisWeek => 'Esta semana';

  @override
  String get digitalBalancePhoneUsageLegend => 'Uso do telefone';

  @override
  String get digitalBalanceDailyInsight => 'Nota do dia';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Cada minuto a fortalecer o seu Deen importa.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'O seu tempo no DeenFocus está maior esta semana do que na anterior. MashaAllah!';

  @override
  String get digitalBalanceInsightQuietDay =>
      'Um dia calmo até agora. O tempo no DeenFocus aparecerá aqui.';

  @override
  String get digitalBalanceGoalTitle => 'A sua meta de tempo de Deen';

  @override
  String get digitalBalanceAdjustGoal => 'Ajustar meta';

  @override
  String get digitalBalanceGoalReached =>
      'Alcançou a meta de hoje. MashaAllah!';

  @override
  String get digitalBalanceGoalSheetTitle => 'Tempo de Deen diário';

  @override
  String get digitalBalanceGoalCustomHint => 'Minutos por dia';

  @override
  String get digitalBalanceGoalSave => 'Guardar';

  @override
  String get digitalBalanceGoal15 => '15 min';

  @override
  String get digitalBalanceGoal30 => '30 min';

  @override
  String get digitalBalanceGoal45 => '45 min';

  @override
  String get digitalBalanceGoal60 => '1 hora';

  @override
  String get digitalBalancePermissionTitle =>
      'Compreenda os seus hábitos digitais';

  @override
  String get digitalBalancePermissionBody =>
      'Permita que o DeenFocus aceda ao uso das apps para ver para onde vai o seu tempo e quanto dá ao seu Deen.';

  @override
  String get digitalBalanceEnableUsage => 'Ativar uso de apps';

  @override
  String get digitalBalanceMaybeLater => 'Talvez mais tarde';

  @override
  String get digitalBalanceUnavailableTitle =>
      'O uso de apps não está disponível aqui';

  @override
  String get digitalBalanceUnavailableBody =>
      'A Apple não partilha o Tempo de ecrã com outras apps, por isso o Digital Balance ainda não pode mostrar o uso do iPhone. Orações, sequências e insights continuam a funcionar.';

  @override
  String get digitalBalanceInfoTitle => 'Sobre o equilíbrio digital';

  @override
  String get digitalBalanceInfoBody =>
      'O equilíbrio digital ajuda a ver para onde vai o seu tempo e quanto dá ao seu Deen. O uso fica no seu dispositivo.';

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
    return 'DeenFocus · $percent% do tempo de telefone';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% do seu tempo de telefone';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% do tempo de telefone de hoje';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% mais tempo no DeenFocus do que na semana passada';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'Passou $duration no DeenFocus hoje. Continue o hábito.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'O seu tempo no DeenFocus aumentou $percent% em relação a ontem.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / dia';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return '$minutes minutos para atingir a meta de hoje';
  }

  @override
  String get tajweedPracticeTitle => 'Prática de tajweed';

  @override
  String tajweedPracticeAyahTitle(String surah, String ref) {
    return '$surah · $ref';
  }

  @override
  String get tajweedDownloadTitle => 'Preparando o modelo de IA';

  @override
  String get tajweedDownloadFailedTitle =>
      'Não foi possível preparar o modelo de IA';

  @override
  String get tajweedDownloadBody =>
      'Download único para a prática de tajweed funcionar totalmente offline depois. Isto só acontece uma vez.';

  @override
  String get tajweedDownloadFinishing => 'A concluir a configuração…';

  @override
  String get tajweedDownloadCanLeave =>
      'Pode sair deste ecrã — o download continua em segundo plano.';

  @override
  String get tajweedDownloadTryAgain => 'Tentar novamente';

  @override
  String get tajweedDownloadPleaseTryAgain => 'Tente novamente.';

  @override
  String get tajweedErrorFeatureDisabled =>
      'A prática de tajweed com IA está desativada. Ative-a primeiro nas Definições.';

  @override
  String get tajweedErrorModelMissing =>
      'O modelo de IA ainda não está instalado.';

  @override
  String get tajweedErrorModelDownloadFailed =>
      'Falha ao descarregar o modelo de IA. Verifique a ligação e tente novamente.';

  @override
  String get tajweedErrorModelLoadFailed =>
      'Não foi possível carregar o modelo de IA neste dispositivo.';

  @override
  String get tajweedErrorCouldNotPrepare =>
      'Não foi possível preparar o modelo de IA.';

  @override
  String get tajweedErrorUnsupported =>
      'A prática de tajweed com IA não está disponível neste dispositivo.';

  @override
  String get sharePromoTitle => 'Veja isto no DeenFocus 🌙';

  @override
  String get sharePromoBody =>
      'Uma app simples para te ajudar a manter o foco no teu Deen, orar a tempo e criar melhores hábitos.';

  @override
  String get sharePromoDownloadHeading => 'Descarrega o DeenFocus:';

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
      'O teu companheiro para um Deen melhor, todos os dias.';

  @override
  String get shareDownloadCta => 'Descarregar o DeenFocus';

  @override
  String get shareAppStoreBadge => 'App Store';

  @override
  String get sharePlayStoreBadge => 'Google Play';

  @override
  String get shareFailed => 'Não foi possível partilhar. Tenta novamente.';

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
  String get insightsLevelName1 => 'Novo começo';

  @override
  String get insightsLevelName2 => 'Primeiros passos';

  @override
  String get insightsLevelName3 => 'Criar o hábito';

  @override
  String get insightsLevelName4 => 'Orante constante';

  @override
  String get insightsLevelName5 => 'Coração constante';

  @override
  String get insightsLevelName6 => 'Guardião da oração';

  @override
  String get insightsLevelName7 => 'Servo dedicado';

  @override
  String get insightsLevelName8 => 'Rotina sólida';

  @override
  String get insightsLevelName9 => 'Orante devoto';

  @override
  String get insightsLevelName10 => 'Firme';

  @override
  String get insightsLevelName11 => 'Fé mais profunda';

  @override
  String get insightsLevelName12 => 'Forte consistência';

  @override
  String get insightsLevelName13 => 'Líder na devoção';

  @override
  String get insightsLevelName14 => 'Consistência excecional';

  @override
  String get insightsLevelName15 => 'DeenFocus Master';

  @override
  String get lockScreenOptionsTitle => 'Estilo da tela de bloqueio';

  @override
  String get lockScreenOptionsSubtitle =>
      'Escolha como os lembretes de oração aparecem';

  @override
  String get lockScreenOptionsHint =>
      'Toque em um estilo para abrir o layout em tela cheia.';

  @override
  String get lockScreenDefaultBadge => 'Padrão';

  @override
  String get lockScreenSelectedBadge => 'Selecionado';

  @override
  String get lockScreenPreviewLabel => 'Pré-visualização';

  @override
  String get lockScreenStyleClassic => 'Lembrete de oração';

  @override
  String get lockScreenStyleTasbih => 'Contador de tasbih';

  @override
  String get lockScreenStyleVerse => 'Versículo diário';

  @override
  String get lockScreenStyleDua => 'Dua diária';

  @override
  String get lockScreenStyleQuiz => 'Verificação de conhecimento';

  @override
  String get lockScreenStyleTimes => 'Horários de oração';

  @override
  String get lockScreenStyleCountdown => 'Contagem regressiva';

  @override
  String get lockScreenStyleHold => 'Mantenha pressionado para confirmar';

  @override
  String get lockScreenStyleType => 'Digite para confirmar';

  @override
  String get lockScreenStyleMinimal => 'Foco mínimo';

  @override
  String get lockScreenItsTimeToPray => 'Está na hora de orar:';

  @override
  String lockScreenRemainingTime(String time) {
    return 'Tempo restante: $time';
  }

  @override
  String get lockScreenRemindLater => 'Lembrar-me mais tarde';

  @override
  String get lockScreenNextVerse => 'Próximo versículo';

  @override
  String get lockScreenVerseForToday => 'Versículo de hoje';

  @override
  String get lockScreenDuaForToday => 'Dua de hoje';

  @override
  String get lockScreenTapToCount => 'Toque em qualquer lugar para contar';

  @override
  String get lockScreenHoldHint => 'Pressione e segure para confirmar';

  @override
  String lockScreenTypeHint(String word) {
    return 'Digite $word para confirmar';
  }

  @override
  String get lockScreenTypeWord => 'ALHAMDULILLAH';

  @override
  String get lockScreenConfirmBeforeAllah =>
      'Confirme perante Allah que você orou.';

  @override
  String get lockScreenQuizCategory => 'Oração';

  @override
  String get lockScreenQuizQuestion =>
      'Quantas orações diárias são obrigatórias?';

  @override
  String get lockScreenQuizA => 'Três';

  @override
  String get lockScreenQuizB => 'Quatro';

  @override
  String get lockScreenQuizC => 'Cinco';

  @override
  String get lockScreenQuizCorrect => 'Correto';

  @override
  String get lockScreenQuizIncorrect => 'Incorreto';

  @override
  String get lockScreenQuizComplete => 'Verificação de conhecimento concluída';

  @override
  String get lockScreenQuizCategoryFasting => 'Jejum';

  @override
  String get lockScreenQuizCategoryPillars => 'Pilares';

  @override
  String get lockScreenQuizQ2 => 'Em que mês os muçulmanos jejuam?';

  @override
  String get lockScreenQuizQ2A => 'Shawwal';

  @override
  String get lockScreenQuizQ2B => 'Ramadã';

  @override
  String get lockScreenQuizQ2C => 'Muharram';

  @override
  String get lockScreenQuizQ3 => 'Qual é o primeiro pilar do islã?';

  @override
  String get lockScreenQuizQ3A => 'Salat';

  @override
  String get lockScreenQuizQ3B => 'Shahada';

  @override
  String get lockScreenQuizQ3C => 'Hajj';

  @override
  String get lockScreenTimeUp => 'O tempo acabou';

  @override
  String get lockScreenHoldRelease => 'Continue pressionando para confirmar';

  @override
  String lockScreenCountProgress(int current, int total) {
    return '$current de $total';
  }

  @override
  String get lockScreenVerseTranslation =>
      'Lembrai-vos de Mim, que Eu Me lembrarei de vós.';

  @override
  String get lockScreenVerseRef => 'Alcorão 2:152';

  @override
  String get lockScreenDuaTransliteration => 'Rabbana atina fid-dunya hasanah';

  @override
  String get lockScreenDuaTranslation =>
      'Senhor nosso, concede-nos o bem neste mundo e o bem na outra vida.';

  @override
  String get lockScreenDuaSource => 'Al-Baqara 2:201';

  @override
  String get lockScreenSampleRemaining => '2h 34min';

  @override
  String get lockScreenDhikrAstaghfirullah => 'Astaghfirullah';

  @override
  String get lockScreenDhikrSubhanAllah => 'SubhanAllah';

  @override
  String get lockScreenDhikrAlhamdulillah => 'Alhamdulillah';

  @override
  String get lockScreenDhikrAllahuAkbar => 'Allahu Akbar';

  @override
  String get homeTajweedPromoTitle => 'Tajweed do Alcorão com IA';

  @override
  String get homeTajweedPromoBody =>
      'Recite qualquer versículo e receba feedback instantâneo de IA sobre seu tajweed.';

  @override
  String get homeTajweedPromoCta => 'Praticar tajweed';

  @override
  String get homeTajweedPromoAiFeedback => 'Feedback de IA';

  @override
  String homeTajweedPromoWordAccuracy(int percent) {
    return '$percent% precisão de palavras';
  }

  @override
  String get homeLockScreenPromoTitle => 'Estilos de tela de bloqueio';

  @override
  String get homeLockScreenPromoBody =>
      'Personalize sua tela de bloqueio com belos designs islâmicos e lembretes úteis.';

  @override
  String get homeLockScreenPromoCta => 'Explorar estilos';

  @override
  String get homePromoNewBadge => 'NOVO';

  @override
  String get homeReadQuranPromoTitle => 'Ler o Alcorão';

  @override
  String get homeReadQuranPromoSubtitle => 'Leia, ouça e pratique tajweed';

  @override
  String get homeReadQuranPromoCta => 'Abrir Alcorão';

  @override
  String get homeReadQuranPromoNewBadge => 'Novo';

  @override
  String cycleModeActiveStatus(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Sequência protegida • Termina em $days dias',
      one: 'Sequência protegida • Termina amanhã',
      zero: 'Sequência protegida • Termina hoje',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeProtectPrayerStreakSubtitle =>
      'Mantém a tua sequência intacta durante os dias do ciclo';

  @override
  String get cycleModeExcludeFromStatisticsSubtitle =>
      'Não contar os dias do ciclo nas estatísticas de oração';

  @override
  String get homePromoPreviewCity => 'Lahore';

  @override
  String get focusScreenTimeAuthPasscodeRequired =>
      'Este iPhone precisa de um código do dispositivo antes da Apple permitir o acesso ao Tempo de Uso. Defina-o em Ajustes e tente de novo.';

  @override
  String get focusScreenTimeAuthCanceled =>
      'O acesso ao Tempo de Uso foi cancelado antes da Apple concedê-lo. Tente de novo e conclua o aviso da Apple.';

  @override
  String get focusScreenTimeAuthConflict =>
      'Outro app já gerencia os Controles parentais neste iPhone. Desative-o primeiro e tente de novo.';

  @override
  String get focusScreenTimeAuthInvalidAccount =>
      'Entre com uma conta iCloud válida neste iPhone e tente o acesso ao Tempo de Uso novamente.';

  @override
  String get focusScreenTimeAuthNetwork =>
      'Este iPhone precisa de internet para a Apple conceder o acesso ao Tempo de Uso.';

  @override
  String get focusScreenTimeAuthRestricted =>
      'Os Controles parentais estão restritos neste iPhone, então o DeenFocus não pode solicitar o acesso ao Tempo de Uso aqui.';

  @override
  String get focusScreenTimeAuthUnavailable =>
      'Os Controles parentais estão indisponíveis neste iPhone no momento.';

  @override
  String get focusScreenTimeAuthIosVersion =>
      'O bloqueio de apps com Tempo de Uso exige iOS 16 ou posterior.';

  @override
  String get focusScreenTimeAuthInvalidArgument =>
      'A solicitação de autorização do Tempo de Uso é inválida. Tente de novo.';

  @override
  String get focusScreenTimeAuthFailedGeneric =>
      'Não foi possível conceder o acesso ao Tempo de Uso neste iPhone.';

  @override
  String widgetLockCountdownHoursMinutes(String hours, String minutes) {
    return 'Em $hours h $minutes min';
  }

  @override
  String widgetLockCountdownMinutes(String minutes) {
    return 'Em $minutes min';
  }

  @override
  String get lockScreenRecommendedBadge => 'Recomendado';
}
