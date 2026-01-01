import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../services/quran_service.dart';
import '../../services/progress_service.dart';
import '../../models/surah.dart';
import 'surah_detail_page.dart';

class SurahListPage extends StatefulWidget {
  final double fontSize;
  const SurahListPage({super.key, required this.fontSize});

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  bool _isSearching = false;
  String _keyword = '';

  List<Surah> _surah = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  /// =========================
  /// LOAD CEPAT (LOCAL ➜ UI)
  /// =========================
  Future<void> _loadInitial() async {
    // 1️⃣ ambil data lokal dulu (INSTANT)
    final local = await QuranService.fetchSurahLocal();

    if (mounted) {
      setState(() {
        _surah = local;
        _loading = false;
      });
    }

    // 2️⃣ sync online di background (tidak blocking UI)
    QuranService.fetchSurah().then((fresh) {
      if (!mounted) return;
      setState(() => _surah = fresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final filteredSurah = _keyword.isEmpty
        ? _surah
        : _surah.where((s) {
            return s.namaLatin.toLowerCase().contains(_keyword) ||
                s.nama.toLowerCase().contains(_keyword) ||
                s.nomor.toString().contains(_keyword);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari surah…',
                  border: InputBorder.none,
                ),
                style: theme.textTheme.titleMedium,
                onChanged: (v) {
                  setState(() => _keyword = v.toLowerCase());
                },
              )
            : const Text('Al-Qur’an'),
        actions: [
          /// 🔍 SEARCH
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _keyword = '';
              });
            },
          ),

          /// 📵 OFFLINE INDICATOR (FIXED)
          FutureBuilder<List<ConnectivityResult>>(
            future: Connectivity().checkConnectivity(),
            builder: (_, snap) {
              final results = snap.data ?? [];
              if (results.contains(ConnectivityResult.none)) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.wifi_off),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: _loading && _surah.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, int>?>(
              future: ProgressService.load(),
              builder: (_, progressSnap) {
                final lastSurah = progressSnap.data?['surah'];

                if (filteredSurah.isEmpty) {
                  return const Center(
                    child: Text('Surah tidak ditemukan'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredSurah.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final e = filteredSurah[index];
                    final isLastRead = e.nomor == lastSurah;

                    return Container(
                      decoration: BoxDecoration(
                        color: isLastRead
                            ? cs.primary.withValues(alpha: 0.08)
                            : null,
                        border: isLastRead
                            ? Border(
                                left: BorderSide(color: cs.primary, width: 4),
                              )
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.namaLatin,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isLastRead)
                              Text(
                                'Terakhir dibaca',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          '${e.jumlahAyat} ayat',
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: Text(
                          e.nama,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'QuranFont',
                            fontSize: 22,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurahDetailPage(
                                nomor: e.nomor,
                                nama: e.namaLatin,
                                fontSize: widget.fontSize,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
