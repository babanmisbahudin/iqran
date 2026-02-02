import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/doa.dart';

class DoaService {
  static const String _baseUrl = 'https://doa-doa-api-ahmadramadhan.fly.dev';

  // Cache untuk mengurangi API calls
  static List<Doa>? _doaCache;
  static DateTime? _cacheTime;

  // ========================
  // FETCH ALL DUAS
  // ========================
  static Future<List<Doa>> fetchAllDoas({bool forceRefresh = false}) async {
    try {
      // Check cache
      if (!forceRefresh &&
          _doaCache != null &&
          _cacheTime != null &&
          DateTime.now().difference(_cacheTime!).inMinutes < 60) {
        return _doaCache!;
      }

      final response = await http.get(Uri.parse('$_baseUrl/api'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> doaList = [];
        if (data is List) {
          doaList = data;
        } else if (data is Map && data.containsKey('data')) {
          doaList = data['data'];
        } else if (data is Map) {
          doaList = data.values.toList();
        }

        _doaCache = doaList
            .map((item) {
              try {
                return Doa.fromJson(item);
              } catch (e) {
                return null;
              }
            })
            .whereType<Doa>()
            .toList();

        _cacheTime = DateTime.now();
        return _doaCache!;
      } else {
        throw Exception('Failed to fetch duas: ${response.statusCode}');
      }
    } catch (e) {
      // Return cache even if expired on error
      if (_doaCache != null) {
        return _doaCache!;
      }
      throw Exception('Error fetching duas: $e');
    }
  }

  // ========================
  // FETCH DUA BY ID
  // ========================
  static Future<Doa?> fetchDoaById(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Doa.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching doa by id: $e');
    }
  }

  // ========================
  // FETCH DUA BY NAME
  // ========================
  static Future<List<Doa>> fetchDoaByName(String name) async {
    try {
      // Fetch all duas first
      final allDoas = await fetchAllDoas();

      // Filter by name
      final nameLower = name.toLowerCase();
      return allDoas
          .where((doa) => doa.title.toLowerCase().contains(nameLower))
          .toList();
    } catch (e) {
      throw Exception('Error fetching doa by name: $e');
    }
  }

  // ========================
  // GET RANDOM DUA
  // ========================
  static Future<Doa?> getRandomDoa() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/api/doa/v1/random'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Doa.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting random doa: $e');
    }
  }

  // ========================
  // SEARCH DUAS
  // ========================
  static Future<List<Doa>> searchDoas(String query) async {
    try {
      final allDoas = await fetchAllDoas();

      if (query.isEmpty) {
        return allDoas;
      }

      final queryLower = query.toLowerCase();
      return allDoas
          .where((doa) =>
              doa.title.toLowerCase().contains(queryLower) ||
              doa.translation.toLowerCase().contains(queryLower))
          .toList();
    } catch (e) {
      throw Exception('Error searching duas: $e');
    }
  }

  // ========================
  // CLEAR CACHE
  // ========================
  static void clearCache() {
    _doaCache = null;
    _cacheTime = null;
  }
}
