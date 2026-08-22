import 'package:deenly/core/services/app_notification_service.dart';
import 'package:deenly/features/home/helpers/daily_checklist_day.dart';
import 'package:deenly/features/home/helpers/home_prayer_times_helper.dart';
import 'package:deenly/features/home/helpers/nightly_wrap_up_planner.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'calculation_method': 'karachi',
      'asr_method': 'standard',
      'sect': 'sunni',
    });
  });

  group('NightlyWrapUpPlanner timing', () {
    test('schedules exactly 1 hour after Isha wall-clock minute', () {
      final isha = DateTime(2026, 8, 13, 20, 17, 45, 120);
      final when = NightlyWrapUpPlanner.wrapUpTimeFromIsha(isha);
      expect(when, DateTime(2026, 8, 13, 21, 17));
    });

    test('Isha + 1h matches generated prayer times for a fixed day', () async {
      final data = await HomePrayerTimesHelper.generatePrayerTimesForDate(
        latitude: 31.5204,
        longitude: 74.3587,
        date: DateTime(2026, 8, 13, 12),
      );
      final isha = data.slots.firstWhere((s) => s.id == HomePrayerId.isha).time;
      final when = NightlyWrapUpPlanner.wrapUpTimeFromIsha(isha);
      expect(when.difference(DateTime(
        isha.year,
        isha.month,
        isha.day,
        isha.hour,
        isha.minute,
      )), const Duration(hours: 1));
    });
  });

  group('NightlyWrapUpPlanner conditionality', () {
    final isha = DateTime(2026, 8, 13, 20, 30);

    Map<TrackablePrayer, PrayerMarkStatus> allHandled() => {
          for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
        };

    Set<DailyChecklistItem> allChecklist() => DailyChecklistItem.values.toSet();

    test('incomplete checklist only → checklist kind', () {
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: allHandled(),
        checklistCompleted: {DailyChecklistItem.fajr},
        skipForCycleMode: false,
      );
      expect(plan, isNotNull);
      expect(plan!.kind, NightlyWrapUpContentKind.checklist);
      expect(plan.when, DateTime(2026, 8, 13, 21, 30));
    });

    test('unmarked prayer → prayers kind', () {
      final statuses = allHandled()..[TrackablePrayer.isha] = PrayerMarkStatus.none;
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: statuses,
        checklistCompleted: allChecklist(),
        skipForCycleMode: false,
      );
      expect(plan!.kind, NightlyWrapUpContentKind.prayers);
    });

    test('missed prayer → prayers kind', () {
      final statuses = allHandled()
        ..[TrackablePrayer.asr] = PrayerMarkStatus.missed;
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: statuses,
        checklistCompleted: allChecklist(),
        skipForCycleMode: false,
      );
      expect(plan!.kind, NightlyWrapUpContentKind.prayers);
    });

    test('both incomplete → combined kind', () {
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: const {},
        checklistCompleted: const {},
        skipForCycleMode: false,
      );
      expect(plan!.kind, NightlyWrapUpContentKind.both);
    });

    test('everything complete → no notification', () {
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: allHandled(),
        checklistCompleted: allChecklist(),
        skipForCycleMode: false,
      );
      expect(plan, isNull);
    });

    test('stored habits without Fajr still complete the checklist reminder', () {
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: allHandled(),
        checklistCompleted: DailyChecklistItemX.storedHabits.toSet(),
        skipForCycleMode: false,
      );
      expect(plan, isNull);
    });

    test('completing everything cancels plan (null)', () {
      // Before: both open.
      expect(
        NightlyWrapUpPlanner.planForDay(
          ishaTime: isha,
          prayerStatuses: const {},
          checklistCompleted: const {},
          skipForCycleMode: false,
        ),
        isNotNull,
      );
      // After user finishes prayers + checklist before Isha+1h.
      expect(
        NightlyWrapUpPlanner.planForDay(
          ishaTime: isha,
          prayerStatuses: allHandled(),
          checklistCompleted: allChecklist(),
          skipForCycleMode: false,
        ),
        isNull,
      );
    });

    test('Sleep Mode / Night Discipline does not suppress planning', () {
      // Planner has no Sleep/Night input — plan still forms when incomplete.
      const nightDisciplineEnabled = true;
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: const {},
        checklistCompleted: const {},
        skipForCycleMode: false,
      );
      expect(nightDisciplineEnabled, isTrue);
      expect(plan, isNotNull);
    });

    test('Cycle Mode member day skips (existing reminder rule)', () {
      final policy = CycleModePolicy(
        CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 10),
          cycleLength: 7,
          pauseStreaks: true,
          excludeFromStatistics: true,
        ),
      );
      expect(policy.isCycleMember(DateTime(2026, 8, 13)), isTrue);
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: const {},
        checklistCompleted: const {},
        skipForCycleMode: policy.isCycleMember(DateTime(2026, 8, 13)),
      );
      expect(plan, isNull);
    });

    test('qada counts as handled for wrap-up', () {
      final statuses = {
        for (final p in TrackablePrayer.values) p: PrayerMarkStatus.qada,
      };
      final plan = NightlyWrapUpPlanner.planForDay(
        ishaTime: isha,
        prayerStatuses: statuses,
        checklistCompleted: allChecklist(),
        skipForCycleMode: false,
      );
      expect(plan, isNull);
    });
  });

  group('Nightly wrap-up notification IDs', () {
    test('do not overlap prayer soft notification IDs', () {
      for (var day = 0; day < 7; day++) {
        final wrapId = AppNotificationService.nightlyWrapUpNotificationIdFor(day);
        expect(AppNotificationService.isNightlyWrapUpNotificationId(wrapId), isTrue);
        expect(AppNotificationService.isPrayerSoftNotificationId(wrapId), isFalse);
        for (final prayer in const [
          HomePrayerId.fajr,
          HomePrayerId.dhuhr,
          HomePrayerId.asr,
          HomePrayerId.maghrib,
          HomePrayerId.isha,
        ]) {
          final prayerId =
              AppNotificationService.prayerNotificationIdFor(prayer, day);
          expect(wrapId, isNot(prayerId));
          expect(
            AppNotificationService.isNightlyWrapUpNotificationId(prayerId),
            isFalse,
          );
        }
      }
      expect(
        AppNotificationService.nightlyWrapUpNotificationIdFor(0),
        inInclusiveRange(5000, 5006),
      );
    });
  });

  group('DailyChecklistDay calendar reset', () {
    test('midnight rolls to a fresh day without carrying incomplete items', () {
      final aug13 = DailyChecklistState(
        dateKey: '2026-08-13',
        completedItems: {
          DailyChecklistItem.fajr,
          DailyChecklistItem.quran,
        },
      );
      final afterMidnight = DailyChecklistDay.resolveForToday(
        stored: aug13,
        now: DateTime(2026, 8, 14, 0, 0),
      );
      expect(afterMidnight.dateKey, '2026-08-14');
      expect(afterMidnight.completedItems, isEmpty);
    });

    test('resume at 2 AM before Fajr uses calendar day', () {
      final resolved = DailyChecklistDay.resolveForToday(
        stored: const DailyChecklistState(
          dateKey: '2026-08-13',
          completedItems: {DailyChecklistItem.dhikr},
        ),
        now: DateTime(2026, 8, 14, 2, 0),
      );
      expect(resolved.dateKey, '2026-08-14');
      expect(resolved.completedItems, isEmpty);
    });

    test('cold start after Fajr still uses calendar day', () {
      final resolved = DailyChecklistDay.resolveForToday(
        stored: const DailyChecklistState(
          dateKey: '2026-08-13',
          completedItems: {DailyChecklistItem.charity},
        ),
        now: DateTime(2026, 8, 14, 7, 30),
      );
      expect(resolved.dateKey, '2026-08-14');
      expect(resolved.completedItems, isEmpty);
    });

    test('same calendar day keeps completed items', () {
      final stored = DailyChecklistState(
        dateKey: '2026-08-14',
        completedItems: {DailyChecklistItem.morningAdhkar},
      );
      final resolved = DailyChecklistDay.resolveForToday(
        stored: stored,
        now: DateTime(2026, 8, 14, 22, 0),
      );
      expect(resolved.completedItems, stored.completedItems);
    });

    test('history date key remains distinct from reset day', () {
      // History is keyed separately; reset only clears today's UI state.
      const history = <String, Set<DailyChecklistItem>>{
        '2026-08-13': {DailyChecklistItem.fajr, DailyChecklistItem.quran},
      };
      final today = DailyChecklistDay.resolveForToday(
        stored: const DailyChecklistState(
          dateKey: '2026-08-13',
          completedItems: {DailyChecklistItem.fajr, DailyChecklistItem.quran},
        ),
        now: DateTime(2026, 8, 14, 9, 0),
      );
      expect(history['2026-08-13'], isNotEmpty);
      expect(today.dateKey, '2026-08-14');
      expect(today.completedItems, isEmpty);
    });

    test('needsReset is true across midnight while VM stays alive', () {
      final current = const DailyChecklistState(
        dateKey: '2026-08-13',
        completedItems: {DailyChecklistItem.smileAtSomeone},
      );
      expect(
        DailyChecklistDay.needsReset(
          current: current,
          now: DateTime(2026, 8, 14, 0, 1),
        ),
        isTrue,
      );
      expect(
        DailyChecklistDay.needsReset(
          current: current,
          now: DateTime(2026, 8, 13, 23, 59),
        ),
        isFalse,
      );
    });
  });
}
