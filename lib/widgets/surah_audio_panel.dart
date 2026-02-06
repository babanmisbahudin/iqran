import 'package:flutter/material.dart';
import '../models/audio_metadata.dart';
import '../services/audio_player_service.dart';

class SurahAudioPanel extends StatelessWidget {
  final int surahNumber;
  final String? surahName;
  final String? surahNameLatin;
  final int? ayatCount;

  const SurahAudioPanel({
    super.key,
    required this.surahNumber,
    this.surahName,
    this.surahNameLatin,
    this.ayatCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ValueListenableBuilder<PlayerStateStatus>(
        valueListenable: AudioPlayerService.status,
        builder: (context, state, _) {
          return ValueListenableBuilder<AudioMetadata?>(
            valueListenable: AudioPlayerService.currentMetadata,
            builder: (context, metadata, _) {
              Widget icon;
              VoidCallback? onTap;
              bool isCurrentPlaying =
                  metadata?.surahNumber == surahNumber && state != PlayerStateStatus.idle;

              switch (state) {
                case PlayerStateStatus.loading:
                  if (metadata?.surahNumber == surahNumber) {
                    icon = const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                    onTap = null;
                  } else {
                    icon = const Icon(Icons.play_arrow);
                    onTap = _playAudio;
                  }
                  break;

                case PlayerStateStatus.playing:
                  if (isCurrentPlaying) {
                    icon = const Icon(Icons.pause);
                    onTap = AudioPlayerService.pause;
                  } else {
                    icon = const Icon(Icons.play_arrow);
                    onTap = _playAudio;
                  }
                  break;

                case PlayerStateStatus.paused:
                  if (isCurrentPlaying) {
                    icon = const Icon(Icons.play_arrow);
                    onTap = AudioPlayerService.resume;
                  } else {
                    icon = const Icon(Icons.play_arrow);
                    onTap = _playAudio;
                  }
                  break;

                case PlayerStateStatus.idle:
                case PlayerStateStatus.error:
                  icon = const Icon(Icons.play_arrow);
                  onTap = _playAudio;
                  break;
              }

              return ListTile(
                leading: icon,
                title: const Text('Putar Murottal'),
                subtitle: Text(
                  surahName ?? 'Audio per surah',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: isCurrentPlaying
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Now Playing',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    : null,
                onTap: onTap,
              );
            },
          );
        },
      ),
    );
  }

  void _playAudio() {
    if (surahName != null && surahNameLatin != null && ayatCount != null) {
      AudioPlayerService.playSurahWithMetadata(
        surahNumber,
        surahName: surahName!,
        surahNameLatin: surahNameLatin!,
        ayatCount: ayatCount!,
      );
    } else {
      // Fallback ke legacy method jika metadata tidak lengkap
      AudioPlayerService.playSurah(surahNumber);
    }
  }
}
