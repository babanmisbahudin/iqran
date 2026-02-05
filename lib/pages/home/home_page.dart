import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../quran/surah_list_page.dart';
import '../qibla/qibla_page.dart';
import '../ibadah/ibadah_page.dart';
import '../bookmark/bookmark_page.dart';
import '../good_deed/good_deed_page.dart';
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();

    String dateStr;
    try {
      final greetingFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
      dateStr = greetingFormat.format(now);
    } catch (e) {
      // Fallback if locale not initialized (e.g., on web)
      dateStr = '${now.day}/${now.month}/${now.year}';
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 28),

                // Continue Reading Section
                LastReadSection(
                  onTap: () {
                    // Navigate to Qur'an page - this will be handled by parent
                    // We'll use PageStorage to navigate to Qur'an tab
                  },
                ),
                const SizedBox(height: 20),

                // Today's Stats Section
                const StatsSection(),
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
                    FeatureCard(
                      icon: Icons.menu_book,
                      title: 'Doa',
                      description: 'Kumpulan Doa',
                      gradientColor: Color.lerp(
                        Colors.orange,
                        cs.surfaceContainer,
                        0.3,
                      )!,
                      onTap: () =>
                          _navigateToPage(context, const IbadahPage()),
                    ),
                    FeatureCard(
                      icon: Icons.explore,
                      title: 'Kiblat',
                      description: 'Arah Kiblat',
                      gradientColor: Color.lerp(
                        Colors.purple,
                        cs.surfaceContainer,
                        0.3,
                      )!,
                      onTap: () =>
                          _navigateToPage(context, const QiblaPage()),
                    ),
                    FeatureCard(
                      icon: Icons.favorite_outline,
                      title: 'Kebaikan',
                      description: 'Tracker Kebaikan',
                      gradientColor: Color.lerp(
                        Colors.red,
                        cs.surfaceContainer,
                        0.3,
                      )!,
                      onTap: () =>
                          _navigateToPage(context, const GoodDeedPage()),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
