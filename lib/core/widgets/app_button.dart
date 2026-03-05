import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/spacing.dart';

enum AppButtonVariant { primary, disabled }

/// Full-width rounded button with optional trailing icon.
/// Use for primary CTAs; disabled state when [enabled] is false.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.loading = false,
    this.showTrailingIcon = true,
    this.variant,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool loading;
  final bool showTrailingIcon;
  final AppButtonVariant? variant;

  bool get _isDisabled => !enabled || loading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveVariant =
        variant ??
        (_isDisabled ? AppButtonVariant.disabled : AppButtonVariant.primary);

    final backgroundColor = effectiveVariant == AppButtonVariant.primary
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final foregroundColor = effectiveVariant == AppButtonVariant.primary
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: foregroundColor,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.lg.w,
            vertical: Spacing.md.h,
          ),
        ),
        child: loading
            ? SizedBox(
                height: 24.h,
                width: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showTrailingIcon) ...[
                    SizedBox(width: Spacing.sm.w),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 20.sp,
                      color: foregroundColor,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
