import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class SurahAudioPanel extends StatelessWidget {
  final int surahNumber;

  const SurahAudioPanel({
    super.key,
    required this.surahNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ValueListenableBuilder<PlayerStateStatus>(
        valueListenable: AudioPlayerService.status,
        builder: (context, state, _) {
          Widget icon;
          VoidCallback? onTap;

          switch (state) {
            case PlayerStateStatus.loading:
              icon = const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
              onTap = null;
              break;

            case PlayerStateStatus.playing:
              icon = const Icon(Icons.pause);
              onTap = AudioPlayerService.pause;
              break;

            case PlayerStateStatus.paused:
            case PlayerStateStatus.idle:
              icon = const Icon(Icons.play_arrow);
              onTap = () => AudioPlayerService.playSurah(surahNumber);
              break;
          }

          return ListTile(
            leading: icon,
            title: const Text('Putar Murottal'),
            subtitle: const Text('Audio per surah'),
            onTap: onTap,
          );
        },
      ),
    );
  }
}
