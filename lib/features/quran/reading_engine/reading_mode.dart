/// The three Phase 1 reading modes. See `memory/features/quran-reader/`.
enum ReadingMode {
  surah,
  juz,
  page;

  static ReadingMode fromName(String? name, {ReadingMode fallback = surah}) {
    return ReadingMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => fallback,
    );
  }
}
