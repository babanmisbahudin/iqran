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

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _collapse() {
    setState(() {
      _isExpanded = false;
    });
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
                          AudioPlayerService.stop();
                          _collapse();
                        },
                      );
                    },
                  );
                },
              );
            }

            // Show collapsed mini-player
            return CollapsedMiniPlayer(
              metadata: metadata,
              status: status,
              onTap: _toggleExpanded,
              onClose: () {
                AudioPlayerService.stop();
              },
            );
          },
        );
      },
    );
  }
}
