/// Support / donation configuration — values may be overridden via `--dart-define`.
///
/// Donations are one-time contributions and are completely separate from
/// Superwall / subscription products.
abstract class SupportConfig {
  SupportConfig._();

  /// Preset one-time support amounts (USD).
  static const List<int> contributionAmounts = <int>[10, 25, 50, 100, 250];

  static const int defaultContributionAmount = 50;
  static const int minContributionAmount = 10;
  static const int maxContributionAmount = 250;

  static const String supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'rnr1710678@gmail.com',
  );

  /// E.164 digits only, e.g. `923001234567`. Empty → WhatsApp uses email fallback.
  static const String whatsAppNumber = String.fromEnvironment(
    'SUPPORT_WHATSAPP_NUMBER',
  );

  /// Optional hosted checkout URL for one-time support.
  /// When empty, contributions open a prefilled email.
  /// Do not use Superwall subscription placements for donations.
  static const String paymentUrl = String.fromEnvironment(
    'SUPPORT_PAYMENT_URL',
  );

  static bool get hasWhatsApp => whatsAppNumber.trim().isNotEmpty;
  static bool get hasPaymentUrl => paymentUrl.trim().isNotEmpty;
}
