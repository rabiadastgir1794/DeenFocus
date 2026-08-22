import 'package:flutter/material.dart';

import '../services/achievements_service.dart';

IconData achievementIcon(AchievementId id) {
  switch (id) {
    case AchievementId.firstPrayer:
      return Icons.star_rounded;
    case AchievementId.sevenPrayerStreak:
      return Icons.calendar_view_week_rounded;
    case AchievementId.thirtyPrayerStreak:
      return Icons.workspace_premium_rounded;
    case AchievementId.fajrWarrior:
      return Icons.wb_twilight_rounded;
    case AchievementId.fajrChampion:
      return Icons.emoji_events_rounded;
    case AchievementId.fiveADay:
      return Icons.mosque_rounded;
    case AchievementId.perfectWeek:
      return Icons.calendar_month_rounded;
    case AchievementId.perfectMonth:
      return Icons.event_available_rounded;
    case AchievementId.quranReader:
    case AchievementId.quranDevotee:
      return Icons.menu_book_rounded;
    case AchievementId.dhikrStarter:
    case AchievementId.dhikrMaster:
      return Icons.spa_rounded;
    case AchievementId.nightWorshipper:
      return Icons.nights_stay_rounded;
    case AchievementId.masjidCompanion:
      return Icons.location_on_rounded;
    case AchievementId.distractionDefender:
    case AchievementId.cycleGuardian:
    case AchievementId.protectedMonth:
      return Icons.shield_rounded;
    case AchievementId.consistencyChampion:
      return Icons.emoji_events_rounded;
    case AchievementId.sixMonthJourney:
      return Icons.flag_rounded;
    case AchievementId.deenfocusMaster:
      return Icons.military_tech_rounded;
  }
}
