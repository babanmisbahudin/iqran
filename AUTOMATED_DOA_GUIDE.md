# Automated Doa System for Tadabur Stories

## Overview

The `add_story_with_doa.py` script provides an automated system for adding new Tadabur stories to the iQran application. The key feature is **automatic doa assignment** based on the Quranic Surah referenced in each story.

### What is Doa Automation?

When you add a new story with a specific Surah number, the system automatically:
1. Checks if that Surah has a predefined doa mapping
2. Assigns the appropriate doa with three components:
   - **Arab**: Original Arabic text
   - **Transliterasi**: Latin transliteration (easy to read)
   - **Terjemahan**: Indonesian translation

If the Surah is not in the predefined mapping, a default universal doa is assigned.

---

## Quick Start

### Option 1: Using Python Import (Recommended)

Create a new Python script (e.g., `add_new_story.py`):

```python
from add_story_with_doa import add_new_story

new_story = {
    "id": 130,
    "judul": "Kisah Zebra dan Singa",
    "surah": 2,
    "ayat": "2:45-46",
    "deskripsi": "Cerita tentang keberanian menghadapi tantangan",
    "cerita": "Di tengah padang luas, seekor zebra muda harus menghadapi tantangan dari singa yang lapar. Dengan keberanian dan kepercayaan kepada Allah, zebra itu berhasil meloloskan diri. Cerita ini mengajarkan bahwa keberanian sejati datang dari iman kepada Allah...",
    "pelajaran": "Ketika kita menghadapi tantangan dalam hidup, iman kepada Allah adalah kekuatan terbesar yang dapat kita andalkan. Jangan pernah kehilangan kepercayaan pada rencana Allah."
}

try:
    result = add_new_story(new_story)
    print(f"Success! Story '{result['judul']}' added with doa for Surah {result['surah']}")
    print(f"Doa: {result['doa']['terjemahan']}")
except ValueError as e:
    print(f"Error: {e}")
```

Run it with:
```bash
python add_new_story.py
```

### Option 2: Using Command Line

```bash
python3 << 'EOF'
from add_story_with_doa import add_new_story

new_story = {
    "id": 130,
    "judul": "Kisah Baru",
    "surah": 3,
    "ayat": "3:134-135",
    "deskripsi": "...",
    "cerita": "...",
    "pelajaran": "..."
}

result = add_new_story(new_story)
EOF
```

---

## Required Fields

Every story **must** include these fields:

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `id` | Integer | Unique story ID (must be higher than 129) | `130` |
| `judul` | String | Story title in Indonesian | `"Kisah Zainab"` |
| `surah` | Integer | Quranic Surah number (1-114) | `18` |
| `ayat` | String | Quranic verse reference | `"18:10-11"` |
| `deskripsi` | String | Short description (1 sentence) | `"Cerita tentang keberanian"` |
| `cerita` | String | Full narrative story (2-5 paragraphs) | `"Ada seorang pemuda..."` |
| `pelajaran` | String | Lesson/takeaway from the story | `"Iman adalah kekuatan..."` |

**Note**: The `doa` field is **automatically added** by the system. Do NOT include it manually.

---

## Doa Mapping Reference

The system includes predefined duas for the following Surahs:

### Surahs with Predefined Duas

| Surah | Name | Doa (Transliterasi) |
|-------|------|---------------------|
| 1 | Al-Fatihah | Alhamdulillahi rabbil alamin |
| 2 | Al-Baqarah | Rabbana la tu'akhidhna in nasina aw akhta'na |
| 3 | Al-Imran | Rabbana amanna faghfir lana dhunubana wa qina adhaba nnaar |
| 4 | An-Nisa | Rabbi ij'al ni min qawmin salihin |
| 5 | Al-Maidah | Rabbana amanna bima anzalta wattaba'na arrasul |
| 6 | Al-An'am | Qul inna salati wa nusuki wa mahyaya wa mamati lillahi rabbil alamin |
| 7 | Al-A'raf | Rabbana dhalamna anfusana wa in lam taghfir lana wa tarhamna lanakununna min al-khasirun |
| 9 | At-Taubah | Rabbana ighfir lana wa li ikhwanina alladhina sabaquna bil iman |
| 10 | Yunus | La ilaha illa anta subhanaka inni kuntu min adh-dhalimin |
| 12 | Yusuf | Rabbi qad ataytani min al-mulk wa allamtani min ta'wil al-ahadith |
| 16 | An-Nahl | Rabbi ighfir warham wa anta khayru arrahimin |
| 18 | Al-Kahf | Rabbana atina min ladunka rahmatan wa hayyii' lana min amrina rasysyada |
| 20 | Taha | Rabbi isyrrah li sadri wa yassir li amri wa hlul 'uqdatan min lisani |
| 21 | Al-Anbiya | La ilaha illa anta subhanaka inni kuntu min adh-dhalimin |
| 25 | Al-Furqan | Rabbi ij'al li ayatan wa la taj'al ni min al-qawm adh-dhalimin |
| 26 | As-Syu'ara | Rabbi inni a'udhu bika an as'alaka ma laysa li bihi ilm |
| 31 | Luqman | Rabbi ij'al ni muqimal solah wa min dhurriyyati |
| 33 | Al-Ahzab | Inna 'aradna al-amanata 'alas samawati wal ardhi wal jibal |
| 36 | Ya-Sin | Subhana alladhiy khalaqa al-azwaja kullaha |
| 39 | Az-Zumar | Qul ya ibadi alladhina asrafu ala anfusihim la taqnatu min rahmati allah |
| 40 | Ghafir | Rabbi inni dhalamtu nafsi faghfir li |
| 41 | Fussilat | Rabbana ighfir lana wa li abaaina wa ummahatin wa lilmu'minin |
| 45 | Al-Jathiyah | Fa'lam annahu la ilaha illallahu wastaghfir lidhanbika |
| 51 | Adz-Dzariyat | Wa qada rabbuka alla ta'budu illa iyyahu wa bil walidain ihsan |
| 55 | Ar-Rahman | Fa bi ayyi alai rabbikuma tukadhdhibaan |
| 65 | At-Talaq | Allahu nurus samawati wal ardh |
| 67 | Al-Mulk | Tabaraka alladhiy biyadihi al-mulk wa huwa ala kulli shai'in qadir |
| 71 | Nuh | Qala nuh rabbi innahum asauni wattaba'u man lam yazidhum |
| 78 | An-Naba | Wa indahum qasiratut tharf atrab |

### Default Doa (for other Surahs)

For Surahs not listed above, the following universal doa is automatically assigned:

```
Arab: رَبَّنَا اغْفِرْ لَنَا وَارْحَمْنَا وَأَنْتَ خَيْرُ الرَّاحِمِينَ
Transliterasi: Rabbana ighfir lana warhamna wa anta khayru arrahimin
Terjemahan: Ya Tuhan kami, ampunilah kami dan sayangilah kami, dan Engkau adalah sebaik-baik yang menyayangi
```

---

## Common Errors & Solutions

### Error: "Field 'X' harus ada dalam story_data"

**Cause**: Missing a required field in your story data.

**Solution**: Check that you included all required fields: `id`, `judul`, `surah`, `ayat`, `deskripsi`, `cerita`, `pelajaran`.

```python
# WRONG (missing 'pelajaran')
new_story = {
    "id": 130,
    "judul": "Kisah Baru",
    "surah": 2,
    # ... other fields
}

# CORRECT
new_story = {
    "id": 130,
    "judul": "Kisah Baru",
    "surah": 2,
    "ayat": "2:1-10",
    "deskripsi": "...",
    "cerita": "...",
    "pelajaran": "..."  # Don't forget this!
}
```

### Error: "Story dengan ID X sudah ada!"

**Cause**: The ID you used already exists in the JSON file.

**Solution**: Use a unique ID. Current highest ID is 129, so start with 130.

```python
new_story = {
    "id": 130,  # This should be unique
    # ...
}
```

### Error: FileNotFoundError

**Cause**: Running the script from wrong directory.

**Solution**: Make sure to run from the project root:

```bash
# Correct
cd /c/Users/Dell/AndroidStudioProjects/iqran
python add_new_story.py

# Wrong (don't run from lib/ or other subdirectories)
```

---

## Verify Your Addition

After adding a story, you can verify it was saved correctly:

```python
import json

with open('assets/data/tadabur_stories.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Find your story by ID
story = next((s for s in data['stories'] if s['id'] == 130), None)

if story:
    print(f"Story found!")
    print(f"Title: {story['judul']}")
    print(f"Doa: {story['doa']['terjemahan']}")
else:
    print("Story not found!")
```

---

## Extending the Doa Mapping

To add a predefined doa for additional Surahs, edit the `DUAS_BY_SURAH` dictionary in `add_story_with_doa.py`:

```python
DUAS_BY_SURAH = {
    # ... existing entries ...

    # Add your new surah here
    8: {  # Surah Al-Anfal
        "arab": "الْعَرَبِيَّة",
        "transliterasi": "transliteration-here",
        "terjemahan": "Indonesian translation here"
    },
}
```

**Steps to add**:
1. Open `add_story_with_doa.py`
2. Find the `DUAS_BY_SURAH` dictionary
3. Add a new entry with Surah number as key
4. Include all three sub-fields: `arab`, `transliterasi`, `terjemahan`
5. Save the file
6. New stories using that Surah will automatically get the new doa

---

## How It Works

```
User calls add_new_story(story_data)
                    ↓
         Validate required fields
                    ↓
         Get Surah number from story_data
                    ↓
         Call get_doa_for_surah(surah_number)
                    ↓
         Does Surah have mapping?
           ├─ YES → Return predefined doa
           └─ NO  → Return DEFAULT_DOA
                    ↓
         Add doa field to story_data
                    ↓
         Load tadabur_stories.json
                    ↓
         Check if ID already exists
                    ↓
         Append new story to data['stories']
                    ↓
         Save updated JSON file
                    ↓
         Return story_data with doa field
```

---

## Best Practices

1. **Use meaningful Surah numbers**: Choose the Surah that best relates to your story's theme.

2. **Write complete stories**: Include 2-5 paragraphs in the `cerita` field for better engagement.

3. **Clear lessons**: Make sure the `pelajaran` field clearly states what readers should learn.

4. **Check for duplicates**: Before adding, verify your story isn't already in the collection by searching in `assets/data/tadabur_stories.json`.

5. **Test first**: Use a separate test script before adding to production.

6. **Use consistent formatting**: Follow the style of existing stories.

---

## Complete Example

```python
from add_story_with_doa import add_new_story

# Define your new story
new_story = {
    "id": 130,
    "judul": "Kisah Ibrahim dan Ismail",
    "surah": 37,
    "ayat": "37:102-107",
    "deskripsi": "Cerita tentang ketaatan dan kebersamaan dalam menghadapi ujian",
    "cerita": "Nabi Ibrahim adalah seorang yang sangat setia kepada Allah. Ketika Allah memberikan ujian besar dengan memerintahkannya untuk mengorbankan putranya Ismail, Ibrahim tidak ragu. Baik Ibrahim maupun Ismail menunjukkan ketaatan luar biasa kepada Allah. Ketika Ismail beranjak dewasa dan memahami perintah Allah, dia bersiap untuk dikorbankan dengan lapang dada. 'Ya ayahku, lakukan apa yang diperintahkan. Engkau akan mendapatiku dalam kondisi sabar insya Allah,' kata Ismail dengan penuh iman.\n\nMomen ini menunjukkan bagaimana iman sejati bukan hanya soal perkataan, tetapi tentang tindakan nyata. Allah memberikan penghargaan atas ketaatan mereka dengan mengganti Ismail dengan seekor domba untuk dikorbankan. Cerita ini menjadi bukti bahwa ketika kita menyerahkan diri sepenuhnya kepada Allah, Allah akan memberikan jalan keluar yang terbaik.",
    "pelajaran": "Ketaatan sejati kepada Allah memerlukan kesiapan mengorbankan apa yang paling berharga bagi kita. Namun, ketika kita bertawakal dan taat, Allah tidak akan membiarkan kita dalam kesusahan. Iman bukan hanya kepercayaan, tetapi tindakan konkret yang menunjukkan komitmen kita kepada perintah-Nya."
}

try:
    result = add_new_story(new_story)
    print(f"Sukses menambahkan cerita: {result['judul']}")
    print(f"Doa otomatis: {result['doa']['terjemahan']}")
except ValueError as e:
    print(f"Gagal: {e}")
```

When you run this, the system will:
1. Validate all required fields ✓
2. Get Surah 37 (As-Saf) - which uses DEFAULT_DOA since it's not in mapping
3. Add doa field automatically ✓
4. Save to JSON ✓
5. Confirm success ✓

---

## Summary

- ✓ Automated doa assignment based on Surah number
- ✓ Predefined duas for 26 important Surahs
- ✓ Universal default doa for other Surahs
- ✓ Simple import-based API for easy integration
- ✓ Full validation and error handling
- ✓ Zero manual doa mapping required

The system ensures that whenever a new story is added, it automatically receives the appropriate doa without any manual configuration!
