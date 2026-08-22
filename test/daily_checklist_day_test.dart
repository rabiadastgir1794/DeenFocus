import 'dart:convert';

import 'package:deenly/features/home/helpers/daily_checklist_day.dart';
import 'package:deenly/features/home/helpers/nightly_wrap_up_planner.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailyChecklistState migration', () {
    test('fromJson keeps existing ticks when new enum values are added', () {
      final json = jsonEncode({
        'dateKey': '2026-08-20',
        'completedItems': ['quran', 'dhikr', 'fajr', 'unknownLegacy'],
      });
      final state = DailyChecklistState.fromJson(json);
      expect(state.dateKey, '2026-08-20');
      expect(state.completedItems, {
        DailyChecklistItem.quran,
        DailyChecklistItem.dhikr,
        DailyChecklistItem.fajr,
      });
      expect(state.completedItems.contains(DailyChecklistItem.istighfar), isFalse);
      expect(state.completedItems.contains(DailyChecklistItem.salawat), isFalse);
    });
  });

  group('DailyChecklistDay progress', () {
    test('habit total excludes mirrored Fajr', () {
      expect(
        DailyChecklistDay.habitTotalCount(),
        DailyChecklistItem.values.length - 1,
      );
      expect(
        DailyChecklistDay.progressTotalCount(),
        TrackablePrayer.values.length + DailyChecklistDay.habitTotalCount(),
      );
    });

    test('progress does not double-count Fajr as a habit', () {
      expect(
        DailyChecklistDay.progressCompletedCount(
          checklist: {
            DailyChecklistItem.fajr,
            DailyChecklistItem.quran,
          },
          obligatoryPrayersDone: 1,
        ),
        2,
      );
    });

    test('stored habits without Fajr are checklist-complete', () {
      final habits = DailyChecklistItemX.storedHabits.toSet();
      expect(NightlyWrapUpPlanner.isChecklistIncomplete(habits), isFalse);
      expect(
        NightlyWrapUpPlanner.isChecklistIncomplete({DailyChecklistItem.fajr}),
        isTrue,
      );
    });
  });
}
