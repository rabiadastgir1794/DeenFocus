import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../core/services/focus_enforcement_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/widgets/app_permission_dialog.dart';
import '../../../core/widgets/focus_app_icon.dart';
import '../model/focus_models.dart';
import '../viewmodel/focus_controller.dart';

class FocusTabScreen extends StatefulWidget {
  const FocusTabScreen({super.key});

  @override
  State<FocusTabScreen> createState() => _FocusTabScreenState();
}

class _FocusTabScreenState extends State<FocusTabScreen>
    with WidgetsBindingObserver {
  bool _showGlobalSelector = false;
  FocusModeType? _pendingModeToEnable;
  bool _awaitingBlockingPermission = false;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusController>(
      builder: (context, vm, _) {
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

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Focus',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Protect your spiritual moments',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (childActive)
                    _ChildModeBanner(
                      countLabel: vm.selectedTargetPhrase,
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
                                    'Apps to Block',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Applies to all focus modes',
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
                            final messenger = ScaffoldMessenger.maybeOf(
                              context,
                            );
                            if (defaultTargetPlatform == TargetPlatform.iOS) {
                              final authResult =
                                  await PermissionService.requestScreenTimeAccessDetailed();
                              if (!mounted) return;
                              if (!authResult.granted) {
                                messenger?.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authResult.userFacingMessage() ??
                                          'Screen Time access is required to view and select apps.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              await vm.requestInstalledApps();
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
                                    'Select apps to block',
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
                                    child: const Row(
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
                                        Text('Loading...'),
                                      ],
                                    ),
                                  )
                                else
                                  Text(
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? 'Open'
                                        : _showGlobalSelector
                                        ? 'Hide'
                                        : vm.installedApps.isEmpty
                                        ? 'Load'
                                        : 'Show',
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
                        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
                          const SizedBox(height: 12),
                          Text(
                            'On iOS, Apple shows a native Screen Time picker. The app receives opaque tokens and a selected item count for apps, categories, and websites, not a normal installed-app name list.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ] else if (_showGlobalSelector) ...[
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
                    title: 'Salah Focus Mode',
                    subtitle: 'Block apps during prayer',
                    value: salahMode,
                    isLoading: _modesInFlight.contains(FocusModeType.salah),
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.salah, value),
                    child: salahMode
                        ? _ModeFooterText(
                            text:
                                '✓ ${vm.selectedTargetPhrase} will be blocked during prayer times',
                            color: colorScheme.primary,
                          )
                        : null,
                  ),
                  _ModeCard(
                    marginBottom: 16,
                    icon: Icons.nights_stay,
                    iconBackground: colorScheme.primary.withValues(alpha: 0.2),
                    iconColor: colorScheme.primary,
                    title: 'Night Discipline',
                    subtitle: 'Protect sleep & Fajr',
                    value: nightMode,
                    isLoading: _modesInFlight.contains(
                      FocusModeType.nightDiscipline,
                    ),
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
                                      label: 'Sleep',
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
                                      label: 'Wake',
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
                              _ModeFooterText(
                                text:
                                    '✓ ${globalApps.length} app${globalApps.length != 1 ? 's' : ''} will be blocked at night',
                                color: colorScheme.primary,
                              ),
                            ],
                          )
                        : null,
                  ),
                  _ModeCard(
                    icon: Icons.child_care_outlined,
                    iconBackground: colorScheme.error.withValues(alpha: 0.1),
                    iconColor: colorScheme.error,
                    title: 'Child Mode',
                    subtitle: 'Block apps immediately',
                    value: childMode,
                    isLoading: _modesInFlight.contains(FocusModeType.child),
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.child, value),
                    child: childMode
                        ? _ModeFooterText(
                            text:
                                '⚠ ${vm.selectedTargetPhrase} blocked immediately',
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
      title: 'Enable Android app blocking',
      message:
          'To block other apps on Android, Deenly needs its accessibility permission turned on. We will open the correct settings screen for you.',
      onPrimaryTap: () {
        FocusEnforcementService.openBlockingPermissionSettings();
      },
    );
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
          final authResult =
              await PermissionService.requestScreenTimeAccessDetailed();
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
      if (mounted) {
        setState(() => _modesInFlight.remove(mode));
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

  Future<void> _pickNightTime(FocusController vm, {required bool isSleep}) async {
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
    var selected = DateTime(
      2020,
      1,
      1,
      initialTime.hour,
      initialTime.minute,
    );

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
                        child: const Text('Cancel'),
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
                        child: const Text('Done'),
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

class _ChildModeBanner extends StatelessWidget {
  const _ChildModeBanner({required this.countLabel, required this.colorScheme});

  final String countLabel;
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
                  'Child Mode Active',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '$countLabel blocked immediately',
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
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
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
                      : Switch(
                          value: value,
                          onChanged: onChanged,
                        ),
                ),
              ),
            ],
          ),
          if (isLoading) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 3,
                width: double.infinity,
                child: LinearProgressIndicator(
                  backgroundColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
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

class _ModeFooterText extends StatelessWidget {
  const _ModeFooterText({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.w500,
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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

    final maxHeight = MediaQuery.sizeOf(context).height * 0.56;
    return SizedBox(
      height: maxHeight.clamp(260.0, 500.0),
      child: GridView.builder(
        itemCount: apps.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.82,
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
    );
  }
}

class _SelectedAppChipData {
  const _SelectedAppChipData({required this.packageName, required this.label});

  final String packageName;
  final String label;
}
