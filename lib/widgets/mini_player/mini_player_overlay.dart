import 'package:flutter/material.dart';

import '../../models/audio_metadata.dart';
import '../../services/audio_player_service.dart';
import 'collapsed_mini_player.dart';
import 'expanded_mini_player.dart';

/// Main mini-player overlay widget yang expand/collapse
class MiniPlayerOverlay extends StatefulWidget {
  final double bottomOffset;

  const MiniPlayerOverlay({
    super.key,
    this.bottomOffset = 0,
  });

  @override
  State<MiniPlayerOverlay> createState() => _MiniPlayerOverlayState();
}

class _MiniPlayerOverlayState extends State<MiniPlayerOverlay> {
  bool _isExpanded = false;

  void _collapse() {
    setState(() {
      _isExpanded = false;
    });
  }

  /// Navigate ke surah detail page yang sedang diplay
  void _navigateToPlayingSurah(AudioMetadata metadata) {
    // Pop expanded player jika ada
    if (_isExpanded) {
      _collapse();
      return;
    }

    // Navigate ke surah detail page
    Navigator.pushNamed(
      context,
      '/surah_detail',
      arguments: {
        'nomor': metadata.surahNumber,
        'nama': metadata.surahName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AudioMetadata?>(
      valueListenable: AudioPlayerService.currentMetadata,
      builder: (context, metadata, _) {
        // Don't show mini-player if no metadata
        if (metadata == null) {
          return const SizedBox.shrink();
        }

        return ValueListenableBuilder<PlayerStateStatus>(
          valueListenable: AudioPlayerService.status,
          builder: (context, status, _) {
            try {
              // Show expanded player fullscreen
              if (_isExpanded) {
                return StreamBuilder<Duration>(
                  stream: AudioPlayerService.positionStream,
                  initialData: Duration.zero,
                  builder: (context, positionSnap) {
                    final position = positionSnap.data ?? Duration.zero;

                    return StreamBuilder<Duration?>(
                      stream: AudioPlayerService.durationStream,
                      initialData: Duration.zero,
                      builder: (context, durationSnap) {
                        final duration = durationSnap.data;

                        return ExpandedMiniPlayer(
                          metadata: metadata,
                          status: status,
                          position: position,
                          duration: duration,
                          onCollapse: _collapse,
                          onClose: () {
                            try {
                              AudioPlayerService.stop();
                              _collapse();
                            } catch (e) {
                              debugPrint('❌ Error stopping audio: $e');
                              _collapse();
                            }
                          },
                        );
                      },
                    );
                  },
                );
              }

              // Show collapsed mini-player with safe sizing
              return SizedBox(
                height: 70,
                child: CollapsedMiniPlayer(
                  metadata: metadata,
                  status: status,
                  onTap: () => _navigateToPlayingSurah(metadata),
                  onClose: () {
                    try {
                      AudioPlayerService.stop();
                    } catch (e) {
                      debugPrint('❌ Error stopping audio: $e');
                    }
                  },
                ),
              );
            } catch (e) {
              debugPrint('❌ Mini-player error: $e');
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
