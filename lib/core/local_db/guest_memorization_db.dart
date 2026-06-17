import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GuestMemoDraft — local storage model for memorization drafts
// created while the user is in guest mode
// ─────────────────────────────────────────────────────────────────────────────

class GuestMemoDraft {
  final String id;          // local UUID (DateTime.now().millisecondsSinceEpoch.toString())
  final int surahId;
  final int fromAyah;
  final int toAyah;
  final String status;      // 'pending' | 'memorized' | 'learning'
  final String? notes;
  final DateTime createdAt;
  final bool synced;

  const GuestMemoDraft({
    required this.id,
    required this.surahId,
    required this.fromAyah,
    required this.toAyah,
    this.status = 'pending',
    this.notes,
    required this.createdAt,
    this.synced = false,
  });

  GuestMemoDraft copyWith({bool? synced, String? status, String? notes}) {
    return GuestMemoDraft(
      id: id,
      surahId: surahId,
      fromAyah: fromAyah,
      toAyah: toAyah,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surah_id': surahId,
        'from_ayah': fromAyah,
        'to_ayah': toAyah,
        'status': status,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'synced': synced,
      };

  factory GuestMemoDraft.fromJson(Map<String, dynamic> json) => GuestMemoDraft(
        id: json['id'] as String,
        surahId: json['surah_id'] as int,
        fromAyah: json['from_ayah'] as int,
        toAyah: json['to_ayah'] as int,
        status: json['status'] as String? ?? 'pending',
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        synced: json['synced'] as bool? ?? false,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// GuestMemorizationDb — Hive-backed local database for guest drafts
// ─────────────────────────────────────────────────────────────────────────────

class GuestMemorizationDb {
  static const String _boxName = 'guest_memo_drafts';

  late Box _box;

  /// Open the Hive box. Call once during app initialization.
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Save a new draft. Uses the draft ID as the Hive key.
  Future<void> saveDraft(GuestMemoDraft draft) async {
    await _box.put(draft.id, jsonEncode(draft.toJson()));
  }

  /// Get all drafts that have not yet been synced to the backend.
  List<GuestMemoDraft> getPendingDrafts() {
    return _box.values
        .map((v) {
          try {
            final decoded = jsonDecode(v as String) as Map<String, dynamic>;
            return GuestMemoDraft.fromJson(decoded);
          } catch (_) {
            return null;
          }
        })
        .whereType<GuestMemoDraft>()
        .where((d) => !d.synced)
        .toList();
  }

  /// Get all drafts (including synced ones).
  List<GuestMemoDraft> getAllDrafts() {
    return _box.values
        .map((v) {
          try {
            final decoded = jsonDecode(v as String) as Map<String, dynamic>;
            return GuestMemoDraft.fromJson(decoded);
          } catch (_) {
            return null;
          }
        })
        .whereType<GuestMemoDraft>()
        .toList();
  }

  /// Mark a draft as synced after successful backend migration.
  Future<void> markSynced(String id) async {
    final raw = _box.get(id) as String?;
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final draft = GuestMemoDraft.fromJson(decoded).copyWith(synced: true);
      await _box.put(id, jsonEncode(draft.toJson()));
    } catch (_) {}
  }

  /// Delete all synced drafts to free up space.
  Future<void> clearSynced() async {
    final syncedKeys = _box.keys
        .where((k) {
          try {
            final raw = _box.get(k) as String?;
            if (raw == null) return false;
            final decoded = jsonDecode(raw) as Map<String, dynamic>;
            return decoded['synced'] as bool? ?? false;
          } catch (_) {
            return false;
          }
        })
        .toList();

    for (final key in syncedKeys) {
      await _box.delete(key);
    }
  }

  /// Total number of pending (unsynced) drafts.
  int get pendingCount => getPendingDrafts().length;

  /// Close the Hive box.
  Future<void> dispose() async {
    await _box.close();
  }
}
