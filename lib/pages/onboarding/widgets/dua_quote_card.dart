import 'package:flutter/material.dart';
import '../../../utils/doa_data.dart';

class DuaQuoteCard extends StatelessWidget {
  final DoaData doa;

  const DuaQuoteCard({
    Key? key,
    required this.doa,
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
          // Story title
          Text(
            doa.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Surah and Ayah reference
          Text(
            '${doa.surah} : ${doa.ayat}',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Arabic doa (RTL)
          if (doa.arab.isNotEmpty) ...[
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                doa.arab,
                style: const TextStyle(
                  fontFamily: 'QuranFont',
                  fontSize: 20,
                  height: 2.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Transliterasi (Latin)
          if (doa.transliterasi.isNotEmpty) ...[
            Text(
              doa.transliterasi,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: cs.onSurface.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],

          // Indonesian translation (LTR)
          Text(
            doa.terjemahan,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
