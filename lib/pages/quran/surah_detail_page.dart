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

class _SurahDetailPageState extends State<SurahDetailPage>
    with SingleTickerProviderStateMixin {
  bool showLatin = false;
  bool showTranslate = false;

  final ScrollController _scrollController = ScrollController();
  bool _hasAutoScrolled = false;

  // =========================
  // BOOKMARK ANIMATION
  // =========================
  late final AnimationController _bookmarkController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    _bookmarkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.15)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_bookmarkController);

    _opacityAnim = Tween<double>(begin: 0.6, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_bookmarkController);

    _bookmarkController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) _bookmarkController.stop();
    });
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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

              final starIcon = Icon(
                Icons.star,
                color: isBookmarked ? Colors.amber : cs.onSurface,
              );

              return IconButton(
                tooltip: 'Surah Favorit',
                icon: isBookmarked
                    ? starIcon
                    : ScaleTransition(
                        scale: _scaleAnim,
                        child: isDark
                            ? starIcon
                            : FadeTransition(
                                opacity: _opacityAnim,
                                child: starIcon,
                              ),
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
              color: showLatin ? cs.primary : cs.onSurface,
            ),
            onPressed: () => setState(() => showLatin = !showLatin),
          ),
          IconButton(
            tooltip: 'Terjemahan',
            icon: Icon(
              Icons.translate,
              color: showTranslate ? cs.primary : cs.onSurface,
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

              // =========================
              // AUTO SCROLL TERAKHIR DIBACA
              // =========================
              if (!_hasAutoScrolled &&
                  lastSurah == widget.nomor &&
                  lastAyat != null) {
                final index = ayatList.indexWhere((a) => a.nomor == lastAyat);

                if (index != -1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        index * 180,
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
                            'Terakhir dibaca: ${widget.nama} ayat ${ayat.nomor}',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );

                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 26),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
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
                                      height: 1.9,
                                      letterSpacing: 0.5,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              if (isLastRead) _LastReadBadge(cs),
                            ],
                          ),
                          if (showLatin || showTranslate)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Divider(
                                thickness: 0.6,
                                color: cs.outline.withValues(alpha: 0.3),
                              ),
                            ),
                          if (showLatin)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                ayat.latin,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          if (showTranslate)
                            Text(
                              ayat.indo,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(height: 1.7),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 14, color: cs.primary),
          const SizedBox(height: 4),
          Text(
            'Terakhir',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'dibaca',
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
