import 'package:flutter/material.dart';

/// Widget untuk display ringkasan metrics dalam grid (2x2)
class MetricsSummaryCard extends StatelessWidget {
  final int totalVersesRead;
  final int totalSurahCompleted;
  final int currentStreak;
  final int monthlyAverageVerses;

  const MetricsSummaryCard({
    Key? key,
    required this.totalVersesRead,
    required this.totalSurahCompleted,
    required this.currentStreak,
    required this.monthlyAverageVerses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.surface,
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _MetricTile(
            icon: Icons.book,
            title: 'Total Ayat',
            value: totalVersesRead.toString(),
            color: Colors.blue,
          ),
          _MetricTile(
            icon: Icons.done_all,
            title: 'Surah Selesai',
            value: totalSurahCompleted.toString(),
            color: Colors.green,
          ),
          _MetricTile(
            icon: Icons.local_fire_department,
            title: 'Streak Saat Ini',
            value: '$currentStreak hari',
            color: Colors.orange,
          ),
          _MetricTile(
            icon: Icons.trending_up,
            title: 'Rata-rata/Bulan',
            value: monthlyAverageVerses.toString(),
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _MetricTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
