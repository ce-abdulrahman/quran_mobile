import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/recitation_models.dart';
import '../models/reciter_model.dart';
import '../network/api_client.dart';
import '../repositories/audio_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import 'audio_event_bus.dart';

enum DownloadStatus { queued, downloading, complete, error }

class DownloadProgress {
  final int reciterId;
  final int surahId;
  final double progress; // 0.0 to 1.0
  final int bytesDownloaded;
  final int totalBytes;
  final DownloadStatus status;

  DownloadProgress({
    required this.reciterId,
    required this.surahId,
    required this.progress,
    required this.bytesDownloaded,
    required this.totalBytes,
    required this.status,
  });
}

class CachedReciter {
  final int id;
  final String name;
  final int sizeBytes;

  CachedReciter({required this.id, required this.name, required this.sizeBytes});
}

class DownloadQueueState {
  final DownloadProgress? activeProgress;
  final int pendingCount;
  final bool isPaused;

  DownloadQueueState({
    this.activeProgress,
    required this.pendingCount,
    required this.isPaused,
  });
}

class DownloadTask {
  final int reciterId;
  final int surahId;
  final Completer<String> completer;
  CancelToken? cancelToken;
  DownloadStatus status;

  DownloadTask({
    required this.reciterId,
    required this.surahId,
    required this.completer,
    this.status = DownloadStatus.queued,
  });
}

class AudioDownloadManager {
  static final AudioDownloadManager _instance = AudioDownloadManager._internal();
  factory AudioDownloadManager() => _instance;
  AudioDownloadManager._internal() {
    processPendingSyncs();
  }

  final ApiClient _apiClient = ApiClient();
  final _progressController = StreamController<DownloadProgress>.broadcast();
  final _queueStateController = StreamController<DownloadQueueState>.broadcast();

  final List<DownloadTask> _queue = [];
  DownloadTask? _activeTask;
  bool _isPaused = false;

  Box get _cacheBox => Hive.box('app_cache_box');

  SharedPreferences? _prefsInstance;
  Future<SharedPreferences> get _prefs async {
    _prefsInstance ??= await SharedPreferences.getInstance();
    return _prefsInstance!;
  }

  Future<void> _updateIsarDownload({
    required int reciterId,
    required int surahId,
    required String status,
    required double progress,
    String? filePath,
    double? sizeMb,
  }) async {
    if (kIsWeb) return;
    try {
      final isar = IsarService.instance.isar;
      final key = '${reciterId}_$surahId';
      
      await isar.writeTxn(() async {
        final existing = await isar.downloadCollections.filter().downloadKeyEqualTo(key).findFirst();
        if (existing != null) {
          existing.status = status;
          existing.progress = progress;
          existing.lastAccessedAt = DateTime.now();
          if (filePath != null) existing.filePath = filePath;
          if (sizeMb != null) existing.sizeMb = sizeMb;
          await isar.downloadCollections.put(existing);
        } else {
          final newItem = DownloadCollection(
            downloadKey: key,
            reciterId: reciterId,
            surahId: surahId,
            filePath: filePath ?? '',
            sizeMb: sizeMb ?? 0.0,
            status: status,
            progress: progress,
            createdAt: DateTime.now(),
            lastAccessedAt: DateTime.now(),
          );
          await isar.downloadCollections.put(newItem);
        }
      });
    } catch (_) {}
  }

  Future<void> _deleteIsarDownload(int reciterId, int surahId) async {
    if (kIsWeb) return;
    try {
      final isar = IsarService.instance.isar;
      final key = '${reciterId}_$surahId';
      await isar.writeTxn(() async {
        await isar.downloadCollections.filter().downloadKeyEqualTo(key).deleteAll();
      });
    } catch (_) {}
  }

  Future<void> _deleteIsarReciterDownloads(int reciterId) async {
    if (kIsWeb) return;
    try {
      final isar = IsarService.instance.isar;
      await isar.writeTxn(() async {
        await isar.downloadCollections.filter().reciterIdEqualTo(reciterId).deleteAll();
      });
    } catch (_) {}
  }

  Future<void> _syncDownloadStatus(int reciterId, int surahId, String status, double progress) async {
    if (kIsWeb) return;
    try {
      await _apiClient.post(
        'audio-downloads',
        data: {
          'reciter_id': reciterId,
          'surah_id': surahId,
          'status': status,
          'progress': progress,
        },
      );
      // Attempt to clear previous pending syncs for this specific key if they exist
      final preferences = await _prefs;
      final list = preferences.getStringList('pending_downloads_sync') ?? [];
      final updatedList = list.where((item) {
        try {
          final decoded = jsonDecode(item);
          return !(decoded['reciter_id'] == reciterId && decoded['surah_id'] == surahId);
        } catch (_) {
          return true;
        }
      }).toList();
      await preferences.setStringList('pending_downloads_sync', updatedList);
    } catch (e) {
      await _queueStatusSync(reciterId, surahId, status, progress);
    }
  }

  Future<void> _queueStatusSync(int reciterId, int surahId, String status, double progress) async {
    final preferences = await _prefs;
    final list = preferences.getStringList('pending_downloads_sync') ?? [];
    final json = jsonEncode({
      'reciter_id': reciterId,
      'surah_id': surahId,
      'status': status,
      'progress': progress,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    final updatedList = list.where((item) {
      try {
        final decoded = jsonDecode(item);
        return !(decoded['reciter_id'] == reciterId && decoded['surah_id'] == surahId);
      } catch (_) {
        return true;
      }
    }).toList();
    updatedList.add(json);
    await preferences.setStringList('pending_downloads_sync', updatedList);
  }

  Future<void> processPendingSyncs() async {
    if (kIsWeb) return;
    try {
      final preferences = await _prefs;
      final list = preferences.getStringList('pending_downloads_sync') ?? [];
      if (list.isEmpty) return;

      final failedList = <String>[];
      for (final item in list) {
        try {
          final decoded = jsonDecode(item);
          final reciterId = decoded['reciter_id'] as int;
          final surahId = decoded['surah_id'] as int;
          final status = decoded['status'] as String;
          final progress = decoded['progress'] as double;

          await _apiClient.post(
            'audio-downloads',
            data: {
              'reciter_id': reciterId,
              'surah_id': surahId,
              'status': status,
              'progress': progress,
            },
          );
        } catch (_) {
          failedList.add(item);
        }
      }
      await preferences.setStringList('pending_downloads_sync', failedList);
    } catch (_) {}
  }

  Stream<DownloadProgress> watchProgress(int reciterId, int surahId) {
    return _progressController.stream.where((p) => p.reciterId == reciterId && p.surahId == surahId);
  }

  Stream<DownloadQueueState> watchQueueState() => _queueStateController.stream;

  bool isDownloaded(int reciterId, int surahId) {
    if (kIsWeb) return false;
    final key = 'downloaded_recitation_${reciterId}_$surahId';
    final data = _cacheBox.get(key);
    if (data == null) return false;
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(
        data is String ? jsonDecode(data) : data,
      );
      final localPath = map['localPath'] as String;
      if (File(localPath).existsSync()) {
        return true;
      } else {
        _cacheBox.delete(key);
      }
    } catch (_) {}
    return false;
  }

  String? getLocalPath(int reciterId, int surahId) {
    if (kIsWeb) return null;
    if (!isDownloaded(reciterId, surahId)) return null;
    final key = 'downloaded_recitation_${reciterId}_$surahId';
    final data = _cacheBox.get(key);
    if (data == null) return null;
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(
        data is String ? jsonDecode(data) : data,
      );
      map['lastAccessedAt'] = DateTime.now().toIso8601String();
      _cacheBox.put(key, map);
      _updateIsarDownload(
        reciterId: reciterId,
        surahId: surahId,
        status: 'completed',
        progress: 100.0,
      );
      return map['localPath'] as String;
    } catch (_) {}
    return null;
  }

  Future<String> downloadSurah(int reciterId, int surahId) async {
    if (kIsWeb) {
      return '';
    }
    if (isDownloaded(reciterId, surahId)) {
      return getLocalPath(reciterId, surahId)!;
    }

    if (_activeTask != null && _activeTask!.reciterId == reciterId && _activeTask!.surahId == surahId) {
      return _activeTask!.completer.future;
    }
    final existing = _queue.where((t) => t.reciterId == reciterId && t.surahId == surahId).firstOrNull;
    if (existing != null) {
      return existing.completer.future;
    }

    final completer = Completer<String>();
    final task = DownloadTask(
      reciterId: reciterId,
      surahId: surahId,
      completer: completer,
    );
    _queue.add(task);

    _progressController.add(DownloadProgress(
      reciterId: reciterId,
      surahId: surahId,
      progress: 0.0,
      bytesDownloaded: 0,
      totalBytes: 0,
      status: DownloadStatus.queued,
    ));

    _updateIsarDownload(
      reciterId: reciterId,
      surahId: surahId,
      status: 'downloading',
      progress: 0.0,
    );
    _syncDownloadStatus(reciterId, surahId, 'downloading', 0.0);
    AudioEventBus().fire(DownloadProgressEvent(
      reciterId: reciterId,
      surahId: surahId,
      progress: 0.0,
      status: 'downloading',
    ));

    _emitQueueState();
    _processNext();

    return completer.future;
  }

  void pauseQueue() {
    if (kIsWeb) return;
    if (_isPaused) return;
    _isPaused = true;
    if (_activeTask != null) {
      final task = _activeTask!;
      task.cancelToken?.cancel();
      _activeTask = null;

      final newTask = DownloadTask(
        reciterId: task.reciterId,
        surahId: task.surahId,
        completer: task.completer,
      );
      _queue.insert(0, newTask);
    }
    _emitQueueState();
  }

  void resumeQueue() {
    if (kIsWeb) return;
    if (!_isPaused) return;
    _isPaused = false;
    _emitQueueState();
    _processNext();
  }

  Future<void> cancelDownload(int reciterId, int surahId) async {
    if (kIsWeb) return;
    if (_activeTask != null && _activeTask!.reciterId == reciterId && _activeTask!.surahId == surahId) {
      _activeTask!.cancelToken?.cancel();
      _activeTask = null;
    } else {
      final index = _queue.indexWhere((t) => t.reciterId == reciterId && t.surahId == surahId);
      if (index != -1) {
        final task = _queue.removeAt(index);
        task.completer.completeError(Exception('داگرتن هەڵوەشێندرایەوە'));
      }
    }

    _progressController.add(DownloadProgress(
      reciterId: reciterId,
      surahId: surahId,
      progress: 0.0,
      bytesDownloaded: 0,
      totalBytes: 0,
      status: DownloadStatus.error,
    ));

    _updateIsarDownload(
      reciterId: reciterId,
      surahId: surahId,
      status: 'failed',
      progress: 0.0,
    );
    _syncDownloadStatus(reciterId, surahId, 'failed', 0.0);
    AudioEventBus().fire(DownloadProgressEvent(
      reciterId: reciterId,
      surahId: surahId,
      progress: 0.0,
      status: 'failed',
    ));

    _emitQueueState();
    _processNext();
  }

  void _emitQueueState() {
    DownloadProgress? activeProgress;
    if (_activeTask != null) {
      activeProgress = DownloadProgress(
        reciterId: _activeTask!.reciterId,
        surahId: _activeTask!.surahId,
        progress: 0.0,
        bytesDownloaded: 0,
        totalBytes: 0,
        status: DownloadStatus.downloading,
      );
    }
    _queueStateController.add(DownloadQueueState(
      activeProgress: activeProgress,
      pendingCount: _queue.length,
      isPaused: _isPaused,
    ));
  }

  void _processNext() async {
    if (_isPaused || _activeTask != null || _queue.isEmpty) {
      _emitQueueState();
      return;
    }

    if (kIsWeb) {
      _activeTask = null;
      _emitQueueState();
      return;
    }

    final task = _queue.removeAt(0);
    _activeTask = task;
    task.status = DownloadStatus.downloading;
    task.cancelToken = CancelToken();
    _emitQueueState();

    try {
      final audioRepo = AudioRepository(_apiClient);
      final result = await audioRepo.getSurahAudio(task.surahId, task.reciterId);

      String url = '';
      result.when(
        success: (data) => url = data.streamUrl,
        error: (msg, _, __) => throw Exception(msg),
      );

      if (url.isEmpty) {
        throw Exception('دەنگی سوورەتەکە نەدۆزرایەوە');
      }

      final docDir = await getApplicationDocumentsDirectory();
      final localDir = Directory('${docDir.path}/recitations/${task.reciterId}');
      if (!await localDir.exists()) {
        await localDir.create(recursive: true);
      }
      final localPath = '${localDir.path}/${task.surahId}.mp3';

      await _apiClient.download(
        url,
        localPath,
        cancelToken: task.cancelToken,
        onReceiveProgress: (received, total) {
          if (task.cancelToken?.isCancelled ?? false) return;
          final progress = total > 0 ? received / total : 0.0;
          _progressController.add(DownloadProgress(
            reciterId: task.reciterId,
            surahId: task.surahId,
            progress: progress,
            bytesDownloaded: received,
            totalBytes: total,
            status: DownloadStatus.downloading,
          ));
          AudioEventBus().fire(DownloadProgressEvent(
            reciterId: task.reciterId,
            surahId: task.surahId,
            progress: progress * 100.0,
            status: 'downloading',
          ));
        },
      );

      final file = File(localPath);
      if (await file.exists()) {
        final fileSize = await file.length();
        final downloaded = DownloadedRecitation(
          reciterId: task.reciterId,
          surahId: task.surahId,
          localPath: localPath,
          fileSize: fileSize,
          downloadedAt: DateTime.now(),
          lastAccessedAt: DateTime.now(),
        );

        final key = 'downloaded_recitation_${task.reciterId}_${task.surahId}';
        await _cacheBox.put(key, jsonEncode(downloaded.toJson()));

        task.status = DownloadStatus.complete;
        _progressController.add(DownloadProgress(
          reciterId: task.reciterId,
          surahId: task.surahId,
          progress: 1.0,
          bytesDownloaded: fileSize,
          totalBytes: fileSize,
          status: DownloadStatus.complete,
        ));

        _updateIsarDownload(
          reciterId: task.reciterId,
          surahId: task.surahId,
          status: 'completed',
          progress: 100.0,
          filePath: localPath,
          sizeMb: fileSize / (1024 * 1024),
        );
        _syncDownloadStatus(task.reciterId, task.surahId, 'completed', 100.0);
        AudioEventBus().fire(DownloadProgressEvent(
          reciterId: task.reciterId,
          surahId: task.surahId,
          progress: 100.0,
          status: 'completed',
        ));

        task.completer.complete(localPath);
      } else {
        throw Exception('پاشەکەوتکردنی فایلەکە سەرکەوتوو نەبوو');
      }
    } catch (e) {
      task.status = DownloadStatus.error;
      _progressController.add(DownloadProgress(
        reciterId: task.reciterId,
        surahId: task.surahId,
        progress: 0.0,
        bytesDownloaded: 0,
        totalBytes: 0,
        status: DownloadStatus.error,
      ));

      _updateIsarDownload(
        reciterId: task.reciterId,
        surahId: task.surahId,
        status: 'failed',
        progress: 0.0,
      );
      _syncDownloadStatus(task.reciterId, task.surahId, 'failed', 0.0);
      AudioEventBus().fire(DownloadProgressEvent(
        reciterId: task.reciterId,
        surahId: task.surahId,
        progress: 0.0,
        status: 'failed',
      ));

      if (!task.completer.isCompleted) {
        task.completer.completeError(e);
      }
    } finally {
      _activeTask = null;
      _emitQueueState();
      _processNext();
    }
  }

  Future<int> getTotalStorageBytes() async {
    if (kIsWeb) return 0;
    int total = 0;
    try {
      for (final key in _cacheBox.keys) {
        if (key is String && key.startsWith('downloaded_recitation_')) {
          final data = _cacheBox.get(key);
          if (data != null) {
            final Map<String, dynamic> map = Map<String, dynamic>.from(
              data is String ? jsonDecode(data) : data,
            );
            total += map['fileSize'] as int? ?? 0;
          }
        }
      }
    } catch (_) {}
    return total;
  }

  Future<int> getReciterStorageBytes(int reciterId) async {
    if (kIsWeb) return 0;
    int total = 0;
    try {
      for (final key in _cacheBox.keys) {
        if (key is String && key.startsWith('downloaded_recitation_${reciterId}_')) {
          final data = _cacheBox.get(key);
          if (data != null) {
            final Map<String, dynamic> map = Map<String, dynamic>.from(
              data is String ? jsonDecode(data) : data,
            );
            total += map['fileSize'] as int? ?? 0;
          }
        }
      }
    } catch (_) {}
    return total;
  }

  Future<List<CachedReciter>> getDownloadedReciters() async {
    if (kIsWeb) return [];
    final Map<int, int> reciterSizes = {};
    for (final key in _cacheBox.keys) {
      if (key is String && key.startsWith('downloaded_recitation_')) {
        final data = _cacheBox.get(key);
        if (data != null) {
          try {
            final Map<String, dynamic> map = Map<String, dynamic>.from(
              data is String ? jsonDecode(data) : data,
            );
            final reciterId = map['reciterId'] as int;
            final fileSize = map['fileSize'] as int? ?? 0;
            reciterSizes[reciterId] = (reciterSizes[reciterId] ?? 0) + fileSize;
          } catch (_) {}
        }
      }
    }

    if (reciterSizes.isEmpty) return [];

    List<ReciterModel> recitersList = [];
    try {
      final audioRepo = AudioRepository(_apiClient);
      final result = await audioRepo.getReciters();
      result.when(
        success: (data) => recitersList = data,
        error: (_, __, ___) {},
      );
    } catch (_) {}

    final List<CachedReciter> result = [];
    reciterSizes.forEach((id, size) {
      final reciter = recitersList.firstWhere(
        (r) => r.id == id,
        orElse: () => ReciterModel(id: id, name: 'قورئان خوێن $id', riwayah: '', language: ''),
      );
      result.add(CachedReciter(id: id, name: reciter.name, sizeBytes: size));
    });
    return result;
  }

  Future<void> deleteReciter(int reciterId) async {
    if (kIsWeb) return;
    final docDir = await getApplicationDocumentsDirectory();
    final localDir = Directory('${docDir.path}/recitations/$reciterId');
    if (await localDir.exists()) {
      await localDir.delete(recursive: true);
    }

    final keysToDelete = <String>[];
    for (final key in _cacheBox.keys) {
      if (key is String && key.startsWith('downloaded_recitation_${reciterId}_')) {
        keysToDelete.add(key);
        try {
          final parts = key.split('_');
          final surahId = int.parse(parts.last);
          _syncDownloadStatus(reciterId, surahId, 'failed', 0.0);
        } catch (_) {}
      }
    }
    for (final key in keysToDelete) {
      await _cacheBox.delete(key);
    }
    await _deleteIsarReciterDownloads(reciterId);
  }

  Future<void> deleteSurah(int reciterId, int surahId) async {
    if (kIsWeb) return;
    final docDir = await getApplicationDocumentsDirectory();
    final file = File('${docDir.path}/recitations/$reciterId/$surahId.mp3');
    if (await file.exists()) {
      await file.delete();
    }
    await _cacheBox.delete('downloaded_recitation_${reciterId}_$surahId');
    await _deleteIsarDownload(reciterId, surahId);
    _syncDownloadStatus(reciterId, surahId, 'failed', 0.0);
  }

  Future<void> enforceSizeLimit(int maxBytes) async {
    if (kIsWeb) return;
    final List<DownloadedRecitation> recitations = [];
    for (final key in _cacheBox.keys) {
      if (key is String && key.startsWith('downloaded_recitation_')) {
        final data = _cacheBox.get(key);
        if (data != null) {
          try {
            final Map<String, dynamic> map = Map<String, dynamic>.from(
              data is String ? jsonDecode(data) : data,
            );
            recitations.add(DownloadedRecitation.fromJson(map));
          } catch (_) {}
        }
      }
    }

    int currentTotal = recitations.fold(0, (sum, item) => sum + item.fileSize);
    if (currentTotal <= maxBytes) return;

    recitations.sort((a, b) => a.lastAccessedAt.compareTo(b.lastAccessedAt));

    for (final item in recitations) {
      if (currentTotal <= maxBytes) break;
      await deleteSurah(item.reciterId, item.surahId);
      currentTotal -= item.fileSize;
    }
  }

  Future<void> runCleanupPolicy() async {
    if (kIsWeb) return;
    await enforceSizeLimit(500 * 1024 * 1024);
  }
}
