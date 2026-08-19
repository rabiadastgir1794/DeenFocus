import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/logger/logging_navigation_observer.dart';
import '../../core/logger/startup_probe.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/tajweed/model/tajweed_practice_args.dart';
import '../../features/tajweed/view/tajweed_practice_gate.dart';
import 'route_deferred_gates.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final LoggingNavigationObserver _loggingNavigationObserver =
    LoggingNavigationObserver();

/// Synchronous, lightweight router. Heavy screens load via deferred gates.
GoRouter createAppRouter() {
  StartupProbe.detail('createAppRouter: enter');
  final routes = StartupProbe.timeSync(
    'createAppRouter: build RouteBase list',
    () => <RouteBase>[
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) {
          StartupProbe.mark('GoRouter builder: SplashScreen');
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) {
          StartupProbe.mark('GoRouter builder: OnboardingRouteGate');
          return const OnboardingRouteGate();
        },
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) {
          StartupProbe.mark('GoRouter builder: HomeRouteGate');
          return const HomeRouteGate();
        },
      ),
      GoRoute(
        path: RouteNames.tajweedPractice,
        name: 'tajweedPractice',
        builder: (context, state) {
          StartupProbe.mark('GoRouter builder: TajweedPracticeGate');
          return TajweedPracticeGate(args: state.extra as TajweedPracticeArgs);
        },
      ),
    ],
  );
  final router = StartupProbe.timeSync(
    'createAppRouter: GoRouter() constructor',
    () => GoRouter(
      navigatorKey: _rootNavigatorKey,
      observers: <NavigatorObserver>[_loggingNavigationObserver],
      initialLocation: RouteNames.splash,
      redirect: (context, state) {
        StartupProbe.detail(
          'GoRouter.redirect loc=${state.uri} matched=${state.matchedLocation}',
        );
        return null; // no redirect — measurement only
      },
      routes: routes,
    ),
  );
  StartupProbe.detail('createAppRouter: exit');
  return router;
}
