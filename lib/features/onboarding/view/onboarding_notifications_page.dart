import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/onboarding_notification_phone_preview.dart';

class OnboardingNotificationsPage extends StatelessWidget {
  const OnboardingNotificationsPage({
    super.key,
    required this.onEnableTap,
    this.isLoading = false,
    this.showEnableButton = true,
  });

  final VoidCallback onEnableTap;
  final bool isLoading;

  /// When false, notification permission is already granted.
  final bool showEnableButton;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 720;
        final horizontal = Spacing.lg.w;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            compact ? Spacing.sm.h : Spacing.md.h,
            horizontal,
            Spacing.sm.h,
          ),
          child: Column(
            children: [
              Container(
                width: compact ? 52.r : 58.r,
                height: compact ? 52.r : 58.r,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  CupertinoIcons.bell,
                  size: compact ? 22.sp : 24.sp,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h),
              Text(
                l10n.notificationsTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 24.sp : 28.sp,
                  height: 1.15,
                  letterSpacing: -0.35,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: Spacing.sm.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.sm.w),
                child: Text(
                  l10n.notificationsSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                    fontSize: compact ? 13.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * 0.72,
                      maxHeight: constraints.maxHeight * (compact ? 0.48 : 0.52),
                    ),
                    child: const OnboardingNotificationPhonePreview(),
                  ),
                ),
              ),
              SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h),
              if (showEnableButton)
                _EnableNotificationsButton(
                  label: l10n.notificationsButton,
                  loading: isLoading,
                  onPressed: onEnableTap,
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: colorScheme.primary,
                      size: 22.sp,
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Text(
                        l10n.notificationsEnabled,
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EnableNotificationsButton extends StatelessWidget {
  const _EnableNotificationsButton({
    required this.label,
    required this.onPressed,
    required this.loading,
  });

  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.7),
          disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.7),
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
        ),
        child: loading
            ? SizedBox(
                height: 22.h,
                width: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.bell, size: 18.sp),
                  SizedBox(width: Spacing.sm.w),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
