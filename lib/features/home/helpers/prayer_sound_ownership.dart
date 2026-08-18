import '../../../core/services/prayer_alarm_service.dart';
import '../model/home_models.dart';

/// Single source of truth for which path owns prayer-time sound (Adhan / beep).
///
/// Native Prayer Alarms and soft FLN reminders can both be scheduled for the
/// same prayer. When native is authorized and will fire, soft UI may remain
/// but must not play a second sound.
abstract final class PrayerSoundOwnership {
  /// Whether the native Prayer Alarm path will present sound for [entry].
  static bool nativeOwnsSound({
    required PrayerSettingEntry entry,
    required bool prayerAlarmsMasterEnabled,
    required PrayerAlarmCapabilities capabilities,
    required PrayerAlarmAuthorizationStatus authorization,
  }) {
    if (!prayerAlarmsMasterEnabled) return false;
    if (!capabilities.supportsNativeAlarm) return false;
    if (authorization != PrayerAlarmAuthorizationStatus.authorized) {
      return false;
    }
    if (!entry.alarmEnabled) return false;
    // Match [PrayerAlarmService.rescheduleAlarms]: AlarmKit cannot mute, so
    // those slots are never scheduled — soft keeps mute ownership.
    if (entry.sound == PrayerNotificationSound.mute &&
        capabilities.isAlarmKit) {
      return false;
    }
    return true;
  }

  /// Sound used by the soft prayer notification for [entry].
  ///
  /// Returns [PrayerNotificationSound.mute] when native owns playback so the
  /// reminder can still appear without a duplicate Adhan/beep.
  static PrayerNotificationSound softEffectiveSound({
    required PrayerSettingEntry entry,
    required bool prayerAlarmsMasterEnabled,
    required PrayerAlarmCapabilities capabilities,
    required PrayerAlarmAuthorizationStatus authorization,
  }) {
    if (nativeOwnsSound(
      entry: entry,
      prayerAlarmsMasterEnabled: prayerAlarmsMasterEnabled,
      capabilities: capabilities,
      authorization: authorization,
    )) {
      return PrayerNotificationSound.mute;
    }
    return entry.sound;
  }
}
