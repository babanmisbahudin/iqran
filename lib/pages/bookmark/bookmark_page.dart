import 'package:flutter/material.dart';
import '../../services/bookmark_service.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmark')),
      body: FutureBuilder(
        future: BookmarkService.getAll(),
        builder: (_, s) {
          if (!s.hasData) return const Center(child: CircularProgressIndicator());
          final list = s.data!;
          if (list.isEmpty) return const Center(child: Text('Belum ada bookmark'));
          return ListView(
            children: list
                .map(
                  (b) => ListTile(
                    title: Text(
                      b.arab,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: 'QuranFont'),
                    ),
                    subtitle: Text('${b.surahName} • Ayat ${b.ayat}'),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
