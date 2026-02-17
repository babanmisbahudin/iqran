import json

# Doa untuk berbagai tema cerita
duas = {
    1: {"arab": "رَبَّنَا وَآتِنَا مَا وَعَدْتَنَا عَلَى رُسُلِكَ وَلَا تُخْزِنَا يَوْمَ الْقِيَامَةِ", "transliterasi": "Rabbana wa atina ma wa'adtana ala rusulika wa la tukhzina yawmal qiyamah", "terjemahan": "Ya Tuhan kami, berikanlah kepada kami apa yang telah Engkau janjikan melalui rasul-rasul-Mu"},
    2: {"arab": "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ", "transliterasi": "La ilaha illa anta subhanaka inni kuntu min adh-dhalimin", "terjemahan": "Tidak ada Tuhan selain Engkau, Mahasuci Engkau, sesungguhnya aku adalah orang-orang yang berbuat zalim"},
    41: {"arab": "رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي", "transliterasi": "Rabbi ij'al ni muqimal solah wa min dhurriyyati", "terjemahan": "Ya Tuhanku, jadikanlah aku dan keturunanku orang-orang yang mendirikan shalat"},
}

default_dua = {"arab": "رَبَّنَا اغْفِرْ لَنَا وَارْحَمْنَا وَأَنْتَ خَيْرُ الرَّاحِمِينَ", "transliterasi": "Rabbana ighfir lana warhamna wa anta khayru arrahimin", "terjemahan": "Ya Tuhan kami, ampunilah kami dan sayangilah kami, dan Engkau adalah sebaik-baik yang menyayangi"}

with open('assets/data/tadabur_stories.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

for story in data['stories']:
    if story['id'] in duas:
        story['doa'] = duas[story['id']]
    else:
        story['doa'] = default_dua

with open('assets/data/tadabur_stories.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("Berhasil menambahkan doa ke semua cerita!")
