import 'package:flutter/foundation.dart';

import '../../../core/config/support_config.dart';
import '../model/support_contribution_result.dart';
import '../services/donation_purchase_service.dart';
import '../services/support_contact_service.dart';

class SupportViewModel extends ChangeNotifier {
  SupportViewModel({
    SupportContactService? contactService,
    DonationPurchaser? donationPurchaser,
  })  : _contactService = contactService ?? const SupportContactService(),
        _donationPurchaser =
            donationPurchaser ?? const SuperwallDonationPurchaser();

  final SupportContactService _contactService;
  final DonationPurchaser _donationPurchaser;

  int _amount = SupportConfig.defaultContributionAmount;
  bool _isSubmitting = false;
  bool _isOpeningContact = false;
  SupportLaunchResult? _lastLaunchResult;
  SupportContributionResult? _lastContributionResult;

  int get amount => _amount;
  bool get isSubmitting => _isSubmitting;
  bool get isOpeningContact => _isOpeningContact;
  bool get isBusy => _isSubmitting || _isOpeningContact;
  SupportLaunchResult? get lastResult => _lastLaunchResult;
  SupportContributionResult? get lastContributionResult =>
      _lastContributionResult;

  String? get selectedProductId => SupportConfig.productIdForAmount(_amount);

  static List<int> get presetAmounts => SupportConfig.contributionAmounts;
  static int get defaultContributionAmount =>
      SupportConfig.defaultContributionAmount;

  void selectAmount(int value) {
    if (!SupportConfig.contributionAmounts.contains(value)) return;
    if (value == _amount) return;
    _amount = value;
    _lastLaunchResult = null;
    _lastContributionResult = null;
    notifyListeners();
  }

  void clearLastResult() {
    if (_lastLaunchResult == null && _lastContributionResult == null) return;
    _lastLaunchResult = null;
    _lastContributionResult = null;
    notifyListeners();
  }

  /// One-time support payment. Never touches subscription / `pro` state.
  Future<SupportContributionResult> submitContribution() async {
    if (_isSubmitting) return SupportContributionResult.failed;
    _isSubmitting = true;
    _lastLaunchResult = null;
    _lastContributionResult = null;
    notifyListeners();

    SupportContributionResult result;
    try {
      final productId = SupportConfig.productIdForAmount(_amount);
      if (productId != null && _donationPurchaser.isAvailable) {
        result = await _donationPurchaser.purchase(productId);
      } else if (productId != null && !_donationPurchaser.isAvailable) {
        result = await _submitExternalContribution();
      } else {
        result = SupportContributionResult.productUnavailable;
      }
    } catch (_) {
      result = SupportContributionResult.failed;
    }

    _isSubmitting = false;
    _lastContributionResult = result;
    notifyListeners();
    return result;
  }

  Future<SupportLaunchResult> openWhatsApp(String message) async {
    return _openContact(
      () => _contactService.openWhatsApp(message: message),
    );
  }

  Future<SupportLaunchResult> openEmail({
    required String subject,
    String? body,
  }) async {
    return _openContact(
      () => _contactService.openEmail(subject: subject, body: body),
    );
  }

  Future<SupportContributionResult> _submitExternalContribution() async {
    final launch = await _contactService.submitContribution(amount: _amount);
    _lastLaunchResult = launch;
    return switch (launch) {
      SupportLaunchResult.launched =>
        SupportContributionResult.launchedExternally,
      SupportLaunchResult.unavailable =>
        SupportContributionResult.launchUnavailable,
      SupportLaunchResult.failed => SupportContributionResult.failed,
    };
  }

  Future<SupportLaunchResult> _openContact(
    Future<SupportLaunchResult> Function() action,
  ) async {
    if (_isOpeningContact) return SupportLaunchResult.failed;
    _isOpeningContact = true;
    _lastLaunchResult = null;
    notifyListeners();

    final result = await action();

    _isOpeningContact = false;
    _lastLaunchResult = result;
    notifyListeners();
    return result;
  }
}
