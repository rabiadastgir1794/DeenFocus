import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/prayer_live_activity_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/view/widgets/feature_demo/feature_demo_kind.dart';
import '../settings/settings_app_demo_screen.dart';

/// Home promo for Live Activity — visible until enabled or dismissed.
class HomeLiveActivityPromoCard extends StatefulWidget {
  const HomeLiveActivityPromoCard({super.key});

  @override
  State<HomeLiveActivityPromoCard> createState() =>
      _HomeLiveActivityPromoCardState();
}

class _HomeLiveActivityPromoCardState extends State<HomeLiveActivityPromoCard> {
  bool _visible = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    PrayerLiveActivityService.instance.preferenceListenable.addListener(
      _onPreferenceChanged,
    );
    unawaited(_refreshVisibility());
  }

  @override
  void dispose() {
    PrayerLiveActivityService.instance.preferenceListenable.removeListener(
      _onPreferenceChanged,
    );
    super.dispose();
  }

  void _onPreferenceChanged() {
    unawaited(_refreshVisibility());
  }

  Future<void> _refreshVisibility() async {
    final caps = await PrayerLiveActivityService.instance.getCapabilities();
    final supported = caps['supportsLiveActivity'] == true;
    final enabled = await PrayerLiveActivityService.instance.resolveEnabled();
    final dismissed = await StorageService.homeLiveActivityPromoDismissed;
    if (!mounted) return;
    setState(() {
      _visible = supported && !enabled && !dismissed;
      _loading = false;
    });
  }

  Future<void> _dismiss() async {
    await StorageService.setHomeLiveActivityPromoDismissed(true);
    if (!mounted) return;
    setState(() => _visible = false);
  }

  void _openTutorial() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const SettingsAppDemoScreen(
          initialFeatureKind: FeatureDemoKind.liveActivity,
          popOnWalkthroughExit: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || !_visible) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? colorScheme.primaryContainer.withValues(alpha: 0.35)
        : const Color(0xFFE8F5EF);
    final titleColor = isDark
        ? colorScheme.onSurface
        : const Color(0xFF0F3D2E);
    final bodyColor = isDark
        ? colorScheme.onSurfaceVariant
        : const Color(0xFF245C48);

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openTutorial,
          borderRadius: BorderRadius.circular(20.r),
          child: Ink(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isDark
                    ? colorScheme.outlineVariant.withValues(alpha: 0.35)
                    : AppColors.outlineVariantLight.withValues(alpha: 0.25),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DottedArcPainter(
                      color:
                          (isDark
                                  ? colorScheme.primary
                                  : const Color(0xFF7BC4A4))
                              .withValues(alpha: 0.35),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 12.h, 8.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header: icon + title | close (kept above the phone).
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.graphic_eq_rounded,
                              size: 16.sp,
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              l10n.homeLivePrayerUpdatesTitle,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: titleColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: 32.w,
                            height: 32.w,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () => unawaited(_dismiss()),
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18.sp,
                                color: bodyColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      // Body: copy + CTA | phone (Live Activity hangs off phone).
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.homeLivePrayerUpdatesBody,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: bodyColor,
                                          height: 1.35,
                                        ),
                                  ),
                                  SizedBox(height: 12.h),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 8.h,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              l10n.homeLivePrayerUpdatesCta,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 16.sp,
                                            color: colorScheme.onPrimary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const _PromoPhoneMockup(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PromoPhoneMockup extends StatelessWidget {
  const _PromoPhoneMockup();

  /// Matches the real lock-screen Live Activity charcoal-green.
  static const Color _liveCardBg = Color(0xFF0D1F1A);
  static const Color _liveCardBorder = Color(0xFF6B8F7A);
  static const Color _muted = Color(0xB3C8D9CF);
  static const Color _accentMint = Color(0xFFA3D9A5);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phoneWidth = 92.w;
    final liveWidth = 124.w;
    final hang = (liveWidth - phoneWidth) / 2;

    return SizedBox(
      width: liveWidth,
      height: 154.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Phone frame — green lock-screen wallpaper like the real device.
          Positioned(
            top: 0,
            left: hang,
            width: phoneWidth,
            bottom: 8.h,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A14),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFF2A3D34), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(painter: _GreenLockWallpaperPainter()),
                  ),
                  // Mini Dynamic Island.
                  Positioned(
                    top: 5.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.graphic_eq_rounded,
                              size: 7.sp,
                              color: _accentMint,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              l10n.homePrayerAsr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 6.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              '3:42 PM',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 6.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 26.h,
                    left: 6.w,
                    right: 6.w,
                    child: Column(
                      children: [
                        Text(
                          '18:07',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          l10n.featureDemoLiveActivityLockHint,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Wider than the phone so the Live Activity peeks past the bezel.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 320,
                child: _PromoLiveActivityCard(l10n: l10n),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft green circular wallpaper matching the Lock Screen screenshot.
class _GreenLockWallpaperPainter extends CustomPainter {
  const _GreenLockWallpaperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF0A1A14),
    );

    void blob(Offset c, double r, Color color) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );
    }

    blob(
      Offset(size.width * 0.15, size.height * 0.2),
      size.width * 0.55,
      const Color(0xFF1B3A2E),
    );
    blob(
      Offset(size.width * 0.85, size.height * 0.35),
      size.width * 0.65,
      const Color(0xFF2A4A3A),
    );
    blob(
      Offset(size.width * 0.45, size.height * 0.55),
      size.width * 0.7,
      const Color(0xFF3D5C4A).withValues(alpha: 0.85),
    );
    blob(
      Offset(size.width * 0.2, size.height * 0.85),
      size.width * 0.5,
      const Color(0xFF4A6355).withValues(alpha: 0.7),
    );
    blob(
      Offset(size.width * 0.9, size.height * 0.9),
      size.width * 0.45,
      const Color(0xFF243D32),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Full-size Live Activity layout; [FittedBox] parent scales it into the phone.
class _PromoLiveActivityCard extends StatelessWidget {
  const _PromoLiveActivityCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    const muted = _PromoPhoneMockup._muted;
    const accent = _PromoPhoneMockup._accentMint;
    final secondary = const TextStyle(
      color: muted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.15,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _PromoPhoneMockup._liveCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _PromoPhoneMockup._liveCardBorder.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5A42),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.liveActivityNowLabel.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFA3D9A5),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.homePrayerAsr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                l10n.liveActivityUpdatedAt('6:07 PM'),
                style: secondary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3:42 PM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Lahore', style: secondary),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                width: 110,
                height: 40,
                child: CustomPaint(
                  painter: _PromoProgressCurvePainter(progress: 0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MintAccentNextPrayerLine(
                  full: l10n.liveActivityNextAt(
                    l10n.homePrayerMaghrib,
                    '6:37 PM',
                  ),
                  time: '6:37 PM',
                  mutedStyle: secondary,
                  accentStyle: const TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                l10n.appTitle.toUpperCase(),
                style: const TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Styles the time portion of a next-prayer line in mint; keeps l10n word order.
class _MintAccentNextPrayerLine extends StatelessWidget {
  const _MintAccentNextPrayerLine({
    required this.full,
    required this.time,
    required this.mutedStyle,
    required this.accentStyle,
  });

  final String full;
  final String time;
  final TextStyle mutedStyle;
  final TextStyle accentStyle;

  @override
  Widget build(BuildContext context) {
    final index = full.indexOf(time);
    if (index < 0) {
      return Text(full, style: mutedStyle);
    }
    return Text.rich(
      TextSpan(
        children: [
          if (index > 0)
            TextSpan(text: full.substring(0, index), style: mutedStyle),
          TextSpan(text: time, style: accentStyle),
          if (index + time.length < full.length)
            TextSpan(
              text: full.substring(index + time.length),
              style: mutedStyle,
            ),
        ],
      ),
    );
  }
}

/// Compact copy of the iOS Live Activity progress curve for the promo phone.
class _PromoProgressCurvePainter extends CustomPainter {
  const _PromoProgressCurvePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final clamped = progress.clamp(0.0, 1.0);

    final curvePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, h * 0.75)
      ..quadraticBezierTo(w * 0.5, h * 0.05, w, h * 0.75);
    canvas.drawPath(path, curvePaint);

    Offset pointOnCurve(double t) {
      final p0 = Offset(0, h * 0.75);
      final p1 = Offset(w * 0.5, h * 0.05);
      final p2 = Offset(w, h * 0.75);
      final mt = 1 - t;
      return Offset(
        mt * mt * p0.dx + 2 * mt * t * p1.dx + t * t * p2.dx,
        mt * mt * p0.dy + 2 * mt * t * p1.dy + t * t * p2.dy,
      );
    }

    final filledThrough = (clamped * 4).round();
    for (var index = 0; index < 5; index++) {
      final point = pointOnCurve(index / 4.0);
      canvas.drawCircle(
        point,
        3,
        Paint()
          ..color = Colors.white.withValues(
            alpha: index <= filledThrough ? 1.0 : 0.35,
          ),
      );
    }

    final current = pointOnCurve(clamped);
    canvas.drawCircle(
      current,
      5,
      Paint()..color = _PromoPhoneMockup._liveCardBg,
    );
    canvas.drawCircle(
      current,
      5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _PromoProgressCurvePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _DottedArcPainter extends CustomPainter {
  _DottedArcPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.35, size.height * 0.15)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.05,
        size.width * 0.95,
        size.height * 0.55,
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + 4;
        final extract = metric.extractPath(
          distance,
          next.clamp(0, metric.length),
        );
        canvas.drawPath(extract, paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedArcPainter oldDelegate) =>
      oldDelegate.color != color;
}
