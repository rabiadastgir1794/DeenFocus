import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/services/app_notification_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/prayer_alarm_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../core/widgets/app_permission_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../services/prayer_settings_service.dart';

/// Global Prayer Alarms settings (master switch, snooze, per-prayer toggles).
///
/// Enabling always runs the platform permission flow first. If required alarm
/// authorization is denied, the master switch is turned back off.
class SettingsPrayerAlarmsScreen extends StatefulWidget {
  const SettingsPrayerAlarmsScreen({super.key});

  @override
  State<SettingsPrayerAlarmsScreen> createState() =>
      _SettingsPrayerAlarmsScreenState();
}

class _SettingsPrayerAlarmsScreenState extends State<SettingsPrayerAlarmsScreen>
    with WidgetsBindingObserver {
  bool _loading = true;
  bool _busy = false;
  bool _enabled = false;
  bool _awaitingPermissionResult = false;
  int _snoozeMinutes = StorageService.defaultPrayerAlarmSnoozeMinutes;
  PrayerAlarmCapabilities? _capabilities;
  PrayerAlarmAuthorizationStatus _auth =
      PrayerAlarmAuthorizationStatus.unavailable;
  bool? _canUseFsi;

  bool get _nativeSupported => _capabilities?.supportsNativeAlarm == true;

  bool get _schedulingAuthorized =>
      _auth == PrayerAlarmAuthorizationStatus.authorized;

  /// Switch reflects preference only when scheduling is actually allowed
  /// (or native alarms are unavailable and we keep the soft-notification path).
  bool get _switchValue {
    if (!_enabled) return false;
    if (!_nativeSupported) return true;
    return _schedulingAuthorized;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshPermissionState(rescheduleIfReady: true));
    }
  }

  Future<void> _load() async {
    final prayerSettings = context.read<PrayerSettingsService>();
    final enabled = await StorageService.prayerAlarmsEnabled;
    final snooze = await StorageService.prayerAlarmSnoozeMinutes;
    // Same in-memory + disk cache as Home prayer sheets.
    await prayerSettings.reload();
    final capabilities = await PrayerAlarmService.instance.getCapabilities(
      forceRefresh: true,
    );
    final auth = await PrayerAlarmService.instance.getAuthorizationStatus();
    final fsi = Platform.isAndroid
        ? await PrayerAlarmService.instance.canUseFullScreenIntent()
        : null;

    // Stored ON but permission revoked → treat as OFF so UI isn't misleading.
    var effectiveEnabled = enabled;
    if (enabled &&
        capabilities.supportsNativeAlarm &&
        auth != PrayerAlarmAuthorizationStatus.authorized) {
      effectiveEnabled = false;
      await StorageService.setPrayerAlarmsEnabled(false);
      await PrayerAlarmService.instance.cancelAll();
    }

    if (!mounted) return;
    setState(() {
      _enabled = effectiveEnabled;
      _snoozeMinutes = snooze;
      _capabilities = capabilities;
      _auth = auth;
      _canUseFsi = fsi;
      _loading = false;
    });
  }

  Future<void> _refreshPermissionState({bool rescheduleIfReady = false}) async {
    final capabilities = await PrayerAlarmService.instance.getCapabilities(
      forceRefresh: true,
    );
    final auth = await PrayerAlarmService.instance.getAuthorizationStatus();
    final fsi = Platform.isAndroid
        ? await PrayerAlarmService.instance.canUseFullScreenIntent()
        : null;
    if (!mounted) return;

    final stored = await StorageService.prayerAlarmsEnabled;
    var enabled = stored;
    final wasAwaiting = _awaitingPermissionResult;
    var showDenied = false;

    if (stored &&
        capabilities.supportsNativeAlarm &&
        auth == PrayerAlarmAuthorizationStatus.authorized) {
      enabled = true;
    } else if (stored &&
        capabilities.supportsNativeAlarm &&
        auth != PrayerAlarmAuthorizationStatus.authorized) {
      // Preference was ON but permission still missing after Settings.
      enabled = false;
      showDenied = wasAwaiting;
      await StorageService.setPrayerAlarmsEnabled(false);
      await PrayerAlarmService.instance.cancelAll();
    }

    setState(() {
      _capabilities = capabilities;
      _auth = auth;
      _canUseFsi = fsi;
      _enabled = enabled;
      _awaitingPermissionResult = false;
    });

    if (rescheduleIfReady && enabled) {
      await _reschedule();
    }
    if (showDenied && mounted) {
      await _showDeniedDialog();
    }
  }

  Future<void> _rescheduleSoftOnly() async {
    final profile = context.read<UserProfileService>();
    final lat = profile.latitude;
    final lng = profile.longitude;
    if (lat == null || lng == null) return;
    await AppNotificationService.instance.reschedulePrayerNotifications(
      latitude: lat,
      longitude: lng,
      forceReschedule: true,
    );
  }

  Future<void> _reschedule() async {
    final profile = context.read<UserProfileService>();
    final lat = profile.latitude;
    final lng = profile.longitude;
    if (lat == null || lng == null) return;
    final l10n = AppLocalizations.of(context);
    // Soft first so Adhan ownership (mute when native owns sound) is current.
    await AppNotificationService.instance.reschedulePrayerNotifications(
      latitude: lat,
      longitude: lng,
      forceReschedule: true,
    );
    await PrayerAlarmService.instance.rescheduleAlarms(
      latitude: lat,
      longitude: lng,
      forceReschedule: true,
      localizations: l10n,
    );
  }

  Future<void> _setEnabled(bool value) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (!value) {
        setState(() {
          _enabled = false;
          _awaitingPermissionResult = false;
        });
        await StorageService.setPrayerAlarmsEnabled(false);
        await PrayerAlarmService.instance.cancelAll();
        // Restore soft Adhan/beep now that native no longer owns sound.
        await _rescheduleSoftOnly();
        return;
      }

      // Soft notifications power the Android alarm presentation path.
      if (Platform.isAndroid) {
        final notificationsOk = await PermissionService.requestNotification();
        if (!notificationsOk) {
          await StorageService.setPrayerAlarmsEnabled(false);
          await PrayerAlarmService.instance.cancelAll();
          if (!mounted) return;
          setState(() => _enabled = false);
          await _showNotificationDeniedDialog();
          return;
        }
      }

      // Persist intent so returning from Settings can complete enablement.
      await StorageService.setPrayerAlarmsEnabled(true);

      final capabilities = await PrayerAlarmService.instance.getCapabilities(
        forceRefresh: true,
      );
      if (!capabilities.supportsNativeAlarm) {
        setState(() {
          _enabled = true;
          _capabilities = capabilities;
        });
        await PrayerAlarmService.instance.cancelAll();
        return;
      }

      var auth = await PrayerAlarmService.instance.getAuthorizationStatus();
      var requested = auth;
      if (auth != PrayerAlarmAuthorizationStatus.authorized) {
        requested = await PrayerAlarmService.instance.requestAuthorization();
      }

      // Re-read after iOS system sheet. On Android, Settings may still be open
      // (request returns notDetermined) — complete on resume.
      auth = await PrayerAlarmService.instance.getAuthorizationStatus();
      if (requested == PrayerAlarmAuthorizationStatus.authorized) {
        auth = PrayerAlarmAuthorizationStatus.authorized;
      }
      final fsi = Platform.isAndroid
          ? await PrayerAlarmService.instance.canUseFullScreenIntent()
          : null;

      if (!mounted) return;

      if (auth == PrayerAlarmAuthorizationStatus.authorized) {
        setState(() {
          _enabled = true;
          _auth = auth;
          _capabilities = capabilities;
          _canUseFsi = fsi;
        });
        await _reschedule();
        if (Platform.isAndroid && fsi == false && mounted) {
          await _showFsiOptionalDialog();
        }
        return;
      }

      if (requested == PrayerAlarmAuthorizationStatus.notDetermined) {
        // Waiting on system Settings — keep intent in storage; switch stays off
        // until authorization is confirmed on resume.
        setState(() {
          _enabled = true;
          _auth = auth;
          _capabilities = capabilities;
          _canUseFsi = fsi;
          _awaitingPermissionResult = true;
        });
        return;
      }

      await StorageService.setPrayerAlarmsEnabled(false);
      await PrayerAlarmService.instance.cancelAll();
      setState(() {
        _enabled = false;
        _auth = auth;
        _capabilities = capabilities;
        _canUseFsi = fsi;
      });
      await _showDeniedDialog();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showDeniedDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.prayerAlarmsDeniedTitle,
      message: l10n.prayerAlarmsDeniedMessage,
      primaryButtonText: l10n.prayerAlarmsOpenSettings,
      secondaryButtonText: l10n.prayerAlarmsCancel,
      onPrimaryTap: () {
        unawaited(() async {
          if (Platform.isAndroid) {
            final notificationsOk = await PermissionService.checkNotification();
            if (!notificationsOk) {
              await PermissionService.openAppSettingsAsync();
            } else {
              await PrayerAlarmService.instance.openExactAlarmSettings();
            }
          } else {
            await PermissionService.openAppSettingsAsync();
          }
        }());
      },
      onSecondaryTap: () {},
    );
  }

  Future<void> _showNotificationDeniedDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.prayerAlarmsDeniedTitle,
      message: l10n.prayerAlarmsDeniedMessage,
      primaryButtonText: l10n.prayerAlarmsOpenSettings,
      secondaryButtonText: l10n.prayerAlarmsCancel,
      onPrimaryTap: () {
        unawaited(PermissionService.openAppSettingsAsync());
      },
      onSecondaryTap: () {},
    );
  }

  Future<void> _showFsiOptionalDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.prayerAlarmsFsiButton,
      message: l10n.prayerAlarmsFsiNeeded,
      primaryButtonText: l10n.prayerAlarmsOpenSettings,
      secondaryButtonText: l10n.prayerAlarmsCancel,
      onPrimaryTap: () {
        unawaited(PrayerAlarmService.instance.openFullScreenIntentSettings());
      },
      onSecondaryTap: () {},
    );
  }

  Future<void> _requestAlarmPermissionAgain() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await StorageService.setPrayerAlarmsEnabled(true);
      final requested = await PrayerAlarmService.instance
          .requestAuthorization();
      var auth = await PrayerAlarmService.instance.getAuthorizationStatus();
      if (requested == PrayerAlarmAuthorizationStatus.authorized) {
        auth = PrayerAlarmAuthorizationStatus.authorized;
      }
      if (!mounted) return;
      if (auth == PrayerAlarmAuthorizationStatus.authorized) {
        setState(() {
          _enabled = true;
          _auth = auth;
        });
        await _reschedule();
        return;
      }
      if (requested == PrayerAlarmAuthorizationStatus.notDetermined) {
        setState(() {
          _enabled = true;
          _auth = auth;
          _awaitingPermissionResult = true;
        });
        return;
      }
      await StorageService.setPrayerAlarmsEnabled(false);
      await PrayerAlarmService.instance.cancelAll();
      setState(() {
        _enabled = false;
        _auth = auth;
        _awaitingPermissionResult = false;
      });
      await _showDeniedDialog();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setSnooze(int minutes) async {
    setState(() => _snoozeMinutes = minutes);
    await StorageService.setPrayerAlarmSnoozeMinutes(minutes);
    if (_switchValue) await _reschedule();
  }

  Future<void> _setPrayerAlarm(TrackablePrayer prayer, bool enabled) async {
    final prayerSettings = context.read<PrayerSettingsService>();
    await prayerSettings.setAlertingEnabled(prayer, enabled);
    // Soft always: mirrors home sheet and keeps Adhan ownership correct.
    // Native only when master switch can schedule.
    if (_switchValue) {
      await _reschedule();
    } else {
      await _rescheduleSoftOnly();
    }
  }

  String _statusText(AppLocalizations l10n) {
    if (!_nativeSupported) return l10n.prayerAlarmsStatusFallback;
    if (!_switchValue) {
      if (_auth != PrayerAlarmAuthorizationStatus.authorized) {
        return l10n.prayerAlarmsStatusNeedsPermission;
      }
      return l10n.prayerAlarmsMasterSubtitle;
    }
    if (Platform.isAndroid && _canUseFsi == false) {
      return l10n.prayerAlarmsStatusFsiOptional;
    }
    return l10n.prayerAlarmsStatusReady;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final prayerSettings = context.watch<PrayerSettingsService>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.settingsPrayerAlarmsTitle,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        Spacing.md.toDouble(),
                        Spacing.sm.toDouble() + 4,
                        Spacing.md.toDouble(),
                        Spacing.xl.toDouble(),
                      ),
                      children: [
                        Text(
                          l10n.settingsPrayerAlarmsSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                        ),
                        SizedBox(height: Spacing.md.toDouble()),
                        _StatusChip(
                          text: _statusText(l10n),
                          ok:
                              _switchValue &&
                              (_canUseFsi != false || !Platform.isAndroid),
                        ),
                        SizedBox(height: Spacing.md.toDouble()),
                        _SettingsCard(
                          borderColor: borderColor,
                          child: SwitchListTile.adaptive(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              l10n.prayerAlarmsMasterLabel,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(l10n.prayerAlarmsMasterSubtitle),
                            value: _switchValue,
                            onChanged: _busy
                                ? null
                                : (value) => unawaited(_setEnabled(value)),
                          ),
                        ),
                        if (_capabilities?.usesNotificationFallback ==
                            true) ...[
                          SizedBox(height: Spacing.sm.toDouble() + 4),
                          _InfoBanner(
                            text: Platform.isIOS
                                ? l10n.prayerAlarmsIosFallback
                                : l10n.prayerAlarmsUnsupported,
                          ),
                        ],
                        if (_nativeSupported && !_schedulingAuthorized) ...[
                          SizedBox(height: Spacing.sm.toDouble() + 4),
                          _InfoBanner(
                            text: l10n.prayerAlarmsPermissionNeeded,
                            actionLabel: l10n.prayerAlarmsPermissionButton,
                            onAction: _requestAlarmPermissionAgain,
                          ),
                        ],
                        if (_switchValue &&
                            Platform.isAndroid &&
                            _canUseFsi == false) ...[
                          SizedBox(height: Spacing.sm.toDouble() + 4),
                          _InfoBanner(
                            text: l10n.prayerAlarmsFsiNeeded,
                            actionLabel: l10n.prayerAlarmsFsiButton,
                            onAction: () async {
                              await PrayerAlarmService.instance
                                  .openFullScreenIntentSettings();
                            },
                          ),
                        ],
                        SizedBox(height: Spacing.lg.toDouble()),
                        Text(
                          l10n.prayerAlarmsSnoozeLabel,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: Spacing.sm.toDouble()),
                        _SettingsCard(
                          borderColor: borderColor,
                          child: Column(
                            children: [
                              for (final minutes
                                  in StorageService
                                      .prayerAlarmSnoozeOptionMinutes)
                                ListTile(
                                  enabled: _switchValue && !_busy,
                                  title: Text(
                                    l10n.prayerAlarmsSnoozeMinutes(minutes),
                                  ),
                                  trailing: Icon(
                                    _snoozeMinutes == minutes
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: _snoozeMinutes == minutes
                                        ? colorScheme.primary
                                        : colorScheme.outline,
                                  ),
                                  onTap: !_switchValue || _busy
                                      ? null
                                      : () => unawaited(_setSnooze(minutes)),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: Spacing.lg.toDouble()),
                        Text(
                          l10n.prayerAlarmsPerPrayerSection,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: Spacing.sm.toDouble()),
                        _SettingsCard(
                          borderColor: borderColor,
                          child: Column(
                            children: [
                              for (final prayer in TrackablePrayer.values) ...[
                                SwitchListTile.adaptive(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 2,
                                  ),
                                  title: Text(prayer.label(l10n)),
                                  subtitle: Text(
                                    l10n.homePrayerAlarmEnableSubtitle(
                                      prayer.label(l10n),
                                    ),
                                  ),
                                  value: prayerSettings
                                      .forPrayer(prayer)
                                      .alarmEnabled,
                                  onChanged: !_switchValue || _busy
                                      ? null
                                      : (value) => unawaited(
                                          _setPrayerAlarm(prayer, value),
                                        ),
                                ),
                                if (prayer != TrackablePrayer.isha)
                                  Divider(
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.35),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child, required this.borderColor});

  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.text, required this.ok});

  final String text;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = ok
        ? colorScheme.primary.withValues(alpha: 0.12)
        : colorScheme.errorContainer.withValues(alpha: 0.55);
    final fg = ok ? colorScheme.primary : colorScheme.onErrorContainer;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            size: 18,
            color: fg,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final Future<void> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => unawaited(onAction!()),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
