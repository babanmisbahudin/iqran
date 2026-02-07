import 'package:flutter/material.dart';

/// Custom progress bar untuk seek dan display durasi
class AudioProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;

  const AudioProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    this.activeColor,
    this.inactiveColor,
    this.height = 4,
  });

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {
  bool _isDragging = false;
  late Duration _draggedPosition;

  @override
  void initState() {
    super.initState();
    _draggedPosition = widget.position;
  }

  @override
  void didUpdateWidget(AudioProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging) {
      _draggedPosition = widget.position;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor =
        widget.inactiveColor ?? theme.colorScheme.outline.withValues(alpha: 0.3);

    final progress = widget.duration.inMilliseconds > 0
        ? (_isDragging ? _draggedPosition : widget.position)
            .inMilliseconds
            .toDouble() /
            widget.duration.inMilliseconds.toDouble()
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Slider
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final thumbPosition = (progress * width) - 6;

            return GestureDetector(
              onHorizontalDragStart: (_) {
                setState(() => _isDragging = true);
              },
              onHorizontalDragUpdate: (details) {
                final dx = details.localPosition.dx;
                final newProgress = (dx / width).clamp(0.0, 1.0);
                final newPosition = Duration(
                  milliseconds:
                      (newProgress * widget.duration.inMilliseconds).toInt(),
                );
                setState(() => _draggedPosition = newPosition);
              },
              onHorizontalDragEnd: (_) {
                setState(() => _isDragging = false);
                widget.onSeek(_draggedPosition);
              },
              child: Stack(
                children: [
                  // Background track
                  Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: inactiveColor,
                      borderRadius: BorderRadius.circular(widget.height / 2),
                    ),
                  ),
                  // Buffered progress (optional)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(widget.height / 2),
                      ),
                      width: progress * 100 + 1,
                    ),
                  ),
                  // Active progress
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(widget.height / 2),
                      ),
                    ),
                  ),
                  // Thumb handle
                  Positioned(
                    left: thumbPosition,
                    top: -6,
                    child: Container(
                      width: widget.height + 8,
                      height: widget.height + 8,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        // Time display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(_isDragging ? _draggedPosition : widget.position),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              _formatDuration(widget.duration),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
