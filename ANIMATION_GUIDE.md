# Animation System Guide - iQran App

## 📱 Overview

iQran App sekarang memiliki sistem animasi komprehensif yang membuat UI lebih interaktif dan menarik. Semua animasi dioptimalkan untuk performa dan mengikuti Material Design principles.

---

## 🎬 Jenis-Jenis Animasi

### 1. **Feature Card Animation** (Home Page)
**File:** `lib/pages/home/widgets/feature_card.dart`

Setiap feature card memiliki:
- ✨ **Entrance Animation**: Slide up + Fade + Scale dengan stagger delay
- 👆 **Tap Feedback**: Scale 0.95 + Opacity 0.7
- 🎯 **Lottie Integration**: Animated icons dengan fallback

**Delays:**
- Al-Qur'an: 100ms
- Bookmark: 200ms
- Tutorial: 300ms
- Donasi: 400ms

---

### 2. **Page Transitions** (All Pages)
**File:** `lib/widgets/animated_page_route.dart`

4 jenis animasi transition yang dapat digunakan:

#### a. **slideFromRight** (Default - Home)
```dart
AnimatedPageRoute(
  page: MyPage(),
  animationType: AnimationType.slideFromRight,
)
```
- Slide dari kanan
- Fade in
- Secondary page scale down 0.7

#### b. **slideFromLeft**
```dart
AnimatedPageRoute(
  page: MyPage(),
  animationType: AnimationType.slideFromLeft,
)
```
- Slide dari kiri
- Fade in
- Untuk back navigation

#### c. **fadeAndScale**
```dart
AnimatedPageRoute(
  page: MyPage(),
  animationType: AnimationType.fadeAndScale,
)
```
- Fade + Scale 0.8 → 1.0
- Modal feel
- Untuk dialog/overlay pages

#### d. **slideAndFade**
```dart
AnimatedPageRoute(
  page: MyPage(),
  animationType: AnimationType.slideAndFade,
)
```
- Slide dari bawah
- Fade in
- Untuk bottom sheet feel

**Transition Duration:** 400ms
**Curve:** easeInOutCubic

---

### 3. **Card Wrapper Animation** (Reusable)
**File:** `lib/widgets/animated_card_wrapper.dart`

Wrapper untuk animasi card apapun:

```dart
AnimatedCardWrapper(
  entranceDelay: const Duration(milliseconds: 100),
  enteranceDuration: const Duration(milliseconds: 600),
  onTap: () => print('Tapped'),
  enableScaleOnTap: true,
  curve: Curves.easeOutCubic,
  child: Container(
    // Your card content
  ),
)
```

**Features:**
- Slide up entrance
- Fade in
- Scale from 0.85
- Customizable delay & duration
- Tap feedback (scale 0.95)

---

### 4. **List Item Animation** (Reusable)
**File:** `lib/widgets/animated_list_item.dart`

Untuk animasi list/grid items dengan stagger effect:

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => AnimatedListItem(
    index: index,
    delayMultiplier: const Duration(milliseconds: 50),
    enteranceDuration: const Duration(milliseconds: 500),
    onTap: () => print('Item $index tapped'),
    child: Container(
      // Your list item content
    ),
  ),
)
```

**Features:**
- Slide dari kiri
- Fade in
- Per-item stagger delay (50ms * index)
- Perfect untuk list & grid

---

## 🎨 Animasi yang Sudah Diimplementasi

### Home Page
✅ Feature cards dengan stagger entrance
✅ Page transition saat navigasi

### Built-in
✅ Feature card tap feedback
✅ Mini player animations (sudah ada sebelumnya)
✅ Navigation transitions

---

## 📋 Quick Implementation Guide

### Menambahkan Animasi ke Card Baru

**Sebelum:**
```dart
Container(
  decoration: BoxDecoration(...),
  child: Text('My Card'),
)
```

**Sesudah:**
```dart
AnimatedCardWrapper(
  entranceDelay: const Duration(milliseconds: 200),
  child: Container(
    decoration: BoxDecoration(...),
    child: Text('My Card'),
  ),
)
```

### Menambahkan Animasi ke Page Navigation

**Sebelum:**
```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => MyPage()))
```

**Sesudah:**
```dart
Navigator.push(context, AnimatedPageRoute(page: MyPage()))
```

### Menambahkan Animasi ke List Items

**Sebelum:**
```dart
ListView.builder(
  itemBuilder: (context, index) => MyListItem(),
)
```

**Sesudah:**
```dart
ListView.builder(
  itemBuilder: (context, index) => AnimatedListItem(
    index: index,
    child: MyListItem(),
  ),
)
```

---

## ⚙️ Customization

### Global Animation Settings

Untuk mengubah global animation properties, edit di masing-masing file:

**Feature Card:**
- `enteranceDuration`: Line 41
- `curve`: Line 49, 53
- `scaleAnimation begin`: Line 46

**List Item:**
- `delayMultiplier`: Default 50ms
- `enteranceDuration`: Default 500ms
- Slide direction: Line 47 (`Offset(-0.3, 0)`)

**Page Route:**
- `transitionDuration`: Line 30
- Curves di setiap method

---

## 🎯 Best Practices

### 1. **Jangan Overanimate**
```dart
// ❌ Bad - Terlalu banyak animasi sekaligus
AnimatedCardWrapper(
  enteranceDuration: const Duration(seconds: 2),
  child: AnimatedListItem(
    child: MyWidget(),
  ),
)

// ✅ Good - Gunakan satu animasi yang tepat
AnimatedCardWrapper(
  enteranceDuration: const Duration(milliseconds: 600),
  child: MyWidget(),
)
```

### 2. **Timing yang Konsisten**
```dart
// ✅ Good - Consistent timing
- Entrance: 600ms
- Tap: 100-150ms
- Page transition: 400ms
```

### 3. **Stagger untuk Multiple Items**
```dart
// ✅ Good - Stagger effect
AnimatedListItem(
  index: index, // Otomatis calculate delay
  delayMultiplier: const Duration(milliseconds: 50),
)
```

---

## 🔧 Performance Tips

1. **Dispose Properly** - Semua AnimationController sudah di-dispose
2. **Use const Widgets** - Kurangi rebuilds yang unnecessary
3. **Limit Animations** - Jangan animate terlalu banyak widget sekaligus
4. **Test on Device** - Performa bisa berbeda di device yang berbeda

---

## 📊 Animation Summary

| Animation | Duration | Curve | Use Case |
|-----------|----------|-------|----------|
| Feature Card | 600ms | easeOutCubic | Card entrance |
| Page Transition | 400ms | easeInOutCubic | Page navigation |
| List Item | 500ms | easeOutCubic | List/Grid items |
| Tap Feedback | 100-150ms | linear | Interactive feedback |

---

## 🚀 Future Enhancements

- [ ] Add animation to SurahListPage items
- [ ] Add animation to BookmarkPage items
- [ ] Add animation to SearchBar results
- [ ] Add haptic feedback dengan animations
- [ ] Add transition animation untuk mini player
- [ ] Customizable animation settings di preferences

---

## 📞 Troubleshooting

### Animasi tidak muncul?
1. Check `mounted` state
2. Verify `Future.delayed` timing
3. Check `dispose()` dipanggil

### Animasi terlalu lambat?
1. Kurangi `enteranceDuration`
2. Kurangi `delayMultiplier`
3. Ubah `curve` ke yang lebih cepat

### Performa drop?
1. Limit jumlah animated widgets
2. Gunakan `const` untuk widgets yang tidak berubah
3. Profile dengan Flutter DevTools

---

**Last Updated:** February 7, 2026
**Created by:** Claude Haiku 4.5
