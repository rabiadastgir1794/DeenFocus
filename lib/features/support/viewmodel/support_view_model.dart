import 'package:flutter/foundation.dart';

import '../../../core/config/support_config.dart';
import '../services/support_contact_service.dart';

class SupportViewModel extends ChangeNotifier {
  SupportViewModel({SupportContactService? contactService})
      : _contactService = contactService ?? const SupportContactService();

  final SupportContactService _contactService;

  int _amount = SupportConfig.defaultContributionAmount;
  String _purpose = '';
  bool _isSubmitting = false;
  bool _isOpeningContact = false;
  SupportLaunchResult? _lastResult;

  int get amount => _amount;
  String get purpose => _purpose;
  bool get isSubmitting => _isSubmitting;
  bool get isOpeningContact => _isOpeningContact;
  bool get isBusy => _isSubmitting || _isOpeningContact;
  SupportLaunchResult? get lastResult => _lastResult;

  static int get minAmount => SupportConfig.minContributionAmount;
  static int get maxAmount => SupportConfig.maxContributionAmount;
  static int get defaultContributionAmount =>
      SupportConfig.defaultContributionAmount;

  void setAmountFromSlider(double value) {
    final next = value.round().clamp(minAmount, maxAmount);
    if (next == _amount) return;
    _amount = next;
    _lastResult = null;
    notifyListeners();
  }

  void setAmountFromText(String raw) {
    final parsed = int.tryParse(raw.trim());
    if (parsed == null) return;
    final next = parsed.clamp(minAmount, maxAmount);
    if (next == _amount) return;
    _amount = next;
    _lastResult = null;
    notifyListeners();
  }

  void setPurpose(String value) {
    if (value == _purpose) return;
    _purpose = value;
    notifyListeners();
  }

  void clearLastResult() {
    if (_lastResult == null) return;
    _lastResult = null;
    notifyListeners();
  }

  Future<SupportLaunchResult> submitContribution() async {
    if (_isSubmitting) return SupportLaunchResult.failed;
    _isSubmitting = true;
    _lastResult = null;
    notifyListeners();

    final result = await _contactService.submitContribution(
      amount: _amount,
      purpose: _purpose,
    );

    _isSubmitting = false;
    _lastResult = result;
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

  Future<SupportLaunchResult> _openContact(
    Future<SupportLaunchResult> Function() action,
  ) async {
    if (_isOpeningContact) return SupportLaunchResult.failed;
    _isOpeningContact = true;
    _lastResult = null;
    notifyListeners();

    final result = await action();

    _isOpeningContact = false;
    _lastResult = result;
    notifyListeners();
    return result;
  }
}
