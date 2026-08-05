/// Support / donation configuration — values may be overridden via `--dart-define`.
abstract class SupportConfig {
  SupportConfig._();

  static const int minContributionAmount = 1;
  static const int maxContributionAmount = 100;
  static const int defaultContributionAmount = 10;

  static const String supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'rnr1710678@gmail.com',
  );

  /// E.164 digits only, e.g. `923001234567`. Empty → WhatsApp uses email fallback.
  static const String whatsAppNumber = String.fromEnvironment(
    'SUPPORT_WHATSAPP_NUMBER',
  );

  /// Optional hosted checkout URL. When empty, contributions open a prefilled email.
  static const String paymentUrl = String.fromEnvironment(
    'SUPPORT_PAYMENT_URL',
  );

  static bool get hasWhatsApp => whatsAppNumber.trim().isNotEmpty;
  static bool get hasPaymentUrl => paymentUrl.trim().isNotEmpty;
}
