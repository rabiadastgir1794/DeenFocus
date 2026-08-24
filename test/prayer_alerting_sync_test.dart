import 'package:deenly/core/services/prayer_alarm_enablement.dart';
import 'package:deenly/core/services/prayer_alarm_service.dart';
import 'package:deenly/features/home/helpers/prayer_sound_ownership.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrayerSettingEntry independent flags', () {
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

    test('copyWith can change soft and native independently', () {
      const softOnly = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: false,
      );
      expect(softOnly.notificationsEnabled, isTrue);
      expect(softOnly.alarmEnabled, isFalse);

      const alarmOnly = PrayerSettingEntry(
        notificationsEnabled: false,
        alarmEnabled: true,
      );
      expect(alarmOnly.notificationsEnabled, isFalse);
      expect(alarmOnly.alarmEnabled, isTrue);
    });

    test('fromMap / toMap round-trip preserves independent flags', () {
      const desynced = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: false,
        sound: PrayerNotificationSound.beep,
      );
      final restored = PrayerSettingEntry.fromMap(desynced.toMap());
      expect(restored.notificationsEnabled, isTrue);
      expect(restored.alarmEnabled, isFalse);
      expect(restored.sound, PrayerNotificationSound.beep);

      final state = PrayerSettingsState(
        entries: {TrackablePrayer.maghrib: restored},
      );
      final entry = state.forPrayer(TrackablePrayer.maghrib);
      expect(entry.notificationsEnabled, isTrue);
      expect(entry.alarmEnabled, isFalse);
      expect(state.isAlertingEnabled(TrackablePrayer.maghrib), isTrue);
    });

    test('round-trip JSON survives restart with independent flags', () {
      final state = PrayerSettingsState(
        entries: {
          TrackablePrayer.fajr: const PrayerSettingEntry(
            notificationsEnabled: false,
            alarmEnabled: true,
          ),
          TrackablePrayer.dhuhr: const PrayerSettingEntry(
            notificationsEnabled: true,
            alarmEnabled: true,
          ),
        },
      );

      final reloaded = PrayerSettingsState.fromJson(state.toJson());
      expect(
        reloaded.forPrayer(TrackablePrayer.fajr).notificationsEnabled,
        isFalse,
      );
      expect(reloaded.forPrayer(TrackablePrayer.fajr).alarmEnabled, isTrue);
      expect(
        reloaded.forPrayer(TrackablePrayer.dhuhr).notificationsEnabled,
        isTrue,
      );
      expect(reloaded.forPrayer(TrackablePrayer.dhuhr).alarmEnabled, isTrue);
    });
  });

  group('PrayerAlarmEnablement effective UI', () {
    const caps = PrayerAlarmCapabilities(
      platform: 'ios',
      implementation: 'alarmkit',
      supportsNativeAlarm: true,
      supportsFullScreen: true,
      requiresAlarmKitEntitlement: true,
    );

    test('stored ON + no permission → effective OFF', () {
      expect(
        PrayerAlarmEnablement.effectiveAlarmEnabled(
          storedAlarmEnabled: true,
          masterEnabled: false,
          capabilities: caps,
          authorization: PrayerAlarmAuthorizationStatus.denied,
        ),
        isFalse,
      );
      expect(
        PrayerAlarmEnablement.effectiveAlarmEnabled(
          storedAlarmEnabled: true,
          masterEnabled: true,
          capabilities: caps,
          authorization: PrayerAlarmAuthorizationStatus.denied,
        ),
        isFalse,
      );
    });

    test('stored ON + master + authorized → effective ON', () {
      expect(
        PrayerAlarmEnablement.effectiveAlarmEnabled(
          storedAlarmEnabled: true,
          masterEnabled: true,
          capabilities: caps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        isTrue,
      );
    });

    test('stored OFF + authorized → effective OFF', () {
      expect(
        PrayerAlarmEnablement.effectiveAlarmEnabled(
          storedAlarmEnabled: false,
          masterEnabled: true,
          capabilities: caps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        isFalse,
      );
    });
  });

  group('schedule gate uses independent flags', () {
    test('alarm OFF → native skips even if soft ON', () {
      const entry = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: false,
      );
      expect(entry.notificationsEnabled, isTrue);
      expect(entry.alarmEnabled, isFalse);
    });

    test('soft OFF → soft skips even if alarm ON', () {
      const entry = PrayerSettingEntry(
        notificationsEnabled: false,
        alarmEnabled: true,
      );
      expect(entry.notificationsEnabled, isFalse);
      expect(entry.alarmEnabled, isTrue);
    });
  });

  group('dual-Adhan ownership with independent flags', () {
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

    test('alarm OFF → native does not own; soft keeps sound', () {
      const entry = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: false,
      );
      expect(
        PrayerSoundOwnership.nativeOwnsSound(
          entry: entry,
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        isFalse,
      );
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry,
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.fullAdhan,
      );
    });

    test('master OFF + alarm ON → soft keeps Adhan (no dual sound)', () {
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
