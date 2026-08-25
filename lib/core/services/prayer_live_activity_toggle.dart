import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/app_permission_dialog.dart';
import 'permission_service.dart';
import 'prayer_live_activity_service.dart';

/// Outcome of [PrayerLiveActivityToggle.apply] before any UI is shown.
enum PrayerLiveActivityToggleResult {
  success,
  unsupported,
  notificationPermissionDenied,
  osActivitiesDisabled,
}

/// Shared enable/disable path for Settings and App Demo (permissions + OS checks).
abstract final class PrayerLiveActivityToggle {
  /// Applies [enabled] using the same gates as Settings → Live Activity.
  static Future<PrayerLiveActivityToggleResult> apply(bool enabled) async {
    if (enabled) {
      final caps =
          await PrayerLiveActivityService.instance.getCapabilities();
      if (caps['supportsLiveActivity'] != true) {
        return PrayerLiveActivityToggleResult.unsupported;
      }

      final notified = await PermissionService.requestNotification();
      if (!notified) {
        return PrayerLiveActivityToggleResult.notificationPermissionDenied;
      }

      if (!kIsWeb && Platform.isIOS) {
        final activitiesOn =
            await PrayerLiveActivityService.instance.areActivitiesEnabled();
        if (!activitiesOn) {
          return PrayerLiveActivityToggleResult.osActivitiesDisabled;
        }
      }
    }

    await PrayerLiveActivityService.instance.setEnabled(enabled);
    return PrayerLiveActivityToggleResult.success;
  }

  /// Runs [apply] and shows the standard permission / unsupported dialogs.
  /// Returns whether the preference was updated.
  static Future<bool> applyWithDialogs(
    BuildContext context, {
    required bool enabled,
  }) async {
    final result = await apply(enabled);
    if (!context.mounted) return false;
    if (result == PrayerLiveActivityToggleResult.success) {
      if (enabled) {
        await _showEnabledSuccessDialog(context);
      }
      return true;
    }

    final l10n = AppLocalizations.of(context)!;
    switch (result) {
      case PrayerLiveActivityToggleResult.success:
        return true;
      case PrayerLiveActivityToggleResult.unsupported:
        await AppPermissionDialog.show(
          context,
          title: l10n.liveActivityUnsupported,
          message: l10n.liveActivityStayUpdatedBody,
          primaryButtonText: l10n.featureDemoContinue,
          onPrimaryTap: () {},
        );
        return false;
      case PrayerLiveActivityToggleResult.notificationPermissionDenied:
        await AppPermissionDialog.show(
          context,
          title: l10n.liveActivityPermissionNeeded,
          message: l10n.liveActivityStayUpdatedBody,
          primaryButtonText: l10n.liveActivityPermissionButton,
          secondaryButtonText: l10n.liveActivityPromptNotNow,
          onPrimaryTap: () {
            unawaited(PermissionService.openAppSettingsAsync());
          },
        );
        return false;
      case PrayerLiveActivityToggleResult.osActivitiesDisabled:
        await AppPermissionDialog.show(
          context,
          title: l10n.liveActivityUnsupported,
          message: l10n.liveActivityStayUpdatedBody,
          primaryButtonText: l10n.liveActivityPermissionButton,
          secondaryButtonText: l10n.liveActivityPromptNotNow,
          onPrimaryTap: () {
            unawaited(PermissionService.openAppSettingsAsync());
          },
        );
        return false;
    }
  }

  static Future<void> _showEnabledSuccessDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final body = !kIsWeb && Platform.isAndroid
        ? l10n.liveActivityEnabledPromptBodyAndroid
        : l10n.liveActivityEnabledPromptBodyIos;
    await AppPermissionDialog.show(
      context,
      title: l10n.liveActivityEnabledPromptTitle,
      message: body,
      primaryButtonText: l10n.liveActivityEnabledPromptButton,
      onPrimaryTap: () {},
    );
  }
}
