import 'package:deenly/core/config/support_config.dart';
import 'package:deenly/features/support/model/support_contribution_result.dart';
import 'package:deenly/features/support/services/donation_purchase_service.dart';
import 'package:deenly/features/support/services/support_contact_service.dart';
import 'package:deenly/features/support/viewmodel/support_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDonationPurchaser implements DonationPurchaser {
  _FakeDonationPurchaser(this.outcome);

  SupportContributionResult outcome;
  String? lastProductId;
  int purchaseCount = 0;

  @override
  bool get isAvailable => true;

  @override
  Future<SupportContributionResult> purchase(String productId) async {
    lastProductId = productId;
    purchaseCount += 1;
    return outcome;
  }
}

void main() {
  group('SupportViewModel', () {
    test('defaults to \$50 preset', () {
      final vm = SupportViewModel();
      expect(vm.amount, 50);
      expect(vm.amount, SupportViewModel.defaultContributionAmount);
      expect(vm.selectedProductId, 'com.deenfocus.donation.50');
    });

    test('selectAmount updates only valid presets', () {
      final vm = SupportViewModel();
      vm.selectAmount(25);
      expect(vm.amount, 25);
      expect(vm.selectedProductId, 'com.deenfocus.donation.25');
      vm.selectAmount(250);
      expect(vm.amount, 250);
      expect(vm.selectedProductId, 'com.deenfocus.donation.250');
      vm.selectAmount(15); // not a preset
      expect(vm.amount, 250);
    });

    test('presetAmounts match design', () {
      expect(
        SupportViewModel.presetAmounts,
        <int>[10, 25, 50, 100, 250],
      );
    });

    test('submitContribution purchases the selected Superwall product', () async {
      final purchaser = _FakeDonationPurchaser(
        SupportContributionResult.purchased,
      );
      final vm = SupportViewModel(donationPurchaser: purchaser);
      vm.selectAmount(100);

      final result = await vm.submitContribution();

      expect(result, SupportContributionResult.purchased);
      expect(purchaser.lastProductId, 'com.deenfocus.donation.100');
      expect(vm.isSubmitting, isFalse);
    });

    test('cancelled purchase does not stay busy and can retry', () async {
      final purchaser = _FakeDonationPurchaser(
        SupportContributionResult.cancelled,
      );
      final vm = SupportViewModel(donationPurchaser: purchaser);

      expect(await vm.submitContribution(), SupportContributionResult.cancelled);
      purchaser.outcome = SupportContributionResult.purchased;
      expect(await vm.submitContribution(), SupportContributionResult.purchased);
      expect(purchaser.purchaseCount, 2);
    });

    test('failed purchase can be retried', () async {
      final purchaser = _FakeDonationPurchaser(
        SupportContributionResult.failed,
      );
      final vm = SupportViewModel(donationPurchaser: purchaser);

      expect(await vm.submitContribution(), SupportContributionResult.failed);
      purchaser.outcome = SupportContributionResult.purchased;
      expect(await vm.submitContribution(), SupportContributionResult.purchased);
    });

    test('pending purchase is reported without treating it as success', () async {
      final purchaser = _FakeDonationPurchaser(
        SupportContributionResult.pending,
      );
      final vm = SupportViewModel(donationPurchaser: purchaser);

      expect(await vm.submitContribution(), SupportContributionResult.pending);
    });
  });

  group('SupportConfig donation products', () {
    test('maps each amount to the exact store product id', () {
      expect(
        SupportConfig.donationProductIds,
        <int, String>{
          10: 'com.deenfocus.donation.10',
          25: 'com.deenfocus.donation.25',
          50: 'com.deenfocus.donation.50',
          100: 'com.deenfocus.donation.100',
          250: 'com.deenfocus.donation.250',
        },
      );
    });

    test('donation SKUs never overlap subscription SKUs', () {
      const subscriptionIds = <String>{
        'premium.yearly',
        'com.rnr.deenfocus.premium.monthly',
        'com.rnr.deenfocus.premium.yearly',
      };
      expect(
        SupportConfig.donationProductIds.values.toSet().intersection(
          subscriptionIds,
        ),
        isEmpty,
      );
    });
  });

  group('SupportContactService', () {
    test('submitContribution completes without throwing', () async {
      const service = SupportContactService();
      final result = await service.submitContribution(amount: 50);
      expect(result, isNotNull);
    });

    test('whatsAppLaunchUris use digits-only phone and prefilled text', () {
      final uris = SupportContactService.whatsAppLaunchUris(
        digits: '+92 300-123-4567',
        text: 'How do I use DeenFocus?',
      );
      expect(uris, hasLength(3));
      expect(uris[0].scheme, 'whatsapp');
      expect(uris[0].queryParameters['phone'], '923001234567');
      expect(uris[0].queryParameters['text'], 'How do I use DeenFocus?');
      expect(uris[1].host, 'wa.me');
      expect(uris[1].path, '/923001234567');
      expect(uris[1].queryParameters['text'], 'How do I use DeenFocus?');
      expect(uris[2].host, 'api.whatsapp.com');
      expect(uris[2].queryParameters['phone'], '923001234567');
    });
  });
}
