import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable blocking permission dialog: title, message, Open Settings (primary), Cancel (secondary).
class AppPermissionDialog extends StatelessWidget {
  const AppPermissionDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonText = 'Open Settings',
    this.secondaryButtonText = 'Cancel',
    required this.onPrimaryTap,
    this.onSecondaryTap,
  });

  final String title;
  final String message;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onSecondaryTap;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String primaryButtonText = 'Open Settings',
    String secondaryButtonText = 'Cancel',
    required VoidCallback onPrimaryTap,
    VoidCallback? onSecondaryTap,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppPermissionDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryTap: onPrimaryTap,
        onSecondaryTap: onSecondaryTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surface;

    return AlertDialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
      contentPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
      actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: isDark ? 0.18 : 0.12,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.lock_clock_rounded,
              color: colorScheme.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                height: 1.15,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          height: 1.55,
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        if (onSecondaryTap != null)
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).maybePop();
              onSecondaryTap!();
            },
            child: Text(secondaryButtonText),
          ),
        FilledButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).maybePop();
            onPrimaryTap();
          },
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          ),
          child: Text(
            primaryButtonText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
