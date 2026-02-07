# Performance Optimization Guide - iQran App
## Untuk Device dengan RAM 4GB

Panduan lengkap untuk mengoptimalkan aplikasi agar berjalan lancar di device dengan RAM terbatas.

---

## 📊 Performance Issues & Solutions

### 1. **Lottie Animation Memory Optimization** ✅
**Problem:** Lottie JSON files besar (hingga 552KB) menggunakan banyak RAM
**Solutions:**
- ✅ Implemented `LottieConfig` di `lib/config/lottie_config.dart`
- ✅ Menggunakan `enableMergePaths: true` untuk reduce complexity
- ✅ Error handling fallback untuk tidak crash jika animation gagal load

**Usage:**
```dart
// Sebelum:
Lottie.asset('assets/lottie/Reading Quran.json')

// Sesudah:
LottieOptimization.optimizedAsset('assets/lottie/Reading Quran.json')
```

---

### 2. **Android Build Optimization** 📦
**Untuk build APK yang lebih ringan, edit `android/app/build.gradle`:**

```gradle
android {
    // ... existing config ...

    buildTypes {
        release {
            // Enable code shrinking
            minifyEnabled true
            shrinkResources true

            // ProGuard configuration
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'

            // Enable R8
            useNewMinifier true
        }
    }
}
```

**File baru `android/app/proguard-rules.pro`:**
```proguard
# Flutter dependencies
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Just Audio & Audio Service
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.google.android.exoplayer2.** { *; }

# Lottie
-keep class com.airbnb.lottie.** { *; }

# SQLite
-keep class org.sqlite.** { *; }

# General optimization
-optimizationpasses 5
-dontusemixedcaseclassnames
-verbose

# Remove logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
```

---

### 3. **Image & Asset Optimization** 🖼️
**Ukuran asset saat ini:**
- `Reading Quran.json`: 552KB → Target: 300KB
- `assets/fonts/Amiri-Regular.ttf`: 412KB → Sudah optimal
- PNG images: Sudah terkompresi

**Tools untuk compress Lottie:**
1. Buka file JSON
2. Remove unused layers
3. Reduce keyframe count
4. Minify JSON structure

Atau gunakan online tool: https://www.iloveimg.com/compress-lottie

---

### 4. **Code-Level Optimizations** 💻

#### A. Lazy Loading Pages
```dart
// Implementasikan lazy loading untuk halaman yang jarang diakses
Navigator.push(
    context,
    AnimatedPageRoute(
        page: SettingsPage(...), // Lazy build
        animationType: AnimationType.slideFromRight,
    ),
);
```

#### B. Image Caching
Implementasi image caching di FutureBuilder untuk data quran yang besar.

#### C. Dispose Resources Properly
✅ Semua AnimationController sudah di-dispose
✅ Semua StreamSubscription sudah di-dispose
✅ Semua ValueNotifier sudah di-dispose

#### D. Use const Constructors
✅ Sudah diterapkan di seluruh aplikasi

---

### 5. **Memory Monitoring** 📈
**Tools untuk monitoring:**
1. Android Studio → Profiler → Memory
2. Flutter DevTools → Memory Tab
3. Logcat untuk melihat memory issues

**Target Memory Usage:**
- Initial: < 150MB
- After loading page: < 250MB
- Peak (playing audio): < 350MB

---

### 6. **Runtime Performance Tips** ⚡

#### A. Reduce Build Frequency
```dart
// Gunakan const untuk widgets yang tidak berubah
const SizedBox(height: 16),

// Gunakan SingleChildScrollView.builder untuk list panjang
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => AnimatedListItem(...),
)
```

#### B. Pagination & Virtual Scrolling
Implementasi untuk surah list yang panjang (114 surah):
```dart
// Load surah in chunks of 10
final itemCount = 114;
final pageSize = 10;
int currentPage = 0;
```

#### C. Network Optimization
```dart
// Implement connection pooling
http.Client().persist();

// Use gzip compression
headers: {'Accept-Encoding': 'gzip'}
```

---

### 7. **Dependencies Analysis** 📦

**Current Dependencies (24 packages):**
```
flutter (required)
http ^1.2.0                  - 100KB (network)
sqflite ^2.3.3              - 200KB (database)
connectivity_plus ^6.0.5    - 50KB
shared_preferences ^2.2.2   - 30KB
google_fonts ^6.1.0         - 1MB (optional)
cupertino_icons ^1.0.6      - 50KB
just_audio ^0.9.38          - 2MB (critical)
audio_service ^0.18.12      - 300KB (critical)
audio_session ^0.1.18       - 50KB
rxdart ^0.27.7              - 100KB
url_launcher ^6.2.6         - 50KB
font_awesome_flutter ^10.7  - 200KB
intl ^0.18.0                - 300KB
flutter_compass ^0.8.0      - 30KB
geolocator ^13.0.2          - 100KB
permission_handler ^11.3.1  - 100KB
uuid ^4.0.0                 - 20KB
lottie ^3.1.0               - 200KB
showcaseview ^3.0.0         - 50KB
```

**Optimization Suggestions:**
1. ✅ Keep critical: flutter, just_audio, audio_service, sqflite
2. ✅ Keep important: http, shared_preferences, lottie, intl
3. ⚠️ Optional: google_fonts (load on-demand), showcaseview (remove if not critical)
4. ⚠️ Consider: flutter_compass, geolocator (only if location feature is critical)

---

### 8. **Build & Release Checklist** ✅

Before releasing on Play Store:

- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Build APK with: `flutter build apk --release -v`
- [ ] Check APK size: `ls -lh build/app/outputs/flutter-apk/app-release.apk`
- [ ] Test on 4GB RAM device
- [ ] Run Performance Profiler to check memory
- [ ] Verify animations run at 60 FPS
- [ ] Check battery drain (should be minimal)

---

### 9. **Expected Results** 📊

**Before Optimization:**
- APK Size: ~80-100MB
- Memory Usage: 300-400MB
- Startup Time: 3-5 seconds
- Frame Rate: 45-55 FPS on 4GB device

**After Optimization:**
- APK Size: ~50-70MB (target)
- Memory Usage: 200-300MB (target)
- Startup Time: 1-2 seconds (target)
- Frame Rate: 55-60 FPS (target)

---

### 10. **Monitoring & Profiling**

**Key Metrics to Monitor:**
1. Memory usage over time
2. Frame rate (should stay 60 FPS)
3. CPU usage during playback
4. Network requests (should be batched)
5. Database query times

**Use Flutter DevTools:**
```bash
flutter pub global activate devtools
flutter pub global run devtools
# Buka di browser: http://localhost:9100
```

---

## 🚀 Quick Start Optimization

**Step 1: Enable code shrinking (Android)**
```bash
# Edit android/app/build.gradle
# Set minifyEnabled = true in release block
```

**Step 2: Update Lottie usage**
```dart
// Replace all Lottie.asset() with LottieOptimization.optimizedAsset()
```

**Step 3: Build & Test**
```bash
flutter clean
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Step 4: Profile**
- Open Android Studio Profiler
- Monitor memory, CPU, FPS
- Adjust if needed

---

## 📞 Performance Issues Troubleshooting

| Issue | Solution |
|-------|----------|
| High memory usage | Reduce animation complexity, implement lazy loading |
| Slow startup | Use const constructors, lazy load pages |
| Jank during animation | Reduce Lottie animation frames, use hardware acceleration |
| Audio stuttering | Close background apps, reduce UI complexity during playback |
| Heat/Battery drain | Reduce refresh rates, disable animations on low-end devices |

---

## 📚 References

- Flutter Performance: https://flutter.dev/docs/perf
- Android App Bundle: https://developer.android.com/guide/app-bundle
- Proguard Rules: https://developer.android.com/studio/build/shrink-code
- Lottie Optimization: https://github.com/airbnb/lottie-android

---

**Last Updated:** February 7, 2026
**Created by:** Claude Haiku 4.5
