import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../core/services/focus_enforcement_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/superwall/premium_gate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_permission_dialog.dart';
import '../../../core/widgets/focus_app_icon.dart';
import '../../../l10n/app_localizations.dart';
import '../model/focus_models.dart';
import '../viewmodel/focus_controller.dart';

String _salahBlockingDescription(AppLocalizations l10n) {
  return l10n.focusPrayerBlockingDescriptionIos;
}

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
    // Idempotent: focus state is warmed from [_AppLifecycleObserver] after first
    // frame so Home stays in sync; keep this so opening Focus before that callback
    // (e.g. very fast tap) still initializes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(context.read<FocusController>().initialize());
    });
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(l10n.focusAndroidBlockingNotReady)),
      );
      return;
    }

    _awaitingBlockingPermission = false;
    _pendingModeToEnable = null;

    if (!mounted) return;

    await vm.refresh();
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
    if (salahMode) parts.add(_salahBlockingDescription(l10n));
    if (nightMode) parts.add(l10n.focusNightBlockingDescription);
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FocusHeader(
                textTheme: textTheme,
                colorScheme: colorScheme,
                l10n: l10n,
              ),
              Selector<FocusController, _TopBannerData?>(
                selector: (_, vm) => _computeTopBannerData(vm, l10n),
                builder: (context, banner, _) {
                  if (banner == null) return const SizedBox.shrink();
                  return _ActiveModeBanner(
                    title: banner.title,
                    detail: banner.detail,
                    colorScheme: colorScheme,
                  );
                },
              ),
              _SelectedAppsSection(
                showGlobalSelector: _showGlobalSelector,
                isAuthorizingScreenTime: _isAuthorizingScreenTime,
                onSelectAppsTap: _handleSelectAppsTap,
                onRemoveSelectedApp: _handleRemoveSelectedApp,
                onToggleApp: _handleToggleApp,
              ),
              _ModeCardsSection(
                modesInFlight: _modesInFlight,
                isAuthorizingScreenTime: _isAuthorizingScreenTime,
                formatTime: _formatTime,
                onToggleMode: _handleToggleMode,
                onPickNightTime: _handlePickNightTime,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _TopBannerData? _computeTopBannerData(
    FocusController vm,
    AppLocalizations l10n,
  ) {
    final childMode = vm.settings.childModeEnabled;
    final childActive = childMode && vm.hasSelectedApps;
    final salahMode = vm.settings.salahModeEnabled && !childMode;
    final nightMode = vm.settings.nightDisciplineEnabled && !childMode;
    final topBannerText = childActive
        ? l10n.focusChildModeActive
        : salahMode && nightMode
        ? l10n.focusSalahAndNightModeActive
        : salahMode
        ? l10n.focusSalahModeActive
        : nightMode
        ? l10n.focusNightModeActive
        : null;
    if (topBannerText == null) return null;
    return _TopBannerData(
      title: topBannerText,
      detail: _activeModeBannerDetail(vm, l10n),
    );
  }

  void _handleSelectAppsTap() {
    final vm = context.read<FocusController>();
    final l10n = AppLocalizations.of(context)!;
    unawaited(_onSelectAppsRowTapped(vm, l10n));
  }

  void _handleRemoveSelectedApp(_SelectedAppChipData app) {
    final vm = context.read<FocusController>();
    unawaited(_removeSelectedApp(vm, app));
  }

  Future<void> _handleToggleApp(FocusInstalledApp app) async {
    final vm = context.read<FocusController>();
    await vm.toggleSelectedApp(app);
  }

  void _handleToggleMode(FocusModeType mode, bool enabled) {
    final vm = context.read<FocusController>();
    unawaited(_toggleMode(vm, mode, enabled));
  }

  void _handlePickNightTime({required bool isSleep}) {
    final vm = context.read<FocusController>();
    unawaited(_pickNightTime(vm, isSleep: isSleep));
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
      message: l10n.focusEnableAndroidAppBlockingMessage,
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
    await SchedulerBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> _onSelectAppsRowTapped(
    FocusController vm,
    AppLocalizations l10n,
  ) async {
    if (_isAuthorizingScreenTime) return;
    await _runSelectAppsFlow(vm, l10n);
  }

  /// Premium is required only when fetching/opening the installed-app list, not
  /// when toggling individual apps or showing an already-loaded grid.
  Future<void> _requestInstalledAppsAfterPremium(FocusController vm) async {
    await PremiumGate.presentIfNeeded(
      context: context,
      onAccess: () {
        if (!mounted) return;
        unawaited(vm.requestInstalledApps());
      },
      debugContext: 'focus:load_apps',
    );
  }

  Future<void> _runSelectAppsFlow(
    FocusController vm,
    AppLocalizations l10n,
  ) async {
    if (!mounted || _isAuthorizingScreenTime) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
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
                  l10n.focusScreenTimeRequiredSelectApps,
            ),
          ),
        );
        return;
      }
      await _requestInstalledAppsAfterPremium(vm);
      return;
    }
    final acceptedDisclosure =
        await _ensureFocusAccessibilityDisclosureAccepted();
    if (!acceptedDisclosure) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.focusAcceptAccessibilityDisclosure)),
      );
      return;
    }
    // Hiding the selector — no gate needed.
    if (_showGlobalSelector) {
      setState(() => _showGlobalSelector = false);
      return;
    }

    // Always verify subscription before opening the selector. The warm
    // cache may have pre-loaded apps without icons, so requestInstalledApps()
    // inside onAccess ensures icons are loaded and subscription is confirmed.
    await _openSelectorAfterPremium(vm);
  }

  Future<void> _openSelectorAfterPremium(FocusController vm) async {
    if (!mounted) return;
    await PremiumGate.presentIfNeeded(
      context: context,
      onAccess: () {
        if (!mounted) return;
        setState(() => _showGlobalSelector = true);
        unawaited(vm.requestInstalledApps());
      },
      debugContext: 'focus:load_apps',
    );
  }

  Future<void> _enableModeAfterPremium(
    FocusController vm,
    FocusModeType mode,
    ScaffoldMessengerState? messenger,
    AppLocalizations l10n,
  ) async {
    if (!mounted) return;
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
                  l10n.focusScreenTimeRequiredBlockIphone,
            ),
          ),
        );
        return;
      }
    }

    final canBlock = await _ensureAndroidBlockingAccess(mode);
    if (!canBlock) return;

    await vm.enableMode(mode);
  }

  Future<void> _toggleMode(
    FocusController vm,
    FocusModeType mode,
    bool enabled,
  ) async {
    if (_modesInFlight.contains(mode)) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
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
          SnackBar(content: Text(l10n.focusNoAppsSelectedSnack)),
        );
        return;
      }

      if (enabled) {
        await _runEnableModeFlow(
          vm: vm,
          mode: mode,
          messenger: messenger,
          l10n: l10n,
        );
      } else {
        await vm.disableMode(mode);
      }
    } catch (_) {
      if (mounted) {
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.focusModeUpdateFailedSnack)),
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

  Future<void> _runEnableModeFlow({
    required FocusController vm,
    required FocusModeType mode,
    required ScaffoldMessengerState? messenger,
    required AppLocalizations l10n,
  }) async {
    final completeEnable = Completer<void>();
    var paywallGrantedCallback = false;
    await PremiumGate.presentIfNeeded(
      context: context,
      onAccess: () {
        paywallGrantedCallback = true;
        unawaited(
          Future<void>(() async {
            try {
              await _enableModeAfterPremium(vm, mode, messenger, l10n);
            } finally {
              if (!completeEnable.isCompleted) completeEnable.complete();
            }
          }),
        );
      },
      debugContext: 'focus:enable_mode:${mode.name}',
    );
    if (!paywallGrantedCallback && !completeEnable.isCompleted) {
      completeEnable.complete();
    }
    await completeEnable.future;
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
    final l10n = AppLocalizations.of(context)!;
    final picked = await _showCupertinoTimePicker(
      context,
      initialTime: initial,
      title: isSleep ? l10n.focusSleepLabel : l10n.focusWakeLabel,
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
                    height: 1.35,
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

class _FocusHeader extends StatelessWidget {
  const _FocusHeader({
    required this.textTheme,
    required this.colorScheme,
    required this.l10n,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tabFocus,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.focusTabSubtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SelectedAppsSection extends StatelessWidget {
  const _SelectedAppsSection({
    required this.showGlobalSelector,
    required this.isAuthorizingScreenTime,
    required this.onSelectAppsTap,
    required this.onRemoveSelectedApp,
    required this.onToggleApp,
  });

  final bool showGlobalSelector;
  final bool isAuthorizingScreenTime;
  final VoidCallback onSelectAppsTap;
  final ValueChanged<_SelectedAppChipData> onRemoveSelectedApp;
  final Future<void> Function(FocusInstalledApp app) onToggleApp;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    return _GlassCard(
      marginBottom: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SelectedAppsHeader(
            textTheme: textTheme,
            colorScheme: colorScheme,
            l10n: l10n,
          ),
          Selector<FocusController, _SelectedAppsData>(
            selector: (_, vm) => _SelectedAppsData.fromVm(vm),
            builder: (context, data, _) {
              if (data.isIosSelection) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _IosSelectedAppsBanner(summary: data.iosSummary),
                );
              }
              if (data.globalApps.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _SelectedAppsList(
                  apps: data.globalApps,
                  iconBytesByPackage: data.iconBytesByPackage,
                  onRemoveSelectedApp: onRemoveSelectedApp,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Selector<FocusController, _SelectAppsRowData>(
            selector: (_, vm) => _SelectAppsRowData.fromVm(
              vm: vm,
              showGlobalSelector: showGlobalSelector,
            ),
            builder: (context, data, _) {
              return _SelectAppsRow(
                data: data,
                isAuthorizingScreenTime: isAuthorizingScreenTime,
                onTap: onSelectAppsTap,
              );
            },
          ),
          if (showGlobalSelector) ...[
            const SizedBox(height: 12),
            _AppsGrid(onAppToggle: onToggleApp),
          ],
        ],
      ),
    );
  }
}

class _SelectedAppsHeader extends StatelessWidget {
  const _SelectedAppsHeader({
    required this.textTheme,
    required this.colorScheme,
    required this.l10n,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final primaryTint = colorScheme.primary.withValues(alpha: 0.1);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.focusAppsToBlockTitle,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.focusAppliesAllModes,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Selector<FocusController, String>(
          selector: (_, vm) => vm.selectedTargetPhrase,
          builder: (context, selectedPhrase, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryTint,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                selectedPhrase,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _IosSelectedAppsBanner extends StatelessWidget {
  const _IosSelectedAppsBanner({required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('📱', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedAppsList extends StatelessWidget {
  const _SelectedAppsList({
    required this.apps,
    required this.iconBytesByPackage,
    required this.onRemoveSelectedApp,
  });

  final List<_SelectedAppChipData> apps;
  final Map<String, Uint8List?> iconBytesByPackage;
  final ValueChanged<_SelectedAppChipData> onRemoveSelectedApp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final app = apps[index];
          return _SelectedAppChip(
            key: ValueKey<String>('selected-${app.packageName}'),
            app: app,
            iconBytes: iconBytesByPackage[app.packageName],
            onRemove: onRemoveSelectedApp,
          );
        },
      ),
    );
  }
}

class _SelectedAppChip extends StatelessWidget {
  const _SelectedAppChip({
    super.key,
    required this.app,
    required this.iconBytes,
    required this.onRemove,
  });

  final _SelectedAppChipData app;
  final Uint8List? iconBytes;
  final ValueChanged<_SelectedAppChipData> onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FocusAppIcon(
            label: app.label,
            iconBytes: iconBytes,
            size: 18,
            radius: 6,
          ),
          const SizedBox(width: 8),
          Text(
            app.label,
            style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => onRemove(app),
            child: Icon(
              Icons.close,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectAppsRow extends StatelessWidget {
  const _SelectAppsRow({
    required this.data,
    required this.isAuthorizingScreenTime,
    required this.onTap,
  });

  final _SelectAppsRowData data;
  final bool isAuthorizingScreenTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: isAuthorizingScreenTime ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.focusSelectAppsToBlock,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (data.isLoadingApps)
              DefaultTextStyle(
                style:
                    textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ) ??
                    const TextStyle(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.focusLoading),
                  ],
                ),
              )
            else
              Text(
                data.actionLabel(l10n),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModeCardsSection extends StatelessWidget {
  const _ModeCardsSection({
    required this.modesInFlight,
    required this.isAuthorizingScreenTime,
    required this.formatTime,
    required this.onToggleMode,
    required this.onPickNightTime,
  });

  final Set<FocusModeType> modesInFlight;
  final bool isAuthorizingScreenTime;
  final String Function(BuildContext context, int hour, int minute) formatTime;
  final void Function(FocusModeType mode, bool enabled) onToggleMode;
  final void Function({required bool isSleep}) onPickNightTime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Selector<FocusController, _ModesSectionData>(
      selector: (_, vm) => _ModesSectionData.fromVm(vm),
      builder: (context, data, _) {
        final salahLoading =
            modesInFlight.contains(FocusModeType.salah) ||
            isAuthorizingScreenTime;
        final nightLoading =
            modesInFlight.contains(FocusModeType.nightDiscipline) ||
            isAuthorizingScreenTime;
        final childLoading =
            modesInFlight.contains(FocusModeType.child) ||
            isAuthorizingScreenTime;
        return Column(
          children: [
            _ModeCard(
              marginBottom: 16,
              icon: Icons.shield_outlined,
              iconBackground: colorScheme.primary.withValues(alpha: 0.1),
              iconColor: colorScheme.primary,
              title: l10n.focusSalahFocusModeTitle,
              subtitle: l10n.focusBlockAppsDuringPrayer,
              value: data.salahMode,
              isLoading: salahLoading,
              onChanged: (value) => onToggleMode(FocusModeType.salah, value),
              child: data.salahMode
                  ? _ModeStatusBanner(
                      text: _salahBlockingDescription(l10n),
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
              value: data.nightMode,
              isLoading: nightLoading,
              onChanged: (value) =>
                  onToggleMode(FocusModeType.nightDiscipline, value),
              child: data.nightMode
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _NightTimePill(
                                label: l10n.focusSleepLabel,
                                timeText: formatTime(
                                  context,
                                  data.nightStartHour,
                                  data.nightStartMinute,
                                ),
                                onTap: () => onPickNightTime(isSleep: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _NightTimePill(
                                label: l10n.focusWakeLabel,
                                timeText: formatTime(
                                  context,
                                  data.nightEndHour,
                                  data.nightEndMinute,
                                ),
                                onTap: () => onPickNightTime(isSleep: false),
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
              value: data.childMode,
              isLoading: childLoading,
              onChanged: (value) => onToggleMode(FocusModeType.child, value),
              child: data.childMode
                  ? _ModeStatusBanner(
                      text: l10n.focusChildBlockingDescription,
                      color: colorScheme.error,
                    )
                  : null,
            ),
          ],
        );
      },
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
  const _AppsGrid({required this.onAppToggle});

  final Future<void> Function(FocusInstalledApp app) onAppToggle;
  static const int _maxRows = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Selector<FocusController, _AppsGridData>(
      selector: (_, vm) => _AppsGridData(
        isLoadingApps: vm.isLoadingApps,
        apps: vm.installedApps,
      ),
      builder: (context, data, _) {
        if (data.isLoadingApps) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
                Text(
                  l10n.focusLoadingInstalledApps,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        if (data.apps.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.focusNoInstalledAppsToShow,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
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
              itemCount: data.apps.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _maxRows,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 88,
              ),
              itemBuilder: (context, index) {
                final app = data.apps[index];
                return RepaintBoundary(
                  key: ValueKey<String>('focus-app-${app.packageName}'),
                  child: _GridAppTile(
                    app: app,
                    colorScheme: colorScheme,
                    onTap: onAppToggle,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _GridAppTile extends StatelessWidget {
  const _GridAppTile({
    required this.app,
    required this.colorScheme,
    required this.onTap,
  });

  final FocusInstalledApp app;
  final ColorScheme colorScheme;
  final Future<void> Function(FocusInstalledApp app) onTap;

  @override
  Widget build(BuildContext context) {
    final selected = context.select<FocusController, bool>(
      (vm) => vm.settings.selectedApps.containsKey(app.packageName),
    );
    final textStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w500);
    final selectedColor = colorScheme.primary.withValues(alpha: 0.15);
    final unselectedColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.5,
    );
    final selectedBorderColor = colorScheme.primary.withValues(alpha: 0.3);
    return InkWell(
      onTap: () => unawaited(onTap(app)),
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? selectedColor : unselectedColor,
          border: Border.all(
            color: selected ? selectedBorderColor : Colors.transparent,
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
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBannerData {
  const _TopBannerData({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _TopBannerData &&
        other.title == title &&
        other.detail == detail;
  }

  @override
  int get hashCode => Object.hash(title, detail);
}

class _SelectedAppsData {
  const _SelectedAppsData({
    required this.globalApps,
    required this.iconBytesByPackage,
    required this.isIosSelection,
    required this.iosSummary,
  });

  factory _SelectedAppsData.fromVm(FocusController vm) {
    final installedAppsByPackage = {
      for (final app in vm.installedApps) app.packageName: app,
    };
    final globalApps = vm.settings.selectedApps.entries
        .map(
          (entry) =>
              _SelectedAppChipData(packageName: entry.key, label: entry.value),
        )
        .toList(growable: false);
    final iconBytesByPackage = <String, Uint8List?>{
      for (final app in globalApps)
        app.packageName:
            installedAppsByPackage[app.packageName]?.iconBytes ??
            vm.settings.iconBytesForPackage(app.packageName),
    };
    final isIosSelection =
        defaultTargetPlatform == TargetPlatform.iOS &&
        vm.settings.iosSelectionCount > 0;
    return _SelectedAppsData(
      globalApps: globalApps,
      iconBytesByPackage: iconBytesByPackage,
      isIosSelection: isIosSelection,
      iosSummary: vm.selectedAppsSummary(),
    );
  }

  final List<_SelectedAppChipData> globalApps;
  final Map<String, Uint8List?> iconBytesByPackage;
  final bool isIosSelection;
  final String iosSummary;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _SelectedAppsData &&
        listEquals(other.globalApps, globalApps) &&
        mapEquals(other.iconBytesByPackage, iconBytesByPackage) &&
        other.isIosSelection == isIosSelection &&
        other.iosSummary == iosSummary;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(globalApps),
    Object.hashAll(iconBytesByPackage.entries),
    isIosSelection,
    iosSummary,
  );
}

class _SelectAppsRowData {
  const _SelectAppsRowData({
    required this.isLoadingApps,
    required this.isIos,
    required this.showGlobalSelector,
    required this.hasInstalledApps,
  });

  factory _SelectAppsRowData.fromVm({
    required FocusController vm,
    required bool showGlobalSelector,
  }) {
    return _SelectAppsRowData(
      isLoadingApps: vm.isLoadingApps,
      isIos: defaultTargetPlatform == TargetPlatform.iOS,
      showGlobalSelector: showGlobalSelector,
      hasInstalledApps: vm.installedApps.isNotEmpty,
    );
  }

  final bool isLoadingApps;
  final bool isIos;
  final bool showGlobalSelector;
  final bool hasInstalledApps;

  String actionLabel(AppLocalizations l10n) {
    if (isIos) return l10n.focusOpen;
    if (showGlobalSelector) return l10n.focusHide;
    return hasInstalledApps ? l10n.focusShow : l10n.focusLoad;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _SelectAppsRowData &&
        other.isLoadingApps == isLoadingApps &&
        other.isIos == isIos &&
        other.showGlobalSelector == showGlobalSelector &&
        other.hasInstalledApps == hasInstalledApps;
  }

  @override
  int get hashCode =>
      Object.hash(isLoadingApps, isIos, showGlobalSelector, hasInstalledApps);
}

class _ModesSectionData {
  const _ModesSectionData({
    required this.childMode,
    required this.salahMode,
    required this.nightMode,
    required this.nightStartHour,
    required this.nightStartMinute,
    required this.nightEndHour,
    required this.nightEndMinute,
  });

  factory _ModesSectionData.fromVm(FocusController vm) {
    final childMode = vm.settings.childModeEnabled;
    return _ModesSectionData(
      childMode: childMode,
      salahMode: vm.settings.salahModeEnabled && !childMode,
      nightMode: vm.settings.nightDisciplineEnabled && !childMode,
      nightStartHour: vm.settings.nightRange.startHour,
      nightStartMinute: vm.settings.nightRange.startMinute,
      nightEndHour: vm.settings.nightRange.endHour,
      nightEndMinute: vm.settings.nightRange.endMinute,
    );
  }

  final bool childMode;
  final bool salahMode;
  final bool nightMode;
  final int nightStartHour;
  final int nightStartMinute;
  final int nightEndHour;
  final int nightEndMinute;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _ModesSectionData &&
        other.childMode == childMode &&
        other.salahMode == salahMode &&
        other.nightMode == nightMode &&
        other.nightStartHour == nightStartHour &&
        other.nightStartMinute == nightStartMinute &&
        other.nightEndHour == nightEndHour &&
        other.nightEndMinute == nightEndMinute;
  }

  @override
  int get hashCode => Object.hash(
    childMode,
    salahMode,
    nightMode,
    nightStartHour,
    nightStartMinute,
    nightEndHour,
    nightEndMinute,
  );
}

class _AppsGridData {
  const _AppsGridData({required this.isLoadingApps, required this.apps});

  final bool isLoadingApps;
  final List<FocusInstalledApp> apps;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _AppsGridData &&
        other.isLoadingApps == isLoadingApps &&
        listEquals(other.apps, apps);
  }

  @override
  int get hashCode => Object.hash(isLoadingApps, Object.hashAll(apps));
}

class _SelectedAppChipData {
  const _SelectedAppChipData({required this.packageName, required this.label});

  final String packageName;
  final String label;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _SelectedAppChipData &&
        other.packageName == packageName &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(packageName, label);
}
