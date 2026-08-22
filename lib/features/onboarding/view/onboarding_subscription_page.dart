import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../model/subscription_plan.dart';
import 'widgets/onboarding_subscription_features.dart';

class OnboardingSubscriptionPage extends StatefulWidget {
  const OnboardingSubscriptionPage({
    super.key,
    this.selectedPlan,
    this.onPlanSelected,
    this.onStartTrial,
    this.onMaybeLater,
  });

  /// Kept for flow/VM compatibility; plan UI is handled by Superwall.
  final SubscriptionPlan? selectedPlan;
  final ValueChanged<SubscriptionPlan?>? onPlanSelected;
  final VoidCallback? onStartTrial;
  final VoidCallback? onMaybeLater;

  @override
  State<OnboardingSubscriptionPage> createState() =>
      _OnboardingSubscriptionPageState();
}

class _OnboardingSubscriptionPageState
    extends State<OnboardingSubscriptionPage> {
  static const Duration _autoAdvanceInterval = Duration(seconds: 2);
  static const Duration _pageAnimDuration = Duration(milliseconds: 320);

  late final PageController _pageController;
  Timer? _autoTimer;
  int _index = 0;
  bool _isProgrammaticPageChange = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(_autoAdvanceInterval, (_) {
      if (!mounted) return;
      _goToPage(_index + 1, programmatic: true);
    });
  }

  Future<void> _goToPage(int index, {required bool programmatic}) async {
    if (!_pageController.hasClients || _isAnimating) return;

    final features = onboardingSubscriptionFeatures(
      AppLocalizations.of(context)!,
    );
    final count = features.length;
    final target = ((index % count) + count) % count;
    if (target == _index) return;

    final wrappingForward = _index == count - 1 && target == 0;
    final wrappingBackward = _index == 0 && target == count - 1;

    _isAnimating = true;
    _isProgrammaticPageChange = true;
    try {
      if (wrappingForward || wrappingBackward) {
        _pageController.jumpToPage(target);
        if (mounted) setState(() => _index = target);
      } else {
        await _pageController.animateToPage(
          target,
          duration: _pageAnimDuration,
          curve: Curves.easeOutCubic,
        );
      }
    } finally {
      _isProgrammaticPageChange = false;
      _isAnimating = false;
    }

    if (!programmatic && mounted) {
      _startAutoAdvance();
    }
  }

  void _onPageChanged(int index) {
    if (_index == index) return;
    setState(() => _index = index);
    if (!_isProgrammaticPageChange) {
      _startAutoAdvance();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final features = onboardingSubscriptionFeatures(l10n);
    final compact = MediaQuery.sizeOf(context).height < 740;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Spacing.lg.w,
        compact ? 6.h : 12.h,
        Spacing.lg.w,
        4.h,
      ),
      child: Column(
        children: [
          Container(
            width: compact ? 48.w : 58.w,
            height: compact ? 48.w : 58.w,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: theme.colorScheme.onPrimary,
              size: compact ? 24.sp : 30.sp,
            ),
          ),
          SizedBox(height: compact ? 10.h : 14.h),
          Text(
            l10n.investPremiumUnlocked,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              fontSize: compact ? 11.sp : 12.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.investTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: onSurface,
              fontSize: compact ? 24.sp : 30.sp,
              height: 1.15,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.investSubtitle,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: onSurface.withValues(alpha: 0.65),
              fontSize: compact ? 12.5.sp : 14.sp,
              height: 1.35,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: compact ? 10.h : 14.h),
          Expanded(
            child: OnboardingSubscriptionFeatureCarousel(
              controller: _pageController,
              features: features,
              index: _index,
              onPageChanged: _onPageChanged,
            ),
          ),
          SizedBox(height: compact ? 8.h : 12.h),
          _TrialCtaBlock(
            compact: compact,
            onStartTrial: widget.onStartTrial,
            onMaybeLater: widget.onMaybeLater,
          ),
        ],
      ),
    );
  }
}

class _TrialCtaBlock extends StatelessWidget {
  const _TrialCtaBlock({
    required this.compact,
    this.onStartTrial,
    this.onMaybeLater,
  });

  final bool compact;
  final VoidCallback? onStartTrial;
  final VoidCallback? onMaybeLater;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final radius = BorderRadius.circular(999);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: radius,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.14),
            ),
          ),
          child: Text(
            l10n.investTrialPill,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(height: compact ? 8.h : 10.h),
        _NoCommitmentDivider(),
        SizedBox(height: compact ? 8.h : 10.h),
        SizedBox(
          width: double.infinity,
          height: compact ? 48.h : 52.h,
          child: ElevatedButton(
            onPressed: onStartTrial,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: radius),
              padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    l10n.getStarted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(Icons.chevron_right_rounded, size: 22.sp),
              ],
            ),
          ),
        ),
        SizedBox(height: Spacing.sm.h),
        TextButton(
          onPressed: onMaybeLater,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 4.h,
            ),
            foregroundColor: colorScheme.onSurface.withValues(alpha: 0.72),
          ),
          child: Text(
            l10n.continueForFree,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoCommitmentDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final lineColor = colorScheme.outlineVariant.withValues(alpha: 0.85);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1, color: lineColor)),
            Container(
              width: 28.w,
              height: 28.w,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: lineColor),
              ),
              child: Icon(
                Icons.verified_user_outlined,
                size: 14.sp,
                color: colorScheme.primary,
              ),
            ),
            Expanded(child: Divider(height: 1, color: lineColor)),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          l10n.investNoCommitment,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
