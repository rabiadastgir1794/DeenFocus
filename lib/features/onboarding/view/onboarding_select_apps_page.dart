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
    this.onMaybeLater,
    this.isLoading = false,
    this.isAutoAdvancing = false,
  });

  final VoidCallback onSelectAppsTap;
  final VoidCallback onSkipForNowTap;
  final VoidCallback? onMaybeLater;
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
        final iconSize = compact ? 52.r : 58.r;

        return AbsorbPointer(
          absorbing: isLoading || isAutoAdvancing,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg.w,
              compact ? Spacing.sm.h : Spacing.md.h,
              Spacing.lg.w,
              Spacing.sm.h,
            ),
            child: Column(
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    size: compact ? 22.sp : 24.sp,
                    color: colorScheme.primary,
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
                          fontSize: compact ? 24.sp : 28.sp,
                          height: 1.15,
                          letterSpacing: -0.4,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: l10n.onboardingSelectAppsTitleAccent,
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: compact ? 24.sp : 28.sp,
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
                    fontSize: compact ? 13.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: constraints.maxWidth - (Spacing.lg.w * 2),
                        child: _SelectAppsIllustration(compact: compact),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: compact ? Spacing.sm.h : Spacing.md.h),
                const _SelectAppsPrivacyBanner(),
                Selector<FocusController, String?>(
                  selector: (_, focus) => focus.selectedAppCount > 0
                      ? focus.selectedTargetPhrase
                      : null,
                  builder: (context, phrase, _) {
                    if (phrase == null) {
                      return SizedBox(height: compact ? Spacing.md.h : Spacing.lg.h);
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
                  height: 52.h,
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
                        borderRadius: BorderRadius.circular(16.r),
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
                              Icon(Icons.lock_rounded, size: 18.sp),
                              SizedBox(width: Spacing.sm.w),
                              Text(
                                l10n.onboardingSelectAppsButton,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                if (!isAutoAdvancing) ...[
                  SizedBox(height: Spacing.md.h),
                  _SkipForNowDivider(
                    label: l10n.onboardingSelectAppsSkipForNow,
                    onTap: isLoading ? null : onSkipForNowTap,
                  ),
                  if (onMaybeLater != null) ...[
                    SizedBox(height: Spacing.md.h),
                    _MaybeLaterButton(
                      label: l10n.notificationsMaybeLater,
                      onPressed: isLoading ? null : onMaybeLater,
                    ),
                  ],
                ] else
                  SizedBox(height: 36.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectAppsPrivacyBanner extends StatelessWidget {
  const _SelectAppsPrivacyBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 22.sp,
            color: colorScheme.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.onboardingSelectAppsPrivacyTitle,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  l10n.onboardingSelectAppsPrivacyBody,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    height: 1.35,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipForNowDivider extends StatelessWidget {
  const _SkipForNowDivider({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lineColor = colorScheme.outlineVariant.withValues(alpha: 0.9);

    return Row(
      children: [
        Expanded(child: Divider(height: 1, color: lineColor)),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
            padding: EdgeInsets.symmetric(horizontal: Spacing.md.w, vertical: 4.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(height: 1, color: lineColor)),
      ],
    );
  }
}

class _MaybeLaterButton extends StatelessWidget {
  const _MaybeLaterButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
        ),
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
    final iconSize = compact ? 28.w : 30.w;

    final rows = <({String name, Widget icon, bool selected})>[
      (
        name: l10n.onboardingSelectAppsMockAllApps,
        icon: _TintedAppIcon(
          background: const Color(0xFFE8F0FF),
          icon: Icons.apps_rounded,
          foreground: const Color(0xFF5B7CFA),
          isDark: isDark,
          size: iconSize,
        ),
        selected: true,
      ),
      (
        name: l10n.screenTimeAppInstagram,
        icon: _SelectAppsBrandIcon(
          kind: _SelectAppsBrandKind.instagram,
          size: iconSize,
        ),
        selected: true,
      ),
      (
        name: l10n.screenTimeAppTikTok,
        icon: _SelectAppsBrandIcon(
          kind: _SelectAppsBrandKind.tiktok,
          size: iconSize,
        ),
        selected: true,
      ),
      (
        name: l10n.screenTimeAppYouTube,
        icon: _SelectAppsBrandIcon(
          kind: _SelectAppsBrandKind.youtube,
          size: iconSize,
        ),
        selected: true,
      ),
      (
        name: l10n.onboardingSelectAppsMockSafari,
        icon: _TintedAppIcon(
          background: const Color(0xFFE3F2FD),
          icon: Icons.public_rounded,
          foreground: const Color(0xFF1E88E5),
          isDark: isDark,
          size: iconSize,
        ),
        selected: false,
      ),
      (
        name: l10n.onboardingSelectAppsMockPodcasts,
        icon: _TintedAppIcon(
          background: const Color(0xFFE8F5E9),
          icon: Icons.podcasts_rounded,
          foreground: const Color(0xFF2E7D32),
          isDark: isDark,
          size: iconSize,
        ),
        selected: false,
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface,
        borderRadius: BorderRadius.circular(22.r),
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
              icon: rows[i].icon,
              selected: rows[i].selected,
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
    required this.icon,
    required this.selected,
    required this.compact,
  });

  final String name;
  final Widget icon;
  final bool selected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rowHeight = compact ? 44.h : 50.h;

    return SizedBox(
      height: rowHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            icon,
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
            _MockCheckbox(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _MockCheckbox extends StatelessWidget {
  const _MockCheckbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = 20.w;
    final radius = BorderRadius.circular(6.r);

    if (selected) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: radius,
        ),
        child: Icon(
          Icons.check_rounded,
          size: 14.sp,
          color: colorScheme.onPrimary,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.6,
        ),
      ),
    );
  }
}

class _TintedAppIcon extends StatelessWidget {
  const _TintedAppIcon({
    required this.background,
    required this.icon,
    required this.foreground,
    required this.isDark,
    required this.size,
  });

  final Color background;
  final IconData icon;
  final Color foreground;
  final bool isDark;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? background.withValues(alpha: 0.22) : background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        size: size * 0.6,
        color: isDark ? foreground.withValues(alpha: 0.9) : foreground,
      ),
    );
  }
}

enum _SelectAppsBrandKind { instagram, tiktok, youtube }

class _SelectAppsBrandIcon extends StatelessWidget {
  const _SelectAppsBrandIcon({required this.kind, required this.size});

  final _SelectAppsBrandKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(8.r);

    switch (kind) {
      case _SelectAppsBrandKind.instagram:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFF58529),
                Color(0xFFDD2A7B),
                Color(0xFF8134AF),
              ],
            ),
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            size: size * 0.55,
            color: Colors.white,
          ),
        );
      case _SelectAppsBrandKind.tiktok:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF010101),
            borderRadius: radius,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(size * 0.08, 0),
                child: Icon(
                  Icons.music_note_rounded,
                  size: size * 0.62,
                  color: const Color(0xFF25F4EE),
                ),
              ),
              Transform.translate(
                offset: Offset(-size * 0.08, 0),
                child: Icon(
                  Icons.music_note_rounded,
                  size: size * 0.62,
                  color: const Color(0xFFFE2C55),
                ),
              ),
              Icon(
                Icons.music_note_rounded,
                size: size * 0.58,
                color: Colors.white,
              ),
            ],
          ),
        );
      case _SelectAppsBrandKind.youtube:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: radius,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Center(
            child: Container(
              width: size * 0.72,
              height: size * 0.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: size * 0.46,
                color: Colors.white,
              ),
            ),
          ),
        );
    }
  }
}
