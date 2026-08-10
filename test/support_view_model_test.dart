import 'package:deenly/features/support/services/support_contact_service.dart';
import 'package:deenly/features/support/viewmodel/support_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupportViewModel', () {
    test('defaults to \$50 preset', () {
      final vm = SupportViewModel();
      expect(vm.amount, 50);
      expect(vm.amount, SupportViewModel.defaultContributionAmount);
    });

    test('selectAmount updates only valid presets', () {
      final vm = SupportViewModel();
      vm.selectAmount(25);
      expect(vm.amount, 25);
      vm.selectAmount(250);
      expect(vm.amount, 250);
      vm.selectAmount(15); // not a preset
      expect(vm.amount, 250);
    });

    test('presetAmounts match design', () {
      expect(
        SupportViewModel.presetAmounts,
        <int>[10, 25, 50, 100, 250],
      );
    });
  });

  group('SupportContactService', () {
    test('submitContribution completes without throwing', () async {
      const service = SupportContactService();
      final result = await service.submitContribution(amount: 50);
      expect(result, isNotNull);
    });
  });
}
