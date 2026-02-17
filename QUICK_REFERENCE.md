# Quick Reference: Adding Tadabur Stories with Auto Doa

## 30-Second Setup

```python
from add_story_with_doa import add_new_story

new_story = {
    "id": 130,
    "judul": "Your Story Title",
    "surah": 18,  # Quranic Surah number
    "ayat": "18:10-11",
    "deskripsi": "One line description",
    "cerita": "Full story narrative...",
    "pelajaran": "Key lesson from the story"
}

result = add_new_story(new_story)
```

**That's it!** The doa is automatically assigned based on the Surah number.

---

## Key Points

| Aspect | Details |
|--------|---------|
| **Location** | `/assets/data/tadabur_stories.json` |
| **Current Stories** | 129 (IDs 1-129) |
| **Next ID to Use** | 130 |
| **Doa Assignment** | Automatic (no manual entry needed) |
| **How Doa is Chosen** | Based on Surah number in the story |

---

## Required Fields Checklist

- [ ] `id` - Unique number (use 130, 131, etc.)
- [ ] `judul` - Story title in Indonesian
- [ ] `surah` - Quranic Surah number (1-114)
- [ ] `ayat` - Verse reference like "18:10-11"
- [ ] `deskripsi` - 1-2 sentence description
- [ ] `cerita` - Full narrative (2-5 paragraphs)
- [ ] `pelajaran` - Key lesson to learn

---

## Example: Complete Story

```python
new_story = {
    "id": 130,
    "judul": "Kisah Zainab yang Sabar",
    "surah": 66,
    "ayat": "66:11",
    "deskripsi": "Wanita beriman yang tegar dalam menghadapi tekanan keluarga",
    "cerita": "Ada seorang wanita yang hidup dalam keluarga yang tidak mendukung imannya. Namun dia tetap konsisten dalam menjalankan keimanannya dengan tulus dan ikhlas. Setiap hari dia membaca Quran, berdoa dengan khusyuk, dan menunjukkan akhlak yang baik kepada semua orang di sekitarnya.\n\nMeskipun menghadapi penolakan, dia tidak pernah marah atau merasa kesal. Sebaliknya, dia terus menunjukkan kebaikan dan kebijaksanaan. Perlahan-lahan, keluarganya mulai melihat cahaya dalam hidupnya dan tertarik untuk mengenal Allah lebih dekat. Imannya yang tulus menjadi contoh bagi orang lain.",
    "pelajaran": "Keberanian untuk berdiri sendiri demi kebenaran adalah bentuk iman yang sejati. Perbuatan baik dan akhlak yang luhur adalah bahasa universal yang dapat mempengaruhi hati orang lain lebih dari seribu kata."
}

result = add_new_story(new_story)
print(f"Cerita '{result['judul']}' berhasil ditambahkan!")
print(f"Doa: {result['doa']['terjemahan']}")
```

---

## How to Run

**Option 1: Python Script**
```bash
cd /c/Users/Dell/AndroidStudioProjects/iqran
python add_new_story.py
```

**Option 2: Direct Command**
```bash
python3 << 'EOF'
from add_story_with_doa import add_new_story
# ... your story code ...
EOF
```

---

## Verify It Worked

```python
import json

with open('assets/data/tadabur_stories.json', 'r', encoding='utf-8') as f:
    data = json.load(f)
    story = next((s for s in data['stories'] if s['id'] == 130), None)

if story:
    print(f"Story saved! Doa: {story['doa']['terjemahan']}")
else:
    print("Story not found")
```

---

## Common Issues

| Problem | Solution |
|---------|----------|
| ID already exists | Use a higher ID (current max: 129) |
| Missing field error | Check all 7 required fields are present |
| File not found | Run from project root directory |
| Encoding error | Use `ensure_ascii=False` in json.dump() |

---

## Supported Surahs with Predefined Duas

Surahs 1, 2, 3, 4, 5, 6, 7, 9, 10, 12, 16, 18, 20, 21, 25, 26, 31, 33, 36, 39, 40, 41, 45, 51, 55, 65, 67, 71, 78

Other Surahs get the universal DEFAULT_DOA automatically.

---

## Need Help?

See `AUTOMATED_DOA_GUIDE.md` for:
- Complete examples
- Error troubleshooting
- Extending the mapping
- Best practices

---

## File Locations

| File | Purpose |
|------|---------|
| `add_story_with_doa.py` | Main automation script |
| `AUTOMATED_DOA_GUIDE.md` | Comprehensive documentation |
| `QUICK_REFERENCE.md` | This file |
| `assets/data/tadabur_stories.json` | Story database |
