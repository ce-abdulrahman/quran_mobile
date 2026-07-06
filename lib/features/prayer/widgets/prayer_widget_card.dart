import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../auth/auth_provider.dart';
import '../../../core/providers/app_providers.dart';
import '../providers/prayer_widget_provider.dart';


class PrayerWidgetCard extends ConsumerStatefulWidget {
  const PrayerWidgetCard({super.key});

  @override
  ConsumerState<PrayerWidgetCard> createState() => _PrayerWidgetCardState();
}

class _PrayerWidgetCardState extends ConsumerState<PrayerWidgetCard> {
  Timer? _timer;
  DateTime? _targetDateTime;
  final ValueNotifier<String> _countdownNotifier = ValueNotifier<String>('--:--:--');

  @override
  void dispose() {
    _timer?.cancel();
    _countdownNotifier.dispose();
    super.dispose();
  }

  void _initTimer(String nextPrayerTime, String nextPrayer) {
    if (nextPrayerTime.isEmpty) return;
    
    final now = DateTime.now();
    int hour = 0;
    int minute = 0;

    final normalized = nextPrayerTime.trim().toUpperCase();
    final isPM = normalized.contains('PM');
    final isAM = normalized.contains('AM');

    // Remove AM/PM and non-digit/colon characters
    final cleanTime = normalized.replaceAll(RegExp(r'[^0-9:]'), '').trim();
    final parts = cleanTime.split(':');
    if (parts.length >= 2) {
      hour = int.tryParse(parts[0]) ?? 0;
      minute = int.tryParse(parts[1]) ?? 0;
      if (isPM && hour < 12) {
        hour += 12;
      } else if (isAM && hour == 12) {
        hour = 0;
      }
    }

    var target = DateTime(now.year, now.month, now.day, hour, minute);
    
    // If the parsed time is already in the past today, it means next prayer is tomorrow (e.g., Fajr tomorrow)
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    _targetDateTime = target;
    
    _timer?.cancel();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _updateCountdown() {
    if (_targetDateTime == null) return;

    final diff = _targetDateTime!.difference(DateTime.now());
    if (diff.isNegative) {
      _countdownNotifier.value = '00:00:00';
      _timer?.cancel();
      // Auto refresh widget to get new times
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(prayerWidgetProvider.notifier).refreshWidgetData();
      });
    } else {
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
      _countdownNotifier.value = '$hours:$minutes:$seconds';
    }
  }

  // LinearGradient based on custom app accent color
  LinearGradient _getPrayerGradient(Color accentColor) {
    return LinearGradient(
      colors: [
        accentColor,
        AppColorScheme.darken(accentColor, 0.08),
        AppColorScheme.darken(accentColor, 0.18),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  String _getPrayerName(String key, AppLocalizations l) {
    switch (key.toLowerCase()) {
      case 'fajr':
        return l.prayerFajr;
      case 'sunrise':
        return l.prayerSunrise;
      case 'dhuhr':
        return l.prayerDhuhr;
      case 'asr':
        return l.prayerAsr;
      case 'maghrib':
        return l.prayerMaghrib;
      case 'isha':
        return l.prayerIsha;
      default:
        return key;
    }
  }

  String _getTranslation(String key, BuildContext context) {
    final isKurdish = Localizations.localeOf(context).languageCode == 'ku';
    switch (key) {
      case 'prayer_widget.title':
        return isKurdish ? 'کاتی نوێژەکان' : 'Prayer Times';
      case 'prayer_widget.next_prayer':
        return isKurdish ? 'نوێژی داهاتوو' : 'Next Prayer';
      case 'prayer_widget.remaining_time':
        return isKurdish ? 'کاتی ماوە' : 'Remaining Time';
      case 'prayer_widget.current_city':
        return isKurdish ? 'شاری ئێستا' : 'Current City';
      case 'prayer_widget.open_qibla':
        return isKurdish ? 'قیبلەنما' : 'Qibla Finder';
      case 'prayer_widget.open_settings':
        return isKurdish ? 'ڕێکخستنەکان' : 'Settings';
      case 'prayer_widget.refresh':
        return isKurdish ? 'نوێکردنەوە' : 'Refresh';
      default:
        return key.split('.').last.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _stripAmPm(String timeStr) {
    return timeStr.replaceAll(RegExp(r'\s?[APap][Mm]'), '').trim();
  }


  @override
  Widget build(BuildContext context) {
    final asyncWidgetData = ref.watch(prayerWidgetProvider);
    final cs = AppColorScheme.of(context);
    final l = context.l10n;

    return asyncWidgetData.when(
      data: (data) {
        if (data == null) return const SizedBox.shrink();

        // Check widget visibility & enabled settings
        final widgetSettings = data.toJson()['widget_settings'] as Map<String, dynamic>? ?? {};
        final bool enabled = widgetSettings['enabled'] as bool? ?? true;
        final String visibility = widgetSettings['visibility'] as String? ?? 'always_visible';

        if (!enabled) return const SizedBox.shrink();

        final authState = ref.watch(authProvider);
        if (visibility == 'only_authenticated' && authState.status != AuthStatus.authenticated) {
          return const SizedBox.shrink();
        }

        // Initialize ticking timer for next prayer
        _initTimer(data.nextPrayerTime, data.nextPrayer);

        final accentColor = ref.watch(accentColorProvider).primary;
        final gradient = _getPrayerGradient(accentColor);

        return Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Soft background geometric highlights
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -60,
                  bottom: -60,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Next Prayer Title, Live countdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTranslation('prayer_widget.next_prayer', context),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.75),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _getPrayerName(data.nextPrayer, l),
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '${l.prayerTimesTitle}: ${_stripAmPm(data.nextPrayerTime)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _getTranslation('prayer_widget.remaining_time', context),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                              const SizedBox(height: 2),
                              ValueListenableBuilder<String>(
                                valueListenable: _countdownNotifier,
                                builder: (context, countdownStr, _) {
                                  return Text(
                                    countdownStr,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Horizontal list of prayer times
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: data.prayerTimes.entries.map((entry) {
                              final isNext = entry.key.toLowerCase() == data.nextPrayer.toLowerCase();
                              return AnimatedContainer(
                                duration: 300.ms,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: isNext
                                    ? BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.35),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withValues(alpha: 0.1),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      )
                                    : null,
                                child: Column(
                                  children: [
                                    Text(
                                      _getPrayerName(entry.key, l),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 10,
                                        fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                                        color: isNext ? Colors.white : Colors.white.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _stripAmPm(entry.value),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                                        color: isNext ? Colors.white : Colors.white.withValues(alpha: 0.95),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
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
      },
      loading: () => Container(
        height: 140,
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.cardBorder),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Container(
        height: 120,
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.cardBorder),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'کێشەیەک ڕوویدا لە بارکردنی کاتەکانی بانگ',
                style: TextStyle(fontFamily: 'Cairo', color: cs.textPrimary),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => ref.read(prayerWidgetProvider.notifier).refreshWidgetData(),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('دووبارە هەوڵ بدەرەوە', style: TextStyle(fontFamily: 'Cairo')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

