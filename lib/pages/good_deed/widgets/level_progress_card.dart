import 'package:flutter/material.dart';

class LevelProgressCard extends StatelessWidget {
  final Map<String, dynamic> levelInfo;

  const LevelProgressCard({
    super.key,
    required this.levelInfo,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final level = levelInfo['level'] as int;
    final totalExp = levelInfo['totalExp'] as int;
    final expForCurrentLevel = levelInfo['expForCurrentLevel'] as int;
    final expForNextLevel = levelInfo['expForNextLevel'] as int;
    final levelProgress = levelInfo['levelProgress'] as double;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.12),
            cs.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level $level',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total EXP: $totalExp',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.primary.withValues(alpha: 0.1),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.star,
                  color: cs.primary,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level Progress',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    '$expForCurrentLevel / $expForNextLevel',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: levelProgress,
                  minHeight: 12,
                  backgroundColor: cs.primary.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.trending_up,
                label: 'Progress',
                value: '${(levelProgress * 100).toStringAsFixed(0)}%',
                color: cs.primary,
              ),
              _StatItem(
                icon: Icons.local_fire_department,
                label: 'Next Level',
                value: '${expForNextLevel - expForCurrentLevel}',
                color: Colors.orange,
              ),
              _StatItem(
                icon: Icons.check_circle,
                label: 'Achieved',
                value: 'Lvl $level',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}
