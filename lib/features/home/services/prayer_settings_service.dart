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

  /// Loads (or reloads) from disk and repairs legacy soft↔alarm desync.
  Future<void> reload() async {
    final raw = await StorageService.prayerSettingsJson;
    final loaded = raw == null
        ? PrayerSettingsState.defaults()
        : PrayerSettingsState.fromJson(raw);
    final normalized = loaded.normalizeAlertingSync();
    _state = normalized;
    _loaded = true;
    if (raw != null && normalized.toJson() != loaded.toJson()) {
      await StorageService.setPrayerSettingsJson(normalized.toJson());
    }
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

  /// Soft notification and native alarm stay in lockstep for [prayer].
  Future<void> setAlertingEnabled(TrackablePrayer prayer, bool enabled) async {
    final entry = forPrayer(prayer).withAlertingEnabled(enabled);
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
  }
}
