import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class SurahAudioPanel extends StatefulWidget {
  final int surahNumber;
  const SurahAudioPanel({super.key, required this.surahNumber});

  @override
  State<SurahAudioPanel> createState() => _SurahAudioPanelState();
}

class _SurahAudioPanelState extends State<SurahAudioPanel> {
  bool playing = false;

  Future<void> toggle() async {
    if (AudioPlayerService.isPlaying) {
      await AudioPlayerService.pause();
      setState(() => playing = false);
    } else {
      await AudioPlayerService.playSurah(widget.surahNumber);
      setState(() => playing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(playing ? Icons.pause : Icons.play_arrow),
        title: const Text('Putar Murottal'),
        subtitle: const Text('Audio per surah'),
        onTap: toggle,
      ),
    );
  }
}
