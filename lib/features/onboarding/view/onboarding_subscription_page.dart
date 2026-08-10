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
  });

  /// Kept for flow/VM compatibility; plan UI is handled by Superwall.
  final SubscriptionPlan? selectedPlan;
  final ValueChanged<SubscriptionPlan?>? onPlanSelected;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            Spacing.lg.w,
            compact ? 8.h : 16.h,
            Spacing.lg.w,
            12.h,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 24.h,
            ),
            child: Column(
              children: [
                Container(
                  width: compact ? 56.w : 64.w,
                  height: compact ? 56.w : 64.w,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(18.r),
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
                    size: compact ? 28.sp : 32.sp,
                  ),
                ),
                SizedBox(height: compact ? 14.h : 18.h),
                Text(
                  l10n.investPremiumUnlocked,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.investTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onSurface,
                    fontSize: compact ? 28.sp : 32.sp,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  l10n.investSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.65),
                    fontSize: compact ? 13.5.sp : 14.5.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: compact ? 20.h : 28.h),
                OnboardingSubscriptionFeatureCarousel(
                  controller: _pageController,
                  features: features,
                  index: _index,
                  onPageChanged: _onPageChanged,
                  height: compact ? 168.h : 178.h,
                ),
                SizedBox(height: compact ? 16.h : 22.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Text(
                    l10n.investTrialPill,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurface.withValues(alpha: 0.78),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onSurface.withValues(alpha: 0.62),
                      fontSize: 13.sp,
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(text: l10n.socialProofPrefix),
                      TextSpan(
                        text: l10n.socialProofHighlight,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: onSurface.withValues(alpha: 0.88),
                        ),
                      ),
                      TextSpan(text: l10n.socialProofSuffix),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
