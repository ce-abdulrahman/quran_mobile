import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';

class LocalNote {
  final String noteId;
  final int surahNumber;
  final int ayahNumber;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const LocalNote({
    required this.noteId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });
}

class NotesNotifier extends StateNotifier<List<LocalNote>> {
  NotesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final isar = IsarService.instance.isar;
    final list = await isar.noteCollections.where().findAll();
    state = list.map((e) => LocalNote(
      noteId: e.noteId,
      surahNumber: e.surahNumber,
      ayahNumber: e.ayahNumber,
      content: e.content,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      isSynced: e.isSynced,
    )).toList();
  }

  Future<void> saveNote({
    required int surahNumber,
    required int ayahNumber,
    required String content,
  }) async {
    final isar = IsarService.instance.isar;
    final noteId = '${surahNumber}_$ayahNumber';
    final existing = await isar.noteCollections.filter().noteIdEqualTo(noteId).findFirst();

    await isar.writeTxn(() async {
      final now = DateTime.now();
      final item = NoteCollection(
        noteId: noteId,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        content: content,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        isSynced: false,
      );
      if (existing != null) {
        item.id = existing.id;
      }
      await isar.noteCollections.put(item);
    });

    await _load();
  }

  Future<void> deleteNote(int surahNumber, int ayahNumber) async {
    final isar = IsarService.instance.isar;
    final noteId = '${surahNumber}_$ayahNumber';
    final existing = await isar.noteCollections.filter().noteIdEqualTo(noteId).findFirst();

    if (existing != null) {
      await isar.writeTxn(() async {
        await isar.noteCollections.delete(existing.id);
      });
      await _load();
    }
  }

  LocalNote? getNote(int surahNumber, int ayahNumber) {
    try {
      return state.firstWhere(
        (n) => n.surahNumber == surahNumber && n.ayahNumber == ayahNumber,
      );
    } catch (_) {
      return null;
    }
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<LocalNote>>((ref) {
  return NotesNotifier();
});
