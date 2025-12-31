import 'package:flutter/material.dart';
import 'audio_settings_card.dart';
import '../../widgets/developer_info_card.dart';

class SettingsPage extends StatelessWidget {
  final bool isDark;
  final double fontSize;
  final ValueChanged<bool> onTheme;
  final ValueChanged<double> onFont;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.fontSize,
    required this.onTheme,
    required this.onFont,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            children: [
              // =========================
              // TAMPILAN
              // =========================
              Card(
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
                        'Tampilan',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Aktifkan mode gelap'),
                        value: isDark,
                        onChanged: onTheme,
                      ),
                      const SizedBox(height: 8),
                      Text('Ukuran Font Arab: ${fontSize.toInt()}'),
                      Slider(
                        min: 20,
                        max: 50,
                        divisions: 10,
                        value: fontSize,
                        onChanged: onFont,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // AUDIO MUROTTAL
              // =========================
              const AudioSettingsCard(),

              const SizedBox(height: 20),

              // =========================
              // TENTANG APLIKASI
              // =========================
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Iqran (Iqro Al-Quran) '
                    'untuk membantu murajaah secara konsisten.',
                    style: TextStyle(height: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // DEVELOPER & COPYRIGHT
              // =========================
              const DeveloperInfoCard(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
