import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/app_localizations.dart';
import '../model/subscription_plan.dart';

class OnboardingSubscriptionPage extends StatelessWidget {
  const OnboardingSubscriptionPage({
    super.key,
    required this.selectedPlan,
    required this.onPlanSelected,
  });

  final SubscriptionPlan? selectedPlan;
  final ValueChanged<SubscriptionPlan?> onPlanSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lockedPlan = SubscriptionPlan.yearly;
    final glassBackground = Colors.white.withValues(
      alpha: isDark ? 0.06 : 0.72,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _GeometricPatternPainter(
                color: colorScheme.outlineVariant.withValues(
                  alpha: isDark ? 0.16 : 0.22,
                ),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 20.h),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 380.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.2),
                          colorScheme.tertiary.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      size: 32.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.investTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 320.w),
                    child: Text(
                      l10n.investSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 320.w),
                    child: _ComparisonCard(
                      colorScheme: colorScheme,
                      l10n: l10n,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 320.w),
                    child: Column(
                      children: [
                        _PricingCard(
                          glassBackground: glassBackground,
                          colorScheme: colorScheme,
                          selected: lockedPlan == SubscriptionPlan.monthly,
                          enabled: false,
                          onTap: null,
                          primaryPrice: l10n.monthlyPriceValue,
                          suffix: l10n.monthlyPriceSuffix,
                          subtitle: l10n.monthlyPlanSubtitle,
                        ),
                        SizedBox(height: 12.h),
                        _PricingCard(
                          glassBackground: glassBackground,
                          colorScheme: colorScheme,
                          selected: true,
                          featured: true,
                          onTap: () => onPlanSelected(SubscriptionPlan.yearly),
                          primaryPrice: l10n.yearlyPriceValue,
                          suffix: l10n.yearlyPriceSuffix,
                          subtitle: l10n.yearlyPlanSubtitle,
                          badgeText: l10n.bestValueTag,
                          popularityText: l10n.mostPopularChoice,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 320.w),
                    child: _BenefitsCard(
                      colorScheme: colorScheme,
                      glassBackground: glassBackground,
                      l10n: l10n,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.colorScheme, required this.l10n});

  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: colorScheme.primary.withValues(alpha: 0.05),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              l10n.investComparisonTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _ComparisonRow(
            emoji: "☕",
            label: l10n.investDailyCoffee,
            amount: l10n.investDailyCoffeePrice,
            muted: true,
            colorScheme: colorScheme,
          ),
          SizedBox(height: 8.h),
          _ComparisonRow(
            emoji: "🍕",
            label: l10n.investFastFood,
            amount: l10n.investFastFoodPrice,
            muted: true,
            colorScheme: colorScheme,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            height: 1.h,
            color: colorScheme.outlineVariant,
          ),
          _ComparisonRow(
            emoji: "🕌",
            label: l10n.investYourDeen,
            amount: l10n.investYourDeenPrice,
            muted: false,
            colorScheme: colorScheme,
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.investComparisonQuote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
              color: colorScheme.primary.withValues(alpha: 0.7),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.emoji,
    required this.label,
    required this.amount,
    required this.muted,
    required this.colorScheme,
  });

  final String emoji;
  final String label;
  final String amount;
  final bool muted;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textColor = muted
        ? colorScheme.onSurfaceVariant
        : colorScheme.primary;

    return Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: 18.sp)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: textColor,
              fontWeight: muted ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor,
            fontWeight: FontWeight.w700,
            decoration: muted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.glassBackground,
    required this.colorScheme,
    required this.selected,
    required this.onTap,
    required this.primaryPrice,
    required this.suffix,
    required this.subtitle,
    this.featured = false,
    this.enabled = true,
    this.badgeText,
    this.popularityText,
  });

  final Color glassBackground;
  final ColorScheme colorScheme;
  final bool selected;
  final VoidCallback? onTap;
  final String primaryPrice;
  final String suffix;
  final String subtitle;
  final bool featured;
  final bool enabled;
  final String? badgeText;
  final String? popularityText;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected || featured
        ? colorScheme.primary.withValues(alpha: featured ? 0.3 : 0.45)
        : colorScheme.outlineVariant.withValues(alpha: 0.65);
    final effectiveTitleColor = enabled
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.78);
    final effectiveSubtitleColor = enabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.72);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: selected
                    ? colorScheme.primary.withValues(alpha: 0.08)
                    : glassBackground,
                border: Border.all(
                  color: borderColor,
                  width: featured ? 2 : (selected ? 1.5 : 1),
                ),
              ),
              child: Stack(
                children: [
                  if (featured)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.r),
                            topRight: Radius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          badgeText ?? '',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: primaryPrice,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: effectiveTitleColor,
                                ),
                              ),
                              TextSpan(
                                text: suffix,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: effectiveSubtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: effectiveSubtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (featured) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 10.sp,
                                color: colorScheme.primary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                popularityText ?? '',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: enabled
                                      ? colorScheme.primary
                                      : colorScheme.primary.withValues(
                                          alpha: 0.6,
                                        ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard({
    required this.colorScheme,
    required this.glassBackground,
    required this.l10n,
  });

  final ColorScheme colorScheme;
  final Color glassBackground;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: glassBackground,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.everythingYouGet,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4.h),
              for (var i = 0; i < _benefits.length; i++) ...[
                if (i > 0) SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 9.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _benefits[i],
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<String> get _benefits => [
    l10n.featureFocusModeAllModes,
    l10n.featurePrayerAnalyticsStreaks,
    l10n.featureMasjidGeofencing,
    l10n.featureQuranAudioTranslations,
    l10n.featureAiAssistant,
  ];
}

class _GeometricPatternPainter extends CustomPainter {
  const _GeometricPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 0.7;
    const spacing = 38.0;

    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        linePaint,
      );
    }
    for (double x = 0; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GeometricPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
