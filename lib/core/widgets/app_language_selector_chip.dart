import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/spacing.dart';

/// Chip showing current language with dropdown. Reusable in onboarding and settings.
class AppLanguageSelectorChip extends StatelessWidget {
  const AppLanguageSelectorChip({
    super.key,
    required this.label,
    this.flagEmoji,
    this.onTap,
  });

  final String label;
  final String? flagEmoji;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.md.w,
            vertical: Spacing.sm.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.global,
                size: 20.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              if (flagEmoji != null) ...[
                SizedBox(width: Spacing.xs.w),
                Text(flagEmoji!, style: TextStyle(fontSize: 16.sp)),
              ],
              SizedBox(width: Spacing.sm.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: Spacing.xs.w),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 16.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
