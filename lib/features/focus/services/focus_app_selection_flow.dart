import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/superwall/premium_gate.dart';
import '../../../l10n/app_localizations.dart';
import '../view/focus_apps_picker_sheet.dart';
import '../viewmodel/focus_controller.dart';

/// Opens the same app-selection experience used by Focus Mode.
///
/// * iOS → system FamilyActivityPicker via [FocusController.requestInstalledApps]
/// * Android → modal sheet with [FocusAppsPickerSheet] / [FocusAppsGrid]
///
/// All selections persist through [FocusController] (`focus_settings_json`), so
/// onboarding and the Focus tab stay synchronized.
class FocusAppSelectionFlow {
  FocusAppSelectionFlow._();

  /// Presents the picker. Returns after the user dismisses it (or cancels auth).
  static Future<void> open({
    required BuildContext context,
    bool requirePremium = true,
    bool requireAccessibilityDisclosure = true,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<FocusController>();
    final messenger = ScaffoldMessenger.maybeOf(context);

    if (defaultTargetPlatform == TargetPlatform.iOS || Platform.isIOS) {
      final authResult =
          await PermissionService.requestScreenTimeAccessDetailed();
      if (!context.mounted) return;
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

      Future<void> openIosPicker() async {
        if (!context.mounted) return;
        await controller.requestInstalledApps();
      }

      if (requirePremium) {
        await PremiumGate.presentIfNeeded(
          context: context,
          onAccess: () => unawaited(openIosPicker()),
          debugContext: 'focus:load_apps',
        );
      } else {
        await openIosPicker();
      }
      return;
    }

    if (requireAccessibilityDisclosure) {
      final accepted = await _ensureAccessibilityDisclosureAccepted(context);
      if (!accepted) {
        if (context.mounted) {
          messenger?.showSnackBar(
            SnackBar(content: Text(l10n.focusAcceptAccessibilityDisclosure)),
          );
        }
        return;
      }
    }
    if (!context.mounted) return;

    Future<void> openAndroidPicker() async {
      if (!context.mounted) return;
      await controller.requestInstalledApps();
      if (!context.mounted) return;
      await FocusAppsPickerSheet.show(context);
    }

    if (requirePremium) {
      await PremiumGate.presentIfNeeded(
        context: context,
        onAccess: () => unawaited(openAndroidPicker()),
        debugContext: 'focus:load_apps',
      );
    } else {
      await openAndroidPicker();
    }
  }

  static Future<bool> _ensureAccessibilityDisclosureAccepted(
    BuildContext context,
  ) async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    final l10n = AppLocalizations.of(context)!;
    final accepted = await StorageService.focusAccessibilityDisclosureAccepted;
    if (accepted) return true;
    if (!context.mounted) return false;

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
}
