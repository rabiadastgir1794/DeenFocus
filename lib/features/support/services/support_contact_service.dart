import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/support_config.dart';

enum SupportLaunchResult { launched, unavailable, failed }

/// Opens WhatsApp, email, or a contribution flow for Support Us.
class SupportContactService {
  const SupportContactService();

  Future<SupportLaunchResult> openWhatsApp({String? message}) async {
    final text = message?.trim() ?? '';
    final digits = SupportConfig.normalizedWhatsAppNumber;

    if (digits.isEmpty) {
      return openEmail(
        subject: 'DeenFocus support',
        body: text.isEmpty ? null : text,
      );
    }

    for (final uri in whatsAppLaunchUris(digits: digits, text: text)) {
      final result = await _launch(uri, checkCanLaunch: false);
      if (result == SupportLaunchResult.launched) return result;
    }

    return openEmail(
      subject: 'DeenFocus support',
      body: text.isEmpty ? null : text,
    );
  }

  /// Native scheme first (installed app), then https click-to-chat (Play/App Store
  /// / in-app browser if WhatsApp is missing).
  static List<Uri> whatsAppLaunchUris({
    required String digits,
    String text = '',
  }) {
    final phone = digits.replaceAll(RegExp(r'\D'), '');
    final query = <String, String>{
      'phone': phone,
      if (text.isNotEmpty) 'text': text,
    };
    return <Uri>[
      Uri(scheme: 'whatsapp', host: 'send', queryParameters: query),
      Uri.https('wa.me', '/$phone', {
        if (text.isNotEmpty) 'text': text,
      }),
      Uri.https('api.whatsapp.com', '/send', query),
    ];
  }

  Future<SupportLaunchResult> openEmail({
    String? subject,
    String? body,
  }) async {
    final queryParameters = <String, String>{
      if (subject != null && subject.isNotEmpty) 'subject': subject,
      if (body != null && body.isNotEmpty) 'body': body,
    };
    final uri = Uri(
      scheme: 'mailto',
      path: SupportConfig.supportEmail,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    return _launch(uri);
  }

  /// Launches one-time support checkout (hosted URL) or a prefilled email.
  /// Never interacts with Superwall or subscription products.
  Future<SupportLaunchResult> submitContribution({
    required int amount,
  }) async {
    if (SupportConfig.hasPaymentUrl) {
      final uri = Uri.parse(SupportConfig.paymentUrl).replace(
        queryParameters: <String, String>{
          'amount': '$amount',
          'type': 'one_time_support',
        },
      );
      return _launch(uri);
    }

    return openEmail(
      subject: 'DeenFocus support — \$$amount',
      body:
          'Assalamu alaikum,\n\nI would like to support DeenFocus with a one-time contribution of \$$amount.\n\nJazakAllah khair.',
    );
  }

  Future<SupportLaunchResult> _launch(
    Uri uri, {
    bool checkCanLaunch = true,
  }) async {
    try {
      if (checkCanLaunch) {
        final can = await canLaunchUrl(uri);
        if (!can) return SupportLaunchResult.unavailable;
      }
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return launched ? SupportLaunchResult.launched : SupportLaunchResult.failed;
    } catch (_) {
      return SupportLaunchResult.failed;
    }
  }
}
