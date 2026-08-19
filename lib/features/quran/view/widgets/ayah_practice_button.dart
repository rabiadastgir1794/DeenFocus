import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Prominent entry to AI Tajweed practice — separate from ayah audio play.
class AyahPracticeButton extends StatelessWidget {
  const AyahPracticeButton({
    super.key,
    required this.onPressed,
    this.compact = false,
  });

  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimaryContainer,
        );

    if (compact) {
      return Material(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.record_voice_over_rounded,
                  size: 16.sp,
                  color: colorScheme.onPrimaryContainer,
                ),
                SizedBox(width: 6.w),
                Text('Recite', style: labelStyle),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(Icons.record_voice_over_rounded, size: 20.sp),
        label: Text(
          'Practice Tajweed',
          style: labelStyle?.copyWith(fontSize: 14.sp),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}
