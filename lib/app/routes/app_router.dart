import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../core/logger/logging_navigation_observer.dart';
import '../../features/home/view/dashboard_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/onboarding/view/onboarding_flow_screen.dart';
import '../../features/tajweed/model/tajweed_practice_args.dart';
import '../../features/tajweed/view/tajweed_practice_screen.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final LoggingNavigationObserver _loggingNavigationObserver =
    LoggingNavigationObserver();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    observers: <NavigatorObserver>[_loggingNavigationObserver],
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingFlowScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.tajweedPractice,
        name: 'tajweedPractice',
        builder: (context, state) =>
            TajweedPracticeScreen(args: state.extra as TajweedPracticeArgs),
      ),
    ],
  );
}
