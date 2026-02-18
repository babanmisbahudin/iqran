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
  final double latinFontSize;

  const HomePage({
    super.key,
    this.fontSize = 16.0,
    this.latinFontSize = 16.0,
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

  int _getGridColumns(double width) {
    if (width > 1200) return 4; // Landscape tablet / desktop
    if (width > 900) return 3; // Tablet
    if (width > 600) return 2; // Large phone
    return 2; // Mobile
  }

  double _getHorizontalPadding(double width) {
    if (width > 1200) return 32.0;
    if (width > 900) return 24.0;
    if (width > 600) return 20.0;
    return 16.0;
  }

  double _getGridSpacing(double width) {
    if (width > 1200) return 20.0;
    if (width > 900) return 16.0;
    return 14.0;
  }

  double _getCardAspectRatio(int columns) {
    if (columns >= 4) return 0.85;
    if (columns == 3) return 0.88;
    return 0.92;
  }

  String _getIndonesianDayName(int weekday) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[weekday - 1];
  }

  String _formatDateWithDay(DateTime date) {
    final dayName = _getIndonesianDayName(date.weekday);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$dayName, $day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final dateStr = _formatDateWithDay(now);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = _getHorizontalPadding(screenWidth);
    final gridColumns = _getGridColumns(screenWidth);
    final gridSpacing = _getGridSpacing(screenWidth);
    final cardAspectRatio = _getCardAspectRatio(gridColumns);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
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
                                    latinFontSize: widget.latinFontSize,
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
                      crossAxisCount: gridColumns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: gridSpacing,
                      mainAxisSpacing: gridSpacing,
                      childAspectRatio: cardAspectRatio,
                      children: [
                        FeatureCard(
                          icon: Icons.menu_book,
                          lottieAsset: 'assets/lottie/book.json',
                          title: 'Al-Qur\'an',
                          description: 'Baca dan jelajahi Al-Qur\'an dengan murotal yang indah',
                          gradientColor: Color.lerp(
                            Colors.green,
                            cs.surfaceContainer,
                            0.3,
                          )!,
                          onTap: () => _navigateToPage(
                            context,
                            SurahListPage(fontSize: widget.fontSize, latinFontSize: widget.latinFontSize),
                          ),
                          animationIndex: 0,
                          entranceDelay: const Duration(milliseconds: 100),
                        ),
                        FeatureCard(
                          icon: Icons.bookmark,
                          lottieAsset: 'assets/lottie/bookmark.json',
                          title: 'Catatan',
                          description: 'Simpan ayat dan surah favorit Anda',
                          gradientColor: Color.lerp(
                            cs.primary,
                            cs.surfaceContainer,
                            0.3,
                          )!,
                          onTap: () => _navigateToPage(
                            context,
                            BookmarkPage(fontSize: widget.fontSize, latinFontSize: widget.latinFontSize),
                          ),
                          animationIndex: 1,
                          entranceDelay: const Duration(milliseconds: 200),
                        ),
                        FeatureCard(
                          icon: Icons.help_outline,
                          lottieAsset: 'assets/lottie/help.json',
                          title: 'Panduan',
                          description: 'Pelajari cara menggunakan aplikasi dengan efektif',
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
                          title: 'Dukung Kami',
                          description: 'Bantu mendukung pengembangan iQran',
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
                    const SizedBox(height: 100),
                  ],
                ),
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
