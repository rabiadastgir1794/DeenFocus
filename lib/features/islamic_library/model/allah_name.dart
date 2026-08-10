import '../../../l10n/app_localizations.dart';

class AllahName {
  const AllahName({
    required this.index,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.explanation,
    this.reflection,
  });

  final int index;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String explanation;
  final String? reflection;

  factory AllahName.fromJson(Map<String, dynamic> json) {
    return AllahName(
      index: json['index'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
      explanation: json['explanation'] as String,
      reflection: json['reflection'] as String?,
    );
  }

  String shareText(AppLocalizations l10n) {
    final buffer = StringBuffer(
      '$arabic\n$transliteration — ${l10n.libraryMeaning}: $meaning\n\n$explanation',
    );
    if (reflection != null && reflection!.isNotEmpty) {
      buffer.writeln('\n\n${l10n.libraryReflection}:\n$reflection');
    }
    return buffer.toString();
  }
}
