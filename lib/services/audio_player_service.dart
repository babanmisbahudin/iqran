import 'package:just_audio/just_audio.dart';
import 'audio_service.dart';

class AudioPlayerService {
  static final AudioPlayer _player = AudioPlayer();

  static bool get isPlaying => _player.playing;

  static Future<void> playSurah(int surahNumber) async {
    final qariKey = await AudioService.loadQari();

    final url =
        'https://equran.id/content/audio/$qariKey/${surahNumber.toString().padLeft(3, '0')}.mp3';

    await _player.setUrl(url);
    await _player.play();
  }

  static Future<void> pause() async {
    await _player.pause();
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
