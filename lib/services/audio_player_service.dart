import 'package:audio_service/audio_service.dart' as audio_service_pkg;
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/audio_metadata.dart';
import 'audio_service.dart';
import 'background_audio_service.dart';

export '../models/audio_playback_state.dart';

enum PlayerStateStatus {
  idle,
  loading,
  playing,
  paused,
  error,
}

class AudioPlayerService {
  static final AudioPlayer _player = AudioPlayer();

  // State management
  static final ValueNotifier<PlayerStateStatus> status =
      ValueNotifier(PlayerStateStatus.idle);

  static final ValueNotifier<AudioMetadata?> currentMetadata =
      ValueNotifier<AudioMetadata?>(null);

  // Streams untuk tracking progress
  static late final Stream<Duration> _positionStream;
  static late final Stream<Duration?> _durationStream;
  static late final Stream<Duration> _bufferedPositionStream;

  // Playlist support
  static List<int>? _playlist;
  static int _playlistIndex = 0;

  static bool _initialized = false;

  static void _listenPlayerState() {
    if (_initialized) return;
    _initialized = true;

    // Listen to player state
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
      } else if (processing == ProcessingState.completed) {
        status.value = PlayerStateStatus.paused;
        // Auto play next in playlist jika ada
        if (_playlist != null && _playlistIndex < _playlist!.length - 1) {
          _playlistIndex++;
          _playNextInPlaylist();
        }
      } else {
        status.value = PlayerStateStatus.idle;
      }
    });

    // Setup streams
    _positionStream = _player.positionStream.asBroadcastStream();
    _durationStream = _player.durationStream.asBroadcastStream();
    _bufferedPositionStream =
        _player.bufferedPositionStream.asBroadcastStream();
  }

  /// Play surah dengan metadata (new enhanced method)
  static Future<void> playSurahWithMetadata(
    int surahNumber, {
    required String surahName,
    required String surahNameLatin,
    required int ayatCount,
    List<int>? playlist,
    int playlistIndex = 0,
  }) async {
    try {
      _listenPlayerState();

      // Get selected qari
      final qariKey = await AudioService.loadQari();
      final qariName = AudioService.qariList[qariKey]!;

      // Get audio URL
      final url = await AudioService.getAudioUrl(surahNumber);

      // Create metadata
      final metadata = AudioMetadata(
        surahNumber: surahNumber,
        surahName: surahName,
        surahNameLatin: surahNameLatin,
        ayatCount: ayatCount,
        qariName: qariName,
        qariKey: qariKey,
        audioUrl: url,
        previousSurah: (playlistIndex > 0 && playlist != null)
            ? playlist[playlistIndex - 1]
            : null,
        nextSurah: (playlist != null && playlistIndex < playlist.length - 1)
            ? playlist[playlistIndex + 1]
            : null,
      );

      // Update state
      _playlist = playlist;
      _playlistIndex = playlistIndex;
      currentMetadata.value = metadata;

      // Load and play
      await _player.setUrl(url);
      await _player.play();

      // Update audio service notification
      _updateAudioServiceNotification(metadata);
    } catch (e) {
      status.value = PlayerStateStatus.error;
      debugPrint('❌ Audio error: $e');
      rethrow;
    }
  }

  /// Legacy method untuk backward compatibility
  static Future<void> playSurah(int surahNumber) async {
    try {
      _listenPlayerState();

      final url = await AudioService.getAudioUrl(surahNumber);
      await _player.setUrl(url);
      await _player.play();

      _playlist = null;
      _playlistIndex = 0;
    } catch (e) {
      status.value = PlayerStateStatus.idle;
      debugPrint('❌ Audio error: $e');
    }
  }

  /// Seek ke posisi tertentu
  static Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      debugPrint('❌ Seek error: $e');
      rethrow;
    }
  }

  /// Play next surah in playlist
  static Future<void> playNext() async {
    if (_playlist == null || _playlistIndex >= _playlist!.length - 1) {
      debugPrint('⚠️ Already at last surah');
      return;
    }

    _playlistIndex++;
    await _playNextInPlaylist();
  }

  /// Play previous surah in playlist
  static Future<void> playPrevious() async {
    if (_playlist == null || _playlistIndex == 0) {
      debugPrint('⚠️ Already at first surah');
      return;
    }

    _playlistIndex--;
    await _playNextInPlaylist();
  }

  /// Internal method untuk play surah dalam playlist
  static Future<void> _playNextInPlaylist() async {
    if (_playlist == null || _playlistIndex >= _playlist!.length) {
      return;
    }

    final surahNumber = _playlist![_playlistIndex];
    try {
      final url = await AudioService.getAudioUrl(surahNumber);
      final qariKey = await AudioService.loadQari();
      final qariName = AudioService.qariList[qariKey]!;

      // Update metadata
      final metadata = currentMetadata.value?.copyWith(
        surahNumber: surahNumber,
        audioUrl: url,
        qariKey: qariKey,
        qariName: qariName,
        previousSurah:
            _playlistIndex > 0 ? _playlist![_playlistIndex - 1] : null,
        nextSurah: _playlistIndex < _playlist!.length - 1
            ? _playlist![_playlistIndex + 1]
            : null,
      );

      if (metadata != null) {
        currentMetadata.value = metadata;
        _updateAudioServiceNotification(metadata);
      }

      // Load and play
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      status.value = PlayerStateStatus.error;
      debugPrint('❌ Error playing next: $e');
    }
  }

  /// Update notification di system (via AudioService)
  static void _updateAudioServiceNotification(AudioMetadata metadata) {
    try {
      final handler = BackgroundAudioService.audioHandler;
      if (handler != null) {
        final mediaItem = audio_service_pkg.MediaItem(
          id: 'surah_${metadata.surahNumber}',
          title: metadata.surahName,
          artist: metadata.qariName,
          album: 'Quran',
          duration: _player.duration,
          artUri: Uri.parse(
            'https://via.placeholder.com/512?text=${metadata.surahNameLatin}',
          ),
        );
        handler.mediaItem.add(mediaItem);
      }
    } catch (e) {
      debugPrint('⚠️ Error updating notification: $e');
    }
  }

  /// Get position stream
  static Stream<Duration> get positionStream {
    _listenPlayerState();
    return _positionStream;
  }

  /// Get duration stream
  static Stream<Duration?> get durationStream {
    _listenPlayerState();
    return _durationStream;
  }

  /// Get buffered position stream
  static Stream<Duration> get bufferedPositionStream {
    _listenPlayerState();
    return _bufferedPositionStream;
  }

  /// Check if can play next
  static bool get canPlayNext =>
      _playlist != null && _playlistIndex < _playlist!.length - 1;

  /// Check if can play previous
  static bool get canPlayPrevious =>
      _playlist != null && _playlistIndex > 0;

  /// Pause playback
  static Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback
  static Future<void> resume() async {
    await _player.play();
  }

  /// Stop playback dan clear metadata
  static Future<void> stop() async {
    await _player.stop();
    status.value = PlayerStateStatus.idle;
    currentMetadata.value = null;
    _playlist = null;
    _playlistIndex = 0;
  }

  /// Dispose semua resources
  static Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}
