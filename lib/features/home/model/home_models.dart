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
