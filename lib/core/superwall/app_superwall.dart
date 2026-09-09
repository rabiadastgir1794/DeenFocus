// app_superwall.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../analytics/meta_app_events_service.dart';
import '../analytics/tiktok_app_events_service.dart';
import '../config/app_config.dart';
import '../services/billing_service.dart';
import '../services/storage_service.dart';

abstract final class SuperwallPlacements {
  static const String premiumFeature = 'premium_feature';
  static const String firstTimeOfferWall = 'first_time_offer_wall';
}

abstract final class SuperwallCustomActions {
  static const String openNormalPaywall = 'openNormalPaywall';
}

class AppSuperwall {
  AppSuperwall._();

  static const Duration _customActionDismissDelay = Duration(milliseconds: 300);
  static const Duration _customActionDismissTimeout = Duration(seconds: 4);
  static const Duration _customActionDismissPollInterval = Duration(
    milliseconds: 100,
  );

  static bool _enabled = false;
  static bool _openingNormalPaywallFromCustomAction = false;

  static Future<void>? _configureFuture;
  static final SuperwallDelegate _delegate = _AppSuperwallDelegate();

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

      Superwall.shared.setDelegate(_delegate);
      _log('Superwall delegate registered for custom paywall actions');

      // Sync subscription state in the background so configure() completes
      // immediately after SDK init. On Play Store, getSubscriptionStatus() can
      // take 1-2 minutes waiting for Google Play Billing — awaiting it here
      // blocks every premium gate (via configure().timeout(30s)).
      unawaited(syncSubscriptionState());
    } catch (e, st) {
      _log('Configure failed: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  /// Loads the persisted subscription status into [subscriptionActiveNotifier]
  /// without hitting the network. Call this early in app startup so premium
  /// gates can skip the loader on cold start when the user is already subscribed.
  static Future<void> loadCachedState() async {
    final cached = await StorageService.cachedSubscriptionActive;
    if (cached) {
      subscriptionActiveNotifier.value = true;
      purchasedSubscriptionActiveNotifier.value = true;
      _log('Loaded cached subscription active=true');
    }
  }

  static Future<bool> syncSubscriptionState() async {
    if (!_enabled) return false;

    try {
      final status = await Superwall.shared.getSubscriptionStatus();

      final isSubscribed = status.isActive;

      purchasedSubscriptionActiveNotifier.value = isSubscribed;
      subscriptionActiveNotifier.value = isSubscribed;

      // Persist so the next cold start can skip the loader.
      await StorageService.setCachedSubscriptionActive(isSubscribed);

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
      return true;
    } catch (e) {
      _log('Failed syncing subscription state: $e');
      return false;
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

      _log('Showing paywall placement=$placement context=$debugContext');

      await Superwall.shared.registerPlacement(
        placement,
        handler: PaywallPresentationHandler()
          ..onPresent((info) {
            _log('Paywall presented');
          })
          ..onDismiss((info, result) async {
            _log('Paywall dismissed result=$result');
            if (result is PurchasedPaywallResult ||
                result is RestoredPaywallResult) {
              const maxAttempts = 5;
              for (var attempt = 1; attempt <= maxAttempts; attempt++) {
                await syncSubscriptionState();
                if (subscriptionActiveNotifier.value) {
                  _log('Subscription confirmed active (attempt $attempt)');
                  onAccess();
                  return;
                }
                _log('Subscription not yet active ($attempt/$maxAttempts)');
                if (attempt < maxAttempts) {
                  await Future<void>.delayed(const Duration(seconds: 2));
                }
              }
              _log(
                'Status still lagging after $maxAttempts attempts — '
                'trusting PurchasedPaywallResult',
              );
              onAccess();
              return;
            }
            try {
              final updatedStatus = await Superwall.shared
                  .getSubscriptionStatus()
                  .timeout(const Duration(seconds: 10));
              if (updatedStatus.isActive) onAccess();
            } catch (e) {
              _log('post-dismiss status check failed: $e');
            }
          })
          ..onError((error) {
            _log('Paywall error: $error');
          })
          ..onCustomCallback((callback) {
            return handleCustomPaywallCallback(
              callback,
              debugContext: debugContext,
            );
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

  /// Handles Superwall paywall custom actions.
  ///
  /// The intro offer paywall's close button sends [openNormalPaywall]. After
  /// Superwall dismisses that paywall, this app requests the normal premium
  /// placement. Add future Superwall custom actions to this switch so all
  /// paywall-to-Flutter navigation stays in one place.
  static void handleCustomPaywallAction(String name) {
    _handleCustomPaywallAction(name, source: 'delegate');
  }

  /// Handles Superwall custom callbacks from paywall presentation handlers.
  ///
  /// Some Superwall editor actions are delivered as custom callbacks instead
  /// of delegate custom actions. Route them through the same dispatcher so the
  /// paywall configuration can use either mechanism.
  static Future<CustomCallbackResult> handleCustomPaywallCallback(
    CustomCallback callback, {
    String debugContext = '',
  }) async {
    _log(
      'Custom paywall callback received: ${callback.name} '
      'context=$debugContext variables=${callback.variables}',
    );

    if (callback.name == SuperwallCustomActions.openNormalPaywall &&
        debugContext.startsWith('custom_action:')) {
      _log(
        'Ignoring ${SuperwallCustomActions.openNormalPaywall} from '
        '$debugContext to avoid reopening ${SuperwallPlacements.premiumFeature}',
      );
      return CustomCallbackResult.success({'ignored': true});
    }

    final handled = _handleCustomPaywallAction(
      callback.name,
      source: 'callback context=$debugContext',
    );

    if (handled) {
      return CustomCallbackResult.success({'handled': true});
    }

    return CustomCallbackResult.failure({'handled': false});
  }

  static bool _handleCustomPaywallAction(
    String name, {
    required String source,
  }) {
    _log('Custom paywall action received: $name source=$source');

    switch (name) {
      case SuperwallCustomActions.openNormalPaywall:
        unawaited(_openNormalPaywallFromCustomAction());
        return true;
      default:
        _log('No Flutter handler registered for custom action: $name');
        return false;
    }
  }

  static Future<void> _openNormalPaywallFromCustomAction() async {
    if (_openingNormalPaywallFromCustomAction) {
      _log(
        'Ignoring duplicate custom action: '
        '${SuperwallCustomActions.openNormalPaywall}',
      );
      return;
    }

    _openingNormalPaywallFromCustomAction = true;

    try {
      if (!_enabled) {
        _log(
          'Cannot open ${SuperwallPlacements.premiumFeature}; '
          'Superwall is not enabled',
        );
        return;
      }

      final dismissed = await _waitForCurrentPaywallToDismiss();
      if (!dismissed) return;

      // Mark the intro offer as used only for this follow-up request. This
      // lets Superwall audience filters choose the normal paywall now without
      // permanently blocking the intro paywall for future unsubscribed opens.
      await _setIntroOfferUsedForFollowUpPlacement();

      _log(
        'Before opening Superwall placement=${SuperwallPlacements.premiumFeature} '
        'from action=${SuperwallCustomActions.openNormalPaywall}',
      );

      await Superwall.shared.registerPlacement(
        SuperwallPlacements.premiumFeature,
        handler: PaywallPresentationHandler()
          ..onPresent((info) {
            _log(
              'Custom action paywall presented '
              'placement=${SuperwallPlacements.premiumFeature}',
            );
          })
          ..onDismiss((info, result) async {
            _log(
              'Custom action paywall dismissed '
              'placement=${SuperwallPlacements.premiumFeature}',
            );
            await syncSubscriptionState();
          })
          ..onError((error) {
            _log(
              'Custom action paywall error '
              'placement=${SuperwallPlacements.premiumFeature} error=$error',
            );
            unawaited(syncSubscriptionState());
          })
          ..onCustomCallback((callback) {
            return handleCustomPaywallCallback(
              callback,
              debugContext:
                  'custom_action:${SuperwallCustomActions.openNormalPaywall}',
            );
          }),
        feature: () async {
          await syncSubscriptionState();
        },
      );

      _log(
        'Successfully requested Superwall placement='
        '${SuperwallPlacements.premiumFeature} '
        'from action=${SuperwallCustomActions.openNormalPaywall}',
      );
    } catch (e, st) {
      _log(
        'Failed opening Superwall placement=${SuperwallPlacements.premiumFeature} '
        'from action=${SuperwallCustomActions.openNormalPaywall}: $e',
      );
      debugPrintStack(stackTrace: st);
    } finally {
      _openingNormalPaywallFromCustomAction = false;
    }
  }

  static Future<void> _setIntroOfferUsedForFollowUpPlacement() async {
    try {
      final status = await Superwall.shared.getSubscriptionStatus();
      final hasEverSubscribed = await StorageService.hasEverSubscribed;

      await Superwall.shared.setUserAttributes({
        'isSubscribed': status.isActive,
        'hasEverSubscribed': hasEverSubscribed,
        'hasUsedIntroOffer': true,
      });

      _log(
        'Temporarily set hasUsedIntroOffer=true for '
        '${SuperwallPlacements.premiumFeature} follow-up '
        'isSubscribed=${status.isActive} hasEverSubscribed=$hasEverSubscribed',
      );
    } catch (e, st) {
      _log('Failed setting temporary intro-offer routing attribute: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<bool> _waitForCurrentPaywallToDismiss() async {
    _log(
      'Waiting ${_customActionDismissDelay.inMilliseconds}ms before opening '
      '${SuperwallPlacements.premiumFeature} for action='
      '${SuperwallCustomActions.openNormalPaywall}',
    );
    await Future<void>.delayed(_customActionDismissDelay);

    final deadline = DateTime.now().add(_customActionDismissTimeout);
    var loggedStillPresented = false;

    while (DateTime.now().isBefore(deadline)) {
      try {
        final isPresented = await Superwall.shared.getIsPaywallPresented();
        if (!isPresented) {
          _log(
            'Current paywall dismissed; continuing to '
            '${SuperwallPlacements.premiumFeature}',
          );
          return true;
        }

        if (!loggedStillPresented) {
          loggedStillPresented = true;
          _log(
            'Current paywall is still presented after '
            '${_customActionDismissDelay.inMilliseconds}ms; waiting before '
            'requesting ${SuperwallPlacements.premiumFeature}',
          );
        }
      } catch (e, st) {
        _log('Failed checking whether current paywall is dismissed: $e');
        debugPrintStack(stackTrace: st);
        return false;
      }

      await Future<void>.delayed(_customActionDismissPollInterval);
    }

    _log(
      'Timed out waiting for current paywall to dismiss; not requesting '
      '${SuperwallPlacements.premiumFeature} to avoid overlapping paywalls',
    );
    return false;
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

class _AppSuperwallDelegate extends SuperwallDelegate {
  @override
  void handleCustomPaywallAction(String name) {
    AppSuperwall.handleCustomPaywallAction(name);
  }

  @override
  void subscriptionStatusDidChange(SubscriptionStatus newValue) {
    final isActive = newValue.isActive;
    AppSuperwall.purchasedSubscriptionActiveNotifier.value = isActive;
    AppSuperwall.subscriptionActiveNotifier.value = isActive;
    AppSuperwall._log(
      'Delegate subscription status changed isActive=$isActive',
    );
  }

  @override
  void handleSuperwallEvent(SuperwallEventInfo eventInfo) {
    // Fire conversion events only after Superwall confirms success.
    // Never on paywall open / button tap. Restores are ignored to avoid dupes.
    try {
      final event = eventInfo.event;
      switch (event.type) {
        case EventType.freeTrialStart:
          unawaited(_trackStartTrial(event));
          break;
        case EventType.subscriptionStart:
          unawaited(_trackSubscribe(event));
          break;
        case EventType.nonRecurringProductPurchase:
          unawaited(_trackPurchase(event));
          break;
        case EventType.transactionComplete:
          // Paid subscription revenue: Superwall also emits subscriptionStart /
          // freeTrialStart; Purchase is deduped by transaction id.
          unawaited(_trackPurchase(event));
          break;
        case EventType.transactionRestore:
        case EventType.restoreComplete:
          // Do not attribute restored purchases as new conversions.
          break;
        default:
          break;
      }
    } catch (e, st) {
      debugPrint('[Superwall] Analytics event hook failed safely: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static String _conversionEventId(SuperwallEvent event, String suffix) {
    final txn = event.transaction;
    final productId = event.product?.productIdentifier ?? 'unknown';
    final txnId =
        txn?.storeTransactionId ??
        txn?.originalTransactionIdentifier ??
        '';
    if (txnId.isNotEmpty) {
      return '$suffix:$txnId:$productId';
    }
    // Fallback — still stable within a session for the same product.
    return '$suffix:$productId:${DateTime.now().millisecondsSinceEpoch ~/ 60000}';
  }

  static Future<void> _trackStartTrial(SuperwallEvent event) async {
    final product = event.product;
    final eventId = _conversionEventId(event, 'StartTrial');
    await TikTokAppEventsService.trackStartTrial(
      eventId: eventId,
      contentId: product?.productIdentifier,
      currency: product?.currencyCode,
      value: product?.price,
    );
    await MetaAppEventsService.trackStartTrial(
      eventId: eventId,
      contentId: product?.productIdentifier,
      currency: product?.currencyCode,
      value: product?.price,
    );
  }

  static Future<void> _trackSubscribe(SuperwallEvent event) async {
    final product = event.product;
    final eventId = _conversionEventId(event, 'Subscribe');
    await TikTokAppEventsService.trackSubscribe(
      eventId: eventId,
      contentId: product?.productIdentifier,
      currency: product?.currencyCode,
      value: product?.price,
    );
    await MetaAppEventsService.trackSubscribe(
      eventId: eventId,
      contentId: product?.productIdentifier,
      currency: product?.currencyCode,
      value: product?.price,
    );
  }

  static Future<void> _trackPurchase(SuperwallEvent event) async {
    final product = event.product;
    final eventId = _conversionEventId(event, 'Purchase');
    final currency = product?.currencyCode;
    final value = product?.price;
    await TikTokAppEventsService.trackPurchase(
      eventId: eventId,
      contentId: product?.productIdentifier,
      contentType: 'product',
      description: product?.productIdentifier,
      currency: currency,
      value: value,
    );
    if (currency != null &&
        currency.trim().isNotEmpty &&
        value != null) {
      await MetaAppEventsService.trackPurchase(
        eventId: eventId,
        contentId: product?.productIdentifier,
        contentType: 'product',
        currency: currency,
        value: value,
      );
    }
  }

  @override
  void willDismissPaywall(PaywallInfo paywallInfo) {}

  @override
  void willPresentPaywall(PaywallInfo paywallInfo) {}

  @override
  void didDismissPaywall(PaywallInfo paywallInfo) {}

  @override
  void didPresentPaywall(PaywallInfo paywallInfo) {}

  @override
  void paywallWillOpenURL(Uri url) {}

  @override
  void paywallWillOpenDeepLink(Uri url) {}

  @override
  void handleLog(
    String level,
    String scope,
    String? message,
    Map<dynamic, dynamic>? info,
    String? error,
  ) {}

  @override
  void handleSuperwallDeepLink(
    Uri fullURL,
    List<String> pathComponents,
    Map<String, String> queryParameters,
  ) {}
}
