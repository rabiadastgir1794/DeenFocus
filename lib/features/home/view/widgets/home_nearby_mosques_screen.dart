import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' show ClientException;
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/services/location/location_service.dart';
import '../../../../core/services/nearby_mosques_cache.dart';
import '../../../../core/services/nearby_mosques_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/widgets/widgets.dart';

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
  static const double _searchRadiusMeters = 5000;
  static const String _emptyMosquesHint =
      'Nothing listed within 5 km on OpenStreetMap for this spot. Try again later or move the map.';

  bool _isLoading = true;
  /// Set only for real failures (network, permission, location). Empty results use [_mosques.isEmpty] instead.
  String? _errorMessage;
  bool _errorSuggestOpenSettings = false;
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

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _errorSuggestOpenSettings = false;
    });

    try {
      await _ensureLocation();
      if (!mounted) return;
      setState(() {});

      final latitude = _latitude;
      final longitude = _longitude;
      if (latitude == null || longitude == null) {
        throw const NearbyMosquesException(
          'Location access is required to find nearby mosques.',
        );
      }

      if (!forceRefresh) {
        final cached = await NearbyMosquesCache.readValid(
          latitude: latitude,
          longitude: longitude,
        );
        if (cached != null) {
          if (!mounted) return;
          setState(() {
            _mosques = cached.mosques;
            _isLoading = false;
            _errorMessage = null;
          });
          return;
        }
      }

      final mosques = await _service.fetchNearby(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: _searchRadiusMeters,
      );

      await NearbyMosquesCache.save(
        latitude: latitude,
        longitude: longitude,
        mosques: mosques,
      );

      if (!mounted) return;
      setState(() {
        _mosques = mosques;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Nearby mosques load failed: $error');
        debugPrint('$stackTrace');
      }
      if (!mounted) return;

      ({
        double lat,
        double lng,
        DateTime fetched,
        List<NearbyMosque> mosques,
      })? fallback;
      try {
        fallback = await NearbyMosquesCache.readLatest();
      } catch (_) {
        fallback = null;
      }

      setState(() {
        _isLoading = false;
        if (fallback != null && fallback.mosques.isNotEmpty) {
          _mosques = fallback.mosques;
          _errorMessage =
              'Live update failed. Showing last saved results. Pull to refresh.';
          _errorSuggestOpenSettings = false;
        } else {
          _errorMessage = _nearbyMosquesFriendlyError(error);
          _errorSuggestOpenSettings =
              _nearbyMosquesErrorSuggestsOpenSettings(error);
        }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nearby Mosques',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => _load(forceRefresh: true),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _NearbyMosquesMapCard(
                latitude: _latitude,
                longitude: _longitude,
                mosques: _mosques,
                isDark: isDark,
                awaitingMosqueResults: _isLoading,
                onMosqueTap: _openMap,
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
                  actionLabel:
                      _errorSuggestOpenSettings ? 'Open Settings' : 'Try Again',
                  onAction: _errorSuggestOpenSettings
                      ? () async {
                          await PermissionService.openLocationSettings();
                        }
                      : () => _load(forceRefresh: true),
                )
              else if (_mosques.isEmpty)
                _NoMosquesFoundCard(
                  hint: _emptyMosquesHint,
                  onRetry: () => _load(forceRefresh: true),
                )
              else ...[
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

  Future<void> _openMap(NearbyMosque mosque) async {
    final lat = mosque.latitude;
    final lng = mosque.longitude;
    final name = mosque.name;
    final googleWebUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('$lat,$lng')}',
    );
    final appleWebUri = Uri.parse(
      'https://maps.apple.com/?ll=$lat,$lng&q=${Uri.encodeComponent(name)}',
    );
    final googleAppUri = Uri.parse(
      'comgooglemaps://?q=${Uri.encodeComponent('$lat,$lng')}',
    );
    final appleAppUri = Uri.parse(
      'maps://?ll=$lat,$lng&q=${Uri.encodeComponent(name)}',
    );

    final hasGoogle = await canLaunchUrl(googleAppUri);
    final hasApple = await canLaunchUrl(appleAppUri);

    if (hasGoogle && !hasApple) {
      await launchUrl(googleAppUri, mode: LaunchMode.externalApplication);
      return;
    }
    if (hasApple && !hasGoogle) {
      await launchUrl(appleAppUri, mode: LaunchMode.externalApplication);
      return;
    }
    if (!hasGoogle && !hasApple) {
      final fallback = await canLaunchUrl(googleWebUri)
          ? googleWebUri
          : appleWebUri;
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
      return;
    }

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map_outlined),
                title: const Text('Open in Google Maps'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final uri = hasGoogle ? googleAppUri : googleWebUri;
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
              ListTile(
                leading: const Icon(Icons.navigation_outlined),
                title: const Text('Open in Apple Maps'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final uri = hasApple ? appleAppUri : appleWebUri;
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NearbyMosquesMapCard extends StatefulWidget {
  const _NearbyMosquesMapCard({
    required this.latitude,
    required this.longitude,
    required this.mosques,
    required this.isDark,
    required this.awaitingMosqueResults,
    required this.onMosqueTap,
  });

  final double? latitude;
  final double? longitude;
  final List<NearbyMosque> mosques;
  final bool isDark;
  final bool awaitingMosqueResults;
  final Future<void> Function(NearbyMosque mosque) onMosqueTap;

  @override
  State<_NearbyMosquesMapCard> createState() => _NearbyMosquesMapCardState();
}

class _NearbyMosquesMapCardState extends State<_NearbyMosquesMapCard> {
  final MapController _mapController = MapController();

  String _mapFooterCaption() {
    if (widget.mosques.isNotEmpty) {
      return '${widget.mosques.length} mosques found within 5 km';
    }
    if (!widget.awaitingMosqueResults) {
      return 'Nearby mosques will appear here once results load.';
    }
    return 'No mosques found within 5 km';
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _NearbyMosquesMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude ||
        oldWidget.awaitingMosqueResults != widget.awaitingMosqueResults ||
        oldWidget.mosques.length != widget.mosques.length ||
        !_sameMosqueIds(oldWidget.mosques, widget.mosques)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds());
    }
  }

  bool _sameMosqueIds(List<NearbyMosque> a, List<NearbyMosque> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds());
  }

  void _fitBounds() {
    final lat = widget.latitude;
    final lng = widget.longitude;
    if (lat == null || lng == null) return;

    final user = LatLng(lat, lng);
    final points = <LatLng>[
      user,
      ...widget.mosques.map((m) => LatLng(m.latitude, m.longitude)),
    ];

    if (widget.mosques.isEmpty) {
      _mapController.move(user, 14);
      return;
    }

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.fromLTRB(44, 44, 44, 64),
        maxZoom: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lat = widget.latitude;
    final lng = widget.longitude;

    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        color: widget.isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.18 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: lat == null || lng == null
          ? const _MapPlaceholder(hasLocation: false)
          : Stack(
              children: [
                Positioned.fill(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(lat, lng),
                      initialZoom: 14,
                      minZoom: 3,
                      maxZoom: 19,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: AppConfig.mapTilesUrlTemplate,
                        userAgentPackageName: 'com.rnr.deenfocus',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(lat, lng),
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.my_location,
                              color: colorScheme.primary,
                              size: 36,
                              shadows: const [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          for (final mosque in widget.mosques)
                            Marker(
                              point: LatLng(mosque.latitude, mosque.longitude),
                              width: 42,
                              height: 42,
                              alignment: Alignment.bottomCenter,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => widget.onMosqueTap(mosque),
                                  customBorder: const CircleBorder(),
                                  child: Icon(
                                    Icons.location_on,
                                    color: colorScheme.error,
                                    size: 40,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black38,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
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
                      _mapFooterCaption(),
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
            Icon(Icons.map_outlined, size: 38, color: colorScheme.primary),
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

class _NoMosquesFoundCard extends StatelessWidget {
  const _NoMosquesFoundCard({
    required this.hint,
    required this.onRetry,
  });

  final String hint;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.mosque_outlined,
            size: 44,
            color: colorScheme.primary.withValues(alpha: 0.85),
          ),
          const SizedBox(height: 12),
          Text(
            'No mosques found within',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Search radius: 5 km',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
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

const String _offlineOrUnreachableMessage =
    'No internet connection or the service is unreachable. Check your connection and try again.';

bool _nearbyMosquesErrorSuggestsOpenSettings(Object error) {
  if (error is NearbyMosquesException) {
    final m = error.message.toLowerCase();
    return m.contains('permission') || m.contains('settings');
  }
  if (error is PermissionDeniedException) return true;
  if (error is LocationServiceDisabledException) return true;
  return false;
}

String _nearbyMosquesFriendlyError(Object error) {
  if (error is NearbyMosquesException) {
    return error.message;
  }
  if (error is PermissionDeniedException) {
    return 'Location access was denied. Enable it in Settings to see nearby mosques.';
  }
  if (error is LocationServiceDisabledException) {
    return 'Location is turned off on this device. Turn it on in Settings, then try again.';
  }
  if (error is PermissionRequestInProgressException) {
    return 'Location permission is still being processed. Please try again in a moment.';
  }
  if (error is TimeoutException) {
    return 'The request took too long. Check your internet connection and try again.';
  }
  if (error is SocketException ||
      error is ClientException ||
      error is HttpException ||
      error is HandshakeException ||
      error is TlsException) {
    return _offlineOrUnreachableMessage;
  }
  if (error is FormatException) {
    return 'We could not read the mosque list right now. Please try again later.';
  }
  if (error is PlatformException) {
    return 'We could not complete that step. Check your connection and try again.';
  }
  return 'Something went wrong. Please try again.';
}
