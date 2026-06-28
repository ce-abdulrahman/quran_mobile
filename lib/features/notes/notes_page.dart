import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/notes_provider.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/l10n/app_localizations.dart';
import 'package:isar/isar.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  Map<int, String> _surahNames = {};

  @override
  void initState() {
    super.initState();
    _loadSurahNames();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSurahNames() async {
    try {
      final isar = IsarService.instance.isar;
      final surahs = await isar.surahCollections.where().findAll();
      setState(() {
        _surahNames = {for (var s in surahs) s.number: s.nameKu};
      });
    } catch (_) {}
  }

  String _getRefText(BuildContext context, int surahNum, int ayahNum) {
    final l = context.l10n;
    if (surahNum == 0 || ayahNum == 0) return l.notesGeneralNote;
    final surahName = _surahNames[surahNum] ?? l.notesSurahNum(surahNum);
    return '$surahName ($surahNum:$ayahNum)';
  }

  void _showNoteDialog({LocalNote? note}) {
    final contentCtrl = TextEditingController(text: note?.content ?? '');
    final isEdit = note != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final cs = AppColorScheme.of(context);
        final l = context.l10n;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: cs.card,
          title: Text(
            isEdit ? l.notesEditTitle : l.notesNewTitle,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: cs.textPrimary,
              fontSize: 16,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxHeight: 250),
            child: TextField(
              controller: contentCtrl,
              maxLines: 8,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Cairo', color: cs.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: l.notesHintText,
                hintStyle: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary.withValues(alpha: 0.6), fontSize: 13),
                hintTextDirection: TextDirection.rtl,
                filled: true,
                fillColor: cs.bg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.primary, width: 1.5),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l.notesCancel,
                style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary, fontSize: 12),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final txt = contentCtrl.text.trim();
                if (txt.isNotEmpty) {
                  await ref.read(notesProvider.notifier).saveNote(
                        surahNumber: note?.surahNumber ?? 0,
                        ayahNumber: note?.ayahNumber ?? 0,
                        content: txt,
                        noteId: note?.noteId,
                      );
                  if (mounted) Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                l.notesSave,
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allNotes = ref.watch(notesProvider);

    // Apply local search filtering
    final notes = allNotes.where((n) {
      if (_query.isEmpty) return true;
      final matchContent = n.content.toLowerCase().contains(_query.toLowerCase());
      final matchRef = _getRefText(context, n.surahNumber, n.ayahNumber)
          .toLowerCase()
          .contains(_query.toLowerCase());
      return matchContent || matchRef;
    }).toList();

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.notesPageTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        backgroundColor: cs.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Premium Header decoration
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColorScheme.darken(cs.primary, 0.35), AppColorScheme.darken(cs.primary, 0.45)]
                    : [cs.primary, cs.primaryDeep],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Search field
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: isDark ? Colors.white : cs.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: l.notesSearchHint,
                      hintStyle: TextStyle(
                        fontFamily: 'Cairo',
                        color: isDark ? Colors.white70 : cs.textSecondary,
                        fontSize: 13,
                      ),
                      hintTextDirection: TextDirection.rtl,
                      prefixIcon: Icon(Icons.search_rounded, color: isDark ? Colors.white70 : cs.textSecondary),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, color: isDark ? Colors.white70 : cs.textSecondary),
                              onPressed: () {
                                _searchCtrl.clear();
                                  setState(() {
                                    _query = '';
                                  });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _query = val.trim();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notes List View
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 64,
                          color: cs.textSecondary.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _query.isNotEmpty ? l.notesEmptySearch : l.notesEmptyList,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: cs.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_query.isEmpty)
                          Text(
                            l.notesEmptyHint,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: cs.textSecondary.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isGeneral = note.surahNumber == 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: cs.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cs.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.015),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showNoteDialog(note: note),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Category Header Tag / Metadata
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Ref tag
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isGeneral
                                              ? Colors.amber.withValues(alpha: 0.1)
                                              : cs.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isGeneral ? Icons.notes_rounded : Icons.menu_book_rounded,
                                              size: 14,
                                              color: isGeneral ? Colors.amber[800] : cs.primary,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              _getRefText(context, note.surahNumber, note.ayahNumber),
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isGeneral ? Colors.amber[800] : cs.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Actions (Delete / Edit)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400], size: 18),
                                            onPressed: () async {
                                              // Confirm delete
                                              final deleteConfirm = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text(l.notesDeleteTitle, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold)),
                                                  content: Text(l.notesDeleteConfirm, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: Text(l.notesDeleteNo, style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      child: Text(l.notesDeleteYes, style: const TextStyle(fontFamily: 'Cairo', color: Colors.red, fontWeight: FontWeight.bold)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (deleteConfirm == true) {
                                                await ref.read(notesProvider.notifier).deleteNoteById(note.noteId);
                                              }
                                            },
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(4),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Content
                                  Text(
                                    note.content,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: cs.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Date
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.access_time_rounded, size: 12, color: cs.textSecondary.withValues(alpha: 0.6)),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${l.notesUpdatedAt} ${_formatDate(note.updatedAt)}',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 10,
                                          color: cs.textSecondary.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate(delay: (index * 60).ms).fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}/${dt.month}/${dt.day}';
  }
}
