import 'dart:async';
import 'dart:io';

import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../config/app_config.dart';
import '../services/storage_service.dart';

/// Event / placement identifiers registered in the Superwall dashboard.
abstract final class SuperwallPlacements {
  static const String changeUsername = 'change_username';
  static const String aboutDeenFocus = 'about_deen_focus';
  static const String premiumFeature = 'premium_feature';
  static const String firstTimeOfferWall = 'first_time_offer_wall';
}

class AppSuperwall {
  AppSuperwall._();

  static bool _enabled = false;
  static Future<void>? _configureFuture;

  static bool get isEnabled => _enabled;

  static const String _userAttrIsSubscribed = 'isSubscribed';
  static const String _userAttrHasUsedIntroOffer = 'hasUsedIntroOffer';

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

  /// Ensures Superwall attributes are up to date and resolves the wall that
  /// must be registered for the current user state.
  static Future<String> syncAttributesAndResolvePaywallRoute({
    bool? isSubscribed,
  }) async {
    var resolvedIsSubscribed = isSubscribed ?? false;
    if (isSubscribed == null && isEnabled) {
      try {
        final status = await Superwall.shared.getSubscriptionStatus();
        resolvedIsSubscribed = status.isActive;
      } catch (_) {
        resolvedIsSubscribed = false;
      }
    }

    var hasUsedIntroOffer = await StorageService.hasUsedIntroOffer;
    if (resolvedIsSubscribed && !hasUsedIntroOffer) {
      // Any completed subscription means this user has consumed their
      // first-time path and should always be routed to premium features.
      hasUsedIntroOffer = true;
      await StorageService.setHasUsedIntroOffer(true);
    }

    final routeToFirstTimeOffer = !resolvedIsSubscribed && !hasUsedIntroOffer;
    final attributes = <String, Object>{
      _userAttrIsSubscribed: resolvedIsSubscribed,
      _userAttrHasUsedIntroOffer: routeToFirstTimeOffer ? false : true,
    };
    await Superwall.shared.setUserAttributes(attributes);

    return routeToFirstTimeOffer
        ? SuperwallPlacements.firstTimeOfferWall
        : SuperwallPlacements.premiumFeature;
  }

  /// Call this from Billing listeners when trial/intro/subscription starts.
  static Future<void> markHasUsedIntroOffer() async {
    await StorageService.setHasUsedIntroOffer(true);
    if (!isEnabled) return;
    await syncAttributesAndResolvePaywallRoute();
  }

  static Future<void> onTrialStarted() => markHasUsedIntroOffer();

  static Future<void> onIntroOfferPurchased() => markHasUsedIntroOffer();

  static Future<void> onSubscriptionPurchased() => markHasUsedIntroOffer();

  static String? _apiKeyForPlatform() {
    if (Platform.isAndroid) return AppConfig.superwallApiKeyAndroid.trim();
    return AppConfig.superwallApiKeyIOS.trim();
  }

  /// Presents a paywall when configured in Superwall for [placement], then
  /// runs [onAccess] if the user is allowed to use the feature.
  static Future<void> registerPlacement(
    String _,
    void Function() onAccess, {
    bool fallbackToAccessWhenNoPaywall = false,
    Duration fallbackTimeout = const Duration(seconds: 2),
  }) async {
    if (!isEnabled) {
      onAccess();
      return;
    }
    final routedPlacement = await syncAttributesAndResolvePaywallRoute();
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
          .registerPlacement(
            routedPlacement,
            feature: grantAccessOnce,
          )
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
    String _, {
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (!isEnabled) {
      throw StateError('Superwall is not configured.');
    }
    final routedPlacement = await syncAttributesAndResolvePaywallRoute();

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
          .registerPlacement(
            routedPlacement,
            handler: handler,
            feature: () {},
          )
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
