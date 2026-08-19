import '../../../l10n/app_localizations.dart';

class HadithCollection {
  const HadithCollection({
    required this.id,
    required this.itemCount,
    required this.items,
  });

  final String id;
  final int itemCount;
  final List<LibraryHadith> items;

  factory HadithCollection.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return HadithCollection(
      id: json['id'] as String,
      itemCount: json['itemCount'] as int? ?? rawItems.length,
      items: rawItems
          .map((e) => LibraryHadith.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  String progressSectionId(String modulePrefix) => '${modulePrefix}_$id';
}

class LibraryHadith {
  const LibraryHadith({
    required this.index,
    required this.title,
    required this.translation,
    required this.narrator,
    required this.source,
    this.arabic,
  });

  final int index;
  final String title;
  final String translation;
  final String narrator;
  final String source;
  final String? arabic;

  factory LibraryHadith.fromJson(Map<String, dynamic> json) {
    return LibraryHadith(
      index: json['index'] as int,
      title: json['title'] as String,
      translation: json['translation'] as String,
      narrator: json['narrator'] as String,
      source: json['source'] as String,
      arabic: json['arabic'] as String?,
    );
  }

  String shareText(AppLocalizations l10n) {
    final buffer = StringBuffer(title);
    if (arabic != null && arabic!.isNotEmpty) {
      buffer.writeln('\n$arabic');
    }
    buffer.writeln('\n${l10n.libraryTranslation}:\n$translation');
    buffer.writeln('\n${l10n.libraryHadithNarrator} $narrator');
    buffer.writeln('${l10n.libraryHadithSource} $source');
    return buffer.toString();
  }
}
