import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/surah_model.dart';
import '../../core/models/ayah_model.dart';
import 'memorization_providers.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<Map<String, dynamic>> wrongAnswers;
  final String quizType;
  final SurahModel surah;
  final bool syncSuccess;
  final MemorizationItemModel? planItem;
  final List<AyahModel> ayahs;
  final List<SurahModel> allSurahs;
  final List<UserAyahProgressModel>? progressList;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.wrongAnswers,
    required this.quizType,
    required this.surah,
    required this.syncSuccess,
    this.planItem,
    required this.ayahs,
    required this.allSurahs,
    this.progressList,
  });

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final double percent = total > 0 ? score / total : 0.0;

    String feedbackText;
    IconData feedbackIcon;
    Color feedbackColor;

    if (percent == 1.0) {
      feedbackText = "ماشاءاللە! نایابە، هیچ هەڵەیەکت نەبوو.";
      feedbackIcon = Icons.emoji_events_rounded;
      feedbackColor = const Color(0xFFCD9D27); // Gold
    } else if (percent >= 0.8) {
      feedbackText = "دەست خۆش! زۆر باشە، تا ڕادەیەکی زۆر باش لەبەرتە.";
      feedbackIcon = Icons.thumb_up_alt_rounded;
      feedbackColor = const Color(0xFF1AB66D); // Green
    } else if (percent >= 0.5) {
      feedbackText = "باشە، بەڵام پێویستت بە پێداچوونەوەی زیاترە.";
      feedbackIcon = Icons.auto_stories_rounded;
      feedbackColor = const Color(0xFFF57F17); // Amber
    } else {
      feedbackText = "هەوڵ بدە زیاتر پێداچوونەوە بکەیت و دووبارە تاقی بکەرەوە.";
      feedbackIcon = Icons.refresh_rounded;
      feedbackColor = const Color(0xFFE53935); // Red
    }

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: cs.bg,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          l.memorizationQuizTitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: cs.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Score Progress Card
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
                      child: Column(
                        children: [
                          // Animating/Sleek Circle score
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  value: percent,
                                  strokeWidth: 10,
                                  backgroundColor: cs.divider.withValues(alpha: 0.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(feedbackColor),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$score / $total',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: cs.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${(percent * 100).toInt()}%',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: cs.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Icon(feedbackIcon, size: 36, color: feedbackColor),
                          const SizedBox(height: 10),
                          Text(
                            feedbackText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: cs.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sync status card
                    _buildSyncStatusCard(context, cs),
                    const SizedBox(height: 16),

                    if (progressList != null && progressList!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cs.card,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: cs.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.schedule_rounded, color: cs.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'خشتەی پێداچوونەوە (Spaced Repetition)',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: cs.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...progressList!.map((progress) {
                              String levelKu = progress.masteryLevel;
                              if (progress.masteryLevel == 'mastered') levelKu = 'لەبەرکراو';
                              if (progress.masteryLevel == 'reviewing') levelKu = 'پێداچوونەوە';
                              if (progress.masteryLevel == 'learning') levelKu = 'خوێندن';
                              
                              final nextDate = progress.nextReviewDate ?? 'سبەی';
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: cs.bg.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ئایەتی ${progress.ayahId}',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: cs.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'ئاست: $levelKu • پێداچوونەوە: $nextDate',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        color: progress.masteryLevel == 'mastered' ? const Color(0xFF10B981) : cs.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Quiz Details Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.cardBorder),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            context: context,
                            cs: cs,
                            title: 'سورەت',
                            value: surah.nameAr,
                            isArValue: true,
                          ),
                          const Divider(height: 20),
                          _buildDetailRow(
                            context: context,
                            cs: cs,
                            title: 'جۆری تاقیکردنەوە',
                            value: quizType == 'guess_surah' ? 'دۆزینەوەی سورەت' : 'بەردەوامی ئایەت',
                            isArValue: false,
                          ),
                          if (planItem != null) ...[
                            const Divider(height: 20),
                            _buildDetailRow(
                              context: context,
                              cs: cs,
                              title: 'پلان',
                              value: 'ڕۆژی ${planItem!.dayNumber} (ئایەتی ${planItem!.fromAyah?.ayahNumber ?? 1} تا ${planItem!.toAyah?.ayahNumber ?? 1})',
                              isArValue: false,
                            ),
                          ]
                        ],
                      ),
                    ),

                    // Mistakes breakdown
                    if (wrongAnswers.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            l.memorizationQuizWrongAnswers,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cs.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: wrongAnswers.length,
                        itemBuilder: (context, index) {
                          final wrong = wrongAnswers[index];
                          final questionText = wrong['questionText'] as String;
                          final correctAnswer = wrong['correctAnswer'] as String;
                          final userAnswer = wrong['userAnswer'] as String;
                          final ayah = wrong['ayah'] as AyahModel;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cs.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: cs.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ئایەتی ${ayah.ayahNumber}',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                        color: cs.textSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'پرسیاری ${index + 1}',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                        color: cs.textSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  questionText,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'UthmanicHafs',
                                    fontSize: 18,
                                    height: 1.6,
                                    color: cs.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(height: 1),
                                const SizedBox(height: 12),
                                // User wrong answer
                                _buildAnswerResultRow(
                                  label: 'وەڵامی تۆ:',
                                  text: userAnswer,
                                  isCorrect: false,
                                  isArabic: quizType != 'guess_surah',
                                  cs: cs,
                                ),
                                const SizedBox(height: 8),
                                // Correct answer
                                _buildAnswerResultRow(
                                  label: 'وەڵامی ڕاست:',
                                  text: correctAnswer,
                                  isCorrect: true,
                                  isArabic: quizType != 'guess_surah',
                                  cs: cs,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Pop all the way back to the dashboard/home
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: cs.divider),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        l.memorizationQuizGoHome,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Restart quiz screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              surah: surah,
                              ayahs: ayahs,
                              allSurahs: allSurahs,
                              questionCount: total,
                              quizType: quizType,
                              planItem: planItem,
                              targetAyahIds: progressList?.map((e) => e.ayahId).toList(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        l.memorizationQuizRetry,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(BuildContext context, AppColorScheme cs) {
    if (planItem == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cs.divider.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'تاقیکردنەوەی سەربەخۆ (ئۆفلاین)',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: cs.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.offline_bolt_rounded, size: 18, color: cs.textSecondary),
          ],
        ),
      );
    }

    final success = syncSuccess;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: success ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: success ? const Color(0xFFC8E6C9) : const Color(0xFFFFCDD2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            success ? 'پێشکەوتنەکانت بە سەرکەوتوویی لەگەڵ سێرڤەر هاوکات کران' : 'کێشە لە هاوکاتکردن لەگەڵ سێرڤەر ڕوویدا',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: success ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            success ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            size: 18,
            color: success ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required AppColorScheme cs,
    required String title,
    required String value,
    required bool isArValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          textDirection: isArValue ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(
            fontFamily: isArValue ? 'UthmanicHafs' : 'Cairo',
            fontSize: isArValue ? 16 : 13,
            fontWeight: FontWeight.bold,
            color: cs.textPrimary,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: cs.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerResultRow({
    required String label,
    required String text,
    required bool isCorrect,
    required bool isArabic,
    required AppColorScheme cs,
  }) {
    final statusColor = isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: isArabic ? 'UthmanicHafs' : 'Cairo',
              fontSize: isArabic ? 16 : 13,
              fontWeight: isArabic ? FontWeight.normal : FontWeight.bold,
              height: 1.5,
              color: statusColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: cs.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
