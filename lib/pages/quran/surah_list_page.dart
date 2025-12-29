import 'package:flutter/material.dart';

import '../../services/quran_service.dart';
import '../../services/progress_service.dart';
import '../../models/surah.dart';
import 'surah_detail_page.dart';

class SurahListPage extends StatelessWidget {
  final double fontSize;
  const SurahListPage({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Al-Qur’an')),
      body: FutureBuilder<List<Surah>>(
        future: QuranService.fetchSurah(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final surahList = snapshot.data!;

          return FutureBuilder<Map<String, int>?>(
            future: ProgressService.load(),
            builder: (_, progressSnap) {
              final lastSurah = progressSnap.data?['surah'];

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: surahList.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final e = surahList[index];
                  final isLastRead = e.nomor == lastSurah;

                  return Container(
                    decoration: BoxDecoration(
                      color: isLastRead
                          ? cs.primary.withValues(alpha: 0.08)
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      // ======================
                      // NAMA LATIN
                      // ======================
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.namaLatin,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          if (isLastRead)
                            Text(
                              'Terakhir dibaca',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                        ],
                      ),

                      // ======================
                      // INFO AYAT
                      // ======================
                      subtitle: Text(
                        '${e.jumlahAyat} ayat',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      // ======================
                      // NAMA ARAB (DIPERBESAR)
                      // ======================
                      trailing: Text(
                        e.nama,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontFamily: 'QuranFont',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurahDetailPage(
                              nomor: e.nomor,
                              nama: e.namaLatin,
                              fontSize: fontSize,
                            ),
                          ),
                        );
                      },
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
