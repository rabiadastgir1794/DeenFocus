import '../services/billing_service.dart';

/// Deep links for native subscription management (must match Android `applicationId`).
abstract final class StoreSubscriptionLinks {
  static const String androidPackageName = 'com.rnr.deenfocus';

  /// Opens Google Play's subscription screen for this app and base subscription SKU.
  static Uri playStoreManageSubscription() => Uri.parse(
    'https://play.google.com/store/account/subscriptions?'
    'package=$androidPackageName&sku=${BillingService.productId}',
  );

  static final Uri appleManageSubscriptions = Uri.parse(
    'https://apps.apple.com/account/subscriptions',
  );
}
