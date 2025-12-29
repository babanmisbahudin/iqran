import 'package:flutter/material.dart';
import '../../services/audio_service.dart';

class AudioSettingsCard extends StatefulWidget {
  const AudioSettingsCard({super.key});

  @override
  State<AudioSettingsCard> createState() => _AudioSettingsCardState();
}

class _AudioSettingsCardState extends State<AudioSettingsCard> {
  String _selectedQari = 'al_afasy';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final qari = await AudioService.loadQari();
    if (!mounted) return;
    setState(() => _selectedQari = qari);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
            Text(
              'Pilih Qari',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedQari,
              items: AudioService.qariList.entries.map((e) {
                return DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                );
              }).toList(),
              onChanged: (value) async {
                if (value == null) return;
                await AudioService.saveQari(value);
                if (!mounted) return;
                setState(() => _selectedQari = value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.headphones, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Qari terpilih akan digunakan '
                    'saat audio murottal diputar.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
