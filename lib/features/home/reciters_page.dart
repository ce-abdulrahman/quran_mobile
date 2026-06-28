import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isar/isar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/services/audio_download_manager.dart';
import '../quran/quran_providers.dart';
import '../quran/providers/audio_player_provider.dart';

final recitersListProvider = FutureProvider<List<ReciterCollection>>((ref) async {
  final isar = IsarService.instance.isar;
  return isar.reciterCollections.where().sortByReciterId().findAll();
});

class RecitersPage extends ConsumerStatefulWidget {
  const RecitersPage({super.key});

  @override
  ConsumerState<RecitersPage> createState() => _RecitersPageState();
}

class _RecitersPageState extends ConsumerState<RecitersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final recitersAsync = ref.watch(recitersListProvider);
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
        title: const Text(
          'قورئانخوێنەکان',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'عەرەبی'),
            Tab(text: 'کوردی'),
          ],
        ),
      ),
      body: recitersAsync.when(
        data: (reciters) {
          final arabicReciters = reciters.where((r) => r.type == 'arabic').toList();
          final kurdishReciters = reciters.where((r) => r.type == 'kurdish').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRecitersList(arabicReciters, cs),
              _buildRecitersList(kurdishReciters, cs),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'هەڵەیەک ڕوویدا: $err',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      ),
    );
  }

  Widget _buildRecitersList(List<ReciterCollection> reciters, AppColorScheme cs) {
    if (reciters.isEmpty) {
      return const Center(
        child: Text(
          'هیچ قورئانخوێنێک بەردەست نییە',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: reciters.length,
      itemBuilder: (context, index) {
        final reciter = reciters[index];
        return _buildReciterCard(context, reciter, cs);
      },
    );
  }

  Widget _buildReciterCard(BuildContext context, ReciterCollection reciter, AppColorScheme cs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? cs.card : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReciterDetailPage(reciter: reciter)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          reciter.nameKu,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: cs.textPrimary,
                          ),
                        ),
                        Text(
                          reciter.nameAr,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          reciter.bioKu,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: cs.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Reciter Avatar with fallback
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.primary.withValues(alpha: 0.2), width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        reciter.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: cs.primary.withValues(alpha: 0.1),
                            child: Icon(Icons.person_rounded, color: cs.primary, size: 30),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms, delay: Duration(milliseconds: 30 * reciter.reciterId));
  }
}

class ReciterDetailPage extends ConsumerStatefulWidget {
  final ReciterCollection reciter;

  const ReciterDetailPage({super.key, required this.reciter});

  @override
  ConsumerState<ReciterDetailPage> createState() => _ReciterDetailPageState();
}

class _ReciterDetailPageState extends ConsumerState<ReciterDetailPage> {
  final AudioDownloadManager _downloadManager = AudioDownloadManager();
  final Map<int, double> _downloadProgresses = {};
  final Map<int, String> _downloadStatuses = {};
  late StreamSubscription _progressSubscription;

  @override
  void initState() {
    super.initState();
    _listenToProgress();
  }

  @override
  void dispose() {
    _progressSubscription.cancel();
    super.dispose();
  }

  void _listenToProgress() {
    _progressSubscription = _downloadManager.watchQueueState().listen((state) {
      if (state.activeProgress != null && state.activeProgress!.reciterId == widget.reciter.reciterId) {
        if (mounted) {
          setState(() {
            _downloadProgresses[state.activeProgress!.surahId] = state.activeProgress!.progress;
            _downloadStatuses[state.activeProgress!.surahId] = state.activeProgress!.status.name;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final surahsAsync = ref.watch(surahListProvider);
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
          widget.reciter.nameKu,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          // Profile Banner
          Container(
            padding: const EdgeInsets.all(20),
            color: isDark ? AppColorScheme.darken(cs.primary, 0.45) : cs.primary.withValues(alpha: 0.05),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.reciter.nameKu,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                      Text(
                        widget.reciter.nameAr,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.reciter.bioKu,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: cs.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.primary, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      widget.reciter.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: cs.primary.withValues(alpha: 0.1),
                          child: Icon(Icons.person_rounded, color: cs.primary, size: 40),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: surahs.length,
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    final isDownloaded = _downloadManager.isDownloaded(widget.reciter.reciterId, surah.id);
                    final progress = _downloadProgresses[surah.id] ?? 0.0;
                    final status = _downloadStatuses[surah.id];

                    return _buildSurahDownloadTile(surah, isDownloaded, progress, status, cs);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text(
                  'هەڵەیەک ڕوویدا لە بارکردنی سوورەتەکان: $err',
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahDownloadTile(
    dynamic surah,
    bool isDownloaded,
    double progress,
    String? status,
    AppColorScheme cs,
  ) {
    final playerState = ref.watch(audioPlayerProvider);
    final isCurrentlyPlayingThisSurah = playerState.isPlaying &&
        playerState.selectedReciterId == widget.reciter.reciterId &&
        playerState.session.currentSurahId == surah.id;

    final isDownloading = status == 'downloading' || (status == 'queued' && progress < 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentlyPlayingThisSurah ? cs.primary : cs.textSecondary.withValues(alpha: 0.08),
          width: isCurrentlyPlayingThisSurah ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Left actions (Play or download status)
          if (isDownloaded) ...[
            IconButton(
              icon: Icon(
                isCurrentlyPlayingThisSurah ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                color: cs.primary,
                size: 32,
              ),
              onPressed: () {
                if (isCurrentlyPlayingThisSurah) {
                  ref.read(audioPlayerProvider.notifier).pause();
                } else {
                  ref.read(audioPlayerProvider.notifier).changeReciter(widget.reciter.reciterId, surah.id);
                }
              },
            ),
          ] else if (isDownloading) ...[
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                value: progress > 0 ? progress : null,
                strokeWidth: 3,
                color: cs.primary,
              ),
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.download_for_offline_rounded, color: cs.primary.withValues(alpha: 0.6), size: 28),
              onPressed: () async {
                setState(() {
                  _downloadStatuses[surah.id] = 'queued';
                });
                try {
                  await _downloadManager.downloadSurah(widget.reciter.reciterId, surah.id);
                } catch (_) {}
                if (mounted) {
                  setState(() {
                    _downloadStatuses[surah.id] = 'complete';
                  });
                }
              },
            ),
          ],
          
          const Spacer(),

          // Surah Meta Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                surah.nameKu,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${surah.totalAyahs} ئایەت',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: cs.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Circle Index
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.textSecondary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${surah.id}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: cs.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
