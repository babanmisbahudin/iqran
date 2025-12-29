import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';
import '../services/audio_service.dart';

class SurahAudioPanel extends StatefulWidget {
  final int surahNumber;

  const SurahAudioPanel({
    super.key,
    required this.surahNumber, required String surahName,
  });

  @override
  State<SurahAudioPanel> createState() => _SurahAudioPanelState();
}

class _SurahAudioPanelState extends State<SurahAudioPanel> {
  bool isPlaying = false;
  String qariName = '';

  @override
  void initState() {
    super.initState();
    _loadQari();
  }

  Future<void> _loadQari() async {
    final key = await AudioService.loadQari();
    setState(() {
      qariName = AudioService.getQariName(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.primary.withValues(alpha: 0.08),
      ),
      child: Row(
        children: [
          IconButton(
            iconSize: 36,
            icon: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: cs.primary,
            ),
            onPressed: () async {
              if (isPlaying) {
                await AudioPlayerService.pause();
              } else {
                await AudioPlayerService.playSurah(widget.surahNumber);
              }

              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Murottal Surah',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  qariName,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
