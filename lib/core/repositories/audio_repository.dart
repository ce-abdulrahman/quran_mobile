import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import '../models/reciter_model.dart';
import '../network/api_client.dart';
import '../network/api_result.dart';

class AudioRepository {
  final ApiClient _apiClient;
  final Isar _isar = IsarService.instance.isar;

  AudioRepository(this._apiClient);

  /// Fetch all reciters. Reads exclusively from local Isar.
  Future<ApiResult<List<ReciterModel>>> getReciters() async {
    try {
      final collections = await _isar.reciterCollections.where().sortByReciterId().findAll();
      
      if (collections.isEmpty) {
        return const ApiError('لیستی قورئانخوێنەکان هێشتا بارنەکراوە. تکایە پەیجی سپڵاش بکەرەوە.');
      }

      final list = collections.map((c) => ReciterModel(
        id: c.reciterId,
        name: c.nameKu,
        riwayah: c.type == 'kurdish' ? 'تەفسیری کوردی' : 'ڕیوایەتی حەفس',
        language: c.type == 'kurdish' ? 'ku' : 'ar',
        image: c.imageAsset,
      )).toList();

      return ApiSuccess(list);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch audio stream URL and timings. Fallback to local offline directory.
  Future<ApiResult<SurahAudioResponse>> getSurahAudio(int surahId, int reciterId, {String? quality}) async {
    // 1. Try remote network first if not restricted
    if (quality != 'offline_only') {
      try {
        final queryParams = <String, dynamic>{'reciter_id': reciterId};
        if (quality != null) {
          queryParams['quality'] = quality;
        }
        final response = await _apiClient.get(
          '/surahs/$surahId/audio',
          queryParameters: queryParams,
        ).timeout(const Duration(seconds: 3));

        final responseData = response.data;
        if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
          final data = responseData['data'] as Map<String, dynamic>;
          final parsed = SurahAudioResponse.fromJson(data);
          
          // Asynchronously cache this timing data locally
          _cacheTimingLocally(surahId, reciterId, data);
          
          return ApiSuccess(parsed);
        }
      } catch (_) {
        // Fall through to local cache/file retrieval
      }
    }

    // 2. Try loading local downloaded timing file
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final localFile = File('${docsDir.path}/audio_metadata/reciter_$reciterId/surah_$surahId.json');
      
      if (await localFile.exists()) {
        final content = await localFile.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;
        final parsed = SurahAudioResponse.fromJson(data);
        return ApiSuccess(parsed);
      }
    } catch (_) {
      // Fall through
    }

    return const ApiError('فایلی دەنگی و کاتی ئایەتەکان بەردەست نییە بە شێوازی ئۆفلاین');
  }

  Future<void> _cacheTimingLocally(int surahId, int reciterId, Map<String, dynamic> data) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${docsDir.path}/audio_metadata/reciter_$reciterId');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final file = File('${dir.path}/surah_$surahId.json');
      await file.writeAsString(jsonEncode(data));
    } catch (_) {
      // Ignore caching failures
    }
  }
}

class SurahAudioResponse {
  final String streamUrl;
  final Map<int, AyahTimingModel> timings;

  SurahAudioResponse({
    required this.streamUrl,
    required this.timings,
  });

  factory SurahAudioResponse.fromJson(Map<String, dynamic> json) {
    final audioFile = json['audio_file'] as Map<String, dynamic>? ?? {};
    final streamUrl = audioFile['stream_url'] as String? ?? '';
    
    final rawTimings = json['ayah_timings'] as Map<String, dynamic>? ?? {};
    final Map<int, AyahTimingModel> timings = {};
    rawTimings.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        final timing = AyahTimingModel.fromJson(value);
        timings[timing.ayahNumber] = timing;
      }
    });

    return SurahAudioResponse(
      streamUrl: streamUrl,
      timings: timings,
    );
  }
}

class AyahTimingModel {
  final int ayahNumber;
  final double startTime;
  final double endTime;

  AyahTimingModel({
    required this.ayahNumber,
    required this.startTime,
    required this.endTime,
  });

  factory AyahTimingModel.fromJson(Map<String, dynamic> json) {
    return AyahTimingModel(
      ayahNumber: json['ayah_number'] as int? ?? 0,
      startTime: (json['start_time'] as num? ?? 0.0).toDouble(),
      endTime: (json['end_time'] as num? ?? 0.0).toDouble(),
    );
  }
}
