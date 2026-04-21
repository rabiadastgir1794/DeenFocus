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
    required this.isLoading,
  });

  final VoidCallback onAllowTap;
  final VoidCallback onSkipTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: AbsorbPointer(
        absorbing: isLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withValues(alpha: isDark ? 0.32 : 0.18),
                    colorScheme.tertiary.withValues(alpha: isDark ? 0.18 : 0.1),
                  ],
                ),
                border: Border.all(
                  color: colorScheme.primary.withValues(
                    alpha: isDark ? 0.3 : 0.14,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(
                      alpha: isDark ? 0.18 : 0.1,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: AppIconCircle(
                size: 64.8.r,
                iconSize: 28.8.sp,
                icon: const Icon(CupertinoIcons.timer),
              ),
            ),
            SizedBox(height: Spacing.xl.h),
            Text(
              AppLocalizations.of(context)!.screenTimeTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                height: 1.15,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: Spacing.md.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.72)
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(
                    alpha: isDark ? 0.4 : 0.55,
                  ),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.screenTimeSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: Spacing.xl.h),
            AppButton(
              label: AppLocalizations.of(context)!.screenTimeButton,
              onPressed: onAllowTap,
              showTrailingIcon: false,
              loading: isLoading,
            ),
            SizedBox(height: Spacing.sm.h),
            Center(
              child: AppTextButton(
                label: AppLocalizations.of(context)!.skip,
                onPressed: isLoading ? null : onSkipTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
