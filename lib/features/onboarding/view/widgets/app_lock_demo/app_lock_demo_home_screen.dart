import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../l10n/app_localizations.dart';

/// Full-screen simulated device home screen (iOS or Android style).
/// Only the Instagram icon is interactive.
class AppLockDemoHomeScreen extends StatefulWidget {
  const AppLockDemoHomeScreen({
    super.key,
    required this.onInstagramTap,
    required this.tryOpeningLabel,
  });

  final VoidCallback onInstagramTap;
  final String tryOpeningLabel;

  @override
  State<AppLockDemoHomeScreen> createState() => _AppLockDemoHomeScreenState();
}

class _AppLockDemoHomeScreenState extends State<AppLockDemoHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _targetKey = GlobalKey();
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTarget());
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  bool get _isIosStyle {
    final p = Theme.of(context).platform;
    return p == TargetPlatform.iOS || p == TargetPlatform.macOS;
  }

  void _measureTarget() {
    final targetCtx = _targetKey.currentContext;
    final stackCtx = _stackKey.currentContext;
    if (targetCtx == null || stackCtx == null || !mounted) return;
    final targetBox = targetCtx.findRenderObject() as RenderBox?;
    final stackBox = stackCtx.findRenderObject() as RenderBox?;
    if (targetBox == null ||
        stackBox == null ||
        !targetBox.hasSize ||
        !stackBox.hasSize) {
      return;
    }
    final topLeft = targetBox.localToGlobal(Offset.zero, ancestor: stackBox);
    final next = topLeft & targetBox.size;
    if (_targetRect == next) return;
    setState(() => _targetRect = next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final isIos = _isIosStyle;
    final apps = isIos ? _iosApps(l10n) : _androidApps(l10n);
    final tryOpeningLabel = widget.tryOpeningLabel;

    // Edge-to-edge system UI while this screen is visible.
    final overlay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _measureTarget());

          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final topPad = media.padding.top;
          final bottomPad = math.max(media.padding.bottom, 8.0);

          // Responsive metrics — fill the device like a real launcher.
          final cols = 4;
          final rows = h < 700 ? 4 : (h < 840 ? 5 : 6);
          final hPad = w * (isIos ? 0.07 : 0.06);
          final dockHeight = isIos ? h * 0.105 : h * 0.11;
          final statusBlock = topPad + (isIos ? 8 : 10);
          final pageDots = isIos ? 18.0 : 0.0;
          final gridTop = statusBlock + (isIos ? 10 : 52);
          final gridBottom = bottomPad + dockHeight + pageDots + 16;
          final gridH = math.max(120.0, h - gridTop - gridBottom);
          final gridW = w - hPad * 2;
          final cellW = gridW / cols;
          final visibleCount = math.min(apps.length, cols * rows);
          final visibleRows =
              math.max(1, (visibleCount / cols).ceil()).clamp(1, rows);
          final cellH = gridH / visibleRows;
          final iconSize = math.min(cellW, cellH) * (isIos ? 0.62 : 0.58);
          final iconRadius = isIos ? iconSize * 0.223 : iconSize * 0.22;
          final labelSize = (iconSize * 0.18).clamp(9.0, 12.0);

          return Stack(
            key: _stackKey,
            fit: StackFit.expand,
            children: [
              _Wallpaper(isIos: isIos, colorScheme: colorScheme),
              // Status / time
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _StatusChrome(
                  isIos: isIos,
                  topPad: topPad,
                  onSurface: colorScheme.onSurface,
                ),
              ),
              if (!isIos)
                Positioned(
                  top: topPad + 8,
                  left: hPad,
                  right: hPad,
                  child: _AndroidSearchBar(
                    height: 40,
                    hint: MaterialLocalizations.of(context).searchFieldLabel,
                  ),
                ),
              // App grid
              Positioned(
                top: gridTop,
                left: hPad,
                right: hPad,
                height: gridH,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: visibleCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisExtent: cellH,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    if (app.isTarget) {
                      if (_targetRect == null) {
                        return _AppIconTile(
                          key: _targetKey,
                          label: app.label,
                          color: app.color,
                          icon: app.icon,
                          iconSize: iconSize,
                          iconRadius: iconRadius,
                          labelSize: labelSize,
                          gradient: app.gradient,
                          onTap: widget.onInstagramTap,
                        );
                      }
                      return SizedBox(
                        key: _targetKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: iconSize, height: iconSize),
                            SizedBox(height: 5),
                            SizedBox(height: labelSize * 1.25),
                          ],
                        ),
                      );
                    }
                    return _AppIconTile(
                      label: app.label,
                      color: app.color,
                      icon: app.icon,
                      iconSize: iconSize,
                      iconRadius: iconRadius,
                      labelSize: labelSize,
                      gradient: app.gradient,
                      labelColor:
                          isIos ? const Color(0xFF1C1C1E) : Colors.white,
                    );
                  },
                ),
              ),
              // Page dots (iOS)
              if (isIos)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomPad + dockHeight + 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final active = i == 1;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 7 : 6,
                        height: active ? 7 : 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(
                            alpha: active ? 0.95 : 0.35,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              // Dock
              Positioned(
                left: isIos ? w * 0.035 : hPad * 0.4,
                right: isIos ? w * 0.035 : hPad * 0.4,
                bottom: bottomPad,
                height: dockHeight,
                child: _Dock(
                  isIos: isIos,
                  iconSize: iconSize * (isIos ? 0.95 : 0.9),
                  iconRadius: iconRadius,
                  apps: isIos ? _iosDock : _androidDock,
                ),
              ),
              // Dim + spotlight
              if (_targetRect != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _SpotlightPainter(
                        hole: _inflateForIcon(
                          _targetRect!,
                          iconSize: iconSize,
                          labelSize: labelSize,
                        ),
                        dimColor: Colors.black.withValues(alpha: 0.55),
                        cornerRadius: iconRadius + 6,
                      ),
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              // Guide arrow
              if (_targetRect != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _GuideArrowPainter(
                        targetCenter: Offset(
                          _targetRect!.center.dx,
                          _targetRect!.top + iconSize / 2,
                        ),
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              // Instruction
              Positioned(
                left: w * 0.08,
                right: w * 0.08,
                top: (_targetRect?.top ?? h * 0.42) - 88,
                child: IgnorePointer(
                  child: Text(
                    tryOpeningLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (w * 0.058).clamp(20.0, 26.0),
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: -0.3,
                      shadows: const [
                        Shadow(blurRadius: 16, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ),
              // Elevated Instagram
              if (_targetRect != null)
                Positioned(
                  left: _targetRect!.left,
                  top: _targetRect!.top,
                  width: _targetRect!.width,
                  height: _targetRect!.height,
                  child: _AppIconTile(
                    label: l10n.appLockDemoAppInstagram,
                    color: const Color(0xFFE1306C),
                    icon: Icons.camera_alt_rounded,
                    iconSize: iconSize,
                    iconRadius: iconRadius,
                    labelSize: labelSize,
                    gradient: _instagramGradient,
                    elevated: true,
                    pulse: _pulse,
                    labelColor: Colors.white,
                    onTap: widget.onInstagramTap,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Spotlight should hug the icon squircle, not the whole grid cell.
  Rect _inflateForIcon(
    Rect cell, {
    required double iconSize,
    required double labelSize,
  }) {
    final iconLeft = cell.left + (cell.width - iconSize) / 2;
    final iconTop = cell.top;
    return Rect.fromLTWH(
      iconLeft - 5,
      iconTop - 5,
      iconSize + 10,
      iconSize + 10,
    );
  }
}

class _Wallpaper extends StatelessWidget {
  const _Wallpaper({required this.isIos, required this.colorScheme});

  final bool isIos;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    if (isIos) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7EB6D9),
              Color(0xFFB8D4E8),
              Color(0xFFE8D5C4),
              Color(0xFFD4C4B0),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.35),
            const Color(0xFF1A2332),
            const Color(0xFF0F1419),
          ],
        ),
      ),
    );
  }
}

class _StatusChrome extends StatelessWidget {
  const _StatusChrome({
    required this.isIos,
    required this.topPad,
    required this.onSurface,
  });

  final bool isIos;
  final double topPad;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    final color = isIos ? const Color(0xFF1C1C1E) : Colors.white;
    return Padding(
      padding: EdgeInsets.only(top: topPad > 0 ? topPad * 0.15 : 8),
      child: SizedBox(
        height: topPad > 20 ? topPad * 0.85 : 28,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Text(
                '9:41',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: isIos ? -0.2 : 0.2,
                ),
              ),
              const Spacer(),
              Icon(Icons.signal_cellular_alt_rounded, size: 15, color: color),
              const SizedBox(width: 5),
              Icon(
                isIos ? Icons.wifi_rounded : Icons.wifi_rounded,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 5),
              Icon(Icons.battery_full_rounded, size: 17, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _AndroidSearchBar extends StatelessWidget {
  const _AndroidSearchBar({required this.height, required this.hint});

  final double height;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(Icons.search_rounded,
                  color: Colors.white.withValues(alpha: 0.85), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.mic_none_rounded,
                  color: Colors.white.withValues(alpha: 0.85), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dock extends StatelessWidget {
  const _Dock({
    required this.isIos,
    required this.iconSize,
    required this.iconRadius,
    required this.apps,
  });

  final bool isIos;
  final double iconSize;
  final double iconRadius;
  final List<_DockApp> apps;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final app in apps)
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: app.color,
              borderRadius: BorderRadius.circular(iconRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(app.icon, color: Colors.white, size: iconSize * 0.48),
          ),
      ],
    );

    if (isIos) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: child,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: child,
    );
  }
}

class _AppIconTile extends StatelessWidget {
  const _AppIconTile({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.iconSize,
    required this.iconRadius,
    required this.labelSize,
    this.gradient,
    this.onTap,
    this.elevated = false,
    this.pulse,
    this.labelColor,
  });

  final String label;
  final Color color;
  final IconData icon;
  final double iconSize;
  final double iconRadius;
  final double labelSize;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool elevated;
  final Animation<double>? pulse;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    Widget iconBox(double glow) {
      return Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(iconRadius),
          boxShadow: elevated
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.65 + glow * 0.25),
                    blurRadius: 22 + glow * 12,
                    spreadRadius: 2 + glow * 3,
                  ),
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.35 + glow * 0.35),
                    blurRadius: 16,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Icon(icon, color: Colors.white, size: iconSize * 0.48),
      );
    }

    final column = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (pulse != null)
          AnimatedBuilder(
            animation: pulse!,
            builder: (_, _) => iconBox(pulse!.value),
          )
        else
          iconBox(0),
        const SizedBox(height: 5),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: labelSize,
            fontWeight: elevated ? FontWeight.w700 : FontWeight.w500,
            color: labelColor ?? const Color(0xFF1C1C1E),
            shadows: labelColor == Colors.white
                ? const [Shadow(blurRadius: 8, color: Colors.black54)]
                : const [
                    Shadow(blurRadius: 4, color: Color(0x33000000)),
                  ],
          ),
        ),
      ],
    );

    if (onTap == null) return column;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: column,
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.hole,
    required this.dimColor,
    required this.cornerRadius,
  });

  final Rect hole;
  final Color dimColor;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndRadius(hole, Radius.circular(cornerRadius)),
      )
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, Paint()..color = dimColor);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.hole != hole ||
      oldDelegate.dimColor != dimColor ||
      oldDelegate.cornerRadius != cornerRadius;
}

class _GuideArrowPainter extends CustomPainter {
  _GuideArrowPainter({required this.targetCenter, required this.color});

  final Offset targetCenter;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(size.width * 0.5, targetCenter.dy - 72);
    final end = Offset(targetCenter.dx, targetCenter.dy - iconClearance);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final control = Offset(
      (start.dx + end.dx) / 2 + 36,
      start.dy + 10,
    );

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);

    final angle = math.atan2(end.dy - control.dy, end.dx - control.dx);
    const head = 11.0;
    final headPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - head * math.cos(angle - 0.5),
        end.dy - head * math.sin(angle - 0.5),
      )
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - head * math.cos(angle + 0.5),
        end.dy - head * math.sin(angle + 0.5),
      );
    canvas.drawPath(headPath, paint);
  }

  static const iconClearance = 34.0;

  @override
  bool shouldRepaint(covariant _GuideArrowPainter oldDelegate) =>
      oldDelegate.targetCenter != targetCenter || oldDelegate.color != color;
}

class _DemoApp {
  const _DemoApp({
    required this.label,
    required this.color,
    required this.icon,
    this.isTarget = false,
    this.gradient,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isTarget;
  final Gradient? gradient;
}

class _DockApp {
  const _DockApp(this.color, this.icon);
  final Color color;
  final IconData icon;
}

const _instagramGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
);

List<_DemoApp> _iosApps(AppLocalizations l10n) => [
      _DemoApp(
        label: l10n.appLockDemoAppFaceTime,
        color: const Color(0xFF34C759),
        icon: Icons.videocam_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppCalendar,
        color: const Color(0xFFFF3B30),
        icon: Icons.calendar_month_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppPhotos,
        color: const Color(0xFFFF2D55),
        icon: Icons.photo_library_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppCamera,
        color: const Color(0xFF8E8E93),
        icon: Icons.photo_camera_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMail,
        color: const Color(0xFF007AFF),
        icon: Icons.mail_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppNotes,
        color: const Color(0xFFFFCC00),
        icon: Icons.sticky_note_2_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppReminders,
        color: const Color(0xFF5AC8FA),
        icon: Icons.checklist_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppClock,
        color: const Color(0xFF1C1C1E),
        icon: Icons.access_time_filled_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMaps,
        color: const Color(0xFF64D2FF),
        icon: Icons.map_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppWeather,
        color: const Color(0xFF5AC8FA),
        icon: Icons.wb_sunny_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppAppStore,
        color: const Color(0xFF007AFF),
        icon: Icons.shop_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppBooks,
        color: const Color(0xFFFF9500),
        icon: Icons.menu_book_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppHealth,
        color: const Color(0xFFFF2D55),
        icon: Icons.favorite_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppWallet,
        color: const Color(0xFF1C1C1E),
        icon: Icons.account_balance_wallet_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppSettings,
        color: const Color(0xFF8E8E93),
        icon: Icons.settings_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMusic,
        color: const Color(0xFFFF2D55),
        icon: Icons.music_note_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMessages,
        color: const Color(0xFF34C759),
        icon: Icons.chat_bubble_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppSafari,
        color: const Color(0xFF007AFF),
        icon: Icons.language_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppPhone,
        color: const Color(0xFF34C759),
        icon: Icons.phone_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppInstagram,
        color: const Color(0xFFE1306C),
        icon: Icons.camera_alt_rounded,
        isTarget: true,
        gradient: _instagramGradient,
      ),
    ];

List<_DemoApp> _androidApps(AppLocalizations l10n) => [
      _DemoApp(
        label: l10n.appLockDemoAppPhone,
        color: const Color(0xFF34A853),
        icon: Icons.phone_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMessages,
        color: const Color(0xFF1A73E8),
        icon: Icons.chat_bubble_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppChrome,
        color: const Color(0xFFFBBC04),
        icon: Icons.language_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppCamera,
        color: const Color(0xFF5F6368),
        icon: Icons.photo_camera_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppPhotos,
        color: const Color(0xFFEA4335),
        icon: Icons.photo_library_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMaps,
        color: const Color(0xFF34A853),
        icon: Icons.map_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppClock,
        color: const Color(0xFF1A73E8),
        icon: Icons.access_time_filled_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppCalendar,
        color: const Color(0xFFEA4335),
        icon: Icons.calendar_month_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMail,
        color: const Color(0xFFEA4335),
        icon: Icons.mail_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppWeather,
        color: const Color(0xFF1A73E8),
        icon: Icons.wb_sunny_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppNotes,
        color: const Color(0xFFFBBC04),
        icon: Icons.sticky_note_2_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppSettings,
        color: const Color(0xFF5F6368),
        icon: Icons.settings_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppMusic,
        color: const Color(0xFFEA4335),
        icon: Icons.music_note_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppHealth,
        color: const Color(0xFF34A853),
        icon: Icons.favorite_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppWallet,
        color: const Color(0xFF1A73E8),
        icon: Icons.account_balance_wallet_rounded,
      ),
      _DemoApp(
        label: l10n.appLockDemoAppInstagram,
        color: const Color(0xFFE1306C),
        icon: Icons.camera_alt_rounded,
        isTarget: true,
        gradient: _instagramGradient,
      ),
    ];

const _iosDock = <_DockApp>[
  _DockApp(Color(0xFF34C759), Icons.phone_rounded),
  _DockApp(Color(0xFF007AFF), Icons.language_rounded),
  _DockApp(Color(0xFF34C759), Icons.message_rounded),
  _DockApp(Color(0xFFFF2D55), Icons.music_note_rounded),
];

const _androidDock = <_DockApp>[
  _DockApp(Color(0xFF34A853), Icons.phone_rounded),
  _DockApp(Color(0xFF1A73E8), Icons.message_rounded),
  _DockApp(Color(0xFFFBBC04), Icons.language_rounded),
  _DockApp(Color(0xFFEA4335), Icons.camera_alt_rounded),
];
