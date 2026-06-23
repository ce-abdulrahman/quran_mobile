import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import '../network/api_client.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';

class SyncEngine {
  final SharedPreferences _prefs;
  final ApiClient _apiClient;
  final Isar _isar = IsarService.instance.isar;

  SyncEngine(this._prefs, this._apiClient);

  static const String lastSyncTimeKey = 'sync_engine_last_sync';

  /// Trigger a background sync process.
  /// Collects local unsynced records, executes Last Write Wins conflict checks,
  /// pushes new edits to the Laravel backend, downloads remote changes,
  /// and triggers safety alerts if offline duration threshold is exceeded.
  Future<void> sync() async {
    final lastSyncStr = _prefs.getString(lastSyncTimeKey);
    final lastSync = lastSyncStr != null ? DateTime.tryParse(lastSyncStr) : null;

    // Check Sync Safety thresholds
    if (lastSync != null) {
      final daysSinceSync = DateTime.now().difference(lastSync).inDays;
      if (daysSinceSync >= 30) {
        debugPrint('[SyncEngine] WARNING: Connect to the internet to ensure your memorization data is safely backed up.');
      } else if (daysSinceSync >= 7) {
        debugPrint('[SyncEngine] WARNING: Your memorization data currently exists only on this device.');
      } else if (daysSinceSync >= 3) {
        debugPrint('[SyncEngine] WARNING: Your memorization progress has not been synced for 3 days.');
      }
    }

    try {
      // 1. Process Outbox: Upload local changes to Laravel using Last Write Wins policy
      await _syncOutbox();

      // 2. Process Inbox: Pull changes from Laravel updated since the last sync time
      await _syncInbox(lastSync);

      // Record successful sync time
      await _prefs.setString(lastSyncTimeKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('[SyncEngine] Sync failed: $e');
    }
  }

  /// Syncs local edits to the backend, implementing the LWW conflict policy.
  Future<void> _syncOutbox() async {
    // A. Memorization Plans
    final unsyncedPlans = await _isar.memorizationPlanCollections.filter().isSyncedEqualTo(false).findAll();
    for (final plan in unsyncedPlans) {
      try {
        final response = await _apiClient.get('/memorization-plans/${plan.planId}');
        if (response.statusCode == 200 && response.data != null) {
          final remote = response.data['data'] as Map<String, dynamic>;
          final remoteUpdatedAt = DateTime.parse(remote['updated_at'] as String);

          // Conflict resolution: Last Write Wins (LWW)
          if (plan.updatedAt.isAfter(remoteUpdatedAt)) {
            // Local is newer: upload
            await _uploadPlan(plan);
          } else if (remoteUpdatedAt.isAfter(plan.updatedAt)) {
            // Remote is newer: pull & update local Isar
            await _updateLocalPlan(plan, remote);
          } else {
            // Equal: just mark local as synced
            await _isar.writeTxn(() async {
              plan.isSynced = true;
              await _isar.memorizationPlanCollections.put(plan);
            });
          }
        } else if (response.statusCode == 404) {
          // Doesn't exist on server yet: upload
          await _uploadPlan(plan);
        }
      } catch (_) {
        // If query fails, assume network issue, upload directly or fallback
        await _uploadPlan(plan);
      }
    }

    // B. Bookmarks
    final unsyncedBookmarks = await _isar.bookmarkCollections.filter().isSyncedEqualTo(false).findAll();
    for (final bookmark in unsyncedBookmarks) {
      try {
        final response = await _apiClient.post('/bookmarks/sync', data: {
          'bookmark_id': bookmark.bookmarkId,
          'surah_number': bookmark.surahNumber,
          'ayah_number': bookmark.ayahNumber,
          'created_at': bookmark.createdAt.toIso8601String(),
          'updated_at': bookmark.updatedAt.toIso8601String(),
        });
        if (response.statusCode == 200 || response.statusCode == 201) {
          await _isar.writeTxn(() async {
            bookmark.isSynced = true;
            await _isar.bookmarkCollections.put(bookmark);
          });
        }
      } catch (_) {}
    }

    // C. Notes
    final unsyncedNotes = await _isar.noteCollections.filter().isSyncedEqualTo(false).findAll();
    for (final note in unsyncedNotes) {
      try {
        final response = await _apiClient.post('/notes/sync', data: {
          'note_id': note.noteId,
          'surah_number': note.surahNumber,
          'ayah_number': note.ayahNumber,
          'content': note.content,
          'created_at': note.createdAt.toIso8601String(),
          'updated_at': note.updatedAt.toIso8601String(),
        });
        if (response.statusCode == 200 || response.statusCode == 201) {
          await _isar.writeTxn(() async {
            note.isSynced = true;
            await _isar.noteCollections.put(note);
          });
        }
      } catch (_) {}
    }
  }

  /// Pulls all updates from the server and applies them locally using LWW policy.
  Future<void> _syncInbox(DateTime? lastSync) async {
    final lastSyncIso = lastSync?.toIso8601String() ?? '';
    final response = await _apiClient.get('/sync/inbox', queryParameters: {
      'since': lastSyncIso,
    });

    if (response.statusCode == 200 && response.data != null) {
      final remoteData = response.data['data'] as Map<String, dynamic>;

      await _isar.writeTxn(() async {
        // A. Import plans
        final remotePlans = remoteData['memorization_plans'] as List? ?? [];
        for (final p in remotePlans) {
          final plan = p as Map<String, dynamic>;
          final id = plan['plan_id'] as String;
          final remoteUpdated = DateTime.parse(plan['updated_at'] as String);

          final existing = await _isar.memorizationPlanCollections.filter().planIdEqualTo(id).findFirst();
          if (existing == null || remoteUpdated.isAfter(existing.updatedAt)) {
            final item = MemorizationPlanCollection(
              planId: id,
              surahId: plan['surah_id'] as int,
              fromAyah: plan['from_ayah'] as int,
              toAyah: plan['to_ayah'] as int,
              status: plan['status'] as String,
              notes: plan['notes'] as String?,
              createdAt: DateTime.parse(plan['created_at'] as String),
              updatedAt: remoteUpdated,
              isSynced: true,
            );
            if (existing != null) item.id = existing.id;
            await _isar.memorizationPlanCollections.put(item);
          }
        }

        // B. Import notes
        final remoteNotes = remoteData['notes'] as List? ?? [];
        for (final n in remoteNotes) {
          final note = n as Map<String, dynamic>;
          final id = note['note_id'] as String;
          final remoteUpdated = DateTime.parse(note['updated_at'] as String);

          final existing = await _isar.noteCollections.filter().noteIdEqualTo(id).findFirst();
          if (existing == null || remoteUpdated.isAfter(existing.updatedAt)) {
            final item = NoteCollection(
              noteId: id,
              surahNumber: note['surah_number'] as int,
              ayahNumber: note['ayah_number'] as int,
              content: note['content'] as String,
              createdAt: DateTime.parse(note['created_at'] as String),
              updatedAt: remoteUpdated,
              isSynced: true,
            );
            if (existing != null) item.id = existing.id;
            await _isar.noteCollections.put(item);
          }
        }
      });
    }
  }

  Future<void> _uploadPlan(MemorizationPlanCollection plan) async {
    final response = await _apiClient.post('/memorization-plans/sync', data: {
      'plan_id': plan.planId,
      'surah_id': plan.surahId,
      'from_ayah': plan.fromAyah,
      'to_ayah': plan.toAyah,
      'status': plan.status,
      'notes': plan.notes,
      'created_at': plan.createdAt.toIso8601String(),
      'updated_at': plan.updatedAt.toIso8601String(),
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      await _isar.writeTxn(() async {
        plan.isSynced = true;
        await _isar.memorizationPlanCollections.put(plan);
      });
    }
  }

  Future<void> _updateLocalPlan(MemorizationPlanCollection local, Map<String, dynamic> remote) async {
    await _isar.writeTxn(() async {
      local.status = remote['status'] as String;
      local.notes = remote['notes'] as String?;
      local.updatedAt = DateTime.parse(remote['updated_at'] as String);
      local.isSynced = true;
      await _isar.memorizationPlanCollections.put(local);
    });
  }
}
