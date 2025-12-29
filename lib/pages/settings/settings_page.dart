import 'package:flutter/material.dart';

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
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520, // biar rapi di tablet
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      Text(
                        'Ukuran Font Arab: ${fontSize.toInt()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Slider(
                        min: 20,
                        max: 40,
                        divisions: 10,
                        value: fontSize,
                        label: fontSize.toInt().toString(),
                        onChanged: onFont,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // TENTANG APLIKASI
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
                        'Tentang Aplikasi',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Iqran adalah aplikasi Al-Qur’an pribadi '
                        'yang dirancang untuk membantu murajaah '
                        'secara konsisten dan nyaman.\n\n'
                        'Fitur utama:\n'
                        '• Membaca Al-Qur’an\n'
                        '• Bookmark ayat\n'
                        '• Progress murajaah\n'
                        '• Mode belajar (Latin & Terjemahan)',
                        style: TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // DEVELOPER / COPYRIGHT
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
                        'Pengembang',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Dibuat oleh:\n'
                        'Baban Misbahudin / @himisbah\n\n'
                        '© 2025 Iqran App\n'
                        'Semua hak cipta dilindungi.',
                        style: TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: cs.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Versi 1.0.0',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
