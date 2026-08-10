import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// DeenFocus segmented control: green outline when idle, dark green fill + white
/// label when selected.
ButtonStyle deenSegmentStyle(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor =
      colorScheme.primary.withValues(alpha: isDark ? 0.75 : 0.6);
  final selectedFill =
      isDark ? colorScheme.primary : AppColors.primaryContainerDark;

  return SegmentedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: colorScheme.primary,
    selectedBackgroundColor: selectedFill,
    selectedForegroundColor: AppColors.onPrimaryLight,
    disabledBackgroundColor: Colors.transparent,
    disabledForegroundColor:
        colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
    side: BorderSide(color: borderColor, width: 1.2),
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
    visualDensity: VisualDensity.compact,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
  );
}
