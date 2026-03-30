import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingNamePage extends StatelessWidget {
  const OnboardingNamePage({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Spacing.xl.h),
            Text(
              AppLocalizations.of(context)!.nameTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: Spacing.sm.h),
            Text(
              AppLocalizations.of(context)!.nameSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10.5.sp,
              ),
            ),
            SizedBox(height: Spacing.xl.h),
            AppTextField(
              controller: controller,
              placeholder: AppLocalizations.of(context)!.namePlaceholder,
              onChanged: onChanged,
            ),
            SizedBox(height: Spacing.xl.h),
          ],
        ),
      ),
    );
  }
}
