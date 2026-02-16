#!/usr/bin/env python3
"""
Quran Data Generator
Fetches all Quran data from equran.id API and generates:
1. quran_data.json (asset file)
2. Updated quran_data.dart with full data
"""

import json
import requests
import sys
from pathlib import Path

BASE_URL = "https://equran.id/api/v2"
OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "data"
DART_FILE = Path(__file__).parent.parent / "lib" / "data" / "quran_data.dart"

def fetch_all_surahs():
    """Fetch all surahs from API"""
    print("📚 Fetching all surahs...")
    try:
        response = requests.get(f"{BASE_URL}/surat", timeout=10)
        response.raise_for_status()
        data = response.json()
        if data.get('code') == 200:
            surahs = data['data']
            print(f"✅ Fetched {len(surahs)} surahs")
            return surahs
        else:
            print(f"❌ API Error: {data.get('message')}")
            return None
    except Exception as e:
        print(f"❌ Error fetching surahs: {e}")
        return None


def fetch_ayat_for_surah(surah_number):
    """Fetch all ayat for a specific surah"""
    try:
        response = requests.get(f"{BASE_URL}/surat/{surah_number}", timeout=10)
        response.raise_for_status()
        data = response.json()
        if data.get('code') == 200:
            surah = data['data']
            print(f"✅ Surah {surah_number}: {surah['namaLatin']} ({len(surah['ayat'])} ayat)")
            return surah
        else:
            print(f"⚠️  Surah {surah_number}: {data.get('message')}")
            return None
    except Exception as e:
        print(f"❌ Error fetching surah {surah_number}: {e}")
        return None


def generate_quran_json(all_data):
    """Generate JSON asset file"""
    print("\n💾 Generating quran_data.json...")

    # Ensure output directory exists
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    output_file = OUTPUT_DIR / "quran_data.json"

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_data, f, ensure_ascii=False, indent=2)

    size_mb = output_file.stat().st_size / (1024 * 1024)
    print(f"✅ Created: {output_file}")
    print(f"   Size: {size_mb:.2f} MB")


def generate_dart_data_class(surahs_list):
    """Generate Dart data class"""
    print("\n🎯 Generating quran_data.dart...")

    # Generate surah list for Dart
    surah_entries = []
    for surah in surahs_list:
        entry = f"""    _surahFromMap({{
      'nomor': {surah['nomor']},
      'nama': '{surah['nama'].replace("'", "\\'")}',
      'namaLatin': '{surah['namaLatin']}',
      'jumlahAyat': {surah['jumlahAyat']},
    }},"""
        surah_entries.append(entry)

    surahs_dart = "\n".join(surah_entries)

    dart_content = f'''import '../models/surah.dart';
import '../models/ayat.dart';

/// Quran Local Data - All Quran data embedded in the app
/// This data is from equran.id API and includes:
/// - 114 Surahs with complete information
/// - All ayat data loaded from quran_data.json
class QuranData {{
  // All surahs data
  static final List<Surah> allSurahs = [
{surahs_dart}
  ];

  // Map to store ayat data for each surah
  static final Map<int, List<Ayat>> _ayatCache = {{}};
  static bool _initialized = false;

  /// Get all ayat for a specific surah
  static List<Ayat> getAyatBySurah(int surahNumber) {{
    if (_ayatCache.containsKey(surahNumber)) {{
      return _ayatCache[surahNumber]!;
    }}
    return [];
  }}

  /// Check if data is initialized
  static bool get isInitialized => _initialized;

  /// Initialize ayat data (call once on app startup)
  static Future<void> initializeAyatData(String jsonString) async {{
    if (_initialized) return;

    try {{
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final surahs = jsonData['surahs'] as List<dynamic>;

      for (var surah in surahs) {{
        final surahNum = surah['nomor'] as int;
        final ayatList = <Ayat>[];

        for (var ayat in surah['ayat'] as List<dynamic>) {{
          ayatList.add(Ayat(
            nomor: ayat['nomorAyat'] as int,
            arab: ayat['teksArab'] as String,
            latin: ayat['teksLatin'] as String,
            indo: ayat['teksIndonesia'] as String,
          ));
        }}

        _ayatCache[surahNum] = ayatList;
      }}

      _initialized = true;
    }} catch (e) {{
      print('Error initializing Quran data: $e');
    }}
  }}

  static Surah _surahFromMap(Map<String, dynamic> map) {{
    return Surah(
      nomor: map['nomor'],
      nama: map['nama'],
      namaLatin: map['namaLatin'],
      jumlahAyat: map['jumlahAyat'],
    );
  }}
}}
'''

    DART_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(DART_FILE, 'w', encoding='utf-8') as f:
        f.write(dart_content)

    print(f"✅ Created: {DART_FILE}")


def main():
    print("🚀 Quran Data Generator\n")
    print("=" * 50)

    # Fetch all surahs
    surahs = fetch_all_surahs()
    if not surahs:
        print("❌ Failed to fetch surahs. Exiting.")
        sys.exit(1)

    # Fetch ayat for each surah
    print("\n📖 Fetching ayat for all surahs...")
    all_data = {'surahs': []}

    for i, surah in enumerate(surahs, 1):
        surah_num = surah['nomor']
        full_surah = fetch_ayat_for_surah(surah_num)

        if full_surah:
            all_data['surahs'].append(full_surah)

        # Rate limiting - avoid hammering API
        if i % 10 == 0:
            print(f"   Progress: {i}/{len(surahs)}")

    if not all_data['surahs']:
        print("❌ No ayat data fetched. Exiting.")
        sys.exit(1)

    print(f"\n✅ Fetched {len(all_data['surahs'])} complete surahs with ayat data")

    # Generate files
    generate_quran_json(all_data)
    generate_dart_data_class(surahs)

    print("\n" + "=" * 50)
    print("✅ Quran data generation complete!")
    print("\nNext steps:")
    print("1. Run: flutter pub get")
    print("2. Run: flutter run")
    print("\nNOTE: The app will now load Quran data from local assets instead of API")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrupted by user")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Fatal error: {e}")
        sys.exit(1)
