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
    required this.arabicText,
    required this.englishText,
  });

  final int surahNumber;
  final int ayahNumber;
  final String surahName;
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

class HomePrayerChecklistDay {
  const HomePrayerChecklistDay({
    required this.dateKey,
    required this.selectedPrayers,
  });

  factory HomePrayerChecklistDay.fromMap(Map<String, dynamic> map) {
    return HomePrayerChecklistDay(
      dateKey: map['dateKey'] as String? ?? '',
      selectedPrayers:
          (map['selectedPrayers'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .map(
                (value) => TrackablePrayer.values.firstWhere(
                  (prayer) => prayer.name == value,
                  orElse: () => TrackablePrayer.fajr,
                ),
              )
              .toSet(),
    );
  }

  final String dateKey;
  final Set<TrackablePrayer> selectedPrayers;

  bool get isCompleted =>
      selectedPrayers.length == TrackablePrayer.values.length;

  HomePrayerChecklistDay copyWith({
    String? dateKey,
    Set<TrackablePrayer>? selectedPrayers,
  }) {
    return HomePrayerChecklistDay(
      dateKey: dateKey ?? this.dateKey,
      selectedPrayers: selectedPrayers ?? this.selectedPrayers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateKey': dateKey,
      'selectedPrayers': selectedPrayers.map((item) => item.name).toList(),
    };
  }
}

class HomePrayerStreakState {
  const HomePrayerStreakState({
    required this.weekStartDateKey,
    required this.weekDays,
    required this.completedDateKeys,
  });

  factory HomePrayerStreakState.empty({required String weekStartDateKey}) {
    return HomePrayerStreakState(
      weekStartDateKey: weekStartDateKey,
      weekDays: const <HomePrayerChecklistDay>[],
      completedDateKeys: const <String>{},
    );
  }

  factory HomePrayerStreakState.fromJson(String source) {
    try {
      final map = jsonDecode(source) as Map<String, dynamic>;
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
        completedDateKeys:
            (map['completedDateKeys'] as List<dynamic>? ?? const <dynamic>[])
                .whereType<String>()
                .toSet(),
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

  HomePrayerStreakState copyWith({
    String? weekStartDateKey,
    List<HomePrayerChecklistDay>? weekDays,
    Set<String>? completedDateKeys,
  }) {
    return HomePrayerStreakState(
      weekStartDateKey: weekStartDateKey ?? this.weekStartDateKey,
      weekDays: weekDays ?? this.weekDays,
      completedDateKeys: completedDateKeys ?? this.completedDateKeys,
    );
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'weekStartDateKey': weekStartDateKey,
      'weekDays': weekDays.map((item) => item.toMap()).toList(),
      'completedDateKeys': completedDateKeys.toList()..sort(),
    });
  }
}
