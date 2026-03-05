import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingScreenTimePage extends StatelessWidget {
  const OnboardingScreenTimePage({
    super.key,
    required this.onAllowTap,
    required this.onSkipTap,
  });

  final VoidCallback onAllowTap;
  final VoidCallback onSkipTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIconCircle(
            size: 64.8.r,
            iconSize: 28.8.sp,
            icon: const Icon(CupertinoIcons.timer),
          ),
          SizedBox(height: Spacing.xl.h),
          Text(
            AppLocalizations.of(context)!.screenTimeTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.screenTimeSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: Spacing.xl.h),
          AppButton(
            label: AppLocalizations.of(context)!.screenTimeButton,
            onPressed: onAllowTap,
            showTrailingIcon: false,
          ),
          SizedBox(height: Spacing.sm.h),
          Center(
            child: AppTextButton(
              label: AppLocalizations.of(context)!.skip,
              onPressed: onSkipTap,
            ),
          ),
        ],
      ),
    );
  }
}
