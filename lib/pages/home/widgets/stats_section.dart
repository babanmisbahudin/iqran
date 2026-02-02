import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.surfaceContainer,
        border: Border.all(
          color: cs.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: cs.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Progres Hari Ini',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Ayat Dibaca',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 60,
                color: cs.outlineVariant,
              ),
              Column(
                children: [
                  Text(
                    'Total Sesi',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 60,
                color: cs.outlineVariant,
              ),
              Column(
                children: [
                  Text(
                    'Target Harian',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0%',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
