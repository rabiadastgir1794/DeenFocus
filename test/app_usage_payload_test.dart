import 'package:deenly/core/services/app_usage_service.dart';
import 'package:deenly/features/home/helpers/digital_balance_math.dart';
import 'package:deenly/features/home/model/digital_balance_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUsageService.parseAvailability', () {
    test('maps iOS Family Controls states without inventing granted data', () {
      expect(
        AppUsageService.parseAvailability('denied'),
        AppUsageAvailability.denied,
      );
      expect(
        AppUsageService.parseAvailability('notDetermined'),
        AppUsageAvailability.denied,
      );
      expect(
        AppUsageService.parseAvailability('unsupported'),
        AppUsageAvailability.unsupported,
      );
      expect(
        AppUsageService.parseAvailability('granted'),
        AppUsageAvailability.granted,
      );
    });
  });

  group('AppUsageService.isDeenFocus', () {
    test('uses the native flag when Apple exposes one', () {
      expect(
        AppUsageService.isDeenFocus(
          packageName: 'token-or-unknown',
          flagged: true,
        ),
        isTrue,
      );
    });

    test('compares the real host bundle id when Apple exposes one', () {
      expect(
        AppUsageService.isDeenFocus(
          packageName: 'com.rnr.deenfocus',
          flagged: false,
          hostBundleId: 'com.rnr.deenfocus',
        ),
        isTrue,
      );
      expect(
        AppUsageService.isDeenFocus(
          packageName: 'com.apple.MobileSMS',
          flagged: false,
          hostBundleId: 'com.rnr.deenfocus',
        ),
        isFalse,
      );
    });
  });

  group('AppUsageService.parseDays', () {
    test('skips zero usage and never invents rows', () {
      final days = AppUsageService.parseDays({
        'status': 'granted',
        'apps': {
          'com.rnr.deenfocus': {'appName': 'DeenFocus', 'isDeenFocus': true},
          'com.example.video': {'appName': 'Video', 'isDeenFocus': false},
        },
        'days': [
          {
            'date': '2026-08-22',
            'usage': {'com.rnr.deenfocus': 0, 'com.example.video': 0},
          },
        ],
      });
      expect(days, hasLength(1));
      expect(days.single.apps, isEmpty);
      expect(days.single.totalPhoneUsage, Duration.zero);
    });

    test('maps a real iOS-shaped payload into weekly snapshots', () {
      final days = AppUsageService.parseDays({
        'status': 'granted',
        'apps': {
          'com.rnr.deenfocus': {'appName': 'DeenFocus', 'isDeenFocus': true},
          'com.example.video': {'appName': 'Video', 'isDeenFocus': false},
        },
        'days': [
          {
            'date': '2026-08-10',
            'usage': {'com.rnr.deenfocus': 30 * 60 * 1000},
          },
          {
            'date': '2026-08-17',
            'usage': {
              'com.rnr.deenfocus': 20 * 60 * 1000,
              'com.example.video': 2 * 60 * 60 * 1000,
            },
          },
          {
            'date': '2026-08-22',
            'usage': {
              'com.rnr.deenfocus': 52 * 60 * 1000,
              'com.example.video': 2 * 60 * 60 * 1000,
            },
          },
        ],
      });

      final snapshot = DigitalBalanceMath.buildSnapshot(
        availability: AppUsageAvailability.granted,
        days: days,
        now: DateTime(2026, 8, 22),
        goalMinutes: 60,
      );

      expect(snapshot.todayDeen, const Duration(minutes: 52));
      expect(snapshot.todayOther, const Duration(hours: 2));
      expect(snapshot.thisWeek.length, 7);
      expect(snapshot.lastWeek.length, 7);
      expect(snapshot.weekDeen, const Duration(minutes: 72));
      expect(snapshot.lastWeekDeen, const Duration(minutes: 30));
      expect(
        DigitalBalanceMath.weekDeenIncreasePercent(
          const Duration(minutes: 72),
          const Duration(minutes: 30),
        ),
        140,
      );
      expect(
        DigitalBalanceMath.weekDeenIncreasePercent(
          snapshot.weekDeen,
          snapshot.lastWeekDeen,
        ),
        isNotNull,
      );
      expect(snapshot.topApps.first.isDeenFocus, isFalse);
      expect(snapshot.topApps.any((app) => app.isDeenFocus), isTrue);
    });

    test('hides week-over-week when last week has no DeenFocus usage', () {
      expect(
        DigitalBalanceMath.weekDeenIncreasePercent(
          const Duration(minutes: 40),
          Duration.zero,
        ),
        isNull,
      );
    });
  });
}
