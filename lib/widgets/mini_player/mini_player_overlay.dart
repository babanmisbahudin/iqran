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
    this.bottomOffset = 72,
  });

  @override
  State<MiniPlayerOverlay> createState() => _MiniPlayerOverlayState();
}

class _MiniPlayerOverlayState extends State<MiniPlayerOverlay>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _expandAnimController;

  @override
  void initState() {
    super.initState();
    _expandAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _expandAnimController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandAnimController.forward();
      } else {
        _expandAnimController.reverse();
      }
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
            return Stack(
              children: [
                // Background overlay saat expanded
                if (_isExpanded)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _toggleExpanded,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                  ),

                // Mini-player
                if (!_isExpanded)
                  Positioned(
                    bottom: widget.bottomOffset,
                    left: 0,
                    right: 0,
                    child: CollapsedMiniPlayer(
                      metadata: metadata,
                      status: status,
                      onTap: _toggleExpanded,
                      onClose: () {
                        AudioPlayerService.stop();
                      },
                    ),
                  ),

                // Expanded player
                if (_isExpanded)
                  Positioned.fill(
                    child: StreamBuilder<Duration>(
                      stream: AudioPlayerService.positionStream,
                      initialData: Duration.zero,
                      builder: (context, positionSnap) {
                        final position =
                            positionSnap.data ?? Duration.zero;

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
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
