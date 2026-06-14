import 'dart:io';
import 'package:dio/dio.dart';
import '../models/backup_model.dart';
import '../models/backup_preview_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class BackupRepository {
  final ApiClient _apiClient;

  BackupRepository(this._apiClient);

  /// Get list of user cloud backups
  Future<ApiResult<List<BackupModel>>> getBackups() async {
    try {
      final response = await _apiClient.get(ApiConstants.backupsList);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final backups = rawList.map((e) => BackupModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(backups);
      }
      return const ApiError('هەڵەیەک لە داڕشتەی پاڵپشتییەکاندا هەیە');
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Create cloud backup
  Future<ApiResult<String>> createBackup({
    String? password,
    String? deviceType,
    String? platform,
    String? appVersion,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.backupsCreate,
        data: {
          if (password != null) 'password': password,
          if (deviceType != null) 'device_type': deviceType,
          if (platform != null) 'platform': platform,
          if (appVersion != null) 'app_version': appVersion,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return ApiSuccess(responseData['message'] as String? ?? 'کارەکە خرایە ڕیزەوە');
      }
      return const ApiError('هەڵەیەک ڕوویدا لە دروستکردنی کۆپی پاڵپشتی');
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Delete a cloud backup
  Future<ApiResult<String>> deleteBackup(int id) async {
    try {
      final response = await _apiClient.delete(ApiConstants.backupsDelete(id));
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return ApiSuccess(responseData['message'] as String? ?? 'کارەکە بە سەرکەوتوویی جێبەجێ کرا');
      }
      return const ApiError('کێشەیەک لە سڕینەوەی پاڵپشتیدا هەیە');
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Download cloud backup ZIP file bytes
  Future<ApiResult<List<int>>> downloadBackup(int id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.backupsDownload(id),
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data is List<int>) {
        return ApiSuccess(response.data as List<int>);
      }
      return const ApiError('فایلەکە دانەگیرا');
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Upload local backup file
  Future<ApiResult<String>> uploadBackup({
    required File backupFile,
    required bool isEncrypted,
    String? deviceType,
    String? platform,
    String? appVersion,
  }) async {
    try {
      final formData = FormData.fromMap({
        'backup_file': await MultipartFile.fromFile(backupFile.path, filename: 'backup.zip'),
        'is_encrypted': isEncrypted ? '1' : '0',
        if (deviceType != null) 'device_type': deviceType,
        if (platform != null) 'platform': platform,
        if (appVersion != null) 'app_version': appVersion,
      });

      final response = await _apiClient.post(
        ApiConstants.backupsUpload,
        data: formData,
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return ApiSuccess(responseData['message'] as String? ?? 'کردارەکە خرایە ڕیزەوە');
      }
      return const ApiError('شکست هێنا لە بەرزکردنەوەی فایلی پاڵپشتی');
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Dry-run restore preview
  Future<ApiResult<BackupPreviewModel>> getRestorePreview({
    int? backupId,
    File? localFile,
    String? password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        if (backupId != null) 'backup_id': backupId,
        if (password != null) 'password': password,
      };

      if (localFile != null) {
        data['backup_file'] = await MultipartFile.fromFile(localFile.path, filename: 'restore.zip');
      }

      final response = await _apiClient.post(
        ApiConstants.backupsRestorePreview,
        data: FormData.fromMap(data),
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final preview = BackupPreviewModel.fromJson(responseData['data'] as Map<String, dynamic>);
        return ApiSuccess(preview);
      }
      return const ApiError('شکست هێنا لە پێشبینیکردنی گەڕاندنەوە');
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Apply restore
  Future<ApiResult<String>> restoreBackup({
    int? backupId,
    File? localFile,
    required String conflictResolution,
    required List<String> modules,
    String? password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        if (backupId != null) 'backup_id': backupId,
        'conflict_resolution': conflictResolution,
        if (password != null) 'password': password,
      };

      for (int i = 0; i < modules.length; i++) {
        data['modules[$i]'] = modules[i];
      }

      if (localFile != null) {
        data['backup_file'] = await MultipartFile.fromFile(localFile.path, filename: 'restore.zip');
      }

      final response = await _apiClient.post(
        ApiConstants.backupsRestore,
        data: FormData.fromMap(data),
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return ApiSuccess(responseData['message'] as String? ?? 'کردارەکە دەستیپێکرد لە پاشبنەمادا');
      }
      return const ApiError('هەڵەیەک لە گەڕاندنەوەی پاڵپشتیدا هەیە');
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
