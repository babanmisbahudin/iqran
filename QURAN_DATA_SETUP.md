# Quran Data Setup Guide

## Overview
iQran menggunakan **local Quran data** tanpa API. Semua data Quran (114 surahs + 6236 ayat) disimpan sebagai JSON asset dalam aplikasi.

## Prerequisites
- Python 3.7+
- Internet connection (untuk download data sekali saja)
- `requests` library: `pip install requests`

## Setup Steps

### 1. Generate Quran Data
Jalankan script generator untuk download dan create asset files:

```bash
cd /path/to/iqran
python tools/generate_quran_data.py
```

Script ini akan:
✅ Download semua 114 surahs dari equran.id API
✅ Download semua 6236 ayat dengan Latin dan Indonesian
✅ Generate `assets/data/quran_data.json` (±5-10 MB)
✅ Update `lib/data/quran_data.dart` dengan daftar surahs

### 2. Update pubspec.yaml
File `assets/` harus didaftarkan di `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/data/quran_data.json
```

Sudah otomatis ditambah? Cek di `pubspec.yaml` line yang berisi `assets/data/`.

### 3. Cleanup Old API Code (Optional)
Untuk lebih clean, bisa menghapus yang tidak dipakai:

```bash
rm lib/services/quran_service.dart
rm lib/services/quran_db.dart
```

### 4. Update Code References
Ganti semua `QuranService` dengan `QuranLocalService` di file-file yang menggunakan Quran data:

```dart
// Sebelum:
import '../services/quran_service.dart';
final surahs = await QuranService.fetchSurah();

// Sesudah:
import '../services/quran_local_service.dart';
final surahs = await QuranLocalService.fetchSurah();
```

### 5. Test
```bash
flutter pub get
flutter run
```

## File Structure

```
lib/
├── data/
│   └── quran_data.dart          # Quran data class (auto-generated)
├── services/
│   └── quran_local_service.dart # Local service (no API calls)
└── models/
    ├── surah.dart
    └── ayat.dart

assets/
└── data/
    └── quran_data.json          # Complete Quran data (generated)

tools/
└── generate_quran_data.py       # Generator script
```

## Features

### ✅ No API Calls
- Semua data dimuat dari asset local
- Lebih cepat, tidak butuh internet saat app running
- Lebih reliable, tidak bergantung pada status API

### ✅ Complete Data
- 114 Surahs dengan info lengkap
- 6236 Ayat dengan:
  - Teks Arab
  - Transliterasi Latin
  - Terjemahan Indonesia

### ✅ Search & Lookup
Fungsi tersedia di `QuranLocalService`:
```dart
// Get semua surahs
final surahs = await QuranLocalService.fetchSurah();

// Get ayat untuk surahs
final ayat = await QuranLocalService.fetchAyat(1); // Surah Al-Fatihah

// Search by name
final results = QuranLocalService.searchSurah('Al-Baqarah');

// Get specific surah
final surah = QuranLocalService.getSurahByNumber(2);

// Get ayat count
final count = QuranLocalService.getAyatCount(1); // Returns 7
```

## File Sizes (Approximate)

| File | Size |
|------|------|
| quran_data.json | 5-8 MB |
| App Build | +5-8 MB |
| **Total Impact** | **~5-8 MB** |

## Troubleshooting

### ❌ "assets/data/quran_data.json not found"
**Solution:**
1. Jalankan: `python tools/generate_quran_data.py`
2. Pastikan file ada di: `assets/data/quran_data.json`
3. Update `pubspec.yaml` dengan asset reference
4. Run: `flutter pub get`

### ❌ "Network timeout"
**Solution:**
- Script akan auto-retry jika timeout
- Pastikan internet connection stabil
- Coba jalankan ulang script

### ❌ "Python not found"
**Solution:**
- Install Python 3.7+ dari https://www.python.org
- Install requirements: `pip install requests`

## API Response Structure

Data diambil dari: `https://equran.id/api/v2/`

### Surahs Endpoint
```json
{
  "nomor": 1,
  "nama": "الفاتحة",
  "namaLatin": "Al-Fatihah",
  "jumlahAyat": 7
}
```

### Ayat Endpoint
```json
{
  "nomorAyat": 1,
  "teksArab": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
  "teksLatin": "Bismillah ar-Rahman ar-Rahim",
  "teksIndonesia": "Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang"
}
```

## Performance

- **Load time**: ~100-200ms (first load)
- **Memory usage**: ~20-30 MB (all data in memory)
- **Search**: <50ms for 114 surahs
- **Ayat lookup**: <1ms direct access

## Future Enhancements

- [ ] Compress JSON data (GZIP/Brotli)
- [ ] Lazy load by surah (load on demand)
- [ ] Add more translations (English, Malay, etc.)
- [ ] Add Tajweed marks (tanda baca Tajweed)
- [ ] Add audio URL mapping

## Questions?

Check:
1. `quran_local_service.dart` untuk API service
2. `quran_data.dart` untuk data structure
3. `tools/generate_quran_data.py` untuk script details

---

**Status**: ✅ Ready to use
**Last Updated**: 2026-02-17
**Data Source**: equran.id API
