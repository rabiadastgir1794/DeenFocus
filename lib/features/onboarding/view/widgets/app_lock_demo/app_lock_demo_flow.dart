import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import 'app_lock_demo_completion.dart';
import 'app_lock_demo_controller.dart';
import 'app_lock_demo_copy.dart';
import 'app_lock_demo_enable_offer.dart';
import 'app_lock_demo_home_screen.dart';
import 'app_lock_demo_intro.dart';
import 'app_lock_demo_mode.dart';
import 'app_lock_demo_opening_app.dart';
import 'app_lock_demo_phase.dart';
import 'app_lock_demo_prayer_lock.dart';
import 'app_lock_demo_streak_reward.dart';

/// Shared interactive App Lock Demo walkthrough (onboarding + Settings).
class AppLockDemoFlow extends StatefulWidget {
  const AppLockDemoFlow({
    super.key,
    required this.mode,
    required this.onComplete,
    required this.onExit,
    this.isActive = true,
    this.fromSettings = false,
    this.onImmersiveChanged,
    this.onEnableFocusMode,
  });

  final AppLockDemoMode mode;
  final VoidCallback onComplete;
  final VoidCallback onExit;
  final bool isActive;
  final bool fromSettings;
  final ValueChanged<bool>? onImmersiveChanged;

  /// Settings App Demo: user accepted the post-demo enable offer.
  final VoidCallback? onEnableFocusMode;

  @override
  State<AppLockDemoFlow> createState() => _AppLockDemoFlowState();
}

class _AppLockDemoFlowState extends State<AppLockDemoFlow> {
  late final AppLockDemoController _controller;
  bool _completed = false;
  bool _lastImmersive = false;

  @override
  void initState() {
    super.initState();
    _controller = AppLockDemoController()..addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emitImmersive(_controller.isImmersive);
    });
  }

  @override
  void didUpdateWidget(covariant AppLockDemoFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      _completed = false;
      _controller.reset();
      _emitImmersive(false);
    }
    if (oldWidget.isActive && !widget.isActive) {
      _completed = false;
      _controller.reset();
      _emitImmersive(false);
    } else if (!oldWidget.isActive && widget.isActive) {
      _completed = false;
      _controller.reset();
      _emitImmersive(false);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _emitImmersive(false);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    _emitImmersive(_controller.isImmersive);
    setState(() {});
  }

  void _emitImmersive(bool value) {
    if (_lastImmersive == value) return;
    _lastImmersive = value;
    widget.onImmersiveChanged?.call(value);
  }

  void _handleComplete() {
    if (_completed) return;
    _completed = true;
    widget.onComplete();
  }

  void _handleEnableFocusMode() {
    if (_completed) return;
    _completed = true;
    (widget.onEnableFocusMode ?? widget.onComplete)();
  }

  AppLockDemoCopy _copy(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remaining = _controller.remaining;
    final formatted =
        '${remaining.inHours}h ${remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}m';
    return AppLockDemoCopy.resolve(
      l10n: l10n,
      mode: widget.mode,
      remainingFormatted: formatted,
      fromSettings: widget.fromSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final phase = _controller.phase;
    final immersive = _controller.isImmersive;
    final copy = _copy(context);

    return ColoredBox(
      color: immersive ? Colors.black : colorScheme.surface,
      child: AnimatedSwitcher(
        duration: _durationFor(phase),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              ...previousChildren,
              ?currentChild,
            ],
          );
        },
        transitionBuilder: (child, animation) {
          return _phaseTransition(child, animation, phase);
        },
        child: KeyedSubtree(
          key: ValueKey('${widget.mode.name}_$phase'),
          child: _buildPhase(phase, copy),
        ),
      ),
    );
  }

  Duration _durationFor(AppLockDemoPhase phase) {
    return switch (phase) {
      AppLockDemoPhase.openingApp => const Duration(milliseconds: 520),
      AppLockDemoPhase.prayerLock => const Duration(milliseconds: 560),
      AppLockDemoPhase.streakReward => const Duration(milliseconds: 420),
      AppLockDemoPhase.completion => const Duration(milliseconds: 480),
      AppLockDemoPhase.enableOffer => const Duration(milliseconds: 420),
      _ => const Duration(milliseconds: 360),
    };
  }

  Widget _phaseTransition(
    Widget child,
    Animation<double> animation,
    AppLockDemoPhase phase,
  ) {
    final curved =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

    switch (phase) {
      case AppLockDemoPhase.openingApp:
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.86, end: 1).animate(curved),
            child: child,
          ),
        );
      case AppLockDemoPhase.prayerLock:
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.04, end: 1).animate(curved),
            child: child,
          ),
        );
      case AppLockDemoPhase.streakReward:
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      case AppLockDemoPhase.completion:
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      default:
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0.01),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
    }
  }

  Widget _buildPhase(AppLockDemoPhase phase, AppLockDemoCopy copy) {
    switch (phase) {
      case AppLockDemoPhase.intro:
        return AppLockDemoIntro(
          navTitle: copy.navTitle,
          introTitle: copy.introTitle,
          introSubtitle: copy.introSubtitle,
          onStartDemo: _controller.startDemo,
          onBack: widget.onExit,
          showCenteredNavHeader: widget.fromSettings,
        );
      case AppLockDemoPhase.homeScreen:
        return AppLockDemoHomeScreen(
          tryOpeningLabel: copy.tryOpeningApp,
          onInstagramTap: _controller.tapInstagram,
        );
      case AppLockDemoPhase.openingApp:
        return const AppLockDemoOpeningApp();
      case AppLockDemoPhase.prayerLock:
        return AppLockDemoPrayerLock(
          copy: copy,
          remaining: _controller.remaining,
          onConfirm: () => _controller.markPrayed(
            showStreakReward: copy.showStreakReward,
          ),
        );
      case AppLockDemoPhase.streakReward:
        return AppLockDemoStreakReward(
          copy: copy,
          onContinue: _controller.continueFromStreak,
        );
      case AppLockDemoPhase.completion:
        return AppLockDemoCompletion(
          completionTitle: copy.completionTitle,
          completionSubtitle: copy.completionSubtitle,
          completionBody: copy.completionBody,
          completionCta: copy.completionCta,
          showCompletionHeart: copy.showCompletionHeart,
          onContinue: widget.fromSettings
              ? _controller.openEnableOffer
              : _handleComplete,
        );
      case AppLockDemoPhase.enableOffer:
        return AppLockDemoEnableOffer(
          mode: widget.mode,
          onEnable: _handleEnableFocusMode,
          onNotNow: _handleComplete,
        );
    }
  }
}
