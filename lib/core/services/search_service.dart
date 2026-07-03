import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import '../local_db/content_package.dart';

class SearchService {
  static final SearchService instance = SearchService._();
  SearchService._();

  Isar get _isar => IsarService.instance.isar;

  /// Rebuilds the search index for a specific package type.
  Future<void> rebuildIndex(ContentPackage package) async {
    final String typeStr = _getTypeStr(package);
    if (typeStr.isEmpty) return;

    // Delete existing index entries for this type
    await _isar.writeTxn(() async {
      await _isar.searchIndexCollections.filter().typeEqualTo(typeStr).deleteAll();
    });

    final List<SearchIndexCollection> newEntries = [];

    switch (package) {
      case ContentPackage.quran:
        final ayahs = await _isar.ayahCollections.where().findAll();
        final surahs = await _isar.surahCollections.where().findAll();
        final surahMap = {for (final s in surahs) s.number: s};

        for (final a in ayahs) {
          final surah = surahMap[a.surahNumber];
          final surahNameKu = surah?.nameKu ?? 'سورەتی ${a.surahNumber}';
          final title = 'ئاڕاستەی ئایەت - $surahNameKu';
          final subtitle = 'سورەتی ${a.surahNumber} ئایەتی ${a.ayahNumber} - لاپەڕە ${a.pageNumber ?? 1}';

          // Combine Arabic, Kurdish and English texts for full-text search
          final content = '${a.textUthmani} ${a.textKu ?? ''} ${a.textEn ?? ''}';

          newEntries.add(SearchIndexCollection(
            key: 'ayah_${a.surahNumber}_${a.ayahNumber}',
            type: 'ayah',
            language: 'all',
            weight: 100,
            title: title,
            subtitle: subtitle,
            content: content,
            surahNumber: a.surahNumber,
            ayahNumber: a.ayahNumber,
          ));
        }
        break;

      case ContentPackage.hadith:
        final hadiths = await _isar.hadithCollections.where().findAll();
        for (final h in hadiths) {
          final title = 'فەرموودە - ${h.categoryNameKu}';
          final subtitle = 'سەرچاوە: ${h.source ?? 'نادیار'} • گێڕاوەتەوە لە لایەن: ${h.narrator ?? 'نادیار'}';
          final content = '${h.arabicText} ${h.translationKu} ${h.translationEn ?? ''} ${h.explanationKu ?? ''}';

          newEntries.add(SearchIndexCollection(
            key: 'hadith_${h.hadithId}',
            type: 'hadith',
            language: 'all',
            weight: 90,
            title: title,
            subtitle: subtitle,
            content: content,
            categoryId: h.categoryId,
            referenceId: h.slug,
          ));
        }
        break;

      case ContentPackage.adhkar:
        final adhkars = await _isar.adhkarCollections.where().findAll();
        for (final a in adhkars) {
          final title = 'زیکر - ${a.categoryNameKu}';
          final subtitle = a.description?.isNotEmpty == true ? a.description! : 'فەزڵ و سوودەکەی';
          final content = '${a.arabicText} ${a.translationKu} ${a.translationEn ?? ''} ${a.description ?? ''}';

          newEntries.add(SearchIndexCollection(
            key: 'adhkar_${a.adhkarId}',
            type: 'adhkar',
            language: 'all',
            weight: 70,
            title: title,
            subtitle: subtitle,
            content: content,
            categoryId: a.categoryId,
            referenceId: 'adhkar-${a.adhkarId}',
          ));
        }
        break;

      case ContentPackage.seerah:
        final seerahList = await _isar.seerahCollections.where().findAll();
        for (final s in seerahList) {
          final title = 'ژیاننامەی پێغەمبەر ﷺ - ${s.titleKu}';
          final subtitle = 'سەردەم: ${s.period}';
          final content = '${s.titleAr} ${s.titleKu} ${s.contentMd}';

          newEntries.add(SearchIndexCollection(
            key: 'seerah_${s.seerahId}',
            type: 'seerah',
            language: 'ku',
            weight: 80,
            title: title,
            subtitle: subtitle,
            content: content,
            referenceId: s.slug,
          ));
        }
        break;

      case ContentPackage.sahaba:
        final sahabaList = await _isar.sahabaCollections.where().findAll();
        for (final s in sahabaList) {
          final title = 'ژیاننامەی هاوەڵان - ${s.nameKu}';
          final subtitle = s.epithetKu;
          final content = '${s.nameAr} ${s.nameKu} ${s.summaryKu} ${s.biographyMd} ${s.virtuesKu}';

          newEntries.add(SearchIndexCollection(
            key: 'sahaba_${s.sahabaId}',
            type: 'sahaba',
            language: 'ku',
            weight: 80,
            title: title,
            subtitle: subtitle,
            content: content,
            referenceId: s.slug,
          ));
        }
        break;

      case ContentPackage.allah_names:
        final names = await _isar.namesOfAllahCollections.where().findAll();
        for (final n in names) {
          final title = 'ناوی خودا - ${n.nameKu} (${n.nameAr})';
          final subtitle = 'واتا: ${n.meaningKu}';
          final content = '${n.nameAr} ${n.nameKu} ${n.meaningKu} ${n.meaningEn} ${n.verseAr} ${n.verseKu} ${n.virtueKu}';

          newEntries.add(SearchIndexCollection(
            key: 'allah_name_${n.nameId}',
            type: 'allah_name',
            language: 'all',
            weight: 80,
            title: title,
            subtitle: subtitle,
            content: content,
            referenceId: n.slug,
          ));
        }
        break;

      case ContentPackage.tafsir:
        final tafsirs = await _isar.tafsirCollections.where().findAll();
        for (final t in tafsirs) {
          final title = 'تەفسیری تەفسیری کوردی';
          final subtitle = 'سەرچاوە: سورەتی ${t.surahNumber} ئایەتی ${t.ayahNumber}';
          final content = t.text;

          newEntries.add(SearchIndexCollection(
            key: 'tafsir_${t.surahNumber}_${t.ayahNumber}',
            type: 'tafsir',
            language: 'ku',
            weight: 80,
            title: title,
            subtitle: subtitle,
            content: content,
            surahNumber: t.surahNumber,
            ayahNumber: t.ayahNumber,
          ));
        }
        break;

      default:
        // Other package types like translations, audio_metadata, etc., are not search-indexed
        return;
    }

    if (newEntries.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.searchIndexCollections.putAll(newEntries);
      });
    }
  }

  /// Rebuilds index for a note item when it is updated or created.
  Future<void> indexNote(NoteCollection note) async {
    final title = 'تێبینییەکانت - سورەتی ${note.surahNumber} ئایەتی ${note.ayahNumber}';
    final subtitle = note.content.length > 50 ? '${note.content.substring(0, 47)}...' : note.content;

    await _isar.writeTxn(() async {
      await _isar.searchIndexCollections.put(SearchIndexCollection(
        key: 'note_${note.noteId}',
        type: 'note',
        language: 'all',
        weight: 110,
        title: title,
        subtitle: subtitle,
        content: note.content,
        surahNumber: note.surahNumber,
        ayahNumber: note.ayahNumber,
        referenceId: note.noteId,
      ));
    });
  }

  /// Removes a note from the search index.
  Future<void> removeNoteIndex(String noteId) async {
    await _isar.writeTxn(() async {
      await _isar.searchIndexCollections.filter().keyEqualTo('note_$noteId').deleteAll();
    });
  }

  /// Rebuilds indexes for all packages.
  Future<void> rebuildAll() async {
    for (final pkg in ContentPackage.values) {
      await rebuildIndex(pkg);
    }
    // Also index existing user notes
    final notes = await _isar.noteCollections.where().findAll();
    for (final n in notes) {
      await indexNote(n);
    }
  }

  String _getTypeStr(ContentPackage pkg) {
    switch (pkg) {
      case ContentPackage.quran:
        return 'ayah';
      case ContentPackage.hadith:
        return 'hadith';
      case ContentPackage.adhkar:
        return 'adhkar';
      case ContentPackage.seerah:
        return 'seerah';
      case ContentPackage.sahaba:
        return 'sahaba';
      case ContentPackage.allah_names:
        return 'allah_name';
      case ContentPackage.tafsir:
        return 'tafsir';
      default:
        return '';
    }
  }
}
