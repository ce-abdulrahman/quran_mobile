import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/local_db/content_package.dart';
import '../../core/providers/package_manager_provider.dart';
import '../../core/services/audio_download_manager.dart';

class DownloadManagerPage extends ConsumerStatefulWidget {
  const DownloadManagerPage({super.key});

  @override
  ConsumerState<DownloadManagerPage> createState() => _DownloadManagerPageState();
}

class _DownloadManagerPageState extends ConsumerState<DownloadManagerPage> {
  bool _isLoading = true;
  bool _isCheckingUpdates = false;
  int _totalStorageBytes = 0;
  
  // Package states
  Map<ContentPackage, PackageManifest?> _manifests = {};
  List<ContentPackage> _updatesAvailable = [];
  
  // Real-time progress trackers
  final Map<ContentPackage, double> _downloadProgress = {};
  final Map<ContentPackage, String> _downloadStatusText = {};
  StreamSubscription? _downloadEventSub;
  
  // Audio reciter states
  List<CachedReciter> _downloadedReciters = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _listenToDownloads();
  }

  @override
  void dispose() {
    _downloadEventSub?.cancel();
    super.dispose();
  }

  void _listenToDownloads() {
    _downloadEventSub = ref.read(packageManagerProvider).downloadEvents.listen((event) {
      if (mounted) {
        setState(() {
          _downloadProgress[event.package] = event.progress;
          if (event.isError) {
            _downloadStatusText[event.package] = event.errorMessage ?? 'هەڵە لە داگرتن';
            _downloadProgress.remove(event.package);
          } else if (event.progress >= 1.0) {
            _downloadStatusText[event.package] = 'تەواوبوو';
            _downloadProgress.remove(event.package);
            _loadData(); // Refresh manifests
          } else {
            _downloadStatusText[event.package] = event.errorMessage ?? 'داگرتن/ڕێکخستن...';
          }
        });
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final packageManager = ref.read(packageManagerProvider);
    final audioManager = AudioDownloadManager();
    
    final tempManifests = <ContentPackage, PackageManifest?>{};
    int packageBytes = 0;
    
    for (final pkg in ContentPackage.values) {
      final manifest = await packageManager.getManifest(pkg);
      tempManifests[pkg] = manifest;
      if (manifest != null && manifest.isComplete) {
        packageBytes += manifest.compressedSize > 0 ? manifest.compressedSize : 1024 * 500;
      }
    }
    
    final audioBytes = await audioManager.getTotalStorageBytes();
    final reciters = await audioManager.getDownloadedReciters();
    
    if (mounted) {
      setState(() {
        _manifests = tempManifests;
        _downloadedReciters = reciters;
        _totalStorageBytes = packageBytes + audioBytes;
        _isLoading = false;
      });
    }
  }

  Future<void> _checkUpdates() async {
    setState(() => _isCheckingUpdates = true);
    try {
      final updates = await ref.read(packageManagerProvider).checkForUpdates();
      if (mounted) {
        setState(() {
          _updatesAvailable = updates;
          _isCheckingUpdates = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              updates.isEmpty 
                  ? 'هیچ وەشانێکی نوێ نییە، سەرجەم پاکێجەکانت نوێن.' 
                  : 'نوێکردنەوە بۆ ${updates.length} پاکێج بەردەستە.',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isCheckingUpdates = false);
      }
    }
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return '0.0 MB';
    final mb = bytes / (1024 * 1024);
    if (mb < 1024) {
      return '${mb.toStringAsFixed(1)} MB';
    }
    final gb = mb / 1024;
    return '${gb.toStringAsFixed(2)} GB';
  }

  String _getPackageNameKu(ContentPackage pkg) {
    switch (pkg) {
      case ContentPackage.quran:
        return 'دەقی قورئانی پیرۆز';
      case ContentPackage.tafsir:
        return 'تەفسیرەکانی قورئان';
      case ContentPackage.hadith:
        return 'پەرتووکی فەرموودەکان';
      case ContentPackage.adhkar:
        return 'ئەزکار و زیکرەکان';
      case ContentPackage.seerah:
        return 'ژیاننامەی پێغەمبەر ﷺ';
      case ContentPackage.sahaba:
        return 'ژیاننامەی هاوەڵان';
      case ContentPackage.allah_names:
        return 'ناوە جوانەکانی خودا (٩٩ ناو)';
      case ContentPackage.prayer_database:
        return 'داتابەیسی کاتەکانی نوێژ';
      case ContentPackage.translations:
        return 'وەرگێڕانەکانی قورئان';
      case ContentPackage.audio_metadata:
        return 'قورئانخوێنەکان و دەنگەکان';
      case ContentPackage.tajweed:
        return 'تەجوید و یاساکانی';
    }
  }

  IconData _getPackageIcon(ContentPackage pkg) {
    switch (pkg) {
      case ContentPackage.quran:
        return Icons.menu_book_rounded;
      case ContentPackage.tafsir:
        return Icons.library_books_rounded;
      case ContentPackage.hadith:
        return Icons.star_rounded;
      case ContentPackage.adhkar:
        return Icons.spa_rounded;
      case ContentPackage.seerah:
        return Icons.history_edu_rounded;
      case ContentPackage.sahaba:
        return Icons.people_outline_rounded;
      case ContentPackage.allah_names:
        return Icons.brightness_high_rounded;
      case ContentPackage.prayer_database:
        return Icons.access_time_rounded;
      case ContentPackage.translations:
        return Icons.translate_rounded;
      case ContentPackage.audio_metadata:
        return Icons.music_note_rounded;
      case ContentPackage.tajweed:
        return Icons.g_translate_rounded;
    }
  }

  Future<void> _deletePackage(ContentPackage pkg) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isRtl = Localizations.localeOf(context).languageCode == 'ar' || Localizations.localeOf(context).languageCode == 'ku';
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            title: const Text('سڕینەوەی بەستە', style: TextStyle(fontFamily: 'Cairo')),
            content: Text('ئایا دڵنیایت لە سڕینەوەی پاکێجی ${_getPackageNameKu(pkg)}؟', style: const TextStyle(fontFamily: 'Cairo')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('پاشگەزبوونەوە', style: TextStyle(fontFamily: 'Cairo')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('سڕینەوە', style: TextStyle(fontFamily: 'Cairo')),
              ),
            ],
          ),
        );
      },
    );

    if (confirm == true) {
      await ref.read(packageManagerProvider).deletePackage(pkg);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'پاکێجی ${_getPackageNameKu(pkg)} بە سەرکەوتوویی سڕایەوە.',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteReciterAudio(CachedReciter reciter) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isRtl = Localizations.localeOf(context).languageCode == 'ar' || Localizations.localeOf(context).languageCode == 'ku';
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            title: const Text('سڕینەوەی دەنگەکان', style: TextStyle(fontFamily: 'Cairo')),
            content: Text('ئایا دڵنیایت لە سڕینەوەی هەموو سوورەتە داگیراوەکانی ${reciter.name}؟', style: const TextStyle(fontFamily: 'Cairo')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('پاشگەزبوونەوە', style: TextStyle(fontFamily: 'Cairo')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('سڕینەوە', style: TextStyle(fontFamily: 'Cairo')),
              ),
            ],
          ),
        );
      },
    );

    if (confirm == true) {
      await AudioDownloadManager().deleteReciter(reciter.id);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'دەنگەکانی ${reciter.name} بە سەرکەوتوویی سڕانەوە.',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _downloadOrUpdatePackage(ContentPackage pkg) async {
    try {
      await ref.read(packageManagerProvider).downloadPackage(pkg);
      await _loadData();
    } catch (_) {
      // Handled by stream listener error messaging
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar' || Localizations.localeOf(context).languageCode == 'ku';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: cs.bg,
        appBar: AppBar(
          title: const Text(
            'بەڕێوەبەری سەرچاوەکان',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (_isCheckingUpdates)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                tooltip: 'پشکنینی نوێکردنەوەکان',
                onPressed: _checkUpdates,
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ── Storage Overview Card ────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cs.primary,
                          cs.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'بیرگەی بەکارهاتوو لە لایەن ئەپەکەوە',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const Icon(Icons.storage_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _formatSize(_totalStorageBytes),
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'هەموو سەرچاوەکان لێرەوە بە شێوازی ئۆفلاین بەردەست دەخرێن',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms),

                  const SizedBox(height: 24),

                  // ── Offline Content Packages ──────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.download_for_offline_rounded, color: cs.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'پاکێجە بەردەستەکان',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ContentPackage.values.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final pkg = ContentPackage.values[index];
                      final manifest = _manifests[pkg];
                      final isReady = manifest != null && manifest.isComplete;
                      final isUpdateAvailable = _updatesAvailable.contains(pkg);
                      
                      final isDownloading = _downloadProgress.containsKey(pkg);
                      final progress = _downloadProgress[pkg] ?? 0.0;
                      final statusText = _downloadStatusText[pkg] ?? '';

                      return Container(
                        decoration: BoxDecoration(
                          color: cs.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cs.cardBorder),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isReady 
                                      ? cs.primary.withValues(alpha: 0.1) 
                                      : cs.textSecondary.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getPackageIcon(pkg),
                                  color: isReady ? cs.primary : cs.textSecondary,
                                  size: 20,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    _getPackageNameKu(pkg),
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: cs.textPrimary,
                                    ),
                                  ),
                                  if (isUpdateAvailable) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'نوێکردنەوە',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                isReady 
                                    ? 'قەبارە: ${_formatSize(manifest.compressedSize > 0 ? manifest.compressedSize : 1024*500)} (وەشان: ${manifest.version})'
                                    : 'ئۆفلاین نییە / داوای داگرتن بکە',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: cs.textSecondary,
                                ),
                              ),
                              trailing: isDownloading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : isUpdateAvailable
                                      ? IconButton(
                                          icon: const Icon(Icons.upgrade_rounded, color: Colors.green),
                                          onPressed: () => _downloadOrUpdatePackage(pkg),
                                        )
                                      : isReady
                                          ? IconButton(
                                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                              onPressed: () => _deletePackage(pkg),
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.cloud_download_outlined, color: cs.primary),
                                              onPressed: () => _downloadOrUpdatePackage(pkg),
                                            ),
                            ),
                            if (isDownloading)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 4,
                                        backgroundColor: cs.cardBorder,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          statusText,
                                          style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary),
                                        ),
                                        Text(
                                          '${(progress * 100).toInt()}%',
                                          style: TextStyle(fontFamily: 'Outfit', fontSize: 10, color: cs.primary, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ).animate().fadeIn(duration: 350.ms, delay: 100.ms),

                  const SizedBox(height: 28),

                  // ── Audio Recitations ──────────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.library_music_rounded, color: cs.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'دەنگە داگیراوەکان',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_downloadedReciters.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.cardBorder),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.cloud_download_outlined, size: 36, color: cs.textSecondary.withValues(alpha: 0.4)),
                            const SizedBox(height: 8),
                            Text(
                              'هیچ سوورەت و دەنگێک دانەگیراوە بۆ کارکردنی ئۆفلاین',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: cs.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 350.ms, delay: 200.ms)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _downloadedReciters.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final reciter = _downloadedReciters[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: cs.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: cs.cardBorder),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_rounded, color: cs.primary, size: 20),
                            ),
                            title: Text(
                              reciter.name,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: cs.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              'قەبارەی گشتی: ${_formatSize(reciter.sizeBytes)}',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: cs.textSecondary,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                              onPressed: () => _deleteReciterAudio(reciter),
                            ),
                          ),
                        );
                      },
                    ).animate().fadeIn(duration: 350.ms, delay: 200.ms),

                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }
}
