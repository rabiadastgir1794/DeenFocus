import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../focus/model/focus_models.dart';
import '../../../onboarding/view/widgets/app_demo_skip_button.dart';
import '../../../onboarding/view/widgets/app_lock_demo/app_lock_demo_flow.dart';
import '../../../onboarding/view/widgets/app_lock_demo/app_lock_demo_mode.dart';
import '../../../onboarding/view/widgets/feature_demo/feature_demo_flow.dart';
import '../../../onboarding/view/widgets/feature_demo/feature_demo_kind.dart';

/// Settings entry for interactive App Demo walkthroughs.
class SettingsAppDemoScreen extends StatefulWidget {
  const SettingsAppDemoScreen({
    super.key,
    this.onRequestEnableFocusMode,
    this.initialFeatureKind,
    this.popOnWalkthroughExit = false,
  });

  /// Opens Focus and runs the existing enable / Superwall flow for [mode].
  final ValueChanged<FocusModeType>? onRequestEnableFocusMode;

  /// When set, opens that feature walkthrough immediately (e.g. Home promo).
  final FeatureDemoKind? initialFeatureKind;

  /// If true, leaving the initial walkthrough pops this route instead of the
  /// App Demo picker (used when opened from the Home Live Activity card).
  final bool popOnWalkthroughExit;

  @override
  State<SettingsAppDemoScreen> createState() => _SettingsAppDemoScreenState();
}

class _SettingsAppDemoScreenState extends State<SettingsAppDemoScreen> {
  AppLockDemoMode? _lockMode;
  FeatureDemoKind? _featureKind;
  bool _immersive = false;

  @override
  void initState() {
    super.initState();
    _featureKind = widget.initialFeatureKind;
  }

  bool get _inWalkthrough => _lockMode != null || _featureKind != null;

  void _openLockMode(AppLockDemoMode mode) {
    setState(() {
      _lockMode = mode;
      _featureKind = null;
      _immersive = false;
    });
  }

  void _openFeature(FeatureDemoKind kind) {
    setState(() {
      _featureKind = kind;
      _lockMode = null;
      _immersive = false;
    });
  }

  void _backToPicker() {
    if (widget.popOnWalkthroughExit &&
        widget.initialFeatureKind != null &&
        _lockMode == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _lockMode = null;
      _featureKind = null;
      _immersive = false;
    });
  }

  void _finishWithFocusEnable(AppLockDemoMode demoMode) {
    final mode = demoMode.focusModeType;
    final requestEnable = widget.onRequestEnableFocusMode;
    Navigator.of(context).pop();
    requestEnable?.call(mode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (_inWalkthrough) {
      final featureImmersive = _featureKind != null && _immersive;
      final lockImmersive = _lockMode != null && _immersive;
      return Scaffold(
        backgroundColor: lockImmersive ? Colors.black : colorScheme.surface,
        body: SafeArea(
          top: !_immersive,
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_lockMode != null)
                AppLockDemoFlow(
                  key: ValueKey(_lockMode),
                  mode: _lockMode!,
                  fromSettings: true,
                  isActive: true,
                  onComplete: _backToPicker,
                  onExit: _backToPicker,
                  onEnableFocusMode: () => _finishWithFocusEnable(_lockMode!),
                  onImmersiveChanged: (value) {
                    if (!mounted || _immersive == value) return;
                    setState(() => _immersive = value);
                  },
                )
              else
                FeatureDemoFlow(
                  key: ValueKey(_featureKind),
                  kind: _featureKind!,
                  onComplete: _backToPicker,
                  onExit: _backToPicker,
                  onImmersiveChanged: (value) {
                    if (!mounted || _immersive == value) return;
                    setState(() => _immersive = value);
                  },
                ),
              if (_immersive)
                AppDemoSkipButton(
                  onPressed: _backToPicker,
                  label: l10n.skip,
                  foregroundColor:
                      (featureImmersive ? colorScheme.onSurface : Colors.white)
                          .withValues(alpha: 0.92),
                  showShadow: !featureImmersive,
                ),
            ],
          ),
        ),
      );
    }

    final bottomPad = Spacing.xl.h + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.settingsAppDemoLabel,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  Spacing.lg.w,
                  Spacing.sm.h,
                  Spacing.lg.w,
                  bottomPad,
                ),
                children: [
                  Text(
                    l10n.settingsAppDemoChooseModeTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: Spacing.sm.h),
                  Text(
                    l10n.settingsAppDemoChooseModeSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: Spacing.lg.h),
                  _ModeOptionCard(
                    icon: Icons.mosque_rounded,
                    title: l10n.focusPrayerModeTitle,
                    subtitle: l10n.settingsAppDemoPrayerCardSubtitle,
                    onTap: () => _openLockMode(AppLockDemoMode.prayer),
                  ),
                  SizedBox(height: Spacing.md.h),
                  _ModeOptionCard(
                    icon: Icons.bedtime_rounded,
                    title: l10n.focusSleepModeTitle,
                    subtitle: l10n.settingsAppDemoSleepCardSubtitle,
                    onTap: () => _openLockMode(AppLockDemoMode.sleep),
                  ),
                  SizedBox(height: Spacing.md.h),
                  _ModeOptionCard(
                    icon: Icons.child_care_rounded,
                    title: l10n.focusChildModeTitle,
                    subtitle: l10n.settingsAppDemoChildCardSubtitle,
                    onTap: () => _openLockMode(AppLockDemoMode.child),
                  ),
                  SizedBox(height: Spacing.xl.h),
                  Text(
                    l10n.settingsAppDemoHomeFeaturesTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: Spacing.sm.h),
                  Text(
                    l10n.settingsAppDemoHomeFeaturesSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: Spacing.lg.h),
                  _ModeOptionCard(
                    icon: Icons.mic_rounded,
                    title: l10n.featureDemoTajweedTitle,
                    subtitle: l10n.settingsAppDemoTajweedCardSubtitle,
                    onTap: () => _openFeature(FeatureDemoKind.tajweed),
                  ),
                  SizedBox(height: Spacing.md.h),
                  _ModeOptionCard(
                    icon: Icons.widgets_rounded,
                    title: l10n.featureDemoWidgetsTitle,
                    subtitle: l10n.settingsAppDemoWidgetsCardSubtitle,
                    onTap: () => _openFeature(FeatureDemoKind.widgets),
                  ),
                  SizedBox(height: Spacing.md.h),
                  _ModeOptionCard(
                    icon: Icons.notifications_active_rounded,
                    title: l10n.featureDemoLiveActivityTitle,
                    subtitle: l10n.settingsAppDemoLiveActivityCardSubtitle,
                    onTap: () => _openFeature(FeatureDemoKind.liveActivity),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOptionCard extends StatelessWidget {
  const _ModeOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 24.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
