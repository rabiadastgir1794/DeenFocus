import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/viewmodel/home_tab_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tip prayer for analytics fallback hours when no schedule is loaded:
/// Fajr≥5, Dhuhr≥12, Asr≥15, Maghrib≥18, Isha≥20.
TrackablePrayer? _tipPrayer(DateTime now) {
  const hours = [5, 12, 15, 18, 20];
  final prayers = TrackablePrayer.values;
  TrackablePrayer? tip;
  for (var i = 0; i < prayers.length; i++) {
    if (now.hour >= hours[i]) tip = prayers[i];
  }
  return tip;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Yes-equivalent on-time mark celebrates once when tip streak increases',
      () async {
    final now = DateTime.now();
    final tip = _tipPrayer(now);
    // Before Fajr (fallback), there is no tip — skip flaky pre-dawn window.
    if (tip == null) return;

    final vm = HomeTabViewModel();
    final before = vm.prayerStreak;

    final first = await vm.markPrayerStatus(
      now,
      tip,
      PrayerMarkStatus.onTime,
    );
    expect(first, isNotNull);
    expect(first!.status, PrayerMarkStatus.onTime);
    expect(first.celebrated, isTrue);
    expect(first.prayerStreak, greaterThan(before));
    expect(vm.statusForToday(tip), PrayerMarkStatus.onTime);

    // Re-marking the same prayer on-time must not re-celebrate / double-count.
    final second = await vm.markPrayerStatus(
      now,
      tip,
      PrayerMarkStatus.onTime,
    );
    expect(second, isNotNull);
    expect(second!.celebrated, isFalse);
    expect(second.prayerStreak, first.prayerStreak);
    expect(vm.statusForToday(tip), PrayerMarkStatus.onTime);
  });

  test('Qada increases counting status but never celebrates', () async {
    final now = DateTime.now();
    final tip = _tipPrayer(now);
    if (tip == null) return;

    final vm = HomeTabViewModel();
    final result = await vm.markPrayerStatus(
      now,
      tip,
      PrayerMarkStatus.qada,
    );

    expect(result, isNotNull);
    expect(result!.status, PrayerMarkStatus.qada);
    expect(result.celebrated, isFalse);
    expect(vm.statusForToday(tip), PrayerMarkStatus.qada);
  });

  test('Missed never celebrates', () async {
    final now = DateTime.now();
    final tip = _tipPrayer(now);
    if (tip == null) return;

    final vm = HomeTabViewModel();
    final result = await vm.markPrayerStatus(
      now,
      tip,
      PrayerMarkStatus.missed,
    );

    expect(result, isNotNull);
    expect(result!.celebrated, isFalse);
    expect(vm.statusForToday(tip), PrayerMarkStatus.missed);
  });

  test('Cycle Mode member day suppresses reminder target', () async {
    final vm = HomeTabViewModel();
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);

    await vm.saveCycleMode(
      CycleModeData(
        isEnabled: true,
        startDate: day,
        cycleLength: 5,
        pauseStreaks: true,
        excludeFromStatistics: true,
      ),
    );

    expect(vm.cyclePolicy.isCycleMember(day), isTrue);
    expect(
      vm.getPrayerReminderTarget(now: day.add(const Duration(hours: 12))),
      isNull,
    );
  });

  test('after Cycle Mode expires, membership no longer blocks today', () async {
    final vm = HomeTabViewModel();
    final start = DateTime(2026, 8, 11);
    final afterEnd = DateTime(2026, 8, 15);

    await vm.saveCycleMode(
      CycleModeData(
        isEnabled: true,
        startDate: start,
        cycleLength: 4,
        pauseStreaks: true,
        excludeFromStatistics: true,
      ).expireFully(),
    );

    expect(vm.cyclePolicy.isCycleMember(start), isTrue);
    expect(vm.cyclePolicy.isCycleMember(afterEnd), isFalse);
    expect(vm.cyclePolicy.isTodayProtected(now: afterEnd), isFalse);
  });

  test('on-time mark persists to SharedPreferences', () async {
    final now = DateTime.now();
    final tip = _tipPrayer(now);
    if (tip == null) return;

    final vm = HomeTabViewModel();
    await vm.markPrayerStatus(now, tip, PrayerMarkStatus.onTime);
    expect(vm.statusForToday(tip), PrayerMarkStatus.onTime);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('home_prayer_streak_json');
    expect(raw, isNotNull);
    expect(raw!, contains(tip.name));
    expect(raw, contains('onTime'));
  });
}
