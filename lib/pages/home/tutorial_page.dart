import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTutorialCard(
                context,
                icon: Icons.menu_book,
                title: 'Membaca Al-Qur\'an',
                description: 'Tekan tombol "Al-Qur\'an" untuk memulai membaca. '
                    'Pilih Surah yang ingin Anda baca, lalu tekan untuk membuka teks lengkap. '
                    'Gunakan kontrol audio untuk mendengarkan bacaan Murotal.',
                color: Color.lerp(Colors.green, cs.surfaceContainer, 0.3)!,
              ),
              const SizedBox(height: 16),
              _buildTutorialCard(
                context,
                icon: Icons.bookmark,
                title: 'Menandai Surah Favorit',
                description: 'Tekan ikon bookmark pada surah untuk menambahkannya ke daftar favorit. '
                    'Akses bookmark Anda kapan saja melalui menu "Bookmark" untuk membaca kembali surah favorit.',
                color: Color.lerp(Colors.blue, cs.surfaceContainer, 0.3)!,
              ),
              const SizedBox(height: 16),
              _buildTutorialCard(
                context,
                icon: Icons.play_circle,
                title: 'Mendengarkan Audio Murotal',
                description: 'Tekan tombol play pada surah untuk mulai mendengarkan. '
                    'Gunakan mini player untuk mengontrol pemutaran, mencari, dan berpindah antar surah. '
                    'Audio akan terus berjalan meskipun aplikasi diminimalkan.',
                color: Color.lerp(Colors.purple, cs.surfaceContainer, 0.3)!,
              ),
              const SizedBox(height: 16),
              _buildTutorialCard(
                context,
                icon: Icons.text_fields,
                title: 'Mengatur Ukuran Teks',
                description: 'Gunakan slider ukuran teks untuk menyesuaikan ukuran font sesuai kenyamanan Anda. '
                    'Pengaturan ini akan tersimpan untuk semua bacaan Anda.',
                color: Color.lerp(Colors.orange, cs.surfaceContainer, 0.3)!,
              ),
              const SizedBox(height: 16),
              _buildTutorialCard(
                context,
                icon: Icons.refresh,
                title: 'Melanjutkan Bacaan Terakhir',
                description: 'Aplikasi secara otomatis menyimpan posisi bacaan Anda. '
                    'Di halaman utama, tekan "Lanjutkan Membaca" untuk kembali ke bacaan terakhir Anda.',
                color: Color.lerp(Colors.teal, cs.surfaceContainer, 0.3)!,
              ),
              const SizedBox(height: 16),
              _buildTutorialCard(
                context,
                icon: Icons.dark_mode,
                title: 'Mode Gelap/Terang',
                description: 'Aplikasi secara otomatis mengikuti pengaturan sistem perangkat Anda. '
                    'Pilih mode yang paling nyaman untuk mata Anda saat membaca.',
                color: Color.lerp(Colors.grey, cs.surfaceContainer, 0.3)!,
              ),
              const SizedBox(height: 16),
              _buildTutorialCard(
                context,
                icon: Icons.lightbulb_outline,
                title: 'Tadabur - Renungan Al-Qur\'an',
                description: 'Fitur Tadabur menyediakan koleksi cerita-cerita islami dan pelajaran mendalam. '
                    'Baca cerita-cerita inspiratif dari Al-Qur\'an, refleksikan makna di balik setiap cerita, dan pahami pelajaran spiritualnya. '
                    'Setiap cerita dilengkapi dengan doa dari Quran atau Hadis Nabi untuk merenungkan makna lebih dalam.',
                color: Color.lerp(Colors.amber, cs.surfaceContainer, 0.3)!,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Tips Berguna',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Tarik ke bawah untuk menyegarkan data\n'
                      '• Audio terus berjalan di latar belakang\n'
                      '• Progress membaca tersimpan otomatis\n'
                      '• Gunakan fitur donasi untuk mendukung pengembangan aplikasi',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
