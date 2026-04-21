import 'dart:async';
import 'dart:io';

import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../config/app_config.dart';

/// Event / placement identifiers registered in the Superwall dashboard.
abstract final class SuperwallPlacements {
  static const String changeUsername = 'change_username';
  static const String aboutDeenFocus = 'about_deen_focus';
}

class AppSuperwall {
  AppSuperwall._();

  static bool _enabled = false;

  static bool get isEnabled => _enabled;

  static Future<void> configureIfNeeded() async {
    final key = _apiKeyForPlatform();
    if (key == null || key.isEmpty) return;

    final done = Completer<void>();
    Superwall.configure(
      key,
      completion: () {
        _enabled = true;
        if (!done.isCompleted) done.complete();
      },
    );
    await done.future;
  }

  static String? _apiKeyForPlatform() {
    return AppConfig.superwallApiKey.trim();
  }

  /// Presents a paywall when configured in Superwall for [placement], then
  /// runs [onAccess] if the user is allowed to use the feature.
  static Future<void> registerPlacement(
    String placement,
    void Function() onAccess,
  ) async {
    if (!isEnabled) {
      onAccess();
      return;
    }
    await Superwall.shared.registerPlacement(placement, feature: onAccess);
  }
}
