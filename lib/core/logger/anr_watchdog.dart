import 'dart:async';

import 'package:flutter/widgets.dart';

import '../services/focus_enforcement_service.dart';
import 'logger_service.dart';
import 'logging_telemetry.dart';

/// Heuristic "main isolate stuck" detector — **not** a replacement for Android's
/// `/data/anr/traces.txt`, but invaluable when testers only share app logs.
///
/// **Why:** When the UI thread stops pumping frames (expensive sync work on the
/// UI isolate, plugin deadlock, or GPU hang), users perceive an ANR. Low-RAM
/// devices amplify this because GC pauses stack with I/O retries.
///
/// **Caveat:** A totally static screen may schedule few frames; we only warn in
/// [AppLifecycleState.resumed] and rely on [LoggingTelemetry.lastFrameActivity]
/// updates from [PerformanceMonitor] plus a lightweight post-frame heartbeat.
class ANRWatchdog with WidgetsBindingObserver {
  ANRWatchdog._();

  static final ANRWatchdog instance = ANRWatchdog._();

  static const Duration _threshold = Duration(seconds: 5);
  static const Duration _tick = Duration(milliseconds: 400);

  Timer? _timer;
  bool _registered = false;
  bool _stopped = true;
  DateTime? _lastAnrLog;

  void start() {
    if (_registered) return;
    _stopped = false;
    _registered = true;
    WidgetsBinding.instance.addObserver(this);
    _timer?.cancel();
    _timer = Timer.periodic(_tick, (_) => _evaluate());
    _schedulePostFrameHeartbeat();
  }

  void dispose() {
    _stopped = true;
    _timer?.cancel();
    _timer = null;
    if (_registered) {
      WidgetsBinding.instance.removeObserver(this);
      _registered = false;
    }
  }

  /// Chained post-frame callbacks approximate "UI is still pumping" without
  /// extra timers on the raster thread.
  void _schedulePostFrameHeartbeat() {
    if (_stopped) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_stopped) return;
      LoggingTelemetry.markFrameActivity();
      _schedulePostFrameHeartbeat();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LoggingTelemetry.markLifecycle(state);
  }

  void _evaluate() {
    if (LoggingTelemetry.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    final gap = DateTime.now().difference(LoggingTelemetry.lastFrameActivity);
    if (gap > _threshold) {
      final now = DateTime.now();
      if (_lastAnrLog == null ||
          now.difference(_lastAnrLog!) > const Duration(seconds: 20)) {
        _lastAnrLog = now;
        final msg =
            'Possible ANR: no frame activity for ${gap.inMilliseconds}ms (UI may be blocked)';
        LoggerService.instance.critical('ANR', msg);
        // [LoggerService] file is under app-scoped storage on Android; mirror to the same public
        // Downloads log as native focus diagnostics so testers see ANR lines next to focus events.
        unawaited(FocusEnforcementService.appendDebugLog('ANR', msg));
      }
    }
  }
}
