import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Circular background with centered icon. Used on onboarding screens.
class AppIconCircle extends StatelessWidget {
  const AppIconCircle({
    super.key,
    required this.icon,
    this.size,
    this.iconSize,
  });

  final Widget icon;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = AppColors.primary;
    final bg = isDark ? base.withOpacity(0.24) : base.withOpacity(0.08);
    final s = size ?? 72.r;
    final iSize = iconSize ?? 32.sp;

    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconTheme(
          data: IconThemeData(size: iSize, color: AppColors.primary),
          child: icon,
        ),
      ),
    );
  }
}
