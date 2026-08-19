import 'dart:async';

import 'package:flutter/widgets.dart';

import 'log_level.dart';
import 'logger_service.dart';
import 'startup_probe.dart';

/// Binds [LoggerService.currentScreen] from route names for every log line.
///
/// **Why:** support tickets without reproduction steps still need context —
/// knowing the user was on `home` vs `paywall` narrows crash hypotheses fast.
class LoggingNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    StartupProbe.detail(
      'NAV didPush name=${route.settings.name} type=${route.runtimeType}',
    );
    super.didPush(route, previousRoute);
    _update(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    StartupProbe.detail(
      'NAV didReplace new=${newRoute?.settings.name} old=${oldRoute?.settings.name}',
    );
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _update(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    StartupProbe.detail(
      'NAV didPop name=${route.settings.name} → ${previousRoute?.settings.name}',
    );
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _update(previousRoute);
    }
  }

  void _update(Route<dynamic> route) {
    final name = route.settings.name;
    final label = (name != null && name.isNotEmpty)
        ? name
        : route.settings.arguments?.toString() ?? route.runtimeType.toString();
    LoggerService.instance.currentScreen = label;
    unawaited(
      LoggerService.instance.log(
        LogLevel.debug,
        'NAV',
        'activeRoute=$label',
      ),
    );
  }
}
