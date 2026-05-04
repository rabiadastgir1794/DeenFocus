import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

  /// Mirrors the last known Superwall subscription state for UI (settings, etc.).
  static final ValueNotifier<bool> subscriptionActiveNotifier =
      ValueNotifier<bool>(false);

  static void _setSubscriptionActiveNotifier(bool isActive) {
    if (subscriptionActiveNotifier.value != isActive) {
      subscriptionActiveNotifier.value = isActive;
    }
  }

  /// Keeps [subscriptionActiveNotifier] aligned when code reads the store directly.
  static void updateSubscriptionNotifierFromStore(bool isActive) {
    _setSubscriptionActiveNotifier(isActive);
  }

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
  ///
  /// [isSubscribed] is returned for callers that must bypass paywall logic when
  /// the store already shows an active entitlement (dashboard rules often omit
  /// subscribers, which yields `no_rule_match` and no `feature` callback).
  static Future<({String placement, bool isSubscribed})>
      syncAttributesAndResolvePaywallRoute({
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

    final placement = routeToFirstTimeOffer
        ? SuperwallPlacements.firstTimeOfferWall
        : SuperwallPlacements.premiumFeature;
    _setSubscriptionActiveNotifier(resolvedIsSubscribed);
    return (placement: placement, isSubscribed: resolvedIsSubscribed);
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

  /// Calls [onAccess] at most once when [syncAttributesAndResolvePaywallRoute]
  /// reports an active subscription. Retries help when status lags right after
  /// purchase ([attempts], [delayBetween]).
  static Future<void> _grantOnAccessIfSubscribed(
    void Function() onAccess, {
    required bool Function() alreadyDelivered,
    required void Function() markDelivered,
    int attempts = 1,
    Duration delayBetween = Duration.zero,
  }) async {
    for (var i = 0; i < attempts; i++) {
      if (alreadyDelivered()) return;
      final after = await syncAttributesAndResolvePaywallRoute();
      if (after.isSubscribed) {
        if (alreadyDelivered()) return;
        markDelivered();
        onAccess();
        return;
      }
      if (i + 1 < attempts && delayBetween > Duration.zero) {
        await Future<void>.delayed(delayBetween);
      }
    }
  }

  /// Syncs subscription state, then either runs [onAccess] immediately or
  /// presents the routed paywall ([firstTimeOfferWall] vs [premiumFeature]).
  ///
  /// Unlike [registerPlacement], this **never** grants access when no paywall
  /// is shown or the user dismisses without an active store entitlement.
  /// [onAccess] runs only when [syncAttributesAndResolvePaywallRoute] reports
  /// an active subscription (including after a successful purchase restore).
  ///
  /// Handles **non-gated** dashboard paywalls: their `feature` block can run
  /// as soon as the paywall appears, so we never call [onAccess] from that
  /// path unless the store already reports an active subscription, and we
  /// also re-check after purchase/restore on paywall dismiss.
  static Future<void> requireActiveSubscriptionOrPresentPaywall(
    void Function() onAccess,
  ) async {
    if (!isEnabled) {
      onAccess();
      return;
    }
    final resolved = await syncAttributesAndResolvePaywallRoute();
    if (resolved.isSubscribed) {
      onAccess();
      return;
    }

    final routedPlacement = resolved.placement;
    var accessDelivered = false;

    bool alreadyDelivered() => accessDelivered;
    void markDelivered() => accessDelivered = true;

    void scheduleFeatureGateCheck() {
      unawaited(
        _grantOnAccessIfSubscribed(
          onAccess,
          alreadyDelivered: alreadyDelivered,
          markDelivered: markDelivered,
          attempts: 2,
          delayBetween: const Duration(milliseconds: 50),
        ),
      );
    }

    final handler = PaywallPresentationHandler()
      ..onDismiss((_, PaywallResult result) {
        if (result is PurchasedPaywallResult ||
            result is RestoredPaywallResult) {
          unawaited(
            _grantOnAccessIfSubscribed(
              onAccess,
              alreadyDelivered: alreadyDelivered,
              markDelivered: markDelivered,
              attempts: 16,
              delayBetween: const Duration(milliseconds: 100),
            ),
          );
        }
      });

    try {
      await Superwall.shared.registerPlacement(
        routedPlacement,
        handler: handler,
        feature: scheduleFeatureGateCheck,
      );
    } catch (_) {
      // Dismissed or presentation error — no access.
    } finally {
      unawaited(syncAttributesAndResolvePaywallRoute());
    }
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
    final resolved = await syncAttributesAndResolvePaywallRoute();
    if (resolved.isSubscribed) {
      onAccess();
      return;
    }

    final routedPlacement = resolved.placement;
    var didGrantAccess = false;

    void grantAccessOnce() {
      if (didGrantAccess) return;
      didGrantAccess = true;
      onAccess();
    }

    bool alreadyDelivered() => didGrantAccess;
    void markDelivered() => didGrantAccess = true;

    Future<void> grantFromSubscriptionIfNeeded({
      required int attempts,
      Duration delayBetween = Duration.zero,
    }) {
      return _grantOnAccessIfSubscribed(
        onAccess,
        alreadyDelivered: alreadyDelivered,
        markDelivered: markDelivered,
        attempts: attempts,
        delayBetween: delayBetween,
      );
    }

    Future<void> grantFallbackIfNeeded() async {
      if (!fallbackToAccessWhenNoPaywall || didGrantAccess) return;
      final isPaywallPresented = await Superwall.shared.getIsPaywallPresented();
      if (!isPaywallPresented) {
        grantAccessOnce();
      }
    }

    final handler = PaywallPresentationHandler()
      ..onDismiss((_, PaywallResult result) {
        if (result is PurchasedPaywallResult ||
            result is RestoredPaywallResult) {
          unawaited(
            grantFromSubscriptionIfNeeded(
              attempts: 16,
              delayBetween: const Duration(milliseconds: 100),
            ),
          );
        }
      });

    try {
      await Superwall.shared
          .registerPlacement(
            routedPlacement,
            handler: handler,
            feature: () {
              unawaited(
                grantFromSubscriptionIfNeeded(
                  attempts: 2,
                  delayBetween: const Duration(milliseconds: 50),
                ),
              );
            },
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
    unawaited(syncAttributesAndResolvePaywallRoute());
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
    final resolved = await syncAttributesAndResolvePaywallRoute();
    if (resolved.isSubscribed) {
      return;
    }

    final routedPlacement = resolved.placement;

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
