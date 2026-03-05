import 'package:deenly/core/widgets/app_icon_rounded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingQuranPage extends StatelessWidget {
  const OnboardingQuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppIconRounded(
                size: 64.8.r,
                iconSize: 28.8.sp,
                icon: const Icon(CupertinoIcons.book),
              ),
              SizedBox(width: 16.w), // spacing between icons
              AppIconRounded(
                size: 64.8.r,
                iconSize: 28.8.sp,
                icon: const Icon(CupertinoIcons.compass),
                backgroundColor: colorScheme.tertiaryContainer,
              ),
              SizedBox(width: 16.w),
              AppIconRounded(
                size: 64.8.r,
                iconSize: 28.8.sp,
                icon: const Icon(CupertinoIcons.location),
              ),
            ],
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.quranTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.quranSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
