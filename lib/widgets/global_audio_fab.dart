import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class GlobalAudioFAB extends StatelessWidget {
  const GlobalAudioFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PlayerStateStatus>(
      valueListenable: AudioPlayerService.status,
      builder: (context, state, _) {
        if (state == PlayerStateStatus.idle) {
          return const SizedBox.shrink();
        }

        VoidCallback? onPressed;
        String tooltipMessage;
        Widget icon;

        switch (state) {
          case PlayerStateStatus.loading:
            icon = const SizedBox(
              key: ValueKey('loading'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            );
            onPressed = null;
            tooltipMessage = 'Memuat audio...';
            break;

          case PlayerStateStatus.playing:
            icon = const Icon(
              Icons.pause,
              key: ValueKey('pause'),
            );
            onPressed = AudioPlayerService.pause;
            tooltipMessage = 'Pause murottal';
            break;

          case PlayerStateStatus.paused:
            icon = const Icon(
              Icons.play_arrow,
              key: ValueKey('play'),
            );
            onPressed = AudioPlayerService.resume;
            tooltipMessage = 'Lanjutkan murottal';
            break;

          case PlayerStateStatus.idle:
            return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 72),
          child: Tooltip(
            message: tooltipMessage,
            child: FloatingActionButton(
              onPressed: onPressed,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: icon,
              ),
            ),
          ),
        );
      },
    );
  }
}
