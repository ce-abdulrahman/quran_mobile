import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/l10n/app_localizations.dart';

class ReaderPlaceholder extends StatelessWidget {
  const ReaderPlaceholder({super.key, required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          surah.nameAr,
          style: TextStyle(
            fontFamily: 'Cairo', // Uthmanic font or Cairo for surah name
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: cs.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryGreen, Color(0xFF2E7D5E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 28),
              Text(
                context.l10n.readerComingSoon,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.readerDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: cs.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.accentGold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${surah.nameEn} · ${surah.totalAyahs} ${context.l10n.quranAyahs}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
