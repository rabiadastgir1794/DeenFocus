import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
      content: Text(message, style: TextStyle(fontSize: 16.sp, height: 1.4)),
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
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
          ),
          child: Text(primaryButtonText),
        ),
      ],
    );
  }
}
