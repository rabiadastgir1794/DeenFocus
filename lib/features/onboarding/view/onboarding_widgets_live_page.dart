import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/services/prayer_live_activity_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/onboarding_widgets_live_phone_frames.dart';

class OnboardingWidgetsLivePage extends StatelessWidget {
  const OnboardingWidgetsLivePage({super.key});

  /// iPhone frame proportions for section layout (122×228 design canvas).
  static const _phoneAspectRatio = 122 / 228;

  static const _titleGreen = Color(0xFF0F3D2E);
  static const _accentGreen = Color(0xFF1F5C45);
  static const _iconCircle = Color(0xFFDCEFE4);
  static const _bodyGrey = Color(0xFF5C7268);

  @override
  Widget build(BuildContext context) {
    final showLive = PrayerLiveActivityService.visibleOnThisPlatform;
    final l10n = AppLocalizations.of(context)!;
    final subtitle = showLive
        ? l10n.onboardingWidgetsLiveSubtitle
        : l10n.onboardingWidgetsLiveSubtitleAndroid;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Theme.of(context).colorScheme.onSurface : _titleGreen;
    final bodyColor =
        isDark ? Theme.of(context).colorScheme.onSurfaceVariant : _bodyGrey;
    final accentGreen =
        isDark ? Theme.of(context).colorScheme.primary : _accentGreen;
    final iconCircle = isDark
        ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.55)
        : _iconCircle;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 760;
        final horizontal = Spacing.lg.w;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            compact ? 4.h : 8.h,
            horizontal,
            compact ? 4.h : 8.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.onboardingWidgetsLiveTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 26.sp : 30.sp,
                  height: 1.12,
                  letterSpacing: -0.5,
                  color: titleColor,
                ),
              ),
              SizedBox(height: compact ? 8.h : 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 4.w),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: bodyColor,
                    height: 1.42,
                    fontSize: compact ? 13.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: compact ? 20.h : 32.h),
              Expanded(
                flex: showLive ? 11 : 1,
                child: Align(
                  alignment: showLive
                      ? Alignment.topCenter
                      : Alignment.center,
                  child: _WidgetsSection(
                    compact: compact,
                    iconCircle: iconCircle,
                    accentGreen: accentGreen,
                    bodyColor: bodyColor,
                    titleColor: titleColor,
                    l10n: l10n,
                  ),
                ),
              ),
              if (showLive) ...[
                SizedBox(height: compact ? 8.h : 14.h),
                Expanded(
                  flex: 10,
                  child: _LiveActivitiesSection(
                    compact: compact,
                    iconCircle: iconCircle,
                    accentGreen: accentGreen,
                    bodyColor: bodyColor,
                    titleColor: titleColor,
                    l10n: l10n,
                  ),
                ),
              ],
              SizedBox(height: compact ? 14.h : 20.h),
              _TrustBanner(
                l10n: l10n,
                accentGreen: accentGreen,
                bodyColor: bodyColor,
                compact: compact,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WidgetsSection extends StatelessWidget {
  const _WidgetsSection({
    required this.compact,
    required this.iconCircle,
    required this.accentGreen,
    required this.bodyColor,
    required this.titleColor,
    required this.l10n,
  });

  final bool compact;
  final Color iconCircle;
  final Color accentGreen;
  final Color bodyColor;
  final Color titleColor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final copy = _SectionCopy(
      compact: compact,
      iconCircle: iconCircle,
      accentGreen: accentGreen,
      bodyColor: bodyColor,
      titleColor: titleColor,
      icon: Icons.widgets_rounded,
      title: l10n.onboardingWidgetsSectionTitle,
      body: _EmphasisBodyText(
        prefix: l10n.onboardingWidgetsSectionBodyPrefix,
        emphasis: l10n.onboardingWidgetsSectionBodyEmphasis,
        bodyColor: bodyColor,
        emphasisColor: accentGreen,
        fontSize: compact ? 12.5.sp : 13.5.sp,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 11,
          child: _scrollableSectionCopy(context, copy),
        ),
        SizedBox(width: compact ? 6.w : 10.w),
        Expanded(
          flex: 12,
          child: _PhonePreviewSlot(
            aspectRatio: OnboardingWidgetsLivePage._phoneAspectRatio,
            alignment: Alignment.topRight,
            child: const OnboardingWidgetsPhonePreview(),
          ),
        ),
      ],
    );
  }
}

class _LiveActivitiesSection extends StatelessWidget {
  const _LiveActivitiesSection({
    required this.compact,
    required this.iconCircle,
    required this.accentGreen,
    required this.bodyColor,
    required this.titleColor,
    required this.l10n,
  });

  final bool compact;
  final Color iconCircle;
  final Color accentGreen;
  final Color bodyColor;
  final Color titleColor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final copy = _SectionCopy(
      compact: compact,
      iconCircle: iconCircle,
      accentGreen: accentGreen,
      bodyColor: bodyColor,
      titleColor: titleColor,
      icon: Icons.schedule_rounded,
      title: l10n.onboardingLiveActivitiesSectionTitle,
      body: _EmphasisBodyText(
        prefix: l10n.onboardingLiveActivitiesSectionBodyPrefix,
        emphasis: l10n.onboardingLiveActivitiesSectionBodyEmphasis,
        suffix: l10n.onboardingLiveActivitiesSectionBodySuffix,
        bodyColor: bodyColor,
        emphasisColor: accentGreen,
        fontSize: compact ? 12.5.sp : 13.5.sp,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 12,
          child: _PhonePreviewSlot(
            aspectRatio: OnboardingWidgetsLivePage._phoneAspectRatio,
            alignment: Alignment.centerLeft,
            child: const OnboardingLiveActivityPhonePreview(),
          ),
        ),
        SizedBox(width: compact ? 6.w : 10.w),
        Expanded(
          flex: 11,
          child: _scrollableSectionCopy(context, copy),
        ),
      ],
    );
  }
}

/// On iPad the side-by-side rows stay, but section copy scrolls if vertical
/// space is tight (prevents RenderFlex overflow without changing phone layout).
Widget _scrollableSectionCopy(BuildContext context, Widget copy) {
  if (!ResponsiveLayout.isTablet(context)) return copy;
  return SingleChildScrollView(
    physics: const ClampingScrollPhysics(),
    child: copy,
  );
}

class _SectionCopy extends StatelessWidget {
  const _SectionCopy({
    required this.compact,
    required this.iconCircle,
    required this.accentGreen,
    required this.bodyColor,
    required this.titleColor,
    required this.icon,
    required this.title,
    required this.body,
  });

  final bool compact;
  final Color iconCircle;
  final Color accentGreen;
  final Color bodyColor;
  final Color titleColor;
  final IconData icon;
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionIconCircle(
          icon: icon,
          background: iconCircle,
          iconColor: accentGreen,
          size: compact ? 42 : 46,
        ),
        SizedBox(height: compact ? 10.h : 14.h),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 17.sp : 19.sp,
            color: titleColor,
            height: 1.1,
          ),
        ),
        SizedBox(height: compact ? 6.h : 8.h),
        body,
      ],
    );
  }
}

/// Sizes a phone preview within its section without distortion.
class _PhonePreviewSlot extends StatelessWidget {
  const _PhonePreviewSlot({
    required this.aspectRatio,
    required this.alignment,
    required this.child,
  });

  final double aspectRatio;
  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        if (maxW <= 0 || maxH <= 0) {
          return const SizedBox.shrink();
        }

        var width = maxW;
        var height = width / aspectRatio;
        if (height > maxH) {
          height = maxH;
          width = height * aspectRatio;
        }

        return Align(
          alignment: alignment,
          child: SizedBox(
            width: width,
            height: height,
            child: child,
          ),
        );
      },
    );
  }
}

class _SectionIconCircle extends StatelessWidget {
  const _SectionIconCircle({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.size,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: size * 0.46, color: iconColor),
    );
  }
}

class _EmphasisBodyText extends StatelessWidget {
  const _EmphasisBodyText({
    required this.prefix,
    required this.emphasis,
    required this.bodyColor,
    required this.emphasisColor,
    required this.fontSize,
    this.suffix = '',
  });

  final String prefix;
  final String emphasis;
  final String suffix;
  final Color bodyColor;
  final Color emphasisColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: bodyColor,
          fontSize: fontSize,
          height: 1.45,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: prefix),
          TextSpan(
            text: emphasis,
            style: TextStyle(
              color: emphasisColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (suffix.isNotEmpty) TextSpan(text: suffix),
        ],
      ),
    );
  }
}

class _TrustBanner extends StatelessWidget {
  const _TrustBanner({
    required this.l10n,
    required this.accentGreen,
    required this.bodyColor,
    required this.compact,
  });

  final AppLocalizations l10n;
  final Color accentGreen;
  final Color bodyColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.55)
        : const Color(0xFFE8F2EC);
    final mosqueWidth = compact ? 48.w : 56.w;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: compact ? 12.h : 14.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: compact ? 34.w : 38.w,
            height: compact ? 34.w : 38.w,
            decoration: BoxDecoration(
              color: accentGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_rounded,
              size: compact ? 18.sp : 20.sp,
              color: accentGreen,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: compact ? 11.5.sp : 12.5.sp,
                    height: 1.38,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: l10n.onboardingWidgetsLiveTrustPrefix),
                    TextSpan(
                      text: l10n.onboardingWidgetsLiveTrustEmphasis,
                      style: TextStyle(
                        color: accentGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: l10n.onboardingWidgetsLiveTrustSuffix),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: mosqueWidth,
            height: compact ? 40.h : 46.h,
            child: CustomPaint(
              painter: _MosqueSilhouettePainter(
                color: accentGreen.withValues(alpha: isDark ? 0.14 : 0.16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MosqueSilhouettePainter extends CustomPainter {
  const _MosqueSilhouettePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Rect.fromLTWH(w * 0.08, h * 0.42, w * 0.84, h * 0.58), paint);

    void minaret(double x) {
      canvas.drawRect(Rect.fromLTWH(x, h * 0.08, w * 0.08, h * 0.34), paint);
      canvas.drawCircle(Offset(x + w * 0.04, h * 0.08), w * 0.05, paint);
    }

    minaret(w * 0.12);
    minaret(w * 0.8);

    final dome = Path()
      ..moveTo(w * 0.34, h * 0.42)
      ..quadraticBezierTo(w * 0.5, h * 0.08, w * 0.66, h * 0.42);
    canvas.drawPath(dome, paint);
  }

  @override
  bool shouldRepaint(covariant _MosqueSilhouettePainter oldDelegate) =>
      oldDelegate.color != color;
}
