import 'audio_metadata.dart';

enum PlayerStateStatus {
  idle,
  loading,
  playing,
  paused,
  error,
}

/// State lengkap untuk audio playback
class AudioPlaybackState {
  final PlayerStateStatus status;
  final AudioMetadata? metadata;
  final Duration position;
  final Duration? duration;
  final double? bufferedPosition;
  final bool isBuffering;
  final String? errorMessage;

  AudioPlaybackState({
    required this.status,
    this.metadata,
    this.position = Duration.zero,
    this.duration,
    this.bufferedPosition,
    this.isBuffering = false,
    this.errorMessage,
  });

  /// Copy with untuk membuat instance baru dengan perubahan tertentu
  AudioPlaybackState copyWith({
    PlayerStateStatus? status,
    AudioMetadata? metadata,
    Duration? position,
    Duration? duration,
    double? bufferedPosition,
    bool? isBuffering,
    String? errorMessage,
  }) {
    return AudioPlaybackState(
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      isBuffering: isBuffering ?? this.isBuffering,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Hitung progress sebagai persentase (0.0 - 1.0)
  double get progress {
    if (duration == null || duration!.inMilliseconds == 0) {
      return 0.0;
    }
    final pos = position.inMilliseconds.toDouble();
    final dur = duration!.inMilliseconds.toDouble();
    return (pos / dur).clamp(0.0, 1.0);
  }

  /// Format waktu untuk display
  String get positionFormatted => _formatDuration(position);
  String get durationFormatted => _formatDuration(duration ?? Duration.zero);

  /// Helper untuk format duration
  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  String toString() =>
      'AudioPlaybackState(status: $status, position: $positionFormatted/$durationFormatted, isBuffering: $isBuffering)';
}
