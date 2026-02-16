import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _keyLocale = 'app_locale';
  static const String _keyLanguageSelected = 'language_selected';

  /// Load saved locale from SharedPreferences
  /// Returns Indonesian locale if not set
  static Future<Locale> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_keyLocale);

      if (languageCode != null) {
        return Locale(languageCode);
      }

      // Default to Indonesian
      return const Locale('id');
    } catch (e) {
      return const Locale('id');
    }
  }

  /// Save locale preference to SharedPreferences
  static Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLocale, locale.languageCode);
    } catch (e) {
      // Silently fail
    }
  }

  /// Check if user has selected a language on first launch
  static Future<bool> isLanguageSelected() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyLanguageSelected) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark language as selected
  static Future<void> markLanguageSelected() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyLanguageSelected, true);
    } catch (e) {
      // Silently fail
    }
  }

  /// Get supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];
}
