import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import 'app_lock_demo_mode.dart';

/// Final Enable / Not now prompt after a Focus Mode App Demo walkthrough.
class AppLockDemoEnableOffer extends StatelessWidget {
  const AppLockDemoEnableOffer({
    super.key,
    required this.mode,
    required this.onEnable,
    required this.onNotNow,
  });

  final AppLockDemoMode mode;
  final VoidCallback onEnable;
  final VoidCallback onNotNow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomPad = Spacing.lg.h + MediaQuery.paddingOf(context).bottom;
    final (title, cta) = switch (mode) {
      AppLockDemoMode.prayer => (
          l10n.appLockDemoOfferPrayerTitle,
          l10n.appLockDemoOfferPrayerCta,
        ),
      AppLockDemoMode.sleep => (
          l10n.appLockDemoOfferSleepTitle,
          l10n.appLockDemoOfferSleepCta,
        ),
      AppLockDemoMode.child => (
          l10n.appLockDemoOfferChildTitle,
          l10n.appLockDemoOfferChildCta,
        ),
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),
          Icon(
            Icons.shield_outlined,
            size: 56.sp,
            color: colorScheme.primary,
          ),
          SizedBox(height: Spacing.lg.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(flex: 3),
          SizedBox(
            height: 56.h,
            child: ElevatedButton(
              onPressed: onEnable,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                cta,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: Spacing.md.h),
          SizedBox(
            height: 56.h,
            child: OutlinedButton(
              onPressed: onNotNow,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.55),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                l10n.appLockDemoOfferNotNow,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: bottomPad),
        ],
      ),
    );
  }
}
