import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:crypto/crypto.dart';

import 'app_providers.dart';

/// Backup encryption envelope format version. Bumped from the original
/// (unversioned) format, which used a fixed all-zero IV and an unsalted
/// SHA-256(password) key — both of which broke AES-CBC's security
/// guarantees for files that are explicitly shared off-device.
const int _backupCryptoVersion = 2;

class _Pbkdf2Params {
  final String password;
  final Uint8List salt;
  final int iterations;
  final int keyLength;
  _Pbkdf2Params(this.password, this.salt, this.iterations, this.keyLength);
}

/// PBKDF2-HMAC-SHA256 key derivation. Runs off the UI isolate via [compute]
/// since ~100k HMAC rounds would otherwise jank the UI thread.
Uint8List _pbkdf2Sync(_Pbkdf2Params p) {
  final hmac = Hmac(sha256, utf8.encode(p.password));
  const hashLen = 32;
  final numBlocks = (p.keyLength / hashLen).ceil();
  final derived = BytesBuilder();
  for (var blockIndex = 1; blockIndex <= numBlocks; blockIndex++) {
    final blockNoBytes = (ByteData(4)..setUint32(0, blockIndex, Endian.big))
        .buffer
        .asUint8List();
    var u = hmac.convert([...p.salt, ...blockNoBytes]).bytes;
    final t = List<int>.from(u);
    for (var i = 1; i < p.iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < t.length; j++) {
        t[j] ^= u[j];
      }
    }
    derived.add(t);
  }
  return Uint8List.fromList(derived.toBytes().sublist(0, p.keyLength));
}

class BackupState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  BackupState({this.isLoading = false, this.errorMessage, this.successMessage});

  BackupState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return BackupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

class BackupNotifier extends StateNotifier<BackupState> {
  final SharedPreferences _prefs;
  final Ref _ref;

  BackupNotifier(this._prefs, this._ref) : super(BackupState());

  /// Export local settings to file & share
  Future<void> exportLocalBackup(String? password) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

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
        jsonString = await _encryptLocalData(jsonString, password);
      }

      final tempDir = await getTemporaryDirectory();
      final String suffix = password != null ? '_encrypted' : '';
      final String formattedDate = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .substring(0, 19);
      final file = File(
        '${tempDir.path}/quran_backup${suffix}_$formattedDate.json',
      );
      await file.writeAsString(jsonString);

      // Share file
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Quran App Local Backup');

      state = state.copyWith(
        isLoading: false,
        successMessage: 'پاڵپشتی ناوخۆیی بە سەرکەوتوویی هەناردە کرا',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'کێشەیەک لە هەناردەکردنی پاڵپشتی هەیە: $e',
      );
    }
  }

  /// Import local settings from file
  Future<bool> importLocalBackup(File file, {String? password}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      String content = await file.readAsString();

      // Decrypt if password provided
      if (password != null && password.isNotEmpty) {
        final decrypted = await _decryptLocalData(content, password);
        if (decrypted == null) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'تێپەڕەوشەی هەڵە یان فایلی تێکچوو',
          );
          return false;
        }
        content = decrypted;
      }

      final payload = jsonDecode(content) as Map<String, dynamic>;
      final localPrefs = payload['local_preferences'] as Map<String, dynamic>?;

      if (localPrefs == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'فایلەکە زانیاری پێویستی تێدا نییە',
        );
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
          await _prefs.setStringList(
            key,
            val.map((e) => e.toString()).toList(),
          );
        }
      }

      state = state.copyWith(
        isLoading: false,
        successMessage: 'داتاکان بە سەرکەوتوویی هێنرانە ناوەوە',
      );
      _ref.invalidate(appSettingsProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'کێشە لە هێنانە ناوەوەی پاڵپشتی: $e',
      );
      return false;
    }
  }

  /// Encrypts [plainText] with a random salt + random IV per call (AES-256-CBC,
  /// key derived via PBKDF2-HMAC-SHA256). The salt and IV are stored alongside
  /// the ciphertext in a small JSON envelope — required for decryption, and
  /// safe to keep in the open since they aren't secret on their own.
  Future<String> _encryptLocalData(String plainText, String password) async {
    final salt = enc.SecureRandom(16).bytes;
    final iv = enc.IV.fromSecureRandom(16);
    final key = enc.Key(
      await compute(_pbkdf2Sync, _Pbkdf2Params(password, salt, 100000, 32)),
    );
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return jsonEncode({
      'v': _backupCryptoVersion,
      'salt': base64.encode(salt),
      'iv': iv.base64,
      'data': encrypted.base64,
    });
  }

  Future<String?> _decryptLocalData(String cipherText, String password) async {
    try {
      Map<String, dynamic>? envelope;
      try {
        final decoded = jsonDecode(cipherText);
        if (decoded is Map<String, dynamic> &&
            decoded['v'] == _backupCryptoVersion) {
          envelope = decoded;
        }
      } catch (_) {
        // Not JSON: must be a pre-v2 backup, handled by the legacy path below.
      }

      if (envelope != null) {
        final salt = base64.decode(envelope['salt'] as String);
        final iv = enc.IV.fromBase64(envelope['iv'] as String);
        final key = enc.Key(
          await compute(_pbkdf2Sync, _Pbkdf2Params(password, salt, 100000, 32)),
        );
        final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
        return encrypter.decrypt64(envelope['data'] as String, iv: iv);
      }

      // Legacy format (fixed zero IV, unsalted SHA-256 key) — kept only so
      // backups made before this fix can still be restored.
      final legacyKey = enc.Key(
        Uint8List.fromList(sha256.convert(utf8.encode(password)).bytes),
      );
      final legacyIv = enc.IV.fromLength(16);
      final legacyEncrypter = enc.Encrypter(
        enc.AES(legacyKey, mode: enc.AESMode.cbc),
      );
      return legacyEncrypter.decrypt64(cipherText, iv: legacyIv);
    } catch (e) {
      return null;
    }
  }
}

final backupStateProvider = StateNotifierProvider<BackupNotifier, BackupState>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BackupNotifier(prefs, ref);
});
