import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/spacing.dart';

/// Shared immersive Skip control for App Demo walkthroughs.
///
/// Stays inside the safe area with enough end padding to remain tappable.
class AppDemoSkipButton extends StatelessWidget {
  const AppDemoSkipButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.foregroundColor,
    this.showShadow = false,
  });

  final VoidCallback onPressed;
  final String label;
  final Color foregroundColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: true,
      top: true,
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            end: Spacing.md.w,
            top: Spacing.xs.h,
          ),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: foregroundColor,
              minimumSize: Size(48.w, 44.h),
              tapTargetSize: MaterialTapTargetSize.padded,
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.md.w,
                vertical: Spacing.sm.h,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                shadows: showShadow
                    ? const [Shadow(blurRadius: 8, color: Colors.black54)]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
