import 'dart:io';

import '../../../core/superwall/app_superwall.dart';
import '../model/support_contribution_result.dart';

/// Purchases a donation consumable. Isolated from subscription entitlements.
abstract class DonationPurchaser {
  bool get isAvailable;

  Future<SupportContributionResult> purchase(String productId);
}

class SuperwallDonationPurchaser implements DonationPurchaser {
  const SuperwallDonationPurchaser();

  @override
  bool get isAvailable => Platform.isIOS || Platform.isAndroid;

  @override
  Future<SupportContributionResult> purchase(String productId) async {
    final result = await AppSuperwall.purchaseDonation(productId);
    return switch (result) {
      SuperwallDirectPurchaseResult.purchased =>
        SupportContributionResult.purchased,
      SuperwallDirectPurchaseResult.cancelled =>
        SupportContributionResult.cancelled,
      SuperwallDirectPurchaseResult.pending =>
        SupportContributionResult.pending,
      SuperwallDirectPurchaseResult.failed =>
        SupportContributionResult.failed,
      SuperwallDirectPurchaseResult.productNotFound =>
        SupportContributionResult.productUnavailable,
    };
  }
}
