import 'package:flutter/material.dart';
import '../../../utils/hadith_data.dart';

class HadithQuoteCard extends StatelessWidget {
  final HadithData hadith;

  const HadithQuoteCard({
    Key? key,
    required this.hadith,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Arabic text (RTL)
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              hadith.arabicText,
              style: const TextStyle(
                fontFamily: 'QuranFont',
                fontSize: 24,
                height: 2.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 20),

          // Indonesian translation (LTR)
          Text(
            hadith.indonesianText,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Source attribution
          Text(
            '— ${hadith.source}',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
