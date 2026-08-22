import 'package:deenly/features/home/helpers/achievement_icon.dart';
import 'package:deenly/features/home/services/achievements_service.dart';
import 'package:deenly/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every achievement has a localized title and description', () {
    final l10n = AppLocalizationsEn();
    for (final id in AchievementId.values) {
      expect(AchievementsService.title(l10n, id), isNotEmpty);
      expect(AchievementsService.description(l10n, id), isNotEmpty);
      expect(achievementIcon(id), isNotNull);
    }
  });
}
