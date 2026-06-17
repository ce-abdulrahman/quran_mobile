import 'package:flutter/foundation.dart';
import '../local_db/guest_memorization_db.dart';
import '../network/api_client.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GuestMemoDraftMigrationService
//
// Migrates memorization drafts created in guest mode to the backend API
// after the user successfully logs in or registers.
//
// Usage (called from AuthNotifier after successful login/register):
//   final service = GuestMemoDraftMigrationService(db, apiClient);
//   final result = await service.migrate();
// ─────────────────────────────────────────────────────────────────────────────

class MigrationResult {
  final int total;
  final int succeeded;
  final int failed;

  const MigrationResult({
    required this.total,
    required this.succeeded,
    required this.failed,
  });

  bool get hasFailures => failed > 0;
  bool get allSucceeded => succeeded == total;
}

class GuestMemoDraftMigrationService {
  final GuestMemorizationDb _db;
  final ApiClient _apiClient;

  const GuestMemoDraftMigrationService(this._db, this._apiClient);

  /// Migrate all unsynced guest drafts to the backend.
  ///
  /// Each draft is posted individually to `POST /memorization-plans`.
  /// Successfully migrated drafts are marked as synced in the local DB.
  /// Returns a [MigrationResult] with counts of success and failure.
  Future<MigrationResult> migrate() async {
    final drafts = _db.getPendingDrafts();
    if (drafts.isEmpty) {
      return const MigrationResult(total: 0, succeeded: 0, failed: 0);
    }

    int succeeded = 0;
    int failed = 0;

    for (final draft in drafts) {
      try {
        final response = await _apiClient.post(
          '/memorization-plans',
          data: {
            'surah_id':  draft.surahId,
            'from_ayah': draft.fromAyah,
            'to_ayah':   draft.toAyah,
            'status':    draft.status,
            'notes':     draft.notes,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await _db.markSynced(draft.id);
          succeeded++;
        } else {
          failed++;
        }
      } catch (e) {
        debugPrint('[GuestMemoDraftMigration] Failed to migrate draft ${draft.id}: $e');
        failed++;
      }
    }

    // Clean up synced drafts after successful migration
    if (succeeded > 0) {
      await _db.clearSynced();
    }

    return MigrationResult(
      total: drafts.length,
      succeeded: succeeded,
      failed: failed,
    );
  }

  /// Check if there are any pending drafts waiting to be migrated.
  bool get hasPendingDrafts => _db.pendingCount > 0;

  /// Number of pending drafts.
  int get pendingCount => _db.pendingCount;
}
