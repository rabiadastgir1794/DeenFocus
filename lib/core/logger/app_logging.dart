import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'anr_watchdog.dart';
import 'log_level.dart';
import 'logger_service.dart';
import 'performance_monitor.dart';

/// One-shot wiring for production diagnostics on Android (especially low-tier OEMs).
///
/// **Call order:** invoke [installFrameworkHooks] only after
/// [WidgetsFlutterBinding.ensureInitialized], and after [LoggerService.initialize]
/// so the first framework errors can be persisted.
abstract final class AppLogging {
  static RawReceivePort? _isolateErrorPort;

  /// Captures synchronous framework failures (build/layout) and forwards to the
  /// default presenter so debug builds keep red screens / console output.
  static void installFrameworkHooks() {
    final previousFlutterOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      unawaited(LoggerService.instance.logFlutterFrameworkError(details));
      if (previousFlutterOnError != null) {
        previousFlutterOnError(details);
      } else {
        FlutterError.presentError(details);
      }
    };

    /// Async errors that skip `try/catch` — common when `await` is forgotten on
    /// futures created in event handlers (clicks, platform callbacks).
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      unawaited(
        LoggerService.instance.log(
          LogLevel.critical,
          'PLATFORM',
          'PlatformDispatcher.onError (uncaught async / native callback)',
          error: error,
          stackTrace: stack,
        ),
      );
      return true;
    };

    _installIsolateErrorListener();

    /// Frame timings — jank classification for GPU/CPU-bound devices.
    PerformanceMonitor.install();

    /// Best-effort freeze detector when the UI isolate stops making progress.
    ANRWatchdog.instance.start();
  }

  /// Zone handler for [runZonedGuarded] — catches errors that escape `main` and
  /// microtasks scheduled inside the guarded zone.
  static void recordZoneError(Object error, StackTrace stack) {
    unawaited(
      LoggerService.instance.log(
        LogLevel.critical,
        'ZONE',
        'runZonedGuarded caught error',
        error: error,
        stackTrace: stack,
      ),
    );
  }

  /// Optional teardown (tests / hot restart edge cases).
  static void dispose() {
    _isolateErrorPort?.close();
    _isolateErrorPort = null;
    ANRWatchdog.instance.dispose();
  }

  static void _installIsolateErrorListener() {
    _isolateErrorPort?.close();
    final port = RawReceivePort((dynamic message) {
      if (message is! List<dynamic> || message.isEmpty) return;
      final err = message[0];
      final st = message.length > 1 ? message[1] : null;
      LoggerService.instance.critical(
        'ISOLATE',
        'Isolate.addErrorListener: $err',
        stackTrace: st is StackTrace ? st : null,
      );
    });
    Isolate.current.addErrorListener(port.sendPort);
    _isolateErrorPort = port;
  }
}
