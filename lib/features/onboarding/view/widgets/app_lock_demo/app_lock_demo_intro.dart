import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/spacing.dart';
import '../../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../../l10n/app_localizations.dart';

/// Shared demo intro chrome (App Lock + feature demos).
class AppLockDemoIntro extends StatelessWidget {
  const AppLockDemoIntro({
    super.key,
    required this.navTitle,
    required this.introTitle,
    required this.introSubtitle,
    required this.onStartDemo,
    required this.onBack,
    this.startButtonLabel,
    this.showCenteredNavHeader = false,
  });

  final String navTitle;
  final String introTitle;
  final String introSubtitle;
  final VoidCallback onStartDemo;
  final VoidCallback onBack;
  final String? startButtonLabel;

  /// Settings uses calendar-style Back + title. Onboarding already has chrome.
  final bool showCenteredNavHeader;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final bottomPad =
        Spacing.lg.h + MediaQuery.paddingOf(context).bottom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showCenteredNavHeader)
          AppCenteredNavHeader(
            title: navTitle,
            backLabel: l10n.calendarBack,
            onBack: onBack,
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                Text(
                  introTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 30.sp,
                    height: 1.15,
                    letterSpacing: -0.4,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: Spacing.md.h),
                Text(
                  introSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                    fontSize: 15.sp,
                  ),
                ),
                const Spacer(flex: 3),
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: onStartDemo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          startButtonLabel ?? l10n.appLockDemoStartButton,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(Icons.chevron_right_rounded, size: 22.sp),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: bottomPad),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
