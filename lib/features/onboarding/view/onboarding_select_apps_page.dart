import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../focus/viewmodel/focus_controller.dart';

/// Onboarding step: select apps to lock during prayer / Focus Mode.
///
/// "Select Apps" opens the shared Focus Mode picker
/// ([FocusAppSelectionFlow]); selections persist in Focus settings.
class OnboardingSelectAppsPage extends StatelessWidget {
  const OnboardingSelectAppsPage({
    super.key,
    required this.onSelectAppsTap,
    required this.onSkipForNowTap,
    this.isLoading = false,
    this.isAutoAdvancing = false,
  });

  final VoidCallback onSelectAppsTap;
  final VoidCallback onSkipForNowTap;
  final bool isLoading;
  final bool isAutoAdvancing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 720;

        return AbsorbPointer(
          absorbing: isLoading || isAutoAdvancing,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
            child: Column(
              children: [
                SizedBox(height: compact ? Spacing.sm.h : Spacing.md.h),
                Expanded(
                  flex: compact ? 5 : 6,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _SelectAppsIllustration(compact: compact),
                  ),
                ),
                SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${l10n.onboardingSelectAppsTitlePrefix} ',
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: compact ? 26.sp : 30.sp,
                          height: 1.15,
                          letterSpacing: -0.4,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: l10n.onboardingSelectAppsTitleAccent,
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: compact ? 26.sp : 30.sp,
                          height: 1.15,
                          letterSpacing: -0.4,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Spacing.sm.h),
                Text(
                  l10n.onboardingSelectAppsSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                    fontSize: compact ? 13.sp : 14.5.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // Compact count pill — same style as Focus Mode header chip.
                Selector<FocusController, String?>(
                  selector: (_, focus) => focus.selectedAppCount > 0
                      ? focus.selectedTargetPhrase
                      : null,
                  builder: (context, phrase, _) {
                    if (phrase == null) {
                      return SizedBox(
                        height: compact ? Spacing.md.h : Spacing.lg.h,
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        top: Spacing.sm.h,
                        bottom: compact ? Spacing.md.h : Spacing.lg.h,
                      ),
                      child: _SelectedCountChip(
                        phrase: phrase,
                        isAutoAdvancing: isAutoAdvancing,
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: (isLoading || isAutoAdvancing)
                        ? null
                        : onSelectAppsTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      disabledBackgroundColor:
                          colorScheme.primary.withValues(alpha: 0.55),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_rounded, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                l10n.onboardingSelectAppsButton,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: Spacing.sm.h),
                if (!isAutoAdvancing)
                  TextButton(
                    onPressed: isLoading ? null : onSkipForNowTap,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      l10n.onboardingSelectAppsSkipForNow,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  SizedBox(height: 36.h),
                SizedBox(height: Spacing.sm.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectedCountChip extends StatelessWidget {
  const _SelectedCountChip({
    required this.phrase,
    required this.isAutoAdvancing,
  });

  final String phrase;
  final bool isAutoAdvancing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 14.sp,
              color: colorScheme.primary,
            ),
            SizedBox(width: 6.w),
            Text(
              phrase,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
            if (isAutoAdvancing) ...[
              SizedBox(width: 8.w),
              SizedBox(
                width: 12.w,
                height: 12.w,
                child: CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectAppsIllustration extends StatelessWidget {
  const _SelectAppsIllustration({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final rows = <({String name, Color iconBg, IconData icon, Color iconFg})>[
      (
        name: l10n.onboardingSelectAppsMockAllApps,
        iconBg: const Color(0xFFE8F0FF),
        icon: Icons.apps_rounded,
        iconFg: const Color(0xFF5B7CFA),
      ),
      (
        name: l10n.onboardingSelectAppsMockPhotos,
        iconBg: const Color(0xFFFFE8F0),
        icon: Icons.photo_rounded,
        iconFg: const Color(0xFFE85D8A),
      ),
      (
        name: l10n.onboardingSelectAppsMockNotes,
        iconBg: const Color(0xFFFFF3D6),
        icon: Icons.sticky_note_2_rounded,
        iconFg: const Color(0xFFD4A017),
      ),
      (
        name: l10n.onboardingSelectAppsMockMusic,
        iconBg: const Color(0xFFFFE5E5),
        icon: Icons.music_note_rounded,
        iconFg: const Color(0xFFE53935),
      ),
      (
        name: l10n.onboardingSelectAppsMockSafari,
        iconBg: const Color(0xFFE3F2FD),
        icon: Icons.public_rounded,
        iconFg: const Color(0xFF1E88E5),
      ),
      (
        name: l10n.onboardingSelectAppsMockPodcasts,
        iconBg: const Color(0xFFE8F5E9),
        icon: Icons.podcasts_rounded,
        iconFg: const Color(0xFF2E7D32),
      ),
    ];

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 340.w),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: isDark ? 0.35 : 0.22,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.28 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _MockAppRow(
              name: rows[i].name,
              iconBackground: isDark
                  ? rows[i].iconBg.withValues(alpha: 0.22)
                  : rows[i].iconBg,
              icon: rows[i].icon,
              iconColor: isDark ? rows[i].iconFg.withValues(alpha: 0.9) : rows[i].iconFg,
              compact: compact,
            ),
            if (i < rows.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 56.w,
                color: colorScheme.outlineVariant.withValues(
                  alpha: isDark ? 0.35 : 0.45,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _MockAppRow extends StatelessWidget {
  const _MockAppRow({
    required this.name,
    required this.iconBackground,
    required this.icon,
    required this.iconColor,
    required this.compact,
  });

  final String name;
  final Color iconBackground;
  final IconData icon;
  final Color iconColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final checkBg = colorScheme.primary.withValues(alpha: 0.14);
    final rowHeight = compact ? 48.h : 54.h;

    return SizedBox(
      height: rowHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: checkBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 14.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 18.sp, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: compact ? 14.sp : 15.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
