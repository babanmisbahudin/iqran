import 'package:flutter/material.dart';
import '../quran/surah_list_page.dart';
import '../quran/surah_detail_page.dart';
import '../bookmark/bookmark_page.dart';
import '../../services/progress_service.dart';
import 'widgets/feature_card.dart';
import 'widgets/last_read_section.dart';
import 'widgets/stats_section.dart';

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
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
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

  String _formatDateIndo(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  const SizedBox(height: 20),

                  // Quick Access Grid
                  Text(
                    'Fitur Utama',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                    children: [
                      FeatureCard(
                        icon: Icons.menu_book,
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
                      ),
                      FeatureCard(
                        icon: Icons.bookmark,
                        title: 'Bookmark',
                        description: 'Ayat Favorit',
                        gradientColor: Color.lerp(
                          cs.primary,
                          cs.surfaceContainer,
                          0.3,
                        )!,
                        onTap: () => _navigateToPage(
                          context,
                          BookmarkPage(fontSize: widget.fontSize),
                        ),
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
}
