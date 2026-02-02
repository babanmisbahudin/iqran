import 'package:flutter/material.dart';
import 'package:iqran/models/daily_stats.dart';
import 'package:iqran/services/progress_service.dart';
import 'package:iqran/services/stats_service.dart';
import 'widgets/today_stats_card.dart';
import 'widgets/calendar_view.dart';
import 'widgets/overall_progress_card.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Future<Map<String, int>?> _progressFuture;
  late Future<int> _todayVersesFuture;
  late Future<List<DailyStats>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _progressFuture = ProgressService.load();
    _todayVersesFuture = ProgressService.getVersesReadToday();
    _statsFuture = StatsService.getDailyStats(30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Murajaah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Today's stats card
            FutureBuilder<int>(
              future: _todayVersesFuture,
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return TodayStatsCard(versesReadToday: count);
              },
            ),
            const SizedBox(height: 16),

            // Calendar view
            FutureBuilder<List<DailyStats>>(
              future: _statsFuture,
              builder: (context, snapshot) {
                final stats = snapshot.data ?? [];
                return CalendarView(stats: stats);
              },
            ),
            const SizedBox(height: 16),

            // Overall progress card
            FutureBuilder<Map<String, int>?>(
              future: _progressFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('Belum ada progress murajaah'),
                      ),
                    ),
                  );
                }

                final surah = snapshot.data!['surah']!;
                final ayat = snapshot.data!['ayat']!;

                return OverallProgressCard(
                  surah: surah,
                  ayat: ayat,
                );
              },
            ),
            const SizedBox(height: 16),

            // Reset button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset Progress'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  if (!mounted) return;
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Reset Progress?'),
                      content: const Text(
                        'Ini akan menghapus semua data progress dan riwayat baca. '
                        'Aksi ini tidak dapat dibatalkan.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Batal'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );

                  if (!mounted) return;
                  if (confirm == true) {
                    await ProgressService.resetAll();
                    if (mounted) {
                      setState(() => _loadData());
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Progress berhasil di-reset'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
