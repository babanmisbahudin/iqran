import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class DoaData {
  final String id;
  final String title;
  final String arab;
  final String transliterasi;
  final String terjemahan;
  final String surah;
  final String ayat;

  DoaData({
    required this.id,
    required this.title,
    required this.arab,
    required this.transliterasi,
    required this.terjemahan,
    required this.surah,
    required this.ayat,
  });

  factory DoaData.fromJson(Map<String, dynamic> json, String storyTitle, String surahInfo) {
    final doa = json['doa'] ?? {};
    return DoaData(
      id: json['id'].toString(),
      title: json['judul'] ?? '',
      arab: doa['arab'] ?? '',
      transliterasi: doa['transliterasi'] ?? '',
      terjemahan: doa['terjemahan'] ?? '',
      surah: surahInfo.split(':')[0],
      ayat: json['ayat'] ?? '',
    );
  }
}

Future<List<DoaData>> loadAllDoasFromTadabur() async {
  try {
    final jsonString = await rootBundle.loadString('assets/data/tadabur_stories.json');
    final jsonData = jsonDecode(jsonString);
    final stories = jsonData['stories'] as List;

    List<DoaData> duas = [];
    for (var story in stories) {
      if (story['doa'] != null && story['doa']['arab'] != null) {
        String surahInfo = 'Surah ${story['surah']}';
        duas.add(DoaData.fromJson(story, story['judul'] ?? '', surahInfo));
      }
    }

    return duas;
  } catch (e) {
    // Return empty list if error
    return [];
  }
}

Future<DoaData?> getRandomDoa() async {
  try {
    final duas = await loadAllDoasFromTadabur();
    if (duas.isEmpty) return null;

    final random = Random();
    return duas[random.nextInt(duas.length)];
  } catch (e) {
    return null;
  }
}

Future<DoaData?> getDoaByStoryId(int storyId) async {
  try {
    final duas = await loadAllDoasFromTadabur();
    return duas.firstWhere((doa) => doa.id == storyId.toString());
  } catch (e) {
    return null;
  }
}
