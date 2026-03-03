import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/widgets/widgets.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          AppIconCircle(
            icon: const Icon(CupertinoIcons.creditcard),
          ),
          SizedBox(height: Spacing.xl.h),
          Text(
            AppLocalizations.of(context)!.investTitle,
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.investSubtitle,
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSurfaceVariant,
              height: 1.5,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: Spacing.xl.h),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              child: AppSelectableCard(
                label: AppLocalizations.of(context)!.monthlyLabel,
                subtitle: AppLocalizations.of(context)!.monthlyPrice,
                selected: selectedPlan == SubscriptionPlan.monthly,
                onTap: () => onPlanSelected(SubscriptionPlan.monthly),
              ),
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              child: AppSelectableCard(
                label: AppLocalizations.of(context)!.yearlyLabel,
                subtitle: AppLocalizations.of(context)!.yearlyPrice,
                badge: AppLocalizations.of(context)!.mostPopular,
                selected: selectedPlan == SubscriptionPlan.yearly,
                onTap: () => onPlanSelected(SubscriptionPlan.yearly),
              ),
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              child: AppSelectableCard(
                label: AppLocalizations.of(context)!.lifetimeLabel,
                subtitle: AppLocalizations.of(context)!.lifetimePrice,
                selected: selectedPlan == SubscriptionPlan.lifetime,
                onTap: () => onPlanSelected(SubscriptionPlan.lifetime),
              ),
            ),
          ),
          SizedBox(height: Spacing.lg.h),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              child: Container(
                padding: EdgeInsets.all(Spacing.lg.w),
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .surface,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.checkmark_seal,
                          size: 18,
                        ),
                        SizedBox(width: Spacing.sm.w),
                        Expanded(
                          child: Text(
                            'Advanced prayer analytics',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Spacing.sm.h),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.checkmark_seal,
                          size: 18,
                        ),
                        SizedBox(width: Spacing.sm.w),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.featureFocusMode,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Spacing.sm.h),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.checkmark_seal,
                          size: 18,
                        ),
                        SizedBox(width: Spacing.sm.w),
                        Expanded(
                          child: Text(
                            'Masjid auto mode',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Spacing.sm.h),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.checkmark_seal,
                          size: 18,
                        ),
                        SizedBox(width: Spacing.sm.w),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.featureNoAds,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Spacing.sm.h),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.checkmark_seal,
                          size: 18,
                        ),
                        SizedBox(width: Spacing.sm.w),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.featureSupport,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
