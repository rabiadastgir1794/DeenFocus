import '../../../l10n/app_localizations.dart';

class PrayerGuide {
  const PrayerGuide({
    required this.id,
    required this.itemCount,
    required this.steps,
  });

  final String id;
  final int itemCount;
  final List<GuideStep> steps;

  factory PrayerGuide.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return PrayerGuide(
      id: json['id'] as String,
      itemCount: json['itemCount'] as int? ?? rawItems.length,
      steps: rawItems
          .map((e) => GuideStep.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  String progressSectionId(String modulePrefix) => '${modulePrefix}_$id';
}

class GuideStep {
  const GuideStep({
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  factory GuideStep.fromJson(Map<String, dynamic> json) {
    return GuideStep(
      index: json['index'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  String shareText(
    AppLocalizations l10n,
    String guideTitle, {
    required int totalSteps,
  }) =>
      '$guideTitle — ${l10n.libraryGuideStepLabel(index, totalSteps)}: '
      '$title\n\n$description';
}

class IslamicOccasion {
  const IslamicOccasion({
    required this.index,
    required this.title,
    required this.importance,
    required this.virtues,
    required this.recommendedActs,
  });

  final int index;
  final String title;
  final String importance;
  final String virtues;
  final String recommendedActs;

  factory IslamicOccasion.fromJson(Map<String, dynamic> json) {
    return IslamicOccasion(
      index: json['index'] as int,
      title: json['title'] as String,
      importance: json['importance'] as String,
      virtues: json['virtues'] as String,
      recommendedActs: json['recommendedActs'] as String,
    );
  }

  String shareText(AppLocalizations l10n) =>
      '$title\n\n${l10n.libraryOccasionImportance}:\n$importance\n\n'
      '${l10n.libraryOccasionVirtues}:\n$virtues\n\n'
      '${l10n.libraryOccasionRecommendedActs}:\n$recommendedActs';
}
