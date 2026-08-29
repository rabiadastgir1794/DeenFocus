// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Enfoque Deen';

  @override
  String get appTagline => 'Fe. Enfocar. Consistencia';

  @override
  String get welcomeGreeting => 'ASSALAMU ALAIKUM';

  @override
  String get welcomeTagline =>
      'Modo de oración. Modo infantil. Modo de suspensión.';

  @override
  String get welcomeDescription =>
      'Realice un seguimiento de sus oraciones, lea el Corán, cuente el Tasbih y cree rachas significativas, todo en un solo lugar.';

  @override
  String get skip => 'Saltar';

  @override
  String get notNow => 'Ahora no';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueForFree => 'Quizá más tarde — explora la app primero';

  @override
  String get getStarted => 'Comenzar mi prueba gratis de 7 días';

  @override
  String get language => 'Idioma';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'DE ACUERDO';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get locationRequired => 'Ubicación requerida';

  @override
  String get locationRequiredMessage =>
      'Se requiere acceso a la ubicación para calcular los tiempos de oración precisos y la dirección de la Qibla. Debe habilitarlo para usar la aplicación.';

  @override
  String get notificationsRequired => 'Notificaciones requeridas';

  @override
  String get notificationsRequiredMessage =>
      'Se requieren notificaciones para recibir alertas y recordatorios de tiempos de oración.';

  @override
  String get sectTitle => 'Elige tu secta';

  @override
  String get sectSubtitle => 'Esto nos ayuda a personalizar tu experiencia.';

  @override
  String get sectSunni => 'suní';

  @override
  String get sectShia => 'chiita';

  @override
  String get sectPreferNotToSay => 'Prefiero no decir';

  @override
  String get nameTitle => '¿Cómo te llamas?';

  @override
  String get nameSubtitle => 'Personalizamos tu saludo';

  @override
  String get namePlaceholder => 'Su nombre';

  @override
  String get locationTitle => 'Encuentra tu Qibla';

  @override
  String get locationSubtitle =>
      'Activa la ubicación para Qibla, horarios de oración y mezquitas cercanas precisos.';

  @override
  String get locationButton => 'Permitir acceso a la ubicación';

  @override
  String get locationManualEntry => 'Introduce tu ciudad manualmente';

  @override
  String get locationOrDivider => 'o';

  @override
  String get locationPrivacyNote => 'Se queda en tu dispositivo';

  @override
  String get locationFeaturePrayerTimesTitle => 'Horarios de oración';

  @override
  String get locationFeatureQiblaTitle => 'Qibla';

  @override
  String get locationFeatureMasjidsTitle => 'Mezquitas';

  @override
  String get notificationsTitle => 'No te pierdas ninguna oración';

  @override
  String get notificationsSubtitle =>
      'Alertas de adhan, recordatorios de enfoque y dhikr diario — justo cuando los necesitas.';

  @override
  String get notificationsButton => 'Habilitar notificaciones';

  @override
  String get notificationsMaybeLater => 'Quizá más tarde';

  @override
  String get notificationsEnabled => 'Las notificaciones están habilitadas.';

  @override
  String get notificationsPreviewDate => 'Viernes, 10 de julio';

  @override
  String get notificationsPreviewTime => '6:42';

  @override
  String get notificationsPreviewNow => 'ahora';

  @override
  String get notificationsPreviewMinutesAgo => 'hace 2 min';

  @override
  String get notificationsPreviewHourAgo => 'hace 1 h';

  @override
  String get notificationsPreviewAdhanTitle => 'Adhan de Maghrib';

  @override
  String get notificationsPreviewAdhanBody => 'Es hora de orar.';

  @override
  String get notificationsPreviewDhikrTitle => 'Dhikr diario';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — tómate un momento.';

  @override
  String get notificationsPreviewStreakTitle => 'Racha';

  @override
  String get notificationsPreviewStreakBody => '7 días de oraciones completas.';

  @override
  String get screenTimeTitle => 'Activar Tiempo en pantalla';

  @override
  String get screenTimeSubtitle =>
      'Esto permite que Deen Focus pause las apps que distraen durante Salah, el sueño y el modo infantil.';

  @override
  String get screenTimeButton => 'Permitir acceso a Tiempo en pantalla';

  @override
  String get screenTimePrivacyNote =>
      'Deen Focus nunca lee tus datos — solo pausa las apps que eliges.';

  @override
  String get onboardingSelectAppsTitlePrefix => 'Selecciona';

  @override
  String get onboardingSelectAppsTitleAccent => 'Apps para bloquear';

  @override
  String get onboardingSelectAppsSubtitle =>
      'Selecciona las apps que quieres bloquear cuando sea hora de orar.';

  @override
  String get onboardingSelectAppsButton => 'Seleccionar apps';

  @override
  String get onboardingSelectAppsSkipForNow => 'Omitir por ahora';

  @override
  String get onboardingSelectAppsPrivacyTitle => 'Tú tienes el control';

  @override
  String get onboardingSelectAppsPrivacyBody =>
      'Nunca leemos tus datos. Solo bloqueamos las apps que eliges.';

  @override
  String get onboardingSelectAppsMockAllApps => 'Todas las apps y categorías';

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
    return 'PASO $current DE $total';
  }

  @override
  String get screenTimeStep1Title => 'Abrir el aviso de Tiempo en pantalla';

  @override
  String get screenTimeStep1Body =>
      'Toca «Permitir acceso a Tiempo en pantalla» — tu dispositivo mostrará su propia solicitud de permiso.';

  @override
  String get screenTimeStep2Title => 'Toca Continuar y luego Permitir';

  @override
  String get screenTimeStep2Body =>
      'Aprueba la solicitud para que Deen Focus pueda pausar apps en el momento adecuado.';

  @override
  String get screenTimeStep3Title => 'Elige apps para bloquear';

  @override
  String get screenTimeStep3Body =>
      'Elige las apps que más te distraen: redes, juegos, vídeo, lo que sea.';

  @override
  String get screenTimeStep4Title => 'Estás protegido';

  @override
  String get screenTimeStep4Body =>
      'Las apps se bloquean automáticamente durante Salah, el sueño y el modo infantil.';

  @override
  String get screenTimePromptTitle => 'Tiempo en pantalla';

  @override
  String screenTimePromptMessage(String appName) {
    return '«$appName» quiere acceder a Tiempo en pantalla';
  }

  @override
  String get screenTimeDontAllow => 'No permitir';

  @override
  String get screenTimePromptContinue => 'Continuar';

  @override
  String get screenTimeAppInstagram => 'Instagram';

  @override
  String get screenTimeAppTikTok => 'TikTok';

  @override
  String get screenTimeAppYouTube => 'YouTube';

  @override
  String get screenTimeAppGames => 'Juegos';

  @override
  String get screenTimeAndroidStep1Title => 'Abrir acceso de uso';

  @override
  String get screenTimeAndroidStep1Body =>
      'Toca «Permitir acceso a Tiempo en pantalla» — tu dispositivo abrirá el acceso de uso para Deen Focus.';

  @override
  String get screenTimeAndroidStep2Title => 'Activar Accesibilidad';

  @override
  String get screenTimeAndroidStep2Body =>
      'Activa el servicio de Deen Focus para pausar apps durante Salah, el sueño y el modo infantil.';

  @override
  String get screenTimeAndroidStep3Title => 'Elige apps para bloquear';

  @override
  String get screenTimeAndroidStep3Body =>
      'Elige las apps que más te distraen: redes, juegos, vídeo, lo que sea.';

  @override
  String get screenTimeAndroidStep4Title => 'Estás protegido';

  @override
  String get screenTimeAndroidStep4Body =>
      'Las apps se bloquean automáticamente durante Salah, el sueño y el modo infantil.';

  @override
  String get screenTimeAndroidUsageTitle => 'Acceso de uso';

  @override
  String get screenTimeAndroidUsageMessage =>
      'Permitir que Deen Focus rastree qué otras apps se usan.';

  @override
  String get screenTimeAndroidAccessibilityTitle => 'Accesibilidad';

  @override
  String get screenTimeAndroidAccessibilityMessage =>
      'Deen Focus necesita Accesibilidad para pausar apps que distraen durante las sesiones de enfoque.';

  @override
  String get screenTimeAndroidPermit => 'Permitir';

  @override
  String get screenTimeAndroidEnable => 'Activar';

  @override
  String get screenTimeAndroidNotNow => 'Ahora no';

  @override
  String get focusModesTitle => 'Todo en una app';

  @override
  String get focusModesSubtitle =>
      'Explora todo lo que ofrece Deen Focus. Toca un modo de enfoque para ver cómo funciona.';

  @override
  String get onboardingWidgetsLiveTitle => 'Tus oraciones, siempre al alcance';

  @override
  String get onboardingWidgetsLiveSubtitle =>
      'Mantente conectado con lo que más importa, desde la pantalla de inicio o de bloqueo.';

  @override
  String get onboardingWidgetsSectionTitle => 'Widgets';

  @override
  String get onboardingWidgetsSectionBodyPrefix =>
      'Consulta tu próxima oración, rachas y progreso ';

  @override
  String get onboardingWidgetsSectionBodyEmphasis => 'de un vistazo.';

  @override
  String get onboardingLiveActivitiesSectionTitle => 'Live Activity';

  @override
  String get onboardingLiveActivitiesSectionBodyPrefix =>
      'Consulta las actualizaciones de tu próxima oración en ';

  @override
  String get onboardingLiveActivitiesSectionBodyEmphasis => 'tiempo real';

  @override
  String get onboardingLiveActivitiesSectionBodySuffix =>
      ' en la pantalla de bloqueo y Dynamic Island.';

  @override
  String get onboardingWidgetsLiveTrustPrefix =>
      'Diseñado para ayudarte a mantenerte ';

  @override
  String get onboardingWidgetsLiveTrustEmphasis => 'constante';

  @override
  String get onboardingWidgetsLiveTrustSuffix =>
      ' y no perderte lo que más importa.';

  @override
  String get onboardingWidgetsMockStreak => 'Racha';

  @override
  String get onboardingWidgetsMockStreakValue => '12 días';

  @override
  String get onboardingWidgetsMockFocus => 'Enfocar';

  @override
  String get onboardingWidgetsMockFocusValue => '25 min';

  @override
  String get onboardingWidgetsLiveLockDate => 'Martes, 6 de mayo';

  @override
  String get onboardingWidgetsLiveLockTime => '9:41';

  @override
  String get onboardingWidgetsLiveNextPrayer => 'Dhuhr 12:45, en 02:15:32';

  @override
  String get focusModesSectionLabel => 'MODOS DE ENFOQUE · TOCA PARA SABER MÁS';

  @override
  String get focusPrayerTrackingSectionLabel => 'ORACIÓN Y SEGUIMIENTO';

  @override
  String get focusLearningHubSectionLabel => 'CENTRO DE APRENDIZAJE';

  @override
  String get focusMoreSectionLabel => 'MÁS';

  @override
  String get focusPrayerModeTitle => 'Modo de oración';

  @override
  String get focusPrayerModeDescription =>
      'Bloquea automáticamente las apps que distraen durante Salah para orar con pleno khushu.';

  @override
  String get focusPrayerModeBullet1 => 'Bloquea apps a la hora de la oración';

  @override
  String get focusPrayerModeBullet2 => 'Se desbloquea cuando terminas';

  @override
  String get focusPrayerModeBullet3 => 'Fortalece el enfoque y la constancia';

  @override
  String get focusSleepModeTitle => 'Modo de suspensión';

  @override
  String get focusSleepModeDescription =>
      'Relájate de forma halal. Bloquea apps a la hora de dormir para descansar bien y despertar para el Fajr.';

  @override
  String get focusSleepModeBullet1 =>
      'Bloquea apps automáticamente al acostarte';

  @override
  String get focusSleepModeBullet2 =>
      'Recordatorios suaves para despertar al Fajr';

  @override
  String get focusSleepModeBullet3 => 'Protege tu sueño y el Fajr';

  @override
  String get focusChildModeTitle => 'Modo infantil';

  @override
  String get focusChildModeDescription =>
      '¿Le das el teléfono a tu hijo? Bloquea apps al instante para que solo vea lo seguro.';

  @override
  String get focusChildModeBullet1 => 'Modo seguro con un toque';

  @override
  String get focusChildModeBullet2 => 'Salida protegida con código';

  @override
  String get focusChildModeBullet3 => 'Tranquilidad en todo momento';

  @override
  String get restrictedModeSalahTitle => 'Hora del Salah';

  @override
  String get restrictedModeSalahMessage =>
      'Aléjate de las distracciones y responde a la llamada a la oración.';

  @override
  String get restrictedModeSalahInfo =>
      'Aprovecha este momento para conectar con Alá.';

  @override
  String get restrictedModeSalahQuote =>
      'Establece la oración para Mi recuerdo.';

  @override
  String get restrictedModeSalahQuoteSource => 'Corán 20:14';

  @override
  String get restrictedModeSalahCta => 'Empezar Salah';

  @override
  String get restrictedModeChildTitle => 'Modo enfoque infantil';

  @override
  String get restrictedModeChildMessage =>
      'Un espacio más seguro y equilibrado para el tiempo de pantalla enfocado.';

  @override
  String get restrictedModeChildInfo =>
      'Algunas apps no están disponibles temporalmente.';

  @override
  String get restrictedModeChildQuote =>
      'Enseñad a vuestros hijos la oración a los siete años.';

  @override
  String get restrictedModeChildQuoteSource => 'Hadiz - Abu Dawud';

  @override
  String get restrictedModeChildCta => 'Mantente protegido';

  @override
  String get restrictedModeNightTitle => 'Modo enfoque nocturno';

  @override
  String get restrictedModeNightMessage =>
      'Es hora de descansar y desconectarse de las distracciones digitales.';

  @override
  String get restrictedModeNightInfo =>
      'Deja el dispositivo a un lado y disfruta de una noche tranquila.';

  @override
  String get restrictedModeNightQuote =>
      'Y hicimos del sueño un descanso para vosotros.';

  @override
  String get restrictedModeNightQuoteSource => 'Corán 78:9';

  @override
  String get restrictedModeNightCta => 'Buenas noches';

  @override
  String get restrictedModeAppsUnavailable =>
      'Algunas apps no están disponibles temporalmente.';

  @override
  String get focusModeGotIt => 'Entendido';

  @override
  String get focusFeaturePrayerTimesTitle => 'Horarios de oración precisos';

  @override
  String get focusFeaturePrayerTimesSubtitle => 'Adhan y recordatorios';

  @override
  String get focusFeatureStreaksTitle => 'Rachas';

  @override
  String get focusFeatureStreaksSubtitle => 'Mantente constante';

  @override
  String get focusFeatureChecklistTitle => 'Lista diaria';

  @override
  String get focusFeatureChecklistSubtitle => 'Crea buenos hábitos';

  @override
  String get focusFeatureQiblaTitle => 'Qibla y mezquita';

  @override
  String get focusFeatureQiblaSubtitle => 'Dirección y mezquitas';

  @override
  String get focusFeatureQuranTitle => 'Corán';

  @override
  String get focusFeatureQuranSubtitle => 'Traducciones, yuz y páginas';

  @override
  String get focusFeatureHadithTitle => 'Hadiz';

  @override
  String get focusFeatureHadithSubtitle => 'Colecciones auténticas';

  @override
  String get focusFeatureDuasTitle => 'Duas';

  @override
  String get focusFeatureDuasSubtitle => 'Súplicas diarias';

  @override
  String get focusFeatureTasbihTitle => 'Tasbih';

  @override
  String get focusFeatureTasbihSubtitle => 'Contador digital de dhikr';

  @override
  String get focusFeatureAiTitle => 'Compañero de IA';

  @override
  String get focusFeatureAiSubtitle => 'Pregunta sobre tu Din';

  @override
  String get focusFeatureInsightsTitle => 'Estadísticas';

  @override
  String get focusFeatureInsightsSubtitle => 'Datos semanales y mensuales';

  @override
  String get investTitle => 'Invierte en el Din';

  @override
  String get investSubtitle =>
      'La mejor inversión no es en lo que se desvanece — es en lo que te acerca a Allah. Prueba todo gratis durante 7 días.';

  @override
  String get investPremiumUnlocked => 'PREMIUM DESBLOQUEADO';

  @override
  String get investTrialPill =>
      '✨ 7 días gratis — cancela cuando quieras antes de que termine';

  @override
  String get investNoCommitment => 'Sin compromiso. Cancela cuando quieras.';

  @override
  String get investFeatureAiTitle => 'Asistente islámico con IA';

  @override
  String get investFeatureAiBody =>
      'Pregunta lo que quieras sobre tu Din — respuestas basadas en fuentes auténticas.';

  @override
  String get investFeaturePrayerModeTitle =>
      'Modo de oración a pantalla completa';

  @override
  String get investFeaturePrayerModeBody =>
      'Una pantalla tranquila y sin distracciones que te llama a la Salah.';

  @override
  String get investFeatureAppBlockingTitle => 'Bloqueo avanzado de apps';

  @override
  String get investFeatureAppBlockingBody =>
      'Control preciso sobre qué apps se bloquean y exactamente cuándo.';

  @override
  String get investFeatureNightModeTitle => 'Modo de disciplina nocturna';

  @override
  String get investFeatureNightModeBody =>
      'Relájate a tiempo, duerme mejor y despierta para el Fajr.';

  @override
  String get investFeaturePlannerTitle => 'Planificador de oración y progreso';

  @override
  String get investFeaturePlannerBody =>
      'Rachas, ideas y diarios que te mantienen constante.';

  @override
  String get investFeatureToolsTitle => 'Herramientas islámicas exclusivas';

  @override
  String get investFeatureToolsBody =>
      'Calendario hijri, duas, tasbih, 99 Nombres y más.';

  @override
  String get investFeatureThemesTitle => 'Temas premium y actualizaciones';

  @override
  String get investFeatureThemesBody =>
      'Temas hermosos más cada nueva función que lancemos.';

  @override
  String get investFeatureTajweedTitle => 'Domina el Tajweed';

  @override
  String get investFeatureTajweedBody =>
      'Mejora tu recitación con lecciones guiadas y comentarios en tiempo real.';

  @override
  String get socialProofPrefix => 'Únete a ';

  @override
  String get socialProofHighlight => '10,000+';

  @override
  String get socialProofSuffix => ' musulmanes que crecen con DeenFocus';

  @override
  String get mostPopular => 'Más Popular';

  @override
  String get monthlyLabel => 'Mensual';

  @override
  String get yearlyLabel => 'Anual';

  @override
  String get lifetimeLabel => 'Vida';

  @override
  String get featureNoAds => 'Elimina todos los anuncios';

  @override
  String get featureSupport => 'Apoyo prioritario';

  @override
  String get homeTitle => 'Casa Deenly';

  @override
  String get homeSalam => 'Assalamu Alaikum';

  @override
  String get homeDailyVerseFallback =>
      'De hecho, las dificultades conllevan la facilidad.';

  @override
  String get homeAppsLocked => 'Aplicaciones bloqueadas';

  @override
  String get homeAppsUnlocked => 'Aplicaciones desbloqueadas';

  @override
  String get homeTapToUnlock =>
      'Toca para desbloquear aplicaciones temporalmente';

  @override
  String get homeTapToRelock =>
      'Toca para volver a bloquear las aplicaciones ahora';

  @override
  String get homeRelock => 'Volver a bloquear';

  @override
  String get homeUnlock => 'Desbloquear';

  @override
  String get homePrayerModeActive => 'Modo de oración activo';

  @override
  String get homeActivatePrayerMode => 'Activar el modo de oración';

  @override
  String get homeAppsBlockedSubtitle =>
      'Las aplicaciones están bloqueadas. Toque para desactivar.';

  @override
  String get homeBlockDistractingApps =>
      'Bloquee las aplicaciones que distraigan durante el Salah.';

  @override
  String get homeQiblaDirection => 'Dirección qibla';

  @override
  String get homeLocationMissingForQibla =>
      'Habilite la ubicación para calcular la dirección Qibla.';

  @override
  String get homeQiblaSubtitleGuiding => 'Guiándote hacia la Qibla';

  @override
  String get homeToMakkah => 'a La Meca';

  @override
  String get homeFindMasjid => 'Encuentra una mezquita cerca de mí';

  @override
  String get quickActionsMasjidFinder => 'Buscador de mezquitas';

  @override
  String get homeSearchNearbyMosques =>
      'Encuentra mezquitas cercanas desde OpenStreetMap.';

  @override
  String get homePrayerStreak => 'Rayas de oración';

  @override
  String homePrayersInARow(int count) {
    return '$count prayers in a row';
  }

  @override
  String homeDayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get homeInsights => 'Resumen';

  @override
  String get homeOpenStreakDetails => 'Detalles de la racha abierta.';

  @override
  String get homeTodaysPrayers => 'Oraciones de hoy';

  @override
  String get homePrayerTimesUnavailable =>
      'Los horarios de oración no están disponibles en este momento.';

  @override
  String get homeNextPrayerIn => 'Próxima oración en';

  @override
  String get homeTapPrayerToMark =>
      'Toca una oración para marcarla como rezada, qada o perdida.';

  @override
  String get homeSetLocation => 'Establecer ubicación';

  @override
  String get homeEditPrayerSettings => 'Editar ajustes de la oración';

  @override
  String get homePrayerFajr => 'Fayr';

  @override
  String get homePrayerSunrise => 'Amanecer';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Magreb';

  @override
  String get homePrayerIsha => 'Isha';

  @override
  String get homeWeek => 'Semana';

  @override
  String get homeMonth => 'Mes';

  @override
  String get homeThisWeek => 'Lo más destacado de Deen esta semana';

  @override
  String get homeJummahMubarak => 'Jumma Mubarak';

  @override
  String get homeJummahReminder => 'No te olvides de la Sura Al-Kahf.';

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
  String get hijriMonthRamadan => 'Ramadán';

  @override
  String get hijriMonthShawwal => 'Shawwal';

  @override
  String get hijriMonthDhuAlQadah => 'Dhu al-Qi\'dah';

  @override
  String get hijriMonthDhuAlHijjah => 'Dhu al-Hijjah';

  @override
  String get calendarTitle => 'Calendario islámico';

  @override
  String get calendarBack => 'Atrás';

  @override
  String get calendarToday => 'Hoy';

  @override
  String get calendarTomorrow => 'Mañana';

  @override
  String calendarDaysAway(int days) {
    return '$days días';
  }

  @override
  String get calendarNoEventsThisWeek =>
      'No hay eventos islámicos esta semana.';

  @override
  String get calendarNoEventsBlessing =>
      'Que Allah bendiga tu semana con paz y bondad.';

  @override
  String get calendarNoUpcomingEvents =>
      'No se encontraron eventos islámicos próximos.';

  @override
  String get calendarUpcomingEvents => 'Próximos eventos islámicos';

  @override
  String get calendarUpcomingThisYear => 'Próximos este año';

  @override
  String get calendarThisWeekObservances => 'Esta semana';

  @override
  String get calendarLegendCycleDays => 'Días del ciclo (racha protegida)';

  @override
  String calendarMoonIlluminated(int percent) {
    return '$percent% iluminada';
  }

  @override
  String get calendarMoonNew => 'Luna nueva';

  @override
  String get calendarMoonWaxingCrescent => 'Luna creciente';

  @override
  String get calendarMoonFirstQuarter => 'Cuarto creciente';

  @override
  String get calendarMoonWaxingGibbous => 'Gibosa creciente';

  @override
  String get calendarMoonFull => 'Luna llena';

  @override
  String get calendarMoonWaningGibbous => 'Gibosa menguante';

  @override
  String get calendarMoonLastQuarter => 'Cuarto menguante';

  @override
  String get calendarMoonWaningCrescent => 'Luna menguante';

  @override
  String get calendarEventRamadanBegins => 'Comienza Ramadán';

  @override
  String get calendarEventRamadanBeginsDesc => 'Mes de ayuno';

  @override
  String get calendarEventLaylatAlQadr => 'Laylat al-Qadr';

  @override
  String get calendarEventLaylatAlQadrDesc => 'Noche del Decreto';

  @override
  String get calendarEventEidAlFitr => 'Eid al-Fitr';

  @override
  String get calendarEventEidAlFitrDesc => 'Fiesta de la ruptura del ayuno';

  @override
  String get calendarEventDayOfArafah => 'Día de Arafah';

  @override
  String get calendarEventDayOfArafahDesc => 'Día de la estación en Arafah';

  @override
  String get calendarEventEidAlAdha => 'Eid al-Adha';

  @override
  String get calendarEventEidAlAdhaDesc => 'Fiesta del sacrificio';

  @override
  String get calendarEventIslamicNewYear => 'Año Nuevo islámico';

  @override
  String get calendarEventIslamicNewYearDesc => '1 de Muharram';

  @override
  String get calendarEventMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarEventMawlidDesc => 'Nacimiento del Profeta';

  @override
  String get calendarEventAshura => 'Ashura';

  @override
  String get calendarEventAshuraDesc => '10 de Muharram';

  @override
  String get calendarEventJumuah => 'Jumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Oración congregacional del viernes';

  @override
  String get calendarEventWhiteDays => 'Días blancos';

  @override
  String get calendarEventWhiteDaysDesc => 'Días de ayuno recomendados';

  @override
  String get cycleModeActiveTitle => 'Tu ciclo es una pausa, no un stop.';

  @override
  String get cycleModeActiveSubtitle => 'Dhikr • Tasbih • Escuchar el Corán';

  @override
  String get cycleModeStreakProtected =>
      'La racha de oración está protegida durante tu ciclo';

  @override
  String get cycleModeCalendarHighlighted =>
      'Los días del calendario están resaltados en rosa';

  @override
  String cycleModeAutoEndInfo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Termina automáticamente en $days días',
      one: 'Termina automáticamente mañana',
      zero: 'Termina hoy',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeSettingsTitle => 'Modo ciclo';

  @override
  String get cycleModeStartDateLabel => 'Fecha de inicio';

  @override
  String get cycleModeLengthLabel => 'Duración del ciclo';

  @override
  String cycleModeLengthValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get cycleModePauseStreaksLabel => 'Proteger racha de oración';

  @override
  String get cycleModeExcludeFromStatisticsLabel =>
      'Excluir de las estadísticas';

  @override
  String get cycleModeSaveButton => 'Guardar';

  @override
  String get cycleModeEditButton => 'Editar';

  @override
  String get cycleModeChangeStartDateTitle => '¿Cambiar la fecha de inicio?';

  @override
  String get cycleModeChangeStartDateMessage =>
      'Cambiar la fecha de inicio recalculará la ventana activa del Modo ciclo. Los días fuera del nuevo rango pueden dejar de contarse como días de ciclo.';

  @override
  String get cycleModeChangeStartDateConfirm => 'Cambiar fecha de inicio';

  @override
  String prayerReminderTitle(String prayer) {
    return '¿Rezaste $prayer?';
  }

  @override
  String get prayerReminderSubtitle =>
      'Mantén tu racha registrando tu oración.';

  @override
  String get prayerReminderYesButton => 'Sí, Alhamdulillah';

  @override
  String get prayerReminderLaterButton => 'Lo marcaré más tarde';

  @override
  String get prayerNotificationSubtitleFajr =>
      '“En verdad, la recitación del alba es siempre presenciada.” — Corán 17:78';

  @override
  String get prayerNotificationSubtitleDhuhr =>
      '“Establece la oración al declinar el sol...” — Corán 17:78';

  @override
  String get prayerNotificationSubtitleAsr =>
      '“Custodiad estrictamente las oraciones, especialmente la oración intermedia.” — Corán 2:238';

  @override
  String get prayerNotificationSubtitleMaghrib =>
      '“Así pues, glorificad a Alá cuando lleguéis al atardecer...” — Corán 30:17';

  @override
  String get prayerNotificationSubtitleIsha =>
      '“Establece la oración -  hasta la oscuridad de la noche.” — Corán 17:78';

  @override
  String prayerNotificationTitle(String prayerName) {
    return 'Es hora de $prayerName';
  }

  @override
  String get homeTrialBannerTitle =>
      'Gratis por 7 días — sé un mejor musulmán ✨';

  @override
  String get homeTrialBannerSubtitle =>
      'Todas las funciones desbloqueadas. Empieza tu viaje hoy.';

  @override
  String get homeFocusModeTitle => 'Modo enfoque';

  @override
  String get homeFocusModeSubtitle =>
      'Bloquea apps que distraen durante la Salah';

  @override
  String get homeLivePrayerUpdatesTitle => 'Actualizaciones de oración en vivo';

  @override
  String get homeLivePrayerUpdatesBody =>
      'Ve tu oración actual y la siguiente en la pantalla de bloqueo y Dynamic Island.';

  @override
  String get homeLivePrayerUpdatesCta => 'Activar actualizaciones en vivo';

  @override
  String get homeWidgetsPromoTitle => 'Widgets';

  @override
  String get homeWidgetsPromoBody =>
      'Ve el versículo del día y los horarios de oración en tu pantalla de inicio.';

  @override
  String get homeWidgetsPromoCta => 'Añadir widget';

  @override
  String get focusModeShortSalah => 'Salah';

  @override
  String get focusModeShortNight => 'Noche';

  @override
  String get focusModeShortChild => 'Infantil';

  @override
  String get focusModeLabelSalah => 'Modo Salah';

  @override
  String get focusModeLabelNight => 'Modo noche';

  @override
  String get focusModeLabelChild => 'Modo infantil';

  @override
  String homeFocusModeNamesTwo(String first, String second) {
    return 'Los modos $first y $second están activados';
  }

  @override
  String homeFocusModeNamesThree(String first, String second, String third) {
    return 'Los modos $first, $second y $third están activados';
  }

  @override
  String get cycleModeTitle => 'Modo ciclo';

  @override
  String get cycleModeSubtitle =>
      'Para la menstruación — pausa oraciones, mantén tu racha';

  @override
  String get dailyChecklistTitle => 'Lista diaria';

  @override
  String get dailyChecklistSubtitle => 'Sigue tus metas espirituales diarias';

  @override
  String dailyChecklistProgress(int completed, int total) {
    return '$completed de $total completadas';
  }

  @override
  String get dailyChecklistSectionPrayer => 'Oración';

  @override
  String get dailyChecklistSectionQuranDhikr => 'Corán y Dhikr';

  @override
  String get dailyChecklistSectionGoodDeeds => 'Buenas obras';

  @override
  String get dailyChecklistSectionDistraction => 'Disciplina personal';

  @override
  String get dailyChecklistFajr => 'Fajr';

  @override
  String get dailyChecklistTahajjud => 'Tahajjud';

  @override
  String get dailyChecklistQuran => 'Corán';

  @override
  String get dailyChecklistMorningAdhkar => 'Adhkar de la mañana';

  @override
  String get dailyChecklistEveningAdhkar => 'Adhkar de la tarde';

  @override
  String get dailyChecklistDhikr => 'Dhikr';

  @override
  String get dailyChecklistCharity => 'Caridad';

  @override
  String get dailyChecklistSmileAtSomeone => 'Sonríe a alguien';

  @override
  String get dailyChecklistFamilyCall => 'Llamada familiar';

  @override
  String get dailyChecklistNoMusicToday => 'Sin música hoy';

  @override
  String get dailyChecklistNoSocialMediaBeforeIsha =>
      'Sin redes sociales antes de Isha';

  @override
  String get focusScoreTitle => 'Puntuación de enfoque de hoy';

  @override
  String get focusScorePrayer => 'Oración';

  @override
  String get focusScoreQuran => 'Corán';

  @override
  String get focusScoreDhikr => 'Dhikr';

  @override
  String get focusScoreDistraction => 'Control de distracción';

  @override
  String get insightsBack => 'Atrás';

  @override
  String get insightsTitle => 'Mis estadísticas';

  @override
  String get insightsSubtitle => 'Sigue tu progreso en el Deen';

  @override
  String get insightsPrayerRate => 'Tasa de oración';

  @override
  String get insightsDayStreak => 'Racha diaria';

  @override
  String get insightsBestStreak => 'Mejor racha';

  @override
  String get insightsWeekly => 'Semanal';

  @override
  String get insightsMonthly => 'Mensual';

  @override
  String get insightsPrayersCompleted => 'Oraciones completadas';

  @override
  String get insightsRestoreStreak => 'Restaurar mi racha — últimas 24 horas';

  @override
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  ) {
    return 'Oración $prayerPercent% · Corán $quranPercent% · Dhikr $dhikrPercent% · Distracción $distractionPercent%';
  }

  @override
  String get quickActionsCalendar => 'Calendario';

  @override
  String get quickActionsCalendarSubtitle => 'Ver fechas islámicas';

  @override
  String get quickActionsSupportUs => 'Apóyanos';

  @override
  String get quickActionsSupportUsSubtitle => 'Ayúdanos a crecer';

  @override
  String get quickActionsSupportUsMessage =>
      '¡Gracias por considerar apoyar DeenFocus! Las funciones de apoyo llegarán pronto.';

  @override
  String get supportUsTitle => 'Apoya DeenFocus';

  @override
  String get supportUsHeroTitle => 'Apoya DeenFocus';

  @override
  String get supportUsHeroBody =>
      'Tu apoyo nos ayuda a mejorar DeenFocus y contribuir a causas significativas.';

  @override
  String get supportUsFundSection => 'Tu apoyo ayuda a financiar';

  @override
  String get supportUsFundSectionSubtitle =>
      'Usamos tu apoyo para crear más bien.';

  @override
  String get supportUsFundFeature1Title => 'Nuevas funciones';

  @override
  String get supportUsFundFeature1Subtitle =>
      'Crear y mejorar funciones significativas de DeenFocus.';

  @override
  String get supportUsFundFeature2Title => 'Corrección de errores';

  @override
  String get supportUsFundFeature2Subtitle =>
      'Mantener la app estable, rápida y fiable para todos.';

  @override
  String get supportUsFundFeature3Title => 'Personas necesitadas';

  @override
  String get supportUsFundFeature3Subtitle =>
      'Apoyar esfuerzos que ayudan a quienes enfrentan dificultades.';

  @override
  String get supportUsFundFeature4Title => 'Caridad y comunidad';

  @override
  String get supportUsFundFeature4Subtitle =>
      'Contribuir a iniciativas benéficas y apoyo comunitario.';

  @override
  String get supportUsNeedHelp => '¿NECESITAS AYUDA?';

  @override
  String get supportUsWhatsApp => 'Chatear por WhatsApp';

  @override
  String get supportUsEmailSupport => 'Soporte por correo';

  @override
  String get supportUsChooseAmountTitle => 'Elige un monto de apoyo';

  @override
  String get supportUsChooseAmountSubtitle => 'Puedes apoyar varias veces.';

  @override
  String get supportUsSecurePaymentNote =>
      'Pago único seguro · Sin cargos recurrentes';

  @override
  String get supportUsTrustBanner =>
      'Seguro • Apoyo único • Puedes apoyar varias veces';

  @override
  String get supportUsImpactSectionTitle =>
      'Dónde tu apoyo marca la diferencia';

  @override
  String get supportUsImpactSectionSubtitle =>
      'Cada contribución tiene un impacto duradero.';

  @override
  String get supportUsImpactPalestine => 'Apoyo y conciencia por Palestina';

  @override
  String get supportUsImpactNeedy => 'Ayudar a quienes lo necesitan';

  @override
  String get supportUsImpactCommunity => 'Caridad y apoyo comunitario';

  @override
  String get supportUsImpactExperience => 'Mejor experiencia DeenFocus';

  @override
  String get supportUsImpactFeatures => 'Nuevas funciones y mejoras';

  @override
  String get supportUsImpactQuran => 'Corán y aprendizaje islámico';

  @override
  String get supportUsImpactServers => 'Servidores y fiabilidad de la app';

  @override
  String supportUsCta(String amount) {
    return 'Apoyar DeenFocus con $amount';
  }

  @override
  String get supportUsWhatsAppPrefill =>
      'Assalamu alaikum, necesito ayuda con DeenFocus.';

  @override
  String get supportUsWhatsAppQuestionHowTo => '¿Cómo uso DeenFocus?';

  @override
  String get supportUsWhatsAppQuestionFeature =>
      'Necesito ayuda con una función';

  @override
  String get supportUsWhatsAppQuestionSubscription =>
      'Tengo un problema con mi suscripción';

  @override
  String get supportUsEmailSubject => 'Solicitud de soporte DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'No se pudo abrir esa app en este dispositivo.';

  @override
  String get supportUsLaunchFailed => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get supportUsThankYouTitle => 'JazakAllah khair';

  @override
  String get supportUsThankYouBody =>
      'Gracias por apoyar DeenFocus. Puedes apoyar de nuevo cuando quieras.';

  @override
  String get supportUsPurchasePending =>
      'Tu apoyo está pendiente. Lo confirmaremos cuando Apple complete la compra.';

  @override
  String get supportUsPurchaseFailed =>
      'No pudimos completar tu pago de apoyo. Inténtalo de nuevo.';

  @override
  String get supportUsProductUnavailable =>
      'Este monto de apoyo no está disponible ahora. Inténtalo más tarde.';

  @override
  String get homeAiChatDescription =>
      'Pregunte cualquier cosa sobre los tiempos de oración, el Corán y la orientación islámica.';

  @override
  String get homeDay => 'Día';

  @override
  String get homeDays => 'Días';

  @override
  String get homeNoEventsFoundForDay =>
      'No se encontraron eventos para este día.';

  @override
  String homeMarkPrayerAs(String prayerName) {
    return '$prayerName — marcar como';
  }

  @override
  String get homeMarkPrayerPrayedOnTime => 'Rezada a tiempo';

  @override
  String get homeMarkPrayerQada => 'Qada (recuperada)';

  @override
  String get homeMarkPrayerMissed => 'Omitida';

  @override
  String homePrayerSettingsTitle(String prayerName) {
    return 'Ajustes de $prayerName';
  }

  @override
  String get homePrayerSettingsPrayerTime => 'Hora de la oración';

  @override
  String get homePrayerSettingsNotification => 'Notificación';

  @override
  String get homePrayerSettingsAboutSubtitle => 'Virtudes, normas y más';

  @override
  String homePrayerSettingsInfoBanner(String prayerName) {
    return 'Estos ajustes son solo para $prayerName. Puedes definir preferencias distintas para cada oración.';
  }

  @override
  String homeEditPrayerTimeTitle(String prayerName) {
    return 'Editar hora de $prayerName';
  }

  @override
  String get homeEditPrayerTimeCurrent => 'Hora actual';

  @override
  String get homeEditPrayerTimeSelectNew => 'Seleccionar nueva hora';

  @override
  String homeEditPrayerTimeNote(String prayerName) {
    return 'Esta hora personalizada solo se aplica a $prayerName. Ajústala si tu mezquita local o el cálculo difieren.';
  }

  @override
  String get homeEditPrayerTimeSave => 'Guardar hora';

  @override
  String get homeEditPrayerTimeReset => 'Restablecer a la hora calculada';

  @override
  String homeNotificationForPrayer(String prayerName) {
    return 'Notificación de $prayerName';
  }

  @override
  String get homeNotificationSoundLabel => 'Sonido de notificación';

  @override
  String get homeNotificationSoundFullAdhan => 'Adhan completo';

  @override
  String get homeNotificationSoundFullAdhanSubtitle =>
      'Reproducir el Adhan completo';

  @override
  String get homeNotificationSoundBeep => 'Pitido';

  @override
  String get homeNotificationSoundBeepSubtitle =>
      'Un tono corto de notificación';

  @override
  String get homeNotificationSoundMute => 'Silencio';

  @override
  String get homeNotificationSoundMuteSubtitle => 'Sin sonido';

  @override
  String get homeNotificationEnableLabel => 'Activar notificación';

  @override
  String homeNotificationEnableSubtitle(String prayerName) {
    return 'Recibir aviso a la hora de $prayerName';
  }

  @override
  String homeAboutPrayerTitle(String prayerName) {
    return 'Acerca de $prayerName';
  }

  @override
  String get homeAboutPrayerTimeLabel => 'Hora';

  @override
  String get homeAboutPrayerRakatLabel => 'Rakats';

  @override
  String get homeAboutPrayerVirtuesLabel => 'Virtudes';

  @override
  String get homeAboutPrayerReferenceLabel => 'Referencia';

  @override
  String get homeAboutFajrTiming =>
      'Comienza con el verdadero amanecer (Fajr Sadiq) y termina al salir el sol.';

  @override
  String get homeAboutFajrRakat => '2 Sunnah + 2 Fard';

  @override
  String get homeAboutFajrVirtue =>
      'Quien reza el Fajr está bajo la protección de Allah.';

  @override
  String get homeAboutFajrReference =>
      '«Las dos rakʿāt del Fajr son mejores que el mundo y todo lo que contiene.» (Sahih Muslim)';

  @override
  String get homeAboutDhuhrTiming =>
      'Comienza cuando el sol pasa su cenit y dura hasta que empieza el Asr.';

  @override
  String get homeAboutDhuhrRakat => '4 Sunnah + 4 Fard + 2 Sunnah';

  @override
  String get homeAboutDhuhrVirtue =>
      'Parte de las 12 rakʿāt voluntarias diarias por las que Allah construye una casa en el Paraíso.';

  @override
  String get homeAboutDhuhrReference =>
      '«Quien rece doce rakʿāt durante un día y una noche tendrá una casa construida para él en el Paraíso.» (Sahih Muslim)';

  @override
  String get homeAboutAsrTiming =>
      'Comienza cuando la sombra de un objeto iguala su longitud y dura hasta la puesta del sol.';

  @override
  String get homeAboutAsrRakat => '4 Fard';

  @override
  String get homeAboutAsrVirtue =>
      'Custodiar esta oración se destaca con una recompensa y una advertencia especiales.';

  @override
  String get homeAboutAsrReference =>
      '«Quien pierde la oración del Asr es como si hubiera perdido a su familia y su riqueza.» (Sahih al-Bukhari)';

  @override
  String get homeAboutMaghribTiming =>
      'Comienza justo después de la puesta del sol y dura hasta que desaparece el crepúsculo rojo.';

  @override
  String get homeAboutMaghribRakat => '3 Fard + 2 Sunnah';

  @override
  String get homeAboutMaghribVirtue =>
      'Un momento en el que las súplicas se animan especialmente.';

  @override
  String get homeAboutMaghribReference =>
      '«Hay dos ocasiones en las que se alegra quien ayuna… cuando rompe el ayuno.» (Sahih al-Bukhari, sobre el iftar del Maghrib)';

  @override
  String get homeAboutIshaTiming =>
      'Comienza cuando el crepúsculo desaparece por completo y dura hasta la medianoche (o hasta el Fajr, según algunas opiniones).';

  @override
  String get homeAboutIshaRakat => '4 Fard + 2 Sunnah + Witr';

  @override
  String get homeAboutIshaVirtue =>
      'Rezar Isha en congregación equivale a pasar la mitad de la noche en oración.';

  @override
  String get homeAboutIshaReference =>
      '«Quien rece Isha en congregación es como si hubiera orado la mitad de la noche.» (Sahih Muslim)';

  @override
  String get backToOnboarding => 'Volver a Incorporación';

  @override
  String get settings => 'Ajustes';

  @override
  String get appLanguage => 'Idioma de la aplicación';

  @override
  String get tabHome => 'Hogar';

  @override
  String get tabFocus => 'Enfocar';

  @override
  String get tabTasbih => 'Tasbih';

  @override
  String get tabQuran => 'Aprender';

  @override
  String get tabLearn => 'Aprender';

  @override
  String get quranLoadFailed => 'No se pudieron cargar los datos del Corán';

  @override
  String get quranTabSubtitle => 'Leer y explorar el Sagrado Corán';

  @override
  String get quranTabSubtitleExtended =>
      'Read, listen and perfect your tajweed';

  @override
  String get quranSearchHint => 'Buscar sura...';

  @override
  String get quranSearchHintExtended => 'Busca sura o significado...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranNoSurahsFound => 'No se encontraron suras';

  @override
  String get quranVersesLabel => 'versos';

  @override
  String quranSurahHeaderSubtitle(String name, int count) {
    return '$name • $count versos';
  }

  @override
  String get quranTextOptions => 'Opciones de texto';

  @override
  String get quranEnglishAndArabic => 'inglés y árabe';

  @override
  String get quranArabicOnly => 'solo árabe';

  @override
  String get quranIncreaseFont => 'aumentar fuente';

  @override
  String get quranDecreaseFont => 'Disminuir fuente';

  @override
  String get quranPause => 'Pausa';

  @override
  String get quranPlaySurah => 'Reproducir sura';

  @override
  String get quranAudioNoInternet =>
      'Sin conexión a internet. El audio requiere internet.';

  @override
  String get quranAudioTimeout =>
      'Se agotó el tiempo de carga del audio. Comprueba tu conexión.';

  @override
  String get quranSurahLabel => 'Sura';

  @override
  String get quranModeSurah => 'Sura';

  @override
  String get quranModeJuz => 'Yuz';

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
  String get quranContinueReading => 'Seguir leyendo';

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
    return '$percent% del yuz $juz';
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
  String get quranQuickTajweed => 'Ejercicio de tayyid';

  @override
  String get quranQuickTajweedSub => 'Recitar y puntuar';

  @override
  String get quranLastListened => 'Última escucha';

  @override
  String get quranNoneYet => 'Aún no hay';

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
  String get readingSettingsTajweedPractice => 'Tayyid del Corán con IA';

  @override
  String get readingSettingsTajweedPracticeSubtitle =>
      'Recita aleyas y recibe comentarios';

  @override
  String get readingSettingsTajweedSeeHowItWorks => 'Mira cómo funciona';

  @override
  String get quranSeeHowAiQuranTajweedWorks => 'see how AI Quran Tajweed works';

  @override
  String get readingSettingsTajweedDeleteModel => 'Eliminar modelo de IA';

  @override
  String get readingSettingsTajweedDeleteConfirmTitle =>
      '¿Eliminar el modelo de IA de tajweed del Corán?';

  @override
  String get readingSettingsTajweedDeleteConfirmBody =>
      'No podrás practicar tajweed hasta que vuelvas a descargar el modelo de IA. Esto también libera espacio en tu dispositivo.';

  @override
  String get readingSettingsTajweedDeleteConfirmAction => 'Eliminar';

  @override
  String get readingSettingsTajweedDeleted =>
      'Modelo de tajweed de IA eliminado';

  @override
  String get readingSettingsTajweedDeleteFailed =>
      'No se pudo eliminar el modelo de tajweed de IA';

  @override
  String get readingSettingsTajweedFreePreviewTranslation =>
      'En el nombre de Alá, el Compasivo, el Misericordioso.';

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
  String get readingSettingsTitle => 'Ajustes de lectura';

  @override
  String get readingSettingsArabicFontSize => 'Tamaño de fuente árabe';

  @override
  String get readingSettingsTranslationFontSize =>
      'Tamaño de fuente de traducción';

  @override
  String get readingSettingsLineSpacing => 'Interlineado';

  @override
  String get readingSettingsDefaultMode => 'Modo de lectura predeterminado';

  @override
  String get readingSettingsRememberPosition => 'Recordar la última posición';

  @override
  String get readingSettingsScript => 'Caligrafía árabe';

  @override
  String get readingSettingsScriptUthmani => 'Uthmani (Hafs)';

  @override
  String get readingSettingsScriptIndopak => 'IndoPak (Hafs)';

  @override
  String get readingSettingsArabicFont => 'Fuente árabe';

  @override
  String get readingSettingsFontUthmanic => 'Uthmanic Hafs';

  @override
  String get readingSettingsFontNooreHuda => 'Noore Huda';

  @override
  String get readingSettingsFontSystem => 'Sistema (nativa)';

  @override
  String get readingSettingsShowTranslation => 'Mostrar traducción';

  @override
  String get readingSettingsShowTransliteration => 'Mostrar transliteración';

  @override
  String get readingSettingsTranslationSection => 'Traducción';

  @override
  String get readingSettingsTranslationLabel => 'Traducción';

  @override
  String get readingSettingsTranslationCurrent => 'Actual';

  @override
  String get readingSettingsInstalledTranslations => 'Instaladas';

  @override
  String get readingSettingsAvailableTranslations => 'Disponibles';

  @override
  String get readingSettingsTranslationInstalled => 'Instalada';

  @override
  String get readingSettingsTranslationSelected => 'Seleccionada';

  @override
  String get readingSettingsTranslationDownload => 'Descargar';

  @override
  String get readingSettingsTranslationInstalling => 'Instalando…';

  @override
  String get readingSettingsTranslationDownloading => 'Descargando…';

  @override
  String get readingSettingsLayoutTheme => 'Diseño del Corán';

  @override
  String get readingSettingsLayoutClassic => 'Mushaf';

  @override
  String get readingSettingsLayoutSimple => 'Simple';

  @override
  String get readingSettingsLayoutColor => 'Corán en color';

  @override
  String get readingSettingsColorTheme => 'Tema de lectura';

  @override
  String get readingSettingsColorThemeParchment => 'Pergamino';

  @override
  String get readingSettingsColorThemeEmerald => 'Esmeralda';

  @override
  String get readingSettingsColorThemeMidnight => 'Medianoche';

  @override
  String get readingSettingsPreview => 'Vista previa';

  @override
  String get readingSettingsResetHistoryTitle => 'Restablecer datos de lectura';

  @override
  String get readingSettingsResetHistorySubtitle =>
      'Borra continuar leyendo, progreso de páginas, marcadores y acciones rápidas';

  @override
  String get readingSettingsResetHistoryConfirmTitle =>
      '¿Restablecer los datos de lectura?';

  @override
  String get readingSettingsResetHistoryConfirmBody =>
      'Esto elimina continuar leyendo, el progreso de páginas, marcadores, lo último escuchado y los atajos de tayyid. Se conservan los ajustes de visualización y traducción.';

  @override
  String get readingSettingsResetHistoryDone => 'Datos de lectura borrados';

  @override
  String get readingSettingsResetHistoryButton => 'Restablecer';

  @override
  String readingSettingsTranslationDownloadFailed(String name) {
    return 'No se pudo descargar $name. Inténtalo de nuevo cuando tengas conexión.';
  }

  @override
  String readingSettingsTranslationSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get tajweedListenToAyah => 'Listen to ayah';

  @override
  String get tajweedStartReciting => 'Empieza a recitar';

  @override
  String get tajweedTapToStop => 'Tap to stop';

  @override
  String get tajweedListeningHint => 'Listening... recite clearly';

  @override
  String get tajweedStopAnalyse => 'Stop & analyse';

  @override
  String get tajweedWordAccuracyLabel => 'PRECISIÓN DE PALABRAS';

  @override
  String get tajweedWordReviewLabel => 'REVISIÓN DE PALABRAS';

  @override
  String get tajweedResultEncouragement =>
      'Beautiful effort — keep practicing your tajweed.';

  @override
  String get quranReciteCheckTajweed => 'Recitar y comprobar tayyid';

  @override
  String get quranTajweedLegendGhunnah => 'Ghunnah';

  @override
  String get quranTajweedLegendGhunnahDesc => 'Nasal, 2 tiempos';

  @override
  String get quranTajweedLegendQalqalah => 'Qalqalah';

  @override
  String get quranTajweedLegendQalqalahDesc => 'Rebote de eco';

  @override
  String get quranTajweedLegendMadd => 'Madd';

  @override
  String get quranTajweedLegendMaddDesc => 'Prolonga la vocal';

  @override
  String get quranTajweedLegendIdgham => 'Idgham';

  @override
  String get quranTajweedLegendIdghamDesc => 'Fusiona letras';

  @override
  String get quranTajweedLegendIkhfa => 'Ikhfa';

  @override
  String get quranTajweedLegendIkhfaDesc => 'Oculta la nun';

  @override
  String get save => 'Ahorrar';

  @override
  String get tasbihBack => 'Atrás';

  @override
  String get tasbihTabTitle => 'Tasbih';

  @override
  String get tasbihChooseOrAddSubtitle =>
      'Selecciona un dhikr o crea el tuyo propio';

  @override
  String get tasbihAddCustomTitle => 'Añadir dhikr';

  @override
  String get tasbihEditCustomTitle => 'Editar dhikr personalizado';

  @override
  String get tasbihArabicOrDhikrHint => 'Texto árabe o cualquier dhikr.';

  @override
  String get tasbihTransliterationOptionalHint => 'Transliteración (opcional)';

  @override
  String get tasbihMeaningOptionalHint => 'Significado (opcional)';

  @override
  String get tasbihNoTransliteration => 'Sin transliteración';

  @override
  String get tasbihTotalCount => 'Recuento total';

  @override
  String get tasbihGrandTotalLabel => 'Total acumulado';

  @override
  String get tasbihTapMe => 'Tocame';

  @override
  String get tasbihReset => 'Reiniciar';

  @override
  String get tasbihRestart => 'Reanudar';

  @override
  String get tasbihCurrentCount => 'Conteo actual';

  @override
  String get tasbihResetTotal => 'Borrar historial';

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
  String get focusModeActivated => 'Modo de enfoque activado';

  @override
  String get focusSetUpHomeCardTitle => 'Configura el modo Enfoque';

  @override
  String get focusTabSubtitle => 'Manténgase enfocado cuando más importa';

  @override
  String get focusChooseAppsEnableMode => 'Elige apps y activa el modo Enfoque';

  @override
  String get focusNotifAppsLockedTitle => 'Apps bloqueadas';

  @override
  String get focusNotifAppsUnlockedTitle => 'Apps desbloqueadas';

  @override
  String get focusNotifNightModeTitle => 'Modo nocturno';

  @override
  String get focusNotifGoodMorningTitle => '¡Buenos días!';

  @override
  String get focusNotifAppsNowAvailableBody =>
      'Las aplicaciones ya están disponibles.';

  @override
  String get focusNotifSalahLockedBody =>
      'Las aplicaciones están bloqueadas durante Salah.';

  @override
  String get focusNotifSalahCompleteTitle => 'Salah completada';

  @override
  String get focusNotifSalahCompleteBody =>
      'Las apps ya están desbloqueadas. Que tu oración sea aceptada.';

  @override
  String focusNotifSalahPrayerTimeTitle(String prayerName) {
    return 'Hora de $prayerName';
  }

  @override
  String focusNotifSalahPrayerMomentBody(String prayerName) {
    return 'Tómate un momento para la oración de $prayerName.';
  }

  @override
  String get focusNotifNightLockedBody =>
      'El modo nocturno está activo. Deja que tu mente y cuerpo descansen.';

  @override
  String get focusNotifGenericLockedBody =>
      'Las aplicaciones seleccionadas están bloqueadas.';

  @override
  String get focusNotifMorningUnlockBody =>
      'Las aplicaciones no están disponibles.';

  @override
  String get widgetDailyVerseTitle => 'Verso del día';

  @override
  String get widgetOpenAppTimelineHint =>
      'Abre Deen Focus para preparar el verso del día y los datos del widget de oración.';

  @override
  String get widgetSetLocationForPrayers =>
      'Establece tu ubicación en Deen Focus para cargar oraciones y el verso del día.';

  @override
  String get widgetPrayerProgressTitle => 'Tu progreso de oración';

  @override
  String widgetPrayerProgressCount(int completed, int total) {
    return '$completed de $total';
  }

  @override
  String get widgetPrayersCompletedSubtitle => 'oraciones completadas.';

  @override
  String widgetPrayersLeftToday(int count) {
    return 'Sigue así — quedan $count oraciones hoy';
  }

  @override
  String get widgetAllPrayersDoneToday =>
      'Alhamdulillah — todas las oraciones de hoy completas';

  @override
  String get focusChildModeActive => 'Modo infantil activo';

  @override
  String get focusSalahAndNightModeActive => 'Modo Salah y nocturno activos';

  @override
  String get focusSalahModeActive => 'Modo Salah activo';

  @override
  String get focusNightModeActive => 'Modo nocturno activo';

  @override
  String get focusAppsToBlockTitle => 'Aplicaciones para bloquear';

  @override
  String get focusAppliesAllModes => 'Se aplica a todos los modos de enfoque';

  @override
  String get focusScreenTimeRequiredSelectApps =>
      'Se requiere acceso a Tiempo en pantalla para ver y seleccionar aplicaciones.';

  @override
  String get focusAcceptAccessibilityDisclosure =>
      'Acepta la divulgación de accesibilidad para continuar.';

  @override
  String get focusSelectAppsToBlock => 'Seleccionar aplicaciones para bloquear';

  @override
  String get focusLoading => 'Cargando...';

  @override
  String get focusOpen => 'Abrir';

  @override
  String get focusHide => 'Ocultar';

  @override
  String get focusLoad => 'Cargar';

  @override
  String get focusShow => 'Mostrar';

  @override
  String get focusSalahFocusModeTitle => 'Modo de enfoque Salah';

  @override
  String get focusBlockAppsDuringPrayer =>
      'Bloquear aplicaciones durante la oración';

  @override
  String get focusNightDisciplineTitle => 'Disciplina nocturna';

  @override
  String get focusSleepLabel => 'Dormir';

  @override
  String get focusWakeLabel => 'Despertar';

  @override
  String get focusBlockAppsImmediately => 'Bloquear aplicaciones de inmediato';

  @override
  String get focusEnableAndroidAppBlocking =>
      'Activar bloqueo de aplicaciones en Android';

  @override
  String get focusEnableAndroidAppBlockingMessage =>
      'Para bloquear otras aplicaciones en Android, Deenly necesita el permiso de accesibilidad activado. Te abriremos la pantalla de ajustes correcta.';

  @override
  String get focusAccessibilityDisclosureTitle =>
      'Divulgación del permiso de accesibilidad';

  @override
  String get focusAccessibilityDisclosureMessage =>
      'Deenly usa Accesibilidad de Android para aplicar el bloqueo de aplicaciones del modo Enfoque.\n\nPor qué lo necesitamos: para detectar cuando abres una aplicación que seleccionaste para bloquear.\n\nCómo lo usamos: solo para identificar la app en primer plano y mostrar la pantalla de bloqueo de Enfoque para las aplicaciones seleccionadas. No lo usamos para leer texto escrito ni contenido personal.';

  @override
  String get focusNotNow => 'Ahora no';

  @override
  String get focusIUnderstand => 'Entiendo';

  @override
  String get focusDone => 'Listo';

  @override
  String get focusNightDisciplineCardSubtitle =>
      'Desarrolla mejores hábitos nocturnos';

  @override
  String get focusPrayerBlockingDescription =>
      'Las aplicaciones se bloquearán durante la oración y se desbloquearán automáticamente después de 15 minutos, o puedes desbloquearlas en cualquier momento desde la pantalla de inicio.';

  @override
  String get focusPrayerBlockingDescriptionIos =>
      'Las aplicaciones se bloquearán durante la oración, o puedes desbloquearlas en cualquier momento desde la pantalla de inicio.';

  @override
  String get focusNightBlockingDescription =>
      'Las aplicaciones se bloquearán durante tu ciclo de sueño y se desbloquearán automáticamente, o puedes desbloquearlas en cualquier momento desde la pantalla de inicio.';

  @override
  String get focusChildBlockingDescription =>
      'Las aplicaciones se bloquean instantáneamente en el modo infantil. Desbloquéalos usando el interruptor o desde la pantalla de inicio.';

  @override
  String get settingsEditUsername => 'Editar nombre de usuario';

  @override
  String get settingsEnterYourName => 'Ingresa tu nombre';

  @override
  String get settingsPremiumTitle => 'Deen Focus Premium';

  @override
  String get settingsPremiumSubtitle => 'Desbloquea todas las funciones';

  @override
  String get settingsManageSubscriptionTitle => 'Gestionar suscripción';

  @override
  String get settingsManageSubscriptionSubtitle =>
      'Ver plan o actualizar facturación';

  @override
  String get settingsUsernameLabel => 'Nombre de usuario';

  @override
  String get settingsLocationLabel => 'Ubicación';

  @override
  String get settingsDarkModeLabel => 'Modo oscuro';

  @override
  String get settingsAboutTitle => 'Acerca de Deen Focus';

  @override
  String get settingsRateDeenFocus => 'Valora DeenFocus ⭐';

  @override
  String get settingsContactUsTitle => 'Contáctenos';

  @override
  String get settingsSavingLocation => 'Guardando...';

  @override
  String get settingsSaveLocation => 'Guardar ubicación';

  @override
  String get settingsAboutTagline => 'Enfoque. Disciplina. Constancia.';

  @override
  String get settingsAboutDescription =>
      'Deen Focus te ayuda a mantenerte conectado con tu fe mientras gestionas las distracciones diarias en un mundo moderno.';

  @override
  String get settingsAboutFeature1 => 'Horarios de oración con recordatorios';

  @override
  String get settingsAboutFeature2 =>
      'Dirección de la Qibla en cualquier momento';

  @override
  String get settingsAboutFeature3 => 'Corán y Tasbih para el dhikr diario';

  @override
  String get settingsAboutFeature4 => 'Mezquitas cercanas';

  @override
  String get settingsAboutFeature5 =>
      'Modos de enfoque inteligentes para Salah, sueño y tiempo familiar';

  @override
  String get settingsAboutFocusDescription =>
      'Los modos de enfoque inteligentes te ayudan a bloquear distracciones durante Salah, el sueño y momentos importantes, para que puedas estar presente y disciplinado.';

  @override
  String get settingsAboutFooter =>
      'Mantén la constancia. Mantén la atención plena. Mantente conectado a tu Deen.';

  @override
  String get settingsAboutOffersHeading => 'Lo que ofrece Deen Focus';

  @override
  String get settingsAboutNewBadge => 'Nuevo';

  @override
  String get settingsAboutFooterCard =>
      'Herramientas inteligentes para ayudarte a mantener la atención plena, la constancia y la conexión con tu Deen — cada día.';

  @override
  String get settingsAboutOfferPrayerTimesTitle =>
      'Horarios de oración precisos';

  @override
  String get settingsAboutOfferPrayerTimesSubtitle =>
      'Alertas oportunas de oración y widgets hermosos para mantenerte al día.';

  @override
  String get settingsAboutOfferPrayerStreaksTitle => 'Rachas de oración';

  @override
  String get settingsAboutOfferPrayerStreaksSubtitle =>
      'Construye constancia y crece en tu Deen con seguimiento de rachas diarias y totales.';

  @override
  String get settingsAboutOfferCycleModeTitle => 'Modo ciclo';

  @override
  String get settingsAboutOfferCycleModeSubtitle =>
      'Para la menstruación — pausa las oraciones, conserva tu racha y continúa tu camino.';

  @override
  String get settingsAboutOfferQuranTajweedTitle => 'Tajweed del Corán';

  @override
  String get settingsAboutOfferQuranTajweedSubtitle =>
      'Lee, escucha y practica el tajweed con nuestro feedback en tiempo real impulsado por IA.';

  @override
  String get settingsAboutOfferLiveActivitiesTitle => 'Live Activities';

  @override
  String get settingsAboutOfferLiveActivitiesSubtitle =>
      'Mantente al día con oraciones en curso y sesiones de enfoque desde la pantalla de bloqueo.';

  @override
  String get settingsAboutOfferQiblaTitle => 'Qibla y buscador de mezquitas';

  @override
  String get settingsAboutOfferQiblaSubtitle =>
      'Encuentra la dirección de la Qibla en cualquier momento y descubre mezquitas cercanas.';

  @override
  String get settingsAboutOfferFocusModesTitle => 'Modos de enfoque';

  @override
  String get settingsAboutOfferFocusModesSubtitle =>
      'Bloquea apps distractoras durante Salah, sueño, estudio o tiempo en familia.';

  @override
  String get settingsAboutOfferTasbihTitle => 'Tasbih y dhikr';

  @override
  String get settingsAboutOfferTasbihSubtitle =>
      'Tasbih digital para ayudarte a recordar a Allah durante todo el día.';

  @override
  String get settingsAboutOfferCalendarTitle => 'Calendario islámico';

  @override
  String get settingsAboutOfferCalendarSubtitle =>
      'Calendario hijri con fechas islámicas importantes y recordatorios.';

  @override
  String get settingsAboutGridNamesTitle => '99 Nombres de Alá';

  @override
  String get settingsAboutGridNamesSubtitle =>
      'Aprende y reflexiona sobre Asma ul-Husna.';

  @override
  String get settingsAboutGridDuasTitle => 'Duas y adhkar';

  @override
  String get settingsAboutGridDuasSubtitle =>
      'Duas de la mañana, la tarde y diarias.';

  @override
  String get settingsAboutGridPrayerTitle => 'Oración y métodos';

  @override
  String get settingsAboutGridPrayerSubtitle =>
      'Aprende Salah, Wudu, Hajj y más.';

  @override
  String get settingsAboutGridFiqhTitle => 'Fiqh y tradiciones';

  @override
  String get settingsAboutGridFiqhSubtitle =>
      'Explora conocimiento islámico auténtico.';

  @override
  String get settingsEnableSystemNotifications =>
      'Activa las notificaciones del sistema para habilitar esto.';

  @override
  String get appDemoTitle => 'Demostración de la app';

  @override
  String get appDemoLoadFailed => 'No se pudo cargar el video de demostración.';

  @override
  String get appDemoRestartHint =>
      'El video requiere reiniciar por completo la app (el hot restart puede romper la reproducción).';

  @override
  String get appDemoPreviewLoadFailed => 'No se pudo cargar la demostración.';

  @override
  String get appDemoTryAgain => 'Intentar de nuevo';

  @override
  String get appDemoWatchLabel => 'Ver demo';

  @override
  String get homeAiChatTitle => 'IA de Deen Focus';

  @override
  String get homeAiAskQuestionHint => 'Haz una pregunta...';

  @override
  String get homeAiSend => 'Enviar';

  @override
  String get homeAiErrorPrefix =>
      'Lo siento, tuve un problema al conectarme con la IA de Deen Focus.';

  @override
  String get homeAiEmptyTitle => 'Pregunta cualquier cosa sobre el Islam';

  @override
  String get homeAiEmptySubtitle =>
      'Horarios de oración, Corán, Hadiz, eventos islámicos y guía espiritual';

  @override
  String get onboardingTypeCityName => 'Escribe el nombre de tu ciudad..';

  @override
  String get onboardingNoLocationsFound => 'No se encontraron ubicaciones';

  @override
  String get onboardingTryAnotherCityName =>
      'Prueba con otro nombre de ciudad.';

  @override
  String get qiblaCompassUnavailable =>
      'Brújula no disponible en este dispositivo';

  @override
  String get qiblaFacing => '✓ Orientado a la Qibla';

  @override
  String get qiblaTurnToFind => 'Gira para encontrar la Qibla';

  @override
  String get qiblaDistanceToMakkah => 'Distancia a La Meca';

  @override
  String get qiblaFromNorth => 'desde el norte';

  @override
  String get qiblaNorthShort => 'norte';

  @override
  String get qiblaSouthShort => 'S';

  @override
  String get qiblaEastShort => 'mi';

  @override
  String get qiblaWestShort => 'O';

  @override
  String get nearbyMosquesTitle => 'Mezquitas cercanas encontradas';

  @override
  String get nearbyMosquesTryAgain => 'Intentar de nuevo';

  @override
  String get nearbyMosquesOpenGoogle => 'Abrir en Google Maps';

  @override
  String get nearbyMosquesOpenApple => 'Abrir en Apple Maps';

  @override
  String get nearbyMosquesNoMosquesFoundWithin =>
      'No se encontraron mezquitas dentro de';

  @override
  String nearbyMosquesSearchRadius(int radiusKm) {
    return 'Radio de búsqueda: $radiusKm km';
  }

  @override
  String get nearbyMosquesMapPreviewUnavailable =>
      'La vista previa del mapa no está disponible en este momento.';

  @override
  String get nearbyMosquesWaitingForLocation => 'Esperando tu ubicación.';

  @override
  String get nearbyMosquesFetchingLocation => 'Obteniendo tu ubicación…';

  @override
  String get nearbyMosquesCurrentLocationLabel => 'Ubicación actual';

  @override
  String get nearbyMosquesAppearAfterLoad =>
      'Las mezquitas cercanas aparecerán aquí cuando se carguen los resultados.';

  @override
  String nearbyMosquesNoneWithinRadius(int radiusKm) {
    return 'No se encontraron mezquitas en $radiusKm km';
  }

  @override
  String get nearbyMosquesLocationRequired =>
      'Se requiere acceso a la ubicación para encontrar mezquitas cercanas.';

  @override
  String get nearbyMosquesPermissionOff =>
      'El permiso de ubicación está desactivado. Actívalo en Configuración para ver mezquitas cercanas.';

  @override
  String get nearbyMosquesLocationUnavailable =>
      'No pudimos leer tu ubicación actual en este momento.';

  @override
  String get nearbyMosquesLiveUpdateFailed =>
      'La actualización en vivo falló. Mostrando los últimos resultados guardados. Desliza para actualizar.';

  @override
  String get nearbyMosquesPermissionDenied =>
      'Se denegó el acceso a la ubicación. Actívalo en Configuración para ver mezquitas cercanas.';

  @override
  String get nearbyMosquesLocationTurnedOff =>
      'La ubicación está desactivada en este dispositivo. Actívala en Configuración y vuelve a intentarlo.';

  @override
  String get nearbyMosquesPermissionProcessing =>
      'El permiso de ubicación aún se está procesando. Vuelve a intentarlo en un momento.';

  @override
  String get nearbyMosquesRequestTimeout =>
      'La solicitud tardó demasiado. Revisa tu conexión a internet e inténtalo de nuevo.';

  @override
  String get nearbyMosquesOfflineOrUnreachable =>
      'Sin conexión a internet o el servicio no está disponible. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get nearbyMosquesFormatError =>
      'No pudimos leer la lista de mezquitas en este momento. Inténtalo más tarde.';

  @override
  String get nearbyMosquesPlatformError =>
      'No pudimos completar ese paso. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get nearbyMosquesSomethingWentWrong =>
      'Algo salió mal. Inténtalo de nuevo.';

  @override
  String nearbyMosquesEmptyHint(int radiusKm) {
    return 'No hay resultados dentro de $radiusKm km en OpenStreetMap para este punto. Inténtalo más tarde o amplía el área.';
  }

  @override
  String nearbyMosquesFoundWithin(int count, int radiusKm) {
    return '$count mezquitas encontradas dentro de $radiusKm km';
  }

  @override
  String nearbyMosquesCountNearby(int count) {
    return '$count mezquitas cercanas';
  }

  @override
  String nearbyMosquesResultsMeta(int radiusKm) {
    return 'Dentro de $radiusKm km · Ordenadas por distancia';
  }

  @override
  String get nearbyMosquesDirections => 'Indicaciones';

  @override
  String get tasbihDeleteDhikrTitle => '¿Eliminar dhikr?';

  @override
  String get tasbihDelete => 'Eliminar';

  @override
  String get focusAndroidBlockingNotReady =>
      'El bloqueo de apps en Android aún se está preparando. Mantén la accesibilidad activada y espera un momento a que se conecte.';

  @override
  String get focusNoAppsSelectedSnack =>
      'No hay apps seleccionadas. Elige primero las apps a bloquear.';

  @override
  String get focusDiagnosticButton => 'Diagnóstico';

  @override
  String get focusDiagnosticTitle => 'Probar bloqueo de apps';

  @override
  String get focusDiagnosticIntro =>
      'Bloquea temporalmente tus apps seleccionadas durante 60 segundos con el mismo bloqueo del modo Enfoque. Abre una app bloqueada para confirmar que aparece la pantalla de bloqueo de DeenFocus.';

  @override
  String focusDiagnosticIntroWithApp(String appName) {
    return 'Bloquea temporalmente tus apps seleccionadas durante 60 segundos. Prueba abrir $appName para confirmar que aparece la pantalla de bloqueo de DeenFocus.';
  }

  @override
  String get focusDiagnosticStart => 'Iniciar prueba';

  @override
  String get focusDiagnosticEndEarly => 'Terminar prueba';

  @override
  String focusDiagnosticRunning(int seconds) {
    return 'El bloqueo está activo durante ${seconds}s. Cambia a una app seleccionada para probar la pantalla de bloqueo.';
  }

  @override
  String get focusDiagnosticSuccessTitle => 'Prueba completada';

  @override
  String get focusDiagnosticSuccessBody =>
      'El bloqueo se activó con tus apps seleccionadas. Si viste la pantalla de bloqueo de DeenFocus, el bloqueo funciona.';

  @override
  String get focusDiagnosticCancelledTitle => 'Prueba finalizada';

  @override
  String get focusDiagnosticCancelledBody =>
      'Se desactivó el bloqueo de diagnóstico. Tus modos y horarios de Enfoque no cambiaron.';

  @override
  String get focusDiagnosticMissingAppsTitle => 'Selecciona apps primero';

  @override
  String get focusDiagnosticMissingAppsBody =>
      'Elige al menos una app para bloquear antes de ejecutar la prueba.';

  @override
  String get focusDiagnosticMissingPermissionTitle => 'Permiso necesario';

  @override
  String get focusDiagnosticMissingPermissionBodyIos =>
      'Se requiere acceso a Tiempo en pantalla. Permítelo e inténtalo de nuevo.';

  @override
  String get focusDiagnosticMissingPermissionBodyAndroid =>
      'Debes activar Accesibilidad para DeenFocus en Android para bloquear apps.';

  @override
  String get focusDiagnosticFailedTitle => 'No se pudo iniciar la prueba';

  @override
  String get focusDiagnosticFailedBody =>
      'El bloqueo no se activó. Revisa permisos y apps seleccionadas e inténtalo de nuevo.';

  @override
  String get focusDiagnosticClose => 'Listo';

  @override
  String get focusScreenTimeRequiredBlockIphone =>
      'Se necesita acceso a Tiempo en pantalla para bloquear apps en el iPhone.';

  @override
  String get focusModeUpdateFailedSnack =>
      'Algo salió mal al actualizar el modo Enfoque. Inténtalo de nuevo.';

  @override
  String get focusLoadingInstalledApps => 'Cargando apps instaladas...';

  @override
  String get focusNoInstalledAppsToShow =>
      'No hay apps instaladas para mostrar.';

  @override
  String get homeAiSuggestion1 => '¿Qué es el Ramadán?';

  @override
  String get homeAiSuggestion2 => 'Horarios de oración';

  @override
  String get homeAiSuggestion3 => 'Plan de lectura del Corán';

  @override
  String get homeAiDeveloperPrompt =>
      'Eres un asistente erudito islámico cordial y respetuoso. Ayuda a los usuarios a aprender sobre tradiciones islámicas, festividades, oración, estudio del Corán y prácticas espirituales. Sé cálido, conciso, educativo y culturalmente sensible. Si preguntan algo fuera de la guía islámica, responde con utilidad sin fingir certeza religiosa.';

  @override
  String get homeAiErrorMissingApiKey => 'Falta la configuración de la API.';

  @override
  String homeAiErrorApi(String statusCode, String detail) {
    return 'Error de la API $statusCode: $detail';
  }

  @override
  String get homeAiErrorEmptyResponse => 'No hubo respuesta del asistente.';

  @override
  String get homeAiErrorEmptyContent => 'La respuesta estaba vacía.';

  @override
  String get settingsPrayerCalculationSection => 'Cálculo de Oración';

  @override
  String get settingsCalculationMethodTitle => 'Método de Cálculo';

  @override
  String get settingsAsrCalculationTitle => 'Cálculo del Asr';

  @override
  String get calculationMethodSectionMajorOrgs =>
      'Principales Organizaciones Islámicas';

  @override
  String get calculationMethodSectionMiddleEast => 'Oriente Medio';

  @override
  String get calculationMethodSectionAsiaPacific => 'Asia Pacífico';

  @override
  String get calculationMethodSectionSpecial => 'Métodos Especiales';

  @override
  String get asrMethodStandard => 'Estándar';

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
  String get insightsPrayerStreak => 'Racha de oración';

  @override
  String insightsPrayerStreakCount(int count) {
    return '$count oraciones';
  }

  @override
  String get insightsPrayersInARow => 'Oraciones seguidas';

  @override
  String get insightsDaysInARow => 'Días seguidos';

  @override
  String insightsChipUpToday(int count) {
    return '↑ $count';
  }

  @override
  String get insightsChipDayUp => '↑ 1 hoy';

  @override
  String get insightsWeeklyCompletion => 'Progreso semanal';

  @override
  String get insightsMonthlyCompletion => 'Progreso mensual';

  @override
  String get insightsThisWeek => 'Esta semana';

  @override
  String get insightsThisMonth => 'Este mes';

  @override
  String get insightsOverall => 'General';

  @override
  String get insightsRateExcellent => 'Excelente';

  @override
  String get insightsRateGood => 'Bien';

  @override
  String get insightsRateFair => 'Regular';

  @override
  String get insightsRateStart => 'Sigue así';

  @override
  String get insightsPrayersCompletedWeekly =>
      'Oraciones completadas (semanal)';

  @override
  String get insightsPrayersCompletedMonthly =>
      'Oraciones completadas (mensual)';

  @override
  String insightsCompletionSummary(int done, int possible) {
    return 'Completaste $done de $possible oraciones.\n¡Alhamdulillah — sigue así!';
  }

  @override
  String get insightsFocusExcellent => '¡Excelente — sigue así!';

  @override
  String get insightsFocusKeepGoing => 'Sigue construyendo tu enfoque';

  @override
  String get insightsTodaysPrayers => 'Oraciones de hoy';

  @override
  String get insightsPrayersCompletedLabel =>
      'Oraciones completadas — ¡Alhamdulillah!';

  @override
  String get insightsCycleModeActiveLabel => 'Modo ciclo activo';

  @override
  String get insightsProtectedByCycleMode => 'Tu racha está protegida.';

  @override
  String get insightsCurrentPrayerStreak => 'Racha de oración actual';

  @override
  String get insightsBestPrayerStreak => 'Mejor racha de oración';

  @override
  String get insightsCurrentDayStreak => 'Racha de días actual';

  @override
  String get insightsCycleProtectedDays => 'Días protegidos por el ciclo';

  @override
  String get insightsAchievements => 'Logros';

  @override
  String get insightsAchieved => 'Logrado';

  @override
  String get insightsMyProgress => 'Mi progreso';

  @override
  String insightsLevelNumber(int level) {
    return 'Nivel $level';
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
    return '$xp XP para el nivel $level';
  }

  @override
  String get insightsMaxLevel => 'NIVEL MÁXIMO';

  @override
  String insightsAchievementsUnlocked(int unlocked, int total) {
    return '$unlocked / $total desbloqueados';
  }

  @override
  String get insightsAchievementUnlockedTitle => 'Logro desbloqueado';

  @override
  String get insightsLevelUpTitle => 'SUBISTE DE NIVEL';

  @override
  String get achievementFirstPrayer => 'Primera oración';

  @override
  String get achievementFajrChampion => 'Campeón del Fajr';

  @override
  String get achievementFiveADay => 'Cinco al día';

  @override
  String get achievementPerfectWeek => 'Semana perfecta';

  @override
  String get achievementPerfectMonth => 'Mes perfecto';

  @override
  String get achievementQuranDevotee => 'Devoto del Corán';

  @override
  String get achievementDhikrStarter => 'Inicio del dhikr';

  @override
  String get achievementNightWorshipper => 'Adorador nocturno';

  @override
  String get achievementMasjidCompanion => 'Compañero de la mezquita';

  @override
  String get achievementDistractionDefender => 'Defensor del enfoque';

  @override
  String get achievementCycleGuardian => 'Guardián del ciclo';

  @override
  String get achievementProtectedMonth => 'Mes protegido';

  @override
  String get achievementSixMonthJourney => 'Viaje de seis meses';

  @override
  String get achievementDeenFocusMaster => 'DeenFocus Master';

  @override
  String insightsCycleModeFooter(int days) {
    return 'Los días de ciclo están protegidos y no rompen la racha. Tienes $days día(s) protegido(s).';
  }

  @override
  String get insightsCycleModeFooterOff =>
      'Activa el Modo ciclo para proteger tu racha durante los días de descanso.';

  @override
  String get achievementFirstPrayerStreak => 'Primera racha de oración';

  @override
  String get achievementSevenPrayerStreak => 'Racha de siete oraciones';

  @override
  String get achievementThirtyPrayerStreak => 'Racha de treinta oraciones';

  @override
  String get achievementFajrWarrior => 'Guerrero del Fajr';

  @override
  String get achievementQuranReader => 'Lector del Corán';

  @override
  String get achievementDhikrMaster => 'Maestro del Dhikr';

  @override
  String get achievementConsistencyChampion => 'Campeón de la constancia';

  @override
  String get prayerCompletionAlhamdulillah => '¡Alhamdulillah!';

  @override
  String prayerCompletionCompleted(String prayer) {
    return '$prayer se ha completado';
  }

  @override
  String get prayerCompletionStreakIncreased =>
      'Tu racha de oración ha aumentado';

  @override
  String get prayerCompletionKeepGoing =>
      'Cada oración te acerca más a Allah. ¡Sigue así!';

  @override
  String get prayerCompletionContinue => 'Continuar';

  @override
  String prayerCompletionNextPrayer(String when) {
    return 'Próxima oración en $when';
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
  String get weekdayLetterMon => 'L';

  @override
  String get weekdayLetterTue => 'M';

  @override
  String get weekdayLetterWed => 'X';

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
      'El modo Disciplina nocturna y Salah están bloqueando las apps seleccionadas.';

  @override
  String get focusHomeBlockingNight =>
      'El modo Disciplina nocturna está bloqueando las apps seleccionadas.';

  @override
  String get focusHomeBlockingSalah =>
      'El modo Salah está bloqueando las apps seleccionadas.';

  @override
  String get focusHomeAppsBlockedNow =>
      'Las apps seleccionadas están bloqueadas ahora.';

  @override
  String focusHomeModeEnabled(String mode) {
    return '$mode está activado.';
  }

  @override
  String focusHomeModesEnabled(String modes) {
    return '$modes están activados.';
  }

  @override
  String get focusHomeChooseMode => 'Elige un modo para proteger tu atención';

  @override
  String get focusStatusSelectApps => 'Selecciona apps para empezar';

  @override
  String get focusStatusBlockingNightAndSalah =>
      'Disciplina nocturna y modo Salah están bloqueando apps ahora';

  @override
  String get focusStatusBlockingNight =>
      'Disciplina nocturna está bloqueando apps ahora';

  @override
  String get focusStatusBlockingSalah =>
      'El modo Salah está bloqueando apps ahora';

  @override
  String get focusStatusAppsLocked => 'Las apps están bloqueadas ahora';

  @override
  String focusStatusUnlockedUntil(String time) {
    return 'Desbloqueado hasta $time';
  }

  @override
  String get focusStatusNoMode => 'Ningún modo de enfoque activado';

  @override
  String focusStatusReadyToLock(String targets) {
    return 'Listo para bloquear $targets';
  }

  @override
  String homeCountdownHms(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String get appLockDemoIntroTitle => 'Así funciona el bloqueo de apps';

  @override
  String get appLockDemoIntroSubtitle =>
      'Quédate en DeenFocus. En la siguiente pantalla, toca Instagram para ver cómo se pausa a la hora de la oración.';

  @override
  String get appLockDemoStartButton => 'Iniciar la demo';

  @override
  String get appLockDemoTryOpeningApp => 'Intenta abrir Instagram';

  @override
  String get appLockDemoSalahModeBadge => 'MODO SALAH';

  @override
  String get appLockDemoTimeToPray => 'Es hora de orar';

  @override
  String appLockDemoRemainingTime(String time) {
    return 'Tiempo restante: $time';
  }

  @override
  String appLockDemoIvePrayed(String prayerName) {
    return 'Ya oré $prayerName';
  }

  @override
  String get appLockDemoAlhamdulillah => 'Alhamdulillah';

  @override
  String appLockDemoPrayerCompleted(String prayerName) {
    return '$prayerName completada';
  }

  @override
  String get appLockDemoStreakIncreased => 'Tu racha de oración aumentó';

  @override
  String get appLockDemoPrayerStreakLabel => 'RACHA DE ORACIÓN';

  @override
  String get appLockDemoDayStreakLabel => 'RACHA DE DÍAS';

  @override
  String appLockDemoNextPrayerIn(String minutes) {
    return 'Próxima oración en $minutes minutos';
  }

  @override
  String get appLockDemoStreakMotivation =>
      '¡Sigue así! Tu constancia te acerca a Allah.';

  @override
  String get appLockDemoCompletionSubtitle =>
      'Ora. Confirma una vez.\nVuelve a tu día.';

  @override
  String get appLockDemoCompletionBody =>
      'El bloqueo de apps pausa suavemente las apps seleccionadas durante Salah para que te centres en la oración — luego continúas cuando estés listo.';

  @override
  String get appLockDemoContinueSetup => 'Continuar configuración';

  @override
  String get appLockDemoAppMessages => 'Mensajes';

  @override
  String get appLockDemoAppCalendar => 'Calendario';

  @override
  String get appLockDemoAppPhotos => 'Fotos';

  @override
  String get appLockDemoAppCamera => 'Cámara';

  @override
  String get appLockDemoAppMail => 'Correo';

  @override
  String get appLockDemoAppMaps => 'Mapas';

  @override
  String get appLockDemoAppWeather => 'Clima';

  @override
  String get appLockDemoAppClock => 'Reloj';

  @override
  String get appLockDemoAppNotes => 'Notas';

  @override
  String get appLockDemoAppSettings => 'Ajustes';

  @override
  String get appLockDemoAppMusic => 'Música';

  @override
  String get appLockDemoAppInstagram => 'Instagram';

  @override
  String get settingsPrayerUpdatesTitle => 'Actualizaciones de oración';

  @override
  String get settingsPrayerUpdatesSubtitle =>
      'Live Activity de tu próxima oración en la pantalla de bloqueo';

  @override
  String get liveActivitySectionTitle => 'Live Activities';

  @override
  String get liveActivityStayUpdatedTitle => 'Mantente al día de un vistazo';

  @override
  String get liveActivityStayUpdatedBody =>
      'Ve tu próxima oración y su hora directamente en la pantalla de bloqueo.';

  @override
  String get liveActivityEnableLabel => 'Activar Live Activity';

  @override
  String get liveActivityPromptNotNow => 'Ahora no';

  @override
  String get liveActivityUnsupported =>
      'Live Activities no están disponibles en este dispositivo.';

  @override
  String get liveActivityPermissionNeeded =>
      'Permite las notificaciones para ver actualizaciones de oración en la pantalla de bloqueo.';

  @override
  String get liveActivityPermissionButton => 'Permitir notificaciones';

  @override
  String get liveActivityStatusActive => 'Live Activity activada';

  @override
  String get liveActivityStatusOff => 'Live Activity desactivada';

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
  String get liveActivityNowLabel => 'Ahora';

  @override
  String liveActivityUpdatedAt(String time) {
    return 'Actualizado a las $time';
  }

  @override
  String liveActivityNextAt(String prayer, String time) {
    return '$prayer a las $time';
  }

  @override
  String get settingsPrayerAlarmsTitle => 'Alarmas de oración';

  @override
  String get settingsPrayerAlarmsSubtitle =>
      'Alarmas completas que pueden atravesar el modo silencioso';

  @override
  String get prayerAlarmsMasterLabel => 'Activar alarmas de oración';

  @override
  String get prayerAlarmsMasterSubtitle =>
      'Programar una alarma nativa para cada oración seleccionada';

  @override
  String get prayerAlarmsSnoozeLabel => 'Duración de la repetición';

  @override
  String prayerAlarmsSnoozeMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get prayerAlarmsPerPrayerSection => 'Alarmas por oración';

  @override
  String get prayerAlarmsPermissionNeeded =>
      'Permite el permiso de alarma para que suenen a tiempo.';

  @override
  String get prayerAlarmsPermissionButton => 'Permitir alarmas';

  @override
  String get prayerAlarmsFsiNeeded =>
      'Permite alarmas a pantalla completa para la pantalla de bloqueo. Sin eso, avisan como banner.';

  @override
  String get prayerAlarmsFsiButton => 'Ajustes a pantalla completa';

  @override
  String get prayerAlarmsUnsupported =>
      'Las alarmas nativas no están disponibles en este dispositivo. Las notificaciones suaves siguen funcionando.';

  @override
  String get prayerAlarmsIosFallback =>
      'En esta versión de iOS se usan notificaciones suaves en lugar de AlarmKit.';

  @override
  String get prayerAlarmsDeniedTitle => 'Se requiere permiso de alarma';

  @override
  String get prayerAlarmsDeniedMessage =>
      'Las alarmas de oración permanecen desactivadas hasta que permitas el permiso. Las notificaciones suaves no se ven afectadas.';

  @override
  String get prayerAlarmsOpenSettings => 'Abrir ajustes';

  @override
  String get prayerAlarmsStatusReady =>
      'Las alarmas están listas para programarse';

  @override
  String get prayerAlarmsStatusNeedsPermission =>
      'Se necesita permiso — las alarmas no están activas';

  @override
  String get prayerAlarmsStatusFallback =>
      'Usando notificaciones suaves en este dispositivo';

  @override
  String get prayerAlarmsStatusFsiOptional =>
      'Alarmas activadas. Activa pantalla completa para la pantalla de bloqueo.';

  @override
  String get prayerAlarmsCancel => 'Ahora no';

  @override
  String get homePrayerAlarmEnableLabel => 'Alarma de oración';

  @override
  String homePrayerAlarmEnableSubtitle(String prayerName) {
    return 'Sonar una alarma nativa en $prayerName';
  }

  @override
  String get prayerAlarmBadge => 'Alarma de oración';

  @override
  String get prayerAlarmSubtitle => 'Hora de orar';

  @override
  String prayerAlarmTitle(String prayerName) {
    return '$prayerName — Hora de orar';
  }

  @override
  String get prayerAlarmIvePrayed => 'He orado';

  @override
  String get prayerAlarmDismiss => 'Descartar';

  @override
  String get prayerAlarmSnooze => 'Posponer';

  @override
  String get appLockDemoAppPhone => 'Teléfono';

  @override
  String get appLockDemoAppSafari => 'Safari';

  @override
  String get appLockDemoAppFaceTime => 'FaceTime';

  @override
  String get appLockDemoAppReminders => 'Recordatorios';

  @override
  String get appLockDemoAppAppStore => 'App Store';

  @override
  String get appLockDemoAppBooks => 'Libros';

  @override
  String get appLockDemoAppHealth => 'Salud';

  @override
  String get appLockDemoAppWallet => 'Cartera';

  @override
  String get appLockDemoAppChrome => 'Chrome';

  @override
  String get settingsAppDemoLabel => 'Demo de la app';

  @override
  String get settingsAppDemoChooseModeTitle => 'Prueba el bloqueo de apps';

  @override
  String get settingsAppDemoChooseModeSubtitle =>
      'Elige un modo Focus y mira cómo se pausan las apps seleccionadas — sin salir de DeenFocus.';

  @override
  String get appLockDemoDone => 'Listo';

  @override
  String get appLockDemoSleepIntroTitle => 'Así funciona el Modo Sueño';

  @override
  String get appLockDemoSleepIntroSubtitle =>
      'Quédate en DeenFocus. En la siguiente pantalla, toca Instagram para ver la pausa a la hora de dormir.';

  @override
  String get appLockDemoSleepModeBadge => 'MODO SUEÑO';

  @override
  String get appLockDemoSleepLockTitle => 'Es hora de descansar';

  @override
  String get appLockDemoSleepLockCta => 'Estoy listo para descansar';

  @override
  String get appLockDemoSleepCompleted => 'Modo Sueño protegido';

  @override
  String get appLockDemoSleepRewardSubtitle => 'Tu protección nocturna aumentó';

  @override
  String get appLockDemoSleepStreakLabel => 'RACHA NOCTURNA';

  @override
  String get appLockDemoSleepRewardFooter =>
      'Recordatorio de Fajr listo para la mañana';

  @override
  String get appLockDemoSleepMotivation =>
      'Descansa bien esta noche para levantarte con energía para Fajr.';

  @override
  String get appLockDemoSleepCompletionSubtitle =>
      'Noches tranquilas.\nMañanas claras.';

  @override
  String get appLockDemoSleepCompletionBody =>
      'El Modo Sueño pausa suavemente las apps seleccionadas por la noche para que descanses — luego continúas.';

  @override
  String get appLockDemoChildIntroTitle => 'Así funciona el Modo Niño';

  @override
  String get appLockDemoChildIntroSubtitle =>
      'Quédate en DeenFocus. En la siguiente pantalla, toca Instagram para ver el bloqueo con Modo Niño.';

  @override
  String get appLockDemoChildModeBadge => 'MODO NIÑO';

  @override
  String get appLockDemoChildLockTitle => 'Las apps están protegidas';

  @override
  String get appLockDemoChildLockDetail =>
      'Las apps seleccionadas permanecen bloqueadas con Modo Niño';

  @override
  String get appLockDemoChildLockCta => 'Entendido';

  @override
  String get appLockDemoChildCompleted => 'Modo Niño activo';

  @override
  String get appLockDemoChildRewardSubtitle => 'Tu racha de protección aumentó';

  @override
  String get appLockDemoChildStreakLabel => 'RACHA SEGURA';

  @override
  String get appLockDemoChildRewardFooter =>
      'Sal en cualquier momento con tu código';

  @override
  String get appLockDemoChildMotivation =>
      'Tranquilidad cada vez que prestas tu teléfono.';

  @override
  String get appLockDemoChildCompletionSubtitle =>
      'Modo seguro con un toque.\nSolo lo que permites.';

  @override
  String get appLockDemoChildCompletionBody =>
      'El Modo Niño bloquea las apps seleccionadas para que tu hijo solo vea lo seguro — luego desbloqueas.';

  @override
  String get appLockDemoSleepCompletionTitle => 'Descansa bien esta noche';

  @override
  String get appLockDemoChildCompletionTitle => 'Tranquilidad';

  @override
  String get settingsAppDemoPrayerCardSubtitle =>
      'Pausa las distracciones en el Salah para orar con presencia.';

  @override
  String get settingsAppDemoSleepCardSubtitle =>
      'Protege tus noches para descansar mejor — y que el Fajr se sienta más ligero.';

  @override
  String get settingsAppDemoChildCardSubtitle =>
      'Entrega tu teléfono con tranquilidad: solo quedan abiertas las apps permitidas.';

  @override
  String get settingsAppDemoHomeFeaturesTitle =>
      'Mantente al día de un vistazo';

  @override
  String get settingsAppDemoHomeFeaturesSubtitle =>
      'Mira cómo los widgets y la Live Activity mantienen los horarios de oración cerca — sin abrir la app.';

  @override
  String get settingsAppDemoWidgetsCardSubtitle =>
      'Verso del día y horarios de oración en tu pantalla de inicio, siempre actualizados.';

  @override
  String get settingsAppDemoLiveActivityCardSubtitle =>
      'Oración actual y siguiente en la pantalla de bloqueo y Dynamic Island.';

  @override
  String get settingsAppDemoTajweedCardSubtitle =>
      'Recita un aleya y recibe feedback de tayyid al instante.';

  @override
  String get featureDemoTajweedTitle => 'Tayyid';

  @override
  String get featureDemoTajweedIntroTitle =>
      'Así funciona la práctica de tayyid';

  @override
  String get featureDemoTajweedIntroSubtitle =>
      'Quédate en DeenFocus. Abre el ejercicio de tayyid, recita un aleya y ve el feedback palabra por palabra.';

  @override
  String get featureDemoTajweedQuranCallout =>
      'Toca Ejercicio de tayyid para empezar';

  @override
  String get featureDemoTajweedLegendCallout =>
      'Los colores muestran las reglas de tayyid al leer';

  @override
  String get featureDemoTajweedReciteCallout =>
      'Toca Recitar y comprobar tayyid';

  @override
  String get featureDemoTajweedDownloadCallout =>
      'Una descarga única para practicar sin conexión';

  @override
  String get featureDemoTajweedMicCallout =>
      'Toca el micrófono y empieza a recitar';

  @override
  String get featureDemoTajweedResultCallout =>
      'Mira qué palabras fueron correctas, omitidas o a mejorar';

  @override
  String get featureDemoTajweedCompletionTitle => 'Tayyid, listo';

  @override
  String get featureDemoTajweedCompletionSubtitle =>
      'Recita con confianza, cuando quieras.';

  @override
  String get featureDemoTajweedCompletionBody =>
      'Abre Corán → Ejercicio de tayyid para practicar cualquier aleya con puntuación en el dispositivo — totalmente sin conexión tras la primera descarga.';

  @override
  String get featureDemoTajweedSurahName => 'Al-Fatihah';

  @override
  String get featureDemoTajweedBaqarahName => 'Al-Baqarah';

  @override
  String get featureDemoTajweedSurahListSubtitle => '7 aleyas • Meca';

  @override
  String get featureDemoTajweedBaqarahSubtitle => '286 aleyas • Medina';

  @override
  String get featureDemoTajweedSurahHeaderSubtitle => 'Al-Fatihah • 7 aleyas';

  @override
  String get featureDemoTajweedSurahMeta => 'SURA 1 • MECA';

  @override
  String get featureDemoTajweedAyahTranslation =>
      'En el nombre de Alá, el Compasivo, el Misericordioso.';

  @override
  String get featureDemoTajweedPracticeTitle => 'Al-Fatihah · 1:1';

  @override
  String get featureDemoTajweedPreparingTitle => 'Preparando el modelo de IA';

  @override
  String get featureDemoTajweedPreparingBody =>
      'Una descarga única para que la práctica de tayyid funcione totalmente sin conexión después. Solo ocurre una vez.';

  @override
  String get featureDemoTajweedResultEncouragement =>
      'Sigue practicando: escucha la referencia e inténtalo de nuevo.';

  @override
  String get featureDemoTajweedStatCorrect => 'Correcto';

  @override
  String get featureDemoTajweedStatPronunciation => 'Pronunciación';

  @override
  String get featureDemoTajweedStatWrong => 'Palabra incorrecta';

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
      'Tu dispositivo no permite que las apps coloquen widgets automáticamente. Añade el widget grande de DeenFocus desde la galería de widgets de la pantalla de inicio.';

  @override
  String get featureDemoOfferWidgetManualTitle =>
      'Añade el widget desde la pantalla de inicio';

  @override
  String get featureDemoOfferNo => 'No';

  @override
  String get featureDemoOfferYes => 'Sí';

  @override
  String get featureDemoOfferLiveActivityTitle =>
      '¿Quieres activar Live Activity en tu dispositivo?';

  @override
  String get featureDemoOfferWidgetsTitle =>
      '¿Quieres añadir este widget a tu pantalla de inicio?';

  @override
  String get featureDemoWidgetsTitle => 'Widgets';

  @override
  String get featureDemoWidgetsIntroTitle => 'Mira tus widgets';

  @override
  String get featureDemoWidgetsIntroSubtitle =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsShowcaseCallout =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsDetailsTitle =>
      'Orientación de oración de un vistazo';

  @override
  String get featureDemoWidgetsDetailsBody =>
      'El widget mediano muestra el verso del día y las cinco oraciones — se actualiza al abrir DeenFocus.';

  @override
  String get featureDemoWidgetsCompletionTitle => 'Widgets listos';

  @override
  String get featureDemoWidgetsCompletionSubtitle =>
      'Recordatorios de fe en tu pantalla de inicio.';

  @override
  String get featureDemoWidgetsCompletionBody =>
      'Añade los widgets de DeenFocus desde la galería y abre la app una vez para sincronizar.';

  @override
  String get featureDemoWidgetsHomeHint => 'Miércoles, 13 de agosto';

  @override
  String get featureDemoWidgetSampleDate => 'Mié, 13 ago';

  @override
  String get featureDemoWidgetSampleVerse =>
      'Solo a Ti adoramos y solo de Ti pedimos ayuda.';

  @override
  String get featureDemoWidgetSampleSource => 'Sura 1:5';

  @override
  String get featureDemoLiveActivityTitle => 'Live Activity';

  @override
  String get featureDemoLiveActivityIntroTitle =>
      'Mira Live Activity en acción';

  @override
  String get featureDemoLiveActivityIntroSubtitle =>
      'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.';

  @override
  String get featureDemoLiveActivityShowcaseCallout => 'Tap Prayer Calculation';

  @override
  String get featureDemoLiveActivityDetailsTitle =>
      'Actualizaciones de oración siempre visibles';

  @override
  String get featureDemoLiveActivityDetailsBody =>
      'Live Activity mantiene Maghrib, Isha y la cuenta atrás en la pantalla de bloqueo — actívala en Ajustes.';

  @override
  String get featureDemoLiveActivityCompletionTitle => 'Live Activity lista';

  @override
  String get featureDemoLiveActivityCompletionSubtitle =>
      'La próxima oración, siempre cerca.';

  @override
  String get featureDemoLiveActivityCompletionBody =>
      'Activa Live Activity en Ajustes → Cálculo de oración para mostrarla en la pantalla de bloqueo.';

  @override
  String get featureDemoLiveActivityLockHint => 'Miércoles, 13 de agosto';

  @override
  String get featureDemoLiveActivitySampleTime => '6:48 p. m.';

  @override
  String get featureDemoLiveActivitySampleNextTime => '8:11 p. m.';

  @override
  String get featureDemoWidgetsIntroSubtitleIos =>
      'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.';

  @override
  String get featureDemoWidgetsIntroSubtitleAndroid =>
      'Stay in DeenFocus. Long-press the Home Screen, open the widget picker, and try all three sizes.';

  @override
  String get featureDemoWidgetsLongPressCalloutIos =>
      'Mantén pulsada la pantalla de inicio';

  @override
  String get featureDemoWidgetsLongPressCalloutAndroid =>
      'Long-press the Home Screen to edit widgets';

  @override
  String get featureDemoWidgetsAddCallout =>
      'Toca + para elegir un widget de DeenFocus';

  @override
  String get featureDemoWidgetsAddSlotLabel => 'Add Widget';

  @override
  String get featureDemoWidgetsGalleryTitle => 'Elige un widget de DeenFocus';

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
  String get featureDemoWidgetSizeSmall => 'Pequeño';

  @override
  String get featureDemoWidgetSizeMedium => 'Mediano';

  @override
  String get featureDemoWidgetSizeLarge => 'Grande';

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
  String get featureDemoLiveOpenPrayerCalcCallout => 'Toca Cálculo de oración';

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
  String get featureDemoAndroidOpenShadeCta => 'Abrir panel de notificaciones';

  @override
  String get featureDemoAndroidShadeTitle => 'Notification shade';

  @override
  String get featureDemoAndroidShadeCallout =>
      'Expand to see the full current and next prayer status';

  @override
  String get featureDemoAndroidOngoingBadge => 'Ongoing';

  @override
  String get appLockDemoOfferPrayerTitle =>
      '¿Listo para probar el Modo Oración?';

  @override
  String get appLockDemoOfferSleepTitle => '¿Listo para probar el Modo Sueño?';

  @override
  String get appLockDemoOfferChildTitle => '¿Listo para probar el Modo Niño?';

  @override
  String get appLockDemoOfferPrayerCta => 'Activar Modo Oración';

  @override
  String get appLockDemoOfferSleepCta => 'Activar Modo Sueño';

  @override
  String get appLockDemoOfferChildCta => 'Activar Modo Niño';

  @override
  String get appLockDemoOfferNotNow => 'Ahora no';

  @override
  String get nightlyWrapUpPrayersTitle => 'Completa las oraciones de hoy';

  @override
  String get nightlyWrapUpPrayersBody =>
      'Marca las oraciones pendientes o perdidas para proteger tu racha de oración.';

  @override
  String get nightlyWrapUpChecklistTitle => 'Completa tu lista diaria';

  @override
  String get nightlyWrapUpChecklistBody =>
      'Aún quedan tareas abiertas — cierra el día con intención.';

  @override
  String get nightlyWrapUpBothTitle => 'Cierra tu día';

  @override
  String get nightlyWrapUpBothBody =>
      'Marca las oraciones pendientes y termina tu lista diaria antes de que termine el día.';

  @override
  String get cycleModeEndedNotificationTitle => 'El modo ciclo ha terminado';

  @override
  String get cycleModeEndedNotificationBody =>
      'Tu modo ciclo ahora está desactivado. Puedes volver a orar. Si quieres cambiar las fechas del modo ciclo, toca aquí para editarlas.';

  @override
  String get libraryHomeTitle => 'Biblioteca islámica';

  @override
  String get libraryHomeSubtitle =>
      'Aprende hadices, dúas, los 99 Nombres y más';

  @override
  String get libraryHubTitle => 'Biblioteca islámica';

  @override
  String get libraryModuleQuran => 'Corán';

  @override
  String get libraryModuleQuranSub => 'Lee, escucha y practica el taywid';

  @override
  String get libraryModuleHadith => 'Hadiz';

  @override
  String get libraryModuleHadithSub => 'Colecciones de fuentes auténticas';

  @override
  String get libraryModuleDuas => 'Dúas y adhkar';

  @override
  String get libraryModuleDuasSub => 'Recuerdo de la mañana, la tarde y diario';

  @override
  String get libraryModulePrayerMethods => 'Oración y métodos islámicos';

  @override
  String get libraryModulePrayerMethodsSub => 'Wudu, salah, hayy y más';

  @override
  String get libraryModuleFiqh => 'Fiqh y tradiciones';

  @override
  String get libraryModuleFiqhSub =>
      'Sunitas, chiitas, madhabs, Ahl-e Hadith y más';

  @override
  String get libraryModuleNames => '99 Nombres de Alá';

  @override
  String get libraryModuleNamesSub =>
      'Aprende y reflexiona sobre Asma ul-Husna';

  @override
  String get libraryModulePillarsIslam => 'Pilares del islam';

  @override
  String get libraryModulePillarsIslamSub =>
      'Los cinco fundamentos de la fe en la práctica';

  @override
  String get libraryModulePillarsIman => 'Pilares de la fe';

  @override
  String get libraryModulePillarsImanSub => 'Los seis artículos de la creencia';

  @override
  String get libraryModuleProphets => 'Profeta Muhammad';

  @override
  String get libraryModuleProphetsSub => 'Su vida, misión y lecciones eternas';

  @override
  String get libraryModuleOccasions => 'Ocasiones islámicas';

  @override
  String get libraryModuleOccasionsSub => 'Ramadán, Eid, Hayy y días sagrados';

  @override
  String get libraryKeyLesson => 'Lección clave';

  @override
  String libraryCardProgress(int current, int total) {
    return '$current de $total';
  }

  @override
  String get libraryPrevious => 'Anterior';

  @override
  String get libraryNext => 'Siguiente';

  @override
  String get libraryBookmark => 'Marcador';

  @override
  String get libraryCopy => 'Copiar';

  @override
  String get libraryShare => 'Compartir';

  @override
  String get libraryCopied => 'Copiado al portapapeles';

  @override
  String get libraryShareCopiedHint => 'Copiado — pega para compartir';

  @override
  String get libraryShareReference => 'Referencia';

  @override
  String get contentShareIntro =>
      'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍';

  @override
  String get contentShareExplore => 'Explora DeenFocus:';

  @override
  String get contentShareFailed =>
      'No se pudo compartir ahora. Inténtalo de nuevo.';

  @override
  String get libraryBookmarkSaved => 'Marcador guardado';

  @override
  String get libraryBookmarkRemoved => 'Marcador eliminado';

  @override
  String get libraryTranslation => 'Traducción';

  @override
  String get libraryTransliteration => 'Transliteración';

  @override
  String get libraryMeaning => 'Significado';

  @override
  String get libraryBookmarksTitle => 'Elementos de aprendizaje guardados';

  @override
  String get libraryBookmarksSubtitle => 'Hadices, dúas, nombres, fiqh y más';

  @override
  String get libraryBookmarksEmpty =>
      'Aún no hay elementos guardados. Toca Marcador en cualquier elemento de aprendizaje para guardarlo aquí.';

  @override
  String get libraryMarkCompleted => 'Marcar como completado';

  @override
  String get librarySectionCompleted => 'Completado';

  @override
  String get libraryReflection => 'Reflexión';

  @override
  String get libraryComingSoonTitle => 'Próximamente';

  @override
  String get libraryComingSoonBody =>
      'Este módulo se está preparando. Vuelve en una futura actualización.';

  @override
  String get librarySearchHint => 'Buscar…';

  @override
  String get libraryHubSearchHint => 'Buscar en Aprendizaje…';

  @override
  String get libraryHubSearchSections => 'Secciones';

  @override
  String get libraryHubSearchTopics => 'Temas';

  @override
  String get librarySearchEmpty => 'Sin resultados';

  @override
  String libraryItemCount(int count) {
    return '$count elementos';
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
  String get libraryInProgress => 'En progreso';

  @override
  String libraryReference(String source) {
    return 'Referencia: $source';
  }

  @override
  String libraryDuaCount(int count) {
    return '$count dúas';
  }

  @override
  String get libraryDuaCategoryMorning => 'Mañana';

  @override
  String get libraryDuaCategoryEvening => 'Tarde';

  @override
  String get libraryDuaCategoryDailyLife => 'Vida diaria';

  @override
  String get libraryDuaCategorySleep => 'Sueño';

  @override
  String get libraryDuaCategoryFood => 'Comida';

  @override
  String get libraryDuaCategoryTravel => 'Viaje';

  @override
  String get libraryDuaCategoryIllness => 'Enfermedad';

  @override
  String get libraryDuaCategoryProtection => 'Protección';

  @override
  String get libraryDuaCategoryForgiveness => 'Perdón';

  @override
  String get libraryDuaCategoryParents => 'Padres';

  @override
  String libraryHadithCount(int count) {
    return '$count hadices';
  }

  @override
  String get libraryHadithNarrator => 'Narrador:';

  @override
  String get libraryHadithSource => 'Fuente:';

  @override
  String get libraryHadithCollectionBukhari => 'Sahih al-Bujari';

  @override
  String get libraryHadithCollectionMuslim => 'Sahih Muslim';

  @override
  String get libraryHadithCollectionRiyad => 'Riyad us-Saliheen';

  @override
  String get libraryHadithCollectionNawawi => '40 Hadices Nawawi';

  @override
  String get libraryHadithCollectionHisnul => 'Hisnul Muslim';

  @override
  String libraryGuideStepCount(int count) {
    return '$count pasos';
  }

  @override
  String libraryGuideStepLabel(int current, int total) {
    return 'Paso $current de $total';
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
  String get libraryGuideJanazah => 'Oración del funeral';

  @override
  String get libraryGuideUmrah => 'Umra';

  @override
  String get libraryGuideHajj => 'Hayy';

  @override
  String get libraryGuideFasting => 'Ayuno';

  @override
  String get libraryGuideZakat => 'Zakat';

  @override
  String get libraryGuideTawbah => 'Tawba';

  @override
  String get libraryOccasionImportance => 'Importancia';

  @override
  String get libraryOccasionVirtues => 'Virtudes';

  @override
  String get libraryOccasionRecommendedActs => 'Actos recomendados';

  @override
  String get libraryFiqhOverview => 'Resumen';

  @override
  String get libraryFiqhKeyPoints => 'Puntos clave';

  @override
  String get libraryFiqhDifferences => 'Diferencias notables';

  @override
  String get libraryFiqhCommonGround => 'Puntos en común';

  @override
  String get insightsCompleted => 'Completados';

  @override
  String get insightsInProgress => 'En progreso';

  @override
  String get insightsKeepGoingTitle => '¡Sigue así!';

  @override
  String get insightsKeepGoingBody =>
      'Estás avanzando mucho. Cada oración cuenta.';

  @override
  String get insightsAchievementsUnlockedLabel => 'Logros desbloqueados';

  @override
  String insightsAchievementsCount(int unlocked, int total) {
    return '$unlocked / $total';
  }

  @override
  String get achievementDescFirstPrayer => 'Rezaste tu primera oración.';

  @override
  String get achievementDescSevenPrayerStreak =>
      'Completa 7 oraciones seguidas.';

  @override
  String get achievementDescThirtyPrayerStreak =>
      'Completa 30 oraciones seguidas.';

  @override
  String get achievementDescFajrWarrior => 'Reza el Fajr durante 14 días.';

  @override
  String get achievementDescFajrChampion => 'Reza el Fajr durante 30 días.';

  @override
  String get achievementDescFiveADay =>
      'Completa las cinco oraciones en un día.';

  @override
  String get achievementDescPerfectWeek =>
      'Completa cada oración durante 7 días seguidos.';

  @override
  String get achievementDescPerfectMonth =>
      'Completa cada oración durante 30 días seguidos.';

  @override
  String get achievementDescQuranReader => 'Lee el Corán durante 7 días.';

  @override
  String get achievementDescQuranDevotee => 'Lee el Corán durante 30 días.';

  @override
  String get achievementDescDhikrStarter => 'Completa el dhikr durante 7 días.';

  @override
  String get achievementDescDhikrMaster => 'Completa el dhikr durante 30 días.';

  @override
  String get achievementDescNightWorshipper =>
      'Reza el Tahajjud durante 7 días.';

  @override
  String get achievementDescMasjidCompanion => 'Visita la mezquita 7 veces.';

  @override
  String get achievementDescDistractionDefender =>
      'Mantente sin distracciones durante 7 días.';

  @override
  String get achievementDescCycleGuardian =>
      'Protege tu racha con el modo ciclo durante 7 días.';

  @override
  String get achievementDescProtectedMonth =>
      'Protege tu racha con el modo ciclo durante 30 días.';

  @override
  String get achievementDescConsistencyChampion =>
      'Mantén la constancia durante 100 días.';

  @override
  String get achievementDescSixMonthJourney => 'Sigue durante 180 días.';

  @override
  String get achievementDescDeenFocusMaster =>
      'Alcanza DeenFocus Master (nivel 15).';

  @override
  String get dailyChecklistOptional => 'Opcional';

  @override
  String get dailyChecklistIstighfar => 'Istighfar';

  @override
  String get dailyChecklistSalawat => 'Salawat / Durood';

  @override
  String get dailyChecklistControlAngerSpeakKindly =>
      'Controlar la ira / Hablar con amabilidad';

  @override
  String get digitalBalanceTitle => 'Equilibrio digital';

  @override
  String get digitalBalanceSubtitle => 'Mira a dónde va tu tiempo';

  @override
  String get digitalBalanceViewCta => 'Ver equilibrio digital →';

  @override
  String get digitalBalanceTodayLabel => 'Hoy';

  @override
  String get digitalBalanceDeenFocus => 'DeenFocus';

  @override
  String get digitalBalanceOtherApps => 'Otras apps';

  @override
  String get digitalBalanceTodayPhoneTime => 'Tiempo de teléfono de hoy';

  @override
  String get digitalBalanceWhereTimeGoes => 'A dónde va tu tiempo';

  @override
  String get digitalBalanceViewAllApps => 'Ver todas las apps';

  @override
  String get digitalBalanceAllAppsTitle => 'Todas las apps';

  @override
  String get digitalBalanceNoApps => 'Aún no hay uso de apps registrado hoy.';

  @override
  String get digitalBalanceDeenVsDigital => 'Deen frente al tiempo digital';

  @override
  String get digitalBalanceYourWeek => 'Tu semana';

  @override
  String get digitalBalanceThisWeek => 'Esta semana';

  @override
  String get digitalBalancePhoneUsageLegend => 'Uso del teléfono';

  @override
  String get digitalBalanceDailyInsight => 'Nota del día';

  @override
  String get digitalBalanceInsightKeepGoing =>
      'Cada minuto que fortalece tu Deen importa.';

  @override
  String get digitalBalanceInsightWeekHigher =>
      'Tu tiempo en DeenFocus es mayor esta semana que la anterior. ¡MashaAllah!';

  @override
  String get digitalBalanceInsightQuietDay =>
      'Un día tranquilo por ahora. El tiempo en DeenFocus aparecerá aquí.';

  @override
  String get digitalBalanceGoalTitle => 'Tu meta de tiempo de Deen';

  @override
  String get digitalBalanceAdjustGoal => 'Ajustar meta';

  @override
  String get digitalBalanceGoalReached =>
      'Alcanzaste la meta de hoy. ¡MashaAllah!';

  @override
  String get digitalBalanceGoalSheetTitle => 'Tiempo de Deen diario';

  @override
  String get digitalBalanceGoalCustomHint => 'Minutos por día';

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
  String get digitalBalancePermissionTitle => 'Comprende tus hábitos digitales';

  @override
  String get digitalBalancePermissionBody =>
      'Permite que DeenFocus acceda al uso de tus apps para ver a dónde va tu tiempo y cuánto das a tu Deen.';

  @override
  String get digitalBalanceEnableUsage => 'Activar uso de apps';

  @override
  String get digitalBalanceMaybeLater => 'Quizá más tarde';

  @override
  String get digitalBalanceUnavailableTitle =>
      'El uso de apps no está disponible aquí';

  @override
  String get digitalBalanceUnavailableBody =>
      'Apple no comparte Tiempo en pantalla con otras apps, así que Digital Balance aún no puede mostrar el uso del iPhone. Tus oraciones, rachas e insights siguen funcionando.';

  @override
  String get digitalBalanceInfoTitle => 'Sobre el equilibrio digital';

  @override
  String get digitalBalanceInfoBody =>
      'El equilibrio digital te ayuda a ver a dónde va tu tiempo y cuánto das a tu Deen. El uso permanece en tu dispositivo.';

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
    return 'DeenFocus · $percent% del tiempo de teléfono';
  }

  @override
  String digitalBalancePercentOfPhoneTime(int percent) {
    return 'DeenFocus = $percent% de tu tiempo de teléfono';
  }

  @override
  String digitalBalancePercentToday(int percent) {
    return '$percent% del tiempo de teléfono de hoy';
  }

  @override
  String digitalBalanceRingLabel(int percent) {
    return '$percent%\nDeenFocus';
  }

  @override
  String digitalBalanceWeekMoreDeen(int percent) {
    return '↑ $percent% más de tiempo en DeenFocus que la semana pasada';
  }

  @override
  String digitalBalanceInsightTimeToday(String duration) {
    return 'Pasaste $duration en DeenFocus hoy. Sigue el hábito.';
  }

  @override
  String digitalBalanceInsightIncreasedYesterday(int percent) {
    return 'Tu tiempo en DeenFocus aumentó un $percent% respecto a ayer.';
  }

  @override
  String digitalBalanceGoalPerDay(String goal) {
    return '$goal / día';
  }

  @override
  String digitalBalanceGoalProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String digitalBalanceMinutesToGoal(int minutes) {
    return '$minutes minutos para alcanzar la meta de hoy';
  }

  @override
  String get tajweedPracticeTitle => 'Práctica de tayyid';

  @override
  String tajweedPracticeAyahTitle(String surah, String ref) {
    return '$surah · $ref';
  }

  @override
  String get tajweedDownloadTitle => 'Preparando el modelo de IA';

  @override
  String get tajweedDownloadFailedTitle =>
      'No se pudo preparar el modelo de IA';

  @override
  String get tajweedDownloadBody =>
      'Descarga única para que la práctica de tayyid funcione totalmente sin conexión después. Solo ocurre una vez.';

  @override
  String get tajweedDownloadFinishing => 'Finalizando la configuración…';

  @override
  String get tajweedDownloadCanLeave =>
      'Puedes salir de esta pantalla: la descarga continúa en segundo plano.';

  @override
  String get tajweedDownloadTryAgain => 'Reintentar';

  @override
  String get tajweedDownloadPleaseTryAgain => 'Inténtalo de nuevo.';

  @override
  String get tajweedErrorFeatureDisabled =>
      'La práctica de tayyid con IA está desactivada. Actívala primero en Ajustes.';

  @override
  String get tajweedErrorModelMissing =>
      'El modelo de IA aún no está instalado.';

  @override
  String get tajweedErrorModelDownloadFailed =>
      'Falló la descarga del modelo de IA. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String get tajweedErrorModelLoadFailed =>
      'No se pudo cargar el modelo de IA en este dispositivo.';

  @override
  String get tajweedErrorCouldNotPrepare =>
      'No se pudo preparar el modelo de IA.';

  @override
  String get tajweedErrorUnsupported =>
      'La práctica de tayyid con IA no está disponible en este dispositivo.';

  @override
  String get sharePromoTitle => 'Mira esto en DeenFocus 🌙';

  @override
  String get sharePromoBody =>
      'Una app sencilla para mantenerte enfocado en tu Deen, orar a tiempo y crear mejores hábitos.';

  @override
  String get sharePromoDownloadHeading => 'Descarga DeenFocus:';

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
  String get shareBrandTagline => 'Tu compañero para un mejor Deen, cada día.';

  @override
  String get shareDownloadCta => 'Descargar DeenFocus';

  @override
  String get shareAppStoreBadge => 'App Store';

  @override
  String get sharePlayStoreBadge => 'Google Play';

  @override
  String get shareFailed => 'No se pudo compartir. Inténtalo de nuevo.';

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
  String get insightsLevelName1 => 'Nuevo comienzo';

  @override
  String get insightsLevelName2 => 'Primeros pasos';

  @override
  String get insightsLevelName3 => 'Crear el hábito';

  @override
  String get insightsLevelName4 => 'Orante constante';

  @override
  String get insightsLevelName5 => 'Corazón constante';

  @override
  String get insightsLevelName6 => 'Guardián de la oración';

  @override
  String get insightsLevelName7 => 'Siervo dedicado';

  @override
  String get insightsLevelName8 => 'Rutina sólida';

  @override
  String get insightsLevelName9 => 'Orante devoto';

  @override
  String get insightsLevelName10 => 'Firme';

  @override
  String get insightsLevelName11 => 'Fe más profunda';

  @override
  String get insightsLevelName12 => 'Gran constancia';

  @override
  String get insightsLevelName13 => 'Líder en devoción';

  @override
  String get insightsLevelName14 => 'Constancia excepcional';

  @override
  String get insightsLevelName15 => 'DeenFocus Master';

  @override
  String get lockScreenOptionsTitle => 'Estilo de pantalla de bloqueo';

  @override
  String get lockScreenOptionsSubtitle =>
      'Elige cómo aparecen los recordatorios de oración';

  @override
  String get lockScreenOptionsHint =>
      'Toca un estilo para abrir el diseño a pantalla completa.';

  @override
  String get lockScreenDefaultBadge => 'Predeterminado';

  @override
  String get lockScreenSelectedBadge => 'Seleccionado';

  @override
  String get lockScreenPreviewLabel => 'Vista previa';

  @override
  String get lockScreenStyleClassic => 'Recordatorio de oración';

  @override
  String get lockScreenStyleTasbih => 'Contador de tasbih';

  @override
  String get lockScreenStyleVerse => 'Versículo diario';

  @override
  String get lockScreenStyleDua => 'Dua diaria';

  @override
  String get lockScreenStyleQuiz => 'Comprobación de conocimientos';

  @override
  String get lockScreenStyleTimes => 'Horarios de oración';

  @override
  String get lockScreenStyleCountdown => 'Cuenta atrás';

  @override
  String get lockScreenStyleHold => 'Mantén pulsado para confirmar';

  @override
  String get lockScreenStyleType => 'Escribe para confirmar';

  @override
  String get lockScreenStyleMinimal => 'Enfoque mínimo';

  @override
  String get lockScreenItsTimeToPray => 'Es hora de orar:';

  @override
  String lockScreenRemainingTime(String time) {
    return 'Tiempo restante: $time';
  }

  @override
  String get lockScreenRemindLater => 'Recuérdame más tarde';

  @override
  String get lockScreenNextVerse => 'Siguiente versículo';

  @override
  String get lockScreenVerseForToday => 'Versículo de hoy';

  @override
  String get lockScreenDuaForToday => 'Dua de hoy';

  @override
  String get lockScreenTapToCount => 'Toca en cualquier lugar para contar';

  @override
  String get lockScreenHoldHint => 'Mantén pulsado para confirmar';

  @override
  String lockScreenTypeHint(String word) {
    return 'Escribe $word para confirmar';
  }

  @override
  String get lockScreenTypeWord => 'ALHAMDULILLAH';

  @override
  String get lockScreenConfirmBeforeAllah =>
      'Confirma ante Allah que has orado.';

  @override
  String get lockScreenQuizCategory => 'Oración';

  @override
  String get lockScreenQuizQuestion =>
      '¿Cuántas oraciones diarias son obligatorias?';

  @override
  String get lockScreenQuizA => 'Tres';

  @override
  String get lockScreenQuizB => 'Cuatro';

  @override
  String get lockScreenQuizC => 'Cinco';

  @override
  String get lockScreenQuizCorrect => 'Correcto';

  @override
  String get lockScreenQuizIncorrect => 'Incorrecto';

  @override
  String get lockScreenQuizComplete =>
      'Comprobación de conocimientos completada';

  @override
  String get lockScreenQuizCategoryFasting => 'Ayuno';

  @override
  String get lockScreenQuizCategoryPillars => 'Pilares';

  @override
  String get lockScreenQuizQ2 => '¿En qué mes ayunan los musulmanes?';

  @override
  String get lockScreenQuizQ2A => 'Shawwal';

  @override
  String get lockScreenQuizQ2B => 'Ramadán';

  @override
  String get lockScreenQuizQ2C => 'Muharram';

  @override
  String get lockScreenQuizQ3 => '¿Cuál es el primer pilar del islam?';

  @override
  String get lockScreenQuizQ3A => 'Salat';

  @override
  String get lockScreenQuizQ3B => 'Shahada';

  @override
  String get lockScreenQuizQ3C => 'Hajj';

  @override
  String get lockScreenTimeUp => 'Se acabó el tiempo';

  @override
  String get lockScreenHoldRelease => 'Sigue pulsando para confirmar';

  @override
  String lockScreenCountProgress(int current, int total) {
    return '$current de $total';
  }

  @override
  String get lockScreenVerseTranslation =>
      'Acordaos de Mí, que Yo me acordaré de vosotros.';

  @override
  String get lockScreenVerseRef => 'Corán 2:152';

  @override
  String get lockScreenDuaTransliteration => 'Rabbana atina fid-dunya hasanah';

  @override
  String get lockScreenDuaTranslation =>
      'Señor nuestro, danos bien en este mundo y bien en el Más Allá.';

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
  String get homeTajweedPromoTitle => 'Tajweed del Corán con IA';

  @override
  String get homeTajweedPromoBody =>
      'Recita cualquier versículo y recibe al instante comentarios de IA sobre tu tajweed.';

  @override
  String get homeTajweedPromoCta => 'Practicar tajweed';

  @override
  String get homeTajweedPromoAiFeedback => 'Comentarios de IA';

  @override
  String homeTajweedPromoWordAccuracy(int percent) {
    return '$percent % precisión de palabras';
  }

  @override
  String get homeLockScreenPromoTitle => 'Estilos de pantalla de bloqueo';

  @override
  String get homeLockScreenPromoBody =>
      'Personaliza tu pantalla de bloqueo con diseños islámicos y recordatorios útiles.';

  @override
  String get homeLockScreenPromoCta => 'Explorar estilos';

  @override
  String get homePromoNewBadge => 'NUEVO';

  @override
  String get homeReadQuranPromoTitle => 'Leer el Corán';

  @override
  String get homeReadQuranPromoSubtitle => 'Lee, escucha y practica el tajweed';

  @override
  String get homeReadQuranPromoCta => 'Abrir Corán';

  @override
  String get homeReadQuranPromoNewBadge => 'Nuevo';

  @override
  String cycleModeActiveStatus(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Racha protegida • Termina en $days días',
      one: 'Racha protegida • Termina mañana',
      zero: 'Racha protegida • Termina hoy',
    );
    return '$_temp0';
  }

  @override
  String get cycleModeProtectPrayerStreakSubtitle =>
      'Mantén tu racha intacta durante los días del ciclo';

  @override
  String get cycleModeExcludeFromStatisticsSubtitle =>
      'No contar los días del ciclo en tus estadísticas de oración';

  @override
  String get homePromoPreviewCity => 'Lahore';

  @override
  String get focusScreenTimeAuthPasscodeRequired =>
      'Este iPhone necesita un código de dispositivo antes de que Apple permita el acceso a Tiempo en pantalla. Configúralo en Ajustes e inténtalo de nuevo.';

  @override
  String get focusScreenTimeAuthCanceled =>
      'Se canceló el acceso a Tiempo en pantalla antes de que Apple lo concediera. Vuelve a intentarlo y completa el aviso de Apple.';

  @override
  String get focusScreenTimeAuthConflict =>
      'Otra app ya gestiona Controles parentales en este iPhone. Desactívala primero e inténtalo de nuevo.';

  @override
  String get focusScreenTimeAuthInvalidAccount =>
      'Inicia sesión con una cuenta de iCloud válida en este iPhone e intenta de nuevo el acceso a Tiempo en pantalla.';

  @override
  String get focusScreenTimeAuthNetwork =>
      'Este iPhone necesita conexión a internet para que Apple conceda el acceso a Tiempo en pantalla.';

  @override
  String get focusScreenTimeAuthRestricted =>
      'Los Controles parentales están restringidos en este iPhone, así que DeenFocus no puede solicitar el acceso a Tiempo en pantalla aquí.';

  @override
  String get focusScreenTimeAuthUnavailable =>
      'Los Controles parentales no están disponibles ahora en este iPhone.';

  @override
  String get focusScreenTimeAuthIosVersion =>
      'El bloqueo de apps con Tiempo en pantalla requiere iOS 16 o posterior.';

  @override
  String get focusScreenTimeAuthInvalidArgument =>
      'La solicitud de autorización de Tiempo en pantalla no es válida. Inténtalo de nuevo.';

  @override
  String get focusScreenTimeAuthFailedGeneric =>
      'No se pudo conceder el acceso a Tiempo en pantalla en este iPhone.';

  @override
  String widgetLockCountdownHoursMinutes(String hours, String minutes) {
    return 'En $hours h $minutes min';
  }

  @override
  String widgetLockCountdownMinutes(String minutes) {
    return 'En $minutes min';
  }

  @override
  String get lockScreenRecommendedBadge => 'Recomendado';
}
