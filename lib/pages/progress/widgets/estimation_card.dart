import 'package:flutter/material.dart';
import 'package:iqran/services/stats_service.dart';

class EstimationCard extends StatefulWidget {
  const EstimationCard({super.key});

  @override
  State<EstimationCard> createState() => _EstimationCardState();
}

class _EstimationCardState extends State<EstimationCard> {
  int _dailyTarget = 10; // Default target: 10 ayat/hari

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
            // Header dengan icon
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: cs.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estimasi Hatam',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Daily target label
            Text(
              'Target harian: $_dailyTarget ayat/hari',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // Slider
            Slider(
              min: 1,
              max: 50,
              divisions: 49,
              value: _dailyTarget.toDouble(),
              onChanged: (value) {
                setState(() => _dailyTarget = value.toInt());
              },
            ),
            const SizedBox(height: 16),

            // Estimated completion date
            FutureBuilder<DateTime?>(
              future: StatsService.estimateCompletionDate(
                dailyTarget: _dailyTarget,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.celebration,
                        color: Colors.green,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selesai! 🎉',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                }

                final date = snapshot.data!;

                // Format date dengan fallback jika locale tidak tersedia
                String formatted;
                final day = date.day;
                final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei',
                                'Juni', 'Juli', 'Agustus', 'September', 'Oktober',
                                'November', 'Desember'];

                // Format simple
                formatted = '$day ${months[date.month - 1]} ${date.year}';

                final daysLeft = date.difference(DateTime.now()).inDays;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatted,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$daysLeft hari lagi',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
