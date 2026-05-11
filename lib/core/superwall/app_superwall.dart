// app_superwall.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../config/app_config.dart';
import '../services/storage_service.dart';

abstract final class SuperwallPlacements {
  static const String premiumFeature = 'premium_feature';
  static const String firstTimeOfferWall = 'first_time_offer_wall';
}

class AppSuperwall {
  AppSuperwall._();

  static bool _enabled = false;

  static Future<void>? _configureFuture;

  static bool get isEnabled => _enabled;

  static final ValueNotifier<bool> subscriptionActiveNotifier =
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
      final status =
      await Superwall.shared.getSubscriptionStatus();

      final isSubscribed = status.isActive;

      subscriptionActiveNotifier.value = isSubscribed;

      var hasUsedIntroOffer =
      await StorageService.hasUsedIntroOffer;

      if (isSubscribed && !hasUsedIntroOffer) {
        hasUsedIntroOffer = true;

        await StorageService.setHasUsedIntroOffer(true);
      }

      await Superwall.shared.setUserAttributes({
        'isSubscribed': isSubscribed,
        'hasUsedIntroOffer': hasUsedIntroOffer,
      });

      _log(
        'Subscription synced isSubscribed=$isSubscribed hasUsedIntroOffer=$hasUsedIntroOffer',
      );
    } catch (e) {
      _log('Failed syncing subscription state: $e');
    }
  }

  static Future<void> requireActiveSubscriptionOrPresentPaywall(
      void Function() onAccess, {
        String debugContext = '',
      }) async {
    try {
      await configure();

      if (!_enabled) {
        _log('Superwall not enabled');
        return;
      }

      final status =
      await Superwall.shared.getSubscriptionStatus();

      if (status.isActive) {
        onAccess();
        return;
      }

      final hasUsedIntroOffer =
      await StorageService.hasUsedIntroOffer;

      final placement = hasUsedIntroOffer
          ? SuperwallPlacements.premiumFeature
          : SuperwallPlacements.firstTimeOfferWall;

      _log(
        'Showing paywall placement=$placement context=$debugContext',
      );

      await Superwall.shared.registerPlacement(
        placement,
        handler: PaywallPresentationHandler()
          ..onPresent((info) {
            _log('Paywall presented');
          })
          ..onDismiss((info, result) async {
            _log('Paywall dismissed');

            await syncSubscriptionState();

            final updatedStatus =
            await Superwall.shared
                .getSubscriptionStatus();

            if (updatedStatus.isActive) {
              onAccess();
            }
          })
          ..onError((error) {
            _log('Paywall error: $error');
          }),
        feature: () async {
          final latestStatus =
          await Superwall.shared
              .getSubscriptionStatus();

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

  static Future<void> markHasUsedIntroOffer() async {
    await StorageService.setHasUsedIntroOffer(true);

    await syncSubscriptionState();
  }

  static String? _apiKeyForPlatform() {
    if (Platform.isAndroid) {
      return AppConfig.superwallApiKeyAndroid.trim();
    }

    return AppConfig.superwallApiKeyIOS.trim();
  }
}