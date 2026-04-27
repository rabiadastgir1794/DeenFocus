import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../core/services/focus_enforcement_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_permission_dialog.dart';
import '../../../core/widgets/focus_app_icon.dart';
import '../../../l10n/app_localizations.dart';
import '../model/focus_models.dart';
import '../viewmodel/focus_controller.dart';

class FocusTabScreen extends StatefulWidget {
  const FocusTabScreen({super.key});

  @override
  State<FocusTabScreen> createState() => _FocusTabScreenState();
}

class _FocusTabScreenState extends State<FocusTabScreen>
    with WidgetsBindingObserver {
  static const Duration _modeSwitchLoaderMinDuration = Duration(seconds: 1);

  bool _showGlobalSelector = false;
  FocusModeType? _pendingModeToEnable;
  bool _awaitingBlockingPermission = false;
  bool _isAuthorizingScreenTime = false;
  final Set<FocusModeType> _modesInFlight = <FocusModeType>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  Future<void> _handleAppResumed() async {
    if (!mounted) return;
    final vm = context.read<FocusController>();

    await FocusEnforcementService.appendDebugLog(
      'focus.screen.resume',
      'app resumed awaiting=$_awaitingBlockingPermission pending=${_pendingModeToEnable?.name}',
    );
    // Foreground focus sync is handled by _AppLifecycleFocusRefresher in main.dart.

    if (!_awaitingBlockingPermission) return;

    final granted = await _waitForBlockingPermissionReady();
    if (!granted) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text(
            'Android app blocking is still getting ready. Keep accessibility enabled and give it a moment to connect.',
          ),
        ),
      );
      return;
    }

    _awaitingBlockingPermission = false;
    final pendingMode = _pendingModeToEnable;
    _pendingModeToEnable = null;

    if (!mounted) return;

    if (pendingMode != null) {
      await vm.enableMode(pendingMode);
    } else {
      await vm.refresh();
    }
  }

  Future<bool> _waitForBlockingPermissionReady() async {
    for (var attempt = 0; attempt < 8; attempt++) {
      final granted =
          await FocusEnforcementService.isBlockingPermissionGranted();
      if (granted) return true;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return false;
  }

  String _activeModeBannerDetail(FocusController vm, AppLocalizations l10n) {
    final childActive = vm.settings.childModeEnabled && vm.hasSelectedApps;
    final salahMode =
        vm.settings.salahModeEnabled && !vm.settings.childModeEnabled;
    final nightMode =
        vm.settings.nightDisciplineEnabled && !vm.settings.childModeEnabled;
    if (childActive) {
      return l10n.focusChildBlockingDescription;
    }
    final parts = <String>[];
    if (salahMode) parts.add(l10n.focusPrayerBlockingDescription);
    if (nightMode) parts.add(l10n.focusNightBlockingDescription);
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusController>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        final colorScheme = Theme.of(context).colorScheme;
        final installedAppsByPackage = {
          for (final app in vm.installedApps) app.packageName: app,
        };
        final globalApps = vm.settings.selectedApps.entries
            .map(
              (entry) => _SelectedAppChipData(
                packageName: entry.key,
                label: entry.value,
              ),
            )
            .toList(growable: false);
        final isIosSelection =
            defaultTargetPlatform == TargetPlatform.iOS &&
            vm.settings.iosSelectionCount > 0;
        final childMode = vm.settings.childModeEnabled;
        final childActive = childMode && vm.hasSelectedApps;
        final salahMode =
            vm.settings.salahModeEnabled && !vm.settings.childModeEnabled;
        final nightMode =
            vm.settings.nightDisciplineEnabled && !vm.settings.childModeEnabled;
        final topBannerText = childActive
            ? l10n.focusChildModeActive
            : salahMode && nightMode
            ? l10n.focusSalahAndNightModeActive
            : salahMode
            ? l10n.focusSalahModeActive
            : nightMode
            ? l10n.focusNightModeActive
            : null;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tabFocus,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.focusTabSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (topBannerText != null)
                    _ActiveModeBanner(
                      title: topBannerText,
                      detail: _activeModeBannerDetail(vm, l10n),
                      colorScheme: colorScheme,
                    ),
                  _GlassCard(
                    marginBottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.focusAppsToBlockTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.focusAppliesAllModes,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontSize: 12,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                vm.selectedTargetPhrase,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        if (isIosSelection) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '📱',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    vm.selectedAppsSummary(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (globalApps.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: globalApps.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final app = globalApps[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FocusAppIcon(
                                        label: app.label,
                                        iconBytes:
                                            installedAppsByPackage[app
                                                    .packageName]
                                                ?.iconBytes ??
                                            vm.settings.iconBytesForPackage(
                                              app.packageName,
                                            ),
                                        size: 18,
                                        radius: 6,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        app.label,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () =>
                                            _removeSelectedApp(vm, app),
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            if (_isAuthorizingScreenTime) return;
                            final messenger = ScaffoldMessenger.maybeOf(
                              context,
                            );
                            if (defaultTargetPlatform == TargetPlatform.iOS) {
                              setState(() => _isAuthorizingScreenTime = true);
                              final authResult =
                                  await PermissionService.requestScreenTimeAccessDetailed();
                              if (mounted) {
                                setState(
                                  () => _isAuthorizingScreenTime = false,
                                );
                              }
                              if (!mounted) return;
                              if (!authResult.granted) {
                                messenger?.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authResult.userFacingMessage() ??
                                          l10n.focusScreenTimeRequiredSelectApps,
                                    ),
                                  ),
                                );
                                return;
                              }
                              await vm.requestInstalledApps();
                              return;
                            }
                            final acceptedDisclosure =
                                await _ensureFocusAccessibilityDisclosureAccepted();
                            if (!acceptedDisclosure) {
                              messenger?.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.focusAcceptAccessibilityDisclosure,
                                  ),
                                ),
                              );
                              return;
                            }
                            final shouldShow = !_showGlobalSelector;
                            setState(() {
                              _showGlobalSelector = shouldShow;
                            });
                            if (shouldShow && vm.installedApps.isEmpty) {
                              await vm.requestInstalledApps();
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Ink(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.focusSelectAppsToBlock,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                if (vm.isLoadingApps)
                                  DefaultTextStyle(
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ) ??
                                        const TextStyle(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(l10n.focusLoading),
                                      ],
                                    ),
                                  )
                                else
                                  Text(
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? l10n.focusOpen
                                        : _showGlobalSelector
                                        ? l10n.focusHide
                                        : vm.installedApps.isEmpty
                                        ? l10n.focusLoad
                                        : l10n.focusShow,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_showGlobalSelector) ...[
                          const SizedBox(height: 12),
                          _AppsGrid(vm: vm),
                        ],
                      ],
                    ),
                  ),
                  _ModeCard(
                    marginBottom: 16,
                    icon: Icons.shield_outlined,
                    iconBackground: colorScheme.primary.withValues(alpha: 0.1),
                    iconColor: colorScheme.primary,
                    title: l10n.focusSalahFocusModeTitle,
                    subtitle: l10n.focusBlockAppsDuringPrayer,
                    value: salahMode,
                    isLoading:
                        _modesInFlight.contains(FocusModeType.salah) ||
                        _isAuthorizingScreenTime,
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.salah, value),
                    child: salahMode
                        ? _ModeStatusBanner(
                            text: l10n.focusPrayerBlockingDescription,
                            color: colorScheme.error,
                          )
                        : null,
                  ),
                  _ModeCard(
                    marginBottom: 16,
                    icon: Icons.nightlight_outlined,
                    iconBackground: colorScheme.primary.withValues(alpha: 0.2),
                    iconColor: colorScheme.onSurface,
                    title: l10n.focusNightDisciplineTitle,
                    subtitle: l10n.focusNightDisciplineCardSubtitle,
                    value: nightMode,
                    isLoading:
                        _modesInFlight.contains(
                          FocusModeType.nightDiscipline,
                        ) ||
                        _isAuthorizingScreenTime,
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.nightDiscipline, value),
                    child: nightMode
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _NightTimePill(
                                      label: l10n.focusSleepLabel,
                                      timeText: _formatTime(
                                        context,
                                        vm.settings.nightRange.startHour,
                                        vm.settings.nightRange.startMinute,
                                      ),
                                      onTap: () =>
                                          _pickNightTime(vm, isSleep: true),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _NightTimePill(
                                      label: l10n.focusWakeLabel,
                                      timeText: _formatTime(
                                        context,
                                        vm.settings.nightRange.endHour,
                                        vm.settings.nightRange.endMinute,
                                      ),
                                      onTap: () =>
                                          _pickNightTime(vm, isSleep: false),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _ModeStatusBanner(
                                text: l10n.focusNightBlockingDescription,
                                color: colorScheme.error,
                              ),
                            ],
                          )
                        : null,
                  ),
                  _ModeCard(
                    icon: Icons.child_care_outlined,
                    iconBackground: colorScheme.error.withValues(alpha: 0.1),
                    iconColor: colorScheme.error,
                    title: l10n.focusChildModeTitle,
                    subtitle: l10n.focusBlockAppsImmediately,
                    value: childMode,
                    isLoading:
                        _modesInFlight.contains(FocusModeType.child) ||
                        _isAuthorizingScreenTime,
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.child, value),
                    child: childMode
                        ? _ModeStatusBanner(
                            text: l10n.focusChildBlockingDescription,
                            color: colorScheme.error,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _ensureAndroidBlockingAccess(FocusModeType mode) async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    final l10n = AppLocalizations.of(context)!;

    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.screen.ensurePermission',
        'mode=${mode.name}',
      ),
    );
    final granted = await FocusEnforcementService.isBlockingPermissionGranted();
    if (granted || !mounted) return granted;

    _pendingModeToEnable = mode;
    _awaitingBlockingPermission = true;
    await AppPermissionDialog.show(
      context,
      title: l10n.focusEnableAndroidAppBlocking,
      message:
          l10n.focusEnableAndroidAppBlockingMessage,
      onPrimaryTap: () {
        FocusEnforcementService.openBlockingPermissionSettings();
      },
    );
    return false;
  }

  Future<bool> _ensureFocusAccessibilityDisclosureAccepted() async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    final l10n = AppLocalizations.of(context)!;
    final accepted = await StorageService.focusAccessibilityDisclosureAccepted;
    if (accepted) return true;
    if (!mounted) return false;

    final choice = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.focusAccessibilityDisclosureTitle),
          content: Text(l10n.focusAccessibilityDisclosureMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.focusNotNow),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.focusIUnderstand),
            ),
          ],
        );
      },
    );

    if (choice == true) {
      await StorageService.setFocusAccessibilityDisclosureAccepted(true);
      return true;
    }
    return false;
  }

  /// Ensures [setState] has been laid out and painted so loaders animate before work runs.
  ///
  /// A single [endOfFrame] can complete in the same turn as the gesture, before the
  /// frame that contains the loading UI — so we yield once, then wait two frame boundaries.
  Future<void> _waitUntilLoaderPainted() async {
    await Future<void>.delayed(Duration.zero);
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
  }

  Future<void> _toggleMode(
    FocusController vm,
    FocusModeType mode,
    bool enabled,
  ) async {
    if (_modesInFlight.contains(mode)) return;
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final loaderStopwatch = Stopwatch()..start();
    setState(() => _modesInFlight.add(mode));
    await _waitUntilLoaderPainted();
    if (!mounted) {
      _modesInFlight.remove(mode);
      return;
    }

    try {
      unawaited(
        FocusEnforcementService.appendDebugLog(
          'focus.screen.toggle',
          'mode=${mode.name} enabled=$enabled selected=${vm.settings.selectedApps.keys.join(",")} locked=${vm.lockState.isLocked}',
        ),
      );
      if (enabled && !vm.hasSelectedApps) {
        messenger?.showSnackBar(
          const SnackBar(
            content: Text(
              'No apps selected. Please select apps to block first.',
            ),
          ),
        );
        return;
      }

      if (enabled) {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          setState(() => _isAuthorizingScreenTime = true);
          final authResult =
              await PermissionService.requestScreenTimeAccessDetailed();
          if (mounted) {
            setState(() => _isAuthorizingScreenTime = false);
          }
          if (!mounted) return;
          if (!authResult.granted) {
            messenger?.showSnackBar(
              SnackBar(
                content: Text(
                  authResult.userFacingMessage() ??
                      'Screen Time access is required to block apps on iPhone.',
                ),
              ),
            );
            return;
          }
        }

        final canBlock = await _ensureAndroidBlockingAccess(mode);
        if (!canBlock) return;

        await vm.enableMode(mode);
        return;
      }
      await vm.disableMode(mode);
    } catch (_) {
      if (mounted) {
        messenger?.showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong while updating Focus mode. Please try again.',
            ),
          ),
        );
      }
    } finally {
      final remaining = _modeSwitchLoaderMinDuration - loaderStopwatch.elapsed;
      if (remaining > Duration.zero) {
        await Future<void>.delayed(remaining);
      }
      if (mounted) {
        setState(() => _modesInFlight.remove(mode));
      } else {
        _modesInFlight.remove(mode);
      }
    }
  }

  Future<void> _removeSelectedApp(
    FocusController vm,
    _SelectedAppChipData app,
  ) async {
    final installedAppsByPackage = {
      for (final item in vm.installedApps) item.packageName: item,
    };
    final remaining = vm.settings.selectedApps.entries
        .where((entry) => entry.key != app.packageName)
        .map(
          (entry) => FocusInstalledApp(
            packageName: entry.key,
            appName: entry.value,
            isSystemApp: false,
            iconBytes:
                installedAppsByPackage[entry.key]?.iconBytes ??
                vm.settings.iconBytesForPackage(entry.key),
          ),
        )
        .toList(growable: false);
    await vm.setSelectedApps(remaining);
  }

  String _formatTime(BuildContext context, int hour, int minute) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay(hour: hour, minute: minute));
  }

  Future<void> _pickNightTime(
    FocusController vm, {
    required bool isSleep,
  }) async {
    final sleep = TimeOfDay(
      hour: vm.settings.nightRange.startHour,
      minute: vm.settings.nightRange.startMinute,
    );
    final wake = TimeOfDay(
      hour: vm.settings.nightRange.endHour,
      minute: vm.settings.nightRange.endMinute,
    );
    final initial = isSleep ? sleep : wake;
    final picked = await _showCupertinoTimePicker(
      context,
      initialTime: initial,
      title: isSleep ? 'Sleep' : 'Wake',
    );
    if (picked == null || !mounted) return;
    if (isSleep) {
      await vm.setNightRange(picked, wake);
    } else {
      await vm.setNightRange(sleep, picked);
    }
  }

  Future<TimeOfDay?> _showCupertinoTimePicker(
    BuildContext context, {
    required TimeOfDay initialTime,
    String? title,
  }) {
    final use24h = MediaQuery.of(context).alwaysUse24HourFormat;
    var selected = DateTime(2020, 1, 1, initialTime.hour, initialTime.minute);

    return showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (ctx) {
        final surface = Theme.of(ctx).colorScheme.surface;
        return Container(
          height: 280,
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(AppLocalizations.of(ctx)!.cancel),
                      ),
                      if (title != null)
                        Text(
                          title,
                          style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(
                            TimeOfDay(
                              hour: selected.hour,
                              minute: selected.minute,
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(ctx)!.focusDone),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: use24h,
                    initialDateTime: selected,
                    onDateTimeChanged: (DateTime dt) {
                      selected = dt;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActiveModeBanner extends StatelessWidget {
  const _ActiveModeBanner({
    required this.title,
    required this.detail,
    required this.colorScheme,
  });

  final String title;
  final String detail;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.error.withValues(alpha: 0.1),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.marginBottom = 0});

  final Widget child;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isLoading,
    required this.onChanged,
    this.child,
    this.marginBottom = 0,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final bool isLoading;
  final ValueChanged<bool> onChanged;
  final Widget? child;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _GlassCard(
      marginBottom: marginBottom,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 52,
                height: 32,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : Switch(value: value, onChanged: onChanged),
                ),
              ),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: child!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ModeStatusBanner extends StatelessWidget {
  const _ModeStatusBanner({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.10),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NightTimePill extends StatelessWidget {
  const _NightTimePill({
    required this.label,
    required this.timeText,
    required this.onTap,
  });

  final String label;
  final String timeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeText,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppsGrid extends StatelessWidget {
  const _AppsGrid({required this.vm});

  final FocusController vm;
  static const int _maxRows = 5;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final apps = vm.installedApps;

    if (vm.isLoadingApps) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 12),
            Text(
              'Loading installed apps...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (apps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'No installed apps available to show.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    final maxHeight = MediaQuery.sizeOf(context).height * 0.58;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: maxHeight.clamp(280.0, 460.0),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.hardEdge,
          itemCount: apps.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _maxRows,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 88,
          ),
          itemBuilder: (context, index) {
            final app = apps[index];
            final selected = vm.settings.selectedApps.containsKey(
              app.packageName,
            );
            return InkWell(
              onTap: () => vm.toggleSelectedApp(app),
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: selected
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                  border: Border.all(
                    color: selected
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FocusAppIcon(
                      label: app.appName,
                      iconBytes: app.iconBytes,
                      size: 28,
                      radius: 10,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      app.appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SelectedAppChipData {
  const _SelectedAppChipData({required this.packageName, required this.label});

  final String packageName;
  final String label;
}
