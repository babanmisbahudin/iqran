import 'package:flutter/material.dart';

import '../../services/quran_service.dart';
import '../../services/progress_service.dart';
import '../../services/surah_bookmark_service.dart';

import '../../models/ayat.dart';

import '../../widgets/surah_audio_panel.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomor;
  final String nama;
  final double fontSize;

  const SurahDetailPage({
    super.key,
    required this.nomor,
    required this.nama,
    required this.fontSize,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  bool showLatin = false;
  bool showTranslate = false;

  final ScrollController _scrollController = ScrollController();
  bool _hasAutoScrolled = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        title: Text(widget.nama),
        actions: [
          /// ⭐ BOOKMARK SURAH
          FutureBuilder<bool>(
            future: SurahBookmarkService.isBookmarked(widget.nomor),
            builder: (context, snap) {
              final isBookmarked = snap.data ?? false;

              return IconButton(
                tooltip: 'Surah Favorit',
                icon: Icon(
                  Icons.star,
                  color: isBookmarked ? Colors.amber : Colors.white,
                ),
                onPressed: () async {
                  if (isBookmarked) {
                    await SurahBookmarkService.remove(widget.nomor);
                  } else {
                    await SurahBookmarkService.add(
                      widget.nomor,
                      widget.nama,
                    );
                  }
                  if (mounted) setState(() {});
                },
              );
            },
          ),

          IconButton(
            tooltip: 'Latin',
            icon: Icon(
              Icons.text_fields,
              color: showLatin ? cs.primary : null,
            ),
            onPressed: () => setState(() => showLatin = !showLatin),
          ),
          IconButton(
            tooltip: 'Terjemahan',
            icon: Icon(
              Icons.translate,
              color: showTranslate ? cs.primary : null,
            ),
            onPressed: () => setState(() => showTranslate = !showTranslate),
          ),
        ],
      ),

      // =========================
      // BODY
      // =========================
      body: FutureBuilder<List<Ayat>>(
        future: QuranService.fetchAyat(widget.nomor),
        builder: (context, ayatSnap) {
          if (ayatSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!ayatSnap.hasData || ayatSnap.data!.isEmpty) {
            return const Center(child: Text('Ayat tidak tersedia'));
          }

          final ayatList = ayatSnap.data!;

          return FutureBuilder<Map<String, int>?>(
            future: ProgressService.load(),
            builder: (context, progressSnap) {
              final lastSurah = progressSnap.data?['surah'];
              final lastAyat = progressSnap.data?['ayat'];

              // AUTO SCROLL
              if (!_hasAutoScrolled &&
                  lastSurah == widget.nomor &&
                  lastAyat != null) {
                final index = ayatList.indexWhere((a) => a.nomor == lastAyat);

                if (index != -1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        index * 150.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                  _hasAutoScrolled = true;
                }
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: ayatList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SurahAudioPanel(
                      surahNumber: widget.nomor,
                    );
                  }

                  final ayat = ayatList[index - 1];
                  final isLastRead =
                      lastSurah == widget.nomor && lastAyat == ayat.nomor;

                  return GestureDetector(
                    onTap: () async {
                      await ProgressService.save(
                        surah: widget.nomor,
                        ayat: ayat.nomor,
                      );

                      if (!mounted) return;

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Progress disimpan: ${widget.nama} ayat ${ayat.nomor}',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );

                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isLastRead
                            ? cs.primary.withValues(alpha: 0.12)
                            : null,
                        border: isLastRead
                            ? Border(
                                left: BorderSide(
                                  color: cs.primary,
                                  width: 4,
                                ),
                              )
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    '${ayat.arab} ۝${ayat.nomor}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'QuranFont',
                                      fontSize: widget.fontSize,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              if (isLastRead) _LastReadBadge(cs),
                            ],
                          ),
                          if (showLatin || showTranslate)
                            Divider(
                              thickness: 0.6,
                              color: cs.outline.withValues(alpha: 0.3),
                            ),
                          if (showLatin)
                            Text(
                              ayat.latin,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          if (showTranslate)
                            Text(
                              ayat.indo,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// =========================
// BADGE TERAKHIR DIBACA
// =========================
class _LastReadBadge extends StatelessWidget {
  final ColorScheme cs;
  const _LastReadBadge(this.cs);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 14, color: cs.primary),
          const SizedBox(width: 4),
          Text(
            'Terakhir dibaca',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
