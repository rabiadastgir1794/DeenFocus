// main.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_router.dart';
import 'core/constants/app_languages.dart';
import 'core/logger/app_logging.dart';
import 'core/logger/logger_service.dart';
import 'core/logger/trace_helpers.dart';
import 'core/services/app_notification_service.dart';
import 'core/services/daily_refresh_service.dart';
import 'core/services/locale_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/user_profile_service.dart';
import 'core/services/widget_sync_service.dart';
import 'core/superwall/app_superwall.dart';
import 'core/theme/app_theme.dart';
import 'features/focus/viewmodel/focus_controller.dart';
import 'features/home/view/settings/app_demo_video_manager.dart';
import 'features/tasbih/data/tasbih_local_repository.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      MediaKit.ensureInitialized();

      final startupWatch = Stopwatch()..start();
      await LoggerService.instance.initialize();
      AppLogging.installFrameworkHooks();
      LoggerService.instance.info(
        'STARTUP',
        'binding + logger hooks installed ${startupWatch.elapsedMilliseconds}ms',
      );

      await TraceHelpers.traceDatabase(
        'hive_init',
        () => Hive.initFlutter(),
        logSuccess: true,
      );
      LoggerService.instance.info(
        'STARTUP',
        'Hive.initFlutter done ${startupWatch.elapsedMilliseconds}ms',
      );

      // Pre-warm subscription notifier from local cache so premium gates can
      // open immediately on cold start without showing the loader.
      unawaited(AppSuperwall.loadCachedState());

      /// Configure Superwall ONCE in the background. Splash must not block on it —
      /// premium gates will wait for [AppSuperwall.configure] when first invoked.
      unawaited(
        TraceHelpers.traceAsync(
          'STARTUP',
          'AppSuperwall.configure (background)',
          AppSuperwall.configure,
          logSuccess: true,
        ),
      );

      runApp(const DeenlyApp());
      LoggerService.instance.info(
        'STARTUP',
        'runApp scheduled ${startupWatch.elapsedMilliseconds}ms',
      );
      unawaited(_initializeServices());
    },
    AppLogging.recordZoneError,
  );
}

Future<void> _initializeServices() async {
  unawaited(TasbihLocalRepository.instance.ensureInitialized());
  unawaited(DailyRefreshService.instance.initialize());
  unawaited(AppNotificationService.instance.initialize());
}

class DeenlyApp extends StatefulWidget {
  const DeenlyApp({super.key});

  @override
  State<DeenlyApp> createState() => _DeenlyAppState();
}

class _DeenlyAppState extends State<DeenlyApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => UserProfileService()),
        ChangeNotifierProvider(create: (_) => FocusController()),
        ChangeNotifierProvider(create: (_) => AppDemoVideoManager()),
      ],
      child: _AppLifecycleObserver(
        child: _DeenlyMaterialApp(router: _router),
      ),
    );
  }
}

class _AppLifecycleObserver extends StatefulWidget {
  const _AppLifecycleObserver({
    required this.child,
  });

  final Widget child;

  @override
  State<_AppLifecycleObserver> createState() =>
      _AppLifecycleObserverState();
}

class _AppLifecycleObserverState
    extends State<_AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppSuperwall.subscriptionActiveNotifier.addListener(
      _handleSubscriptionChanged,
    );
    // [DashboardScreen] lazy-builds non-selected tabs as [SizedBox.shrink], so
    // [FocusTabScreen] (and its post-frame [FocusController.initialize]) never
    // runs until the user opens Focus. Home reads the same controller for the
    // lock/unlock card — warm it once after first frame so UI matches storage
    // without blocking the initial build (heavy work stays async in the controller).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(context.read<FocusController>().initialize());
      unawaited(_syncSubscriptionAndDisableFocusModesIfNeeded());
    });
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
    return widget.child;
  }
}

class _DeenlyMaterialApp extends StatelessWidget {
  const _DeenlyMaterialApp({
    required this.router,
  });

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final locale = context.select<LocaleService, Locale?>(
              (service) => service.locale,
        );

        final themeMode = context.select<ThemeService, ThemeMode>(
              (service) => service.themeMode,
        );

        return MaterialApp.router(
          title: 'Deenly',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates:
          AppLocalizations.localizationsDelegates,
          supportedLocales: kSupportedLocales,
          routerConfig: router,
        );
      },
    );
  }
}
