import json

# Doa untuk 20 cerita pertama
duas = {
    1: {"arab": "رَبَّنَا وَآتِنَا مَا وَعَدْتَنَا عَلَى رُسُلِكَ", "transliterasi": "Rabbana wa atina ma wa'adtana ala rusulika", "terjemahan": "Ya Tuhan kami, berikanlah apa yang Engkau janjikan melalui rasul-rasul-Mu"},
    2: {"arab": "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ", "transliterasi": "La ilaha illa anta subhanaka", "terjemahan": "Tidak ada Tuhan selain Engkau, Mahasuci Engkau"},
    3: {"arab": "رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا", "transliterasi": "Rabbana la tu'akhidhna in nasina aw akhta'na", "terjemahan": "Ya Tuhan kami, jangan Engkau hukum kami jika kami lupa atau berbuat kesalahan"},
    4: {"arab": "رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً", "transliterasi": "Rabbana atina min ladunka rahmatan", "terjemahan": "Ya Tuhan kami, anugerahilah kepada kami rahmat dari sisi-Mu"},
    5: {"arab": "رَبِّ اجْعَلْنِي مِنْ قَوْمٍ صَالِحِينَ", "transliterasi": "Rabbi ij'al ni min qawmin salihin", "terjemahan": "Ya Tuhanku, jadikanlah aku dari golongan orang-orang yang saleh"},
    6: {"arab": "رَبِّ أَنِّي لِمَا أَنْزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ", "transliterasi": "Rabbi anni lima anzalta ilayya min khayrin faqir", "terjemahan": "Ya Tuhanku, sesungguhnya aku sangat membutuhkan rahmat yang Engkau turunkan"},
    7: {"arab": "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي", "transliterasi": "Rabbi isyrrah li sadri wa yassir li amri", "terjemahan": "Ya Tuhanku, lapangkan dadaku dan mudahkan urusanku"},
    8: {"arab": "رَبِّ إِنِّي أَعُوذُ بِكَ أَنْ أَدْعُوكَ بِمَا لَيْسَ لِي بِهِ عِلْمٌ", "transliterasi": "Rabbi inni a'udhu bika an ad'uwaka bima laysa li bihi ilm", "terjemahan": "Ya Tuhanku, aku berlindung kepada-Mu dari mengucapkan doa tentang hal yang aku tidak mengetahuinya"},
    9: {"arab": "رَبَّنَا إِنَّنَا آمَنَّا فَاغْفِرْ لَنَا ذُنُوبَنَا", "transliterasi": "Rabbana innana amanna faghfir lana dhunubana", "terjemahan": "Ya Tuhan kami, kami telah beriman, maka ampunilah kami atas dosa-dosa kami"},
    10: {"arab": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ", "transliterasi": "Subhanallahi wa bihamdihi subhanallahil adhim", "terjemahan": "Mahasuci Allah dan segala puji bagi-Nya, Mahasuci Allah Yang Maha Agung"},
    11: {"arab": "رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ", "transliterasi": "Rabbi ighfir li wa li walidayya", "terjemahan": "Ya Tuhanku, ampunilah aku dan kedua orang tuaku"},
    12: {"arab": "رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا", "transliterasi": "Rabbana ighfir lana wa li ikhwanina", "terjemahan": "Ya Tuhan kami, ampunilah kami dan saudara-saudara kami"},
    13: {"arab": "رَبِّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ", "transliterasi": "Rabbi a'inni ala dhikrika wa shukrika", "terjemahan": "Ya Tuhanku, bantulah aku mengingat-Mu dan bersyukur"},
    14: {"arab": "رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ", "transliterasi": "Rabbi ij'al ni muqimal solah", "terjemahan": "Ya Tuhanku, jadikanlah aku orang yang mendirikan shalat"},
    15: {"arab": "الْحَمْدُ لِلَّهِ الَّذِي وَهَبَ لِي", "transliterasi": "Alhamdulillahi alladhi wahaba li", "terjemahan": "Segala puji bagi Allah yang telah menganugerahkan kepadaku"},
    16: {"arab": "رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ", "transliterasi": "Rabbana taqabbal minna innaka anta assami", "terjemahan": "Ya Tuhan kami, terimalah dari kami, sesungguhnya Engkaulah Yang Maha Mendengar"},
    17: {"arab": "رَبَّنَا اغْفِرْ لَنَا ذُنُوبَنَا", "transliterasi": "Rabbana ighfir lana dhunubana", "terjemahan": "Ya Tuhan kami, ampunilah kami atas dosa-dosa kami"},
    18: {"arab": "رَبِّ اغْفِرْ وَارْحَمْ", "transliterasi": "Rabbi ighfir warham", "terjemahan": "Ya Tuhanku, ampunilah dan sayangilah"},
    19: {"arab": "رَبَّنَا آمَنَّا بِمَا أَنْزَلْتَ", "transliterasi": "Rabbana amanna bima anzalta", "terjemahan": "Ya Tuhan kami, kami beriman pada yang Engkau turunkan"},
    20: {"arab": "رَبَّنَا ظَلَمْنَا أَنْفُسَنَا", "transliterasi": "Rabbana dhalamna anfusana", "terjemahan": "Ya Tuhan kami, kami telah menganiaya diri kami sendiri"},
}

default_dua = {"arab": "رَبَّنَا اغْفِرْ لَنَا وَارْحَمْنَا وَأَنْتَ خَيْرُ الرَّاحِمِينَ", "transliterasi": "Rabbana ighfir lana warhamna wa anta khayru arrahimin", "terjemahan": "Ya Tuhan kami, ampunilah kami dan sayangilah kami, dan Engkau adalah sebaik-baik yang menyayangi"}

with open('assets/data/tadabur_stories.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

added = 0
for story in data['stories']:
    if story['id'] in duas:
        story['doa'] = duas[story['id']]
    else:
        story['doa'] = default_dua
    added += 1

with open('assets/data/tadabur_stories.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Berhasil menambahkan doa ke {added} cerita!")
