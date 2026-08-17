import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/spacing.dart';

/// Shared demo completion chrome (App Lock + feature demos).
class AppLockDemoCompletion extends StatelessWidget {
  const AppLockDemoCompletion({
    super.key,
    required this.completionTitle,
    required this.completionSubtitle,
    required this.completionBody,
    required this.completionCta,
    required this.onContinue,
    this.showCompletionHeart = false,
  });

  final String completionTitle;
  final String completionSubtitle;
  final String completionBody;
  final String completionCta;
  final VoidCallback onContinue;
  final bool showCompletionHeart;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomPad =
        Spacing.lg.h + MediaQuery.paddingOf(context).bottom;
    final logoSize = 88.w;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),
          Center(
            child: Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/app_icon.png',
                fit: BoxFit.cover,
                width: logoSize,
                height: logoSize,
              ),
            ),
          ),
          SizedBox(height: Spacing.lg.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  completionTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                    fontSize: 30.sp,
                  ),
                ),
              ),
              if (showCompletionHeart) ...[
                SizedBox(width: 8.w),
                Icon(
                  Icons.favorite_rounded,
                  color: colorScheme.primary.withValues(alpha: 0.55),
                  size: 22.sp,
                ),
              ],
            ],
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            completionSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          Text(
            completionBody,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const Spacer(flex: 3),
          SizedBox(
            height: 56.h,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                completionCta,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: bottomPad),
        ],
      ),
    );
  }
}
