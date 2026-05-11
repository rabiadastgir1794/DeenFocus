import 'package:flutter/widgets.dart';

/// Shared signals between frame instrumentation and the ANR heuristic.
///
/// **Why this exists:** [PerformanceMonitor] and [ANRWatchdog] must agree on what
/// "forward progress" means. On low-end GPUs, raster times dominate; counting
/// only build time misses freezes that still feel like ANRs to users.
///
/// **What it diagnoses:** long gaps without any completed frame pipeline work —
/// a practical proxy when Java thread dumps are unavailable from Dart alone.
class LoggingTelemetry {
  LoggingTelemetry._();

  /// Last time we observed frame timings from the engine (end of frame work).
  static DateTime lastFrameActivity = DateTime.now();

  /// Last known app lifecycle state so the watchdog ignores backgrounding.
  static AppLifecycleState lifecycleState = AppLifecycleState.resumed;

  static void markFrameActivity([DateTime? at]) {
    lastFrameActivity = at ?? DateTime.now();
  }

  static void markLifecycle(AppLifecycleState state) {
    lifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      markFrameActivity();
    }
  }
}
