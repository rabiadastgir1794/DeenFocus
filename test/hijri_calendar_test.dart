import 'package:deenly/features/home/helpers/home_islamic_events_helper.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/hijri_date_service.dart';
import 'package:deenly/features/home/services/hijri_local_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HijriLocalConverter', () {
    test('returns valid Hijri map for Aug 3 2026', () {
      final map = HijriLocalConverter.toHijriMap(DateTime(2026, 8, 3));
      expect(map['day'], isNotEmpty);
      expect(map['month'], isA<int>());
      expect((map['month'] as int) >= 1 && (map['month'] as int) <= 12, isTrue);
      expect(map['year'], isNotEmpty);
    });

    test('monthCalendar covers every day in August 2026', () {
      final days = HijriLocalConverter.monthCalendar(year: 2026, month: 8);
      expect(days, hasLength(31));
      expect(days.first.gregorian.day, 1);
      expect(days.last.gregorian.day, 31);
      expect(days.every((d) => d.hijriDay >= 1 && d.hijriDay <= 30), isTrue);
    });
  });

  group('HijriDateService local APIs', () {
    test('currentHijriLocal is synchronous', () {
      final map = HijriDateService.currentHijriLocal(DateTime(2026, 8, 3));
      expect(map['day'], isNot('…'));
      expect(map['month'], isPositive);
    });

    test('monthCalendarLocal matches converter', () {
      final days = HijriDateService.monthCalendarLocal(year: 2026, month: 8);
      expect(days, hasLength(31));
    });

    test('moonPhaseFromHijriDay returns bounded illumination', () {
      final info = HijriDateService.moonPhaseFromHijriDay(15);
      expect(info.illuminationPercent, inInclusiveRange(0, 100));
      expect(info.phaseFraction, inInclusiveRange(0.0, 1.0));
    });
  });

  group('HomeIslamicEventsHelper.majorUpcomingEvents', () {
    test('returns next occurrence per major kind', () {
      final events = <HomeIslamicEvent>[
        HomeIslamicEvent(
          date: DateTime(2026, 8, 25),
          title: 'Mawlid an-Nabi',
        ),
        HomeIslamicEvent(
          date: DateTime(2027, 2, 10),
          title: '1 Ramadan',
        ),
        HomeIslamicEvent(
          date: DateTime(2027, 3, 12),
          title: 'Eid al-Fitr',
        ),
        HomeIslamicEvent(
          date: DateTime(2026, 7, 1),
          title: 'Islamic New Year',
        ),
      ];

      final upcoming = HomeIslamicEventsHelper.majorUpcomingEvents(
        events,
        from: DateTime(2026, 8, 3),
      );

      expect(upcoming, isNotEmpty);
      expect(upcoming.first.date, DateTime(2026, 8, 25));
      expect(upcoming.map((e) => e.title), contains('1 Ramadan'));
    });

    test('skips past major events before anchor date', () {
      final events = <HomeIslamicEvent>[
        HomeIslamicEvent(
          date: DateTime(2026, 6, 1),
          title: 'Islamic New Year',
        ),
        HomeIslamicEvent(
          date: DateTime(2027, 6, 1),
          title: 'Islamic New Year',
        ),
      ];

      final upcoming = HomeIslamicEventsHelper.majorUpcomingEvents(
        events,
        from: DateTime(2026, 8, 3),
      );

      expect(upcoming.where((e) => e.date.year == 2026), isEmpty);
      expect(upcoming.any((e) => e.date.year == 2027), isTrue);
    });
  });
}
