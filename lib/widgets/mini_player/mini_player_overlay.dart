import 'package:flutter/material.dart';

import '../../models/audio_metadata.dart';
import '../../services/audio_player_service.dart';
import 'collapsed_mini_player.dart';
import 'expanded_mini_player.dart';

/// Main mini-player overlay widget yang expand/collapse
class MiniPlayerOverlay extends StatefulWidget {
  final double bottomOffset;
  // ignore: library_private_types_in_public_api
  static final GlobalKey<_MiniPlayerOverlayState> globalKey =
      GlobalKey<_MiniPlayerOverlayState>();

  const MiniPlayerOverlay({
    super.key,
    this.bottomOffset = 0,
  });

  @override
  State<MiniPlayerOverlay> createState() => _MiniPlayerOverlayState();

  // Public method to show mini player from outside
  static void show() {
    globalKey.currentState?._show();
  }

  // Public method to check if mini player is hidden
  static bool isHidden() {
    return globalKey.currentState?._isHidden ?? false;
  }
}

class _MiniPlayerOverlayState extends State<MiniPlayerOverlay> {
  bool _isExpanded = false;
  bool _isHidden = false;
  late double _offsetTop;
  late double _offsetLeft;

  @override
  void initState() {
    super.initState();
    _offsetTop = 60;
    _offsetLeft = 0;
  }

  void _collapse() {
    debugPrint('🎵 Collapse mini player');
    setState(() {
      _isExpanded = false;
    });
  }

  /// Expand/collapse mini player
  void _toggleExpanded() {
    debugPrint('🎵 Toggle expanded: $_isExpanded -> ${!_isExpanded}');
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Hide/show mini player
  void _toggleHidden() {
    debugPrint('🎵 Toggle hidden: $_isHidden -> ${!_isHidden}');
    setState(() {
      _isHidden = !_isHidden;
      if (_isHidden) {
        _isExpanded = false; // Collapse when hiding
      }
    });
  }

  void _show() {
    debugPrint('🎵 Show mini player');
    setState(() {
      _isHidden = false;
    });
  }

  /// Handle dragging untuk mini player (hanya saat collapsed)
  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isExpanded) return; // Don't allow drag when expanded

    setState(() {
      _offsetTop += details.delta.dy;
      _offsetLeft += details.delta.dx;

      // Batasi posisi agar tidak keluar dari layar
      final screenSize = MediaQuery.of(context).size;
      _offsetTop = _offsetTop.clamp(0.0, screenSize.height - 100);
      _offsetLeft = _offsetLeft.clamp(-320, screenSize.width - 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Don't show mini player if hidden
    if (_isHidden) {
      return const SizedBox.shrink();
    }

    // When expanded, show fullscreen without position constraints
    if (_isExpanded) {
      return _buildMiniPlayer();
    }

    // When collapsed, use positioned widget for dragging
    return Stack(
      children: [
        Positioned(
          top: _offsetTop,
          left: _offsetLeft,
          right: _offsetLeft == 0 ? 0 : null,
          child: GestureDetector(
            onPanUpdate: _handleDragUpdate,
            child: _buildMiniPlayer(),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniPlayer() {
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
                  onTap: _toggleExpanded,
                  onClose: () {
                    try {
                      AudioPlayerService.stop();
                    } catch (e) {
                      debugPrint('❌ Error stopping audio: $e');
                    }
                  },
                  onHide: _toggleHidden,
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
