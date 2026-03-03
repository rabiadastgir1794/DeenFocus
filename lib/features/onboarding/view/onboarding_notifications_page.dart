import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingNotificationsPage extends StatelessWidget {
  const OnboardingNotificationsPage({
    super.key,
    required this.onEnableTap,
    this.isLoading = false,
  });

  final VoidCallback onEnableTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIconCircle(
            icon: const Icon(CupertinoIcons.bell),
          ),
          SizedBox(height: Spacing.xl.h),
          Text(
            AppLocalizations.of(context)!.notificationsTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            AppLocalizations.of(context)!.notificationsSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                  fontSize: 16.sp,
                ),
          ),
          SizedBox(height: Spacing.xl.h),
          AppButton(
            label: AppLocalizations.of(context)!.notificationsButton,
            onPressed: onEnableTap,
            loading: isLoading,
            showTrailingIcon: false,
          ),
        ],
      ),
    );
  }
}
