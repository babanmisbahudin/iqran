import 'package:flutter/material.dart';

import '../../../models/fasting_schedule.dart';

class FastingCard extends StatelessWidget {
  final FastingSchedule fasting;
  final bool isDone;
  final VoidCallback onToggle;

  const FastingCard({
    super.key,
    required this.fasting,
    required this.isDone,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDone
            ? cs.primary.withValues(alpha: 0.1)
            : cs.surfaceContainer,
        border: Border.all(
          color: isDone
              ? cs.primary.withValues(alpha: 0.3)
              : cs.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isDone,
            onChanged: (_) => onToggle(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fasting.dateString,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDone ? cs.primary : cs.onSurface,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (fasting.description.isNotEmpty)
                  Text(
                    fasting.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
