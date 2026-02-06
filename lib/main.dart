import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/iqran_app.dart';
import 'services/onboarding_service.dart';
import 'services/background_audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize intl locale data for Indonesian (skip for web)
  if (!kIsWeb) {
    await initializeDateFormatting('id_ID', null);
  }
  Intl.defaultLocale = 'id_ID';

  // Initialize onboarding service
  await OnboardingService.initialize();

  // Initialize background audio service
  if (!kIsWeb) {
    try {
      await BackgroundAudioService.init();
    } catch (e) {
      debugPrint('⚠️ Failed to initialize background audio service: $e');
    }
  }

  runApp(const IqranApp());
}
