import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

void showFeatureNotAvailableDialog(BuildContext context) {
  final l = AppLocalizations.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final primaryColor = Theme.of(context).colorScheme.primary;

  showDialog(
    context: context,
    builder: (context) {
      final isRtl = l.localeCode == 'ku' || l.localeCode == 'ar';
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          contentPadding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 8),
          actionsPadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.localeCode == 'ku'
                      ? 'تایبەتمەندی بەردەست نییە'
                      : (l.localeCode == 'ar' ? 'الميزة غير متوفرة' : 'Feature Not Available'),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l.localeCode == 'ku'
                ? 'ئەم تایبەتمەندییە هێشتا لە ڤێرژنی ١ بەردەست نییە.\n\nبۆ نوێکردنەوەکانی داهاتوو پلان بۆ دانراوە و لە ڤێرژنی ٢ بەردەست دەبێت. سوپاس بۆ ئارامگریت.'
                : (l.localeCode == 'ar'
                    ? 'هذه الميزة غير متوفرة في الإصدار الأول بعد.\n\nمن المخطط لها في التحديثات المستقبلية وستكون متاحة في الإصدار الثاني. شكراً لصبركم.'
                    : 'This feature is not available in Version 1 yet.\n\nIt is planned for a future update and will become available in Version 2. Thank you for your patience.'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l.localeCode == 'ku' ? 'باشە' : (l.localeCode == 'ar' ? 'حسناً' : 'OK'),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showFeatureUnderDevelopmentDialog(BuildContext context, {required String messageKu, required String messageAr, required String messageEn}) {
  final l = AppLocalizations.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final primaryColor = Theme.of(context).colorScheme.primary;

  showDialog(
    context: context,
    builder: (context) {
      final isRtl = l.localeCode == 'ku' || l.localeCode == 'ar';
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          contentPadding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 8),
          actionsPadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.localeCode == 'ku'
                      ? 'ئەم تایبەتمەندییە بەردەست نییە'
                      : (l.localeCode == 'ar' ? 'الميزة غير متوفرة حالياً' : 'Feature Not Available'),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l.localeCode == 'ku'
                ? messageKu
                : (l.localeCode == 'ar' ? messageAr : messageEn),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l.localeCode == 'ku' ? 'باشە' : (l.localeCode == 'ar' ? 'حسناً' : 'OK'),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
