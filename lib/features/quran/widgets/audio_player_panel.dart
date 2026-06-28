import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/reciter_model.dart';
import '../../../core/models/recitation_models.dart';
import '../providers/audio_player_provider.dart';
import '../quran_providers.dart';
import 'audio_settings_sheet.dart';

class AudioPlayerPanel extends ConsumerStatefulWidget {
  final int surahId;

  const AudioPlayerPanel({
    super.key,
    required this.surahId,
  });

  @override
  ConsumerState<AudioPlayerPanel> createState() => _AudioPlayerPanelState();
}

class _AudioPlayerPanelState extends ConsumerState<AudioPlayerPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(audioPlayerProvider.notifier).loadSurah(widget.surahId);
      }
    });
  }

  @override
  void didUpdateWidget(AudioPlayerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahId != widget.surahId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(audioPlayerProvider.notifier).loadSurah(widget.surahId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final playerState = ref.watch(audioPlayerProvider);
    final recitersAsync = ref.watch(recitersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (playerState.streamUrl == null && !playerState.isLoading && playerState.errorMessage == null) {
      return const SizedBox.shrink();
    }

    String formatDuration(Duration duration) {
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF061810).withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SafeArea(
            top: false,
            bottom: true,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              // Pull indicator handle
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              if (playerState.sessionRecoveryState == SessionRecoveryState.available) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history_rounded, color: cs.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ئایا دەتەوێت بەردەوام بیت لە گوێگرتن لەو شوێنەی وەستابوویت؟',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: cs.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              ref.read(audioPlayerProvider.notifier).cancelRecovery();
                            },
                            child: Text(
                              'نەخێر',
                              style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              ref.read(audioPlayerProvider.notifier).restoreSession();
                            },
                            child: const Text(
                              'بەڵێ، بەردەوامبە',
                              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (playerState.sessionRecoveryState == SessionRecoveryState.restoring) ...[
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Top row: Reciter selector & playback speed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reciter Selector
                  recitersAsync.when(
                    data: (reciters) {
                      final selectedReciter = reciters.firstWhere(
                        (r) => r.id == playerState.selectedReciterId,
                        orElse: () => reciters.first,
                      );
                      return GestureDetector(
                        onTap: () => _showReciterSelector(context, ref, reciters, selectedReciter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mic_none_rounded, size: 16, color: cs.primary),
                              const SizedBox(width: 6),
                              Text(
                                selectedReciter.name,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: cs.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: cs.textSecondary),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => Text(
                      'خوێنەرەکان بارنەکران',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary),
                    ),
                  ),

                  // Speed Control & Auto Scroll Toggle
                  Row(
                    children: [
                      // Advanced Audio Settings
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AudioSettingsSheet(surahId: widget.surahId),
                          );
                        },
                        icon: Icon(Icons.settings_outlined, color: cs.primary, size: 20),
                        tooltip: 'ڕێکخستنەکان',
                      ),
                      const SizedBox(width: 4),
                      // Auto-Scroll Toggle
                      IconButton(
                        onPressed: () => ref.read(audioPlayerProvider.notifier).toggleAutoScroll(),
                        icon: Icon(
                          playerState.isAutoScrollEnabled
                              ? Icons.phonelink_ring_rounded
                              : Icons.phonelink_erase_rounded,
                          size: 20,
                          color: playerState.isAutoScrollEnabled ? cs.primary : cs.textSecondary,
                        ),
                        tooltip: 'لادانی ئۆتۆماتیکی',
                      ),
                      const SizedBox(width: 4),
                      // Playback Speed
                      GestureDetector(
                        onTap: () {
                          final speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
                          final currentIndex = speeds.indexOf(playerState.speed);
                          final nextIndex = (currentIndex + 1) % speeds.length;
                          ref.read(audioPlayerProvider.notifier).setSpeed(speeds[nextIndex]);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${playerState.speed}x',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Slider & Timer Row
              if (playerState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    playerState.errorMessage!,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.redAccent),
                  ),
                )
              else if (playerState.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    // Slider
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        activeTrackColor: cs.primary,
                        inactiveTrackColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                        thumbColor: cs.primary,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: playerState.position.inMilliseconds.toDouble(),
                        max: playerState.duration.inMilliseconds.toDouble() > 0
                            ? playerState.duration.inMilliseconds.toDouble()
                            : 100.0,
                        onChanged: (val) {
                          ref.read(audioPlayerProvider.notifier).seek(Duration(milliseconds: val.toInt()));
                        },
                      ),
                    ),
                    // Timestamps
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(playerState.position),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: cs.textSecondary,
                            ),
                          ),
                          Text(
                            formatDuration(playerState.duration),
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

              const SizedBox(height: 12),

              if (playerState.engineState == RecitationEngineState.waitingGap) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ماوەی بێدەنگی بۆ لەبەرکردن: ${playerState.gapRemainingSeconds} چرکە ماوە',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Play/Pause Controller Button
              if (!playerState.isLoading && playerState.errorMessage == null)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      iconSize: 52,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (playerState.isPlaying) {
                          ref.read(audioPlayerProvider.notifier).pause();
                        } else {
                          ref.read(audioPlayerProvider.notifier).play();
                        }
                      },
                      icon: Icon(
                        playerState.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }

  void _showReciterSelector(
    BuildContext context,
    WidgetRef ref,
    List<ReciterModel> reciters,
    ReciterModel currentReciter,
  ) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: isDark
                  ? const Color(0xFF0A2218).withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.95),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'هەڵبژاردنی قورئان خوێن',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reciters.length,
                      itemBuilder: (context, index) {
                        final reciter = reciters[index];
                        final isSelected = reciter.id == currentReciter.id;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cs.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? cs.primary : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              ref.read(audioPlayerProvider.notifier).changeReciter(reciter.id, widget.surahId);
                              Navigator.pop(context);
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            title: Text(
                              reciter.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: cs.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              'ڕیوایەتی ${reciter.riwayah}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: cs.textSecondary,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_circle_rounded, color: cs.primary)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
