import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeveloperInfoCard extends StatelessWidget {
  const DeveloperInfoCard({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Tidak bisa membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Pengembang',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dikembangkan oleh:\n'
              'Baban Misbahudin\n\n'
              'Iqran adalah aplikasi Al-Qur’an digital\n'
              'tanpa iklan atau berlangganan berbayar',
              style: TextStyle(height: 1.5),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            /// =========================
            /// BRAND ICONS (OFFICIAL)
            /// =========================
            Wrap(
              spacing: 20,
              children: [
                IconButton(
                  tooltip: 'Instagram',
                  icon: const FaIcon(FontAwesomeIcons.instagram),
                  onPressed: () => _open(
                    'https://www.instagram.com/himisbah_/',
                  ),
                ),
                IconButton(
                  tooltip: 'TikTok',
                  icon: const FaIcon(FontAwesomeIcons.tiktok),
                  onPressed: () => _open(
                    'https://www.tiktok.com/@himisbah',
                  ),
                ),
                IconButton(
                  tooltip: 'LinkedIn',
                  icon: const FaIcon(FontAwesomeIcons.linkedin),
                  onPressed: () => _open(
                    'https://www.linkedin.com/in/himisbah/',
                  ),
                ),
                IconButton(
                  tooltip: 'Email (Bisnis)',
                  icon: const FaIcon(FontAwesomeIcons.envelope),
                  onPressed: () => _open(
                    'mailto:workingwithmisbah@gmail.com',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              '© 2026 Iqran App\nAll rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
