part of 'feature_demo_live_activity_screens.dart';

SystemUiOverlayStyle _demoOverlayStyle(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
}

/// Matches the real iOS Lock Screen Live Activity (ActivityKit) presentation.
class _LiveActivityBanner extends StatelessWidget {
  const _LiveActivityBanner({required this.l10n, required this.expanded});

  final AppLocalizations l10n;
  final bool expanded;

  /// Same tint as `PrayerLiveActivityLockScreenView.activityBackgroundTint`.
  static const Color _cardBg = Color(0xFF1A2E29);
  static const Color _muted = Color(0xB3FFFFFF);
  static const double _demoProgress = 0.45;

  @override
  Widget build(BuildContext context) {
    final secondary = TextStyle(
      color: _muted,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(expanded ? 18.w : 16.w),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(expanded ? 28.r : 24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  l10n.liveActivityNowLabel.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  l10n.homePrayerAsr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                l10n.liveActivityUpdatedAt('6:07 PM'),
                style: TextStyle(
                  color: _muted,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: expanded ? 14.h : 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3:42 PM',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: expanded ? 34.sp : 32.sp,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Lahore',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: secondary,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 120.w,
                height: 44.h,
                child: CustomPaint(
                  painter: _PrayerProgressCurvePainter(progress: _demoProgress),
                ),
              ),
            ],
          ),
          SizedBox(height: expanded ? 12.h : 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.liveActivityNextAt(
                    l10n.homePrayerMaghrib,
                    '6:37 PM',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: secondary,
                ),
              ),
              Text(
                l10n.appTitle.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
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

/// Mirrors iOS `PrayerProgressCurve` in `PrayerLiveActivityWidget.swift`.
class _PrayerProgressCurvePainter extends CustomPainter {
  _PrayerProgressCurvePainter({required this.progress});

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
      final fill = Paint()
        ..color = Colors.white.withValues(
          alpha: index <= filledThrough ? 1.0 : 0.35,
        );
      canvas.drawCircle(point, 3, fill);
    }

    final current = pointOnCurve(clamped);
    canvas.drawCircle(current, 5, Paint()..color = const Color(0xFF1A2E29));
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
  bool shouldRepaint(covariant _PrayerProgressCurvePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _AndroidOngoingCard extends StatelessWidget {
  const _AndroidOngoingCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.mosque_rounded,
              color: colorScheme.onPrimary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.liveActivityNowLabel} · ${l10n.homePrayerMaghrib}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${l10n.featureDemoLiveActivitySampleTime} · ${l10n.liveActivityNextAt(l10n.homePrayerIsha, l10n.featureDemoLiveActivitySampleNextTime)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
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

class _AndroidShadeCard extends StatelessWidget {
  const _AndroidShadeCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mosque_rounded, color: colorScheme.primary, size: 18.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  l10n.appTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                l10n.featureDemoAndroidOngoingBadge,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            '${l10n.liveActivityNowLabel} · ${l10n.homePrayerMaghrib}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            l10n.featureDemoLiveActivitySampleTime,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.liveActivityNextAt(
              l10n.homePrayerIsha,
              l10n.featureDemoLiveActivitySampleNextTime,
            ),
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
