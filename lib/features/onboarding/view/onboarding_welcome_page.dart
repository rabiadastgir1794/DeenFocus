import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon_circle.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIconCircle(icon: const Icon(CupertinoIcons.moon)),
          SizedBox(height: Spacing.xl.h),
          Text(
            AppLocalizations.of(context)!.appTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 48.sp,
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          Text(
            AppLocalizations.of(context)!.welcomeTagline,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          Center(
            child: Text(
              AppLocalizations.of(context)!.welcomeDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
