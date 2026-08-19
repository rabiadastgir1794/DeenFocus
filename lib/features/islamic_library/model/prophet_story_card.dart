import '../../../l10n/app_localizations.dart';

class ProphetStoryCard {
  const ProphetStoryCard({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.body,
    this.lesson,
    this.quranReference,
  });

  final int index;
  final String title;
  final String subtitle;
  final String body;
  final String? lesson;
  final String? quranReference;

  factory ProphetStoryCard.fromJson(Map<String, dynamic> json) {
    return ProphetStoryCard(
      index: json['index'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      body: json['body'] as String,
      lesson: json['lesson'] as String?,
      quranReference: json['quranReference'] as String?,
    );
  }

  String shareText(AppLocalizations l10n) {
    final buffer = StringBuffer('$title\n$subtitle\n\n$body');
    if (lesson != null && lesson!.isNotEmpty) {
      buffer.writeln('\n\n${l10n.libraryKeyLesson}:\n$lesson');
    }
    if (quranReference != null && quranReference!.isNotEmpty) {
      buffer.writeln('\n${l10n.libraryReference(quranReference!)}');
    }
    return buffer.toString();
  }
}
