// main.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_router.dart';
import 'core/constants/app_languages.dart';
import 'core/logger/app_logging.dart';
import 'core/logger/logger_service.dart';
import 'core/logger/startup_handoff.dart';
import 'core/logger/startup_probe.dart';
import 'core/logger/timed_app_localizations_delegate.dart';
import 'core/logger/trace_helpers.dart';
import 'core/services/storage_service.dart';
import 'core/services/app_notification_service.dart';
import 'core/services/daily_refresh_service.dart';
import 'core/services/locale_service.dart';
import 'core/services/prayer_alarm_service.dart';
import 'core/services/prayer_live_activity_service.dart';
import 'core/services/quran_translation_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/user_profile_service.dart';
import 'core/services/widget_sync_service.dart';
import 'core/superwall/app_superwall.dart';
import 'core/theme/app_theme.dart';
import 'features/focus/viewmodel/focus_controller.dart';
import 'features/home/services/prayer_settings_service.dart';
import 'features/tasbih/data/tasbih_local_repository.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    StartupProbe.start();
    WidgetsFlutterBinding.ensureInitialized();
    StartupProbe.mark('1_WidgetsFlutterBinding.ensureInitialized');

    // Logger file I/O must not block first frame (see LoggerService.initialize).
    unawaited(LoggerService.instance.initialize());
    AppLogging.installFrameworkHooks();
    StartupProbe.mark('2_logger hooks installed');

    try {
      StartupProbe.detail(
        'Hive: probing path_provider.getApplicationDocumentsDirectory',
      );
      final docs = await getApplicationDocumentsDirectory();
      StartupProbe.detail('Hive: path_provider OK path=${docs.path}');
      final hive = Hive.initFlutter();
      final onboarding = StorageService.warmOnboardingCompleted();
      await hive;
      StartupProbe.mark('3_Hive.initFlutter done');
      try {
        await onboarding;
        StartupProbe.mark('onboardingCompleted warmed');
      } catch (e) {
        debugPrint('[STARTUP] onboardingCompleted warm failed: $e');
      }
    } catch (e, st) {
      debugPrint('[STARTUP] Hive.initFlutter / path_provider FAILED: $e');
      debugPrint('[STARTUP] stack:\n$st');
      rethrow;
    }

    // Pre-warm subscription notifier from local cache so premium gates can
    // open immediately on cold start without showing the loader.
    unawaited(AppSuperwall.loadCachedState());

    runApp(const DeenlyApp());
    StartupProbe.mark('4_runApp');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupProbe.mark('5_first Flutter frame');
      StartupProbe.dumpSummary();
    });

    // Alarms / translations after the first Home (or onboarding) paint.
    // Superwall.configure spawns WKWebView — wait one extra frame so it does
    // not race Home layout (see firstDestinationIdle).
    unawaited(
      StartupHandoff.firstDestinationFrame.then((_) {
        StartupProbe.detail(
          '_initializeServices: after first destination frame',
        );
        unawaited(_initializeServices());
      }),
    );
    unawaited(
      StartupHandoff.firstDestinationIdle.then((_) {
        StartupProbe.mark('Superwall.configure scheduled (after Home idle)');
        unawaited(
          TraceHelpers.traceAsync(
            'STARTUP',
            'AppSuperwall.configure (after destination idle)',
            AppSuperwall.configure,
            logSuccess: true,
          ),
        );
      }),
    );
  }, AppLogging.recordZoneError);
}

Future<void> _initializeServices() async {
  StartupProbe.detail('_initializeServices: begin');
  unawaited(TasbihLocalRepository.instance.ensureInitialized());
  unawaited(DailyRefreshService.instance.initialize());
  unawaited(AppNotificationService.instance.initialize());
  unawaited(PrayerAlarmService.instance.initialize());
  QuranTranslationService.attachLifecycleRetry();
  unawaited(QuranTranslationService.ensureDefaultTranslationInBackground());
  StartupProbe.detail('_initializeServices: scheduled');
}

class DeenlyApp extends StatefulWidget {
  const DeenlyApp({super.key});

  @override
  State<DeenlyApp> createState() => _DeenlyAppState();
}

class _DeenlyAppState extends State<DeenlyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    StartupProbe.mark('DeenlyApp.initState begin');
    _router = StartupProbe.timeSync('createAppRouter()', createAppRouter);
    StartupProbe.mark('DeenlyApp.initState end');
  }

  @override
  Widget build(BuildContext context) {
    StartupProbe.mark('DeenlyApp.build begin');
    final tree = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => UserProfileService()),
        ChangeNotifierProvider(create: (_) => PrayerSettingsService()),
        ChangeNotifierProvider(create: (_) => FocusController()),
      ],
      child: _AppLifecycleObserver(child: _DeenlyMaterialApp(router: _router)),
    );
    StartupProbe.mark('DeenlyApp.build end');
    return tree;
  }
}

class _AppLifecycleObserver extends StatefulWidget {
  const _AppLifecycleObserver({required this.child});
  //
  final Widget child;

  @override
  State<_AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<_AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    StartupProbe.mark('_AppLifecycleObserver.initState begin');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppSuperwall.subscriptionActiveNotifier.addListener(
      _handleSubscriptionChanged,
    );
    unawaited(
      StartupHandoff.firstDestinationFrame.then((_) {
        if (!mounted) return;
        StartupProbe.detail(
          '_AppLifecycleObserver: FocusController.initialize after Home',
        );
        unawaited(context.read<FocusController>().initialize());
      }),
    );
    unawaited(
      StartupHandoff.firstDestinationIdle.then((_) {
        if (!mounted) return;
        unawaited(_syncSubscriptionAndDisableFocusModesIfNeeded());
      }),
    );
    StartupProbe.mark('_AppLifecycleObserver.initState end');
  }

  @override
  void dispose() {
    AppSuperwall.subscriptionActiveNotifier.removeListener(
      _handleSubscriptionChanged,
    );
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleSubscriptionChanged() {
    if (!mounted) return;
    if (!AppSuperwall.isEnabled) return;
    if (AppSuperwall.subscriptionActiveNotifier.value) return;
    unawaited(
      context.read<FocusController>().disableModesForInactiveSubscription(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_handleResume());
    }
  }

  /// OS signals memory pressure first on low-RAM devices before Java OOM kills.
  /// Logging here helps correlate jank / ANR heuristics with GC storms.
  @override
  void didHaveMemoryPressure() {
    LoggerService.instance.warning(
      'MEMORY',
      'didHaveMemoryPressure — OS is reclaiming memory',
    );
    super.didHaveMemoryPressure();
  }

  Future<void> _handleResume() async {
    /// Refresh only subscription state
    /// DO NOT configure again
    final subscriptionSynced = await AppSuperwall.syncSubscriptionState();

    if (!mounted) return;

    if (subscriptionSynced) {
      await _disableFocusModesIfSubscriptionInactive();
    }
    if (!mounted) return;

    unawaited(context.read<FocusController>().refresh());
    unawaited(WidgetSyncService.instance.syncTimeline());
    unawaited(PrayerLiveActivityService.instance.syncFromStorage());
  }

  Future<void> _syncSubscriptionAndDisableFocusModesIfNeeded() async {
    await AppSuperwall.configure();
    final subscriptionSynced = await AppSuperwall.syncSubscriptionState();
    if (!mounted) return;
    if (subscriptionSynced) {
      await _disableFocusModesIfSubscriptionInactive();
    }
  }

  Future<void> _disableFocusModesIfSubscriptionInactive() async {
    if (!AppSuperwall.isEnabled) return;
    if (AppSuperwall.subscriptionActiveNotifier.value) return;
    await context.read<FocusController>().disableModesForInactiveSubscription();
  }

  @override
  Widget build(BuildContext context) {
    StartupProbe.markOnce('_AppLifecycleObserver.build');
    return widget.child;
  }
}

class _DeenlyMaterialApp extends StatelessWidget {
  const _DeenlyMaterialApp({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    StartupProbe.mark('_DeenlyMaterialApp.build begin');
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        StartupProbe.markOnce('ScreenUtilInit.builder');
        final locale = context.select<LocaleService, Locale?>(
          (service) => service.locale,
        );

        final themeMode = context.select<ThemeService, ThemeMode>(
          (service) => service.themeMode,
        );
        final platformDark =
            MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark;
        final useDark = switch (themeMode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };
        // Building both Material 3 ThemeData objects on the first inflate
        // was ~half of the DeenlyApp.build → SplashScreen gap. The other
        // brightness is warmed after the first frame.
        final theme = useDark ? AppTheme.dark : AppTheme.light;
        StartupProbe.markOnce('MaterialApp.router themes ready');
        AppTheme.warmUnusedAfterFirstFrame(useDark: useDark);

        return MaterialApp.router(
          title: 'Deenly',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: theme,
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates: [
            const TimedAppLocalizationsDelegate(),
            ...AppLocalizations.localizationsDelegates.skip(1),
          ],
          supportedLocales: kSupportedLocales,
          routerConfig: router,
          builder: (context, child) {
            StartupProbe.markOnce(
              'MaterialApp.builder (after l10n; before/with router child)',
            );
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
