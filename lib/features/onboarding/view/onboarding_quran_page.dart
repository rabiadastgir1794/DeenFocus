import 'package:deenly/core/widgets/app_icon_rounded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingQuranPage extends StatelessWidget {
  const OnboardingQuranPage({super.key});
  static const double _descriptionSlotHeight = 96;

  @override
  Widget build(BuildContext context) {
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
                size: 72.r,
                iconSize: 32.sp,
                icon: const Icon(CupertinoIcons.book),
              ),
              SizedBox(width: 16.w), // spacing between icons
              AppIconRounded(
                size: 72.r,
                iconSize: 32.sp,
                icon: const Icon(CupertinoIcons.compass),
                backgroundColor: const Color(0xFFe5edf1),
              ),
              SizedBox(width: 16.w),
              AppIconRounded(
                size: 72.r,
                iconSize: 32.sp,
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
              fontSize: 32.sp,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.quranSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
