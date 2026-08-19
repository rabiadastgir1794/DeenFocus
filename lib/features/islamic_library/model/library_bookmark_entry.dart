import 'library_module.dart';

/// A bookmarked learning card resolved for display and navigation.
class LibraryBookmarkEntry {
  const LibraryBookmarkEntry({
    required this.sectionId,
    required this.cardIndex,
    required this.moduleId,
    required this.moduleLabel,
    required this.sectionLabel,
    required this.title,
    required this.preview,
    this.subSectionId,
  });

  final String sectionId;
  final int cardIndex;
  final LibraryModuleId moduleId;

  /// Collection / category / guide id when [sectionId] is prefixed.
  final String? subSectionId;
  final String moduleLabel;
  final String sectionLabel;
  final String title;
  final String preview;

  String get id => '$sectionId:$cardIndex';
}
