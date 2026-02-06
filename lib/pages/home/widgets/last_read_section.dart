import 'package:flutter/material.dart';

import '../../../services/quran_service.dart';
import '../../../models/surah.dart';

class LastReadSection extends StatefulWidget {
  final int? surah;
  final int? ayat;
  final VoidCallback onTap;

  const LastReadSection({
    super.key,
    this.surah,
    this.ayat,
    required this.onTap,
  });

  @override
  State<LastReadSection> createState() => _LastReadSectionState();
}

class _LastReadSectionState extends State<LastReadSection> {
  late Future<Surah?> _surahDetailFuture;

  @override
  void initState() {
    super.initState();
    _loadSurahDetail();
  }

  @override
  void didUpdateWidget(LastReadSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surah != widget.surah) {
      _loadSurahDetail();
    }
  }

  void _loadSurahDetail() {
    if (widget.surah == null) {
      _surahDetailFuture = Future.value(null);
      return;
    }

    _surahDetailFuture = QuranService.fetchSurahLocal().then((surahs) {
      try {
        return surahs.firstWhere((s) => s.nomor == widget.surah);
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FutureBuilder<Surah?>(
      future: _surahDetailFuture,
      builder: (context, snapshot) {
        final surahData = snapshot.data;

        // Default values
        final surahName = surahData?.namaLatin ?? 'Al-Fatihah';
        final ayatText = widget.ayat != null
            ? 'Ayat ${widget.ayat}'
            : 'Ayat 1 - ${surahData?.jumlahAyat ?? 7}';

        // Calculate progress
        double progress = 0.0;
        if (widget.surah != null && surahData != null && widget.ayat != null) {
          progress = widget.ayat! / surahData.jumlahAyat;
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
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
                      Expanded(
                        child: Text(
                          'Lanjutkan Membaca',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: cs.primary,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                Text(
                  'Surah $surahName',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  ayatText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: cs.primary.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% Surah Selesai',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            ),
          ),
        );
      },
    );
  }
}
