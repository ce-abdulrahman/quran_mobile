import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/surah_model.dart';
import '../quran_providers.dart';
import '../quran_reader_page.dart';
import '../mushaf_reader_page.dart';

class QuranJumpDialog extends ConsumerStatefulWidget {
  const QuranJumpDialog({super.key});

  @override
  ConsumerState<QuranJumpDialog> createState() => _QuranJumpDialogState();
}

class _QuranJumpDialogState extends ConsumerState<QuranJumpDialog> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final surahsAsync = ref.watch(surahListProvider);

    return Dialog(
      backgroundColor: cs.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.travel_explore_rounded, color: cs.primary, size: 24),
                const SizedBox(width: 10),
                Text(
                  l.quickJump,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: cs.textSecondary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cs.bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.cardBorder),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (v) => setState(() => _query = v),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: cs.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: l.jumpHint,
                  hintStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: cs.textSecondary,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: cs.primary, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: surahsAsync.when(
                data: (surahs) {
                  final results = _search(surahs);
                  if (results.isEmpty) {
                    return Center(
                      child: Text(
                        l.searchNoResults,
                        style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: results.length,
                    separatorBuilder: (_, __) => Divider(color: cs.cardBorder, height: 1),
                    itemBuilder: (context, idx) {
                      final item = results[idx];
                      return ListTile(
                        dense: true,
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: item.isPage ? 'Cairo' : 'UthmanicHafs',
                            fontWeight: FontWeight.bold,
                            fontSize: item.isPage ? 14 : 18,
                            color: cs.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          item.subtitle,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: cs.textSecondary,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right_rounded, color: cs.primary),
                        onTap: () {
                          Navigator.pop(context);
                          if (item.isPage) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MushafReaderPage(initialPage: item.pageNumber),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuranReaderPage(
                                  surah: item.surah!,
                                  initialAyahNumber: item.ayahNumber,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(e.toString(), style: const TextStyle(fontFamily: 'Cairo')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_JumpResult> _search(List<SurahModel> surahs) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      return surahs.take(5).map((s) => _JumpResult.fromSurah(s)).toList();
    }

    // 1. Parse Surah:Ayah pattern (e.g. "2:255" or "2 : 255")
    if (q.contains(':')) {
      final parts = q.split(':');
      if (parts.length == 2) {
        final surahNum = int.tryParse(parts[0].trim());
        final ayahNum = int.tryParse(parts[1].trim());
        if (surahNum != null && ayahNum != null) {
          final surah = surahs.firstWhere((s) => s.number == surahNum, orElse: () => surahs.first);
          if (surah.number == surahNum && ayahNum >= 1 && ayahNum <= surah.totalAyahs) {
            return [_JumpResult.fromAyah(surah, ayahNum)];
          }
        }
      }
    }

    // 2. Parse Juz pattern (e.g. "juz 15", "جزء 15", "j 15")
    final juzRegex = RegExp(r'(juz|j|جزء)\s*(\d+)', caseSensitive: false);
    final juzMatch = juzRegex.firstMatch(q);
    if (juzMatch != null) {
      final juzNum = int.tryParse(juzMatch.group(2) ?? '');
      if (juzNum != null && juzNum >= 1 && juzNum <= 30) {
        // Juz start pages
        const juzStartPages = [
          1, 22, 42, 62, 82, 102, 122, 142, 162, 182,
          202, 222, 242, 262, 282, 302, 322, 342, 362, 382,
          402, 422, 442, 462, 482, 502, 522, 542, 562, 582
        ];
        return [_JumpResult.fromJuz(juzNum, juzStartPages[juzNum - 1])];
      }
    }

    // 3. Parse Page number
    final pageNum = int.tryParse(q);
    if (pageNum != null && pageNum >= 1 && pageNum <= 604) {
      return [_JumpResult.fromPage(pageNum)];
    }

    // 4. Default Surah search matches
    final matches = surahs.where((s) {
      return s.nameEn.toLowerCase().contains(q) ||
          s.nameAr.contains(q) ||
          s.nameKu.contains(q) ||
          s.number.toString() == q;
    }).map((s) => _JumpResult.fromSurah(s)).toList();

    return matches;
  }
}

class _JumpResult {
  final String title;
  final String subtitle;
  final bool isPage;
  final int pageNumber;
  final SurahModel? surah;
  final int? ayahNumber;

  _JumpResult({
    required this.title,
    required this.subtitle,
    required this.isPage,
    required this.pageNumber,
    this.surah,
    this.ayahNumber,
  });

  factory _JumpResult.fromSurah(SurahModel surah) {
    return _JumpResult(
      title: surah.nameAr,
      subtitle: '${surah.nameEn} — ${surah.number} | ${surah.totalAyahs} ئایەت',
      isPage: false,
      pageNumber: surah.pageStart ?? 1,
      surah: surah,
    );
  }

  factory _JumpResult.fromPage(int pageNum) {
    return _JumpResult(
      title: 'لاپەڕەی $pageNum',
      subtitle: 'مۆدی پەیج (موسحەف)',
      isPage: true,
      pageNumber: pageNum,
    );
  }

  factory _JumpResult.fromAyah(SurahModel surah, int ayahNum) {
    return _JumpResult(
      title: '${surah.nameAr} ($ayahNum)',
      subtitle: '${surah.nameEn} — ئایەتی $ayahNum',
      isPage: false,
      pageNumber: surah.pageStart ?? 1,
      surah: surah,
      ayahNumber: ayahNum,
    );
  }

  factory _JumpResult.fromJuz(int juzNum, int startPage) {
    return _JumpResult(
      title: 'جزءی $juzNum',
      subtitle: 'دەستپێدەکات لە لاپەڕە $startPage',
      isPage: true,
      pageNumber: startPage,
    );
  }
}
