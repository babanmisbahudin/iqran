import 'package:flutter/material.dart';

import '../../services/surah_bookmark_service.dart';
import '../../models/surah_bookmark.dart';
import '../quran/surah_detail_page.dart';

class BookmarkPage extends StatefulWidget {
  final double fontSize;

  const BookmarkPage({
    super.key,
    this.fontSize = 28.0,
  });

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late Future<List<SurahBookmark>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _bookmarksFuture = SurahBookmarkService.getAll();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _loadData();
    });
    await _bookmarksFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah Favorit'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<List<SurahBookmark>>(
          future: _bookmarksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text('Belum ada surah favorit'),
                  ),
                ],
              );
            }

            final list = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final surah = list[index];

                return Material(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahDetailPage.fromBookmark(
                            nomor: surah.nomor,
                            nama: surah.nama,
                            fontSize: widget.fontSize,
                          ),
                        ),
                      ).then((_) {
                        // Reload data when user returns from reading
                        if (mounted) {
                          setState(() {
                            _loadData();
                          });
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surah.nama,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Surah ke-${surah.nomor}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
