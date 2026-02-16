import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/tadabur_story.dart';

/// Tadabur Service - Manage Quran Stories
class TadabourService {
  static bool _initialized = false;
  static List<TadabourStory> _stories = [];

  /// Initialize tadabur stories from JSON asset
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/tadabur_stories.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final storiesList = jsonData['stories'] as List<dynamic>;

      _stories = storiesList
          .map((story) => TadabourStory.fromMap(story as Map<String, dynamic>))
          .toList();

      _initialized = true;
    } catch (e) {
      // Data will be empty until JSON file is provided
      _stories = [];
      _initialized = false;
    }
  }

  /// Get all stories
  static Future<List<TadabourStory>> getAllStories() async {
    await initialize();
    return _stories;
  }

  /// Get stories by surah
  static Future<List<TadabourStory>> getStoriesBySurah(int surah) async {
    await initialize();
    return _stories.where((story) => story.surah == surah).toList();
  }

  /// Get single story by ID
  static Future<TadabourStory?> getStoryById(int id) async {
    await initialize();
    try {
      return _stories.firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search stories by title
  static Future<List<TadabourStory>> searchStories(String query) async {
    await initialize();
    final q = query.toLowerCase();
    return _stories
        .where((story) =>
            story.judul.toLowerCase().contains(q) ||
            story.deskripsi.toLowerCase().contains(q))
        .toList();
  }

  /// Get random story
  static Future<TadabourStory?> getRandomStory() async {
    await initialize();
    if (_stories.isEmpty) return null;
    _stories.shuffle();
    return _stories.first;
  }

  /// Check if initialized
  static bool get isInitialized => _initialized;

  /// Get story count
  static Future<int> getStoryCount() async {
    await initialize();
    return _stories.length;
  }
}
