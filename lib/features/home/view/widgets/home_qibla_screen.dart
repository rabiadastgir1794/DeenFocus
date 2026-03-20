import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/qibla_compass_service.dart';
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

class _HomeQiblaScreenState extends State<HomeQiblaScreen> {
  late final Stream<double> _headingStream;

  @override
  void initState() {
    super.initState();
    _headingStream = QiblaCompassService.headingStream();
    final latitude = widget.latitude;
    final longitude = widget.longitude;
    if (latitude != null && longitude != null) {
      QiblaCompassService.setLocation(latitude: latitude, longitude: longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final latitude = widget.latitude;
    final longitude = widget.longitude;

    if (latitude == null || longitude == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.homeQiblaDirection)),
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
        : 'Current location';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeQiblaDirection)),
      body: StreamBuilder<double>(
        stream: _headingStream,
        builder: (context, snapshot) {
          final heading = snapshot.data ?? 0;
          final angleDelta = _normalizedDelta(qiblaDirection, heading);
          final hasLiveHeading = snapshot.hasData;
          final aligned = hasLiveHeading && angleDelta <= 10;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  Text(
                    cityLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Center(
                      child: _QiblaCompass(
                        heading: heading,
                        qiblaDirection: qiblaDirection,
                        aligned: aligned,
                      ),
                    ),
                  ),
                  Text(
                    !hasLiveHeading
                        ? 'Compass unavailable on this device'
                        : aligned
                        ? 'Facing Qibla'
                        : 'Turn to find Qibla',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: aligned
                          ? Theme.of(context).colorScheme.primary
                          : !hasLiveHeading
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Distance to Makkah: ${distanceKm.toStringAsFixed(0)} km',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${qiblaDirection.toStringAsFixed(0)}° from North',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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

class _QiblaCompass extends StatelessWidget {
  const _QiblaCompass({
    required this.heading,
    required this.qiblaDirection,
    required this.aligned,
  });

  final double heading;
  final double qiblaDirection;
  final bool aligned;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const compassSize = 288.0;

    return SizedBox(
      width: compassSize,
      height: compassSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: aligned ? 1 : 0,
            child: Container(
              width: compassSize,
              height: compassSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.18),
                    blurRadius: 28,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          AnimatedRotation(
            turns: -(heading % 360) / 360,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            child: CustomPaint(
              size: const Size(compassSize, compassSize),
              painter: _CompassRingPainter(
                ringColor: colorScheme.outlineVariant,
                tickColor: colorScheme.onSurfaceVariant,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ..._cardinalDirections(context),
                  Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: qiblaDirection * math.pi / 180,
                      child: SizedBox(
                        width: compassSize,
                        height: compassSize,
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 6,
                              child: Text('🕋', style: TextStyle(fontSize: 18)),
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
          Transform.rotate(
            angle: (qiblaDirection - heading) * math.pi / 180,
            child: Icon(
              Icons.navigation_rounded,
              size: 42,
              color: aligned
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _cardinalDirections(BuildContext context) {
    final labels = <_CardinalLabel>[
      const _CardinalLabel('N', Alignment(0, -0.92)),
      const _CardinalLabel('E', Alignment(0.92, 0)),
      const _CardinalLabel('S', Alignment(0, 0.92)),
      const _CardinalLabel('W', Alignment(-0.92, 0)),
    ];

    return labels
        .map(
          (item) => Align(
            alignment: item.alignment,
            child: Text(
              item.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        )
        .toList(growable: false);
  }
}

class _CardinalLabel {
  const _CardinalLabel(this.label, this.alignment);

  final String label;
  final Alignment alignment;
}

class _CompassRingPainter extends CustomPainter {
  const _CompassRingPainter({required this.ringColor, required this.tickColor});

  final Color ringColor;
  final Color tickColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 1, ringPaint);

    for (var index = 0; index < 72; index++) {
      final angle = (index * 5 - 90) * math.pi / 180;
      final outer = Offset(
        center.dx + (radius - 16) * math.cos(angle),
        center.dy + (radius - 16) * math.sin(angle),
      );
      final tickRadius = index % 18 == 0
          ? 2.6
          : index % 6 == 0
          ? 1.8
          : 1.1;
      final tickPaint = Paint()
        ..color = index % 18 == 0
            ? tickColor.withValues(alpha: 0.55)
            : index % 6 == 0
            ? tickColor.withValues(alpha: 0.3)
            : tickColor.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(outer, tickRadius, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CompassRingPainter oldDelegate) {
    return oldDelegate.ringColor != ringColor ||
        oldDelegate.tickColor != tickColor;
  }
}
