import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Horizontal dot progress for onboarding. Active step is elongated pill.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentIndex,
  });

  final int totalSteps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inactiveColor = colorScheme.outlineVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : inactiveColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

/// Top-attached linear progress bar for onboarding steps.
class AppStepProgressLine extends StatelessWidget {
  const AppStepProgressLine({
    super.key,
    required this.totalSteps,
    required this.currentIndex,
  });

  final int totalSteps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = colorScheme.outlineVariant;

    if (totalSteps <= 0) {
      return SizedBox(
        width: double.infinity,
        height: 2.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2.r),
          child: LinearProgressIndicator(
            value: 0,
            backgroundColor: backgroundColor.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
      );
    }

    final safeIndex = currentIndex.clamp(0, totalSteps - 1);
    final progress = (safeIndex + 1) / totalSteps;

    return SizedBox(
      width: double.infinity,
      height: 3.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.r),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: backgroundColor.withValues(alpha: 0.3),
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
    );
  }
}
