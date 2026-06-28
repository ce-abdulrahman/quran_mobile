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
  int _totalStorageBytes = 0;
  
  // Package states
  Map<ContentPackage, PackageManifest?> _manifests = {};
  
  // Audio reciter states
  List<CachedReciter> _downloadedReciters = [];

  @override
  void initState() {
    super.initState();
    _loadData();
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
        packageBytes += manifest.sizeBytes;
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
      case ContentPackage.tajweed:
        return 'یاساکانی تەجوید';
      case ContentPackage.adhkar:
        return 'پەرتووکی ئەزکار و زیکرەکان';
      case ContentPackage.hadith:
        return 'پەرتووکی فەرموودەکان';
      case ContentPackage.tafsir:
        return 'تەفسیری کوردی و عەرەبی';
      case ContentPackage.translations:
        return 'وەرگێڕانی ئایەتەکان';
    }
  }

  IconData _getPackageIcon(ContentPackage pkg) {
    switch (pkg) {
      case ContentPackage.quran:
        return Icons.menu_book_rounded;
      case ContentPackage.tajweed:
        return Icons.g_translate_rounded;
      case ContentPackage.adhkar:
        return Icons.spa_rounded;
      case ContentPackage.hadith:
        return Icons.star_rounded;
      case ContentPackage.tafsir:
        return Icons.library_books_rounded;
      case ContentPackage.translations:
        return Icons.translate_rounded;
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
            'بەڕێوەبەری داگرتنەکان',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
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
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cs.primary,
                          cs.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
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
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const Icon(Icons.storage_rounded, color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _formatSize(_totalStorageBytes),
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'هەموو سەرچاوە دابەزێنراوەکان بە شێوازی ئۆفلاین بەردەستن',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
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
                      Icon(Icons.download_for_offline_rounded, color: cs.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'پاکێجە بەردەستەکان',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
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
                              color: isReady 
                                  ? cs.primary.withValues(alpha: 0.1) 
                                  : cs.textSecondary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getPackageIcon(pkg),
                              color: isReady ? cs.primary : cs.textSecondary,
                            ),
                          ),
                          title: Text(
                            _getPackageNameKu(pkg),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: cs.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            isReady 
                                ? 'قەبارە: ${_formatSize(manifest.sizeBytes)} (وەشان: ${manifest.version})'
                                : 'دابەزنەکراوە / لەگەڵ ئەپەکەدا نەهاتووە',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: cs.textSecondary,
                            ),
                          ),
                          trailing: isReady
                              ? IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                  onPressed: () => _deletePackage(pkg),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: cs.textSecondary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'ئۆفلاین',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 10,
                                      color: cs.textSecondary,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ).animate().fadeIn(duration: 350.ms, delay: 100.ms),

                  const SizedBox(height: 28),

                  // ── Audio Recitations ──────────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.library_music_rounded, color: cs.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'دەنگە داگیراوەکانی قورئانخوێنان',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_downloadedReciters.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.cardBorder),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.cloud_download_outlined, size: 40, color: cs.textSecondary.withValues(alpha: 0.4)),
                            const SizedBox(height: 10),
                            Text(
                              'هیچ سوورەت و دەنگێک دانەگیراوە',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
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
                              child: Icon(Icons.person_rounded, color: cs.primary),
                            ),
                            title: Text(
                              reciter.name,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: cs.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              'قەبارە: ${_formatSize(reciter.sizeBytes)}',
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
