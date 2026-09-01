import 'dart:convert';

class DailyVerseRef {
  const DailyVerseRef({required this.surahNumber, required this.ayahNumber});

  final int surahNumber;
  final int ayahNumber;
}

class HomeDailyVerse {
  const HomeDailyVerse({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.arabicSurahName,
    required this.arabicText,
    required this.englishText,
  });

  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String arabicSurahName;
  final String arabicText;
  final String englishText;
}

enum HomePrayerId { fajr, sunrise, dhuhr, asr, maghrib, isha }

class HomePrayerSlot {
  const HomePrayerSlot({required this.id, required this.time});

  final HomePrayerId id;
  final DateTime time;
}

class HomePrayerTimesData {
  const HomePrayerTimesData({
    required this.slots,
    required this.nextPrayer,
    required this.nextPrayerTime,
    required this.remaining,
  });

  final List<HomePrayerSlot> slots;
  final HomePrayerId? nextPrayer;
  final DateTime? nextPrayerTime;
  final Duration? remaining;
}

class HomeIslamicEvent {
  const HomeIslamicEvent({required this.date, required this.title});

  final DateTime date;
  final String title;
}

enum TrackablePrayer { fajr, dhuhr, asr, maghrib, isha }

/// Maps [TrackablePrayer] <-> [HomePrayerId] since sunrise is not trackable.
extension TrackablePrayerHomeId on TrackablePrayer {
  HomePrayerId get homePrayerId {
    switch (this) {
      case TrackablePrayer.fajr:
        return HomePrayerId.fajr;
      case TrackablePrayer.dhuhr:
        return HomePrayerId.dhuhr;
      case TrackablePrayer.asr:
        return HomePrayerId.asr;
      case TrackablePrayer.maghrib:
        return HomePrayerId.maghrib;
      case TrackablePrayer.isha:
        return HomePrayerId.isha;
    }
  }
}

extension HomePrayerIdTrackable on HomePrayerId {
  /// Null for [HomePrayerId.sunrise], which cannot be marked/tracked.
  TrackablePrayer? get trackablePrayer {
    switch (this) {
      case HomePrayerId.fajr:
        return TrackablePrayer.fajr;
      case HomePrayerId.sunrise:
        return null;
      case HomePrayerId.dhuhr:
        return TrackablePrayer.dhuhr;
      case HomePrayerId.asr:
        return TrackablePrayer.asr;
      case HomePrayerId.maghrib:
        return TrackablePrayer.maghrib;
      case HomePrayerId.isha:
        return TrackablePrayer.isha;
    }
  }
}

/// Per-day, per-prayer mark chosen from the "Mark Prayer" bottom sheet.
enum PrayerMarkStatus { none, onTime, qada, missed }

/// Per-prayer notification tone, remembered independently for each prayer.
enum PrayerNotificationSound { fullAdhan, beep, mute }

class HomePrayerChecklistDay {
  const HomePrayerChecklistDay({
    required this.dateKey,
    required this.selectedPrayers,
    this.prayerStatuses = const <TrackablePrayer, PrayerMarkStatus>{},
  });

  factory HomePrayerChecklistDay.fromMap(Map<String, dynamic> map) {
    final selectedPrayers =
        (map['selectedPrayers'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<String>()
            .map(
              (value) => TrackablePrayer.values.firstWhere(
                (prayer) => prayer.name == value,
                orElse: () => TrackablePrayer.fajr,
              ),
            )
            .toSet();

    final statusesMap = map['prayerStatuses'] as Map<String, dynamic>?;
    final prayerStatuses = <TrackablePrayer, PrayerMarkStatus>{};
    if (statusesMap != null) {
      for (final entry in statusesMap.entries) {
        final prayer = TrackablePrayer.values
            .where((value) => value.name == entry.key)
            .firstOrNull;
        final status = PrayerMarkStatus.values
            .where((value) => value.name == entry.value)
            .firstOrNull;
        if (prayer != null &&
            status != null &&
            status != PrayerMarkStatus.none) {
          prayerStatuses[prayer] = status;
        }
      }
    }
    // Legacy rows only stored selectedPrayers — hydrate statuses so unmark
    // cannot wipe siblings that lived only in the set.
    if (prayerStatuses.isEmpty && selectedPrayers.isNotEmpty) {
      for (final prayer in selectedPrayers) {
        prayerStatuses[prayer] = PrayerMarkStatus.onTime;
      }
    }

    return HomePrayerChecklistDay(
      dateKey: map['dateKey'] as String? ?? '',
      selectedPrayers: selectedPrayers,
      prayerStatuses: prayerStatuses,
    );
  }

  final String dateKey;
  final Set<TrackablePrayer> selectedPrayers;
  final Map<TrackablePrayer, PrayerMarkStatus> prayerStatuses;

  bool get isCompleted =>
      selectedPrayers.length == TrackablePrayer.values.length;

  /// Falls back to [selectedPrayers] for data saved before per-status
  /// tracking existed, so old streaks keep showing as "prayed on time".
  PrayerMarkStatus statusFor(TrackablePrayer prayer) {
    final explicit = prayerStatuses[prayer];
    if (explicit != null) return explicit;
    return selectedPrayers.contains(prayer)
        ? PrayerMarkStatus.onTime
        : PrayerMarkStatus.none;
  }

  HomePrayerChecklistDay copyWith({
    String? dateKey,
    Set<TrackablePrayer>? selectedPrayers,
    Map<TrackablePrayer, PrayerMarkStatus>? prayerStatuses,
  }) {
    return HomePrayerChecklistDay(
      dateKey: dateKey ?? this.dateKey,
      selectedPrayers: selectedPrayers ?? this.selectedPrayers,
      prayerStatuses: prayerStatuses ?? this.prayerStatuses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateKey': dateKey,
      'selectedPrayers': selectedPrayers.map((item) => item.name).toList(),
      'prayerStatuses': prayerStatuses.map(
        (prayer, status) => MapEntry(prayer.name, status.name),
      ),
    };
  }
}

/// Per-prayer settings: custom time override, notification sound, and
/// whether notifications / native prayer alarms are enabled for that prayer.
class PrayerSettingEntry {
  const PrayerSettingEntry({
    this.notificationsEnabled = true,
    this.alarmEnabled = true,
    this.sound = PrayerNotificationSound.fullAdhan,
    this.customTimeMinutes,
  });

  factory PrayerSettingEntry.fromMap(Map<String, dynamic> map) {
    return PrayerSettingEntry(
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      // Default true so enabling the master Prayer Alarms switch covers all five
      // once permission is granted. UI must still show OFF until scheduling works.
      alarmEnabled: map['alarmEnabled'] as bool? ?? true,
      sound:
          PrayerNotificationSound.values
              .where((value) => value.name == map['sound'])
              .firstOrNull ??
          PrayerNotificationSound.fullAdhan,
      customTimeMinutes: map['customTimeMinutes'] as int?,
    );
  }

  /// Whether the user wants a soft notification for this prayer at all.
  final bool notificationsEnabled;

  /// Whether a native Prayer Alarm should fire for this prayer.
  final bool alarmEnabled;

  /// Which sound plays when the notification / alarm fires.
  final PrayerNotificationSound sound;

  /// Minutes since local midnight; null means use the calculated time.
  final int? customTimeMinutes;

  PrayerSettingEntry copyWith({
    bool? notificationsEnabled,
    bool? alarmEnabled,
    PrayerNotificationSound? sound,
    int? customTimeMinutes,
    bool clearCustomTime = false,
  }) {
    return PrayerSettingEntry(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
      sound: sound ?? this.sound,
      customTimeMinutes: clearCustomTime
          ? null
          : (customTimeMinutes ?? this.customTimeMinutes),
    );
  }

  /// Soft notification + native alarm together (convenience for tests / bulk).
  PrayerSettingEntry withAlertingEnabled(bool enabled) =>
      copyWith(notificationsEnabled: enabled, alarmEnabled: enabled);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationsEnabled': notificationsEnabled,
      'alarmEnabled': alarmEnabled,
      'sound': sound.name,
      if (customTimeMinutes != null) 'customTimeMinutes': customTimeMinutes,
    };
  }
}

class PrayerSettingsState {
  const PrayerSettingsState({required this.entries});

  factory PrayerSettingsState.defaults() {
    return const PrayerSettingsState(
      entries: <TrackablePrayer, PrayerSettingEntry>{},
    );
  }

  factory PrayerSettingsState.fromJson(String source) {
    try {
      final map = jsonDecode(source) as Map<String, dynamic>;
      final entries = <TrackablePrayer, PrayerSettingEntry>{};
      for (final entry in map.entries) {
        final prayer = TrackablePrayer.values
            .where((value) => value.name == entry.key)
            .firstOrNull;
        if (prayer == null) continue;
        entries[prayer] = PrayerSettingEntry.fromMap(
          Map<String, dynamic>.from(entry.value as Map),
        );
      }
      return PrayerSettingsState(entries: entries);
    } catch (_) {
      return PrayerSettingsState.defaults();
    }
  }

  final Map<TrackablePrayer, PrayerSettingEntry> entries;

  PrayerSettingEntry forPrayer(TrackablePrayer prayer) =>
      entries[prayer] ?? const PrayerSettingEntry();

  /// Soft notification preference for [prayer].
  bool isAlertingEnabled(TrackablePrayer prayer) =>
      forPrayer(prayer).notificationsEnabled;

  /// Only prayers with an explicit custom time, for schedule recomputation.
  Map<TrackablePrayer, int> get customTimeOverrides {
    return <TrackablePrayer, int>{
      for (final entry in entries.entries)
        if (entry.value.customTimeMinutes != null)
          entry.key: entry.value.customTimeMinutes!,
    };
  }

  PrayerSettingsState copyWithEntry(
    TrackablePrayer prayer,
    PrayerSettingEntry entry,
  ) {
    final updated = Map<TrackablePrayer, PrayerSettingEntry>.from(entries);
    updated[prayer] = entry;
    return PrayerSettingsState(entries: updated);
  }

  String toJson() {
    return jsonEncode(
      entries.map((prayer, entry) => MapEntry(prayer.name, entry.toMap())),
    );
  }
}

class HomePrayerStreakState {
  const HomePrayerStreakState({
    required this.weekStartDateKey,
    required this.weekDays,
    required this.completedDateKeys,
    this.statusHistory =
        const <String, Map<TrackablePrayer, PrayerMarkStatus>>{},
    this.bestPrayerStreak = 0,
    this.bestDayStreak = 0,
  });

  factory HomePrayerStreakState.empty({required String weekStartDateKey}) {
    return HomePrayerStreakState(
      weekStartDateKey: weekStartDateKey,
      weekDays: const <HomePrayerChecklistDay>[],
      completedDateKeys: const <String>{},
    );
  }

  static Map<String, Map<TrackablePrayer, PrayerMarkStatus>> _parseStatusMap(
    Map<String, dynamic>? raw,
  ) {
    final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
    if (raw == null) return history;
    for (final entry in raw.entries) {
      final dayMap = <TrackablePrayer, PrayerMarkStatus>{};
      final rawDay = entry.value;
      if (rawDay is Map) {
        for (final prayerEntry in rawDay.entries) {
          final prayer = TrackablePrayer.values
              .where((p) => p.name == prayerEntry.key)
              .firstOrNull;
          final status = PrayerMarkStatus.values
              .where((s) => s.name == prayerEntry.value)
              .firstOrNull;
          if (prayer != null &&
              status != null &&
              status != PrayerMarkStatus.none) {
            dayMap[prayer] = status;
          }
        }
      }
      if (dayMap.isNotEmpty) history[entry.key] = dayMap;
    }
    return history;
  }

  factory HomePrayerStreakState.fromJson(String source) {
    try {
      final map = jsonDecode(source) as Map<String, dynamic>;
      final completedDateKeys =
          (map['completedDateKeys'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .toSet();

      final history = _parseStatusMap(
        map['statusHistory'] as Map<String, dynamic>?,
      );

      // Legacy: prayerHistory was a set of prayer names (assumed onTime).
      final rawHistory = map['prayerHistory'] as Map<String, dynamic>?;
      if (rawHistory != null) {
        for (final entry in rawHistory.entries) {
          history.putIfAbsent(entry.key, () {
            final dayMap = <TrackablePrayer, PrayerMarkStatus>{};
            for (final name
                in (entry.value as List<dynamic>? ?? const <dynamic>[])) {
              final prayer = TrackablePrayer.values
                  .where((p) => p.name == '$name')
                  .firstOrNull;
              if (prayer != null) {
                dayMap[prayer] = PrayerMarkStatus.onTime;
              }
            }
            return dayMap;
          });
        }
      }

      return HomePrayerStreakState(
        weekStartDateKey: map['weekStartDateKey'] as String? ?? '',
        weekDays: (map['weekDays'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map>()
            .map(
              (item) => HomePrayerChecklistDay.fromMap(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(growable: false),
        completedDateKeys: completedDateKeys,
        statusHistory: history,
        bestPrayerStreak: (map['bestPrayerStreak'] as num?)?.toInt() ?? 0,
        bestDayStreak: (map['bestDayStreak'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return const HomePrayerStreakState(
        weekStartDateKey: '',
        weekDays: <HomePrayerChecklistDay>[],
        completedDateKeys: <String>{},
      );
    }
  }

  final String weekStartDateKey;
  final List<HomePrayerChecklistDay> weekDays;
  final Set<String> completedDateKeys;

  /// Real prayer marks — single source for streaks, charts, and restore.
  final Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory;
  final int bestPrayerStreak;
  final int bestDayStreak;

  HomePrayerStreakState copyWith({
    String? weekStartDateKey,
    List<HomePrayerChecklistDay>? weekDays,
    Set<String>? completedDateKeys,
    Map<String, Map<TrackablePrayer, PrayerMarkStatus>>? statusHistory,
    int? bestPrayerStreak,
    int? bestDayStreak,
  }) {
    return HomePrayerStreakState(
      weekStartDateKey: weekStartDateKey ?? this.weekStartDateKey,
      weekDays: weekDays ?? this.weekDays,
      completedDateKeys: completedDateKeys ?? this.completedDateKeys,
      statusHistory: statusHistory ?? this.statusHistory,
      bestPrayerStreak: bestPrayerStreak ?? this.bestPrayerStreak,
      bestDayStreak: bestDayStreak ?? this.bestDayStreak,
    );
  }

  String toJson() {
    Map<String, dynamic> encodeDay(
      Map<TrackablePrayer, PrayerMarkStatus> day,
    ) => day.map((prayer, status) => MapEntry(prayer.name, status.name));

    return jsonEncode(<String, dynamic>{
      'weekStartDateKey': weekStartDateKey,
      'weekDays': weekDays.map((item) => item.toMap()).toList(),
      'completedDateKeys': completedDateKeys.toList()..sort(),
      'statusHistory': statusHistory.map(
        (key, day) => MapEntry(key, encodeDay(day)),
      ),
      'bestPrayerStreak': bestPrayerStreak,
      'bestDayStreak': bestDayStreak,
    });
  }
}

/// Result returned when a prayer is marked, used for celebration UI sync.
class PrayerMarkResult {
  const PrayerMarkResult({
    required this.prayer,
    required this.status,
    required this.celebrated,
    required this.prayerStreak,
    required this.previousPrayerStreak,
    required this.dayStreak,
  });

  final TrackablePrayer prayer;
  final PrayerMarkStatus status;
  final bool celebrated;
  final int prayerStreak;
  final int previousPrayerStreak;
  final int dayStreak;
}

/// Daily Checklist items that users can track each day.
///
/// [fajr] remains for existing saves. The five obligatory prayers are shown
/// from [TrackablePrayer] marks so Home and the checklist stay in sync.
enum DailyChecklistItem {
  fajr,
  tahajjud,
  quran,
  morningAdhkar,
  eveningAdhkar,
  dhikr,
  istighfar,
  salawat,
  charity,
  smileAtSomeone,
  familyCall,
  noMusicToday,
  noSocialMediaBeforeIsha,
  controlAngerSpeakKindly,
}

extension DailyChecklistItemX on DailyChecklistItem {
  /// Habits stored only on the checklist. Obligatory Fajr is not listed here.
  static Iterable<DailyChecklistItem> get storedHabits =>
      DailyChecklistItem.values.where((e) => e != DailyChecklistItem.fajr);

  bool get isOptionalHabit {
    switch (this) {
      case DailyChecklistItem.tahajjud:
      case DailyChecklistItem.charity:
      case DailyChecklistItem.smileAtSomeone:
      case DailyChecklistItem.familyCall:
      case DailyChecklistItem.noMusicToday:
      case DailyChecklistItem.noSocialMediaBeforeIsha:
      case DailyChecklistItem.controlAngerSpeakKindly:
        return true;
      case DailyChecklistItem.fajr:
      case DailyChecklistItem.quran:
      case DailyChecklistItem.morningAdhkar:
      case DailyChecklistItem.eveningAdhkar:
      case DailyChecklistItem.dhikr:
      case DailyChecklistItem.istighfar:
      case DailyChecklistItem.salawat:
        return false;
    }
  }
}

/// Inclusive calendar range for one Cycle Mode period (active or completed).
class CycleModeInterval {
  const CycleModeInterval({
    required this.startDate,
    required this.endDate,
    this.pauseStreaks = true,
    this.excludeFromStatistics = true,
  });

  factory CycleModeInterval.fromJson(Map<String, dynamic> map) {
    final startMs = map['startDateMs'];
    final endMs = map['endDateMs'];
    final start = startMs is int
        ? DateTime.fromMillisecondsSinceEpoch(startMs)
        : DateTime.now();
    final end = endMs is int
        ? DateTime.fromMillisecondsSinceEpoch(endMs)
        : start;
    final startDay = CycleModeData.dateOnly(start);
    final endDay = CycleModeData.dateOnly(end);
    return CycleModeInterval(
      startDate: startDay,
      endDate: endDay.isBefore(startDay) ? startDay : endDay,
      pauseStreaks: map['pauseStreaks'] as bool? ?? true,
      excludeFromStatistics: map['excludeFromStatistics'] as bool? ?? true,
    );
  }

  final DateTime startDate;
  final DateTime endDate;
  final bool pauseStreaks;
  final bool excludeFromStatistics;

  bool containsDate(DateTime date) {
    final day = CycleModeData.dateOnly(date);
    return !day.isBefore(startDate) && !day.isAfter(endDate);
  }

  bool samePolicyAs(CycleModeInterval other) =>
      pauseStreaks == other.pauseStreaks &&
      excludeFromStatistics == other.excludeFromStatistics;

  /// True when intervals share at least one calendar day (same policy).
  /// Adjacent-only windows (end + 1 == other.start) do **not** merge — each
  /// enable/disable cycle stays a separate historical record.
  bool mergesWith(CycleModeInterval other) {
    if (!samePolicyAs(other)) return false;
    // Overlap: start <= other.end && other.start <= end
    return !startDate.isAfter(other.endDate) &&
        !other.startDate.isAfter(endDate);
  }

  CycleModeInterval mergeWith(CycleModeInterval other) {
    assert(samePolicyAs(other));
    final start = startDate.isBefore(other.startDate)
        ? startDate
        : other.startDate;
    final end = endDate.isAfter(other.endDate) ? endDate : other.endDate;
    return CycleModeInterval(
      startDate: start,
      endDate: end,
      pauseStreaks: pauseStreaks,
      excludeFromStatistics: excludeFromStatistics,
    );
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'startDateMs': startDate.millisecondsSinceEpoch,
    'endDateMs': endDate.millisecondsSinceEpoch,
    'pauseStreaks': pauseStreaks,
    'excludeFromStatistics': excludeFromStatistics,
  };

  @override
  bool operator ==(Object other) {
    return other is CycleModeInterval &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        pauseStreaks == other.pauseStreaks &&
        excludeFromStatistics == other.excludeFromStatistics;
  }

  @override
  int get hashCode =>
      Object.hash(startDate, endDate, pauseStreaks, excludeFromStatistics);
}

/// Lifecycle phases for Cycle Mode — kept separate on purpose:
///
/// * [draft] — values configured, toggle OFF. No pink, no analytics impact.
/// * [active] — toggle ON. Rules apply; valid days may highlight.
/// * [historical] — toggle OFF after a cycle was sealed into [CycleModeData.history]
///   (sealed days still show pink via [CycleModePolicy.isHighlightable]).
///
/// A device may have draft preferences **and** historical intervals at once
/// (next-cycle draft + past sealed windows). Draft fields never create an
/// effective cycle window until the user enables.
enum CycleModePhase { draft, active, historical }

/// Configurable Cycle Mode settings — persisted locally and used by analytics.
///
/// Manual early disable seals the active window through the day **before**
/// the disable date into [history] (disable day is normal). Natural expiry
/// seals the full planned window inclusive. Separate enable sessions never
/// merge across a gap — previous and new cycles stay distinct.
class CycleModeData {
  const CycleModeData({
    required this.isEnabled,
    required this.startDate,
    this.cycleLength = defaultCycleLength,
    this.pauseStreaks = true,
    this.excludeFromStatistics = true,
    this.history = const <CycleModeInterval>[],
  });

  static const int defaultCycleLength = 6;
  static const int minCycleLength = 1;
  static const int maxCycleLength = 14;

  /// Primary phase for the *current* toggle/config.
  /// Historical intervals may still exist alongside a [CycleModePhase.draft].
  CycleModePhase get phase {
    if (isEnabled) return CycleModePhase.active;
    if (history.isNotEmpty) return CycleModePhase.historical;
    return CycleModePhase.draft;
  }

  bool get isDraft => !isEnabled;
  bool get isActive => isEnabled;
  bool get hasHistoricalCycles => history.isNotEmpty;

  factory CycleModeData.disabled({DateTime? startDate}) {
    final today = DateTime.now();
    return CycleModeData(
      isEnabled: false,
      startDate: dateOnly(startDate ?? today),
    );
  }

  factory CycleModeData.fromJson(Map<String, dynamic> map) {
    final startMs = map['startDateMs'];
    final startDate = startMs is int
        ? DateTime.fromMillisecondsSinceEpoch(startMs)
        : DateTime.now();
    final length = (map['cycleLength'] as num?)?.toInt() ?? defaultCycleLength;
    final historyRaw = map['history'] as List<dynamic>? ?? const <dynamic>[];
    final history = <CycleModeInterval>[
      for (final item in historyRaw)
        if (item is Map)
          CycleModeInterval.fromJson(Map<String, dynamic>.from(item)),
    ];
    return CycleModeData(
      isEnabled: map['isEnabled'] as bool? ?? false,
      startDate: dateOnly(startDate),
      cycleLength: length.clamp(minCycleLength, maxCycleLength),
      pauseStreaks: map['pauseStreaks'] as bool? ?? true,
      excludeFromStatistics: map['excludeFromStatistics'] as bool? ?? true,
      history: normalizeHistory(history),
    );
  }

  /// Deduplicate and merge **overlapping** intervals with the same flags.
  /// Adjacent-but-separate cycles are kept as distinct history entries.
  static List<CycleModeInterval> normalizeHistory(
    Iterable<CycleModeInterval> intervals,
  ) {
    final sorted = intervals.toList(growable: false)
      ..sort((a, b) {
        final byStart = a.startDate.compareTo(b.startDate);
        if (byStart != 0) return byStart;
        return a.endDate.compareTo(b.endDate);
      });
    if (sorted.isEmpty) return const <CycleModeInterval>[];

    final merged = <CycleModeInterval>[sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      final current = sorted[i];
      final last = merged.last;
      if (last == current) {
        continue; // exact duplicate
      }
      if (last.mergesWith(current)) {
        merged[merged.length - 1] = last.mergeWith(current);
      } else {
        merged.add(current);
      }
    }
    return List<CycleModeInterval>.unmodifiable(merged);
  }

  /// Combine histories from two states without duplicates.
  static List<CycleModeInterval> mergeHistories(
    Iterable<CycleModeInterval> a,
    Iterable<CycleModeInterval> b,
  ) => normalizeHistory(<CycleModeInterval>[...a, ...b]);

  final bool isEnabled;
  final DateTime startDate;
  final int cycleLength;
  final bool pauseStreaks;
  final bool excludeFromStatistics;

  /// Completed cycle windows (including early manual ends). Kept so past
  /// cycle days remain paused/excluded after Cycle Mode is turned off.
  final List<CycleModeInterval> history;

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Last calendar day of the currently configured active window.
  DateTime get plannedEndDate =>
      dateOnly(startDate).add(Duration(days: cycleLength - 1));

  /// Effective active window — **null in draft** (disabled), even if start/length
  /// are configured. Draft must never affect pink / streaks / stats / charts.
  CycleModeInterval? get activeInterval {
    if (!isEnabled) return null;
    return CycleModeInterval(
      startDate: dateOnly(startDate),
      endDate: plannedEndDate,
      pauseStreaks: pauseStreaks,
      excludeFromStatistics: excludeFromStatistics,
    );
  }

  /// Intervals that actually affect the app: sealed history + active window.
  Iterable<CycleModeInterval> get effectiveIntervals sync* {
    yield* history;
    final active = activeInterval;
    if (active != null) yield active;
  }

  /// True for any **active or historical** cycle day (never draft-only dates).
  bool containsDate(DateTime date) {
    for (final interval in effectiveIntervals) {
      if (interval.containsDate(date)) return true;
    }
    return false;
  }

  CycleModeInterval? intervalFor(DateTime date) {
    for (final interval in effectiveIntervals) {
      if (interval.containsDate(date)) return interval;
    }
    return null;
  }

  /// Removes residue from the earlier Edit-enabled-by-mistake bug, plus any
  /// impossible future-dated history. Safe to run repeatedly.
  CycleModeData purgeLegacyEditBugHistory({DateTime? now}) {
    if (history.isEmpty) return this;
    final today = dateOnly(now ?? DateTime.now());
    final draftStart = dateOnly(startDate);
    final kept = <CycleModeInterval>[];

    for (final interval in history) {
      if (interval.startDate.isAfter(today)) continue;

      final lengthDays =
          interval.endDate.difference(interval.startDate).inDays + 1;
      final isSingleDay = lengthDays <= 1;

      if (!isEnabled) {
        // Same-day ON→OFF artifact: single-day seal equal to "today".
        // A real one-day cycle is sealed when disabling on a *later* day.
        if (isSingleDay &&
            interval.startDate == today &&
            interval.endDate == today) {
          continue;
        }
        if (isSingleDay && interval.startDate != draftStart) continue;
        if (lengthDays <= 2 && interval.endDate.isBefore(draftStart)) {
          continue;
        }
      }

      final end = interval.endDate.isAfter(today) ? today : interval.endDate;
      if (end.isBefore(interval.startDate)) continue;

      kept.add(
        CycleModeInterval(
          startDate: interval.startDate,
          endDate: end,
          pauseStreaks: interval.pauseStreaks,
          excludeFromStatistics: interval.excludeFromStatistics,
        ),
      );
    }

    final normalized = normalizeHistory(kept);
    if (_historyEquals(normalized, history)) return this;
    return copyWith(history: normalized);
  }

  static bool _historyEquals(
    List<CycleModeInterval> a,
    List<CycleModeInterval> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Toggle ON **and** [now] falls inside the configured active window
  /// (inclusive start → planned end). Before start or after the window ends,
  /// Cycle Mode is configured but not *running*.
  bool isRunningOn(DateTime now) {
    if (!isEnabled) return false;
    final today = dateOnly(now);
    final start = dateOnly(startDate);
    final end = plannedEndDate;
    return !today.isBefore(start) && !today.isAfter(end);
  }

  int daysRemainingOn(DateTime now) {
    if (!isEnabled) return 0;
    final today = dateOnly(now);
    final start = dateOnly(startDate);
    final end = plannedEndDate;
    if (today.isBefore(start) || today.isAfter(end)) return 0;
    return end.difference(today).inDays + 1;
  }

  bool hasExpiredOn(DateTime now) {
    if (!isEnabled) return false;
    return dateOnly(now).difference(dateOnly(startDate)).inDays >= cycleLength;
  }

  /// Ends the active cycle. The disable [date] itself is a **normal** day;
  /// history seals through the previous calendar day (capped at [plannedEndDate]).
  ///
  /// Example: active 1–3 Aug, disable on 4 Aug → history ends 3 Aug; 4 Aug is ❌.
  /// Same-day enable→disable seals nothing (disable day stays normal; prayer
  /// history/graph must not be hidden by a one-day pause/exclude seal).
  /// Idempotent when already disabled — never appends duplicate history.
  CycleModeData disableOn(DateTime date) {
    if (!isEnabled) {
      return copyWith(history: normalizeHistory(history));
    }
    final start = dateOnly(startDate);
    final plannedEnd = plannedEndDate;
    final day = dateOnly(date);

    // Disable before the window starts — nothing to seal.
    if (day.isBefore(start)) {
      return copyWith(isEnabled: false, history: normalizeHistory(history));
    }

    final DateTime end;
    if (day.isAfter(plannedEnd)) {
      // Already past natural end — seal the full planned window.
      end = plannedEnd;
    } else {
      // Disable day is exclusive (returns to normal), including start day.
      end = day.subtract(const Duration(days: 1));
    }

    if (end.isBefore(start)) {
      return copyWith(isEnabled: false, history: normalizeHistory(history));
    }

    final sealed = CycleModeInterval(
      startDate: start,
      endDate: end,
      pauseStreaks: pauseStreaks,
      excludeFromStatistics: excludeFromStatistics,
    );
    return copyWith(
      isEnabled: false,
      history: normalizeHistory(<CycleModeInterval>[...history, sealed]),
    );
  }

  /// Natural end after the full configured length (last day inclusive).
  CycleModeData expireFully() {
    if (!isEnabled) {
      return copyWith(history: normalizeHistory(history));
    }
    final sealed = CycleModeInterval(
      startDate: dateOnly(startDate),
      endDate: plannedEndDate,
      pauseStreaks: pauseStreaks,
      excludeFromStatistics: excludeFromStatistics,
    );
    return copyWith(
      isEnabled: false,
      history: normalizeHistory(<CycleModeInterval>[...history, sealed]),
    );
  }

  /// Start a new active cycle while preserving normalized history.
  CycleModeData enableWith({
    required DateTime startDate,
    int? cycleLength,
    bool? pauseStreaks,
    bool? excludeFromStatistics,
    List<CycleModeInterval>? history,
  }) {
    return copyWith(
      isEnabled: true,
      startDate: startDate,
      cycleLength: cycleLength,
      pauseStreaks: pauseStreaks,
      excludeFromStatistics: excludeFromStatistics,
      history: normalizeHistory(history ?? this.history),
    );
  }

  /// Persist settings without enabling. Used by Edit → Save while Cycle Mode
  /// is off — the toggle + Save (enabling sheet) is what turns it on.
  CycleModeData saveDraft({
    required DateTime startDate,
    int? cycleLength,
    bool? pauseStreaks,
    bool? excludeFromStatistics,
  }) {
    return copyWith(
      isEnabled: false,
      startDate: startDate,
      cycleLength: cycleLength,
      pauseStreaks: pauseStreaks,
      excludeFromStatistics: excludeFromStatistics,
      history: history,
    );
  }

  /// Update settings on an already-active cycle by **extending/shrinking the
  /// same window** (start date kept unless explicitly changed) — never starts
  /// a second overlapping cycle or seals history.
  ///
  /// Example: start 1 Aug, length 6 → length 8 keeps start 1 Aug and ends 8 Aug.
  /// Shrinking cannot move the end before [now]; length is clamped so today
  /// remains inside the active window.
  CycleModeData updateActiveCycle({
    DateTime? startDate,
    int? cycleLength,
    bool? pauseStreaks,
    bool? excludeFromStatistics,
    DateTime? now,
  }) {
    final start = dateOnly(startDate ?? this.startDate);
    var length = (cycleLength ?? this.cycleLength).clamp(
      minCycleLength,
      maxCycleLength,
    );
    final today = dateOnly(now ?? DateTime.now());
    final elapsed = today.difference(start).inDays;
    if (elapsed >= 0) {
      final minLengthThroughToday = elapsed + 1;
      if (length < minLengthThroughToday) {
        length = minLengthThroughToday.clamp(minCycleLength, maxCycleLength);
      }
    }
    return copyWith(
      isEnabled: true,
      startDate: start,
      cycleLength: length,
      pauseStreaks: pauseStreaks,
      excludeFromStatistics: excludeFromStatistics,
      history: history,
    );
  }

  CycleModeData copyWith({
    bool? isEnabled,
    DateTime? startDate,
    int? cycleLength,
    bool? pauseStreaks,
    bool? excludeFromStatistics,
    List<CycleModeInterval>? history,
  }) {
    return CycleModeData(
      isEnabled: isEnabled ?? this.isEnabled,
      startDate: startDate != null ? dateOnly(startDate) : this.startDate,
      cycleLength: (cycleLength ?? this.cycleLength).clamp(
        minCycleLength,
        maxCycleLength,
      ),
      pauseStreaks: pauseStreaks ?? this.pauseStreaks,
      excludeFromStatistics:
          excludeFromStatistics ?? this.excludeFromStatistics,
      history: history != null ? normalizeHistory(history) : this.history,
    );
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'isEnabled': isEnabled,
    'startDateMs': dateOnly(startDate).millisecondsSinceEpoch,
    'cycleLength': cycleLength,
    'pauseStreaks': pauseStreaks,
    'excludeFromStatistics': excludeFromStatistics,
    'history': [for (final interval in history) interval.toJsonMap()],
  };

  String toJson() => jsonEncode(toJsonMap());
}

/// Daily checklist state for a single day
class DailyChecklistState {
  const DailyChecklistState({
    required this.dateKey,
    this.completedItems = const <DailyChecklistItem>{},
  });

  factory DailyChecklistState.fromJson(String source) {
    try {
      final map = jsonDecode(source) as Map<String, dynamic>;
      final completedItems = <DailyChecklistItem>{};
      for (final value
          in (map['completedItems'] as List<dynamic>? ?? const <dynamic>[])) {
        if (value is! String) continue;
        for (final item in DailyChecklistItem.values) {
          if (item.name == value) {
            completedItems.add(item);
            break;
          }
        }
      }

      return DailyChecklistState(
        dateKey: map['dateKey'] as String? ?? '',
        completedItems: completedItems,
      );
    } catch (_) {
      return const DailyChecklistState(
        dateKey: '',
        completedItems: <DailyChecklistItem>{},
      );
    }
  }

  final String dateKey;
  final Set<DailyChecklistItem> completedItems;

  DailyChecklistState copyWith({
    String? dateKey,
    Set<DailyChecklistItem>? completedItems,
  }) {
    return DailyChecklistState(
      dateKey: dateKey ?? this.dateKey,
      completedItems: completedItems ?? this.completedItems,
    );
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'dateKey': dateKey,
      'completedItems': completedItems.map((item) => item.name).toList(),
    });
  }
}
