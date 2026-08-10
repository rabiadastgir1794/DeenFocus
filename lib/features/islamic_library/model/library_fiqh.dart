import '../../../l10n/app_localizations.dart';

class FiqhTopic {
  const FiqhTopic({
    required this.index,
    required this.title,
    required this.overview,
    required this.keyPoints,
    required this.differences,
    required this.commonGround,
  });

  final int index;
  final String title;
  final String overview;
  final String keyPoints;
  final String differences;
  final String commonGround;

  factory FiqhTopic.fromJson(Map<String, dynamic> json) {
    return FiqhTopic(
      index: json['index'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      keyPoints: json['keyPoints'] as String,
      differences: json['differences'] as String,
      commonGround: json['commonGround'] as String,
    );
  }

  String shareText(AppLocalizations l10n) =>
      '$title\n\n${l10n.libraryFiqhOverview}:\n$overview\n\n'
      '${l10n.libraryFiqhKeyPoints}:\n$keyPoints\n\n'
      '${l10n.libraryFiqhDifferences}:\n$differences\n\n'
      '${l10n.libraryFiqhCommonGround}:\n$commonGround';
}
