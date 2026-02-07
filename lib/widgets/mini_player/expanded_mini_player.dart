import 'package:flutter/material.dart';

import '../../models/audio_metadata.dart';
import '../../services/audio_player_service.dart';
import 'audio_artwork.dart';
import 'audio_progress_bar.dart';

/// Full screen mini-player view untuk kontrol yang lebih lengkap
class ExpandedMiniPlayer extends StatefulWidget {
  final AudioMetadata metadata;
  final PlayerStateStatus status;
  final Duration position;
  final Duration? duration;
  final VoidCallback onCollapse;
  final VoidCallback onClose;

  const ExpandedMiniPlayer({
    super.key,
    required this.metadata,
    required this.status,
    required this.position,
    required this.duration,
    required this.onCollapse,
    required this.onClose,
  });

  @override
  State<ExpandedMiniPlayer> createState() => _ExpandedMiniPlayerState();
}

class _ExpandedMiniPlayerState extends State<ExpandedMiniPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _collapseAnimController;

  @override
  void initState() {
    super.initState();
    _collapseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Animate in when player is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _collapseAnimController.forward();
      }
    });
  }

  @override
  void dispose() {
    _collapseAnimController.dispose();
    super.dispose();
  }

  void _handleCollapse() {
    _collapseAnimController.reverse().then((_) {
      widget.onCollapse();
    });
  }

  void _showSleepTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sleep Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<Duration?>(
              valueListenable: AudioPlayerService.sleepTimerRemaining,
              builder: (context, remaining, _) {
                if (remaining != null) {
                  final minutes = remaining.inMinutes;
                  final seconds = remaining.inSeconds % 60;
                  return Text(
                    'Active: ${minutes}:${seconds.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  );
                }
                return const Text('No timer set');
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [5, 10, 15, 30, 45, 60].map((minutes) {
                return ElevatedButton(
                  onPressed: () {
                    AudioPlayerService.setSleepTimer(minutes);
                    Navigator.pop(context);
                  },
                  child: Text('$minutes min'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              AudioPlayerService.cancelSleepTimer();
              Navigator.pop(context);
            },
            child: const Text('Cancel Timer'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: _collapseAnimController, curve: Curves.easeOut),
        ),
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            onPressed: _handleCollapse,
            tooltip: 'Collapse',
          ),
          actions: [
            ValueListenableBuilder<Duration?>(
              valueListenable: AudioPlayerService.sleepTimerRemaining,
              builder: (context, remaining, _) {
                return IconButton(
                  icon: Icon(
                    remaining != null ? Icons.timer : Icons.timer_outlined,
                  ),
                  onPressed: _showSleepTimerDialog,
                  tooltip: 'Sleep Timer',
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: widget.onClose,
              tooltip: 'Stop',
            ),
          ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Large artwork
                Hero(
                  tag: 'audio_artwork_${widget.metadata.surahNumber}',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: AudioArtwork(
                      text: widget.metadata.surahNameLatin,
                      size: 200,
                      primaryColor: colorScheme.primary,
                    ),
                  ),
                ),

                // Metadata
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.metadata.surahName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.metadata.ayatCount} Ayat • ${widget.metadata.qariName}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),

                // Progress bar
                AudioProgressBar(
                  position: widget.position,
                  duration: widget.duration ?? Duration.zero,
                  onSeek: (position) {
                    AudioPlayerService.seek(position);
                  },
                ),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous button
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded),
                      iconSize: 32,
                      onPressed:
                          AudioPlayerService.canPlayPrevious
                              ? () => AudioPlayerService.playPrevious()
                              : null,
                      tooltip: 'Previous',
                    ),

                    // Play/pause button (large)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: widget.status == PlayerStateStatus.playing
                            ? const Icon(Icons.pause_rounded)
                            : widget.status == PlayerStateStatus.loading
                                ? const SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.play_arrow_rounded),
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () {
                          if (widget.status == PlayerStateStatus.playing) {
                            AudioPlayerService.pause();
                          } else if (widget.status == PlayerStateStatus.paused ||
                              widget.status == PlayerStateStatus.idle) {
                            AudioPlayerService.resume();
                          }
                        },
                        tooltip: widget.status == PlayerStateStatus.playing
                            ? 'Pause'
                            : 'Play',
                      ),
                    ),

                    // Next button
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      iconSize: 32,
                      onPressed:
                          AudioPlayerService.canPlayNext
                              ? () => AudioPlayerService.playNext()
                              : null,
                      tooltip: 'Next',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
