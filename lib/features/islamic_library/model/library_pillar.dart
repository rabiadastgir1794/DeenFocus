import '../../../core/share/content_share_payload.dart';
import '../../../l10n/app_localizations.dart';

class LibraryPillar {
  const LibraryPillar({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.body,
    this.arabic,
    this.reference,
  });

  final int index;
  final String title;
  final String subtitle;
  final String body;
  final String? arabic;
  final String? reference;

  factory LibraryPillar.fromJson(Map<String, dynamic> json) {
    return LibraryPillar(
      index: json['index'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      body: json['body'] as String,
      arabic: json['arabic'] as String?,
      reference: json['reference'] as String?,
    );
  }

  String shareText(AppLocalizations l10n) {
    final buffer = StringBuffer(title);
    if (arabic != null && arabic!.isNotEmpty) {
      buffer.writeln('\n$arabic');
    }
    buffer.writeln('\n$body');
    if (reference != null && reference!.isNotEmpty) {
      buffer.writeln('\n${l10n.libraryReference(reference!)}');
    }
    return buffer.toString();
  }

  ContentSharePayload sharePayload(AppLocalizations l10n) {
    return ContentSharePayload(
      title: title,
      paragraphs: [body],
      fields: [
        if (reference != null && reference!.isNotEmpty)
          ContentShareField(
            label: l10n.libraryShareReference,
            value: reference!,
          ),
      ],
    );
  }
}
