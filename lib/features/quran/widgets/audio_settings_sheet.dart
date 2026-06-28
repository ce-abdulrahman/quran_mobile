import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/recitation_models.dart';
import '../../../core/services/audio_download_manager.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/sleep_timer_service.dart';
import '../../../core/providers/audio_favorites_provider.dart';
import '../../../core/services/audio_quality_manager.dart';
import 'download_dashboard_screen.dart';
import '../providers/audio_player_provider.dart';
import '../quran_providers.dart';

class AudioSettingsSheet extends ConsumerStatefulWidget {
  final int surahId;

  const AudioSettingsSheet({
    super.key,
    required this.surahId,
  });

  @override
  ConsumerState<AudioSettingsSheet> createState() => _AudioSettingsSheetState();
}

class _AudioSettingsSheetState extends ConsumerState<AudioSettingsSheet> {
  String _qariSearchQuery = '';
  bool _isQariExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final playerState = ref.watch(audioPlayerProvider);
    final recitersAsync = ref.watch(recitersProvider);
    final surahList = ref.watch(surahListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appLocale = ref.watch(appLocaleProvider);

    final currentSurah = surahList.valueOrNull?.where((s) => s.id == widget.surahId).firstOrNull;
    final totalAyahs = currentSurah?.totalAyahs ?? 7;

    return Directionality(
      textDirection: (appLocale.languageCode == 'ar' || appLocale.languageCode == 'ku')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF071B11).withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.98),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull indicator & Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ڕێکخستنەکانی خوێندنەوە و لەبەرکردن',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final favs = ref.watch(audioFavoritesProvider);
                      final isFav = favs.favoriteSurahs.contains(widget.surahId);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: isFav ? Colors.redAccent : cs.textSecondary,
                        ),
                        onPressed: () {
                          ref.read(audioFavoritesProvider.notifier).toggleFavorite('surah', widget.surahId);
                        },
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: cs.textSecondary),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Recently Used Reciters (Phase 3)
              () {
                final recentIds = ref.watch(reciterHistorySyncQueueProvider).getRecentReciterIds();
                final recentReciters = recitersAsync.valueOrNull?.where((r) => recentIds.contains(r.id)).toList() ?? [];
                // Sort according to chronological usage queue
                recentReciters.sort((a, b) => recentIds.indexOf(a.id).compareTo(recentIds.indexOf(b.id)));

                if (recentReciters.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(cs, 'دوایین خوێنەرە بەکارهاتووەکان'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recentReciters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final reciter = recentReciters[index];
                          final isSel = reciter.id == playerState.selectedReciterId;
                          return GestureDetector(
                            onTap: () {
                              ref.read(audioPlayerProvider.notifier).changeReciter(reciter.id, widget.surahId);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: isSel ? cs.primary : cs.card,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage: reciter.image != null && reciter.image!.isNotEmpty
                                        ? NetworkImage(reciter.image!)
                                        : null,
                                    child: reciter.image == null || reciter.image!.isEmpty
                                        ? Text(
                                            reciter.name.substring(0, 1),
                                            style: TextStyle(color: isSel ? Colors.white : cs.textPrimary),
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  reciter.name.split(' ').first,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 10,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    color: isSel ? cs.primary : cs.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }(),

              // 1. Qari Select Expansion
              _buildSectionTitle(cs, 'خوێنەر (قارئ)'),
              const SizedBox(height: 8),
              recitersAsync.when(
                data: (reciters) {
                  final selectedReciter = reciters.firstWhere(
                    (r) => r.id == playerState.selectedReciterId,
                    orElse: () => reciters.first,
                  );

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isQariExpanded = !_isQariExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cs.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: cs.cardBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.mic_external_on_outlined, color: cs.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedReciter.name,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: cs.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'ڕیوایەتی ${selectedReciter.riwayah}',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                        color: cs.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                _isQariExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                                color: cs.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isQariExpanded) ...[
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 250),
                          decoration: BoxDecoration(
                            color: cs.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: cs.cardBorder),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Search input
                              TextField(
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  hintText: 'گەڕان بۆ خوێنەر...',
                                  hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: Icon(Icons.search_rounded, color: cs.primary, size: 18),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: cs.divider)),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _qariSearchQuery = val;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                               Consumer(
                                builder: (context, ref, child) {
                                  final favoriteState = ref.watch(audioFavoritesProvider);
                                  final recentIds = ref.watch(reciterHistorySyncQueueProvider).getRecentReciterIds();

                                  final filteredReciters = reciters
                                      .where((r) => r.name.toLowerCase().contains(_qariSearchQuery.toLowerCase()))
                                      .toList();

                                  filteredReciters.sort((a, b) {
                                    final aFav = favoriteState.favoriteReciters.contains(a.id);
                                    final bFav = favoriteState.favoriteReciters.contains(b.id);
                                    if (aFav && !bFav) return -1;
                                    if (!aFav && bFav) return 1;

                                    final aRecentIdx = recentIds.indexOf(a.id);
                                    final bRecentIdx = recentIds.indexOf(b.id);
                                    final aHasRecent = aRecentIdx != -1;
                                    final bHasRecent = bRecentIdx != -1;

                                    if (aHasRecent && !bHasRecent) return -1;
                                    if (!aHasRecent && bHasRecent) return 1;
                                    if (aHasRecent && bHasRecent) {
                                      return aRecentIdx.compareTo(bRecentIdx);
                                    }

                                    return a.id.compareTo(b.id);
                                  });

                                  return Flexible(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: filteredReciters.map((reciter) {
                                        final isSel = reciter.id == selectedReciter.id;
                                        final isFav = favoriteState.favoriteReciters.contains(reciter.id);
                                        return ListTile(
                                          dense: true,
                                          onTap: () {
                                            ref.read(audioPlayerProvider.notifier).changeReciter(reciter.id, widget.surahId);
                                            setState(() {
                                              _isQariExpanded = false;
                                            });
                                          },
                                          title: Text(
                                            reciter.name,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                              color: isSel ? cs.primary : cs.textPrimary,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'ڕیوایەتی ${reciter.riwayah}',
                                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 10),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                                                  color: isFav ? Colors.amber : cs.textSecondary,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  ref.read(audioFavoritesProvider.notifier).toggleFavorite('reciter', reciter.id);
                                                },
                                              ),
                                              if (isSel)
                                                Icon(Icons.check_circle_rounded, color: cs.primary, size: 18),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text(context.l10n.audioReciterLoadError),
              ),
              const SizedBox(height: 16),

              _buildSectionTitle(cs, context.l10n.audioQualityTitle),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AudioQuality>(
                    value: AudioQualityManager().getUserPreference(),
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: cs.textSecondary),
                    dropdownColor: isDark ? const Color(0xFF071B11) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    isExpanded: true,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: cs.textPrimary,
                      fontSize: 13,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: AudioQuality.auto,
                        child: Text(context.l10n.audioQualityAuto),
                      ),
                      DropdownMenuItem(
                        value: AudioQuality.high,
                        child: Text(context.l10n.audioQualityHigh),
                      ),
                      DropdownMenuItem(
                        value: AudioQuality.medium,
                        child: Text(context.l10n.audioQualityMedium),
                      ),
                      DropdownMenuItem(
                        value: AudioQuality.low,
                        child: Text(context.l10n.audioQualityLow),
                      ),
                      DropdownMenuItem(
                        value: AudioQuality.offlineOnly,
                        child: Text(context.l10n.audioQualityOfflineOnly),
                      ),
                    ],
                    onChanged: (val) async {
                      if (val != null) {
                        await AudioQualityManager().setUserPreference(val);
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Memorization Mode Selector Presets
              _buildSectionTitle(cs, context.l10n.audioMemorizationMode),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPresetButton(cs, context.l10n.audioMemorizationOff, null, !playerState.settings.memorizationMode),
                  const SizedBox(width: 8),
                  _buildPresetButton(cs, context.l10n.audioMemorizationBeginner, MemorizationPreset.beginner, playerState.settings.memorizationMode && playerState.settings.repeatCount == 3),
                  const SizedBox(width: 8),
                  _buildPresetButton(cs, context.l10n.audioMemorizationIntermediate, MemorizationPreset.intermediate, playerState.settings.memorizationMode && playerState.settings.repeatCount == 5),
                  const SizedBox(width: 8),
                  _buildPresetButton(cs, context.l10n.audioMemorizationAdvanced, MemorizationPreset.advanced, playerState.settings.memorizationMode && playerState.settings.repeatCount == 10),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Repeat Mode Segment
              _buildSectionTitle(cs, context.l10n.audioRepeatMode),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildModeButton(cs, context.l10n.audioRepeatNone, RepeatMode.none, playerState.settings.repeatMode == RepeatMode.none),
                  const SizedBox(width: 8),
                  _buildModeButton(cs, context.l10n.audioRepeatAyah, RepeatMode.ayah, playerState.settings.repeatMode == RepeatMode.ayah),
                  const SizedBox(width: 8),
                  _buildModeButton(cs, context.l10n.audioRepeatRange, RepeatMode.range, playerState.settings.repeatMode == RepeatMode.range),
                  const SizedBox(width: 8),
                  _buildModeButton(cs, context.l10n.audioRepeatSurah, RepeatMode.surah, playerState.settings.repeatMode == RepeatMode.surah),
                ],
              ),
              const SizedBox(height: 16),

              // 4. A-B Range Picker
              if (playerState.settings.repeatMode == RepeatMode.range) ...[
                _buildSectionTitle(cs, context.l10n.audioRangeTitle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.audioRangeStart, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                          DropdownButtonFormField<int>(
                            value: playerState.session.rangeStartAyah <= totalAyahs ? playerState.session.rangeStartAyah : 1,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: List.generate(totalAyahs, (i) => i + 1).map((val) {
                              return DropdownMenuItem<int>(
                                value: val,
                                child: Text(context.l10n.audioAyahNumber(val), style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                ref.read(audioPlayerProvider.notifier).setRange(val, playerState.session.rangeEndAyah);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.audioRangeEnd, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                          DropdownButtonFormField<int>(
                            value: playerState.session.rangeEndAyah <= totalAyahs ? playerState.session.rangeEndAyah : totalAyahs,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: List.generate(totalAyahs, (i) => i + 1).map((val) {
                              return DropdownMenuItem<int>(
                                value: val,
                                child: Text(context.l10n.audioAyahNumber(val), style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                ref.read(audioPlayerProvider.notifier).setRange(playerState.session.rangeStartAyah, val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // 5. Repeat Count Slider
              if (playerState.settings.repeatMode != RepeatMode.none) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(cs, context.l10n.audioRepeatCount),
                    Text(
                      playerState.settings.repeatCount == -1 ? context.l10n.audioRepeatInfinite : context.l10n.audioRepeatTimes(playerState.settings.repeatCount),
                      style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: cs.primary),
                    ),
                  ],
                ),
                Slider(
                  value: playerState.settings.repeatCount.toDouble(),
                  min: -1,
                  max: 10,
                  divisions: 11,
                  activeColor: cs.primary,
                  inactiveColor: cs.primary.withValues(alpha: 0.2),
                  onChanged: (v) {
                    ref.read(audioPlayerProvider.notifier).setRepeatCount(v.round());
                  },
                ),
                const SizedBox(height: 8),
              ],

              // 6. Gap Settings
              if (playerState.settings.repeatMode != RepeatMode.none) ...[
                _buildSectionTitle(cs, 'شێوازی ماوەی بێدەنگی (Gap)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildGapModeButton(cs, 'بێ بێدەنگی', GapMode.none, playerState.settings.gapMode == GapMode.none),
                    const SizedBox(width: 8),
                    _buildGapModeButton(cs, 'نێوان ئایەتەکان', GapMode.betweenAyahs, playerState.settings.gapMode == GapMode.betweenAyahs),
                    const SizedBox(width: 8),
                    _buildGapModeButton(cs, 'نێوان دووبارەبوونەوەکان', GapMode.betweenRepeats, playerState.settings.gapMode == GapMode.betweenRepeats),
                  ],
                ),
                if (playerState.settings.gapMode != GapMode.none) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.audioGapDuration, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                      Text(
                        context.l10n.audioGapSeconds(playerState.settings.gapSeconds),
                        style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: cs.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: playerState.settings.gapSeconds.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    activeColor: cs.primary,
                    inactiveColor: cs.primary.withValues(alpha: 0.2),
                    onChanged: (v) {
                      ref.read(audioPlayerProvider.notifier).setGapSeconds(v.round());
                    },
                  ),
                ],
                const SizedBox(height: 16),
              ],

              // 7. General Options
              _buildSectionTitle(cs, context.l10n.audioGeneralOptions),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      activeColor: cs.primary,
                      title: Text(context.l10n.audioAutoNext, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                      value: playerState.settings.autoNext,
                      onChanged: (val) {
                        ref.read(audioPlayerProvider.notifier).setAutoNext(val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 8. Sleep Timer (Phase 3)
              _buildSectionTitle(cs, context.l10n.audioSleepTimer),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (playerState.sleepTimerState.isActive) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                          playerState.sleepTimerState.mode == SleepTimerMode.surahEnd
                                ? context.l10n.audioSleepTimerUntilSurahEnd
                                : context.l10n.audioSleepTimerRemaining,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: cs.textPrimary,
                            ),
                          ),
                          if (playerState.sleepTimerState.mode == SleepTimerMode.durationBased)
                            Text(
                              _formatRemainingTime(playerState.sleepTimerState.remainingSeconds),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            ref.read(audioPlayerProvider.notifier).cancelSleepTimer();
                          },
                          icon: const Icon(Icons.timer_off_rounded, size: 16),
                          label: Text(context.l10n.audioSleepTimerCancel, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                        ),
                      ),
                      Text(
                        context.l10n.audioSleepTimerPrompt,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSleepOption(ref, context.l10n.audioSleepMin15, 15),
                          _buildSleepOption(ref, context.l10n.audioSleepMin30, 30),
                          _buildSleepOption(ref, context.l10n.audioSleepMin45, 45),
                          _buildSleepOption(ref, context.l10n.audioSleepMin60, 60),
                          GestureDetector(
                            onTap: () {
                              ref.read(audioPlayerProvider.notifier).startSurahEndSleepTimer();
                            },
                            child: Chip(
                              label: Text(context.l10n.audioSurahEnd, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                              backgroundColor: cs.primary.withValues(alpha: 0.1),
                              side: BorderSide(color: cs.primary.withValues(alpha: 0.3)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 9. Download Status & Sequential Queue Controller
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(cs, context.l10n.audioOfflineTitle),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DownloadDashboardScreen()),
                      );
                    },
                    icon: const Icon(Icons.dashboard_customize_rounded, size: 14),
                    label: Text(context.l10n.audioOfflineShowDashboard, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                    style: TextButton.styleFrom(
                      foregroundColor: cs.primary,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(60, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDownloadPanel(cs, playerState.selectedReciterId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(AppColorScheme cs, String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: cs.textSecondary,
      ),
    );
  }

  Widget _buildPresetButton(AppColorScheme cs, String text, MemorizationPreset? preset, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (preset == null) {
            // Turn off memorization
            final settings = ref.read(audioPlayerProvider).settings.copyWith(
              memorizationMode: false,
              repeatMode: RepeatMode.none,
            );
            ref.read(audioPlayerProvider.notifier).updateSettings(settings);
          } else {
            ref.read(audioPlayerProvider.notifier).setMemorizationPreset(preset);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : cs.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? cs.primary : cs.cardBorder),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : cs.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(AppColorScheme cs, String text, RepeatMode mode, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(audioPlayerProvider.notifier).setRepeatMode(mode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : cs.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? cs.primary : cs.cardBorder),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : cs.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGapModeButton(AppColorScheme cs, String text, GapMode mode, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(audioPlayerProvider.notifier).setGapMode(mode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : cs.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? cs.primary : cs.cardBorder),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : cs.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadPanel(AppColorScheme cs, int reciterId) {
    final manager = AudioDownloadManager();
    final isDownloaded = manager.isDownloaded(reciterId, widget.surahId);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder),
      ),
      child: Column(
        children: [
          StreamBuilder<DownloadProgress>(
            stream: manager.watchProgress(reciterId, widget.surahId),
            builder: (context, snapshot) {
              final activeProgress = snapshot.data;
              final isDownloading = activeProgress != null && activeProgress.status == DownloadStatus.downloading;

              if (isDownloaded) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.audioOfflineDownloaded,
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: () async {
                        await manager.deleteSurah(reciterId, widget.surahId);
                        setState(() {});
                      },
                    ),
                  ],
                );
              }

              if (isDownloading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.audioOfflineDownloading,
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.primary, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 20),
                          onPressed: () async {
                            await manager.cancelDownload(reciterId, widget.surahId);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: activeProgress.progress,
                      color: cs.primary,
                      backgroundColor: cs.primary.withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.audioOfflineProgress(
                        (activeProgress.progress * 100).toStringAsFixed(0),
                        (activeProgress.bytesDownloaded / (1024 * 1024)).toStringAsFixed(1),
                        (activeProgress.totalBytes / (1024 * 1024)).toStringAsFixed(1),
                      ),
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary),
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'خوێندنەوەی ئەم سوورەتە داگیرابێت بۆ کارکردنی دەرەوەی هێڵ.',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      await manager.downloadSurah(reciterId, widget.surahId);
                      setState(() {});
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('داگرتن', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 20),

          // Download Queue status & control
          StreamBuilder<DownloadQueueState>(
            stream: manager.watchQueueState(),
            builder: (context, snapshot) {
              final queue = snapshot.data;
              final pendingCount = queue?.pendingCount ?? 0;
              final isPaused = queue?.isPaused ?? false;

              if (pendingCount == 0 && queue?.activeProgress == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.queue_music_rounded, color: cs.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${context.l10n.audioQueueStatus}: ${context.l10n.audioQueuePending(pendingCount)}',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textPrimary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                          color: cs.primary,
                          size: 20,
                        ),
                        onPressed: () {
                          if (isPaused) {
                            manager.resumeQueue();
                          } else {
                            manager.pauseQueue();
                          }
                        },
                      ),
                    ],
                  ),
                  if (queue?.activeProgress != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.audioQueueBackground,
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatRemainingTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Widget _buildSleepOption(WidgetRef ref, String label, int minutes) {
    final cs = AppColorScheme.of(context);
    return GestureDetector(
      onTap: () {
        ref.read(audioPlayerProvider.notifier).startSleepTimer(minutes);
      },
      child: Chip(
        label: Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
        backgroundColor: cs.primary.withValues(alpha: 0.1),
        side: BorderSide(color: cs.primary.withValues(alpha: 0.3)),
      ),
    );
  }
}
