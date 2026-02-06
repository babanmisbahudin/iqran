import 'package:flutter/material.dart';

/// Widget untuk display 7-day reading progress chart
class ProgressChartWidget extends StatelessWidget {
  /// Verses read untuk 7 hari terakhir (index 0 = oldest, index 6 = today)
  final List<int> dailyVerses;

  /// Max verses untuk normalize chart (untuk scaling)
  final int maxDaily;

  const ProgressChartWidget({
    Key? key,
    required this.dailyVerses,
    this.maxDaily = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final today = DateTime.now();

    // Days of week
    const daysOfWeek = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Ming'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.primaryContainer.withValues(alpha: 0.3),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7 Hari Terakhir',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final verses = dailyVerses[index];
                final height = (verses / maxDaily * 100).clamp(0, 100).toDouble();
                final isToday = index == 6;
                final dayOfWeek = daysOfWeek[(today.subtract(Duration(days: 6 - index)).weekday - 1) % 7];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Bar
                    Container(
                      width: 32,
                      height: height == 0 ? 8 : height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isToday ? cs.primary : cs.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Verse count
                    Text(
                      '$verses',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // Day
                    Text(
                      dayOfWeek,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
