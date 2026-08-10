import '../../../l10n/app_localizations.dart';

class DuaCategory {
  const DuaCategory({
    required this.id,
    required this.itemCount,
    required this.items,
  });

  final String id;
  final int itemCount;
  final List<LibraryDua> items;

  factory DuaCategory.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return DuaCategory(
      id: json['id'] as String,
      itemCount: rawItems.length,
      items: rawItems
          .map((e) => LibraryDua.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  String progressSectionId(String modulePrefix) => '${modulePrefix}_$id';
}

class LibraryDua {
  const LibraryDua({
    required this.index,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.reference,
  });

  final int index;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String? reference;

  factory LibraryDua.fromJson(Map<String, dynamic> json) {
    return LibraryDua(
      index: json['index'] as int,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      reference: json['reference'] as String?,
    );
  }

  String shareText(AppLocalizations l10n) {
    final buffer = StringBuffer(
      '$arabic\n'
      '${l10n.libraryTransliteration}: $transliteration\n\n'
      '${l10n.libraryTranslation}:\n$translation',
    );
    if (reference != null && reference!.isNotEmpty) {
      buffer.writeln('\n${l10n.libraryReference(reference!)}');
    }
    return buffer.toString();
  }
}
