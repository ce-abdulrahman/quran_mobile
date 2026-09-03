import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/tafsir_provider.dart';

/// Shows the tafsir for one ayah.
///
/// Tafsir ships as an optional downloadable package, so this has three real
/// states: installed with an entry for this ayah, installed without one, and
/// not installed at all. The last is not an error — it is what a fresh install
/// looks like, so it explains where to get the package instead of showing a
/// failure.
class TafsirSheet extends ConsumerWidget {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String? arabicText;

  const TafsirSheet({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    this.arabicText,
  });

  static Future<void> show(
    BuildContext context, {
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
    String? arabicText,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      isScrollControlled: true,
      builder: (_) => TafsirSheet(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
        arabicText: arabicText,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final tafsir = ref.watch(
      ayahTafsirProvider(
        AyahRef(surahNumber: surahNumber, ayahNumber: ayahNumber),
      ),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.card,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border.all(color: cs.cardBorder),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: cs.textSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                _Header(cs: cs, surahName: surahName, ayahNumber: ayahNumber),
                const SizedBox(height: 8),
                Divider(color: cs.divider, height: 1),
                Expanded(
                  child: tafsir.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                    error: (e, _) => _Message(
                      cs: cs,
                      icon: Icons.error_outline_rounded,
                      title: 'کێشەیەک ڕوویدا',
                      body: e.toString(),
                    ),
                    data: (result) => result.when(
                      // The package is not installed at all.
                      error: (message, _, __) => _Message(
                        cs: cs,
                        icon: Icons.cloud_download_outlined,
                        title: 'تەفسیر دانەگیراوە',
                        body: 'بۆ خوێندنەوەی تەفسیر، سەرەتا پاکێجی تەفسیر '
                            'دابگرە لە ڕێکخستنەکان › بەڕێوەبردنی داگرتن.',
                      ),
                      success: (entry) {
                        if (entry == null) {
                          return _Message(
                            cs: cs,
                            icon: Icons.menu_book_outlined,
                            title: 'تەفسیر بۆ ئەم ئایەتە نییە',
                            body: 'پاکێجی داگیراو تەفسیری ئەم ئایەتەی تێدا نییە.',
                          );
                        }
                        return _TafsirBody(
                          cs: cs,
                          scrollController: scrollController,
                          arabicText: arabicText,
                          text: entry.text,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final AppColorScheme cs;
  final String surahName;
  final int ayahNumber;

  const _Header({
    required this.cs,
    required this.surahName,
    required this.ayahNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.menu_book_rounded, size: 20, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'تەفسیری $surahName — ئایەتی $ayahNumber',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: cs.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TafsirBody extends StatelessWidget {
  final AppColorScheme cs;
  final ScrollController scrollController;
  final String? arabicText;
  final String text;

  const _TafsirBody({
    required this.cs,
    required this.scrollController,
    required this.arabicText,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final ayahText = arabicText;

    return Stack(
      children: [
        ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 84),
          children: [
            if (ayahText != null && ayahText.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
                ),
                child: Text(
                  ayahText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 20,
                    height: 2.0,
                    color: cs.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              text,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                height: 1.9,
                color: cs.textPrimary,
              ),
            ),
          ],
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: _CopyButton(cs: cs, text: text),
        ),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  final AppColorScheme cs;
  final String text;

  const _CopyButton({required this.cs, required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cs.primary,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: text));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تەفسیرەکە کۆپی کرا',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'کۆپی',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final AppColorScheme cs;
  final IconData icon;
  final String title;
  final String body;

  const _Message({
    required this.cs,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: cs.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                height: 1.7,
                color: cs.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
