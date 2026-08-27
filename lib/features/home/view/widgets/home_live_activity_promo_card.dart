import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/prayer_live_activity_service.dart';
import '../../../../core/services/prayer_live_activity_toggle.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/view/widgets/feature_demo/feature_demo_kind.dart';
import '../settings/settings_app_demo_screen.dart';

/// Home promo carousel: Live Activity + Widgets.
class HomeLiveActivityPromoCard extends StatefulWidget {
  const HomeLiveActivityPromoCard({super.key});

  @override
  State<HomeLiveActivityPromoCard> createState() =>
      _HomeLiveActivityPromoCardState();
}

class _HomeLiveActivityPromoCardState extends State<HomeLiveActivityPromoCard> {
  bool _liveVisible = false;
  bool _widgetsVisible = false;
  bool _loading = true;
  bool _enabling = false;
  int _page = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    PrayerLiveActivityService.instance.preferenceListenable.addListener(
      _onPreferenceChanged,
    );
    unawaited(_refreshVisibility());
  }

  @override
  void dispose() {
    _pageController.dispose();
    PrayerLiveActivityService.instance.preferenceListenable.removeListener(
      _onPreferenceChanged,
    );
    super.dispose();
  }

  void _onPreferenceChanged() {
    unawaited(_refreshVisibility());
  }

  Future<void> _refreshVisibility() async {
    var supported = false;
    var enabled = false;
    if (PrayerLiveActivityService.visibleOnThisPlatform) {
      final caps = await PrayerLiveActivityService.instance.getCapabilities();
      supported = caps['supportsLiveActivity'] == true;
      enabled = await PrayerLiveActivityService.instance.resolveEnabled();
    }
    final liveDismissed = await StorageService.homeLiveActivityPromoDismissed;
    final widgetsDismissed = await StorageService.homeWidgetsPromoDismissed;
    if (!mounted) return;
    setState(() {
      _liveVisible = PrayerLiveActivityService.visibleOnThisPlatform &&
          supported &&
          !enabled &&
          !liveDismissed;
      _widgetsVisible = !widgetsDismissed;
      _loading = false;
      if (_slideCount <= 1) _page = 0;
    });
  }

  int get _slideCount {
    var count = 0;
    if (_liveVisible) count++;
    if (_widgetsVisible) count++;
    return count;
  }

  Future<void> _dismissLive() async {
    await StorageService.setHomeLiveActivityPromoDismissed(true);
    if (!mounted) return;
    setState(() {
      _liveVisible = false;
      _page = 0;
    });
  }

  Future<void> _dismissWidgets() async {
    await StorageService.setHomeWidgetsPromoDismissed(true);
    if (!mounted) return;
    setState(() {
      _widgetsVisible = false;
      _page = 0;
    });
  }

  Future<void> _enableLiveActivity() async {
    if (_enabling) return;
    setState(() => _enabling = true);
    try {
      final ok = await PrayerLiveActivityToggle.applyWithDialogs(
        context,
        enabled: true,
      );
      if (!mounted) return;
      if (ok) {
        await _refreshVisibility();
      }
    } finally {
      if (mounted) setState(() => _enabling = false);
    }
  }

  Future<void> _openWidgetsDemo() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SettingsAppDemoScreen(
          initialFeatureKind: FeatureDemoKind.widgets,
          popOnWalkthroughExit: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _slideCount == 0) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final slides = <Widget>[
      if (_liveVisible)
        _HomePromoSlide(
          icon: Icons.graphic_eq_rounded,
          title: l10n.homeLivePrayerUpdatesTitle,
          body: l10n.homeLivePrayerUpdatesBody,
          cta: l10n.homeLivePrayerUpdatesCta,
          mockup: const _PromoPhoneMockup(),
          busy: _enabling,
          onTap: () => unawaited(_enableLiveActivity()),
          onDismiss: () => unawaited(_dismissLive()),
        ),
      if (_widgetsVisible)
        _HomePromoSlide(
          icon: Icons.widgets_rounded,
          title: l10n.homeWidgetsPromoTitle,
          body: l10n.homeWidgetsPromoBody,
          cta: l10n.homeWidgetsPromoCta,
          mockup: const _PromoWidgetsMockup(),
          onTap: () => unawaited(_openWidgetsDemo()),
          onDismiss: () => unawaited(_dismissWidgets()),
        ),
    ];

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        children: [
          SizedBox(
            height: 228.h,
            child: slides.length == 1
                ? slides.first
                : PageView(
                    controller: _pageController,
                    clipBehavior: Clip.none,
                    onPageChanged: (index) => setState(() => _page = index),
                    children: slides,
                  ),
          ),
          if (slides.length > 1) ...[
            SizedBox(height: 8.h),
            _PromoPageDots(count: slides.length, index: _page),
          ],
        ],
      ),
    );
  }
}

class _PromoPageDots extends StatelessWidget {
  const _PromoPageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: 6.w),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == index ? 8.w : 6.w,
            height: i == index ? 8.w : 6.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == index
                  ? colorScheme.primary
                  : colorScheme.primary.withValues(alpha: 0.28),
            ),
          ),
        ],
      ],
    );
  }
}

class _HomePromoSlide extends StatelessWidget {
  const _HomePromoSlide({
    required this.icon,
    required this.title,
    required this.body,
    required this.cta,
    required this.mockup,
    required this.onTap,
    required this.onDismiss,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String cta;
  final Widget mockup;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final bool busy;

  @override
  Widget build(BuildContext context) {
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: busy ? null : onTap,
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
                    color: (isDark
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            icon,
                            size: 16.sp,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            title,
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
                            onPressed: onDismiss,
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
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    body,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
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
                                              cta,
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
                          mockup,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoWidgetsMockup extends StatelessWidget {
  const _PromoWidgetsMockup();

  static const Color _widgetGreen = Color(0xFF3E8268);

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
          Positioned(
            top: 0,
            left: hang,
            width: phoneWidth,
            bottom: 8.h,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A3328),
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
                  Positioned(
                    top: 8.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          '9:41',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            alignment: WrapAlignment.center,
                            children: List.generate(
                              6,
                              (i) => Container(
                                width: 16.w,
                                height: 16.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
              decoration: BoxDecoration(
                color: _widgetGreen,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.widgetDailyVerseTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.appTitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'وَإِيَّاكَ نَسْتَعِينُ',
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      for (final label in [
                        l10n.homePrayerFajr,
                        l10n.homePrayerDhuhr,
                        l10n.homePrayerAsr,
                      ]) ...[
                        Expanded(
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 6.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
