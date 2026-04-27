import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/qibla_compass_service.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';

class HomeQiblaScreen extends StatefulWidget {
  const HomeQiblaScreen({
    super.key,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  final String? locationName;
  final double? latitude;
  final double? longitude;

  @override
  State<HomeQiblaScreen> createState() => _HomeQiblaScreenState();
}

class _HomeQiblaScreenState extends State<HomeQiblaScreen>
    with SingleTickerProviderStateMixin {
  late final Stream<double> _headingStream;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _headingStream = QiblaCompassService.headingStream();
    final latitude = widget.latitude;
    final longitude = widget.longitude;
    if (latitude != null && longitude != null) {
      QiblaCompassService.setLocation(latitude: latitude, longitude: longitude);
    }
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final latitude = widget.latitude;
    final longitude = widget.longitude;

    if (latitude == null || longitude == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: l10n.homeQiblaDirection,
          onBack: () => Navigator.of(context).pop(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.homeLocationMissingForQibla,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final coordinates = Coordinates(latitude, longitude);
    final qiblaDirection = Qibla(coordinates).direction;
    final distanceKm =
        Geolocator.distanceBetween(
          latitude,
          longitude,
          Qibla.MAKKAH.latitude,
          Qibla.MAKKAH.longitude,
        ) /
        1000;
    final cityLabel = (widget.locationName?.trim().isNotEmpty ?? false)
        ? widget.locationName!.trim()
        : l10n.settingsLocationLabel;

    final distanceFormatted = NumberFormat.decimalPattern(
      'en_US',
    ).format(distanceKm.round());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: l10n.homeQiblaDirection,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: StreamBuilder<double>(
        stream: _headingStream,
        builder: (context, snapshot) {
          final heading = snapshot.data ?? 0;
          final hasLiveHeading = snapshot.hasData;
          final angleDelta = _normalizedDelta(qiblaDirection, heading);
          final aligned = hasLiveHeading && angleDelta <= 10;

          return Stack(
            children: [
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cityLabel,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 32,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Center(
                            child: _QiblaCompassView(
                              heading: heading,
                              qiblaDirection: qiblaDirection,
                              aligned: aligned,
                              distanceFormatted: distanceFormatted,
                              hasLiveHeading: hasLiveHeading,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _normalizedDelta(double target, double heading) {
    final delta = (target - heading).abs() % 360;
    return delta > 180 ? 360 - delta : delta;
  }
}

class _QiblaCompassView extends StatefulWidget {
  const _QiblaCompassView({
    required this.heading,
    required this.qiblaDirection,
    required this.aligned,
    required this.distanceFormatted,
    required this.hasLiveHeading,
  });

  final double heading;
  final double qiblaDirection;
  final bool aligned;
  final String distanceFormatted;
  final bool hasLiveHeading;

  @override
  State<_QiblaCompassView> createState() => _QiblaCompassViewState();
}

class _QiblaCompassViewState extends State<_QiblaCompassView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _syncBreathing();
  }

  @override
  void didUpdateWidget(covariant _QiblaCompassView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.aligned != widget.aligned) {
      _syncBreathing();
    }
  }

  void _syncBreathing() {
    if (widget.aligned) {
      _breathingController.repeat(reverse: true);
    } else {
      _breathingController
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const compassSize = 288.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: compassSize,
          height: compassSize,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (widget.aligned)
                AnimatedBuilder(
                  animation: _breathingController,
                  builder: (context, child) {
                    final pulse =
                        0.12 +
                        0.06 * math.sin(_breathingController.value * math.pi);
                    return Container(
                      width: compassSize,
                      height: compassSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: pulse),
                      ),
                    );
                  },
                ),
              AnimatedRotation(
                turns: -(widget.heading % 360) / 360,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
                child: Container(
                  width: compassSize,
                  height: compassSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      CustomPaint(
                        size: const Size(compassSize, compassSize),
                        painter: _CompassTicksPainter(
                          foreground: colorScheme.onSurface,
                        ),
                      ),
                      _CardinalLabel(
                        label: l10n.qiblaNorthShort,
                        alignment: Alignment.topCenter,
                        offset: const EdgeInsets.only(top: 8),
                        heading: widget.heading,
                      ),
                      _CardinalLabel(
                        label: l10n.qiblaSouthShort,
                        alignment: Alignment.bottomCenter,
                        offset: const EdgeInsets.only(bottom: 8),
                        heading: widget.heading,
                      ),
                      _CardinalLabel(
                        label: l10n.qiblaEastShort,
                        alignment: Alignment.centerRight,
                        offset: const EdgeInsets.only(right: 8),
                        heading: widget.heading,
                      ),
                      _CardinalLabel(
                        label: l10n.qiblaWestShort,
                        alignment: Alignment.centerLeft,
                        offset: const EdgeInsets.only(left: 8),
                        heading: widget.heading,
                      ),
                      Transform.rotate(
                        angle: widget.qiblaDirection * math.pi / 180,
                        child: SizedBox(
                          width: compassSize,
                          height: compassSize,
                          child: const Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text('🕋', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Transform.rotate(
                    angle:
                        (widget.qiblaDirection - widget.heading) *
                        math.pi /
                        180,
                    child: Icon(
                      Icons.navigation_rounded,
                      size: 28,
                      color: widget.aligned
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w600,
            color: !widget.hasLiveHeading
                ? colorScheme.error
                : widget.aligned
                ? colorScheme.primary
                : colorScheme.onSurface,
          ),
          child: Text(
            !widget.hasLiveHeading
                ? l10n.qiblaCompassUnavailable
                : widget.aligned
                ? l10n.qiblaFacing
                : l10n.qiblaTurnToFind,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.qiblaDistanceToMakkah}: ${widget.distanceFormatted} km',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.qiblaDirection.toStringAsFixed(0)}° ${l10n.qiblaFromNorth}',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CardinalLabel extends StatelessWidget {
  const _CardinalLabel({
    required this.label,
    required this.alignment,
    required this.offset,
    required this.heading,
  });

  final String label;
  final Alignment alignment;
  final EdgeInsets offset;
  final double heading;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: offset,
        child: Transform.rotate(
          angle: heading * math.pi / 180,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _CompassTicksPainter extends CustomPainter {
  const _CompassTicksPainter({required this.foreground});

  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    for (var i = 0; i < 72; i++) {
      final angleDeg = i * 5.0;
      final angleRad = angleDeg * math.pi / 180;
      final h = i % 18 == 0 ? 12.0 : (i % 6 == 0 ? 8.0 : 4.0);
      final innerR = radius - h;
      final outerR = radius;

      final inner = Offset(
        center.dx + math.sin(angleRad) * innerR,
        center.dy - math.cos(angleRad) * innerR,
      );
      final outer = Offset(
        center.dx + math.sin(angleRad) * outerR,
        center.dy - math.cos(angleRad) * outerR,
      );

      final opacity = i % 18 == 0
          ? 0.4
          : i % 6 == 0
          ? 0.2
          : 0.1;
      final paint = Paint()
        ..color = foreground.withValues(alpha: opacity)
        ..strokeWidth = 1
        ..strokeCap = StrokeCap.square;
      canvas.drawLine(inner, outer, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CompassTicksPainter oldDelegate) {
    return oldDelegate.foreground != foreground;
  }
}
