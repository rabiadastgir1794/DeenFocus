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
import 'widgets/onboarding_location_qibla_hero.dart';

const double _kLocationActionHeight = 52;

class _SearchUiState {
  const _SearchUiState({
    this.isSearching = false,
    this.results = const [],
    this.activeQuery = '',
    this.selectedLocation,
  });

  final bool isSearching;
  final List<LocationSuggestion> results;
  final String activeQuery;
  final LocationSuggestion? selectedLocation;

  _SearchUiState copyWith({
    bool? isSearching,
    List<LocationSuggestion>? results,
    String? activeQuery,
    LocationSuggestion? selectedLocation,
    bool clearSelected = false,
  }) {
    return _SearchUiState(
      isSearching: isSearching ?? this.isSearching,
      results: results ?? this.results,
      activeQuery: activeQuery ?? this.activeQuery,
      selectedLocation: clearSelected
          ? null
          : (selectedLocation ?? this.selectedLocation),
    );
  }
}

class OnboardingLocationPage extends StatefulWidget {
  const OnboardingLocationPage({
    super.key,
    required this.onLocationSelected,
    this.onPermissionChanged,
    this.onPermissionLocationResolved,
    this.onManualLocationResolved,
    this.initialSelection,
  });

  final ValueChanged<LocationSuggestion?> onLocationSelected;
  final ValueChanged<bool>? onPermissionChanged;

  /// Called when GPS location is saved after permission grant (triggers auto-advance).
  final ValueChanged<LocationSuggestion>? onPermissionLocationResolved;

  /// Called when a city is chosen via manual search (triggers auto-advance).
  final ValueChanged<LocationSuggestion>? onManualLocationResolved;
  final LocationSuggestion? initialSelection;

  @override
  State<OnboardingLocationPage> createState() => _OnboardingLocationPageState();
}

class _OnboardingLocationPageState extends State<OnboardingLocationPage> {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  final SearchPlacesUseCase _searchPlacesUseCase = SearchPlacesUseCase();
  final ValueNotifier<_SearchUiState> _searchUi = ValueNotifier(
    const _SearchUiState(),
  );
  final ValueNotifier<bool> _showClearButton = ValueNotifier(false);

  Timer? _searchDebounce;
  int _searchRequestId = 0;
  bool _isResolvingLocation = false;
  bool _showManualEntry = false;
  bool _didReportPermissionLocation = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSelection;
    if (initial != null) {
      _cityController.text = initial.title;
      _showManualEntry = true;
      _showClearButton.value = true;
      _searchUi.value = _SearchUiState(
        selectedLocation: initial,
        results: <LocationSuggestion>[initial],
        activeQuery: initial.title,
      );
    }
    _cityController.addListener(_syncClearButton);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _cityController.removeListener(_syncClearButton);
    _cityFocusNode.dispose();
    _cityController.dispose();
    _searchUi.dispose();
    _showClearButton.dispose();
    super.dispose();
  }

  void _syncClearButton() {
    final hasText = _cityController.text.isNotEmpty;
    if (_showClearButton.value != hasText) {
      _showClearButton.value = hasText;
    }
  }

  /// Primary CTA: request native location permission immediately (App Store 5.1.1(iv)).
  Future<void> _onContinueTap() async {
    _cityFocusNode.unfocus();
    final status = await PermissionService.requestLocationStatus();
    if (!mounted) return;

    if (status.isGranted) {
      widget.onPermissionChanged?.call(true);
      await _fetchAndApplyCurrentLocation(fromPermissionGrant: true);
      return;
    }

    widget.onPermissionChanged?.call(false);

    // Denial keeps this screen open; manual city entry remains available.
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

  Future<void> _fetchAndApplyCurrentLocation({
    bool fromPermissionGrant = false,
  }) async {
    setState(() => _isResolvingLocation = true);

    try {
      final location = await LocationService.fetchCurrentCity();
      if (!mounted || location == null) return;

      _applySelectedLocation(
        location,
        updateResults: true,
        fromPermissionGrant: fromPermissionGrant,
      );
    } catch (_) {
      // Timeout or location error — dismiss spinner so user can search manually.
    } finally {
      if (mounted) {
        setState(() => _isResolvingLocation = false);
      }
    }
  }

  void _clearParentSelectionIfNeeded() {
    if (_searchUi.value.selectedLocation == null) return;
    _searchUi.value = _searchUi.value.copyWith(clearSelected: true);
    widget.onLocationSelected(null);
  }

  void _onQueryChanged(String value) {
    _searchDebounce?.cancel();
    _clearParentSelectionIfNeeded();

    final query = value.trim();
    if (query.isEmpty) {
      _searchUi.value = const _SearchUiState();
      return;
    }

    _searchUi.value = _searchUi.value.copyWith(
      activeQuery: query,
      clearSelected: true,
    );
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    final requestId = ++_searchRequestId;
    _searchUi.value = _searchUi.value.copyWith(isSearching: true);

    final results = await _searchPlacesUseCase.execute(query);
    if (!mounted || requestId != _searchRequestId) return;

    _searchUi.value = _searchUi.value.copyWith(
      isSearching: false,
      results: results,
      activeQuery: query,
    );
  }

  void _applySelectedLocation(
    LocationSuggestion location, {
    bool updateResults = false,
    bool fromPermissionGrant = false,
  }) {
    _cityController.text = location.title;
    _cityController.selection = TextSelection.fromPosition(
      TextPosition(offset: _cityController.text.length),
    );
    _searchUi.value = _searchUi.value.copyWith(
      selectedLocation: location,
      results: updateResults
          ? <LocationSuggestion>[location]
          : _searchUi.value.results,
      activeQuery: location.title,
      isSearching: false,
    );

    if (fromPermissionGrant && !_didReportPermissionLocation) {
      _didReportPermissionLocation = true;
      final resolved = widget.onPermissionLocationResolved;
      if (resolved != null) {
        resolved(location);
        return;
      }
    }

    if (!fromPermissionGrant) {
      final manualResolved = widget.onManualLocationResolved;
      if (manualResolved != null) {
        manualResolved(location);
        return;
      }
    }

    widget.onLocationSelected(location);
  }

  Future<void> _onLocationTap(LocationSuggestion item) async {
    _cityFocusNode.unfocus();

    if (item.latitude != null && item.longitude != null) {
      _applySelectedLocation(item);
      return;
    }

    setState(() => _isResolvingLocation = true);
    try {
      final resolved = await LocationService.resolveCoordinates(item);
      if (!mounted) return;
      if (resolved == null) {
        // Never apply a city without coordinates — prayer times would stay on
        // the previous location (or go blank) while the label shows the new city.
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.onboardingNoLocationsFound)),
        );
        return;
      }
      _applySelectedLocation(resolved);
    } finally {
      if (mounted) {
        setState(() => _isResolvingLocation = false);
      }
    }
  }

  void _activateManualEntry() {
    if (_showManualEntry) {
      _cityFocusNode.requestFocus();
      return;
    }

    setState(() => _showManualEntry = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _cityFocusNode.requestFocus();
    });
  }

  void _exitManualEntry() {
    _cityFocusNode.unfocus();
    setState(() => _showManualEntry = false);
  }

  void _clearCityQuery() {
    _cityController.clear();
    _onQueryChanged('');
    _cityFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _showManualEntry
              ? KeyedSubtree(
                  key: const ValueKey('location-search-mode'),
                  child: _buildSearchMode(context, l10n),
                )
              : KeyedSubtree(
                  key: const ValueKey('location-browse-mode'),
                  child: _buildBrowseMode(context, l10n),
                ),
        ),
        if (_isResolvingLocation)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(child: CupertinoActivityIndicator(radius: 12.r)),
            ),
          ),
      ],
    );
  }

  /// Default onboarding marketing layout (hero + chips + actions).
  Widget _buildBrowseMode(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final compact = MediaQuery.sizeOf(context).height < 780;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.locationTitle,
              textAlign: TextAlign.center,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: compact ? 24.sp : 28.sp,
                height: 1.15,
                letterSpacing: -0.3,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: Spacing.sm.h),
            Text(
              l10n.locationSubtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.35,
                fontSize: compact ? 13.sp : 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: Spacing.md.h),
            Center(
              child: RepaintBoundary(
                child: OnboardingLocationQiblaHero(
                  compact: compact,
                  size: compact ? 156.r : 176.r,
                ),
              ),
            ),
            SizedBox(height: Spacing.md.h),
            _LocationBenefitChips(compact: compact),
            SizedBox(height: Spacing.lg.h),
            _LocationActionButton(
              label: l10n.continueButton,
              onPressed: _isResolvingLocation ? null : _onContinueTap,
              loading: _isResolvingLocation,
              primary: true,
              icon: CupertinoIcons.location_solid,
            ),
            SizedBox(height: Spacing.md.h),
            _OrDivider(label: l10n.locationOrDivider),
            SizedBox(height: Spacing.md.h),
            _LocationActionButton(
              label: l10n.locationManualEntry,
              onPressed: _activateManualEntry,
              primary: false,
              icon: CupertinoIcons.building_2_fill,
            ),
            SizedBox(height: Spacing.md.h),
            _PrivacyNote(
              title: l10n.locationPrivacyTitle,
              body: l10n.locationPrivacyBody,
            ),
            SizedBox(height: Spacing.md.h),
          ],
        ),
      ),
    );
  }

  /// Focused city search: field stays put, results fill space above the keyboard.
  Widget _buildSearchMode(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Spacing.lg.w,
        Spacing.sm.h,
        Spacing.lg.w,
        Spacing.sm.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _exitManualEntry,
                tooltip: l10n.cancel,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  CupertinoIcons.back,
                  size: 20.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: Text(
                  l10n.locationManualEntry,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(width: 40.w),
            ],
          ),
          SizedBox(height: Spacing.sm.h),
          SizedBox(
            height: _kLocationActionHeight.h,
            child: ValueListenableBuilder<bool>(
              valueListenable: _showClearButton,
              builder: (context, showClear, _) {
                return _ManualCityField(
                  controller: _cityController,
                  focusNode: _cityFocusNode,
                  placeholder: l10n.onboardingTypeCityName,
                  showClear: showClear,
                  onChanged: _onQueryChanged,
                  onClear: _clearCityQuery,
                );
              },
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          Expanded(
            child: ValueListenableBuilder<_SearchUiState>(
              valueListenable: _searchUi,
              builder: (context, search, _) {
                return _ManualSearchResults(
                  isSearching: search.isSearching,
                  results: search.results,
                  activeQuery: search.activeQuery,
                  selectedLocation: search.selectedLocation,
                  onTap: _onLocationTap,
                );
              },
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          _PrivacyNote(
            title: l10n.locationPrivacyTitle,
            body: l10n.locationPrivacyBody,
          ),
        ],
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_rounded,
              size: 14.sp,
              color: colorScheme.primary,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  height: 1.3,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          body,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11.sp,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _ManualCityField extends StatelessWidget {
  const _ManualCityField({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.showClear,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final bool showClear;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.search,
      scrollPadding: EdgeInsets.zero,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
        suffixIcon: SizedBox(
          width: 40.w,
          child: showClear
              ? IconButton(
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    CupertinoIcons.clear_circled_solid,
                    size: 18.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _ManualSearchResults extends StatelessWidget {
  const _ManualSearchResults({
    required this.isSearching,
    required this.results,
    required this.activeQuery,
    required this.selectedLocation,
    required this.onTap,
  });

  final bool isSearching;
  final List<LocationSuggestion> results;
  final String activeQuery;
  final LocationSuggestion? selectedLocation;
  final ValueChanged<LocationSuggestion> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isSearching) {
      return Center(
        child: SizedBox(
          width: 22.w,
          height: 22.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
      );
    }

    if (results.isNotEmpty) {
      return ListView.separated(
        padding: EdgeInsets.only(bottom: Spacing.sm.h),
        itemCount: results.length,
        separatorBuilder: (_, _) => SizedBox(height: Spacing.sm.h),
        itemBuilder: (context, index) {
          final item = results[index];
          final isSelected =
              selectedLocation?.title == item.title &&
              selectedLocation?.subtitle == item.subtitle;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(item),
              borderRadius: BorderRadius.circular(14.r),
              child: Ink(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.md.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.08)
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.55,
                        ),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (item.subtitle.trim().isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    if (activeQuery.isNotEmpty) {
      return Center(
        child: AppEmptyState(
          title: l10n.onboardingNoLocationsFound,
          subtitle: l10n.onboardingTryAnotherCityName,
        ),
      );
    }

    return Center(
      child: Text(
        l10n.onboardingTypeCityName,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}

class _LocationBenefitChips extends StatelessWidget {
  const _LocationBenefitChips({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Spacing.sm.w,
      runSpacing: Spacing.sm.h,
      children: [
        _LocationBenefitChip(
          icon: CupertinoIcons.compass,
          label: l10n.locationFeatureQiblaTitle,
          compact: compact,
        ),
        _LocationBenefitChip(
          icon: CupertinoIcons.time,
          label: l10n.locationFeaturePrayerTimesTitle,
          compact: compact,
        ),
        _LocationBenefitChip(
          icon: CupertinoIcons.location_solid,
          label: l10n.locationFeatureMasjidsTitle,
          compact: compact,
        ),
      ],
    );
  }
}

class _LocationBenefitChip extends StatelessWidget {
  const _LocationBenefitChip({
    required this.icon,
    required this.label,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12.w : 14.w,
        vertical: compact ? 8.h : 10.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 14.sp : 15.sp, color: colorScheme.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: compact ? 12.sp : 13.sp,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lineColor = colorScheme.outlineVariant.withValues(alpha: 0.9);
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        Expanded(child: Divider(height: 1, color: lineColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.md.w),
          child: Text(label, style: textStyle),
        ),
        Expanded(child: Divider(height: 1, color: lineColor)),
      ],
    );
  }
}

class _LocationActionButton extends StatelessWidget {
  const _LocationActionButton({
    required this.label,
    required this.onPressed,
    required this.primary,
    this.icon,
    this.loading = false,
    this.showTrailingChevron = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final IconData? icon;
  final bool loading;
  final bool showTrailingChevron;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = primary
        ? colorScheme.primary
        : Colors.transparent;
    final foregroundColor = primary
        ? colorScheme.onPrimary
        : colorScheme.primary;
    final radius = BorderRadius.circular(999);

    final labelRow = loading
        ? SizedBox(
            height: 22.h,
            width: 22.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : showTrailingChevron
        ? Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: foregroundColor),
                SizedBox(width: Spacing.sm.w),
              ],
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: Spacing.sm.w),
              Icon(
                CupertinoIcons.chevron_forward,
                size: 16.sp,
                color: foregroundColor,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: foregroundColor),
                SizedBox(width: Spacing.sm.w),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );

    return SizedBox(
      width: double.infinity,
      height: _kLocationActionHeight.h,
      child: primary
          ? ElevatedButton(
              onPressed: loading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                disabledBackgroundColor: backgroundColor.withValues(alpha: 0.7),
                disabledForegroundColor: foregroundColor.withValues(alpha: 0.7),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: radius),
                padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
              ),
              child: labelRow,
            )
          : OutlinedButton(
              onPressed: loading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                side: BorderSide(color: colorScheme.primary, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: radius),
                padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
              ),
              child: labelRow,
            ),
    );
  }
}
