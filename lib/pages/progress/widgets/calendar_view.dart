import 'package:flutter/material.dart';
import 'package:iqran/models/daily_stats.dart';

class CalendarView extends StatelessWidget {
  final List<DailyStats> stats; // Last 30 days (sorted newest first)

  const CalendarView({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Check if all days are inactive (first-time user)
    final allInactive = stats.every((s) => !s.hasActivity);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.grid_view,
                  color: cs.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aktivitas 30 Hari',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Calendar or encouragement message
            if (allInactive)
              _buildEmptyState(context)
            else
              _buildCalendarGrid(context, theme, cs),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 64,
            color: cs.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Mulai baca untuk melihat\naktivitas harian Anda',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(
      BuildContext context, ThemeData theme, ColorScheme cs) {
    return Column(
      children: [
        // Calendar grid (7 columns x 5 rows for 30+ days)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return _CalendarDay(stat: stat);
          },
        ),
        const SizedBox(height: 16),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(
              color: Colors.green.shade400,
              label: 'Aktif',
            ),
            const SizedBox(width: 24),
            _LegendItem(
              color: Colors.red.shade400,
              label: 'Tidak aktif',
            ),
          ],
        ),
      ],
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final DailyStats stat;

  const _CalendarDay({required this.stat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final color = stat.hasActivity ? Colors.green.shade400 : Colors.red.shade400;

    final date = DateTime.parse(stat.date);
    final day = date.day;

    return Tooltip(
      message: '${stat.date}\n${stat.uniqueVersesRead} ayat',
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            '$day',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
