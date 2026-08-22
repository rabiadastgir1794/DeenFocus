import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deenly/features/quran/reading_engine/quran_audio_handler.dart';

void main() {
  test('media item id is surah:ayah for lock-screen skip mapping', () {
    final item = QuranAudioHandler.mediaItemFor(
      surahNumber: 1,
      ayahNumber: 7,
      surahName: 'Al-Fatihah',
    );
    expect(item, isA<MediaItem>());
    expect(item.id, '1:7');
    expect(item.album, 'Al-Fatihah');
    expect(item.title, 'Al-Fatihah · 7');
    expect(item.artist, 'DeenFocus');
    expect(item.artUri, isNull);
  });
}
