import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingTasbihPage extends StatelessWidget {
  const OnboardingTasbihPage({super.key});
  static const double _descriptionSlotHeight = 96;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIconCircle(
            icon: const Icon(CupertinoIcons.heart),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.tasbihTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 32.sp,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.tasbihSubtitle,
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
