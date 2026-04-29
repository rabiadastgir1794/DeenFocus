import 'dart:async';
import 'dart:io';

import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../config/app_config.dart';

/// Event / placement identifiers registered in the Superwall dashboard.
abstract final class SuperwallPlacements {
  static const String changeUsername = 'change_username';
  static const String aboutDeenFocus = 'about_deen_focus';
  static const String premiumFeature = 'premium_feature';
}

class AppSuperwall {
  AppSuperwall._();

  static bool _enabled = false;
  static Future<void>? _configureFuture;

  static bool get isEnabled => _enabled;

  static Future<void> configureIfNeeded() async {
    if (_enabled) return;
    final inFlight = _configureFuture;
    if (inFlight != null) {
      await inFlight;
      return;
    }

    final key = _apiKeyForPlatform();
    if (key == null || key.isEmpty) return;

    final done = Completer<void>();
    _configureFuture = done.future;
    Superwall.configure(
      key,
      completion: () {
        _enabled = true;
        if (!done.isCompleted) done.complete();
      },
    );
    await _configureFuture;
  }

  static String? _apiKeyForPlatform() {
    if(Platform.isAndroid) return AppConfig.superwallApiKeyAndroid.trim();
    return AppConfig.superwallApiKeyIOS.trim();
  }

  /// Presents a paywall when configured in Superwall for [placement], then
  /// runs [onAccess] if the user is allowed to use the feature.
  static Future<void> registerPlacement(
    String placement,
    void Function() onAccess, {
    bool fallbackToAccessWhenNoPaywall = false,
    Duration fallbackTimeout = const Duration(seconds: 2),
  }) async {
    if (!isEnabled) {
      onAccess();
      return;
    }
    var didGrantAccess = false;

    void grantAccessOnce() {
      if (didGrantAccess) return;
      didGrantAccess = true;
      onAccess();
    }

    Future<void> grantFallbackIfNeeded() async {
      if (!fallbackToAccessWhenNoPaywall || didGrantAccess) return;
      final isPaywallPresented = await Superwall.shared.getIsPaywallPresented();
      if (!isPaywallPresented) {
        grantAccessOnce();
      }
    }

    try {
      await Superwall.shared
          .registerPlacement(placement, feature: grantAccessOnce)
          .timeout(fallbackTimeout);
    } on TimeoutException {
      await grantFallbackIfNeeded();
      return;
    } catch (_) {
      await grantFallbackIfNeeded();
      rethrow;
    }

    await grantFallbackIfNeeded();
  }

  /// Triggers [placement] and waits until a paywall is presented.
  /// Throws when presentation fails or takes too long.
  static Future<void> verifyPlacementPaywall(
    String placement, {
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (!isEnabled) {
      throw StateError('Superwall is not configured.');
    }

    final presented = Completer<void>();
    final handler = PaywallPresentationHandler()
      ..onPresent((_) {
        if (!presented.isCompleted) presented.complete();
      })
      ..onError((error) {
        if (!presented.isCompleted) {
          presented.completeError(StateError(error));
        }
      });

    unawaited(
      Superwall.shared
          .registerPlacement(placement, handler: handler, feature: () {})
          .catchError((Object error) {
        if (!presented.isCompleted) {
          presented.completeError(error);
        }
      }),
    );

    await presented.future.timeout(
      timeout,
      onTimeout: () => throw TimeoutException('Failed to verify subscription.'),
    );
  }
}
