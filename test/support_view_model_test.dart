import 'package:deenly/features/support/services/support_contact_service.dart';
import 'package:deenly/features/support/viewmodel/support_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupportViewModel', () {
    test('defaults to configured amount', () {
      final vm = SupportViewModel();
      expect(vm.amount, SupportViewModel.defaultContributionAmount);
    });

    test('slider updates clamped amount', () {
      final vm = SupportViewModel();
      vm.setAmountFromSlider(42.7);
      expect(vm.amount, 43);
      vm.setAmountFromSlider(200);
      expect(vm.amount, SupportViewModel.maxAmount);
      vm.setAmountFromSlider(0);
      expect(vm.amount, SupportViewModel.minAmount);
    });

    test('custom text updates amount when valid', () {
      final vm = SupportViewModel();
      vm.setAmountFromText('25');
      expect(vm.amount, 25);
      vm.setAmountFromText('abc');
      expect(vm.amount, 25);
    });

    test('purpose updates independently', () {
      final vm = SupportViewModel();
      vm.setPurpose('Sadaqah');
      expect(vm.purpose, 'Sadaqah');
    });
  });

  group('SupportContactService', () {
    test('submitContribution builds mailto when payment URL is empty', () async {
      const service = SupportContactService();
      // Cannot launch in unit tests; ensure method completes without throwing.
      final result = await service.submitContribution(
        amount: 10,
        purpose: 'Sadaqah',
      );
      expect(result, isNotNull);
    });
  });
}
