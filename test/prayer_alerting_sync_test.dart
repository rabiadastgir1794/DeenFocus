import 'package:deenly/core/services/prayer_alarm_service.dart';
import 'package:deenly/features/home/helpers/prayer_sound_ownership.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrayerSettingEntry alerting lockstep', () {
    test('withAlertingEnabled sets soft and native together', () {
      const base = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: true,
        sound: PrayerNotificationSound.fullAdhan,
      );
      final off = base.withAlertingEnabled(false);
      expect(off.notificationsEnabled, isFalse);
      expect(off.alarmEnabled, isFalse);
      expect(off.sound, PrayerNotificationSound.fullAdhan);

      final on = off.withAlertingEnabled(true);
      expect(on.notificationsEnabled, isTrue);
      expect(on.alarmEnabled, isTrue);
    });

    test('normalizeAlertingSync keeps ON when either flag was ON', () {
      const softOnly = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: false,
      );
      final softFixed = softOnly.normalizeAlertingSync();
      expect(softFixed.notificationsEnabled, isTrue);
      expect(softFixed.alarmEnabled, isTrue);

      const alarmOnly = PrayerSettingEntry(
        notificationsEnabled: false,
        alarmEnabled: true,
      );
      final alarmFixed = alarmOnly.normalizeAlertingSync();
      expect(alarmFixed.notificationsEnabled, isTrue);
      expect(alarmFixed.alarmEnabled, isTrue);
    });

    test('normalizeAlertingSync keeps OFF when both were OFF', () {
      const bothOff = PrayerSettingEntry(
        notificationsEnabled: false,
        alarmEnabled: false,
      );
      final fixed = bothOff.normalizeAlertingSync();
      expect(fixed.notificationsEnabled, isFalse);
      expect(fixed.alarmEnabled, isFalse);
    });

    test('fromMap preserves raw flags; state normalize repairs desync', () {
      const desynced = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: false,
        sound: PrayerNotificationSound.beep,
      );
      final restored = PrayerSettingEntry.fromMap(desynced.toMap());
      expect(restored.notificationsEnabled, isTrue);
      expect(restored.alarmEnabled, isFalse);

      final state = PrayerSettingsState(
        entries: {TrackablePrayer.maghrib: restored},
      ).normalizeAlertingSync();
      final entry = state.forPrayer(TrackablePrayer.maghrib);
      expect(entry.notificationsEnabled, isTrue);
      expect(entry.alarmEnabled, isTrue);
      expect(state.isAlertingEnabled(TrackablePrayer.maghrib), isTrue);
    });

    test('round-trip JSON survives restart with synced flags', () {
      final state = PrayerSettingsState(
        entries: {
          TrackablePrayer.fajr: const PrayerSettingEntry(
            notificationsEnabled: false,
            alarmEnabled: true, // legacy desync
          ),
          TrackablePrayer.dhuhr: const PrayerSettingEntry(
            notificationsEnabled: true,
            alarmEnabled: true,
          ),
        },
      ).normalizeAlertingSync();

      final reloaded = PrayerSettingsState.fromJson(
        state.toJson(),
      ).normalizeAlertingSync();
      expect(
        reloaded.forPrayer(TrackablePrayer.fajr).notificationsEnabled,
        isTrue,
      );
      expect(reloaded.forPrayer(TrackablePrayer.fajr).alarmEnabled, isTrue);
      expect(
        reloaded.forPrayer(TrackablePrayer.dhuhr).notificationsEnabled,
        isTrue,
      );
      expect(reloaded.forPrayer(TrackablePrayer.dhuhr).alarmEnabled, isTrue);
    });
  });

  group('schedule gate mirrors synced UI', () {
    test('alerting OFF → soft and native both skip', () {
      final entry = const PrayerSettingEntry().withAlertingEnabled(false);
      expect(entry.notificationsEnabled, isFalse);
      expect(entry.alarmEnabled, isFalse);
    });

    test('alerting ON → soft and native both eligible', () {
      final entry = const PrayerSettingEntry(
        notificationsEnabled: false,
        alarmEnabled: false,
      ).withAlertingEnabled(true);
      expect(entry.notificationsEnabled, isTrue);
      expect(entry.alarmEnabled, isTrue);
    });
  });

  group('synced alerting preserves dual-Adhan ownership', () {
    const androidCaps = PrayerAlarmCapabilities(
      platform: 'android',
      implementation: 'fullscreen_intent',
      supportsNativeAlarm: true,
      supportsFullScreen: true,
      requiresAlarmKitEntitlement: false,
    );

    test('both ON + master authorized → soft muted, native owns', () {
      final entry = const PrayerSettingEntry().withAlertingEnabled(true);
      expect(
        PrayerSoundOwnership.nativeOwnsSound(
          entry: entry,
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        isTrue,
      );
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry,
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.mute,
      );
    });

    test('both OFF → native does not own; soft would skip schedule', () {
      final entry = const PrayerSettingEntry().withAlertingEnabled(false);
      expect(
        PrayerSoundOwnership.nativeOwnsSound(
          entry: entry,
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        isFalse,
      );
      expect(entry.notificationsEnabled, isFalse);
    });

    test('master OFF + alerting ON → soft keeps Adhan (no dual sound)', () {
      final entry = const PrayerSettingEntry().withAlertingEnabled(true);
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry,
          prayerAlarmsMasterEnabled: false,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.fullAdhan,
      );
    });
  });
}
