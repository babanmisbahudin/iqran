import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

/// Custom AudioHandler untuk mengelola background audio playback
class IqranAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;
  late final BehaviorSubject<PlaybackState> _playbackState;
  late final BehaviorSubject<List<MediaItem>> _queue;
  late final BehaviorSubject<MediaItem?> _currentMediaItem;

  IqranAudioHandler(this._player) {
    // Initialize BehaviorSubjects dengan default values
    _playbackState = BehaviorSubject<PlaybackState>.seeded(
      PlaybackState(
        controls: const [MediaControl.play],
        systemActions: const {MediaAction.seek},
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
    _queue = BehaviorSubject<List<MediaItem>>.seeded([]);
    _currentMediaItem = BehaviorSubject<MediaItem?>.seeded(null);
    _init();
  }

  Future<void> _init() async {
    // Initialize queue and mediaItem streams
    queue.addStream(_queue.stream);
    mediaItem.addStream(_currentMediaItem.stream);

    // Listen to player state dan broadcast ke system
    _player.playerStateStream.listen(_broadcastState);
    _player.positionStream.listen((_) => _broadcastState(_player.playerState));

    // Set initial state
    _broadcastState(_player.playerState);
  }

  /// Broadcast player state ke system notification dan lock screen
  void _broadcastState(PlayerState playerState) {
    final isPlaying = playerState.playing;
    final processingState = playerState.processingState;

    late final AudioProcessingState audioProcessingState;
    switch (processingState) {
      case ProcessingState.idle:
        audioProcessingState = AudioProcessingState.idle;
        break;
      case ProcessingState.loading:
        audioProcessingState = AudioProcessingState.loading;
        break;
      case ProcessingState.buffering:
        audioProcessingState = AudioProcessingState.buffering;
        break;
      case ProcessingState.ready:
        audioProcessingState = AudioProcessingState.ready;
        break;
      case ProcessingState.completed:
        audioProcessingState = AudioProcessingState.completed;
        break;
    }

    playbackState.add(
      _playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
          MediaAction.skipToPrevious,
          MediaAction.skipToNext,
        },
        processingState: audioProcessingState,
        playing: isPlaying,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );

    _playbackState.add(playbackState.value);
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    // Handled by AudioPlayerService
  }

  @override
  Future<void> skipToPrevious() async {
    // Handled by AudioPlayerService
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    _currentMediaItem.add(mediaItem);
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playbackState.value.playing)
          MediaControl.pause
        else
          MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
    ));
  }

  /// Update media item untuk notification
  void setMediaItem(MediaItem mediaItem) {
    _currentMediaItem.add(mediaItem);
  }

  /// Dispose resources
  @override
  Future<void> onTaskRemoved() async {
    await stop();
    await super.onTaskRemoved();
  }

  void dispose() {
    _playbackState.close();
    _queue.close();
    _currentMediaItem.close();
  }
}
