import 'quran_service.dart';
import 'offline_status_service.dart';

class QuranPreloadService {
  static Future<void> preloadAll({
    required void Function(int current, int total) onProgress,
  }) async {
    final surahList = await QuranService.fetchSurah();
    final total = surahList.length;

    final startIndex = await OfflineStatusService.getProgress();

    for (int i = startIndex; i < total; i++) {
      final surah = surahList[i];
      await QuranService.fetchAyat(surah.nomor);

      await OfflineStatusService.saveProgress(i + 1);
      onProgress(i + 1, total);
    }

    await OfflineStatusService.setReady(true);
    await OfflineStatusService.clearProgress();
  }
}
