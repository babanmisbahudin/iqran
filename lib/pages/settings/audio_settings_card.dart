import 'package:flutter/material.dart';
import '../../services/audio_service.dart';

class AudioSettingsCard extends StatefulWidget {
  const AudioSettingsCard({super.key});

  @override
  State<AudioSettingsCard> createState() => _AudioSettingsCardState();
}

class _AudioSettingsCardState extends State<AudioSettingsCard> {
  String? selected;

  @override
  void initState() {
    super.initState();
    AudioService.loadQari().then((v) {
      if (!mounted) return;
      setState(() => selected = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audio Murottal',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (selected == null)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<String>(
                initialValue: selected,
                items: AudioService.qariList.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
                onChanged: (v) async {
                  if (v == null) return;
                  await AudioService.saveQari(v);
                  setState(() => selected = v);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pilih Qari',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
