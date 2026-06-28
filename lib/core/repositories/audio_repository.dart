import '../models/reciter_model.dart';
import '../network/api_client.dart';
import '../network/api_result.dart';

class AudioRepository {
  final ApiClient _apiClient;

  AudioRepository(this._apiClient);

  /// Fetch all reciters
  Future<ApiResult<List<ReciterModel>>> getReciters() async {
    try {
      final response = await _apiClient.get('/reciters');
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final reciters = rawList.map((e) => ReciterModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(reciters);
      } else {
        return const ApiError('شکست لە هێنانی ناوی قورئان خوێنەکان');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch audio stream URL and timings for a specific surah and reciter
  Future<ApiResult<SurahAudioResponse>> getSurahAudio(int surahId, int reciterId, {String? quality}) async {
    try {
      final queryParams = <String, dynamic>{'reciter_id': reciterId};
      if (quality != null && quality != 'offline_only') {
        queryParams['quality'] = quality;
      }
      final response = await _apiClient.get(
        '/surahs/$surahId/audio',
        queryParameters: queryParams,
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final parsed = SurahAudioResponse.fromJson(data);
        return ApiSuccess(parsed);
      } else {
        return const ApiError('فایلی دەنگی یان کاتەکان نەدۆزرانەوە');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
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
