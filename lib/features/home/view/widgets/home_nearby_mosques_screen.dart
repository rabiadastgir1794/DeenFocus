import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/services/location/location_service.dart';
import '../../../../core/services/nearby_mosques_service.dart';
import '../../../../core/services/permission_service.dart';

class HomeNearbyMosquesScreen extends StatefulWidget {
  const HomeNearbyMosquesScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialLocationName,
  });

  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialLocationName;

  @override
  State<HomeNearbyMosquesScreen> createState() =>
      _HomeNearbyMosquesScreenState();
}

class _HomeNearbyMosquesScreenState extends State<HomeNearbyMosquesScreen> {
  final NearbyMosquesService _service = NearbyMosquesService();

  bool _isLoading = true;
  String? _errorMessage;
  String? _locationName;
  double? _latitude;
  double? _longitude;
  List<NearbyMosque> _mosques = const <NearbyMosque>[];

  @override
  void initState() {
    super.initState();
    _locationName = widget.initialLocationName;
    _latitude = widget.initialLatitude;
    _longitude = widget.initialLongitude;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (!AppConfig.hasGoogleMapsApiKey) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Nearby Mosques needs a Google Maps API key before maps and mosque results can load.';
      });
      return;
    }

    try {
      await _ensureLocation();
      final latitude = _latitude;
      final longitude = _longitude;
      if (latitude == null || longitude == null) {
        throw const NearbyMosquesException(
          'Location access is required to find nearby mosques.',
        );
      }

      final mosques = await _service.fetchNearby(
        latitude: latitude,
        longitude: longitude,
      );

      if (!mounted) return;
      setState(() {
        _mosques = mosques;
        _isLoading = false;
        _errorMessage = mosques.isEmpty
            ? 'No mosques were found within 5 km of your current location.'
            : null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _ensureLocation() async {
    if (_latitude != null && _longitude != null) return;

    final status = await PermissionService.requestLocationStatus();
    if (status != PermissionStatus.granted) {
      throw const NearbyMosquesException(
        'Location permission is turned off. Enable it in settings to see nearby mosques.',
      );
    }

    final location = await LocationService.fetchCurrentCity();
    if (location == null ||
        location.latitude == null ||
        location.longitude == null) {
      throw const NearbyMosquesException(
        'We could not read your current location right now.',
      );
    }

    _latitude = location.latitude;
    _longitude = location.longitude;
    _locationName = location.title;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Mosques')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _MapCard(
                latitude: _latitude,
                longitude: _longitude,
                mosques: _mosques,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              if ((_locationName?.trim().isNotEmpty ?? false))
                Text(
                  _locationName!.trim(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              if ((_locationName?.trim().isNotEmpty ?? false))
                const SizedBox(height: 8),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                _StatusCard(
                  message: _errorMessage!,
                  actionLabel: _canOpenSettings
                      ? 'Open Settings'
                      : AppConfig.hasGoogleMapsApiKey
                      ? 'Try Again'
                      : null,
                  onAction: _canOpenSettings
                      ? () async {
                          await PermissionService.openLocationSettings();
                        }
                      : AppConfig.hasGoogleMapsApiKey
                      ? _load
                      : null,
                )
              else ...[
                Text(
                  'Within 5 km',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                for (final mosque in _mosques) ...[
                  _MosqueTile(mosque: mosque, onTap: () => _openMap(mosque)),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _canOpenSettings =>
      _errorMessage?.toLowerCase().contains('permission') ?? false;

  Future<void> _openMap(NearbyMosque mosque) async {
    final label = Uri.encodeComponent(mosque.name);
    final coordinates = '${mosque.latitude},${mosque.longitude}';

    if (Platform.isIOS) {
      final googleMapsUri = Uri.parse(
        'comgooglemaps://?q=$label&center=$coordinates',
      );
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        return;
      }

      final appleMapsUri = Uri.parse(
        'https://maps.apple.com/?ll=$coordinates&q=$label',
      );
      await launchUrl(appleMapsUri, mode: LaunchMode.externalApplication);
      return;
    }

    final fallback = mosque.googleMapsUri?.trim().isNotEmpty == true
        ? Uri.parse(mosque.googleMapsUri!)
        : Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$coordinates&query_place_id=${Uri.encodeComponent(mosque.id)}',
          );
    await launchUrl(fallback, mode: LaunchMode.externalApplication);
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({
    required this.latitude,
    required this.longitude,
    required this.mosques,
    required this.isDark,
  });

  final double? latitude;
  final double? longitude;
  final List<NearbyMosque> mosques;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mapUrl = _buildStaticMapUrl();

    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: mapUrl == null
          ? _MapPlaceholder(hasLocation: latitude != null && longitude != null)
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    mapUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const _MapPlaceholder(hasLocation: true);
                    },
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      mosques.isEmpty
                          ? 'Nearby mosques will appear here once results load.'
                          : '${mosques.length} mosques found within 5 km',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String? _buildStaticMapUrl() {
    final latitude = this.latitude;
    final longitude = this.longitude;
    if (latitude == null ||
        longitude == null ||
        !AppConfig.hasGoogleMapsApiKey) {
      return null;
    }

    final buffer = StringBuffer(
      'https://maps.googleapis.com/maps/api/staticmap'
      '?center=$latitude,$longitude'
      '&zoom=14'
      '&size=1200x800'
      '&scale=2'
      '&maptype=roadmap'
      '&markers=color:green%7Clabel:U%7C$latitude,$longitude',
    );

    for (final mosque in mosques.take(8)) {
      buffer.write(
        '&markers=color:red%7Clabel:M%7C${mosque.latitude},${mosque.longitude}',
      );
    }

    buffer.write('&key=${AppConfig.googleMapsApiKey}');
    return buffer.toString();
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.hasLocation});

  final bool hasLocation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 38,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              hasLocation
                  ? 'Map preview unavailable right now.'
                  : 'Waiting for your location.',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final Future<void> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class _MosqueTile extends StatelessWidget {
  const _MosqueTile({required this.mosque, required this.onTap});

  final NearbyMosque mosque;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mosque.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${mosque.address} • ${_distanceLabel(mosque.distanceMeters)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _distanceLabel(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}
