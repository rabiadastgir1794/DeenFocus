import 'package:deenly/features/home/helpers/digital_balance_math.dart';
import 'package:deenly/features/home/model/digital_balance_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DigitalBalanceMath.formatDuration', () {
    test('formats zero, minutes, hours, and mixed values', () {
      expect(DigitalBalanceMath.formatDuration(Duration.zero), '0m');
      expect(
        DigitalBalanceMath.formatDuration(const Duration(minutes: 52)),
        '52m',
      );
      expect(DigitalBalanceMath.formatDuration(const Duration(hours: 6)), '6h');
      expect(
        DigitalBalanceMath.formatDuration(
          const Duration(hours: 6, minutes: 42),
        ),
        '6h 42m',
      );
      expect(
        DigitalBalanceMath.formatDuration(
          const Duration(hours: 38, minutes: 20),
        ),
        '38h 20m',
      );
    });
  });

  group('DigitalBalanceMath.percentOf', () {
    test('returns 0 when total is zero', () {
      expect(
        DigitalBalanceMath.percentOf(
          const Duration(minutes: 52),
          Duration.zero,
        ),
        0,
      );
    });

    test('rounds DeenFocus share of phone time', () {
      expect(
        DigitalBalanceMath.percentOf(
          const Duration(minutes: 52),
          const Duration(hours: 6, minutes: 42),
        ),
        13,
      );
    });
  });

  group('DigitalBalanceMath.weekDeenIncreasePercent', () {
    test('hides comparison when last week is empty', () {
      expect(
        DigitalBalanceMath.weekDeenIncreasePercent(
          const Duration(hours: 5),
          Duration.zero,
        ),
        isNull,
      );
    });

    test('hides comparison when this week is not higher', () {
      expect(
        DigitalBalanceMath.weekDeenIncreasePercent(
          const Duration(hours: 4),
          const Duration(hours: 5),
        ),
        isNull,
      );
    });

    test('returns increase when this week is higher', () {
      expect(
        DigitalBalanceMath.weekDeenIncreasePercent(
          const Duration(minutes: 123),
          const Duration(hours: 1, minutes: 40),
        ),
        23,
      );
    });

    test('does not cap week-over-week growth at 100 percent', () {
      expect(
        DigitalBalanceMath.weekDeenIncreasePercent(
          const Duration(minutes: 72),
          const Duration(minutes: 30),
        ),
        140,
      );
    });
  });

  group('DigitalBalanceMath.insightFor', () {
    test('prefers yesterday increase over minutes today', () {
      final insight = DigitalBalanceMath.insightFor(
        todayDeen: const Duration(minutes: 59),
        yesterdayDeen: const Duration(minutes: 50),
        thisWeekDeen: const Duration(hours: 2),
        lastWeekDeen: const Duration(hours: 1),
      );
      expect(insight.kind, DigitalBalanceInsightKind.increasedVsYesterday);
      expect(insight.percent, 18);
    });

    test('uses minutes today when there is no yesterday gain', () {
      final insight = DigitalBalanceMath.insightFor(
        todayDeen: const Duration(minutes: 52),
        yesterdayDeen: const Duration(minutes: 60),
        thisWeekDeen: Duration.zero,
        lastWeekDeen: Duration.zero,
      );
      expect(insight.kind, DigitalBalanceInsightKind.minutesToday);
      expect(insight.duration, const Duration(minutes: 52));
    });

    test('uses quiet day when there is no DeenFocus time', () {
      final insight = DigitalBalanceMath.insightFor(
        todayDeen: Duration.zero,
        yesterdayDeen: Duration.zero,
        thisWeekDeen: Duration.zero,
        lastWeekDeen: Duration.zero,
      );
      expect(insight.kind, DigitalBalanceInsightKind.quietDay);
    });
  });

  group('DigitalBalanceMath.buildSnapshot', () {
    test('keeps DeenFocus in the top list and never invents usage', () {
      final monday = DateTime(2026, 8, 17);
      final today = DateTime(2026, 8, 22);
      final deen = AppUsageAppInfo(
        packageName: 'com.rnr.deenfocus',
        appName: 'DeenFocus',
        isDeenFocus: true,
      );
      final other = AppUsageAppInfo(
        packageName: 'com.example.video',
        appName: 'Video',
        isDeenFocus: false,
      );
      final snapshot = DigitalBalanceMath.buildSnapshot(
        availability: AppUsageAvailability.granted,
        days: [
          AppUsageDay(
            date: today,
            apps: [
              AppUsageEntry(
                info: other,
                usage: const Duration(hours: 2),
                date: today,
              ),
              AppUsageEntry(
                info: deen,
                usage: const Duration(minutes: 52),
                date: today,
              ),
            ],
          ),
          AppUsageDay(
            date: monday,
            apps: [
              AppUsageEntry(
                info: deen,
                usage: const Duration(minutes: 20),
                date: monday,
              ),
            ],
          ),
        ],
        now: today,
        goalMinutes: 60,
      );

      expect(snapshot.todayPhone, const Duration(hours: 2, minutes: 52));
      expect(snapshot.todayDeen, const Duration(minutes: 52));
      expect(snapshot.todayOther, const Duration(hours: 2));
      expect(snapshot.thisWeek.length, 7);
      expect(snapshot.thisWeek.first.date, monday);
      expect(snapshot.topApps.any((app) => app.isDeenFocus), isTrue);
      expect(snapshot.weekDeen, const Duration(minutes: 72));
      expect(
        DigitalBalanceMath.remainingToGoal(snapshot.todayDeen, 60),
        const Duration(minutes: 8),
      );
    });
  });
}
