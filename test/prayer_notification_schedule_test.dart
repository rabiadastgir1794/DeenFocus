import 'package:deenly/core/services/app_notification_service.dart';
import 'package:deenly/features/home/helpers/home_prayer_times_helper.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  group('prayer notification IDs', () {
    test('are stable and unique for all five prayers across day offsets', () {
      const prayers = <HomePrayerId>[
        HomePrayerId.fajr,
        HomePrayerId.dhuhr,
        HomePrayerId.asr,
        HomePrayerId.maghrib,
        HomePrayerId.isha,
      ];
      final ids = <int>{};
      for (var day = 0; day < 7; day++) {
        for (final prayer in prayers) {
          final id = AppNotificationService.prayerNotificationIdFor(prayer, day);
          expect(id, inInclusiveRange(1000, 1199));
          expect(ids.add(id), isTrue, reason: 'duplicate id=$id');
        }
      }
      // Same prayer tomorrow must not reuse today's id.
      expect(
        AppNotificationService.prayerNotificationIdFor(HomePrayerId.fajr, 0),
        isNot(
          AppNotificationService.prayerNotificationIdFor(HomePrayerId.fajr, 1),
        ),
      );
    });

    test('maps slot index order Fajr < Dhuhr < Asr < Maghrib < Isha', () {
      final fajr = AppNotificationService.prayerNotificationIdFor(
        HomePrayerId.fajr,
        0,
      );
      final dhuhr = AppNotificationService.prayerNotificationIdFor(
        HomePrayerId.dhuhr,
        0,
      );
      final asr = AppNotificationService.prayerNotificationIdFor(
        HomePrayerId.asr,
        0,
      );
      final maghrib = AppNotificationService.prayerNotificationIdFor(
        HomePrayerId.maghrib,
        0,
      );
      final isha = AppNotificationService.prayerNotificationIdFor(
        HomePrayerId.isha,
        0,
      );
      expect(fajr, lessThan(dhuhr));
      expect(dhuhr, lessThan(asr));
      expect(asr, lessThan(maghrib));
      expect(maghrib, lessThan(isha));
    });
  });

  group('prayer time calculation for notifications', () {
    test('produces five trackable slots on a fixed calendar day', () async {
      final data = await HomePrayerTimesHelper.generatePrayerTimesForDate(
        latitude: 31.5204,
        longitude: 74.3587,
        date: DateTime(2026, 8, 11, 12),
      );
      final trackable = data.slots
          .where((slot) => slot.id != HomePrayerId.sunrise)
          .toList();
      expect(trackable.map((s) => s.id), [
        HomePrayerId.fajr,
        HomePrayerId.dhuhr,
        HomePrayerId.asr,
        HomePrayerId.maghrib,
        HomePrayerId.isha,
      ]);
      // Times are local wall clocks truncated to the minute (no seconds).
      for (final slot in trackable) {
        expect(slot.time.isUtc, isFalse);
        expect(slot.time.second, 0);
        expect(slot.time.millisecond, 0);
      }
      // Chronological order for the same local day.
      for (var i = 1; i < trackable.length; i++) {
        expect(
          trackable[i].time.isAfter(trackable[i - 1].time),
          isTrue,
          reason: '${trackable[i].id} should be after ${trackable[i - 1].id}',
        );
      }
    });

    test('generatePrayerTimesForDateWithOverrides applies custom Asr', () async {
      final date = DateTime(2026, 8, 11, 12);
      final overridden =
          await HomePrayerTimesHelper.generatePrayerTimesForDateWithOverrides(
            latitude: 31.5204,
            longitude: 74.3587,
            date: date,
            overridesMinutesSinceMidnight: const {
              TrackablePrayer.asr: 16 * 60, // 4:00 PM
            },
          );
      final asr = overridden.slots.firstWhere(
        (slot) => slot.id == HomePrayerId.asr,
      );
      expect(asr.time.hour, 16);
      expect(asr.time.minute, 0);
      expect(asr.time.day, 11);
    });

    test('custom override replaces only that prayer wall time', () async {
      final base = await HomePrayerTimesHelper.generatePrayerTimesForDate(
        latitude: 31.5204,
        longitude: 74.3587,
        date: DateTime(2026, 8, 11, 12),
      );
      final overridden = HomePrayerTimesHelper.applyCustomOverrides(
        data: base,
        overridesMinutesSinceMidnight: const {
          TrackablePrayer.maghrib: 18 * 60 + 5, // 18:05
        },
        referenceTime: DateTime(2026, 8, 11, 12),
      );
      final maghrib = overridden.slots.firstWhere(
        (slot) => slot.id == HomePrayerId.maghrib,
      );
      expect(maghrib.time.hour, 18);
      expect(maghrib.time.minute, 5);
      final fajr = overridden.slots.firstWhere(
        (slot) => slot.id == HomePrayerId.fajr,
      );
      final baseFajr = base.slots.firstWhere(
        (slot) => slot.id == HomePrayerId.fajr,
      );
      expect(fajr.time, baseFajr.time);
    });

    test('adjacent calendar days produce distinct local dates', () async {
      final day0 = await HomePrayerTimesHelper.generatePrayerTimesForDate(
        latitude: 31.5204,
        longitude: 74.3587,
        date: DateTime(2026, 8, 11, 12),
      );
      final day1 = await HomePrayerTimesHelper.generatePrayerTimesForDate(
        latitude: 31.5204,
        longitude: 74.3587,
        date: DateTime(2026, 8, 12, 12),
      );
      final fajr0 = day0.slots.firstWhere((s) => s.id == HomePrayerId.fajr);
      final fajr1 = day1.slots.firstWhere((s) => s.id == HomePrayerId.fajr);
      expect(fajr0.time.day, 11);
      expect(fajr1.time.day, 12);
      expect(fajr1.time.isAfter(fajr0.time), isTrue);
    });
  });

  group('iOS pending-cap prioritization', () {
    PrayerScheduleCandidate candidate({
      required int id,
      required DateTime when,
    }) {
      return PrayerScheduleCandidate(
        id: id,
        when: when,
        title: 't$id',
        body: 'b$id',
        details: const NotificationDetails(),
        payload: 'prayer:$id',
      );
    }

    test('keeps nearest upcoming prayers when room is partial day', () {
      final now = DateTime(2026, 8, 11, 12, 0);
      final selected = AppNotificationService.prioritizeNearestPrayerSlots(
        candidates: [
          candidate(id: 1, when: DateTime(2026, 8, 11, 13, 0)), // Dhuhr
          candidate(id: 2, when: DateTime(2026, 8, 11, 16, 0)), // Asr
          candidate(id: 3, when: DateTime(2026, 8, 11, 18, 0)), // Maghrib
          candidate(id: 4, when: DateTime(2026, 8, 11, 20, 0)), // Isha
          candidate(id: 5, when: DateTime(2026, 8, 12, 4, 30)), // next Fajr
        ],
        room: 3, // fewer than a full day of 5
        now: now,
      );
      expect(selected.map((c) => c.id), [1, 2, 3]);
    });

    test('skips past prayers and sorts soonest first', () {
      final now = DateTime(2026, 8, 11, 17, 0);
      final selected = AppNotificationService.prioritizeNearestPrayerSlots(
        candidates: [
          candidate(id: 10, when: DateTime(2026, 8, 12, 5, 0)),
          candidate(id: 11, when: DateTime(2026, 8, 11, 5, 0)), // past
          candidate(id: 12, when: DateTime(2026, 8, 11, 18, 30)),
          candidate(id: 13, when: DateTime(2026, 8, 11, 20, 0)),
        ],
        room: 10,
        now: now,
      );
      expect(selected.map((c) => c.id), [12, 13, 10]);
    });

    test('room zero selects nothing', () {
      final selected = AppNotificationService.prioritizeNearestPrayerSlots(
        candidates: [
          candidate(id: 1, when: DateTime(2026, 8, 11, 18, 0)),
        ],
        room: 0,
        now: DateTime(2026, 8, 11, 12, 0),
      );
      expect(selected, isEmpty);
    });

    test('protect count matches upcoming prayers and never exceeds reserve', () {
      expect(
        AppNotificationService.iosPrayerSlotsToProtect(futureCandidateCount: 0),
        0,
      );
      expect(
        AppNotificationService.iosPrayerSlotsToProtect(futureCandidateCount: 3),
        3,
      );
      expect(
        AppNotificationService.iosPrayerSlotsToProtect(futureCandidateCount: 15),
        15,
      );
      expect(
        AppNotificationService.iosPrayerSlotsToProtect(futureCandidateCount: 20),
        15,
      );
    });

    test('fewer than 15 free slots still keeps nearest prayers', () {
      final now = DateTime(2026, 8, 11, 12, 0);
      final selected = AppNotificationService.prioritizeNearestPrayerSlots(
        candidates: [
          for (var i = 0; i < 15; i++)
            candidate(
              id: i,
              when: DateTime(2026, 8, 11, 13, 0).add(Duration(hours: i)),
            ),
        ],
        room: 4,
        now: now,
      );
      expect(selected.length, 4);
      expect(selected.map((c) => c.id), [0, 1, 2, 3]);
    });

    test('calendar day+d construction does not skip DST spring-forward day', () {
      // US Pacific spring forward 2026-03-08. Building day+1 via calendar parts
      // must land on March 9, not a Duration-based 24h slip.
      final today = DateTime(2026, 3, 8);
      final next = DateTime(today.year, today.month, today.day + 1);
      expect(next.year, 2026);
      expect(next.month, 3);
      expect(next.day, 9);
    });
  });

  group('exact-time scheduling (no late delivery)', () {
    test('full day Fajr→Isha use independent notification IDs', () {
      const prayers = <HomePrayerId>[
        HomePrayerId.fajr,
        HomePrayerId.dhuhr,
        HomePrayerId.asr,
        HomePrayerId.maghrib,
        HomePrayerId.isha,
      ];
      final ids = <int>{};
      for (final prayer in prayers) {
        expect(
          ids.add(AppNotificationService.prayerNotificationIdFor(prayer, 0)),
          isTrue,
        );
      }
      expect(
        AppNotificationService.prayerNotificationIdFor(HomePrayerId.isha, 0),
        isNot(
          AppNotificationService.prayerNotificationIdFor(HomePrayerId.isha, 1),
        ),
      );
    });

    test('prioritizeNearest keeps only exact future slots — never past Isha', () {
      final now = DateTime(2026, 8, 11, 20, 22);
      PrayerScheduleCandidate candidate({
        required int id,
        required DateTime when,
      }) {
        return PrayerScheduleCandidate(
          id: id,
          when: when,
          title: 't$id',
          body: 'b$id',
          details: const NotificationDetails(),
          payload: 'prayer:$id',
        );
      }

      final selected = AppNotificationService.prioritizeNearestPrayerSlots(
        candidates: [
          candidate(id: 1, when: DateTime(2026, 8, 11, 3, 57)), // Fajr past
          candidate(id: 2, when: DateTime(2026, 8, 11, 20, 14)), // Isha past
          candidate(id: 3, when: DateTime(2026, 8, 12, 3, 57)), // next Fajr
        ],
        room: 10,
        now: now,
      );
      expect(selected.map((c) => c.id), [3]);
    });
  });
}
