import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/services/location/location_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/search_places_use_case.dart';
import '../model/location_suggestion.dart';

class OnboardingLocationPage extends StatefulWidget {
  const OnboardingLocationPage({
    super.key,
    required this.onLocationSelected,
    this.initialSelection,
    this.autoFetchLocation = true,
  });

  final ValueChanged<LocationSuggestion?> onLocationSelected;
  final LocationSuggestion? initialSelection;
  final bool autoFetchLocation;

  @override
  State<OnboardingLocationPage> createState() => _OnboardingLocationPageState();
}

class _OnboardingLocationPageState extends State<OnboardingLocationPage> {
  final TextEditingController _cityController = TextEditingController();
  final SearchPlacesUseCase _searchPlacesUseCase = SearchPlacesUseCase();

  Timer? _searchDebounce;
  bool _isResolvingLocation = false;
  bool _isSearching = false;
  bool _locationPermissionRequested = false;
  List<LocationSuggestion> _results = const [];
  int _searchRequestId = 0;
  String _activeQuery = '';

  LocationSuggestion? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialSelection;
    if (_selectedLocation != null) {
      _cityController.text = _selectedLocation!.title;
    }
    if (widget.autoFetchLocation) {
      _requestPermissionWithDelay();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissionWithDelay() async {
    if (_locationPermissionRequested) return;

    _locationPermissionRequested = true;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    final status = await PermissionService.requestLocationStatus();
    if (!mounted) return;

    if (status.isGranted) {
      await _fetchAndApplyCurrentLocation();
      return;
    }

    if (status.isPermanentlyDenied) {
      final l10n = AppLocalizations.of(context)!;
      await AppPermissionDialog.show(
        context,
        title: l10n.locationRequired,
        message: l10n.locationRequiredMessage,
        primaryButtonText: l10n.openSettings,
        secondaryButtonText: l10n.cancel,
        onPrimaryTap: () => PermissionService.openLocationSettings(),
        onSecondaryTap: () {},
      );
    }
  }

  Future<void> _fetchAndApplyCurrentLocation() async {
    setState(() {
      _isResolvingLocation = true;
    });

    try {
      final location = await LocationService.fetchCurrentCity();
      if (!mounted || location == null) return;

      _applySelectedLocation(location, updateResults: true);
    } catch (_) {
      // Timeout or location error — dismiss spinner so user can search manually.
    } finally {
      if (mounted) {
        setState(() {
          _isResolvingLocation = false;
        });
      }
    }
  }

  void _onQueryChanged(String value) {
    _searchDebounce?.cancel();

    final query = value.trim();
    _activeQuery = query;
    if (query.isEmpty) {
      setState(() {
        _results = const [];
        _isSearching = false;
      });
      widget.onLocationSelected(null);
      _selectedLocation = null;
      return;
    }

    widget.onLocationSelected(null);
    _selectedLocation = null;

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    final requestId = ++_searchRequestId;
    setState(() {
      _isSearching = true;
    });
    final results = await _searchPlacesUseCase.execute(query);

    if (!mounted || requestId != _searchRequestId) {
      return;
    }

    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  void _applySelectedLocation(
    LocationSuggestion location, {
    bool updateResults = false,
  }) {
    setState(() {
      _selectedLocation = location;
      _cityController.text = location.title;
      _cityController.selection = TextSelection.fromPosition(
        TextPosition(offset: _cityController.text.length),
      );
      if (updateResults) {
        _results = <LocationSuggestion>[location];
      }
    });

    widget.onLocationSelected(location);
  }

  Future<void> _onLocationTap(LocationSuggestion item) async {
    if (item.latitude != null && item.longitude != null) {
      _applySelectedLocation(item);
      return;
    }

    setState(() {
      _isResolvingLocation = true;
    });

    try {
      if (!mounted) return;
      _applySelectedLocation(item);
    } finally {
      if (mounted) {
        setState(() {
          _isResolvingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
            final maxSuggestionHeight = (constraints.maxHeight * 0.36).clamp(
              120.0,
              260.0,
            );
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: keyboardInset),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Spacing.md.h),
                      AppIconCircle(
                        size: 64.8.r,
                        iconSize: 28.8.sp,
                        icon: const Icon(CupertinoIcons.location),
                      ),
                      SizedBox(height: Spacing.xl.h),
                      Text(
                        l10n.locationTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                      ),
                      SizedBox(height: Spacing.md.h),
                      Text(
                        l10n.locationSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: Spacing.xl.h),
                      AppTextField(
                        controller: _cityController,
                        placeholder: l10n.onboardingTypeCityName,
                        textAlign: TextAlign.center,
                        onChanged: _onQueryChanged,
                      ),
                      SizedBox(height: Spacing.md.h),
                      if (_isSearching)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_results.isNotEmpty)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: maxSuggestionHeight,
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: _results.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(height: Spacing.sm.h),
                            itemBuilder: (context, index) {
                              final item = _results[index];
                              final isSelected =
                                  _selectedLocation?.title == item.title &&
                                  _selectedLocation?.subtitle == item.subtitle;

                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
                                  ),
                                ),
                                title: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.25.sp,
                                  ),
                                ),
                                subtitle: item.subtitle.trim().isEmpty
                                    ? null
                                    : Text(
                                        item.subtitle,
                                        style: TextStyle(
                                          fontSize: 9.75.sp,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                onTap: () => _onLocationTap(item),
                              );
                            },
                          ),
                        )
                      else if (_activeQuery.isNotEmpty)
                        AppEmptyState(
                          title: l10n.onboardingNoLocationsFound,
                          subtitle: l10n.onboardingTryAnotherCityName,
                        ),
                      SizedBox(height: Spacing.xl.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (_isResolvingLocation)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(child: CupertinoActivityIndicator(radius: 12.r)),
            ),
          ),
      ],
    );
  }
}
