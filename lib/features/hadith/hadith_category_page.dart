import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/hadith_provider.dart';

class HadithCategoryPage extends StatelessWidget {
  final HadithCategory category;

  const HadithCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          category.nameKu,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: category.hadiths.isEmpty
          ? Center(
              child: Text(
                'هیچ فەرموودەیەک لەم هاوپۆلەدا نییە',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: cs.textSecondary,
                  fontSize: 14,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: category.hadiths.length,
              itemBuilder: (context, index) {
                final hadith = category.hadiths[index];
                return HadithCard(hadith: hadith, cs: cs);
              },
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hadith Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class HadithCard extends StatefulWidget {
  final HadithItem hadith;
  final AppColorScheme cs;

  const HadithCard({super.key, required this.hadith, required this.cs});

  @override
  State<HadithCard> createState() => HadithCardState();
}

class HadithCardState extends State<HadithCard> {
  bool _isExpanded = false;

  void _copyToClipboard() {
    final textToCopy = '${widget.hadith.narrator != null ? "${widget.hadith.narrator}\n" : ""}'
        '${widget.hadith.arabicText}\n\n'
        'وەرگێڕان:\n${widget.hadith.translationKu}'
        '${widget.hadith.source != null ? "\n\nسەرچاوە: ${widget.hadith.source}" : ""}';

    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'فەرموودەکە بە سەرکەوتوویی کۆپیکرا',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: widget.cs.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareHadith() {
    final textToShare = '${widget.hadith.narrator != null ? "${widget.hadith.narrator}\n" : ""}'
        '${widget.hadith.arabicText}\n\n'
        'وەرگێڕان:\n${widget.hadith.translationKu}'
        '${widget.hadith.source != null ? "\n\nسەرچاوە: ${widget.hadith.source}" : ""}';

    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    final hasExplanation = widget.hadith.explanationKu != null && widget.hadith.explanationKu!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.cs.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: widget.cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Narrator (Arabic or Kurdish)
          if (widget.hadith.narrator != null && widget.hadith.narrator!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.hadith.narrator!,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: widget.cs.textSecondary,
                ),
              ),
            ),

          // Arabic Text (Centered and bold, with premium Uthmani font styling)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              widget.hadith.arabicText,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.cs.textPrimary,
                height: 1.6,
              ),
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Divider(color: widget.cs.cardBorder, height: 1),
          ),

          // Kurdish Translation
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Text(
              widget.hadith.translationKu,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: widget.cs.textPrimary,
                height: 1.5,
              ),
            ),
          ),

          // Footer (Source tag, actions, explanation toggle)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Source
                if (widget.hadith.source != null && widget.hadith.source!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.cs.textSecondary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: widget.cs.cardBorder),
                    ),
                    child: Text(
                      widget.hadith.source!,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: widget.cs.textSecondary,
                      ),
                    ),
                  )
                else
                  const SizedBox(),

                // Action Row (Copy, Share, Explanation)
                Row(
                  children: [
                    // Copy button
                    IconButton(
                      icon: Icon(Icons.copy_all_rounded, color: widget.cs.textSecondary, size: 20),
                      onPressed: _copyToClipboard,
                      tooltip: 'کۆپیکردن',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),
                    const SizedBox(width: 8),

                    // Share button
                    IconButton(
                      icon: Icon(Icons.share_rounded, color: widget.cs.textSecondary, size: 20),
                      onPressed: _shareHadith,
                      tooltip: 'بڵاوکردنەوە',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),

                    if (hasExplanation) ...[
                      const SizedBox(width: 8),
                      // Explanation Toggle
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isExpanded ? widget.cs.primary : widget.cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'شیکردنەوە',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _isExpanded ? Colors.white : widget.cs.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                size: 14,
                                color: _isExpanded ? Colors.white : widget.cs.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Animated Collapsible Explanation Box
          if (hasExplanation)
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.cs.primary.withValues(alpha: 0.03),
                  border: Border(
                    top: BorderSide(color: widget.cs.cardBorder),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: widget.cs.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'شیکردنەوە و وانەکان',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.cs.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.hadith.explanationKu!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: widget.cs.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
        ],
      ),
    );
  }
}
