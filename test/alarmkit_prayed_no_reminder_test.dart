import 'package:deenly/core/services/storage_service.dart';
import 'package:deenly/core/services/widget_sync_service.dart';
import 'package:deenly/features/focus/viewmodel/focus_controller.dart';
import 'package:deenly/features/home/helpers/prayer_reminder_prompt_keys.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/viewmodel/home_tab_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tip prayer for analytics fallback hours when no schedule is loaded.
TrackablePrayer? _tipPrayer(DateTime now) {
  const hours = [5, 12, 15, 18, 20];
  final prayers = TrackablePrayer.values;
  TrackablePrayer? tip;
  for (var i = 0; i < prayers.length; i++) {
    if (now.hour >= hours[i]) tip = prayers[i];
  }
  return tip;
}

HomePrayerTimesData _scheduleWhereTipHasStarted(DateTime now, TrackablePrayer tip) {
  const hours = [5, 12, 15, 18, 20];
  final slots = <HomePrayerSlot>[
    for (var i = 0; i < TrackablePrayer.values.length; i++)
      HomePrayerSlot(
        id: TrackablePrayer.values[i].homePrayerId,
        time: DateTime(now.year, now.month, now.day, hours[i]),
      ),
  ];
  final tipIndex = TrackablePrayer.values.indexOf(tip);
  final next = tipIndex + 1 < TrackablePrayer.values.length
      ? TrackablePrayer.values[tipIndex + 1]
      : null;
  return HomePrayerTimesData(
    slots: slots,
    nextPrayer: next?.homePrayerId,
    nextPrayerTime: next == null
        ? null
        : DateTime(now.year, now.month, now.day, hours[tipIndex + 1]),
    remaining: const Duration(hours: 1),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    WidgetSyncService.debugDisableTimelineSync = true;
    FocusController.debugUnlockAppsAfterPrayerMarked = () async {};
  });

  tearDown(() {
    FocusController.debugUnlockAppsAfterPrayerMarked = null;
    WidgetSyncService.debugDisableTimelineSync = false;
  });

  group('AlarmKit I\'ve Prayed → app closed → reopen → no confirmation', () {
    test(
      'applyAlarmPrayedAction marks once; remount has no soft reminder target',
      () async {
        final now = DateTime.now();
        final tip = _tipPrayer(now);
        if (tip == null) return;

        final schedule = _scheduleWhereTipHasStarted(now, tip);

        final cold = HomeTabViewModel();
        await cold.ensurePrayerStreakReady();
        cold.debugSetPrayerTimesForTest(schedule);

        // Before AlarmKit: soft reminder would target the tip.
        expect(cold.getPrayerReminderTarget(now: now), tip);

        final before = cold.prayerStreak;
        final first = await cold.applyAlarmPrayedAction(tip);
        expect(first, isNotNull);
        expect(first!.status, PrayerMarkStatus.onTime);
        expect(first.celebrated, isTrue);
        expect(cold.prayerStreak, before + 1);
        expect(cold.statusForToday(tip), PrayerMarkStatus.onTime);
        expect(cold.getPrayerReminderTarget(now: now), isNull);

        // Duplicate AlarmKit delivery must not celebrate / double streak.
        final second = await cold.applyAlarmPrayedAction(tip);
        expect(second, isNull);
        expect(cold.prayerStreak, before + 1);

        final prompted = await StorageService.prayerReminderPromptedKeys;
        expect(prompted.contains(PrayerReminderPromptKeys.forPrayer(tip)), isTrue);

        // App completely closed → new process/VM loads persisted streak.
        final reopened = HomeTabViewModel();
        await reopened.ensurePrayerStreakReady();
        reopened.debugSetPrayerTimesForTest(schedule);

        expect(reopened.statusForToday(tip), PrayerMarkStatus.onTime);
        expect(reopened.prayerStreak, before + 1);
        expect(reopened.getPrayerReminderTarget(now: now), isNull);
        expect(reopened.shouldShowPrayerReminder(tip), isFalse);
      },
    );

    test(
      'concurrent streak reload cannot wipe AlarmKit on-time mark',
      () async {
        final now = DateTime.now();
        final tip = _tipPrayer(now);
        if (tip == null) return;

        final schedule = _scheduleWhereTipHasStarted(now, tip);
        final vm = HomeTabViewModel();
        await vm.ensurePrayerStreakReady();
        vm.debugSetPrayerTimesForTest(schedule);

        final reload = vm.ensurePrayerStreakReady();
        final mark = vm.applyAlarmPrayedAction(tip);
        await Future.wait<void>([reload, mark.then((_) {})]);

        expect(vm.statusForToday(tip), PrayerMarkStatus.onTime);
        expect(vm.getPrayerReminderTarget(now: now), isNull);

        final reopened = HomeTabViewModel();
        await reopened.ensurePrayerStreakReady();
        reopened.debugSetPrayerTimesForTest(schedule);
        expect(reopened.statusForToday(tip), PrayerMarkStatus.onTime);
        expect(reopened.getPrayerReminderTarget(now: now), isNull);
      },
    );

    test('success celebration flag is false on remount remount mark', () async {
      final now = DateTime.now();
      final tip = _tipPrayer(now);
      if (tip == null) return;

      final firstVm = HomeTabViewModel();
      await firstVm.ensurePrayerStreakReady();
      final r1 = await firstVm.applyAlarmPrayedAction(tip);
      expect(r1?.celebrated, isTrue);
      final streak = firstVm.prayerStreak;

      final secondVm = HomeTabViewModel();
      await secondVm.ensurePrayerStreakReady();
      final r2 = await secondVm.applyAlarmPrayedAction(tip);
      expect(r2, isNull);
      expect(secondVm.prayerStreak, streak);
    });
  });
}
