import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';

class DataTransferService {
  final SharedPreferences _prefs;
  final Isar _isar = IsarService.instance.isar;

  DataTransferService(this._prefs);

  /// Exports all offline user data (progress, statistics, history, and preferences) as a JSON-encodable map.
  Future<Map<String, dynamic>> exportData() async {
    // 1. Gather Isar user data collections
    final notes = await _isar.noteCollections.where().findAll();
    final bookmarks = await _isar.bookmarkCollections.where().findAll();
    final tasbihSessions = await _isar.tasbihSessionCollections.where().findAll();
    final memoPlans = await _isar.memorizationPlanCollections.where().findAll();
    final memoReviews = await _isar.memorizationReviewCollections.where().findAll();
    final readingHistory = await _isar.readingHistoryCollections.where().findAll();

    // 2. Gather settings from SharedPreferences
    final settings = <String, dynamic>{
      'theme_mode': _prefs.getString('theme_mode') ?? 'default',
      'language_code': _prefs.getString('language_code') ?? 'ku',
      'font_size': _prefs.getDouble('font_size') ?? 18.0,
      'line_height': _prefs.getDouble('line_height') ?? 2.2,
      'show_kurdish': _prefs.getBool('show_kurdish') ?? true,
      'show_english': _prefs.getBool('show_english') ?? false,
      'show_tajweed': _prefs.getBool('show_tajweed') ?? true,
    };

    return {
      'version': '1.0.0',
      'exported_at': DateTime.now().toIso8601String(),
      'settings': settings,
      'data': {
        'notes': notes.map((e) => {
              'noteId': e.noteId,
              'surahNumber': e.surahNumber,
              'ayahNumber': e.ayahNumber,
              'content': e.content,
              'createdAt': e.createdAt.toIso8601String(),
              'updatedAt': e.updatedAt.toIso8601String(),
            }).toList(),
        'bookmarks': bookmarks.map((e) => {
              'bookmarkId': e.bookmarkId,
              'surahNumber': e.surahNumber,
              'ayahNumber': e.ayahNumber,
              'createdAt': e.createdAt.toIso8601String(),
              'updatedAt': e.updatedAt.toIso8601String(),
            }).toList(),
        'tasbihSessions': tasbihSessions.map((e) => {
              'sessionId': e.sessionId,
              'startTime': e.startTime.toIso8601String(),
              'endTime': e.endTime?.toIso8601String(),
              'durationSeconds': e.durationSeconds,
              'totalCount': e.totalCount,
              'avgPerMinute': e.avgPerMinute,
              'sessionDate': e.sessionDate,
              'status': e.status,
              'customDhikrName': e.customDhikrName,
              'updatedAt': e.updatedAt.toIso8601String(),
            }).toList(),
        'memorizationPlans': memoPlans.map((e) => {
              'planId': e.planId,
              'surahId': e.surahId,
              'fromAyah': e.fromAyah,
              'toAyah': e.toAyah,
              'status': e.status,
              'notes': e.notes,
              'createdAt': e.createdAt.toIso8601String(),
              'updatedAt': e.updatedAt.toIso8601String(),
            }).toList(),
        'memorizationReviews': memoReviews.map((e) => {
              'reviewId': e.reviewId,
              'planId': e.planId,
              'reviewedAt': e.reviewedAt.toIso8601String(),
              'performance': e.performance,
              'updatedAt': e.updatedAt.toIso8601String(),
            }).toList(),
        'readingHistory': readingHistory.map((e) => {
              'surahNumber': e.surahNumber,
              'pageNumber': e.pageNumber,
              'readAt': e.readAt.toIso8601String(),
              'durationSeconds': e.durationSeconds,
            }).toList(),
      }
    };
  }

  /// Imports and merges a JSON-encodable backup data map into the local database and settings.
  Future<bool> importData(Map<String, dynamic> backup) async {
    try {
      final version = backup['version'] as String?;
      if (version != '1.0.0') return false;

      // 1. Restore settings to SharedPreferences
      final settings = backup['settings'] as Map<String, dynamic>? ?? {};
      if (settings.isNotEmpty) {
        if (settings.containsKey('theme_mode')) await _prefs.setString('theme_mode', settings['theme_mode']);
        if (settings.containsKey('language_code')) await _prefs.setString('language_code', settings['language_code']);
        if (settings.containsKey('font_size')) await _prefs.setDouble('font_size', settings['font_size']);
        if (settings.containsKey('line_height')) await _prefs.setDouble('line_height', settings['line_height']);
        if (settings.containsKey('show_kurdish')) await _prefs.setBool('show_kurdish', settings['show_kurdish']);
        if (settings.containsKey('show_english')) await _prefs.setBool('show_english', settings['show_english']);
        if (settings.containsKey('show_tajweed')) await _prefs.setBool('show_tajweed', settings['show_tajweed']);
      }

      final data = backup['data'] as Map<String, dynamic>? ?? {};
      if (data.isEmpty) return true;

      await _isar.writeTxn(() async {
        // 2. Restore Notes
        final rawNotes = data['notes'] as List? ?? [];
        for (final n in rawNotes) {
          final note = n as Map<String, dynamic>;
          final id = note['noteId'] as String;
          final existing = await _isar.noteCollections.filter().noteIdEqualTo(id).findFirst();
          final item = NoteCollection(
            noteId: id,
            surahNumber: note['surahNumber'] as int,
            ayahNumber: note['ayahNumber'] as int,
            content: note['content'] as String,
            createdAt: DateTime.parse(note['createdAt'] as String),
            updatedAt: DateTime.parse(note['updatedAt'] as String),
            isSynced: false,
          );
          if (existing != null) item.id = existing.id;
          await _isar.noteCollections.put(item);
        }

        // 3. Restore Bookmarks
        final rawBookmarks = data['bookmarks'] as List? ?? [];
        for (final b in rawBookmarks) {
          final bookmark = b as Map<String, dynamic>;
          final id = bookmark['bookmarkId'] as String;
          final existing = await _isar.bookmarkCollections.filter().bookmarkIdEqualTo(id).findFirst();
          final item = BookmarkCollection(
            bookmarkId: id,
            surahNumber: bookmark['surahNumber'] as int,
            ayahNumber: bookmark['ayahNumber'] as int,
            createdAt: DateTime.parse(bookmark['createdAt'] as String),
            updatedAt: DateTime.parse(bookmark['updatedAt'] as String),
            isSynced: false,
          );
          if (existing != null) item.id = existing.id;
          await _isar.bookmarkCollections.put(item);
        }

        // 4. Restore Tasbih Sessions
        final rawTasbih = data['tasbihSessions'] as List? ?? [];
        for (final s in rawTasbih) {
          final session = s as Map<String, dynamic>;
          final id = session['sessionId'] as String;
          final existing = await _isar.tasbihSessionCollections.filter().sessionIdEqualTo(id).findFirst();
          final item = TasbihSessionCollection(
            sessionId: id,
            startTime: DateTime.parse(session['startTime'] as String),
            endTime: session['endTime'] != null ? DateTime.parse(session['endTime'] as String) : null,
            durationSeconds: session['durationSeconds'] as int,
            totalCount: session['totalCount'] as int,
            avgPerMinute: (session['avgPerMinute'] as num).toDouble(),
            sessionDate: session['sessionDate'] as String,
            status: session['status'] as String,
            customDhikrName: session['customDhikrName'] as String?,
            updatedAt: DateTime.parse(session['updatedAt'] as String),
            isSynced: false,
          );
          if (existing != null) item.id = existing.id;
          await _isar.tasbihSessionCollections.put(item);
        }

        // 5. Restore Memorization Plans
        final rawPlans = data['memorizationPlans'] as List? ?? [];
        for (final p in rawPlans) {
          final plan = p as Map<String, dynamic>;
          final id = plan['planId'] as String;
          final existing = await _isar.memorizationPlanCollections.filter().planIdEqualTo(id).findFirst();
          final item = MemorizationPlanCollection(
            planId: id,
            surahId: plan['surahId'] as int,
            fromAyah: plan['fromAyah'] as int,
            toAyah: plan['toAyah'] as int,
            status: plan['status'] as String,
            notes: plan['notes'] as String?,
            createdAt: DateTime.parse(plan['createdAt'] as String),
            updatedAt: DateTime.parse(plan['updatedAt'] as String),
            isSynced: false,
          );
          if (existing != null) item.id = existing.id;
          await _isar.memorizationPlanCollections.put(item);
        }

        // 6. Restore Memorization Reviews
        final rawReviews = data['memorizationReviews'] as List? ?? [];
        for (final r in rawReviews) {
          final review = r as Map<String, dynamic>;
          final id = review['reviewId'] as String;
          final existing = await _isar.memorizationReviewCollections.filter().reviewIdEqualTo(id).findFirst();
          final item = MemorizationReviewCollection(
            reviewId: id,
            planId: review['planId'] as String,
            reviewedAt: DateTime.parse(review['reviewedAt'] as String),
            performance: review['performance'] as String,
            updatedAt: DateTime.parse(review['updatedAt'] as String),
            isSynced: false,
          );
          if (existing != null) item.id = existing.id;
          await _isar.memorizationReviewCollections.put(item);
        }

        // 7. Restore Reading History
        final rawHistory = data['readingHistory'] as List? ?? [];
        for (final h in rawHistory) {
          final history = h as Map<String, dynamic>;
          final item = ReadingHistoryCollection(
            surahNumber: history['surahNumber'] as int,
            pageNumber: history['pageNumber'] as int,
            readAt: DateTime.parse(history['readAt'] as String),
            durationSeconds: history['durationSeconds'] as int,
          );
          await _isar.readingHistoryCollections.put(item);
        }
      });

      return true;
    } catch (_) {
      return false;
    }
  }
}
