import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/onboarding_screen_time_steps.dart';

class OnboardingScreenTimePage extends StatefulWidget {
  const OnboardingScreenTimePage({
    super.key,
    required this.onAllowTap,
    required this.isLoading,
  });

  final VoidCallback onAllowTap;
  final bool isLoading;

  @override
  State<OnboardingScreenTimePage> createState() =>
      _OnboardingScreenTimePageState();
}

class _OnboardingScreenTimePageState extends State<OnboardingScreenTimePage> {
  static const int _stepCount = 4;
  static const Duration _autoAdvanceInterval = Duration(milliseconds: 2500);
  static const Duration _pageAnimDuration = Duration(milliseconds: 280);

  late final PageController _stepController;
  Timer? _autoTimer;
  int _stepIndex = 0;
  bool _isProgrammaticPageChange = false;
  bool _isAnimatingStep = false;

  @override
  void initState() {
    super.initState();
    _stepController = PageController();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _stepController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(_autoAdvanceInterval, (_) {
      if (!mounted || widget.isLoading) return;
      _goToStep(_stepIndex + 1, programmatic: true);
    });
  }

  void _onUserNavigated() {
    _startAutoAdvance();
  }

  Future<void> _goToStep(int index, {required bool programmatic}) async {
    if (!_stepController.hasClients || _isAnimatingStep) return;

    final target = ((index % _stepCount) + _stepCount) % _stepCount;
    if (target == _stepIndex) return;

    final wrappingForward = _stepIndex == _stepCount - 1 && target == 0;
    final wrappingBackward = _stepIndex == 0 && target == _stepCount - 1;

    _isAnimatingStep = true;
    _isProgrammaticPageChange = true;
    try {
      if (wrappingForward || wrappingBackward) {
        _stepController.jumpToPage(target);
        if (mounted) setState(() => _stepIndex = target);
      } else {
        await _stepController.animateToPage(
          target,
          duration: _pageAnimDuration,
          curve: Curves.easeOutCubic,
        );
      }
    } finally {
      _isProgrammaticPageChange = false;
      _isAnimatingStep = false;
    }

    if (!programmatic && mounted) {
      _onUserNavigated();
    }
  }

  void _onPageChanged(int index) {
    if (_stepIndex == index) return;
    setState(() => _stepIndex = index);
    if (!_isProgrammaticPageChange) {
      _onUserNavigated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 720;

        return AbsorbPointer(
          absorbing: widget.isLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
            child: Column(
              children: [
                SizedBox(height: compact ? Spacing.sm.h : Spacing.md.h),
                Text(
                  l10n.screenTimeTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 24.sp : 28.sp,
                    height: 1.15,
                    letterSpacing: -0.35,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: Spacing.sm.h),
                Text(
                  l10n.screenTimeSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                    fontSize: compact ? 13.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h),
                Expanded(
                  child: _ScreenTimeStepCard(
                    controller: _stepController,
                    stepIndex: _stepIndex,
                    stepCount: _stepCount,
                    onPageChanged: _onPageChanged,
                    onUserScrollStart: () => _autoTimer?.cancel(),
                    onPrevious: () =>
                        _goToStep(_stepIndex - 1, programmatic: false),
                    onNext: () =>
                        _goToStep(_stepIndex + 1, programmatic: false),
                  ),
                ),
                SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h),
                _AllowScreenTimeButton(
                  label: l10n.screenTimeButton,
                  loading: widget.isLoading,
                  onPressed: widget.onAllowTap,
                ),
                SizedBox(height: Spacing.sm.h),
                Text(
                  l10n.screenTimePrivacyNote,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: Spacing.sm.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ScreenTimeStepCard extends StatelessWidget {
  const _ScreenTimeStepCard({
    required this.controller,
    required this.stepIndex,
    required this.stepCount,
    required this.onPageChanged,
    required this.onUserScrollStart,
    required this.onPrevious,
    required this.onNext,
  });

  final PageController controller;
  final int stepIndex;
  final int stepCount;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onUserScrollStart;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.28 : 0.07),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 8.h),
            child: Row(
              children: [
                _StepNavButton(
                  icon: CupertinoIcons.chevron_left,
                  onTap: onPrevious,
                ),
                Expanded(
                  child: Text(
                    l10n.screenTimeStepOf(stepIndex + 1, stepCount),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                _StepNavButton(
                  icon: CupertinoIcons.chevron_right,
                  onTap: onNext,
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification &&
                    notification.dragDetails != null) {
                  onUserScrollStart();
                }
                return false;
              },
              child: PageView(
                controller: controller,
                onPageChanged: onPageChanged,
                children: screenTimeStepPages(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 14.h, top: 10.h),
            child: _StepDots(total: stepCount, currentIndex: stepIndex),
          ),
        ],
      ),
    );
  }
}

class _StepNavButton extends StatelessWidget {
  const _StepNavButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34.r,
          height: 34.r,
          child: Icon(
            icon,
            size: 15.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.total, required this.currentIndex});

  final int total;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final active = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: active ? 18.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: active ? colorScheme.primary : colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _AllowScreenTimeButton extends StatelessWidget {
  const _AllowScreenTimeButton({
    required this.label,
    required this.onPressed,
    required this.loading,
  });

  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.7),
          disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.7),
          elevation: 1,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
        ),
        child: loading
            ? SizedBox(
                height: 22.h,
                width: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.lock, size: 18.sp),
                  SizedBox(width: Spacing.sm.w),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
