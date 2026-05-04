import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player_android/video_player_android.dart';
import 'package:video_player_avfoundation/video_player_avfoundation.dart';

import 'app/routes/app_router.dart';
import 'core/constants/app_languages.dart';
import 'core/superwall/app_superwall.dart';
import 'core/services/app_notification_service.dart';
import 'core/services/daily_refresh_service.dart';
import 'core/services/locale_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/user_profile_service.dart';
import 'core/theme/app_theme.dart';
import 'features/focus/viewmodel/focus_controller.dart';
import 'features/home/view/settings/app_demo_video_manager.dart';
import 'features/tasbih/data/tasbih_local_repository.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        AVFoundationVideoPlayer.registerWith();
        break;
      case TargetPlatform.android:
        AndroidVideoPlayer.registerWith();
        break;
      default:
        break;
    }
  }
  await Hive.initFlutter();
  await AppSuperwall.configureIfNeeded();
  if (AppSuperwall.isEnabled) {
    await AppSuperwall.syncAttributesAndResolvePaywallRoute();
  }
  await AppNotificationService.instance.initialize();
  unawaited(TasbihLocalRepository.instance.ensureInitialized());
  unawaited(DailyRefreshService.instance.initialize());
  runApp(const DeenlyApp());
}

class DeenlyApp extends StatefulWidget {
  const DeenlyApp({super.key});

  @override
  State<DeenlyApp> createState() => _DeenlyAppState();
}

class _DeenlyAppState extends State<DeenlyApp> {
  late final _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => UserProfileService()),
        ChangeNotifierProvider(create: (_) => FocusController()..initialize()),
        ChangeNotifierProvider(create: (_) => AppDemoVideoManager()),
      ],
      child: _AppLifecycleFocusRefresher(
        child: _DeenlyMaterialApp(router: _router),
      ),
    );
  }
}

/// Refreshes focus lock state whenever the app returns to foreground so
/// prayer windows stay aligned even if the user was on a tab without its own observer.
class _AppLifecycleFocusRefresher extends StatefulWidget {
  const _AppLifecycleFocusRefresher({required this.child});

  final Widget child;

  @override
  State<_AppLifecycleFocusRefresher> createState() =>
      _AppLifecycleFocusRefresherState();
}

class _AppLifecycleFocusRefresherState
    extends State<_AppLifecycleFocusRefresher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_onResumed());
    }
  }

  Future<void> _onResumed() async {
    if (AppSuperwall.isEnabled) {
      await AppSuperwall.syncAttributesAndResolvePaywallRoute();
      if (!mounted) return;
      if (!AppSuperwall.subscriptionActiveNotifier.value) {
        await context.read<FocusController>().disableAllModesDueToSubscription();
      }
    }
    if (!mounted) return;
    unawaited(context.read<FocusController>().refresh());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _DeenlyMaterialApp extends StatelessWidget {
  const _DeenlyMaterialApp({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer2<LocaleService, ThemeService>(
          builder: (context, localeService, themeService, _) {
            return MaterialApp.router(
              title: AppLocalizations.of(context)?.appTitle ?? 'Deenly',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeService.themeMode,
              locale: localeService.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: kSupportedLocales,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}
