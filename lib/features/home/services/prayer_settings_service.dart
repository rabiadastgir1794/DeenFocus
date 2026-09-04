import 'package:flutter/foundation.dart';

import '../../../core/services/storage_service.dart';
import '../model/home_models.dart';

/// Single in-app source of truth for per-prayer soft notification + alarm flags.
///
/// Persistence remains [StorageService.prayerSettingsJson]. Home and Settings
/// must read/write through this service so toggles never diverge in memory.
class PrayerSettingsService extends ChangeNotifier {
  PrayerSettingsState _state = PrayerSettingsState.defaults();
  bool _loaded = false;

  PrayerSettingsState get state => _state;

  bool get isLoaded => _loaded;

  PrayerSettingEntry forPrayer(TrackablePrayer prayer) =>
      _state.forPrayer(prayer);

  bool isAlertingEnabled(TrackablePrayer prayer) =>
      _state.isAlertingEnabled(prayer);

  Map<TrackablePrayer, int> get customTimeOverrides =>
      _state.customTimeOverrides;

  /// Incremented when a per-prayer custom wall time is saved or cleared so
  /// Focus (app blocking) can drop cached salah windows immediately.
  static final ValueNotifier<int> customTimeRevision = ValueNotifier<int>(0);

  /// Loads (or reloads) from disk. Soft notification and native alarm flags
  /// stay independent so Home and Settings can toggle them separately.
  Future<void> reload() async {
    final raw = await StorageService.prayerSettingsJson;
    _state = raw == null
        ? PrayerSettingsState.defaults()
        : PrayerSettingsState.fromJson(raw);
    _loaded = true;
    notifyListeners();
  }

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    await reload();
  }

  Future<void> _persist() async {
    await StorageService.setPrayerSettingsJson(_state.toJson());
  }

  Future<void> replaceEntry(
    TrackablePrayer prayer,
    PrayerSettingEntry entry,
  ) async {
    await ensureLoaded();
    _state = _state.copyWithEntry(prayer, entry);
    await _persist();
    notifyListeners();
  }

  /// Soft notification and native alarm together (legacy / both-on helpers).
  Future<void> setAlertingEnabled(TrackablePrayer prayer, bool enabled) async {
    final entry = forPrayer(prayer).withAlertingEnabled(enabled);
    await replaceEntry(prayer, entry);
  }

  Future<void> setNotificationsEnabled(
    TrackablePrayer prayer,
    bool enabled,
  ) async {
    final entry = forPrayer(prayer).copyWith(notificationsEnabled: enabled);
    await replaceEntry(prayer, entry);
  }

  Future<void> setAlarmEnabled(TrackablePrayer prayer, bool enabled) async {
    final entry = forPrayer(prayer).copyWith(alarmEnabled: enabled);
    await replaceEntry(prayer, entry);
  }

  Future<void> setSound(
    TrackablePrayer prayer,
    PrayerNotificationSound sound,
  ) async {
    final entry = forPrayer(prayer).copyWith(sound: sound);
    await replaceEntry(prayer, entry);
  }

  Future<void> setCustomTime(
    TrackablePrayer prayer,
    int? minutesSinceMidnight,
  ) async {
    final entry = forPrayer(prayer).copyWith(
      customTimeMinutes: minutesSinceMidnight,
      clearCustomTime: minutesSinceMidnight == null,
    );
    await replaceEntry(prayer, entry);
    customTimeRevision.value++;
  }

  /// Clears every per-prayer wall-clock override (e.g. after a city change).
  Future<void> clearAllCustomTimes() async {
    await ensureLoaded();
    var changed = false;
    var next = _state;
    for (final prayer in TrackablePrayer.values) {
      if (next.forPrayer(prayer).customTimeMinutes == null) continue;
      next = next.copyWithEntry(
        prayer,
        next.forPrayer(prayer).copyWith(clearCustomTime: true),
      );
      changed = true;
    }
    if (!changed) return;
    _state = next;
    await _persist();
    customTimeRevision.value++;
    notifyListeners();
  }
}
