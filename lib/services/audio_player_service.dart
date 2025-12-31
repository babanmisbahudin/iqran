import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_service.dart';

enum PlayerStateStatus {
  idle,
  loading,
  playing,
  paused,
}

class AudioPlayerService {
  static final AudioPlayer _player = AudioPlayer();

  static final ValueNotifier<PlayerStateStatus> status =
      ValueNotifier(PlayerStateStatus.idle);

  static bool _initialized = false;

  static void _listenPlayerState() {
    if (_initialized) return;
    _initialized = true;

    _player.playerStateStream.listen((playerState) {
      final processing = playerState.processingState;
      final playing = playerState.playing;

      if (processing == ProcessingState.loading ||
          processing == ProcessingState.buffering) {
        status.value = PlayerStateStatus.loading;
      } else if (playing) {
        status.value = PlayerStateStatus.playing;
      } else if (processing == ProcessingState.ready) {
        status.value = PlayerStateStatus.paused;
      } else {
        status.value = PlayerStateStatus.idle;
      }
    });
  }

  static Future<void> playSurah(int surahNumber) async {
    try {
      _listenPlayerState();

      final url = await AudioService.getAudioUrl(surahNumber);
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      status.value = PlayerStateStatus.idle;
      debugPrint('Audio error: $e');
    }
  }

  static Future<void> pause() async {
    await _player.pause();
  }

  static Future<void> resume() async {
    await _player.play();
  }

  static Future<void> stop() async {
    await _player.stop();
    status.value = PlayerStateStatus.idle;
  }
}
