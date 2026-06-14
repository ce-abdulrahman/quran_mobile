import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:crypto/crypto.dart';

import '../models/backup_model.dart';
import '../models/backup_preview_model.dart';
import '../repositories/backup_repository.dart';
import 'app_providers.dart';

class BackupState {
  final bool isLoading;
  final bool isRestoring;
  final List<BackupModel> backups;
  final String? errorMessage;
  final String? successMessage;
  final BackupPreviewModel? previewReport;
  final String autoBackupInterval;

  BackupState({
    this.isLoading = false,
    this.isRestoring = false,
    this.backups = const [],
    this.errorMessage,
    this.successMessage,
    this.previewReport,
    this.autoBackupInterval = 'disabled',
  });

  BackupState copyWith({
    bool? isLoading,
    bool? isRestoring,
    List<BackupModel>? backups,
    String? errorMessage,
    String? successMessage,
    BackupPreviewModel? previewReport,
    String? autoBackupInterval,
  }) {
    return BackupState(
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      backups: backups ?? this.backups,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      previewReport: previewReport ?? this.previewReport,
      autoBackupInterval: autoBackupInterval ?? this.autoBackupInterval,
    );
  }
}

class BackupNotifier extends StateNotifier<BackupState> {
  final BackupRepository _repository;
  final SharedPreferences _prefs;
  final Ref _ref;

  static const _autoIntervalKey = 'backup_auto_interval';

  BackupNotifier(this._repository, this._prefs, this._ref)
      : super(BackupState()) {
    _init();
  }

  void _init() {
    final interval = _prefs.getString(_autoIntervalKey) ?? 'disabled';
    state = state.copyWith(autoBackupInterval: interval);
    fetchCloudBackups();
  }

  /// Fetch user backups list from cloud
  Future<void> fetchCloudBackups() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    final result = await _repository.getBackups();
    result.when(
      success: (data) {
        state = state.copyWith(backups: data, isLoading: false);
      },
      error: (message, code, cached) {
        state = state.copyWith(errorMessage: message, isLoading: false);
      },
    );
  }

  /// Create a cloud backup
  Future<void> createCloudBackup({String? password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    final result = await _repository.createBackup(
      password: password,
      deviceType: 'Mobile App',
      platform: Platform.isAndroid ? 'Android' : 'iOS',
      appVersion: '1.0.0',
    );
    result.when(
      success: (message) {
        state = state.copyWith(successMessage: message);
        fetchCloudBackups();
      },
      error: (message, code, cached) {
        state = state.copyWith(errorMessage: message, isLoading: false);
      },
    );
  }

  /// Delete a cloud backup
  Future<void> deleteCloudBackup(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    final result = await _repository.deleteBackup(id);
    result.when(
      success: (message) {
        state = state.copyWith(successMessage: message);
        fetchCloudBackups();
      },
      error: (message, code, cached) {
        state = state.copyWith(errorMessage: message, isLoading: false);
      },
    );
  }

  /// Request Restoration Preview report from server
  Future<void> generateRestorePreview({int? backupId, File? localFile, String? password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null, previewReport: null);
    final result = await _repository.getRestorePreview(
      backupId: backupId,
      localFile: localFile,
      password: password,
    );
    result.when(
      success: (preview) {
        state = state.copyWith(previewReport: preview, isLoading: false);
      },
      error: (message, code, cached) {
        state = state.copyWith(errorMessage: message, isLoading: false);
      },
    );
  }

  /// Execute Restoration
  Future<bool> executeRestore({
    int? backupId,
    File? localFile,
    required String conflictResolution,
    required List<String> modules,
    String? password,
  }) async {
    state = state.copyWith(isRestoring: true, errorMessage: null, successMessage: null);
    final result = await _repository.restoreBackup(
      backupId: backupId,
      localFile: localFile,
      conflictResolution: conflictResolution,
      modules: modules,
      password: password,
    );

    return result.when(
      success: (message) {
        state = state.copyWith(successMessage: message, isRestoring: false, previewReport: null);
        // Refresh tasbihs / reminders locally
        _ref.invalidate(appSettingsProvider);
        return true;
      },
      error: (message, code, cached) {
        state = state.copyWith(errorMessage: message, isRestoring: false);
        return false;
      },
    );
  }

  /// Configure auto-backup interval
  Future<void> setAutoBackupInterval(String interval) async {
    await _prefs.setString(_autoIntervalKey, interval);
    state = state.copyWith(autoBackupInterval: interval);
  }

  /// Export local settings to file & share
  Future<void> exportLocalBackup(String? password) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

    try {
      final Map<String, dynamic> localData = {};
      final keys = [
        'tasbih_custom_list',
        'tasbih_session_counts',
        'tasbih_current_streak',
        'tasbih_longest_streak',
        'tasbih_last_activity_date',
        'tasbih_daily_goal_value',
        'tasbih_daily_progress',
        'tasbih_daily_completed',
        'tasbih_daily_goal_date',
        'app_font_size',
        'app_theme_mode',
        'app_language',
      ];

      for (final key in keys) {
        if (_prefs.containsKey(key)) {
          final val = _prefs.get(key);
          localData[key] = val;
        }
      }

      final payload = {
        'backup_version': '1.0',
        'app_version': '1.0.0',
        'created_at': DateTime.now().toIso8601String(),
        'device_type': 'Mobile App',
        'platform': Platform.isAndroid ? 'Android' : 'iOS',
        'local_preferences': localData,
      };

      String jsonString = jsonEncode(payload);

      // Encrypt if password is provided
      if (password != null && password.isNotEmpty) {
        jsonString = _encryptLocalData(jsonString, password);
      }

      final tempDir = await getTemporaryDirectory();
      final String suffix = password != null ? '_encrypted' : '';
      final String formattedDate = DateTime.now().toIso8601String().replaceAll(':', '-').substring(0, 19);
      final file = File('${tempDir.path}/quran_backup${suffix}_$formattedDate.json');
      await file.writeAsString(jsonString);

      // Share file
      await Share.shareXFiles([XFile(file.path)], text: 'Quran App Local Backup');

      state = state.copyWith(isLoading: false, successMessage: 'پاڵپشتی ناوخۆیی بە سەرکەوتوویی هەناردە کرا');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'کێشەیەک لە هەناردەکردنی پاڵپشتی هەیە: $e');
    }
  }

  /// Import local settings from file
  Future<bool> importLocalBackup(File file, {String? password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

    try {
      String content = await file.readAsString();

      // Decrypt if password provided
      if (password != null && password.isNotEmpty) {
        final decrypted = _decryptLocalData(content, password);
        if (decrypted == null) {
          state = state.copyWith(isLoading: false, errorMessage: 'تێپەڕەوشەی هەڵە یان فایلی تێکچوو');
          return false;
        }
        content = decrypted;
      }

      final payload = jsonDecode(content) as Map<String, dynamic>;
      final localPrefs = payload['local_preferences'] as Map<String, dynamic>?;

      if (localPrefs == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'فایلەکە زانیاری پێویستی تێدا نییە');
        return false;
      }

      // Apply to SharedPreferences
      for (final key in localPrefs.keys) {
        final val = localPrefs[key];
        if (val is String) {
          await _prefs.setString(key, val);
        } else if (val is int) {
          await _prefs.setInt(key, val);
        } else if (val is bool) {
          await _prefs.setBool(key, val);
        } else if (val is double) {
          await _prefs.setDouble(key, val);
        } else if (val is List) {
          await _prefs.setStringList(key, val.map((e) => e.toString()).toList());
        }
      }

      state = state.copyWith(isLoading: false, successMessage: 'داتاکان بە سەرکەوتوویی هێنرانە ناوەوە');
      _ref.invalidate(appSettingsProvider);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'کێشە لە هێنانە ناوەوەی پاڵپشتی: $e');
      return false;
    }
  }

  String _encryptLocalData(String plainText, String password) {
    final key = enc.Key(Uint8List.fromList(sha256.convert(utf8.encode(password)).bytes));
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String? _decryptLocalData(String cipherText, String password) {
    try {
      final key = enc.Key(Uint8List.fromList(sha256.convert(utf8.encode(password)).bytes));
      final iv = enc.IV.fromLength(16);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final decrypted = encrypter.decrypt64(cipherText, iv: iv);
      return decrypted;
    } catch (e) {
      return null;
    }
  }
}

final backupStateProvider = StateNotifierProvider<BackupNotifier, BackupState>((ref) {
  final repository = ref.watch(backupRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return BackupNotifier(repository, prefs, ref);
});
