import 'package:just_audio/just_audio.dart';
import 'audio_service.dart';

class AudioPlayerService {
  static final AudioPlayer _player = AudioPlayer();

  static AudioPlayer get player => _player;

  static Future<void> playSurah(int surahNumber) async {
    final url = await AudioService.getAudioUrl(surahNumber);
    await _player.setUrl(url);
    await _player.play();
  }

  static Future<void> pause() async {
    await _player.pause();
  }

  static Future<void> stop() async {
    await _player.stop();
  }

  static bool get isPlaying => _player.playing;
}
