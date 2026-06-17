import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/surah_model.dart';
import '../../core/models/ayah_model.dart';
import 'memorization_providers.dart';
import 'quiz_result_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Quiz Screen Widget
// ─────────────────────────────────────────────────────────────────────────────

class QuizScreen extends ConsumerStatefulWidget {
  final SurahModel surah;
  final List<AyahModel> ayahs;
  final List<SurahModel> allSurahs;
  final int questionCount;
  final String quizType; // 'continue' or 'guess_surah'
  final MemorizationItemModel? planItem;
  final List<int>? targetAyahIds;

  const QuizScreen({
    super.key,
    required this.surah,
    required this.ayahs,
    required this.allSurahs,
    required this.questionCount,
    required this.quizType,
    this.planItem,
    this.targetAyahIds,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _answered = false;
  int _score = 0;
  final List<Map<String, dynamic>> _wrongAnswersList = [];
  bool _isSubmitting = false;
  late final DateTime _startedAt;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _generateQuestions();
  }

  void _generateQuestions() {
    final int count = min(widget.questionCount, widget.ayahs.length);

    if (widget.quizType == 'guess_surah') {
      // ── Guess the Surah Quiz ──
      final List<AyahModel> shuffledAyahs = List.from(widget.ayahs)..shuffle();
      final itemsToTake = min(count, shuffledAyahs.length);

      for (int i = 0; i < itemsToTake; i++) {
        final qAyah = shuffledAyahs[i];
        final correctSurahName = widget.surah.nameAr;

        // Pick 3 distractors from all Surahs
        final distractors = widget.allSurahs
            .where((s) => s.nameAr != correctSurahName)
            .map((s) => s.nameAr)
            .toList();
        distractors.shuffle();
        final options = [correctSurahName, ...distractors.take(3)];
        options.shuffle();

        _questions.add({
          'questionText': qAyah.textUthmani,
          'correctAnswer': correctSurahName,
          'options': options,
          'ayah': qAyah,
        });
      }
    } else {
      // ── Continue the Verse Quiz ──
      // Candidates are ayahs that have a next ayah in the list
      final List<int> candidateIndices = [];
      for (int i = 0; i < widget.ayahs.length - 1; i++) {
        if (widget.targetAyahIds != null) {
          if (widget.targetAyahIds!.contains(widget.ayahs[i].id)) {
            candidateIndices.add(i);
          }
        } else {
          candidateIndices.add(i);
        }
      }

      if (candidateIndices.isEmpty) {
        if (widget.targetAyahIds != null && widget.targetAyahIds!.isNotEmpty) {
          for (int i = 0; i < widget.ayahs.length; i++) {
            if (widget.targetAyahIds!.contains(widget.ayahs[i].id)) {
              candidateIndices.add(i);
            }
          }
        }
        if (candidateIndices.isEmpty) {
          candidateIndices.add(0);
        }
      }

      candidateIndices.shuffle();
      final itemsToTake = min(count, candidateIndices.length);

      for (int i = 0; i < itemsToTake; i++) {
        final idx = candidateIndices[i];
        final qAyah = widget.ayahs[idx];

        // Correct answer is the next ayah
        final hasNext = idx + 1 < widget.ayahs.length;
        final correctAyah = hasNext ? widget.ayahs[idx + 1] : qAyah;
        final correctAnswerText = correctAyah.textUthmani;

        // Pick 3 distractors
        List<String> distractors = [];
        final pool = widget.ayahs.where((a) => a.id != correctAyah.id).toList();

        if (pool.length >= 3) {
          pool.shuffle();
          distractors = pool.take(3).map((a) => a.textUthmani).toList();
        } else {
          // Fallback if not enough distractors
          final fallbackTexts = [
            "قُلْ هُوَ اللَّهُ أَحَدٌ",
            "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ",
            "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
            "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
            "قُلْ أَعُوذُ بِرَبِّ النَّاسِ"
          ];
          fallbackTexts.shuffle();
          distractors = fallbackTexts.take(3).toList();
        }

        final options = [correctAnswerText, ...distractors];
        options.shuffle();

        _questions.add({
          'questionText': qAyah.textUthmani,
          'correctAnswer': correctAnswerText,
          'options': options,
          'ayah': qAyah,
          'correctAyah': correctAyah,
        });
      }
    }
  }

  void _handleOptionTap(int index) {
    if (_answered) return;

    final currentQuestion = _questions[_currentIndex];
    final options = currentQuestion['options'] as List<String>;
    final isCorrect = options[index] == currentQuestion['correctAnswer'];

    setState(() {
      _selectedOptionIndex = index;
      _answered = true;
      if (isCorrect) {
        _score++;
        HapticFeedback.lightImpact();
      } else {
        _wrongAnswersList.add({
          'questionText': currentQuestion['questionText'],
          'correctAnswer': currentQuestion['correctAnswer'],
          'userAnswer': options[index],
          'ayah': currentQuestion['ayah'],
        });
        HapticFeedback.vibrate();
      }
    });
  }

  void _nextQuestion() async {
    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _answered = false;
      });
    } else {
      // Quiz Finished! Submit session and review data
      bool syncSuccess = false;
      setState(() => _isSubmitting = true);
      final repo = ref.read(memorizationRepositoryProvider);

      // If user passed, update the plan item status (if it was a plan quiz)
      final scorePercent = _questions.isEmpty ? 0.0 : _score / _questions.length;
      if (widget.planItem != null && scorePercent >= 0.8) {
        await repo.updateItemStatus(
          widget.planItem!.memorizationPlanId,
          widget.planItem!.id,
          'completed',
        );
        ref.invalidate(memorizationTodayProvider);
      }

      // Log the memorization session
      await repo.logSession(
        sessionType: 'quiz',
        status: 'completed',
        startedAt: _startedAt,
        endedAt: DateTime.now(),
        completedAt: DateTime.now(),
        durationSeconds: DateTime.now().difference(_startedAt).inSeconds,
        ayahsReviewed: _questions.length,
        ayahsMemorized: _wrongAnswersList.length < _questions.length ? (_questions.length - _wrongAnswersList.length) : 0,
        score: (_score * 10).clamp(0, 100),
      );

      // Post reviews for the wrong and right ayahs
      final List<UserAyahProgressModel> progressList = [];
      for (final q in _questions) {
        final isWrong = _wrongAnswersList.any((w) => w['questionText'] == q['questionText']);
        final resultStr = isWrong ? 'forgot' : 'perfect';
        final levelStr = isWrong ? 'learning' : 'reviewing';

        final ayah = q['ayah'] as AyahModel;
        final res = await repo.saveReview(
          ayahId: ayah.id,
          reviewLevel: levelStr,
          result: resultStr,
          notes: 'Quiz: $_score/${_questions.length}',
        );
        if (res != null) {
          progressList.add(res);
          syncSuccess = true;
        }
      }

      ref.invalidate(memorizationDashboardProvider);
      setState(() => _isSubmitting = false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizResultScreen(
              score: _score,
              total: _questions.length,
              wrongAnswers: _wrongAnswersList,
              quizType: widget.quizType,
              surah: widget.surah,
              syncSuccess: syncSuccess,
              planItem: widget.planItem,
              ayahs: widget.ayahs,
              allSurahs: widget.allSurahs,
              progressList: progressList,
            ),
          ),
        );
      }
    }
  }

  Future<void> _logInterruptedSession() async {
    final repo = ref.read(memorizationRepositoryProvider);
    final duration = DateTime.now().difference(_startedAt).inSeconds;
    await repo.logSession(
      sessionType: 'quiz',
      status: 'interrupted',
      startedAt: _startedAt,
      endedAt: null,
      completedAt: null,
      durationSeconds: duration,
      ayahsReviewed: _currentIndex,
      ayahsMemorized: 0,
      score: (_score * 10).clamp(0, 100),
    );
    ref.invalidate(memorizationDashboardProvider);
  }

  Future<bool> _onWillPop() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'دڵنیایت لە دەرچوون؟',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'پێشکەوتنەکانت خەزن ناکرێن ئەگەر ئێستا دەرچیت.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('نەخێر', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('بەڵێ', style: TextStyle(fontFamily: 'Cairo', color: Colors.red)),
          ),
        ],
      ),
    );
    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: cs.bg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentIndex];
    final options = currentQuestion['options'] as List<String>;
    final progress = (_currentIndex + 1) / _questions.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          await _logInterruptedSession();
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: cs.bg,
        appBar: AppBar(
          backgroundColor: cs.bg,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: cs.textPrimary),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                await _logInterruptedSession();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
          title: Text(
            'پرسیاری ${_currentIndex + 1} لە ${_questions.length}',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: cs.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: _isSubmitting
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'خەزنکردنی پێشکەوتنەکان لە سێرڤەر...',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Linear Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: cs.divider.withValues(alpha: 0.5),
                        color: cs.primary,
                        minHeight: 6,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Question Type Indicator
                          Text(
                            widget.quizType == 'guess_surah' ? 'ئەم ئایەتە لە کام سورەتەیە؟' : 'ئایەتی دواتر دیاری بکە:',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: cs.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Question Box (Arabic Script Card)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cs.card,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: cs.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Text(
                              currentQuestion['questionText'],
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'UthmanicHafs',
                                fontSize: 22,
                                height: 1.8,
                                color: cs.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 4 Choices List
                          ...List.generate(options.length, (i) {
                            final optionText = options[i];
                            final isSelected = _selectedOptionIndex == i;
                            final isCorrectOption = optionText == currentQuestion['correctAnswer'];

                            Color cardBg = cs.card;
                            Color borderCol = cs.cardBorder;
                            Color textCol = cs.textPrimary;

                            if (_answered) {
                              if (isCorrectOption) {
                                cardBg = const Color(0xFFE8F5E9);
                                borderCol = const Color(0xFF4CAF50);
                                textCol = const Color(0xFF2E7D32);
                              } else if (isSelected) {
                                cardBg = const Color(0xFFFFEBEE);
                                borderCol = const Color(0xFFEF5350);
                                textCol = const Color(0xFFC62828);
                              }
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _handleOptionTap(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderCol, width: 1.5),
                                  ),
                                  child: Text(
                                    optionText,
                                    textDirection: widget.quizType == 'guess_surah' ? TextDirection.rtl : TextDirection.rtl,
                                    textAlign: widget.quizType == 'guess_surah' ? TextAlign.right : TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: widget.quizType == 'guess_surah' ? 'Cairo' : 'UthmanicHafs',
                                      fontSize: widget.quizType == 'guess_surah' ? 14 : 17,
                                      fontWeight: widget.quizType == 'guess_surah' ? FontWeight.bold : FontWeight.normal,
                                      height: 1.6,
                                      color: textCol,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Button Panel
                  if (_answered)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentIndex + 1 == _questions.length ? l.memorizationQuizFinish : l.memorizationQuizNext,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
