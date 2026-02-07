import 'package:flutter/material.dart';
import '../quran/surah_list_page.dart';
import '../quran/surah_detail_page.dart';
import '../bookmark/bookmark_page.dart';
import '../../services/progress_service.dart';
import '../../widgets/animated_page_route.dart';
import 'widgets/feature_card.dart';
import 'widgets/last_read_section.dart';
import 'widgets/stats_section.dart';
import 'tutorial_page.dart';
import 'donation_dialog.dart';

class HomePage extends StatefulWidget {
  final double fontSize;

  const HomePage({
    super.key,
    this.fontSize = 16.0,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, int>?> _progressFuture;
  late Future<int> _todayVersesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _progressFuture = ProgressService.load();
    _todayVersesFuture = ProgressService.getVersesReadToday();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _loadData();
    });
    await Future.wait([
      _progressFuture.then((_) {}).catchError((_) {}),
      _todayVersesFuture.then((_) {}).catchError((_) {}),
    ]);
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context)
        .push(
          AnimatedPageRoute(
            page: page,
            animationType: AnimationType.slideFromRight,
          ),
        )
        .then((_) {
          // Reload data when user returns from navigation
          if (mounted) {
            setState(() {
              _loadData();
            });
          }
        });
  }

  String _formatDateIndo(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];

    final dayName = days[date.weekday % 7];
    final monthName = months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();

    final dateStr = _formatDateIndo(now);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Header with greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Assalamu\'alaikum',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Continue Reading Section
                  FutureBuilder<Map<String, int>?>(
                    future: _progressFuture,
                    builder: (context, snapshot) {
                      final progress = snapshot.data;
                      final surahNumber = progress?['surah'];
                      final ayatNumber = progress?['ayat'];

                      return LastReadSection(
                        surah: surahNumber,
                        ayat: ayatNumber,
                        onTap: () {
                          // Navigate to the last read surah if data exists
                          if (surahNumber != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SurahDetailPage.fromBookmark(
                                  nomor: surahNumber,
                                  nama: 'Surah',
                                  fontSize: widget.fontSize,
                                  ayatTujuan: ayatNumber,
                                ),
                              ),
                            ).then((_) {
                              // Reload data when user returns from navigation
                              if (mounted) {
                                setState(() {
                                  _loadData();
                                });
                              }
                            });
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Today's Stats Section
                  FutureBuilder<int>(
                    future: _todayVersesFuture,
                    builder: (context, snapshot) {
                      final versesReadToday = snapshot.data ?? 0;
                      return StatsSection(versesReadToday: versesReadToday);
                    },
                  ),
                  const SizedBox(height: 28),

                  // Quick Features Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.92,
                    children: [
                      FeatureCard(
                        icon: Icons.menu_book,
                        lottieAsset: 'assets/lottie/book.json',
                        title: 'Al-Qur\'an',
                        description: 'Baca Qur\'an',
                        gradientColor: Color.lerp(
                          Colors.green,
                          cs.surfaceContainer,
                          0.3,
                        )!,
                        onTap: () => _navigateToPage(
                          context,
                          SurahListPage(fontSize: widget.fontSize),
                        ),
                        animationIndex: 0,
                        entranceDelay: const Duration(milliseconds: 100),
                      ),
                      FeatureCard(
                        icon: Icons.bookmark,
                        lottieAsset: 'assets/lottie/bookmark.json',
                        title: 'Bookmark',
                        description: 'Surah Favorit',
                        gradientColor: Color.lerp(
                          cs.primary,
                          cs.surfaceContainer,
                          0.3,
                        )!,
                        onTap: () => _navigateToPage(
                          context,
                          BookmarkPage(fontSize: widget.fontSize),
                        ),
                        animationIndex: 1,
                        entranceDelay: const Duration(milliseconds: 200),
                      ),
                      FeatureCard(
                        icon: Icons.help_outline,
                        lottieAsset: 'assets/lottie/help.json',
                        title: 'Tutorial',
                        description: 'Panduan Aplikasi',
                        gradientColor: Color.lerp(
                          Colors.blue,
                          cs.surfaceContainer,
                          0.3,
                        )!,
                        onTap: () => _navigateToPage(
                          context,
                          const TutorialPage(),
                        ),
                        animationIndex: 2,
                        entranceDelay: const Duration(milliseconds: 300),
                      ),
                      FeatureCard(
                        icon: Icons.favorite,
                        lottieAsset: 'assets/lottie/heart.json',
                        title: 'Donasi',
                        description: 'Dukung Developer',
                        gradientColor: Color.lerp(
                          Colors.red,
                          cs.surfaceContainer,
                          0.3,
                        )!,
                        onTap: () => _showDonationDialog(context),
                        animationIndex: 3,
                        entranceDelay: const Duration(milliseconds: 400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DonationDialog(),
    );
  }
}
