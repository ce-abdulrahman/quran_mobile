import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/prayer_times_provider.dart';

class PrayerMethodSettingsPage extends ConsumerWidget {
  const PrayerMethodSettingsPage({super.key});

  String _getTranslation(String key, BuildContext context) {
    final isKurdish = Localizations.localeOf(context).languageCode == 'ku';
    switch (key) {
      case 'prayer.method.muslim_world_league.name':
        return isKurdish ? 'ڕابیتەی جیهانی ئیسلامی' : 'Muslim World League';
      case 'prayer.method.muslim_world_league.desc':
        return isKurdish 
            ? 'زاویەی بەیانی: ١٨، زاویەی عیشا: ١٧. گونجاوە بۆ ئەوروپا، ڕۆژهەڵاتی دوور و ئەمریکا.' 
            : 'Fajr 18.0°, Isha 17.0°. Standard method in Europe, Far East, and parts of Americas.';
      case 'prayer.method.egyptian.name':
        return isKurdish ? 'دەستەی گشتی ڕووپێوی میسر' : 'Egyptian General Authority';
      case 'prayer.method.egyptian.desc':
        return isKurdish 
            ? 'زاویەی بەیانی: ١٩.٥، زاویەی عیشا: ١٧.٥. میسر و باکووری ئەفریقا.' 
            : 'Fajr 19.5°, Isha 17.5°. Widely used in Egypt and parts of Africa.';
      case 'prayer.method.umm_al_qura.name':
        return isKurdish ? 'زانکۆی ئوم ئەلقورا، مەککە' : 'Umm al-Qura University, Makkah';
      case 'prayer.method.umm_al_qura.desc':
        return isKurdish 
            ? 'زاویەی بەیانی: ١٨.٥، عیشا: ٩٠ خولەک دوای مەغریب. عەرەبستانی سعوودی.' 
            : 'Fajr 18.5°, Isha: 90 min after Maghrib (120 in Ramadan). Saudi Arabia.';
      case 'prayer.method.isna.name':
        return isKurdish ? 'کۆمەڵەی ئیسلامی ئەمریکای باکوور' : 'ISNA';
      case 'prayer.method.isna.desc':
        return isKurdish 
            ? 'زاویەی بەیانی: ١٥، زاویەی عیشا: ١٥. ئەمریکای باکوور.' 
            : 'Fajr 15.0°, Isha 15.0°. Standard method in North America.';
      case 'prayer.method.turkey.name':
        return isKurdish ? 'تورکیا (دیانەت)' : 'Turkey (Diyanet)';
      case 'prayer.method.turkey.desc':
        return isKurdish 
            ? 'زاویەی بەیانی: ١٨، زاویەی عیشا: ١٧ لەگەڵ دەستکاری خۆجێی تورکیا.' 
            : 'Fajr 18.0°, Isha 17.0°. Standard method used in Turkey.';
      case 'prayer.method.kurdistan.name':
        return isKurdish ? 'هەرێمی کوردستان (وەزارەتی ئەوقاف)' : 'Kurdistan Region Ministry';
      case 'prayer.method.kurdistan.desc':
        return isKurdish 
            ? 'ڕێساکان و دەستکاری ناوخۆیی بۆ شارەکانی کوردستان و عێراق (پێشنیارکراو).' 
            : 'Iraq/Kurdistan local calculation rules and offsets (Recommended).';
      case 'prayer.method.title':
        return isKurdish ? 'ڕێگای کاتی نوێژ' : 'Calculation Method';
      case 'prayer.method.subtitle':
        return isKurdish ? 'هەڵبژاردنی ڕێگای هەژمارکردنی کاتەکانی بانگ' : 'Choose calculation method for prayer times';
      default:
        // Fallback title formatting
        return key.split('.').last.replaceAll('_', ' ').toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final methodsState = ref.watch(prayerMethodsListProvider);
    final settingsState = ref.watch(prayerTimesSettingsProvider);

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
          _getTranslation('prayer.method.title', context),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Banner Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColorScheme.darken(cs.primary, 0.35), AppColorScheme.darken(cs.primary, 0.42)]
                    : [cs.primary, cs.primaryDeep],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Text(
              _getTranslation('prayer.method.subtitle', context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),

          // Scrollable list
          Expanded(
            child: methodsState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : methodsState.methods.isEmpty
                    ? Center(
                        child: Text(
                          'هیچ شێوازێک نەدۆزرایەوە',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: cs.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: methodsState.methods.length,
                        itemBuilder: (context, index) {
                          final method = methodsState.methods[index];
                          final isSelected = settingsState.calculationMethod == method.key;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cs.primary.withValues(alpha: 0.08)
                                  : cs.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? cs.primary : cs.cardBorder,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              onTap: () {
                                ref.read(prayerTimesSettingsProvider.notifier).changeCalculationMethod(method.key);
                              },
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _getTranslation(method.translationKeyName, context),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? cs.primary : cs.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (method.isDefault)
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 6),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: cs.primary.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'دەستپێک',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: cs.primary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  _getTranslation(method.translationKeyDesc, context),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    height: 1.4,
                                    color: cs.textSecondary,
                                  ),
                                ),
                              ),
                              trailing: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? cs.primary : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? cs.primary : cs.textSecondary.withValues(alpha: 0.4),
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ).animate().fadeIn(
                                duration: 300.ms,
                                delay: (index * 50).ms,
                              );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
