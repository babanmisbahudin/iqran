import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../services/quran_service.dart';
import '../../services/progress_service.dart';
import '../../services/surah_bookmark_service.dart';
import '../../services/tajweed_service.dart';
import '../../services/audio_player_service.dart';

import '../../models/ayat.dart';
import '../../widgets/tajweed_text.dart';
import '../../widgets/tajweed_legend.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomor;
  final String nama;
  final double fontSize;
  final int? ayatTujuan;

  const SurahDetailPage({
    super.key,
    required this.nomor,
    required this.nama,
    required this.fontSize,
    this.ayatTujuan,
  });

  factory SurahDetailPage.fromBookmark({
    required int nomor,
    required String nama,
    double fontSize = 28,
    int? ayatTujuan,
  }) {
    return SurahDetailPage(
      nomor: nomor,
      nama: nama,
      fontSize: fontSize,
      ayatTujuan: ayatTujuan,
    );
  }

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage>
    with SingleTickerProviderStateMixin {
  bool showLatin = false;
  bool showTranslate = false;
  bool _showTajweed = false;

  final ScrollController _scrollController = ScrollController();
  int? _lastReadAyat;

  // GlobalKey untuk setiap ayat (precise scroll)
  final Map<int, GlobalKey> _ayatKeys = {};

  late final AnimationController _bookmarkController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    // Initialize tajweed service
    TajweedService.initialize();

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

    _loadLastReadAyat();
  }

  Future<void> _loadLastReadAyat() async {
    try {
      final progressData = await ProgressService.load();
      if (!mounted) return;

      int? targetAyat;

      if (widget.ayatTujuan != null) {
        targetAyat = widget.ayatTujuan;
      } else if (progressData != null &&
          progressData['surah'] == widget.nomor &&
          progressData['ayat'] != null) {
        targetAyat = progressData['ayat'];
      }

      setState(() {
        _lastReadAyat = targetAyat;
      });

      if (targetAyat != null) {
        // Scroll ke target ayat setelah frame render selesai (instant jump tanpa animation)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToAyat(targetAyat!, animate: false);
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading last read ayat: $e');
    }
  }

  @override
  void didUpdateWidget(SurahDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger rebuild jika fontSize berubah saat membaca
    if (oldWidget.fontSize != widget.fontSize) {
      setState(() {});
    }
  }

  void _scrollToAyat(int ayatNomor, {int retries = 0, bool animate = false}) {
    if (retries > 20) return; // Max 20 retries

    // PHASE 1: Rough jump to force ListView to build widgets in that area
    // (Only on first attempt, retries use callback only)
    if (retries == 0) {
      if (_scrollController.hasClients) {
        try {
          // Audio panel height + (ayat number - 1) * estimated item height
          // Estimated item height: margin(26) + padding(36) + text(~100) = ~170px
          const audioHeight = 80.0;
          const avgItemHeight = 170.0;
          final estimatedOffset = audioHeight + (ayatNomor - 1) * avgItemHeight;

          // Jump to rough position to force ListView.builder to build items
          _scrollController.jumpTo(
            estimatedOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          );
        } catch (e) {
          // Ignore errors during jump
        }
      } else {
        // ScrollController not ready yet, retry after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToAyat(ayatNomor, retries: 1, animate: animate);
          }
        });
        return;
      }
    }

    // PHASE 2: Fine-tune with GlobalKey after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_ayatKeys.containsKey(ayatNomor)) {
        final key = _ayatKeys[ayatNomor];
        final ayatContext = key?.currentContext;

        if (ayatContext != null && mounted) {
          if (animate) {
            // Smooth scroll with animation
            Scrollable.ensureVisible(
              ayatContext,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              alignment: 0.2,
            );
          } else {
            // Instant jump without animation
            try {
              final renderBox = ayatContext.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                final offset = renderBox.localToGlobal(Offset.zero).dy;
                _scrollController.jumpTo(
                  _scrollController.offset + offset - 100,
                );
              }
            } catch (e) {
              // Fallback to ensureVisible if calculation fails
              Scrollable.ensureVisible(
                ayatContext,
                alignment: 0.2,
              );
            }
          }
        } else if (mounted && retries < 20) {
          // Widget still not built, retry with exponential backoff
          // Delays: 100ms, 200ms, 300ms, 400ms, etc.
          Future.delayed(Duration(milliseconds: 100 * (retries + 1)), () {
            if (mounted) {
              _scrollToAyat(ayatNomor, retries: retries + 1, animate: animate);
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showTajweedLegendModal(BuildContext context) {
    final rules = TajweedService.getAllRules();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Tajweed Rules Legend',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: TajweedLegend(rules: rules),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: _showTajweed
          ? FloatingActionButton.extended(
              onPressed: () {
                _showTajweedLegendModal(context);
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Hukum Tajweed'),
            )
          : ValueListenableBuilder<PlayerStateStatus>(
              valueListenable: AudioPlayerService.status,
              builder: (context, status, _) {
                return FloatingActionButton(
                  heroTag: 'audio_fab_${widget.nomor}',
                  onPressed: () {
                    if (status == PlayerStateStatus.playing) {
                      AudioPlayerService.pause();
                    } else if (status == PlayerStateStatus.paused) {
                      AudioPlayerService.resume();
                    } else {
                      // Play audio
                      try {
                        AudioPlayerService.playSurahWithMetadata(
                          widget.nomor,
                          surahName: widget.nama,
                          surahNameLatin: widget.nama,
                          ayatCount: _ayatKeys.isNotEmpty ? _ayatKeys.length : 114, // Fallback to 114 ayat
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  tooltip: status == PlayerStateStatus.playing
                      ? 'Pause Murottal'
                      : 'Play Murottal',
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: status == PlayerStateStatus.loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            status == PlayerStateStatus.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            key: ValueKey(status),
                          ),
                  ),
                );
              },
            ),
      appBar: AppBar(
        title: Text(widget.nama),
        actions: [
          /// TAJWEED TOGGLE
          IconButton(
            tooltip: 'Hukum Tajweed',
            icon: Icon(
              Icons.language,
              color: _showTajweed ? cs.primary : cs.onSurface,
            ),
            onPressed: () => setState(() => _showTajweed = !_showTajweed),
          ),

          /// OFFLINE INDICATOR (FIXED)
          FutureBuilder<List<ConnectivityResult>>(
            future: Connectivity().checkConnectivity(),
            builder: (_, snap) {
              final results = snap.data ?? [];
              if (results.contains(ConnectivityResult.none)) {
                return const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.wifi_off),
                );
              }
              return const SizedBox();
            },
          ),

          /// BOOKMARK
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

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: ayatList.length,
            itemBuilder: (context, index) {
              final ayat = ayatList[index];
              final isLastRead = _lastReadAyat == ayat.nomor;

              // Create GlobalKey untuk ayat ini jika belum ada
              if (!_ayatKeys.containsKey(ayat.nomor)) {
                _ayatKeys[ayat.nomor] = GlobalKey();
              }

              return GestureDetector(
                onTap: () async {
                  await ProgressService.saveWithHistory(
                    surah: widget.nomor,
                    ayat: ayat.nomor,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Terakhir dibaca: ${widget.nama} ayat ${ayat.nomor}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );

                  setState(() {
                    _lastReadAyat = ayat.nomor;
                  });
                },
                child: Container(
                  key: _ayatKeys[ayat.nomor],
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
                              child: _showTajweed
                                  ? TajweedText(
                                      '${ayat.arab} ۝${ayat.nomor}',
                                      style: TextStyle(
                                        fontFamily: 'QuranFont',
                                        fontSize: widget.fontSize,
                                        height: 1.9,
                                      ),
                                      textAlign: TextAlign.right,
                                    )
                                  : Text(
                                      '${ayat.arab} ۝${ayat.nomor}',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: 'QuranFont',
                                        fontSize: widget.fontSize,
                                        height: 1.9,
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.7,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 14),
          SizedBox(height: 4),
          Text('Terakhir'),
          Text('dibaca'),
        ],
      ),
    );
  }
}
