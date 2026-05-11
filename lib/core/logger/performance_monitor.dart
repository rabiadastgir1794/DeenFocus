import 'dart:ui';

import 'package:flutter/scheduler.dart';

import 'logger_service.dart';
import 'logging_telemetry.dart';

/// Subscribes to engine frame timings to classify jank on weak Android GPUs/CPUs.
///
/// **Why:** Infinix/Tecno devices often show "frozen" UX while the Dart profiler
/// still looks idle — the bottleneck is in rasterization or shader compilation.
/// [SchedulerBinding.addTimingsCallback] surfaces what users feel as stutters.
///
/// **Thresholds (heuristic):** tuned for 60 Hz; on 90/120 Hz devices a stricter
/// budget would use [PlatformDispatcher.views] refresh rate — kept simple here
/// to avoid false alarms on variable refresh OEMs.
class PerformanceMonitor {
  PerformanceMonitor._();

  static bool _installed = false;

  /// Normal lag: just over one frame budget (debug noise, trend spotting).
  static const int _normalLagMs = 17;

  /// Severe lag: multiple missed frames — user-visible stutter.
  static const int _severeLagMs = 50;

  /// Frozen frame: tactile "ANR-like" pause before system watchdog fires.
  static const int _frozenFrameMs = 700;

  /// Avoid filling `stack_logs.txt` on 60 Hz devices where many frames land
  /// slightly above budget during animations.
  static DateTime? _lastNormalLagLog;

  static void install() {
    if (_installed) return;
    _installed = true;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  static void _onTimings(List<FrameTiming> timings) {
    LoggingTelemetry.markFrameActivity();
    for (final t in timings) {
      final totalMs = t.totalSpan.inMilliseconds;
      final buildMs = t.buildDuration.inMilliseconds;
      final rasterMs = t.rasterDuration.inMilliseconds;

      if (totalMs >= _frozenFrameMs) {
        LoggerService.instance.error(
          'PERF',
          'Frozen frame totalSpan=${totalMs}ms build=${buildMs}ms raster=${rasterMs}ms',
        );
        continue;
      }
      if (totalMs >= _severeLagMs) {
        LoggerService.instance.warning(
          'PERF',
          'Severe lag totalSpan=${totalMs}ms build=${buildMs}ms raster=${rasterMs}ms',
        );
        continue;
      }
      if (totalMs >= _normalLagMs) {
        final now = DateTime.now();
        if (_lastNormalLagLog == null ||
            now.difference(_lastNormalLagLog!) >
                const Duration(seconds: 3)) {
          _lastNormalLagLog = now;
          LoggerService.instance.debug(
            'PERF',
            'Normal lag totalSpan=${totalMs}ms build=${buildMs}ms raster=${rasterMs}ms',
          );
        }
      }
    }
  }
}
