import 'package:flutter/material.dart';
import 'package:iqran/models/dashboard_metrics.dart';
import 'package:iqran/services/progress_service.dart';
import 'package:iqran/services/stats_service.dart';
import '../../widgets/animated_card_wrapper.dart';
import 'widgets/overall_progress_card.dart';
import 'widgets/progress_chart_widget.dart';
import 'widgets/metrics_summary_card.dart';
import 'widgets/daily_target_card.dart';
import 'widgets/estimation_card.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Future<Map<String, int>?> _progressFuture;
  late Future<DashboardMetrics> _dashboardMetricsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _progressFuture = ProgressService.load();
    _dashboardMetricsFuture = StatsService.getDashboardMetrics();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _loadData();
    });
    await _dashboardMetricsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Murajaah'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<DashboardMetrics>(
          future: _dashboardMetricsFuture,
          builder: (context, snapshot) {
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Handle error state
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _loadData());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            // Get metrics data
            final metrics = snapshot.data ?? DashboardMetrics.empty();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // a. DailyTargetCard (top priority)
                  AnimatedCardWrapper(
                    entranceDelay: const Duration(milliseconds: 100),
                    child: DailyTargetCard(
                      versesReadToday: metrics.versesReadToday,
                      dailyTarget: metrics.dailyTarget,
                      progressPercentage: metrics.todayProgressPercentage,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // b. ProgressChartWidget (7-day chart)
                  AnimatedCardWrapper(
                    entranceDelay: const Duration(milliseconds: 200),
                    child: ProgressChartWidget(
                      dailyVerses: metrics.last7DaysVerses,
                      maxDaily: 150,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // c. MetricsSummaryCard (4 metrics dalam grid)
                  AnimatedCardWrapper(
                    entranceDelay: const Duration(milliseconds: 300),
                    child: MetricsSummaryCard(
                      totalVersesRead: metrics.totalVersesRead,
                      totalSurahCompleted: metrics.totalSurahCompleted,
                      currentStreak: metrics.streak.currentStreak,
                      monthlyAverageVerses: metrics.monthlyAverageVerses,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // d. Keeping existing widgets
                  // Overall progress card
                  AnimatedCardWrapper(
                    entranceDelay: const Duration(milliseconds: 400),
                    child: FutureBuilder<Map<String, int>?>(
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
                  ),
                  const SizedBox(height: 16),

                  // Estimation card
                  const AnimatedCardWrapper(
                    entranceDelay: Duration(milliseconds: 500),
                    child: EstimationCard(),
                  ),
                  const SizedBox(height: 16),

                  // e. Reset button di bottom
                  AnimatedCardWrapper(
                    entranceDelay: const Duration(milliseconds: 600),
                    child: SizedBox(
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
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
