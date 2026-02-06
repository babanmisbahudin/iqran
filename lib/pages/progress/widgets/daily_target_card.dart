import 'package:flutter/material.dart';

/// Widget untuk display daily reading target vs actual
class DailyTargetCard extends StatelessWidget {
  final int versesReadToday;
  final int dailyTarget;
  final double progressPercentage;

  const DailyTargetCard({
    Key? key,
    required this.versesReadToday,
    required this.dailyTarget,
    required this.progressPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isCompleted = progressPercentage >= 100;
    final displayPercentage = progressPercentage.clamp(0, 100);

    // Get motivational message
    String message;
    if (versesReadToday == 0) {
      message = 'Mulai membaca hari ini! 📖';
    } else if (isCompleted) {
      message = '🎉 Target harian tercapai! Alhamdulillah';
    } else if (displayPercentage >= 75) {
      message = 'Tinggal sedikit lagi! 💪';
    } else if (displayPercentage >= 50) {
      message = 'Sudah separuh jalan! 👍';
    } else {
      message = 'Mari lanjutkan membaca 📚';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.15),
            cs.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target Hari Ini',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                ),
                child: Text(
                  '${displayPercentage.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green : Colors.orange,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: displayPercentage / 100,
              minHeight: 12,
              backgroundColor: cs.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? Colors.green : cs.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$versesReadToday / $dailyTarget ayat',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '${(dailyTarget - versesReadToday).clamp(0, dailyTarget)} lagi',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Motivational message
          Center(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: cs.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
