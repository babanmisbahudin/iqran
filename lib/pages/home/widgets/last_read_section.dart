import 'package:flutter/material.dart';

class LastReadSection extends StatefulWidget {
  final VoidCallback onTap;

  const LastReadSection({
    super.key,
    required this.onTap,
  });

  @override
  State<LastReadSection> createState() => _LastReadSectionState();
}

class _LastReadSectionState extends State<LastReadSection> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bookmark,
                  color: cs.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Lanjutkan Membaca',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Surah Al-Fatihah',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ayat 1 - 7',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.15,
                minHeight: 8,
                backgroundColor: cs.primary.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '15% Surah Selesai',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
