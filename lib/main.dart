import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'app/iqran_app.dart';
import 'pages/splash_screen.dart';
import 'pages/quran/surah_detail_page.dart';
import 'services/onboarding_service.dart';
import 'services/background_audio_service.dart';
import 'config/device_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize device configuration for performance optimization
  await DeviceConfig.initialize();

  // Initialize onboarding service
  await OnboardingService.initialize();

  // Initialize background audio service
  if (!kIsWeb) {
    try {
      await BackgroundAudioService.init();
      debugPrint('✅ BackgroundAudioService initialized');
    } catch (e) {
      debugPrint('⚠️ Failed to initialize background audio service: $e');
      debugPrint('ℹ️ Audio will work but without system notifications');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const IqranApp(),
        '/surah_detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return SurahDetailPage(
            nomor: args?['nomor'] ?? 1,
            nama: args?['nama'] ?? 'Surah',
            fontSize: 28,
          );
        },
      },
    );
  }
}
