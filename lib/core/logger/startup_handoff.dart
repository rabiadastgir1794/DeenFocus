import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Destination / Home quiet gates so Superwall WKWebView does not compete with
/// first Home paint or the daily-verse transition.
abstract final class StartupHandoff {
  static final Completer<void> _firstDestinationFrame = Completer<void>();
  static final Completer<void> _firstDestinationIdle = Completer<void>();
  static final Completer<void> _homeContentSettled = Completer<void>();
  static final Completer<void> _homeUiQuiet = Completer<void>();

  /// True after [homeUiQuiet] — safe to run continuous Home animations (marquee).
  static final ValueNotifier<bool> allowHomeChromeAnimations =
      ValueNotifier<bool>(false);

  static Future<void> get firstDestinationFrame =>
      _firstDestinationFrame.future;

  /// One vsync after destination first paint (services may start; not Superwall).
  static Future<void> get firstDestinationIdle => _firstDestinationIdle.future;

  /// Home secondary metrics + isolated verse publish finished.
  static Future<void> get homeContentSettled => _homeContentSettled.future;

  /// After settled, once the frame pipeline has drained — Superwall may start.
  static Future<void> get homeUiQuiet => _homeUiQuiet.future;

  static void notifyFirstDestinationFrame() {
    if (!_firstDestinationFrame.isCompleted) {
      _firstDestinationFrame.complete();
    }
  }

  static void notifyFirstDestinationIdle() {
    if (!_firstDestinationIdle.isCompleted) {
      _firstDestinationIdle.complete();
    }
  }

  /// Call after secondary Home data is applied and the verse listenable updated.
  /// Schedules [homeUiQuiet] after real frame boundaries (not an arbitrary delay).
  static void notifyHomeContentSettled() {
    if (_homeContentSettled.isCompleted) return;
    _homeContentSettled.complete();
    unawaited(_drainFramesThenQuiet());
  }

  static Future<void> _drainFramesThenQuiet() async {
    final binding = WidgetsBinding.instance;
    // Drain the current and next frame so verse AnimatedSwitcher / Home snap
    // rebuild are not concurrent with Superwall's WKWebView spawn.
    await binding.endOfFrame;
    await binding.endOfFrame;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await binding.endOfFrame;
    }
    if (!_homeUiQuiet.isCompleted) {
      _homeUiQuiet.complete();
    }
  }

  static void notifyHomeChromeAnimationsAllowed() {
    if (!allowHomeChromeAnimations.value) {
      allowHomeChromeAnimations.value = true;
    }
  }
}
