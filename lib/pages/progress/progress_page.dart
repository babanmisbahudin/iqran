import 'package:flutter/material.dart';
import '../../services/progress_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Future<Map<String, int>?> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ProgressService.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Murajaah')),
      body: FutureBuilder<Map<String, int>?>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'Belum ada progress murajaah',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final surah = snapshot.data!['surah']!;
          final ayat = snapshot.data!['ayat']!;
          final progress = surah / 114;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Terakhir dibaca'),
                const SizedBox(height: 4),
                Text(
                  'Surah $surah • Ayat $ayat',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset Progress'),
                  onPressed: () async {
                    await ProgressService.reset();
                    setState(() {
                      _load(); // 🔥 refresh TANPA navigator
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
