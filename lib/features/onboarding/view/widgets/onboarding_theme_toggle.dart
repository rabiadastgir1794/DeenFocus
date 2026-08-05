import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/theme_service.dart';

/// Compact sun/moon theme toggle for the onboarding welcome header.
class OnboardingThemeToggle extends StatelessWidget {
  const OnboardingThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.select<ThemeService, bool>(
      (service) => service.isDarkModeEnabled,
    );

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.72),
      shape: StadiumBorder(
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.read<ThemeService>().setDarkModeEnabled(!isDark);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 18.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
