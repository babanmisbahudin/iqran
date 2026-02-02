import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompassWidget extends StatelessWidget {
  final double deviceHeading;
  final double qiblaBearing;

  const CompassWidget({
    super.key,
    required this.deviceHeading,
    required this.qiblaBearing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Calculate arrow rotation relative to device heading
    final arrowAngle = (qiblaBearing - deviceHeading) * (math.pi / 180);

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Compass circle
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surface,
              border: Border.all(
                color: cs.outlineVariant,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Compass markings
          Transform.rotate(
            angle: -deviceHeading * (math.pi / 180),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // North
                Column(
                  children: [
                    Text(
                      'U',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.error,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      color: cs.error,
                    ),
                  ],
                ),
                // South
                Column(
                  children: [
                    Container(
                      width: 2,
                      height: 15,
                      color: cs.onSurfaceVariant,
                    ),
                    Text(
                      'S',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Direction labels
          Positioned(
            top: 20,
            child: Text(
              'U',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Text(
              'S',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Positioned(
            left: 20,
            child: Text(
              'B',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Text(
              'T',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),

          // Qibla arrow
          Transform.rotate(
            angle: arrowAngle,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        cs.primary,
                        cs.primary.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
                // Arrow head
                Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),

          // Center dot
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary,
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Heading display
          Positioned(
            bottom: 20,
            child: Column(
              children: [
                Text(
                  '${deviceHeading.toStringAsFixed(0)}°',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Kompas Perangkat',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
