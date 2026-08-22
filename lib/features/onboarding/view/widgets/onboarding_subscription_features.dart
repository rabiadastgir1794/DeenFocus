import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';

class OnboardingSubscriptionFeature {
  const OnboardingSubscriptionFeature({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

List<OnboardingSubscriptionFeature> onboardingSubscriptionFeatures(
  AppLocalizations l10n,
) {
  return [
    OnboardingSubscriptionFeature(
      icon: Icons.smart_toy_outlined,
      title: l10n.investFeatureAiTitle,
      body: l10n.investFeatureAiBody,
    ),
    OnboardingSubscriptionFeature(
      icon: Icons.phone_iphone_rounded,
      title: l10n.investFeaturePrayerModeTitle,
      body: l10n.investFeaturePrayerModeBody,
    ),
    OnboardingSubscriptionFeature(
      icon: Icons.lock_outline_rounded,
      title: l10n.investFeatureAppBlockingTitle,
      body: l10n.investFeatureAppBlockingBody,
    ),
    OnboardingSubscriptionFeature(
      icon: Icons.nightlight_round,
      title: l10n.investFeatureNightModeTitle,
      body: l10n.investFeatureNightModeBody,
    ),
    OnboardingSubscriptionFeature(
      icon: Icons.show_chart_rounded,
      title: l10n.investFeaturePlannerTitle,
      body: l10n.investFeaturePlannerBody,
    ),
    OnboardingSubscriptionFeature(
      icon: Icons.calendar_month_outlined,
      title: l10n.investFeatureToolsTitle,
      body: l10n.investFeatureToolsBody,
    ),
    OnboardingSubscriptionFeature(
      icon: Icons.palette_outlined,
      title: l10n.investFeatureThemesTitle,
      body: l10n.investFeatureThemesBody,
    ),
    OnboardingSubscriptionFeature(
      icon: Icons.menu_book_rounded,
      title: l10n.investFeatureTajweedTitle,
      body: l10n.investFeatureTajweedBody,
    ),
  ];
}

class OnboardingSubscriptionFeatureContent extends StatelessWidget {
  const OnboardingSubscriptionFeatureContent({
    super.key,
    required this.feature,
  });

  final OnboardingSubscriptionFeature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(feature.icon, color: primary, size: 22.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  feature.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                    fontSize: 16.sp,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  feature.body,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.62),
                    fontSize: 13.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OnboardingSubscriptionFeatureCarousel extends StatelessWidget {
  const OnboardingSubscriptionFeatureCarousel({
    super.key,
    required this.controller,
    required this.features,
    required this.index,
    required this.onPageChanged,
  });

  final PageController controller;
  final List<OnboardingSubscriptionFeature> features;
  final int index;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: features.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, i) {
                return OnboardingSubscriptionFeatureContent(
                  feature: features[i],
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(features.length, (i) {
              final active = i == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: active ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: active
                      ? primary
                      : theme.colorScheme.outline.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
