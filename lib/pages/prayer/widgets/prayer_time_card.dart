import 'package:flutter/material.dart';

class PrayerTimeCard extends StatelessWidget {
  final String name;
  final String time;

  const PrayerTimeCard({
    super.key,
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final now = DateTime.now();

    // Parse time
    final timeParts = time.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts[1]) ?? 0;
    final prayerTime = DateTime(now.year, now.month, now.day, hour, minute);

    final isPassed = now.isAfter(prayerTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isPassed
            ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
            : cs.surfaceContainer,
        border: Border.all(
          color: isPassed ? cs.outlineVariant : cs.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: isPassed ? cs.onSurfaceVariant : cs.onSurface,
            ),
          ),
          Row(
            children: [
              Text(
                time,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPassed ? cs.onSurfaceVariant : cs.primary,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isPassed ? Icons.check_circle : Icons.schedule,
                size: 20,
                color: isPassed ? cs.outline : cs.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
