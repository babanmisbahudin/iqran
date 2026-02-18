import 'package:flutter/material.dart';

import '../../models/audio_metadata.dart';
import '../../services/audio_player_service.dart';
import 'audio_artwork.dart';

/// Compact mini-player view yang ditampilkan di bottom
class CollapsedMiniPlayer extends StatelessWidget {
  final AudioMetadata metadata;
  final PlayerStateStatus status;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final VoidCallback onHide;

  const CollapsedMiniPlayer({
    super.key,
    required this.metadata,
    required this.status,
    required this.onTap,
    required this.onClose,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Clickable area: Album art + Metadata
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      // Album art
                      AudioArtwork(
                        text: metadata.surahNameLatin,
                        size: 56,
                        primaryColor: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),

                      // Metadata
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              metadata.surahName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              metadata.qariName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Play/pause button (outside InkWell)
              IconButton(
                icon: status == PlayerStateStatus.playing
                    ? const Icon(Icons.pause_rounded)
                    : status == PlayerStateStatus.loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.play_arrow_rounded),
                onPressed: () {
                  if (status == PlayerStateStatus.playing) {
                    AudioPlayerService.pause();
                  } else if (status == PlayerStateStatus.paused ||
                      status == PlayerStateStatus.idle) {
                    AudioPlayerService.resume();
                  }
                },
                tooltip: status == PlayerStateStatus.playing
                    ? 'Jeda'
                    : 'Lanjutkan',
              ),

              // Close button (outside InkWell)
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: onClose,
                tooltip: 'Hentikan',
                iconSize: 20,
              ),

              // Hide button (outside InkWell)
              IconButton(
                icon: const Icon(Icons.expand_less_rounded),
                onPressed: onHide,
                tooltip: 'Sembunyikan',
                iconSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
