import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/prayer_time.dart';
import '../../../services/prayer_service.dart';

class NextPrayerCard extends StatefulWidget {
  final PrayerTime prayerTime;

  const NextPrayerCard({
    super.key,
    required this.prayerTime,
  });

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  late Map<String, dynamic> _nextPrayer;
  late Duration _remainingDuration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateNextPrayer();
    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateNextPrayer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateNextPrayer() {
    final nextPrayer = PrayerService.getNextPrayer(widget.prayerTime);
    setState(() {
      _nextPrayer = nextPrayer;
      _remainingDuration = nextPrayer['duration'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final hours = _remainingDuration.inHours;
    final minutes = _remainingDuration.inMinutes % 60;
    final seconds = _remainingDuration.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.1),
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
        children: [
          Text(
            'SHOLAT BERIKUTNYA',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _nextPrayer['name'] ?? 'Unknown',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimeUnit(
                  value: hours,
                  label: 'Jam',
                  theme: theme,
                  cs: cs,
                ),
                Text(
                  ':',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(color: cs.onSurface),
                ),
                _TimeUnit(
                  value: minutes,
                  label: 'Menit',
                  theme: theme,
                  cs: cs,
                ),
                Text(
                  ':',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(color: cs.onSurface),
                ),
                _TimeUnit(
                  value: seconds,
                  label: 'Detik',
                  theme: theme,
                  cs: cs,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pukul ${(_nextPrayer['time'] as DateTime).hour.toString().padLeft(2, '0')}:${(_nextPrayer['time'] as DateTime).minute.toString().padLeft(2, '0')} WIB',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;
  final ThemeData theme;
  final ColorScheme cs;

  const _TimeUnit({
    required this.value,
    required this.label,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
