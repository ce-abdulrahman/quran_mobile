import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/surah_model.dart';
import '../quran/quran_providers.dart';
import 'memorization_providers.dart';
import 'quiz_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Memorization Quiz Page
// ─────────────────────────────────────────────────────────────────────────────

class MemorizationQuizPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const MemorizationQuizPage({super.key, this.showBackButton = false});

  @override
  ConsumerState<MemorizationQuizPage> createState() => _MemorizationQuizPageState();
}

class _MemorizationQuizPageState extends ConsumerState<MemorizationQuizPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Custom Quiz Settings
  SurahModel? _selectedSurah;
  int _questionCount = 10;
  String _quizType = 'continue'; // 'continue' or 'guess_surah'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startCustomQuiz(List<SurahModel> allSurahs) async {
    if (_selectedSurah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.memorizationQuizSelectSurah,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Fetch Ayahs for the selected Surah
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final ayahs = await ref.read(ayahsProvider(_selectedSurah!.id).future);
      if (mounted) Navigator.pop(context); // Close loading dialog

      if (ayahs.isEmpty) {
        throw Exception("No ayahs found in this surah");
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              surah: _selectedSurah!,
              ayahs: ayahs,
              allSurahs: allSurahs,
              questionCount: _questionCount,
              quizType: _quizType,
              planItem: null,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog if open
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('کێشەیەک ڕوویدا لە بارکردنی ئایەتەکان: $e', style: const TextStyle(fontFamily: 'Cairo')),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _startPlanQuiz(MemorizationItemModel item, List<SurahModel> allSurahs) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final allAyahs = await ref.read(ayahsProvider(item.surahId).future);
      if (mounted) Navigator.pop(context); // Close loading dialog

      // Filter ayahs within the plan range
      final rangeAyahs = allAyahs.where((a) {
        final fromNum = item.fromAyah?.ayahNumber ?? 1;
        final toNum = item.toAyah?.ayahNumber ?? 1;
        return a.ayahNumber >= fromNum && a.ayahNumber <= toNum;
      }).toList();

      if (rangeAyahs.isEmpty) {
        throw Exception("No ayahs found in the specified range");
      }

      final surah = item.surah ?? allSurahs.firstWhere((s) => s.id == item.surahId);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              surah: surah,
              ayahs: rangeAyahs,
              allSurahs: allSurahs,
              questionCount: rangeAyahs.length - 1 <= 0 ? 1 : rangeAyahs.length,
              quizType: 'continue',
              planItem: item,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('کێشەیەک ڕوویدا لە بارکردنی ئایەتەکان: $e', style: const TextStyle(fontFamily: 'Cairo')),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          l.memorizationQuizTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600, fontSize: 14),
          tabs: [
            Tab(text: l.memorizationQuizSurahTab),
            Tab(text: l.memorizationQuizPlanTab),
          ],
        ),
      ),
      body: surahsAsync.when(
        data: (surahs) {
          if (_selectedSurah == null && surahs.isNotEmpty) {
            _selectedSurah = surahs.first;
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildSurahQuizTab(cs, l, surahs),
              _buildPlanQuizTab(cs, l, surahs),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'هەڵەیەک ڕوویدا لە بارکردنی سورەتەکان: $err',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahQuizTab(AppColorScheme cs, AppLocalizations l, List<SurahModel> surahs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Illustration
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary.withValues(alpha: 0.15), cs.primaryDeep.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
            ),
            child: Column(
              children: [
                Icon(Icons.psychology_rounded, size: 48, color: cs.primary),
                const SizedBox(height: 12),
                Text(
                  'توانای لەبەرکردنی ئایەتەکان تاقی بکەرەوە',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'سورەتێک و جۆری تاقیکردنەوەکە دیاری بکە بۆ دەستپێکردن',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: cs.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Surah Selector Card
          Text(
            l.memorizationQuizSelectSurah,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: cs.textPrimary),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: cs.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SurahModel>(
                value: _selectedSurah,
                isExpanded: true,
                dropdownColor: cs.card,
                items: surahs.map((surah) {
                  return DropdownMenuItem(
                    value: surah,
                    child: Text(
                      '${surah.number}. ${surah.nameAr} (${surah.nameEn})',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: cs.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedSurah = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quiz Type Selection is hidden in V1. Default is 'continue'.
          const SizedBox(height: 8),

          // Question Count Choice
          Text(
            '${l.memorizationQuizSelectQuestions}: $_questionCount',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: cs.textPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [5, 10, 15, 20].map((count) {
              final active = count == _questionCount;
              return GestureDetector(
                onTap: () => setState(() => _questionCount = count),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? cs.primary : cs.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: active ? cs.primary : cs.cardBorder),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : cs.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 36),

          // Start Button
          ElevatedButton(
            onPressed: () => _startCustomQuiz(surahs),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(
              l.memorizationQuizStart,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPlanQuizTab(AppColorScheme cs, AppLocalizations l, List<SurahModel> surahs) {
    final todayPlansAsync = ref.watch(memorizationTodayProvider);

    return todayPlansAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_rounded, size: 64, color: cs.textSecondary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    l.memorizationQuizNoPlan,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تکایە سەرەتا پلانێکی پاراستن لە ئەدمین پانێڵ دروست بکە بۆ ئەوەی ڕۆژانە تاقیکردنەوە بکەیت.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: cs.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final matchedSurah = surahs.firstWhere((s) => s.id == item.surahId, orElse: () => surahs.first);
            final fromNum = item.fromAyah?.ayahNumber ?? 1;
            final toNum = item.toAyah?.ayahNumber ?? 1;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _startPlanQuiz(item, surahs),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text(
                      'دەستپێکردن',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        matchedSurah.nameAr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ئایەتی $fromNum تا $toNum — ڕۆژی ${item.dayNumber}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 54, color: cs.textSecondary.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text(
                l.memorizationQuizConnectError,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
