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
  String get locationManualEntry => 'O introduce tu ciudad';

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
  String get notificationsPreviewAdhanBody =>
      'Es hora de orar. Las apps están pausadas.';

  @override
  String get notificationsPreviewDhikrTitle => 'DHIKR DIARIO';

  @override
  String get notificationsPreviewDhikrBody =>
      'SubhanAllah — tómate un minuto para recordar.';

  @override
  String get notificationsPreviewStreakTitle => 'RACHA';

  @override
  String get notificationsPreviewStreakBody =>
      '7 días de oraciones completas. ¡Sigue así!';

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
  String get homeSearchNearbyMosques => 'Buscar mezquitas cercanas.';

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
  String get calendarTitle => 'Calendario Islámico';

  @override
  String get calendarBack => 'Back';

  @override
  String get calendarToday => 'Hoy';

  @override
  String get calendarTomorrow => 'Mañana';

  @override
  String calendarDaysAway(int days) {
    return '$days días';
  }

  @override
  String get calendarNoEventsThisWeek => 'No hay eventos islámicos esta semana';

  @override
  String get calendarNoEventsBlessing =>
      'May Allah bless your week with peace and goodness.';

  @override
  String get calendarNoUpcomingEvents => 'No upcoming Islamic events found.';

  @override
  String get calendarUpcomingEvents => 'Próximos Eventos Islámicos';

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
  String get calendarEventJumuah => 'Yumu\'ah';

  @override
  String get calendarEventJumuahDesc => 'Oración congregacional del viernes';

  @override
  String get calendarEventWhiteDays => 'Días blancos';

  @override
  String get calendarEventWhiteDaysDesc => 'Del 13 al 15 de cada mes';

  @override
  String get cycleModeActiveTitle =>
      '«Allah desea para vosotros la facilidad y no desea para vosotros la dificultad.» — Corán 2:185';

  @override
  String get cycleModeActiveSubtitle =>
      'Durante este período, tu racha está protegida. Los días del ciclo se destacan en rosa y el Modo ciclo se desactiva automáticamente al terminar el ciclo.';

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
  String get cycleModePauseStreaksLabel => 'Pausar rachas';

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
  String get dailyChecklistSectionDistraction => 'Control de distracción';

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
  String get supportUsEmailSubject => 'Solicitud de soporte DeenFocus';

  @override
  String get supportUsLaunchUnavailable =>
      'No se pudo abrir esa app en este dispositivo.';

  @override
  String get supportUsLaunchFailed => 'Algo salió mal. Inténtalo de nuevo.';

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
  String get tabQuran => 'Corán';

  @override
  String get tabLearn => 'Aprender';

  @override
  String get quranLoadFailed => 'No se pudieron cargar los datos del Corán';

  @override
  String get quranTabSubtitle => 'Leer y explorar el Sagrado Corán';

  @override
  String get quranSearchHint => 'Buscar sura...';

  @override
  String get quranNoSurahsFound => 'No se encontraron suras';

  @override
  String get quranVersesLabel => 'versos';

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
      'Mantente constante. Mantente consciente.\nMantente conectado con tu Deen.';

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
  String get nearbyMosquesTitle => 'Mezquitas cercanas';

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
  String get nearbyMosquesSearchRadius => 'Radio de búsqueda: 5 km';

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
  String get nearbyMosquesNoneWithinRadius =>
      'No se encontraron mezquitas en 5 km';

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
  String get nearbyMosquesEmptyHint =>
      'No hay resultados dentro de 5 km en OpenStreetMap para este punto. Inténtalo más tarde o mueve el mapa.';

  @override
  String nearbyMosquesFoundWithin(int count) {
    return '$count mezquitas encontradas dentro de 5 km';
  }

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
    return '$count prayers';
  }

  @override
  String get insightsPrayersInARow => 'Oraciones seguidas';

  @override
  String get insightsDaysInARow => 'Días seguidos';

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
  String get insightsFocusExcellent => '¡Excelente — sigue así!';

  @override
  String get insightsFocusKeepGoing => 'Sigue construyendo tu enfoque';

  @override
  String get insightsTodaysPrayers => 'Oraciones de hoy';

  @override
  String get insightsPrayersCompletedLabel =>
      'Prayers completed — Alhamdulillah!';

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
  String insightsCycleModeFooter(int days) {
    return 'Cycle Mode days are protected and not counted as streak breaks. You have $days protected day(s) available.';
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
}
