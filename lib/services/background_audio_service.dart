import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_handler.dart';

/// Service untuk mengelola background audio playback
class BackgroundAudioService {
  static IqranAudioHandler? _audioHandler;
  static bool _initialized = false;

  static IqranAudioHandler? get audioHandler => _audioHandler;
  static bool get isInitialized => _initialized;

  /// Initialize background audio service
  static Future<IqranAudioHandler> init() async {
    if (_initialized && _audioHandler != null) {
      return _audioHandler!;
    }

    try {
      // Setup audio session untuk audio focus handling
      final audioSession = await AudioSession.instance;
      await audioSession.configure(
        const AudioSessionConfiguration.music(),
      );

      // Listen untuk audio interruptions (phone calls, dll)
      audioSession.interruptionEventStream.listen((event) {
        if (event.begin) {
          // Pause when interrupted
          _audioHandler?.pause();
        } else {
          // Optionally resume when interruption ends
          // _audioHandler?.play();
        }
      });

      // Create audio handler dengan just_audio player
      final player = AudioPlayer();
      final handler = IqranAudioHandler(player);

      // Initialize AudioService
      await AudioService.init(
        builder: () => handler,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.iqran.audio',
          androidNotificationChannelName: 'Iqran Murottal',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );

      _audioHandler = handler;
      _initialized = true;

      debugPrint('✅ BackgroundAudioService initialized successfully');
      return handler;
    } catch (e) {
      debugPrint('❌ Error initializing BackgroundAudioService: $e');
      rethrow;
    }
  }

  /// Dispose audio handler
  static void dispose() {
    _audioHandler?.dispose();
    _audioHandler = null;
    _initialized = false;
  }
}
