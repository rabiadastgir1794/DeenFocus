import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Fixed-size iPhone shell used by onboarding Widget / Live Activity previews.
class OnboardingPhoneShell extends StatelessWidget {
  const OnboardingPhoneShell({
    super.key,
    required this.wallpaper,
    required this.child,
  });

  final Widget wallpaper;
  final Widget child;

  static const Size designSize = Size(122, 228);
  static const double _bezel = 4;
  static const double _innerRadius = 20;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF3A3A3C), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_bezel),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_innerRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: wallpaper),
              child,
              const Positioned(
                top: 7,
                left: 0,
                right: 0,
                child: Center(child: _DynamicIsland()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

/// Home Screen iPhone — wallpaper, real widget, small widgets, app icons.
class OnboardingWidgetsPhonePreview extends StatelessWidget {
  const OnboardingWidgetsPhonePreview({super.key});

  static const _asset = 'assets/onboarding/widgets_preview.png';
  static const _widgetGreen = Color(0xFF3D8268);
  static const _widgetGreenDark = Color(0xFF2F6A54);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.topRight,
      child: SizedBox(
        width: OnboardingPhoneShell.designSize.width,
        height: OnboardingPhoneShell.designSize.height,
        child: OnboardingPhoneShell(
          wallpaper: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEAF5EF),
                  Color(0xFFD8EBE1),
                  Color(0xFFC9E0D4),
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 26, 7, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 52,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      _asset,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  flex: 22,
                  child: Row(
                    children: [
                      Expanded(
                        child: _MiniWidgetTile(
                          icon: Icons.local_fire_department_rounded,
                          label: l10n.onboardingWidgetsMockStreak,
                          value: l10n.onboardingWidgetsMockStreakValue,
                          color: _widgetGreenDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _MiniWidgetTile(
                          icon: Icons.adjust_rounded,
                          label: l10n.onboardingWidgetsMockFocus,
                          value: l10n.onboardingWidgetsMockFocusValue,
                          color: _widgetGreen,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _MiniAppIcon(
                        color: _widgetGreen,
                        child: Image.asset(
                          'assets/app_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  flex: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _MiniAppIcon(color: Color(0xFF5AC8FA), icon: Icons.photo_rounded),
                      _MiniAppIcon(color: Color(0xFFFF9500), icon: Icons.calendar_month_rounded),
                      _MiniAppIcon(color: Color(0xFF34C759), icon: Icons.message_rounded),
                      _MiniAppIcon(color: Color(0xFF007AFF), icon: Icons.mail_rounded),
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

class _MiniWidgetTile extends StatelessWidget {
  const _MiniWidgetTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 4, 4, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 8),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 6.5,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 6,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAppIcon extends StatelessWidget {
  const _MiniAppIcon({
    required this.color,
    this.icon,
    this.child,
  }) : assert(icon != null || child != null);

  final Color color;
  final IconData? icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
          child: child ??
              Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}

/// Lock Screen iPhone — light wallpaper, clock, real Live Activity screenshot.
class OnboardingLiveActivityPhonePreview extends StatelessWidget {
  const OnboardingLiveActivityPhonePreview({super.key});

  static const _asset = 'assets/onboarding/live_activity_preview.png';
  static const _assetAspect = 642 / 274;

  static const _lockDateColor = Color(0xFF5C7268);
  static const _lockTimeColor = Color(0xFF0F3D2E);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: OnboardingPhoneShell.designSize.width,
        height: OnboardingPhoneShell.designSize.height,
        child: OnboardingPhoneShell(
          wallpaper: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF3F8F5),
                  Color(0xFFE4F0EA),
                  Color(0xFFD6E8DF),
                ],
              ),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Column(
                  children: [
                    Text(
                      l10n.onboardingWidgetsLiveLockDate,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _lockDateColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.onboardingWidgetsLiveLockTime,
                      style: const TextStyle(
                        color: _lockTimeColor,
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 6,
                right: 6,
                bottom: 10,
                child: AspectRatio(
                  aspectRatio: _assetAspect,
                  child: Image.asset(
                    _asset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
