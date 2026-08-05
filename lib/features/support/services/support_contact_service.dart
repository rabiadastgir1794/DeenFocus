import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/support_config.dart';

enum SupportLaunchResult { launched, unavailable, failed }

/// Opens WhatsApp, email, or a contribution flow for Support Us.
class SupportContactService {
  const SupportContactService();

  Future<SupportLaunchResult> openWhatsApp({String? message}) async {
    final text = message?.trim();
    final encoded = text == null || text.isEmpty
        ? null
        : Uri.encodeComponent(text);

    final Uri uri;
    if (SupportConfig.hasWhatsApp) {
      final base = 'https://wa.me/${SupportConfig.whatsAppNumber}';
      uri = encoded == null ? Uri.parse(base) : Uri.parse('$base?text=$encoded');
    } else if (encoded != null) {
      uri = Uri.parse('https://wa.me/?text=$encoded');
    } else {
      return openEmail(
        subject: 'DeenFocus support',
        body: text,
      );
    }

    return _launch(uri);
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

  Future<SupportLaunchResult> submitContribution({
    required int amount,
    String? purpose,
  }) async {
    if (SupportConfig.hasPaymentUrl) {
      final uri = Uri.parse(SupportConfig.paymentUrl).replace(
        queryParameters: <String, String>{
          'amount': '$amount',
          if (purpose != null && purpose.trim().isNotEmpty)
            'purpose': purpose.trim(),
        },
      );
      return _launch(uri);
    }

    final purposeLine = purpose == null || purpose.trim().isEmpty
        ? ''
        : '\nPurpose: ${purpose.trim()}';
    return openEmail(
      subject: 'DeenFocus support — \$$amount',
      body:
          'Assalamu alaikum,\n\nI would like to support DeenFocus with a one-time contribution of \$$amount.$purposeLine\n\nJazakAllah khair.',
    );
  }

  Future<SupportLaunchResult> _launch(Uri uri) async {
    try {
      final can = await canLaunchUrl(uri);
      if (!can) return SupportLaunchResult.unavailable;
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      return launched ? SupportLaunchResult.launched : SupportLaunchResult.failed;
    } catch (_) {
      return SupportLaunchResult.failed;
    }
  }
}
