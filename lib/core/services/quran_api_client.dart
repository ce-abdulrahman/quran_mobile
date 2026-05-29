import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranApiClient {
  final Dio _dio;
  final SharedPreferences? _prefs;

  QuranApiClient({Dio? dio, SharedPreferences? prefs})
      : _prefs = prefs,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'http://127.0.0.1:8000/api/',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _prefs?.getString('auth_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  /// Fetch all Surahs from Laravel v1 API (with revelation type).
  Future<List<Map<String, dynamic>>> fetchSurahs() async {
    try {
      final response = await _dio.get('v1/surahs');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          final List<dynamic> list = data['data'];
          return list.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
      throw Exception('Failed to load Surahs from API');
    } catch (e) {
      throw Exception('Failed to connect to Quran API: $e');
    }
  }

  /// Fetch all Ayahs for a Surah from Laravel main API.
  Future<List<Map<String, dynamic>>> fetchAyahs(int surahId) async {
    try {
      final response = await _dio.get('surahs/$surahId/ayahs');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          final List<dynamic> list = data['data']['ayahs'];
          return list.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
      throw Exception('Failed to load Ayahs for Surah $surahId');
    } catch (e) {
      throw Exception('Failed to connect to Quran API: $e');
    }
  }

  /// POST /api/v1/auth/login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('v1/auth/login', data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception(response.data['message'] ?? 'Login failed');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// POST /api/v1/auth/register
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('v1/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception(response.data['message'] ?? 'Registration failed');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// GET /api/v1/leaderboard?period=daily|weekly|monthly|alltime
  Future<List<Map<String, dynamic>>> fetchLeaderboard(String period) async {
    try {
      final response = await _dio.get('v1/leaderboard', queryParameters: {'period': period});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          final List<dynamic> list = data['data'];
          return list.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
      throw Exception('Failed to load leaderboard');
    } catch (e) {
      throw Exception('Failed to fetch leaderboard: $e');
    }
  }

  /// GET /api/v1/me/stats
  Future<Map<String, dynamic>> fetchMyStats() async {
    try {
      final response = await _dio.get('v1/me/stats');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception('Failed to load my stats');
    } catch (e) {
      throw Exception('Failed to fetch my stats: $e');
    }
  }

  /// POST /api/v1/last-read
  Future<Map<String, dynamic>> saveLastRead(int ayahId, int? secondsSpent) async {
    try {
      final response = await _dio.post('v1/last-read', data: {
        'ayah_id': ayahId,
        'seconds_spent': secondsSpent ?? 0,
      });
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception('Failed to save reading progress');
    } catch (e) {
      throw Exception('Failed to save last read: $e');
    }
  }

  /// GET /api/v1/reading-streaks
  Future<Map<String, dynamic>> fetchReadingStreaks() async {
    try {
      final response = await _dio.get('v1/reading-streaks');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception('Failed to load reading streaks');
    } catch (e) {
      throw Exception('Failed to fetch reading streaks: $e');
    }
  }

  /// GET /api/v1/last-read
  Future<Map<String, dynamic>?> fetchLastRead() async {
    try {
      final response = await _dio.get('v1/last-read');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          return data['data'] != null ? Map<String, dynamic>.from(data['data']) : null;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch last read: $e');
    }
  }
}
