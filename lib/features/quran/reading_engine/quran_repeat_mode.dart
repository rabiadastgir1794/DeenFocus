/// Audio repeat behavior shared by the Surah, Juz and Page reading screens.
enum QuranRepeatMode {
  off,
  ayah,
  surah;

  static QuranRepeatMode fromName(String? name) {
    return QuranRepeatMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => QuranRepeatMode.off,
    );
  }
}
