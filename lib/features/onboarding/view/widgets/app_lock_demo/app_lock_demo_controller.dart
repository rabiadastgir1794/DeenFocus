import 'dart:async';

import 'package:flutter/foundation.dart';

import 'app_lock_demo_phase.dart';

/// Local state machine for the interactive onboarding App Lock Demo.
///
/// Does not touch real Focus / Screen Time enforcement — it only drives the
/// in-app walkthrough. Demo prayer is always Maghrib with a fixed remaining
/// window for a predictable experience.
class AppLockDemoController extends ChangeNotifier {
  AppLockDemoPhase _phase = AppLockDemoPhase.intro;
  AppLockDemoPhase get phase => _phase;

  /// True while the demo should cover the whole device (no onboarding chrome).
  bool get isImmersive =>
      _phase == AppLockDemoPhase.homeScreen ||
      _phase == AppLockDemoPhase.openingApp ||
      _phase == AppLockDemoPhase.prayerLock ||
      _phase == AppLockDemoPhase.streakReward;

  bool _instagramTapped = false;
  bool get instagramTapped => _instagramTapped;

  bool _prayerCompleted = false;
  bool get prayerCompleted => _prayerCompleted;

  /// Demo remaining prayer window (counts down gently while lock is visible).
  Duration _remaining = const Duration(minutes: 12);
  Duration get remaining => _remaining;

  Timer? _openingTimer;
  Timer? _remainingTimer;

  static const Duration openingDuration = Duration(milliseconds: 1100);

  void startDemo() {
    _goTo(AppLockDemoPhase.homeScreen);
  }

  /// Full reset — used when leaving/re-entering the onboarding step.
  void reset() {
    _cancelTimers();
    _instagramTapped = false;
    _prayerCompleted = false;
    _remaining = const Duration(minutes: 12);
    if (_phase == AppLockDemoPhase.intro) {
      notifyListeners();
      return;
    }
    _phase = AppLockDemoPhase.intro;
    notifyListeners();
  }

  void backToIntro() => reset();

  void tapInstagram() {
    if (_phase != AppLockDemoPhase.homeScreen || _instagramTapped) return;
    _instagramTapped = true;
    _goTo(AppLockDemoPhase.openingApp);
    _openingTimer?.cancel();
    _openingTimer = Timer(openingDuration, () {
      if (_phase == AppLockDemoPhase.openingApp) {
        _startRemainingTicker();
        _goTo(AppLockDemoPhase.prayerLock);
      }
    });
  }

  /// Confirms the lock CTA. Prayer demos show streak reward; other modes skip
  /// straight to completion.
  void markPrayed({bool showStreakReward = true}) {
    if (_phase != AppLockDemoPhase.prayerLock) return;
    _prayerCompleted = true;
    _remainingTimer?.cancel();
    _goTo(
      showStreakReward
          ? AppLockDemoPhase.streakReward
          : AppLockDemoPhase.completion,
    );
  }

  void continueFromStreak() {
    if (_phase != AppLockDemoPhase.streakReward) return;
    _goTo(AppLockDemoPhase.completion);
  }

  void _startRemainingTicker() {
    _remainingTimer?.cancel();
    _remainingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) return;
      _remaining -= const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void _goTo(AppLockDemoPhase next) {
    if (_phase == next) return;
    _phase = next;
    notifyListeners();
  }

  void _cancelTimers() {
    _openingTimer?.cancel();
    _openingTimer = null;
    _remainingTimer?.cancel();
    _remainingTimer = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}
