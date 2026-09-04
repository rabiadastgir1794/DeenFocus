import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/prayer_alarm_service.dart';
import '../../../../core/services/prayer_live_activity_service.dart';
import '../../../../core/services/prayer_live_activity_toggle.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tajweed/tajweed_entry_point.dart';
import '../../../tajweed/tajweed_free_preview.dart';
import '../../../onboarding/view/widgets/feature_demo/feature_demo_kind.dart';
import '../settings/settings_app_demo_screen.dart';
import '../settings/settings_prayer_alarms_screen.dart';
import 'lock_screen_options/lock_screen_options_popup.dart';
import 'home_card_open_arrow.dart';

/// Home promo carousel: Full Screen Alarm, Live Activity, Widgets, Tajweed, Lock Screen.
class HomeLiveActivityPromoCard extends StatefulWidget {
  const HomeLiveActivityPromoCard({super.key});

  @override
  State<HomeLiveActivityPromoCard> createState() =>
      _HomeLiveActivityPromoCardState();
}

class _HomeLiveActivityPromoCardState extends State<HomeLiveActivityPromoCard>
    with WidgetsBindingObserver {
  static const Duration _autoSlideInterval = Duration(seconds: 5);

  bool _fullScreenAlarmVisible = false;
  bool _liveVisible = false;
  bool _widgetsVisible = false;
  bool _tajweedVisible = false;
  bool _lockScreenVisible = false;
  bool _loading = true;
  bool _enabling = false;
  int _page = 0;
  late final PageController _pageController;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    PrayerLiveActivityService.instance.preferenceListenable.addListener(
      _onPreferenceChanged,
    );
    StorageService.prayerAlarmsEnabledListenable.addListener(
      _onPreferenceChanged,
    );
    unawaited(_refreshVisibility());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopAutoSlide();
    _pageController.dispose();
    PrayerLiveActivityService.instance.preferenceListenable.removeListener(
      _onPreferenceChanged,
    );
    StorageService.prayerAlarmsEnabledListenable.removeListener(
      _onPreferenceChanged,
    );
    super.dispose();
  }

  void _onPreferenceChanged() {
    unawaited(_refreshVisibility());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshVisibility());
    }
  }

  Future<void> _refreshVisibility() async {
    var supported = false;
    var enabled = false;
    if (PrayerLiveActivityService.visibleOnThisPlatform) {
      final caps = await PrayerLiveActivityService.instance.getCapabilities();
      supported = caps['supportsLiveActivity'] == true;
      enabled = await PrayerLiveActivityService.instance.resolveEnabled();
    }

    var fullScreenAlarmSupported = false;
    var prayerAlarmsEnabled = false;
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      // Match Settings: native prayer alarms = AlarmKit (iOS) or FSI (Android).
      // Do NOT require supportsFullScreen — iOS AlarmKit reports that false
      // because FSI is an Android-only API, which hid this slide on every iPhone.
      final alarmCaps = await PrayerAlarmService.instance.getCapabilities(
        forceRefresh: true,
      );
      fullScreenAlarmSupported = alarmCaps.supportsNativeAlarm;
      if (fullScreenAlarmSupported) {
        prayerAlarmsEnabled = await StorageService.prayerAlarmsEnabled;
      }
    }

    final liveDismissed = await StorageService.homeLiveActivityPromoDismissed;
    final widgetsDismissed = await StorageService.homeWidgetsPromoDismissed;
    final tajweedDismissed = await StorageService.homeTajweedPromoDismissed;
    final lockScreenDismissed =
        await StorageService.homeLockScreenPromoDismissed;
    final fullScreenAlarmDismissed =
        await StorageService.homeFullScreenAlarmPromoDismissed;
    if (!mounted) return;
    setState(() {
      _fullScreenAlarmVisible = fullScreenAlarmSupported &&
          !prayerAlarmsEnabled &&
          !fullScreenAlarmDismissed;
      _liveVisible = PrayerLiveActivityService.visibleOnThisPlatform &&
          supported &&
          !enabled &&
          !liveDismissed;
      _widgetsVisible = !widgetsDismissed;
      _tajweedVisible = !tajweedDismissed;
      _lockScreenVisible = !lockScreenDismissed;
      _loading = false;
      if (_slideCount <= 1) _page = 0;
    });
    _syncAutoSlide(_slideCount);
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  void _syncAutoSlide(int slideCount) {
    _stopAutoSlide();
    if (slideCount <= 1 || !mounted) return;

    _autoSlideTimer = Timer.periodic(_autoSlideInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;

      final current = _pageController.page?.round() ?? _page;
      final next = (current + 1) % slideCount;
      unawaited(
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        ),
      );
    });
  }

  void _onPromoPageChanged(int index, int slideCount) {
    setState(() => _page = index);
    _syncAutoSlide(slideCount);
  }

  int get _slideCount {
    var count = 0;
    if (_fullScreenAlarmVisible) count++;
    if (_liveVisible) count++;
    if (_widgetsVisible) count++;
    if (_tajweedVisible) count++;
    if (_lockScreenVisible) count++;
    return count;
  }

  Future<void> _dismissLive() async {
    await StorageService.setHomeLiveActivityPromoDismissed(true);
    if (!mounted) return;
    setState(() {
      _liveVisible = false;
      _page = 0;
    });
    _resetPageController();
    _syncAutoSlide(_slideCount);
  }

  Future<void> _dismissWidgets() async {
    await StorageService.setHomeWidgetsPromoDismissed(true);
    if (!mounted) return;
    setState(() {
      _widgetsVisible = false;
      _page = 0;
    });
    _resetPageController();
    _syncAutoSlide(_slideCount);
  }

  Future<void> _dismissTajweed() async {
    await StorageService.setHomeTajweedPromoDismissed(true);
    if (!mounted) return;
    setState(() {
      _tajweedVisible = false;
      _page = 0;
    });
    _resetPageController();
    _syncAutoSlide(_slideCount);
  }

  Future<void> _dismissLockScreen() async {
    await StorageService.setHomeLockScreenPromoDismissed(true);
    if (!mounted) return;
    setState(() {
      _lockScreenVisible = false;
      _page = 0;
    });
    _resetPageController();
    _syncAutoSlide(_slideCount);
  }

  Future<void> _dismissFullScreenAlarm() async {
    await StorageService.setHomeFullScreenAlarmPromoDismissed(true);
    if (!mounted) return;
    setState(() {
      _fullScreenAlarmVisible = false;
      _page = 0;
    });
    _resetPageController();
    _syncAutoSlide(_slideCount);
  }

  void _resetPageController() {
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
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

  Future<void> _openLockScreenStyles() async {
    await LockScreenOptionsPopup.show(context);
  }

  Future<void> _openFullScreenAlarmSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SettingsPrayerAlarmsScreen(),
      ),
    );
    if (!mounted) return;
    unawaited(_refreshVisibility());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _slideCount == 0) {
      _stopAutoSlide();
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final slides = <Widget>[
      if (_fullScreenAlarmVisible)
        _HomePromoSlide(
          icon: Icons.notifications_active_rounded,
          title: l10n.homeFullScreenAlarmPromoTitle,
          body: l10n.homeFullScreenAlarmPromoBody,
          cta: l10n.homeFullScreenAlarmPromoCta,
          ctaLeadingIcon: Icons.notifications_active_rounded,
          mockup: _PromoFullScreenAlarmMockup(l10n: l10n),
          onTap: () => unawaited(_openFullScreenAlarmSettings()),
          onDismiss: () => unawaited(_dismissFullScreenAlarm()),
        ),
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
      if (_tajweedVisible)
        _HomePromoSlide(
          icon: Icons.graphic_eq_rounded,
          title: l10n.homeTajweedPromoTitle,
          body: l10n.homeTajweedPromoBody,
          cta: l10n.homeTajweedPromoCta,
          ctaLeadingIcon: Icons.mic_rounded,
          mockup: _PromoTajweedMockup(l10n: l10n),
          onTap: () => unawaited(TajweedEntryPoint.openFreePreview(context)),
          onDismiss: () => unawaited(_dismissTajweed()),
        ),
      if (_lockScreenVisible)
        _HomePromoSlide(
          icon: Icons.phonelink_lock_rounded,
          title: l10n.homeLockScreenPromoTitle,
          body: l10n.homeLockScreenPromoBody,
          cta: l10n.homeLockScreenPromoCta,
          ctaLeadingIcon: Icons.smartphone_rounded,
          mockup: _PromoLockScreenStylesMockup(l10n: l10n),
          onTap: () => unawaited(_openLockScreenStyles()),
          onDismiss: () => unawaited(_dismissLockScreen()),
        ),
    ];

    final carouselHeight =
        ResponsiveLayout.isTablet(context) ? 280.h : 248.h;

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        children: [
          SizedBox(
            height: carouselHeight,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: slides.length == 1
                  ? slides.first
                  : PageView(
                      controller: _pageController,
                      clipBehavior: Clip.none,
                      onPageChanged: (index) =>
                          _onPromoPageChanged(index, slides.length),
                      children: slides,
                    ),
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
    this.ctaLeadingIcon,
  });

  final IconData icon;
  final String title;
  final String body;
  final String cta;
  final Widget mockup;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final bool busy;
  final IconData? ctaLeadingIcon;

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
                            maxLines: 3,
                            softWrap: true,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: 32.w,
                          height: 40.h,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
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
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        body,
                                        maxLines: 4,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: bodyColor,
                                              height: 1.35,
                                            ),
                                      ),
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
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (ctaLeadingIcon != null) ...[
                                              Icon(
                                                ctaLeadingIcon,
                                                size: 16.sp,
                                                color: colorScheme.onPrimary,
                                              ),
                                              SizedBox(width: 6.w),
                                            ],
                                            Text(
                                              cta,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            SizedBox(width: 6.w),
                                            HomeDirectionalForwardIcon(
                                              size: 16.sp,
                                              color: colorScheme.onPrimary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: mockup,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -6.h,
                right: 10.w,
                child: const _PromoNewBadge(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoNewBadge extends StatelessWidget {
  const _PromoNewBadge();

  static const Color _badgeRed = Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background =
        isDark ? Theme.of(context).colorScheme.error : _badgeRed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 11.sp,
            color: Colors.white,
          ),
          SizedBox(width: 4.w),
          Text(
            l10n.homePromoNewBadge,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scales decorative carousel mockups from a fixed design canvas so full-screen
/// ScreenUtil `.w` / `.sp` never blow up mini phone art on iPad.
class _PromoMockupCanvas extends StatelessWidget {
  const _PromoMockupCanvas({
    this.designWidth = 124,
    this.designHeight = 154,
    required this.child,
  });

  final double designWidth;
  final double designHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final displayHeight = ResponsiveLayout.isTablet(context) ? 136.h : 154.h;
    final displayWidth = displayHeight * (designWidth / designHeight);
    return SizedBox(
      width: displayWidth,
      height: displayHeight,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: designWidth,
          height: designHeight,
          child: child,
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
    const phoneWidth = 92.0;
    const hang = (124 - phoneWidth) / 2;

    return _PromoMockupCanvas(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: 0,
            left: hang,
            width: phoneWidth,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A3328),
                borderRadius: BorderRadius.circular(18),
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
                    top: 8,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        const Text(
                          '9:41',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            alignment: WrapAlignment.center,
                            children: List.generate(
                              6,
                              (i) => Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(4),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _widgetGreen,
                borderRadius: BorderRadius.circular(14),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.appTitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'وَإِيَّاكَ نَسْتَعِينُ',
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      for (final label in [
                        l10n.homePrayerFajr,
                        l10n.homePrayerDhuhr,
                        l10n.homePrayerAsr,
                      ])
                        Expanded(
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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

class _PromoTajweedMockup extends StatelessWidget {
  const _PromoTajweedMockup({required this.l10n});

  final AppLocalizations l10n;

  static const Color _practiceBg = Color(0xFFF3EDE3);
  static const Color _practiceBorder = Color(0xFFE0D8CC);
  static const Color _feedbackBg = Color(0xFF0F1F18);
  static const Color _feedbackBorder = Color(0xFF2A4A3A);
  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _accentMint = Color(0xFF7BC4A4);

  @override
  Widget build(BuildContext context) {
    return _PromoMockupCanvas(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 8,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              decoration: BoxDecoration(
                color: _practiceBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _practiceBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _MiniCircleIcon(Icons.tune_rounded),
                      const SizedBox(width: 4),
                      _MiniCircleIcon(Icons.volume_up_rounded),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    TajweedFreePreview.fallbackArabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: Color(0xFF1A3328),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'bsm allh alrhman alrhym',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 5,
                      color: Color(0xFF6B7C74),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.readingSettingsTajweedFreePreviewTranslation,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 4.5,
                      color: Color(0xFF6B7C74),
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: _primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final h in [3.0, 6.0, 4.0, 7.0, 3.0])
                        Container(
                          width: 2,
                          height: h,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: BoxDecoration(
                            color: _accentMint.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.tajweedStartReciting,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF245C48),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            width: 88,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              decoration: BoxDecoration(
                color: _feedbackBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _feedbackBorder.withValues(alpha: 0.7),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryGreen.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '0%',
                          style: TextStyle(
                            color: _accentMint,
                            fontSize: 5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.homeTajweedPromoAiFeedback,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeTajweedPromoWordAccuracy(0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _FeedbackStatRow(
                    color: _primaryGreen,
                    label: l10n.featureDemoTajweedStatCorrect,
                    count: '0',
                  ),
                  const SizedBox(height: 2),
                  _FeedbackStatRow(
                    color: const Color(0xFFF9A825),
                    label: l10n.featureDemoTajweedStatPronunciation,
                    count: '0',
                  ),
                  const SizedBox(height: 2),
                  _FeedbackStatRow(
                    color: const Color(0xFFE53935),
                    label: l10n.featureDemoTajweedStatWrong,
                    count: '1',
                  ),
                  const SizedBox(height: 2),
                  _FeedbackStatRow(
                    color: const Color(0xFF9E9E9E),
                    label: l10n.featureDemoTajweedStatMissed,
                    count: '3',
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: _accentMint.withValues(alpha: 0.55),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.refresh_rounded,
                            size: 6,
                            color: _accentMint,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            l10n.tajweedDownloadTryAgain,
                            style: const TextStyle(
                              color: _accentMint,
                              fontSize: 5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _MiniCircleIcon extends StatelessWidget {
  const _MiniCircleIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: Color(0xFFE8F0EB),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 6,
        color: const Color(0xFF245C48),
      ),
    );
  }
}

class _FeedbackStatRow extends StatelessWidget {
  const _FeedbackStatRow({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 4.5,
              height: 1.1,
            ),
          ),
        ),
        Text(
          count,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 4.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PromoLockScreenStylesMockup extends StatelessWidget {
  const _PromoLockScreenStylesMockup({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    const mockupWidth = 124.0;
    const sideWidth = 34.0;
    const sideHeight = 106.0;
    const centerWidth = 44.0;
    const centerHeight = 130.0;
    const overlap = 9.0;
    const centerLift = 8.0;

    final groupWidth = (2 * sideWidth) + centerWidth - (2 * overlap);
    final inset = (mockupWidth - groupWidth) / 2;
    final leftX = inset;
    final centerX = leftX + sideWidth - overlap;
    final rightX = centerX + centerWidth - overlap;

    return _PromoMockupCanvas(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: leftX,
            bottom: 0,
            child: _MiniLockStylePhone(
              width: sideWidth,
              height: sideHeight,
              label:
                  '${l10n.lockScreenPreviewLabel} · ${l10n.lockScreenStyleHold}',
              laterLabel: l10n.prayerReminderLaterButton,
              child: _HoldPreviewContent(l10n: l10n),
            ),
          ),
          Positioned(
            left: rightX,
            bottom: 0,
            child: _MiniLockStylePhone(
              width: sideWidth,
              height: sideHeight,
              label:
                  '${l10n.lockScreenPreviewLabel} · ${l10n.lockScreenStyleTasbih}',
              laterLabel: l10n.prayerReminderLaterButton,
              child: _TasbihPreviewContent(l10n: l10n),
            ),
          ),
          Positioned(
            left: centerX,
            bottom: centerLift,
            child: _MiniLockStylePhone(
              width: centerWidth,
              height: centerHeight,
              label:
                  '${l10n.lockScreenPreviewLabel} · ${l10n.lockScreenStyleType}',
              laterLabel: l10n.prayerReminderLaterButton,
              elevated: true,
              child: _TypePreviewContent(l10n: l10n),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniLockStylePhone extends StatelessWidget {
  const _MiniLockStylePhone({
    required this.width,
    required this.height,
    required this.label,
    required this.laterLabel,
    required this.child,
    this.elevated = false,
  });

  final double width;
  final double height;
  final String label;
  final String laterLabel;
  final Widget child;
  final bool elevated;

  static const double _designWidth = 132;
  static const double _designHeight = 286;

  static const Color _phoneBorder = Color(0xFF2A4A3A);
  static const Color _phoneBg = Color(0xFFFAFAF7);
  static const Color _primaryGreen = Color(0xFF1F4D3A);
  static const Color _accentGreen = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: elevated
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: _designWidth,
            height: _designHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _phoneBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _phoneBorder, width: 1.6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0EB),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          label,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            color: _primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                        child: child,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: _accentGreen.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Text(
                          laterLabel,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: _accentGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HoldPreviewContent extends StatelessWidget {
  const _HoldPreviewContent({required this.l10n});

  final AppLocalizations l10n;

  static const Color _primaryGreen = Color(0xFF1F4D3A);
  static const Color _accentGreen = Color(0xFF2E7D32);
  static const Color _muted = Color(0xFF6B7C74);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          l10n.lockScreenItsTimeToPray,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: _muted, height: 1.2),
        ),
        Text(
          l10n.homePrayerDhuhr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _primaryGreen,
          ),
        ),
        const Spacer(),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentGreen.withValues(alpha: 0.08),
              border: Border.all(
                color: _accentGreen.withValues(alpha: 0.5),
                width: 2.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'الظهر',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _primaryGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    l10n.lockScreenHoldHint,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8.5,
                      color: _muted,
                      height: 1.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _TypePreviewContent extends StatelessWidget {
  const _TypePreviewContent({required this.l10n});

  final AppLocalizations l10n;

  static const Color _primaryGreen = Color(0xFF1F4D3A);
  static const Color _muted = Color(0xFF6B7C74);
  static const Color _phoneBorder = Color(0xFF2A4A3A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.lockScreenConfirmBeforeAllah,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 9.5, color: _muted, height: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.lockScreenTypeHint(l10n.lockScreenTypeWord),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 9,
            color: _primaryGreen,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _phoneBorder.withValues(alpha: 0.35)),
          ),
          child: Text(
            l10n.lockScreenTypeWord,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: _primaryGreen,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _TasbihPreviewContent extends StatelessWidget {
  const _TasbihPreviewContent({required this.l10n});

  final AppLocalizations l10n;

  static const Color _primaryGreen = Color(0xFF1F4D3A);
  static const Color _accentGreen = Color(0xFF2E7D32);
  static const Color _muted = Color(0xFF6B7C74);

  @override
  Widget build(BuildContext context) {
    final phrases = [
      l10n.lockScreenDhikrAstaghfirullah,
      l10n.lockScreenDhikrSubhanAllah,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.lockScreenItsTimeToPray,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 9, color: _muted, height: 1.15),
        ),
        Text(
          l10n.homePrayerDhuhr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'سُبْحَانَ اللّٰهِ',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _primaryGreen,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < phrases.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == 0 ? _accentGreen : _muted.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  phrases[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 7.5,
                    fontWeight: i == 0 ? FontWeight.w700 : FontWeight.w500,
                    color: i == 0 ? _primaryGreen : _muted,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.lockScreenCountProgress(0, 3),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: _primaryGreen,
          ),
        ),
        Text(
          l10n.lockScreenTapToCount,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 8, color: _muted, height: 1.1),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: _accentGreen,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            l10n.prayerReminderYesButton,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
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
    const phoneWidth = 92.0;
    const hang = (124 - phoneWidth) / 2;

    return _PromoMockupCanvas(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: 0,
            left: hang,
            width: phoneWidth,
            bottom: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A14),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2A3D34), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: CustomPaint(painter: _GreenLockWallpaperPainter()),
                    ),
                    Positioned(
                      top: 5,
                      left: 4,
                      right: 4,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2.5,
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
                                  size: 7,
                                  color: _accentMint,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  l10n.homePrayerAsr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 6,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  '3:42 PM',
                                  style: TextStyle(
                                    color: Color(0xE6FFFFFF),
                                    fontSize: 6,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 26,
                      left: 6,
                      right: 6,
                      child: Column(
                        children: [
                          const Text(
                            '18:07',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.featureDemoLiveActivityLockHint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                    Text(l10n.homePromoPreviewCity, style: secondary),
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

class _PromoFullScreenAlarmMockup extends StatelessWidget {
  const _PromoFullScreenAlarmMockup({required this.l10n});

  final AppLocalizations l10n;

  static const Color _accentGreen = Color(0xFF2E7D32);
  static const Color _phoneBorder = Color(0xFF2A3D34);

  @override
  Widget build(BuildContext context) {
    return _PromoMockupCanvas(
      designWidth: 92,
      designHeight: 146,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _phoneBorder, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
            child: Column(
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 10,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 7,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          l10n.prayerAlarmTitle(l10n.homePrayerMaghrib),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '18:40',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.appTitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 7,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                  decoration: BoxDecoration(
                    color: _accentGreen,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.prayerAlarmIvePrayed,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 16,
                  padding: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        margin: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.homeFullScreenAlarmPromoSlideToStop,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 6,
                              fontWeight: FontWeight.w500,
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
      ),
    );
  }
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
