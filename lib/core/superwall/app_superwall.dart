// app_superwall.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../config/app_config.dart';
import '../services/billing_service.dart';
import '../services/storage_service.dart';
import 'premium_access_policy.dart';

abstract final class SuperwallPlacements {
  static const String premiumFeature = 'premium_feature';
  static const String firstTimeOfferWall = 'first_time_offer_wall';
}

abstract final class SuperwallCustomActions {
  static const String openNormalPaywall = 'openNormalPaywall';
}

/// Result of Superwall's direct purchase API. Isolated from paywalls / `pro`.
enum SuperwallDirectPurchaseResult {
  purchased,
  cancelled,
  pending,
  failed,
  productNotFound,
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

  /// Configures Superwall once. Retries on the next call if a previous attempt
  /// finished without enabling the SDK (missing key / timeout / failure).
  static Future<void> configure() {
    if (_enabled) return Future<void>.value();
    return _configureFuture ??= _configureInternal().whenComplete(() {
      // Allow a later retry when configure did not succeed (e.g. empty
      // dart-define on a previous binary, or a transient timeout).
      if (!_enabled) {
        _configureFuture = null;
      }
    });
  }

  static Future<void> _configureInternal() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final key = _apiKeyForPlatform() ?? '';
    final keyPresent = key.isNotEmpty;
    final defineName = _apiKeyDefineNameForPlatform();

    // Safe diagnostic only — never log the key value.
    _log(
      'Configure start platform=$platform keyPresent=$keyPresent '
      'keyLength=${key.length} define=$defineName',
    );

    if (!keyPresent) {
      _log(
        'Configure failed: missing API key for $platform define=$defineName '
        'keyPresent=false keyLength=0. '
        'Android merges repo dart_defines.json in gradle; also pass '
        '--dart-define-from-file=dart_defines.json for Flutter CLI runs. '
        'Full rebuild required — hot reload cannot inject dart-defines.',
      );
      return;
    }

    final completer = Completer<void>();

    try {
      _log(
        'Starting Superwall.configure define=$defineName '
        'keyPresent=true keyLength=${key.length}',
      );

      Superwall.configure(
        key,
        completion: () {
          unawaited(_onConfigureCompletion(completer));
        },
      );

      await completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          _log(
            'Superwall.configure completion timed out after 8s — '
            'polling configuration status',
          );
        },
      );

      if (!_enabled) {
        await _pollUntilConfigured(
          timeout: const Duration(seconds: 12),
          reason: 'after configure wait',
        );
      }

      if (!_enabled) {
        final status = await _safeConfigurationStatus();
        _log(
          'Configure failed: Superwall not enabled after attempt '
          'platform=$platform status=$status',
        );
        return;
      }

      Superwall.shared.setDelegate(_delegate);
      _log(
        'Configure succeeded platform=$platform '
        'delegate registered for custom paywall actions',
      );

      // Sync subscription state in the background so configure() completes
      // immediately after SDK init. On Play Store, getSubscriptionStatus() can
      // take 1-2 minutes waiting for Google Play Billing — awaiting it here
      // blocks every premium gate (via configure().timeout(30s)).
      unawaited(syncSubscriptionState());
    } catch (e, st) {
      _log('Configure failed with exception: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<void> _onConfigureCompletion(Completer<void> completer) async {
    try {
      final status = await _safeConfigurationStatus();
      if (status == ConfigurationStatus.configured) {
        _enabled = true;
        _log('Configure completion: success status=configured');
      } else {
        _log(
          'Configure completion: SDK callback fired but status=$status '
          '(not marking enabled yet)',
        );
      }
    } catch (e) {
      _log('Configure completion: status check failed: $e');
    } finally {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
  }

  static Future<ConfigurationStatus?> _safeConfigurationStatus() async {
    try {
      return await Superwall.shared.getConfigurationStatus();
    } catch (e) {
      _log('getConfigurationStatus failed: $e');
      return null;
    }
  }

  static Future<void> _pollUntilConfigured({
    required Duration timeout,
    required String reason,
  }) async {
    final deadline = DateTime.now().add(timeout);
    _log('Polling Superwall configuration ($reason) for ${timeout.inSeconds}s');
    while (!_enabled && DateTime.now().isBefore(deadline)) {
      final status = await _safeConfigurationStatus();
      if (status == ConfigurationStatus.configured) {
        _enabled = true;
        _log('Polling: Superwall became configured ($reason)');
        return;
      }
      if (status == ConfigurationStatus.failed) {
        _log('Polling: Superwall configuration failed ($reason)');
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  }

  /// Android donations require Superwall. iOS may still use StoreKit 2.
  static Future<bool> _ensureConfiguredForAndroidDonation() async {
    await configure();
    if (_enabled) return true;

    await _pollUntilConfigured(
      timeout: const Duration(seconds: 8),
      reason: 'donation gate',
    );

    if (_enabled) return true;

    final status = await _safeConfigurationStatus();
    final key = _apiKeyForPlatform() ?? '';
    final defineName = _apiKeyDefineNameForPlatform();
    _log(
      'Donation blocked: Superwall not configured on Android '
      'define=$defineName keyPresent=${key.isNotEmpty} '
      'keyLength=${key.length} status=$status superwallEnabled=$_enabled',
    );
    return false;
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

  /// Marks entitlement active after Superwall confirms a purchase/restore when
  /// StoreKit / Play Billing status is still catching up. Never call this from
  /// paywall dismiss, skip, or feature() alone.
  static Future<void> markActiveFromConfirmedPurchase() async {
    purchasedSubscriptionActiveNotifier.value = true;
    subscriptionActiveNotifier.value = true;
    await StorageService.setCachedSubscriptionActive(true);
    await StorageService.setHasEverSubscribed(true);
    if (_enabled) {
      try {
        await Superwall.shared.setUserAttributes({
          'isSubscribed': true,
          'hasEverSubscribed': true,
          'hasUsedIntroOffer': true,
        });
      } catch (e) {
        _log('Failed setting attributes after confirmed purchase: $e');
      }
    }
    _log('Marked subscription active from confirmed purchase/restore');
    // Delay sync so a lagging StoreKit/Play status cannot immediately
    // overwrite the confirmed purchase before billing catches up.
    unawaited(
      Future<void>.delayed(const Duration(seconds: 5)).then(
        (_) => syncSubscriptionState(),
      ),
    );
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

      var accessGranted = false;
      void grantAccess(String source) {
        if (accessGranted) return;
        accessGranted = true;
        _log(
          'GRANT_ACCESS source=$source context=$debugContext '
          'subscriptionActive=${subscriptionActiveNotifier.value}',
        );
        onAccess();
      }

      void applyDecision(
        PremiumAccessDecision decision, {
        required PremiumGateEvent event,
        PaywallDismissKind? dismissKind,
        required String source,
      }) {
        _log(
          PremiumAccessPolicy.decisionLogLine(
            decision: decision,
            event: event,
            subscriptionActive: subscriptionActiveNotifier.value,
            dismissKind: dismissKind,
            debugContext: debugContext,
          ),
        );
        if (decision.grantAccess) {
          grantAccess(source);
        }
      }

      await Superwall.shared.registerPlacement(
        placement,
        handler: PaywallPresentationHandler()
          ..onPresent((info) {
            _log('Paywall presented');
          })
          ..onDismiss((info, result) async {
            final dismissKind =
                PremiumAccessPolicy.dismissKindFromResultType(result.runtimeType);
            _log(
              'Paywall dismissed result=$result dismissKind=${dismissKind.name} '
              'subscriptionActive=${subscriptionActiveNotifier.value}',
            );
            if (dismissKind == PaywallDismissKind.purchased ||
                dismissKind == PaywallDismissKind.restored) {
              const maxAttempts = 5;
              for (var attempt = 1; attempt <= maxAttempts; attempt++) {
                await syncSubscriptionState();
                final mid = PremiumAccessPolicy.decide(
                  event: PremiumGateEvent.paywallDismissed,
                  subscriptionActive: subscriptionActiveNotifier.value,
                  dismissKind: dismissKind,
                  trustConfirmedPurchaseAfterSyncLag: false,
                  debugContext: debugContext,
                );
                if (mid.grantAccess) {
                  _log('Subscription confirmed active (attempt $attempt)');
                  applyDecision(
                    mid,
                    event: PremiumGateEvent.paywallDismissed,
                    dismissKind: dismissKind,
                    source: 'dismiss_purchase_sync_$attempt',
                  );
                  return;
                }
                _log('Subscription not yet active ($attempt/$maxAttempts)');
                if (attempt < maxAttempts) {
                  await Future<void>.delayed(const Duration(seconds: 2));
                }
              }
              final trusted = PremiumAccessPolicy.decide(
                event: PremiumGateEvent.paywallDismissed,
                subscriptionActive: subscriptionActiveNotifier.value,
                dismissKind: dismissKind,
                trustConfirmedPurchaseAfterSyncLag: true,
                debugContext: debugContext,
              );
              _log(
                'Status still lagging after $maxAttempts attempts — '
                'evaluating trusted purchase',
              );
              if (trusted.grantAccess) {
                await markActiveFromConfirmedPurchase();
              }
              applyDecision(
                trusted,
                event: PremiumGateEvent.paywallDismissed,
                dismissKind: dismissKind,
                source: 'dismiss_purchase_trusted',
              );
              return;
            }
            await syncSubscriptionState();
            applyDecision(
              PremiumAccessPolicy.decide(
                event: PremiumGateEvent.paywallDismissed,
                subscriptionActive: subscriptionActiveNotifier.value,
                dismissKind: dismissKind,
                debugContext: debugContext,
              ),
              event: PremiumGateEvent.paywallDismissed,
              dismissKind: dismissKind,
              source: 'dismiss_non_purchase',
            );
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
          // Never treat feature() as entitlement by itself.
          _log(
            'feature() invoked — verifying entitlement context=$debugContext '
            'subscriptionActive=${subscriptionActiveNotifier.value}',
          );
          await syncSubscriptionState();
          var active = subscriptionActiveNotifier.value;
          if (!active) {
            try {
              final updated = await Superwall.shared
                  .getSubscriptionStatus()
                  .timeout(const Duration(seconds: 5));
              if (updated.isActive) {
                await syncSubscriptionState();
                active = subscriptionActiveNotifier.value || updated.isActive;
              }
            } catch (e) {
              _log('feature() entitlement re-check failed: $e');
            }
          }
          applyDecision(
            PremiumAccessPolicy.decide(
              event: PremiumGateEvent.featureCallback,
              subscriptionActive: active,
              debugContext: debugContext,
            ),
            event: PremiumGateEvent.featureCallback,
            source: 'feature_callback',
          );
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

  static String _apiKeyDefineNameForPlatform() {
    if (Platform.isAndroid) {
      return AppConfig.superwallApiKeyAndroidDefine;
    }
    return AppConfig.superwallApiKeyIOSDefine;
  }

  static const MethodChannel _donationChannel = MethodChannel(
    'com.app.deenly.deenly/superwall_donations',
  );

  /// Fetches a store product via the native Superwall donation bridge.
  /// iOS may fall back to StoreKit 2; Android uses Superwall only.
  /// Does not present a paywall and does not change subscription / `pro` state.
  static Future<Map<String, dynamic>?> fetchDonationProduct(
    String productId,
  ) async {
    if (Platform.isAndroid) {
      final ready = await _ensureConfiguredForAndroidDonation();
      if (!ready) return null;
    } else {
      await configure();
    }

    try {
      final raw = await _donationChannel.invokeMapMethod<String, dynamic>(
        'fetchProduct',
        <String, String>{'productId': productId},
      );
      _log(
        'Fetched donation product id=$productId '
        'superwallEnabled=$_enabled payload=$raw',
      );
      return raw;
    } on PlatformException catch (e) {
      _log(
        'Donation product fetch failed id=$productId '
        'code=${e.code} message=${e.message}',
      );
      if (e.code == 'PRODUCT_NOT_FOUND') return null;
      rethrow;
    } on MissingPluginException catch (e) {
      _log('Donation product fetch missing plugin: $e');
      return null;
    }
  }

  /// Purchases a one-time donation via Superwall's direct purchase API.
  /// iOS may fall back to StoreKit 2 when Superwall is unavailable; Android
  /// uses Superwall only (Superwall owns the Play Billing lifecycle).
  ///
  /// Never presents a Superwall paywall, never calls [syncSubscriptionState],
  /// and must not grant the `pro` entitlement.
  static Future<SuperwallDirectPurchaseResult> purchaseDonation(
    String productId,
  ) async {
    if (Platform.isAndroid) {
      final ready = await _ensureConfiguredForAndroidDonation();
      if (!ready) {
        return SuperwallDirectPurchaseResult.failed;
      }
    } else {
      await configure();
    }

    _log(
      'Donation purchase start id=$productId superwallEnabled=$_enabled '
      'platform=${Platform.isAndroid ? 'android' : 'ios'}',
    );

    try {
      final product = await fetchDonationProduct(productId);
      if (product == null) {
        _log('Donation product not found id=$productId');
        return SuperwallDirectPurchaseResult.productNotFound;
      }

      final raw = await _donationChannel.invokeMapMethod<String, dynamic>(
        'purchase',
        <String, String>{'productId': productId},
      );
      final status = raw?['status'] as String?;
      _log('Donation purchase id=$productId status=$status');

      switch (status) {
        case 'purchased':
          return SuperwallDirectPurchaseResult.purchased;
        case 'cancelled':
          return SuperwallDirectPurchaseResult.cancelled;
        case 'pending':
          return SuperwallDirectPurchaseResult.pending;
        case 'failed':
          return SuperwallDirectPurchaseResult.failed;
        default:
          _log('Donation purchase returned unknown status=$status');
          return SuperwallDirectPurchaseResult.failed;
      }
    } on PlatformException catch (e) {
      _log(
        'Donation purchase failed id=$productId '
        'code=${e.code} message=${e.message}',
      );
      if (e.code == 'PRODUCT_NOT_FOUND') {
        return SuperwallDirectPurchaseResult.productNotFound;
      }
      if (e.code == 'cancelled') {
        return SuperwallDirectPurchaseResult.cancelled;
      }
      return SuperwallDirectPurchaseResult.failed;
    } on MissingPluginException catch (e) {
      _log('Donation purchase missing plugin: $e');
      return SuperwallDirectPurchaseResult.failed;
    } catch (e, st) {
      _log('Donation purchase failed id=$productId error=$e');
      debugPrintStack(stackTrace: st);
      return SuperwallDirectPurchaseResult.failed;
    }
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
  void handleSuperwallEvent(SuperwallEventInfo eventInfo) {}

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
