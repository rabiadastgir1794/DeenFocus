import 'package:just_audio/just_audio.dart';

import '../../../core/services/storage_service.dart';
import '../data/quran_local_repository.dart';
import 'quran_audio_handler.dart';
import 'quran_recitation.dart';
import 'quran_repeat_mode.dart';

/// Wraps a single [AudioPlayer] instance with the playback-speed, volume and
/// repeat controls shared by the Juz and Page reading screens. Each screen
/// still owns (and disposes) its own controller/player — this does not
/// introduce a global/shared audio service, per Phase 1 scope.
///
/// The existing Surah reading screen keeps its own local `AudioPlayer`
/// wiring untouched; it gained the same speed/volume/repeat controls
/// directly (see `surah_detail_bottom_sheet.dart`) rather than being
/// refactored onto this class, to avoid touching already-working code.
class QuranAudioController {
  QuranAudioController() : player = AudioPlayer();

  final AudioPlayer player;

  Future<void> loadPreferences() async {
    final results = await Future.wait<Object>([
      StorageService.quranPlaybackSpeed,
      StorageService.quranPlaybackVolume,
      StorageService.quranRepeatMode,
    ]);
    final speed = results[0] as double;
    final volume = results[1] as double;
    final repeatMode = QuranRepeatMode.fromName(results[2] as String);
    await player.setSpeed(speed);
    await player.setVolume(volume);
    await _applyLoopMode(repeatMode);
  }

  Future<void> setPlaylist(List<AyahRecord> ayahs) async {
    final names = <int, String>{};
    for (final number in ayahs.map((ayah) => ayah.surahNumber).toSet()) {
      final surah = await QuranLocalRepository.instance.getSurah(number);
      names[number] = surah?.name ?? 'Surah $number';
    }
    final items = ayahs
        .map(
          (ayah) => QuranAudioHandler.mediaItemFor(
            surahNumber: ayah.surahNumber,
            ayahNumber: ayah.ayahNumber,
            surahName: names[ayah.surahNumber]!,
          ),
        )
        .toList(growable: false);
    final source = ConcatenatingAudioSource(
      children: ayahs
          .map(
            (ayah) => AudioSource.uri(
              Uri.parse(
                QuranRecitation.audioUrl(ayah.surahNumber, ayah.ayahNumber),
              ),
            ),
          )
          .toList(growable: false),
    );
    await player.setAudioSource(source, preload: true);
    await QuranAudioHandler.instance.attach(player: player, items: items);
  }

  Future<void> setSpeed(double speed) async {
    await player.setSpeed(speed);
    await StorageService.setQuranPlaybackSpeed(speed);
  }

  Future<void> setVolume(double volume) async {
    await player.setVolume(volume);
    await StorageService.setQuranPlaybackVolume(volume);
  }

  Future<void> setRepeatMode(QuranRepeatMode mode) async {
    await _applyLoopMode(mode);
    await StorageService.setQuranRepeatMode(mode.name);
  }

  Future<void> _applyLoopMode(QuranRepeatMode mode) async {
    switch (mode) {
      case QuranRepeatMode.off:
        await player.setLoopMode(LoopMode.off);
      case QuranRepeatMode.ayah:
        await player.setLoopMode(LoopMode.one);
      case QuranRepeatMode.surah:
        await player.setLoopMode(LoopMode.all);
    }
  }

  Future<void> dispose() async {
    QuranAudioHandler.instance.detach(player);
    await player.dispose();
  }
}
