import 'package:flutter/material.dart';
import '../../services/surah_bookmark_service.dart';
import '../../models/surah_bookmark.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Surah Favorit')),
      body: FutureBuilder<List<SurahBookmark>>(
        future: SurahBookmarkService.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada surah favorit'));
          }

          final list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final surah = list[index];

              return ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text(surah.nama),
                subtitle: Text('Surah ke-${surah.nomor}'),
                onTap: () {
                  // nanti bisa navigasi ke SurahDetailPage
                },
              );
            },
          );
        },
      ),
    );
  }
}
