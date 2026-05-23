import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Reads store billing metadata and decides which Superwall paywall to show.
///
/// This service intentionally uses:
/// - `in_app_purchase` only for querying products and purchase history
/// - `superwallkit_flutter` only for paywall presentation / purchase handling
class BillingService {
  BillingService({InAppPurchase? inAppPurchase})
    : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  static const String androidYearlyProductId = 'premium.yearly';
  static const String iosMonthlyProductId = 'com.rnr.deenfocus.premium.monthly';
  static const String iosYearlyProductId = 'com.rnr.deenfocus.premium.yearly';

  /// Backwards-compatible alias for the primary subscription SKU used by
  /// Android subscription management deep links and intro-offer decisions.
  static const String productId = androidYearlyProductId;

  /// All subscription products that should be available to Superwall paywalls
  /// for the current platform.
  static Set<String> get productIds {
    if (Platform.isIOS) {
      return {iosMonthlyProductId, iosYearlyProductId};
    }

    return {androidYearlyProductId};
  }

  static String get yearlyProductId {
    if (Platform.isIOS) return iosYearlyProductId;
    return androidYearlyProductId;
  }

  static const String basePlanId = 'yearly';

  static const String firstTimeOfferWall = 'first_time_offer_wall';
  static const String premiumFeaturesWall = 'premium_feature';

  final InAppPurchase _inAppPurchase;

  /// Queries the platform store for the configured subscription product.
  Future<List<ProductDetails>> fetchProducts() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint(
        '[BillingService] Unsupported platform detected. Returning empty products.',
      );
      return const <ProductDetails>[];
    }

    final platform = Platform.isIOS ? 'iOS' : 'Android';

    try {
      final isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        debugPrint('[BillingService] $platform billing is unavailable.');
        return const <ProductDetails>[];
      }

      debugPrint(
        '[BillingService] Querying $platform products: ${productIds.join(', ')}',
      );

      final response = await _inAppPurchase.queryProductDetails(productIds);

      if (response.error != null) {
        debugPrint(
          '[BillingService] $platform queryProductDetails error: '
          '${response.error!.code} ${response.error!.message}',
        );
      }

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint(
          '[BillingService] $platform product IDs not found: '
          '${response.notFoundIDs.join(', ')}',
        );
      }

      if (response.productDetails.isEmpty) {
        debugPrint(
          '[BillingService] No $platform products returned for '
          '`${productIds.join(', ')}`.',
        );
        return const <ProductDetails>[];
      }

      for (final product in response.productDetails) {
        debugPrint(
          '[BillingService] Loaded $platform product '
          'id=${product.id} title="${product.title}" price=${product.price}',
        );
      }

      return response.productDetails;
    } catch (error, stackTrace) {
      debugPrint(
        '[BillingService] $platform fetchProducts error: '
        '$error\n$stackTrace',
      );
      return const <ProductDetails>[];
    }
  }

  /// Returns true when Google Play product metadata includes an intro discount
  /// phase (price lower than the highest recurring/full phase) for [product].
  bool detectIntroOffer(ProductDetails? product) {
    if (product == null) {
      debugPrint('[BillingService] detectIntroOffer: product is null.');
      return false;
    }

    if (product is! GooglePlayProductDetails) {
      debugPrint(
        '[BillingService] detectIntroOffer: not a GooglePlayProductDetails.',
      );
      return false;
    }

    final offerDetails = product.productDetails.subscriptionOfferDetails;
    if (offerDetails == null || offerDetails.isEmpty) {
      debugPrint('[BillingService] detectIntroOffer: no subscription offers.');
      return false;
    }

    int? fullPriceMicros;
    var hasLowerPhase = false;

    for (final offer in offerDetails) {
      final pricingPhases = offer.pricingPhases;
      for (final phase in pricingPhases) {
        final phasePrice = phase.priceAmountMicros;
        if (fullPriceMicros == null || phasePrice > fullPriceMicros) {
          fullPriceMicros = phasePrice;
        }
      }
    }

    if (fullPriceMicros == null) {
      debugPrint(
        '[BillingService] detectIntroOffer: unable to resolve full price.',
      );
      return false;
    }

    for (final offer in offerDetails) {
      final pricingPhases = offer.pricingPhases;
      for (final phase in pricingPhases) {
        if (phase.priceAmountMicros < fullPriceMicros) {
          hasLowerPhase = true;
          break;
        }
      }
      if (hasLowerPhase) break;
    }

    debugPrint(
      '[BillingService] detectIntroOffer: fullPriceMicros=$fullPriceMicros, '
      'hasIntroOffer=$hasLowerPhase, basePlanId=$basePlanId',
    );
    return hasLowerPhase;
  }

  /// Returns true if Google Play reports any previous purchases for this user.
  ///
  /// Uses Android platform addition and tolerates plugin API differences by
  /// safely reading dynamic response fields when needed.
  Future<bool> hasUserPurchasedBefore() async {
    if (!Platform.isAndroid) {
      debugPrint(
        '[BillingService] hasUserPurchasedBefore: non-Android platform.',
      );
      return false;
    }

    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      debugPrint(
        '[BillingService] hasUserPurchasedBefore: billing unavailable.',
      );
      return false;
    }

    try {
      final androidAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await androidAddition.queryPastPurchases();
      final purchases = response.pastPurchases;

      if (purchases.isEmpty) {
        debugPrint(
          '[BillingService] hasUserPurchasedBefore: no past purchases.',
        );
        return false;
      }

      final matchedSubscription = purchases.any((dynamic purchase) {
        final List<dynamic> products =
            (purchase.products ?? const <dynamic>[]) as List<dynamic>;
        if (products.isEmpty) return false;
        return products.any(productIds.contains);
      });

      if (matchedSubscription) {
        debugPrint(
          '[BillingService] hasUserPurchasedBefore: found purchase for '
          '${productIds.join(', ')}.',
        );
        return true;
      }

      debugPrint(
        '[BillingService] hasUserPurchasedBefore: purchases exist but none '
        'matched ${productIds.join(', ')}.',
      );
      return false;
    } catch (error, stackTrace) {
      debugPrint(
        '[BillingService] hasUserPurchasedBefore error: $error\n$stackTrace',
      );
      return false;
    }
  }

  /// Decides and presents the correct Superwall paywall:
  /// - `first_time_offer_wall` when intro offer exists and user has no history
  /// - `premium_feature` otherwise
  ///
  /// Google Play remains responsible for actual offer application at checkout.
  Future<void> decideAndShowPaywall() async {
    if (!Platform.isAndroid) {
      debugPrint('[BillingService] decideAndShowPaywall: Android only.');
      return;
    }

    final products = await fetchProducts();
    if (products.isEmpty) {
      debugPrint(
        '[BillingService] decideAndShowPaywall: empty product list, '
        'falling back to premium paywall.',
      );
      await _registerPaywall(premiumFeaturesWall);
      return;
    }

    final ProductDetails? targetProduct = products
        .where((product) => product.id == yearlyProductId)
        .firstOrNull;

    if (targetProduct == null) {
      debugPrint(
        '[BillingService] decideAndShowPaywall: $yearlyProductId missing, '
        'falling back to premium paywall.',
      );
      await _registerPaywall(premiumFeaturesWall);
      return;
    }

    final hasIntroOffer = detectIntroOffer(targetProduct);
    final hasPurchasedBefore = await hasUserPurchasedBefore();

    final eventName = (hasIntroOffer && !hasPurchasedBefore)
        ? firstTimeOfferWall
        : premiumFeaturesWall;

    debugPrint(
      '[BillingService] Paywall decision: '
      'hasIntroOffer=$hasIntroOffer, '
      'hasPurchasedBefore=$hasPurchasedBefore, '
      'event=$eventName',
    );

    await _registerPaywall(eventName);
  }

  Future<void> _registerPaywall(String eventName) async {
    try {
      await Superwall.shared.registerPlacement(eventName, feature: () {});
      debugPrint('[BillingService] Registered Superwall event: $eventName');
    } catch (error, stackTrace) {
      debugPrint(
        '[BillingService] Failed to register Superwall event `$eventName`: '
        '$error\n$stackTrace',
      );
      rethrow;
    }
  }
}
