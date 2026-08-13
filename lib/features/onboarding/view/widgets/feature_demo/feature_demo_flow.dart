import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../app_lock_demo/app_lock_demo_completion.dart';
import '../app_lock_demo/app_lock_demo_intro.dart';
import 'feature_demo_controller.dart';
import 'feature_demo_copy.dart';
import 'feature_demo_enable_offer.dart';
import 'feature_demo_kind.dart';
import 'feature_demo_live_activity_screens.dart';
import 'feature_demo_phase.dart';
import 'feature_demo_widgets_screens.dart';

bool _isCupertinoPlatform() {
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

/// Interactive Widgets / Live Activity walkthrough hosted by Settings App Demo.
class FeatureDemoFlow extends StatefulWidget {
  const FeatureDemoFlow({
    super.key,
    required this.kind,
    required this.onComplete,
    required this.onExit,
    this.onImmersiveChanged,
  });

  final FeatureDemoKind kind;
  final VoidCallback onComplete;
  final VoidCallback onExit;
  final ValueChanged<bool>? onImmersiveChanged;

  @override
  State<FeatureDemoFlow> createState() => _FeatureDemoFlowState();
}

class _FeatureDemoFlowState extends State<FeatureDemoFlow> {
  late final FeatureDemoController _controller;
  bool _completed = false;
  bool _lastImmersive = false;

  @override
  void initState() {
    super.initState();
    _controller = FeatureDemoController(
      kind: widget.kind,
      isCupertinoPlatform: _isCupertinoPlatform(),
    )..addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emitImmersive(_controller.isImmersive);
    });
  }

  @override
  void didUpdateWidget(covariant FeatureDemoFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.kind != widget.kind) {
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final phase = _controller.phase;
    final copy = FeatureDemoCopy.resolve(
      l10n: l10n,
      kind: widget.kind,
      isCupertinoPlatform: _controller.isCupertinoPlatform,
    );

    return ColoredBox(
      color: colorScheme.surface,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 380),
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
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
        },
        child: KeyedSubtree(
          key: ValueKey(
            '${widget.kind.name}_${phase.name}_${_controller.widgetSize.name}',
          ),
          child: _buildPhase(phase, copy, l10n),
        ),
      ),
    );
  }

  Widget _buildPhase(
    FeatureDemoPhase phase,
    FeatureDemoCopy copy,
    AppLocalizations l10n,
  ) {
    final callout = copy.calloutFor(phase, l10n);

    switch (phase) {
      case FeatureDemoPhase.intro:
        return AppLockDemoIntro(
          navTitle: copy.navTitle,
          introTitle: copy.introTitle,
          introSubtitle: copy.introSubtitle,
          onStartDemo: _controller.startDemo,
          onBack: widget.onExit,
          showCenteredNavHeader: true,
        );
      case FeatureDemoPhase.widgetsHome:
      case FeatureDemoPhase.widgetsEditMode:
      case FeatureDemoPhase.widgetsPlaced:
        return FeatureDemoWidgetsHome(
          controller: _controller,
          callout: callout,
        );
      case FeatureDemoPhase.widgetsGallery:
        return FeatureDemoWidgetsGallery(controller: _controller);
      case FeatureDemoPhase.liveSettings:
        return FeatureDemoLiveSettings(
          controller: _controller,
          callout: callout,
        );
      case FeatureDemoPhase.liveLockScreen:
        return FeatureDemoLiveLockScreen(
          callout: callout,
          onContinue: _controller.advanceLiveActivity,
        );
      case FeatureDemoPhase.liveCompactIsland:
        return FeatureDemoLiveCompactIsland(
          callout: callout,
          onContinue: _controller.advanceLiveActivity,
        );
      case FeatureDemoPhase.liveExpandedIsland:
        return FeatureDemoLiveExpandedIsland(
          callout: callout,
          onContinue: _controller.advanceLiveActivity,
        );
      case FeatureDemoPhase.liveOngoingNotification:
        return FeatureDemoLiveOngoingNotification(
          callout: callout,
          onContinue: _controller.advanceLiveActivity,
        );
      case FeatureDemoPhase.liveNotificationShade:
        return FeatureDemoLiveNotificationShade(
          callout: callout,
          onContinue: _controller.advanceLiveActivity,
        );
      case FeatureDemoPhase.completion:
        return AppLockDemoCompletion(
          completionTitle: copy.completionTitle,
          completionSubtitle: copy.completionSubtitle,
          completionBody: copy.completionBody,
          completionCta: copy.completionCta,
          // Widgets cannot be auto-placed on iOS (no public API); Android pin is
          // launcher-dependent — do not ask. Live Activity can be enabled for real.
          onContinue: widget.kind == FeatureDemoKind.liveActivity
              ? _controller.openEnableOffer
              : _handleComplete,
        );
      case FeatureDemoPhase.enableOffer:
        return FeatureDemoEnableOffer(onFinished: _handleComplete);
    }
  }
}
