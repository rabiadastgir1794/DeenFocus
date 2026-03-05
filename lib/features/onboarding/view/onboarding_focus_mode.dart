import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingFocusModePage extends StatelessWidget {
  const OnboardingFocusModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final modes = [
      _FocusModeConfig(
        title: l10n.focusPrayerModeTitle,
        description: l10n.focusPrayerModeDescription,
        icon: Icons.shield_outlined,
        iconBackground: colorScheme.primaryContainer,
        iconColor: colorScheme.primary,
      ),
      _FocusModeConfig(
        title: l10n.focusSleepModeTitle,
        description: l10n.focusSleepModeDescription,
        icon: Icons.nights_stay_outlined,
        iconBackground: colorScheme.tertiaryContainer,
        iconColor: colorScheme.tertiary,
      ),
      _FocusModeConfig(
        title: l10n.focusChildModeTitle,
        description: l10n.focusChildModeDescription,
        icon: Icons.child_care_outlined,
        iconBackground: colorScheme.errorContainer,
        iconColor: colorScheme.error,
      ),
    ];

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg.w,
              Spacing.xxl.h,
              Spacing.lg.w,
              Spacing.lg.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.focusModesTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: Spacing.md.h),
                Text(
                  l10n.focusModesSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: Spacing.xl.h),
                ...modes.map(
                  (mode) => Padding(
                    padding: EdgeInsets.only(bottom: Spacing.lg.h),
                    child: _FocusModeCard(config: mode),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FocusModeCard extends StatelessWidget {
  const _FocusModeCard({required this.config});

  final _FocusModeConfig config;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Spacing.lg.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: config.iconBackground,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(config.icon, color: config.iconColor, size: 28.8.sp),
          ),
          SizedBox(width: Spacing.md.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: Spacing.xs.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5.sp,
                    ),
                  ),
                  SizedBox(height: Spacing.sm.h),
                  Text(
                    config.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusModeConfig {
  const _FocusModeConfig({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
}
