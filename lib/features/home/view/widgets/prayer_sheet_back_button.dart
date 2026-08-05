import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/spacing.dart';

/// Circular back button used in the header of nested Prayer Settings sheets
/// (Prayer Time, Notification) so users can return to the previous sheet
/// instead of dismissing the whole flow. Mirrors the circular icon-button
/// style already used for the settings shortcut on the Mark Prayer sheet.
class SheetBackButton extends StatelessWidget {
  const SheetBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(Spacing.sm.w),
          child: Icon(
            Icons.chevron_left_rounded,
            size: 24.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
