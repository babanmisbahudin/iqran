import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/prayer_time.dart';
import '../../services/prayer_service.dart';
import '../../services/city_storage_service.dart';
import '../prayer/prayer_page.dart';
import '../qibla/qibla_page.dart';
import '../ibadah/ibadah_page.dart';
import '../bookmark/bookmark_page.dart';
import 'widgets/feature_card.dart';
import 'widgets/last_read_section.dart';
import 'widgets/next_prayer_card.dart';
import 'widgets/stats_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<PrayerTime?> _nextPrayerFuture;

  @override
  void initState() {
    super.initState();
    _nextPrayerFuture = _loadNextPrayer();
  }

  Future<PrayerTime?> _loadNextPrayer() async {
    try {
      final city = await CityStorageService.getSelectedCity();
      if (city == null) return null;

      return await PrayerService.getTodayPrayerTimes(cityId: city.id);
    } catch (e) {
      return null;
    }
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final greetingFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final dateStr = greetingFormat.format(now);

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

                // Next Prayer Section
                FutureBuilder<PrayerTime?>(
                  future: _nextPrayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: cs.surfaceContainer,
                          border: Border.all(
                            color: cs.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Jadwal Sholat',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Atur lokasi untuk melihat jadwal sholat',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  _navigateToPage(context, const PrayerPage()),
                              child: const Text('Atur Lokasi'),
                            ),
                          ],
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () =>
                          _navigateToPage(context, const PrayerPage()),
                      child: NextPrayerCard(
                        prayerTime: snapshot.data!,
                        onTap: () =>
                            _navigateToPage(context, const PrayerPage()),
                      ),
                    );
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
                      icon: Icons.bookmark,
                      title: 'Bookmark',
                      description: 'Ayat Favorit',
                      gradientColor: Color.lerp(
                        cs.primary,
                        cs.surfaceContainer,
                        0.3,
                      )!,
                      onTap: () =>
                          _navigateToPage(context, const BookmarkPage()),
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
                      icon: Icons.favorite,
                      title: 'Puasa',
                      description: 'Tracker Puasa',
                      gradientColor: Color.lerp(
                        Colors.pink,
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
