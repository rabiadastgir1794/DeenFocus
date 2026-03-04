import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingFocusModePage extends StatelessWidget {
  const OnboardingFocusModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final modes = [
      _FocusModeConfig(
        title: l10n.focusPrayerModeTitle,
        description: l10n.focusPrayerModeDescription,
        icon: Icons.shield_outlined,
        iconBackground: const Color(0xFFDEE8E1),
        iconColor: const Color(0xFF3F8F6E),
      ),
      _FocusModeConfig(
        title: l10n.focusSleepModeTitle,
        description: l10n.focusSleepModeDescription,
        icon: Icons.nights_stay_outlined,
        iconBackground: const Color(0xFFDCE9EF),
        iconColor: const Color(0xFF1F4A62),
      ),
      _FocusModeConfig(
        title: l10n.focusChildModeTitle,
        description: l10n.focusChildModeDescription,
        icon: Icons.child_care_outlined,
        iconBackground: const Color(0xFFF6DEDB),
        iconColor: const Color(0xFFDA2B2B),
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
                    fontSize: 32.sp,
                  ),
                ),
                SizedBox(height: Spacing.md.h),
                Text(
                  l10n.focusModesSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                    fontSize: 16.sp,
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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Spacing.lg.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F2),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFECE6E0)),
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
            child: Icon(
              config.icon,
              color: config.iconColor,
              size: 32.sp,
            ),
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
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: Spacing.sm.h),
                  Text(
                    config.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                      fontSize: 16.sp,
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

class _SubtlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEDE8E2)
      ..strokeWidth = 0.8;
    const spacing = 42.0;

    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }

    for (double x = 0; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
