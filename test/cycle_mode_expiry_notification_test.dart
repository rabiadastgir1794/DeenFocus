import 'package:deenly/core/services/app_notification_service.dart';
import 'package:deenly/features/home/cycle_mode_entry_intent.dart';
import 'package:deenly/features/home/helpers/cycle_mode_expiry_notification_planner.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CycleModeData active({
    required DateTime start,
    int length = 3,
  }) {
    return CycleModeData(
      isEnabled: true,
      startDate: start,
      cycleLength: length,
    );
  }

  group('CycleModeExpiryNotificationPlanner — automatic expiry', () {
    test('fires at local midnight the day after plannedEndDate', () {
      // Enable 17 Aug for 3 days → active 17–19; ends morning of 20 Aug.
      final data = active(start: DateTime(2026, 8, 17, 14, 30), length: 3);
      expect(data.plannedEndDate, DateTime(2026, 8, 19));
      expect(
        CycleModeExpiryNotificationPlanner.scheduledFireTime(data),
        DateTime(2026, 8, 20),
      );
      expect(data.hasExpiredOn(DateTime(2026, 8, 19, 23, 59)), isFalse);
      expect(data.hasExpiredOn(DateTime(2026, 8, 20)), isTrue);
    });

    test('shouldSchedule while cycle is still active before fire time', () {
      final data = active(start: DateTime(2026, 8, 17), length: 3);
      expect(
        CycleModeExpiryNotificationPlanner.shouldSchedule(
          data,
          now: DateTime(2026, 8, 17, 15),
        ),
        isTrue,
      );
      expect(
        CycleModeExpiryNotificationPlanner.shouldSchedule(
          data,
          now: DateTime(2026, 8, 19, 23, 59),
        ),
        isTrue,
      );
    });

    test('should not schedule at or after automatic expiry instant', () {
      final data = active(start: DateTime(2026, 8, 17), length: 3);
      expect(
        CycleModeExpiryNotificationPlanner.shouldSchedule(
          data,
          now: DateTime(2026, 8, 20),
        ),
        isFalse,
      );
      expect(
        CycleModeExpiryNotificationPlanner.shouldSchedule(
          data,
          now: DateTime(2026, 8, 21, 9),
        ),
        isFalse,
      );
    });

    test('expireFully disables scheduling (post auto-expiry state)', () {
      final expired = active(start: DateTime(2026, 8, 17), length: 3).expireFully();
      expect(expired.isEnabled, isFalse);
      expect(
        CycleModeExpiryNotificationPlanner.scheduledFireTime(expired),
        isNull,
      );
      expect(
        CycleModeExpiryNotificationPlanner.shouldSchedule(
          expired,
          now: DateTime(2026, 8, 19),
        ),
        isFalse,
      );
    });
  });

  group('CycleModeExpiryNotificationPlanner — manual disable', () {
    test('manual disable clears schedule even if dates remain in draft', () {
      final activeCycle = active(start: DateTime(2026, 8, 17), length: 3);
      final disabled = activeCycle.disableOn(DateTime(2026, 8, 18, 10));
      expect(disabled.isEnabled, isFalse);
      expect(
        CycleModeExpiryNotificationPlanner.shouldSchedule(
          disabled,
          now: DateTime(2026, 8, 18, 11),
        ),
        isFalse,
      );
      expect(
        CycleModeExpiryNotificationPlanner.scheduledFireTime(disabled),
        isNull,
      );
    });
  });

  group('CycleModeExpiryNotificationPlanner — date editing', () {
    test('editing start/length reschedules to the new end midnight', () {
      final original = active(start: DateTime(2026, 8, 17), length: 3);
      final edited = active(start: DateTime(2026, 8, 17), length: 5);
      expect(
        CycleModeExpiryNotificationPlanner.scheduledFireTime(original),
        DateTime(2026, 8, 20),
      );
      expect(
        CycleModeExpiryNotificationPlanner.scheduledFireTime(edited),
        DateTime(2026, 8, 22),
      );

      final movedStart = active(start: DateTime(2026, 8, 18), length: 3);
      expect(
        CycleModeExpiryNotificationPlanner.scheduledFireTime(movedStart),
        DateTime(2026, 8, 21),
      );
    });

    test('signature changes when dates are edited so reschedule is not skipped',
        () {
      final original = active(start: DateTime(2026, 8, 17), length: 3);
      final edited = active(start: DateTime(2026, 8, 17), length: 5);
      final now = DateTime(2026, 8, 17, 12);
      final a = CycleModeExpiryNotificationPlanner.scheduleSignature(
        original,
        localeCode: 'en',
        now: now,
      );
      final b = CycleModeExpiryNotificationPlanner.scheduleSignature(
        edited,
        localeCode: 'en',
        now: now,
      );
      expect(a, isNot(b));
      expect(a, startsWith('schedule|'));
      expect(b, startsWith('schedule|'));
    });
  });

  group('CycleModeExpiryNotificationPlanner — restart / duplicate prevention',
      () {
    test('identical active state yields the same schedule signature', () {
      final data = active(start: DateTime(2026, 8, 17, 9), length: 3);
      final now = DateTime(2026, 8, 18, 8);
      final first = CycleModeExpiryNotificationPlanner.scheduleSignature(
        data,
        localeCode: 'en',
        now: now,
      );
      final second = CycleModeExpiryNotificationPlanner.scheduleSignature(
        data,
        localeCode: 'en',
        now: now,
      );
      expect(first, second);
    });

    test('cancel signature after disable differs from prior schedule signature',
        () {
      final enabled = active(start: DateTime(2026, 8, 17), length: 3);
      final disabled = enabled.disableOn(DateTime(2026, 8, 18));
      final now = DateTime(2026, 8, 18, 12);
      final scheduled = CycleModeExpiryNotificationPlanner.scheduleSignature(
        enabled,
        localeCode: 'en',
        now: now,
      );
      final cancelled = CycleModeExpiryNotificationPlanner.scheduleSignature(
        disabled,
        localeCode: 'en',
        now: now,
      );
      expect(scheduled, startsWith('schedule|'));
      expect(cancelled, startsWith('cancel|'));
      expect(scheduled, isNot(cancelled));
    });

    test('uses a single dedicated notification id outside prayer/wrap-up ranges',
        () {
      final id = AppNotificationService.cycleModeExpiryNotificationId;
      expect(id, 5100);
      expect(AppNotificationService.isCycleModeExpiryNotificationId(id), isTrue);
      expect(AppNotificationService.isPrayerSoftNotificationId(id), isFalse);
      expect(AppNotificationService.isNightlyWrapUpNotificationId(id), isFalse);
      expect(
        AppNotificationService.isCycleModeExpiryNotificationId(5000),
        isFalse,
      );
    });

    test('timezone change changes signature so Android AlarmManager reschedules',
        () {
      final data = active(start: DateTime(2026, 8, 17), length: 3);
      final now = DateTime(2026, 8, 18, 8);
      final before = CycleModeExpiryNotificationPlanner.scheduleSignature(
        data,
        localeCode: 'en',
        timeZoneName: 'Asia/Karachi',
        now: now,
      );
      final after = CycleModeExpiryNotificationPlanner.scheduleSignature(
        data,
        localeCode: 'en',
        timeZoneName: 'America/New_York',
        now: now,
      );
      expect(before, isNot(after));
      expect(before, contains('Asia/Karachi'));
      expect(after, contains('America/New_York'));
    });
  });

  group('Android Cycle Mode expiry support (shared FLN architecture)', () {
    test('uses dedicated Android channel cycle_mode (not prayer channels)', () {
      expect(AppNotificationService.cycleModeAndroidChannelId, 'cycle_mode');
    });

    test('id 5100 is outside SoftPrayerNotificationInvalidator range 1000–1199',
        () {
      // Native Android timezone clears only soft prayer IDs; Cycle Mode must
      // survive that wipe and be reconciled by Flutter signature+sync.
      const prayerStart = 1000;
      const prayerEnd = 1199;
      final id = AppNotificationService.cycleModeExpiryNotificationId;
      expect(id < prayerStart || id > prayerEnd, isTrue);
    });

    test('fire time is wall-clock local midnight (AlarmManager absoluteTime)', () {
      final data = active(start: DateTime(2026, 8, 17, 22, 15), length: 3);
      final when = CycleModeExpiryNotificationPlanner.scheduledFireTime(data)!;
      expect(when.hour, 0);
      expect(when.minute, 0);
      expect(when.second, 0);
      expect(when.isUtc, isFalse);
    });

    test('manual disable / date edit cancel paths produce distinct signatures',
        () {
      final now = DateTime(2026, 8, 18, 10);
      final enabled = active(start: DateTime(2026, 8, 17), length: 3);
      final disabled = enabled.disableOn(now);
      final edited = active(start: DateTime(2026, 8, 17), length: 6);
      final tz = 'Asia/Karachi';
      final enabledSig = CycleModeExpiryNotificationPlanner.scheduleSignature(
        enabled,
        localeCode: 'en',
        timeZoneName: tz,
        now: now,
      );
      final disabledSig = CycleModeExpiryNotificationPlanner.scheduleSignature(
        disabled,
        localeCode: 'en',
        timeZoneName: tz,
        now: now,
      );
      final editedSig = CycleModeExpiryNotificationPlanner.scheduleSignature(
        edited,
        localeCode: 'en',
        timeZoneName: tz,
        now: now,
      );
      expect(enabledSig, startsWith('schedule|'));
      expect(disabledSig, startsWith('cancel|'));
      expect(editedSig, startsWith('schedule|'));
      expect({enabledSig, disabledSig, editedSig}, hasLength(3));
    });
  });

  group('Cycle Mode ended notification tap / navigation', () {
    tearDown(() {
      CycleModeEntryIntent.pendingOpenSettings.value = false;
    });

    test('payload routes to CycleModeEntryIntent open-settings', () {
      expect(CycleModeEntryIntent.pendingOpenSettings.value, isFalse);
      AppNotificationService.handleNotificationPayload(
        CycleModeExpiryNotificationPlanner.payload,
      );
      expect(CycleModeEntryIntent.pendingOpenSettings.value, isTrue);
      expect(CycleModeEntryIntent.takePendingOpenSettings(), isTrue);
      expect(CycleModeEntryIntent.takePendingOpenSettings(), isFalse);
    });

    test('unrelated payloads do not open Cycle Mode settings', () {
      AppNotificationService.handleNotificationPayload('prayer:fajr');
      expect(CycleModeEntryIntent.pendingOpenSettings.value, isFalse);
      AppNotificationService.handleNotificationPayload(null);
      expect(CycleModeEntryIntent.pendingOpenSettings.value, isFalse);
    });

    test('payload constant is stable for deep-link routing', () {
      expect(CycleModeExpiryNotificationPlanner.payload, 'cycle_mode:edit');
    });
  });
}
