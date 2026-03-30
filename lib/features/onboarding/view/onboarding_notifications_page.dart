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
    this.showEnableButton = true,
  });

  final VoidCallback onEnableTap;
  final bool isLoading;

  /// When false, the user already granted notification permission (e.g. system prompt).
  final bool showEnableButton;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          AppIconCircle(
            size: 64.8.r,
            iconSize: 28.8.sp,
            icon: const Icon(CupertinoIcons.bell),
          ),
          SizedBox(height: Spacing.xl.h),
          Text(
            l10n.notificationsTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            l10n.notificationsSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: Spacing.xl.h),
          if (showEnableButton)
            AppButton(
              label: l10n.notificationsButton,
              onPressed: onEnableTap,
              loading: isLoading,
              showTrailingIcon: false,
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: colorScheme.primary,
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    l10n.notificationsEnabled,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
