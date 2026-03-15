import 'dart:convert';

import '../../home/model/home_models.dart';

enum FocusModeType { child, nightDiscipline, salah }

enum ChildLockType { indefinite, timed }

class FocusInstalledApp {
  const FocusInstalledApp({
    required this.packageName,
    required this.appName,
    required this.isSystemApp,
  });

  factory FocusInstalledApp.fromMap(Map<Object?, Object?> map) {
    return FocusInstalledApp(
      packageName: map['packageName'] as String? ?? '',
      appName: map['appName'] as String? ?? 'Unknown',
      isSystemApp: map['isSystemApp'] as bool? ?? false,
    );
  }

  final String packageName;
  final String appName;
  final bool isSystemApp;
}

class FocusTimeRange {
  const FocusTimeRange({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });

  const FocusTimeRange.defaults()
    : startHour = 22,
      startMinute = 0,
      endHour = 6,
      endMinute = 0;

  factory FocusTimeRange.fromMap(Map<String, dynamic> map) {
    return FocusTimeRange(
      startHour: (map['startHour'] as num?)?.toInt() ?? 22,
      startMinute: (map['startMinute'] as num?)?.toInt() ?? 0,
      endHour: (map['endHour'] as num?)?.toInt() ?? 6,
      endMinute: (map['endMinute'] as num?)?.toInt() ?? 0,
    );
  }

  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  int get startTotalMinutes => startHour * 60 + startMinute;
  int get endTotalMinutes => endHour * 60 + endMinute;

  bool contains(DateTime now) {
    final currentMinutes = now.hour * 60 + now.minute;
    if (startTotalMinutes == endTotalMinutes) return true;
    if (startTotalMinutes < endTotalMinutes) {
      return currentMinutes >= startTotalMinutes &&
          currentMinutes < endTotalMinutes;
    }
    return currentMinutes >= startTotalMinutes ||
        currentMinutes < endTotalMinutes;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
    };
  }
}

class FocusSettings {
  const FocusSettings({
    required this.selectedApps,
    required this.iosSelectionData,
    required this.iosSelectionCount,
    required this.childModeEnabled,
    required this.childLockType,
    required this.childLockDurationMinutes,
    required this.childLockedUntil,
    required this.nightDisciplineEnabled,
    required this.nightRange,
    required this.salahModeEnabled,
    required this.temporarilyUnlockedUntil,
  });

  factory FocusSettings.defaults() {
    return const FocusSettings(
      selectedApps: <String, String>{},
      iosSelectionData: null,
      iosSelectionCount: 0,
      childModeEnabled: false,
      childLockType: ChildLockType.indefinite,
      childLockDurationMinutes: 30,
      childLockedUntil: null,
      nightDisciplineEnabled: false,
      nightRange: FocusTimeRange.defaults(),
      salahModeEnabled: false,
      temporarilyUnlockedUntil: null,
    );
  }

  factory FocusSettings.fromJson(String source) {
    try {
      final map = jsonDecode(source) as Map<String, dynamic>;
      final selectedAppsRaw = Map<String, dynamic>.from(
        map['selectedApps'] as Map? ?? const {},
      );
      return FocusSettings(
        selectedApps: selectedAppsRaw.map(
          (key, value) => MapEntry(key, value as String),
        ),
        iosSelectionData: map['iosSelectionData'] as String?,
        iosSelectionCount: (map['iosSelectionCount'] as num?)?.toInt() ?? 0,
        childModeEnabled: map['childModeEnabled'] as bool? ?? false,
        childLockType:
            (map['childLockType'] as String?) == ChildLockType.timed.name
            ? ChildLockType.timed
            : ChildLockType.indefinite,
        childLockDurationMinutes:
            (map['childLockDurationMinutes'] as num?)?.toInt() ?? 30,
        childLockedUntil: _parseDateTime(map['childLockedUntil']),
        nightDisciplineEnabled: map['nightDisciplineEnabled'] as bool? ?? false,
        nightRange: FocusTimeRange.fromMap(
          Map<String, dynamic>.from(map['nightRange'] as Map? ?? const {}),
        ),
        salahModeEnabled: map['salahModeEnabled'] as bool? ?? false,
        temporarilyUnlockedUntil: _parseDateTime(
          map['temporarilyUnlockedUntil'],
        ),
      );
    } catch (_) {
      return FocusSettings.defaults();
    }
  }

  final Map<String, String> selectedApps;
  final String? iosSelectionData;
  final int iosSelectionCount;
  final bool childModeEnabled;
  final ChildLockType childLockType;
  final int childLockDurationMinutes;
  final DateTime? childLockedUntil;
  final bool nightDisciplineEnabled;
  final FocusTimeRange nightRange;
  final bool salahModeEnabled;
  final DateTime? temporarilyUnlockedUntil;

  FocusModeType? get enabledMode {
    if (childModeEnabled) return FocusModeType.child;
    if (nightDisciplineEnabled) return FocusModeType.nightDiscipline;
    if (salahModeEnabled) return FocusModeType.salah;
    return null;
  }

  bool get hasSelectedApps => selectedApps.isNotEmpty || iosSelectionCount > 0;

  FocusSettings copyWith({
    Map<String, String>? selectedApps,
    String? iosSelectionData,
    bool clearIosSelectionData = false,
    int? iosSelectionCount,
    bool? childModeEnabled,
    ChildLockType? childLockType,
    int? childLockDurationMinutes,
    DateTime? childLockedUntil,
    bool clearChildLockedUntil = false,
    bool? nightDisciplineEnabled,
    FocusTimeRange? nightRange,
    bool? salahModeEnabled,
    DateTime? temporarilyUnlockedUntil,
    bool clearTemporaryUnlock = false,
  }) {
    return FocusSettings(
      selectedApps: selectedApps ?? this.selectedApps,
      iosSelectionData: clearIosSelectionData
          ? null
          : iosSelectionData ?? this.iosSelectionData,
      iosSelectionCount: iosSelectionCount ?? this.iosSelectionCount,
      childModeEnabled: childModeEnabled ?? this.childModeEnabled,
      childLockType: childLockType ?? this.childLockType,
      childLockDurationMinutes:
          childLockDurationMinutes ?? this.childLockDurationMinutes,
      childLockedUntil: clearChildLockedUntil
          ? null
          : childLockedUntil ?? this.childLockedUntil,
      nightDisciplineEnabled:
          nightDisciplineEnabled ?? this.nightDisciplineEnabled,
      nightRange: nightRange ?? this.nightRange,
      salahModeEnabled: salahModeEnabled ?? this.salahModeEnabled,
      temporarilyUnlockedUntil: clearTemporaryUnlock
          ? null
          : temporarilyUnlockedUntil ?? this.temporarilyUnlockedUntil,
    );
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'selectedApps': selectedApps,
      'iosSelectionData': iosSelectionData,
      'iosSelectionCount': iosSelectionCount,
      'childModeEnabled': childModeEnabled,
      'childLockType': childLockType.name,
      'childLockDurationMinutes': childLockDurationMinutes,
      'childLockedUntil': childLockedUntil?.toIso8601String(),
      'nightDisciplineEnabled': nightDisciplineEnabled,
      'nightRange': nightRange.toMap(),
      'salahModeEnabled': salahModeEnabled,
      'temporarilyUnlockedUntil': temporarilyUnlockedUntil?.toIso8601String(),
    });
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }
}

class FocusLockState {
  const FocusLockState({
    required this.isLocked,
    required this.activeMode,
    required this.reason,
    required this.nextChangeAt,
    required this.isTemporarilyUnlocked,
  });

  const FocusLockState.unlocked()
    : isLocked = false,
      activeMode = null,
      reason = null,
      nextChangeAt = null,
      isTemporarilyUnlocked = false;

  final bool isLocked;
  final FocusModeType? activeMode;
  final String? reason;
  final DateTime? nextChangeAt;
  final bool isTemporarilyUnlocked;
}

class SalahWindow {
  const SalahWindow({
    required this.prayer,
    required this.start,
    required this.end,
  });

  final HomePrayerSlot prayer;
  final DateTime start;
  final DateTime end;
}
