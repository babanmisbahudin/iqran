#!/usr/bin/env python3
"""
Script untuk menambah cerita baru ke Tadabur dengan doa otomatis
Usage: python add_story_with_doa.py
"""

import json

# Comprehensive mapping of Quranic verses/surahs to relevant duas
DUAS_BY_SURAH = {
    1: {  # Surah Al-Fatihah
        "arab": "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
        "transliterasi": "Alhamdulillahi rabbil alamin",
        "terjemahan": "Segala puji bagi Allah, Tuhan semesta alam"
    },
    2: {  # Surah Al-Baqarah
        "arab": "رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا",
        "transliterasi": "Rabbana la tu'akhidhna in nasina aw akhta'na",
        "terjemahan": "Ya Tuhan kami, jangan Engkau hukum kami jika kami lupa atau berbuat kesalahan"
    },
    3: {  # Surah Al-Imran
        "arab": "رَبَّنَا آمَنَّا فَاغْفِرْ لَنَا ذُنُوبَنَا وَقِنَا عَذَابَ النَّارِ",
        "transliterasi": "Rabbana amanna faghfir lana dhunubana wa qina adhaba nnaar",
        "terjemahan": "Ya Tuhan kami, kami telah beriman, maka ampunilah kami dan lindungilah dari azab neraka"
    },
    4: {  # Surah An-Nisa
        "arab": "رَبِّ اجْعَلْنِي مِنْ قَوْمٍ صَالِحِينَ",
        "transliterasi": "Rabbi ij'al ni min qawmin salihin",
        "terjemahan": "Ya Tuhanku, jadikanlah aku dari golongan orang-orang yang saleh"
    },
    5: {  # Surah Al-Maidah
        "arab": "رَبَّنَا آمَنَّا بِمَا أَنْزَلْتَ وَاتَّبَعْنَا الرَّسُولَ",
        "transliterasi": "Rabbana amanna bima anzalta wattaba'na arrasul",
        "terjemahan": "Ya Tuhan kami, kami beriman pada yang Engkau turunkan dan kami mengikuti Rasul"
    },
    6: {  # Surah Al-An'am
        "arab": "قُلْ إِنَّ صَلَاتِي وَنُسُكِي وَمَحْيَايَ وَمَمَاتِي لِلَّهِ رَبِّ الْعَالَمِينَ",
        "transliterasi": "Qul inna salati wa nusuki wa mahyaya wa mamati lillahi rabbil alamin",
        "terjemahan": "Katakanlah: Sesungguhnya shalatku, ibadahku, hidupku dan matiku hanya untuk Allah, Tuhan semesta alam"
    },
    7: {  # Surah Al-A'raf
        "arab": "رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ",
        "transliterasi": "Rabbana dhalamna anfusana wa in lam taghfir lana wa tarhamna lanakununna min al-khasirun",
        "terjemahan": "Ya Tuhan kami, kami telah menganiaya diri kami, jika tidak Engkau ampuni tentu kami akan rugi"
    },
    9: {  # Surah At-Taubah
        "arab": "رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالْإِيمَانِ",
        "transliterasi": "Rabbana ighfir lana wa li ikhwanina alladhina sabaquna bil iman",
        "terjemahan": "Ya Tuhan kami, ampunilah kami dan saudara-saudara kami yang telah mendahului beriman"
    },
    10: {  # Surah Yunus
        "arab": "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
        "transliterasi": "La ilaha illa anta subhanaka inni kuntu min adh-dhalimin",
        "terjemahan": "Tidak ada Tuhan selain Engkau, Mahasuci Engkau, aku adalah orang yang berbuat zalim"
    },
    12: {  # Surah Yusuf
        "arab": "رَبِّ قَدْ آتَيْتَنِي مِنَ الْمُلْكِ وَعَلَّمْتَنِي مِنْ تَأْوِيلِ الْأَحَادِيثِ",
        "transliterasi": "Rabbi qad ataytani min al-mulk wa allamtani min ta'wil al-ahadith",
        "terjemahan": "Ya Tuhanku, sesungguhnya Engkau telah memberikan kepadaku sebagian dari kerajaan dan mengajarkan kepadaku ta'wil mimpi"
    },
    16: {  # Surah An-Nahl
        "arab": "رَبِّ اغْفِرْ وَارْحَمْ وَأَنْتَ خَيْرُ الرَّاحِمِينَ",
        "transliterasi": "Rabbi ighfir warham wa anta khayru arrahimin",
        "terjemahan": "Ya Tuhanku, ampunilah dan sayangilah, dan Engkau adalah sebaik-baik yang menyayangi"
    },
    18: {  # Surah Al-Kahf
        "arab": "رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا",
        "transliterasi": "Rabbana atina min ladunka rahmatan wa hayyii' lana min amrina rasysyada",
        "terjemahan": "Ya Tuhan kami, anugerahilah kepada kami rahmat dan sempurnakanlah petunjuk dalam urusan kami"
    },
    20: {  # Surah Taha
        "arab": "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي",
        "transliterasi": "Rabbi isyrrah li sadri wa yassir li amri wa hlul 'uqdatan min lisani",
        "terjemahan": "Ya Tuhanku, lapangkan dadaku, mudahkan urusanku, dan lepaskan kekakuan dari lidahku"
    },
    21: {  # Surah Al-Anbiya
        "arab": "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
        "transliterasi": "La ilaha illa anta subhanaka inni kuntu min adh-dhalimin",
        "terjemahan": "Tidak ada Tuhan selain Engkau, Mahasuci Engkau, aku adalah orang yang berbuat zalim"
    },
    25: {  # Surah Al-Furqan
        "arab": "رَبِّ اجْعَلْ لِي آيَةً وَلَا تَجْعَلْنِي مِنَ الْقَوْمِ الظَّالِمِينَ",
        "transliterasi": "Rabbi ij'al li ayatan wa la taj'al ni min al-qawm adh-dhalimin",
        "terjemahan": "Ya Tuhanku, berikan kepadaku tanda dan jangan jadikan aku dari orang-orang yang zalim"
    },
    26: {  # Surah As-Syu'ara
        "arab": "رَبِّ إِنِّي أَعُوذُ بِكَ أَنْ أَسْأَلَكَ مَا لَيْسَ لِي بِهِ عِلْمٌ",
        "transliterasi": "Rabbi inni a'udhu bika an as'alaka ma laysa li bihi ilm",
        "terjemahan": "Ya Tuhanku, aku berlindung kepada-Mu dari memohon sesuatu yang aku tidak tahu"
    },
    31: {  # Surah Luqman
        "arab": "رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي",
        "transliterasi": "Rabbi ij'al ni muqimal solah wa min dhurriyyati",
        "terjemahan": "Ya Tuhanku, jadikanlah aku orang yang mendirikan shalat dan dari keturunanku"
    },
    33: {  # Surah Al-Ahzab
        "arab": "إِنَّا عَرَضْنَا الْأَمَانَةَ عَلَى السَّمَاوَاتِ وَالْأَرْضِ وَالْجِبَالِ",
        "transliterasi": "Inna 'aradna al-amanata 'alas samawati wal ardhi wal jibal",
        "terjemahan": "Sesungguhnya kami telah menawarkan amanah kepada langit, bumi, dan gunung-gunung"
    },
    36: {  # Surah Ya-Sin
        "arab": "سُبْحَانَ الَّذِي خَلَقَ الْأَزْوَاجَ كُلَّهَا",
        "transliterasi": "Subhana alladhiy khalaqa al-azwaja kullaha",
        "terjemahan": "Mahasuci Dia yang telah menciptakan segala sesuatu berpasang-pasangan"
    },
    39: {  # Surah Az-Zumar
        "arab": "قُلْ يَا عِبَادِ الَّذِينَ أَسْرَفُوا عَلَى أَنْفُسِهِمْ لَا تَقْنَطُوا مِنْ رَحْمَةِ اللَّهِ",
        "transliterasi": "Qul ya ibadi alladhina asrafu ala anfusihim la taqnatu min rahmati allah",
        "terjemahan": "Katakanlah: Wahai hamba-hamba-Ku yang telah berbuat merugikan diri mereka, jangan putus asa dari rahmat Allah"
    },
    40: {  # Surah Ghafir
        "arab": "رَبِّ إِنِّي ظَلَمْتُ نَفْسِي فَاغْفِرْ لِي",
        "transliterasi": "Rabbi inni dhalamtu nafsi faghfir li",
        "terjemahan": "Ya Tuhanku, sesungguhnya aku telah menganiaya diriku sendiri, maka ampunilah aku"
    },
    41: {  # Surah Fussilat
        "arab": "رَبَّنَا اغْفِرْ لَنَا وَلِآبَائِنَا وَأُمَّهَاتِنَا وَلِلْمُؤْمِنِينَ",
        "transliterasi": "Rabbana ighfir lana wa li abaaina wa ummahatin wa lilmu'minin",
        "terjemahan": "Ya Tuhan kami, ampunilah kami dan orang-orang tua kami serta semua orang beriman"
    },
    45: {  # Surah Al-Jathiyah
        "arab": "فَاعْلَمْ أَنَّهُ لَا إِلَهَ إِلَّا اللَّهُ وَاسْتَغْفِرْ لِذَنْبِكَ",
        "transliterasi": "Fa'lam annahu la ilaha illallahu wastaghfir lidhanbika",
        "terjemahan": "Maka ketahuilah bahwa tidak ada Tuhan selain Allah dan mohonlah ampun atas dosamu"
    },
    51: {  # Surah Adz-Dzariyat
        "arab": "وَقَضَى رَبُّكَ أَلَّا تَعْبُدُوا إِلَّا إِيَّاهُ وَبِالْوَالِدَيْنِ إِحْسَانًا",
        "transliterasi": "Wa qada rabbuka alla ta'budu illa iyyahu wa bil walidain ihsan",
        "terjemahan": "Dan Tuhanmu telah memerintahkan agar kamu jangan menyembah selain Dia dan berbuat baiklah kepada kedua orang tua"
    },
    55: {  # Surah Ar-Rahman
        "arab": "فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ",
        "transliterasi": "Fa bi ayyi alai rabbikuma tukadhdhibaan",
        "terjemahan": "Maka nikmat Tuhan manakah yang kamu dustakan?"
    },
    65: {  # Surah At-Talaq
        "arab": "اللَّهُ نُورُ السَّمَاوَاتِ وَالْأَرْضِ",
        "transliterasi": "Allahu nurus samawati wal ardh",
        "terjemahan": "Allah adalah Nur (cahaya) langit dan bumi"
    },
    67: {  # Surah Al-Mulk
        "arab": "تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
        "transliterasi": "Tabaraka alladhiy biyadihi al-mulk wa huwa ala kulli shai'in qadir",
        "terjemahan": "Berkati adalah Dia yang di tangan-Nya adalah kerajaan, dan Dia atas segala sesuatu Mahakuasa"
    },
    71: {  # Surah Nuh
        "arab": "قَالَ نُوحٌ رَبِّ إِنَّهُمْ عَصَوْنِي وَاتَّبَعُوا مَنْ لَمْ يَزِدْهُ",
        "transliterasi": "Qala nuh rabbi innahum asauni wattaba'u man lam yazidhum",
        "terjemahan": "Nuh berkata: Ya Tuhanku, sesungguhnya mereka telah mendurhakaiku dan mengikuti orang yang hartanya dan anaknya tidak menambah mereka"
    },
    78: {  # Surah An-Naba
        "arab": "وَعِنْدَهُمْ قَاصِرَاتُ الطَّرْفِ أَتْرَابٌ",
        "transliterasi": "Wa indahum qasiratut tharf atrab",
        "terjemahan": "Dan di sisi mereka ada perempuan-perempuan yang tegar pandangan mata seumuran mereka"
    },
}

# Default doa jika surah tidak ada di mapping
DEFAULT_DOA = {
    "arab": "رَبَّنَا اغْفِرْ لَنَا وَارْحَمْنَا وَأَنْتَ خَيْرُ الرَّاحِمِينَ",
    "transliterasi": "Rabbana ighfir lana warhamna wa anta khayru arrahimin",
    "terjemahan": "Ya Tuhan kami, ampunilah kami dan sayangilah kami, dan Engkau adalah sebaik-baik yang menyayangi"
}

def get_doa_for_surah(surah_number):
    """
    Ambil doa yang sesuai untuk surah tertentu.
    Jika tidak ada mapping, gunakan default doa.
    """
    if surah_number in DUAS_BY_SURAH:
        return DUAS_BY_SURAH[surah_number]
    return DEFAULT_DOA

def add_new_story(story_data):
    """
    Tambah cerita baru dengan doa otomatis berdasarkan surah

    story_data harus berisi:
    {
        "id": 128,
        "judul": "Judul Cerita",
        "surah": 2,
        "ayat": "2:1-10",
        "deskripsi": "...",
        "cerita": "...",
        "pelajaran": "..."
    }
    """

    # Validasi
    required_fields = ['id', 'judul', 'surah', 'ayat', 'deskripsi', 'cerita', 'pelajaran']
    for field in required_fields:
        if field not in story_data:
            raise ValueError(f"Field '{field}' harus ada dalam story_data")

    # Tambahkan doa otomatis
    surah_number = story_data['surah']
    story_data['doa'] = get_doa_for_surah(surah_number)

    # Load file yang sudah ada
    with open('assets/data/tadabur_stories.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Check jika ID sudah ada
    existing_ids = [s['id'] for s in data['stories']]
    if story_data['id'] in existing_ids:
        raise ValueError(f"Story dengan ID {story_data['id']} sudah ada!")

    # Tambahkan cerita baru
    data['stories'].append(story_data)

    # Simpan
    with open('assets/data/tadabur_stories.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    return story_data

def print_available_duas():
    """
    Print semua doa yang tersedia untuk setiap surah
    """
    print("=" * 80)
    print("DOA MAPPING UNTUK SETIAP SURAH")
    print("=" * 80)
    for surah_num in sorted(DUAS_BY_SURAH.keys()):
        doa = DUAS_BY_SURAH[surah_num]
        print(f"\nSurah {surah_num}:")
        print(f"  Arab: {doa['arab']}")
        print(f"  Transliterasi: {doa['transliterasi']}")
        print(f"  Terjemahan: {doa['terjemahan']}")
    print("\n" + "=" * 80)

if __name__ == "__main__":
    # Contoh: Print semua doa yang tersedia
    # print_available_duas()  # Skip karena Unicode encoding issue

    # Contoh: Cara menambah cerita baru
    print("=" * 80)
    print("SCRIPT: Penambahan Cerita dengan Doa Otomatis")
    print("=" * 80)

    example_story = {
        "id": 128,
        "judul": "Kisah Contoh - Doa Otomatis",
        "surah": 2,
        "ayat": "2:45-46",
        "deskripsi": "Ini adalah contoh cerita baru",
        "cerita": "Cerita akan ditambahkan di sini...",
        "pelajaran": "Pelajaran akan ditambahkan di sini..."
    }

    print("\nContoh story_data:")
    print(json.dumps(example_story, ensure_ascii=False, indent=2))

    print("\n\nUntuk menambah cerita, gunakan kode seperti ini:")
    print("""
from add_story_with_doa import add_new_story

new_story = {
    "id": 128,
    "judul": "Judul Cerita",
    "surah": 3,
    "ayat": "3:134-135",
    "deskripsi": "Deskripsi cerita",
    "cerita": "Narasi lengkap cerita...",
    "pelajaran": "Pelajaran dari cerita..."
}

result = add_new_story(new_story)
print(f"Cerita ditambahkan dengan doa untuk Surah {result['surah']}")
print(f"Doa: {result['doa']['terjemahan']}")
    """)

    print("\nScript siap digunakan!")
    print("Doa akan ditambahkan OTOMATIS berdasarkan nomor Surah cerita Anda.")
