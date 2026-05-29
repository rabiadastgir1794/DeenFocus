// app_superwall.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../config/app_config.dart';
import '../services/billing_service.dart';
import '../services/storage_service.dart';

abstract final class SuperwallPlacements {
  static const String premiumFeature = 'premium_feature';
  static const String firstTimeOfferWall = 'first_time_offer_wall';
}

class AppSuperwall {
  AppSuperwall._();

  static bool _enabled = false;

  static Future<void>? _configureFuture;
  static Future<void>? _storeProductsPreflightFuture;

  static bool get isEnabled => _enabled;

  static final ValueNotifier<bool> subscriptionActiveNotifier = ValueNotifier(
    false,
  );
  static final ValueNotifier<bool> purchasedSubscriptionActiveNotifier =
      ValueNotifier(false);

  static void _log(String message) {
    debugPrint('[Superwall] $message');
  }

  static Future<void> configure() {
    return _configureFuture ??= _configureInternal();
  }

  static Future<void> _configureInternal() async {
    final key = _apiKeyForPlatform();

    if (key == null || key.isEmpty) {
      _log('Missing API key');
      return;
    }

    final completer = Completer<void>();

    try {
      _log('Starting Superwall.configure');

      Superwall.configure(
        key,
        completion: () {
          _enabled = true;

          _log('Superwall configured successfully');

          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      await completer.future;

      await syncSubscriptionState();
    } catch (e, st) {
      _log('Configure failed: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<void> syncSubscriptionState() async {
    if (!_enabled) return;

    try {
      final status = await Superwall.shared.getSubscriptionStatus();

      final isSubscribed = status.isActive;

      purchasedSubscriptionActiveNotifier.value = isSubscribed;
      subscriptionActiveNotifier.value = isSubscribed;

      var hasEverSubscribed = await StorageService.hasEverSubscribed;

      if (isSubscribed && !hasEverSubscribed) {
        hasEverSubscribed = true;

        await StorageService.setHasEverSubscribed(true);
      }

      await Superwall.shared.setUserAttributes({
        'isSubscribed': isSubscribed,
        'hasEverSubscribed': hasEverSubscribed,
        'hasUsedIntroOffer': hasEverSubscribed,
      });

      _log(
        'Subscription synced isSubscribed=$isSubscribed hasEverSubscribed=$hasEverSubscribed',
      );
    } catch (e) {
      _log('Failed syncing subscription state: $e');
    }
  }

  static Future<void> preflightStoreProducts({String debugContext = ''}) {
    final inFlight = _storeProductsPreflightFuture;
    if (inFlight != null) return inFlight;

    final future = _preflightStoreProductsInternal(debugContext: debugContext)
        .whenComplete(() {
          _storeProductsPreflightFuture = null;
        });
    _storeProductsPreflightFuture = future;
    return future;
  }

  static Future<void> _preflightStoreProductsInternal({
    required String debugContext,
  }) async {
    try {
      final products = await BillingService().fetchProducts();
      if (products.isEmpty) {
        _log(
          'Store product preflight returned no products context=$debugContext '
          'productIds=${BillingService.productIds.join(', ')}',
        );
        return;
      }

      _log(
        'Store product preflight loaded '
        '${products.map((product) => product.id).join(', ')} '
        'context=$debugContext',
      );
    } catch (e) {
      _log('Store product preflight failed context=$debugContext error=$e');
    }
  }

  static Future<String> paywallPlacementForCurrentUser({
    String debugContext = '',
  }) async {
    final hasEverSubscribed = await hasEverSubscribedToAnySubscription(
      debugContext: debugContext,
    );
    final placement = hasEverSubscribed
        ? SuperwallPlacements.premiumFeature
        : SuperwallPlacements.firstTimeOfferWall;

    _log(
      'Resolved paywall placement=$placement '
      'hasEverSubscribed=$hasEverSubscribed context=$debugContext',
    );

    return placement;
  }

  static Future<bool> hasEverSubscribedToAnySubscription({
    String debugContext = '',
  }) async {
    final stored = await StorageService.hasEverSubscribed;
    if (stored) return true;

    final hasStorePurchase = await BillingService().hasUserPurchasedBefore();
    if (!hasStorePurchase) return false;

    await StorageService.setHasEverSubscribed(true);
    if (_enabled) {
      await Superwall.shared.setUserAttributes({
        'hasEverSubscribed': true,
        'hasUsedIntroOffer': true,
      });
    }

    _log('Detected previous subscription purchase context=$debugContext');
    return true;
  }

  static Future<void> requireActiveSubscriptionOrPresentPaywall(
    void Function() onAccess, {
    String debugContext = '',
    String? placementOverride,
  }) async {
    try {
      await configure();

      if (!_enabled) {
        _log('Superwall not enabled');
        onAccess();
        return;
      }

      final status = await Superwall.shared.getSubscriptionStatus();

      if (status.isActive) {
        onAccess();
        return;
      }

      final placement =
          placementOverride ??
          await paywallPlacementForCurrentUser(debugContext: debugContext);

      await preflightStoreProducts(debugContext: debugContext);

      _log('Showing paywall placement=$placement context=$debugContext');

      await Superwall.shared.registerPlacement(
        placement,
        handler: PaywallPresentationHandler()
          ..onPresent((info) {
            _log('Paywall presented');
          })
          ..onDismiss((info, result) async {
            _log('Paywall dismissed');

            await syncSubscriptionState();

            final updatedStatus = await Superwall.shared
                .getSubscriptionStatus();

            if (updatedStatus.isActive) {
              onAccess();
            }
          })
          ..onError((error) {
            _log('Paywall error: $error');
          }),
        feature: () async {
          final latestStatus = await Superwall.shared.getSubscriptionStatus();

          if (latestStatus.isActive) {
            onAccess();
          }
        },
      );
    } catch (e, st) {
      _log('Paywall flow failed: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<void> markHasEverSubscribed() async {
    await StorageService.setHasEverSubscribed(true);

    await syncSubscriptionState();
  }

  static Future<void> markHasUsedIntroOffer() => markHasEverSubscribed();

  static String? _apiKeyForPlatform() {
    if (Platform.isAndroid) {
      return AppConfig.superwallApiKeyAndroid.trim();
    }

    return AppConfig.superwallApiKeyIOS.trim();
  }
}
