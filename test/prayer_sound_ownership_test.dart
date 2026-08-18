import 'package:deenly/core/services/prayer_alarm_service.dart';
import 'package:deenly/features/home/helpers/prayer_sound_ownership.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const androidCaps = PrayerAlarmCapabilities(
    platform: 'android',
    implementation: 'fullscreen_intent',
    supportsNativeAlarm: true,
    supportsFullScreen: true,
    requiresAlarmKitEntitlement: false,
  );
  const alarmKitCaps = PrayerAlarmCapabilities(
    platform: 'ios',
    implementation: 'alarmkit',
    supportsNativeAlarm: true,
    supportsFullScreen: false,
    requiresAlarmKitEntitlement: true,
  );
  const iosFallbackCaps = PrayerAlarmCapabilities(
    platform: 'ios',
    implementation: 'notification_fallback',
    supportsNativeAlarm: false,
    supportsFullScreen: false,
    requiresAlarmKitEntitlement: false,
  );

  PrayerSettingEntry entry({
    bool notifications = true,
    bool alarm = true,
    PrayerNotificationSound sound = PrayerNotificationSound.fullAdhan,
  }) {
    return PrayerSettingEntry(
      notificationsEnabled: notifications,
      alarmEnabled: alarm,
      sound: sound,
    );
  }

  group('PrayerSoundOwnership — dual Adhan prevention', () {
    test('native + soft enabled → soft is muted (one Adhan via native)', () {
      final soft = PrayerSoundOwnership.softEffectiveSound(
        entry: entry(),
        prayerAlarmsMasterEnabled: true,
        capabilities: androidCaps,
        authorization: PrayerAlarmAuthorizationStatus.authorized,
      );
      expect(soft, PrayerNotificationSound.mute);
      expect(
        PrayerSoundOwnership.nativeOwnsSound(
          entry: entry(),
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        isTrue,
      );
    });

    test('native disabled (master off) → soft keeps Full Adhan', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(),
          prayerAlarmsMasterEnabled: false,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.fullAdhan,
      );
    });

    test('native unavailable (iOS fallback) → soft keeps Full Adhan', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(),
          prayerAlarmsMasterEnabled: true,
          capabilities: iosFallbackCaps,
          authorization: PrayerAlarmAuthorizationStatus.unavailable,
        ),
        PrayerNotificationSound.fullAdhan,
      );
    });

    test('native unauthorized → soft keeps Full Adhan', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(),
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.denied,
        ),
        PrayerNotificationSound.fullAdhan,
      );
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(),
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.notDetermined,
        ),
        PrayerNotificationSound.fullAdhan,
      );
    });

    test(
      'soft disabled + native enabled → native owns sound; soft mute N/A',
      () {
        // Soft schedule skips notificationsEnabled=false; ownership still true.
        expect(
          PrayerSoundOwnership.nativeOwnsSound(
            entry: entry(notifications: false),
            prayerAlarmsMasterEnabled: true,
            capabilities: androidCaps,
            authorization: PrayerAlarmAuthorizationStatus.authorized,
          ),
          isTrue,
        );
      },
    );

    test('per-prayer alarm off → soft keeps configured Adhan', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(alarm: false),
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.fullAdhan,
      );
    });
  });

  group('PrayerSoundOwnership — beep / mute preferences', () {
    test('beep + native owns → soft muted (no duplicate beep)', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(sound: PrayerNotificationSound.beep),
          prayerAlarmsMasterEnabled: true,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.mute,
      );
    });

    test('beep + native off → soft keeps beep', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(sound: PrayerNotificationSound.beep),
          prayerAlarmsMasterEnabled: false,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.beep,
      );
    });

    test('mute preference stays mute on soft when native off', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(sound: PrayerNotificationSound.mute),
          prayerAlarmsMasterEnabled: false,
          capabilities: androidCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.mute,
      );
    });

    test(
      'Android mute + native authorized → soft mute (native owns silent alarm)',
      () {
        expect(
          PrayerSoundOwnership.nativeOwnsSound(
            entry: entry(sound: PrayerNotificationSound.mute),
            prayerAlarmsMasterEnabled: true,
            capabilities: androidCaps,
            authorization: PrayerAlarmAuthorizationStatus.authorized,
          ),
          isTrue,
        );
        expect(
          PrayerSoundOwnership.softEffectiveSound(
            entry: entry(sound: PrayerNotificationSound.mute),
            prayerAlarmsMasterEnabled: true,
            capabilities: androidCaps,
            authorization: PrayerAlarmAuthorizationStatus.authorized,
          ),
          PrayerNotificationSound.mute,
        );
      },
    );

    test('AlarmKit mute → native does not own; soft stays mute', () {
      expect(
        PrayerSoundOwnership.nativeOwnsSound(
          entry: entry(sound: PrayerNotificationSound.mute),
          prayerAlarmsMasterEnabled: true,
          capabilities: alarmKitCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        isFalse,
      );
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(sound: PrayerNotificationSound.mute),
          prayerAlarmsMasterEnabled: true,
          capabilities: alarmKitCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.mute,
      );
    });

    test('AlarmKit + Full Adhan authorized → soft muted', () {
      expect(
        PrayerSoundOwnership.softEffectiveSound(
          entry: entry(),
          prayerAlarmsMasterEnabled: true,
          capabilities: alarmKitCaps,
          authorization: PrayerAlarmAuthorizationStatus.authorized,
        ),
        PrayerNotificationSound.mute,
      );
    });
  });
}
