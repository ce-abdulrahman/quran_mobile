import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/prayer_times_provider.dart';


class PrayerTimesPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const PrayerTimesPage({super.key, this.showBackButton = true});

  @override
  ConsumerState<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends ConsumerState<PrayerTimesPage> {
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final settings = ref.watch(prayerTimesSettingsProvider);
    final todayTimes = ref.watch(prayerTimesForDateProvider(DateTime.now()));
    final nextPrayerInfo = ref.watch(nextPrayerProvider);

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
          l.prayerTimesTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Next Prayer Countdown Card (Dynamic Gradient representation of Sky)
              if (nextPrayerInfo != null) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColorScheme.darken(cs.primary, 0.45),
                              const Color(0xFF1E1E2F),
                            ]
                          : [
                              cs.primary,
                              const Color(0xFF1A3A5C), // Lapis/Navy Blue
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_rounded, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  settings.selectedCity.nameKu,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            l.prayerNextPrayer,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        nextPrayerInfo.arabicName,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'کاتی نوێژ: ${_formatTime(nextPrayerInfo.time)}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 20),
                      Text(
                        l.prayerTimeRemaining,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _CountdownTimerText(
                        targetTime: nextPrayerInfo.time,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 2. City Selector Card
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<KurdishCity>(
                                value: settings.cities.firstWhere(
                                  (c) => c.nameEn == settings.selectedCity.nameEn,
                                  orElse: () => settings.cities.isNotEmpty ? settings.cities.first : kurdishCities.first,
                                ),
                                isExpanded: true,
                                dropdownColor: cs.card,
                                items: settings.cities.map((city) {
                                  return DropdownMenuItem(
                                    value: city,
                                    child: Text(
                                      city.nameKu,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: cs.textPrimary,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    ref.read(prayerTimesSettingsProvider.notifier).changeCity(val);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l.prayerSelectCity,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 24),

              // 3. Global Notification Config Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Switch.adaptive(
                      value: settings.isAzanEnabled,
                      activeThumbColor: cs.primary,
                      activeTrackColor: cs.primary.withValues(alpha: 0.5),
                      onChanged: (val) {
                        ref.read(prayerTimesSettingsProvider.notifier).toggleAzan(val);
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l.prayerAzanNotification,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: cs.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l.prayerAzanNotificationSub,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Detailed Times Card
              Container(
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildPrayerRow(
                      context: context,
                      cs: cs,
                      keyName: 'Fajr',
                      prayerNameKu: l.prayerFajr,
                      prayerNameAr: 'الفجر',
                      time: todayTimes.fajr.toLocal(),
                      settings: settings,
                      isPrayer: true,
                    ),
                    _buildDivider(cs),
                    _buildPrayerRow(
                      context: context,
                      cs: cs,
                      keyName: 'Sunrise',
                      prayerNameKu: l.prayerSunrise,
                      prayerNameAr: 'الشروق',
                      time: todayTimes.sunrise.toLocal(),
                      settings: settings,
                      isPrayer: false, // Sunrise doesn't have notifications/azan
                    ),
                    _buildDivider(cs),
                    _buildPrayerRow(
                      context: context,
                      cs: cs,
                      keyName: 'Dhuhr',
                      prayerNameKu: l.prayerDhuhr,
                      prayerNameAr: 'الظهر',
                      time: todayTimes.dhuhr.toLocal(),
                      settings: settings,
                      isPrayer: true,
                    ),
                    _buildDivider(cs),
                    _buildPrayerRow(
                      context: context,
                      cs: cs,
                      keyName: 'Asr',
                      prayerNameKu: l.prayerAsr,
                      prayerNameAr: 'العصر',
                      time: todayTimes.asr.toLocal(),
                      settings: settings,
                      isPrayer: true,
                    ),
                    _buildDivider(cs),
                    _buildPrayerRow(
                      context: context,
                      cs: cs,
                      keyName: 'Maghrib',
                      prayerNameKu: l.prayerMaghrib,
                      prayerNameAr: 'المغرب',
                      time: todayTimes.maghrib.toLocal(),
                      settings: settings,
                      isPrayer: true,
                    ),
                    _buildDivider(cs),
                    _buildPrayerRow(
                      context: context,
                      cs: cs,
                      keyName: 'Isha',
                      prayerNameKu: l.prayerIsha,
                      prayerNameAr: 'العشاء',
                      time: todayTimes.isha.toLocal(),
                      settings: settings,
                      isPrayer: true,
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

  Widget _buildDivider(AppColorScheme cs) {
    return Divider(height: 1, color: cs.divider.withValues(alpha: 0.5));
  }

  Widget _buildPrayerRow({
    required BuildContext context,
    required AppColorScheme cs,
    required String keyName,
    required String prayerNameKu,
    required String prayerNameAr,
    required DateTime time,
    required PrayerTimesState settings,
    required bool isPrayer,
  }) {
    final bool isNotificationOn = settings.prayerToggles[keyName] ?? true;
    final String formattedTime = _formatTime(time);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Notification Switch / Bell Icon on Left
          if (isPrayer)
            IconButton(
              icon: Icon(
                isNotificationOn ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                color: isNotificationOn ? cs.primary : cs.textSecondary.withValues(alpha: 0.5),
                size: 20,
              ),
              onPressed: () {
                ref
                    .read(prayerTimesSettingsProvider.notifier)
                    .togglePrayerNotification(keyName, !isNotificationOn);
              },
            )
          else
            const SizedBox(width: 48, height: 48), // Spacer for Sunrise alignment

          // Time in middle
          Text(
            formattedTime,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cs.textPrimary,
            ),
          ),

          // Name on Right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prayerNameKu,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                prayerNameAr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: cs.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountdownTimerText extends StatefulWidget {
  final DateTime targetTime;
  final TextStyle style;

  const _CountdownTimerText({
    required this.targetTime,
    required this.style,
  });

  @override
  State<_CountdownTimerText> createState() => _CountdownTimerTextState();
}

class _CountdownTimerTextState extends State<_CountdownTimerText> {
  late Timer _timer;
  late ValueNotifier<Duration> _remainingNotifier;

  @override
  void initState() {
    super.initState();
    final initialRemaining = widget.targetTime.difference(DateTime.now());
    _remainingNotifier = ValueNotifier(initialRemaining);
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant _CountdownTimerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetTime != widget.targetTime) {
      _timer.cancel();
      _remainingNotifier.value = widget.targetTime.difference(DateTime.now());
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final diff = widget.targetTime.difference(DateTime.now());
      if (diff.isNegative || diff.inSeconds <= 0) {
        _remainingNotifier.value = Duration.zero;
        _timer.cancel();
      } else {
        _remainingNotifier.value = diff;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _remainingNotifier.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: _remainingNotifier,
      builder: (context, remaining, child) {
        return Text(
          _formatDuration(remaining),
          style: widget.style,
        );
      },
    );
  }
}
