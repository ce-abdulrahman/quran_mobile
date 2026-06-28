import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/audio_download_manager.dart';

class DownloadDashboardScreen extends ConsumerStatefulWidget {
  const DownloadDashboardScreen({super.key});

  @override
  ConsumerState<DownloadDashboardScreen> createState() => _DownloadDashboardScreenState();
}

class _DownloadDashboardScreenState extends ConsumerState<DownloadDashboardScreen> {
  int _totalStorageBytes = 0;
  List<CachedReciter> _downloadedReciters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    setState(() => _isLoading = true);
    final manager = AudioDownloadManager();
    final total = await manager.getTotalStorageBytes();
    final reciters = await manager.getDownloadedReciters();
    if (mounted) {
      setState(() {
        _totalStorageBytes = total;
        _downloadedReciters = reciters;
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

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final queueStateStream = AudioDownloadManager().watchQueueState();

    final isRtl = Localizations.localeOf(context).languageCode == 'ar' || Localizations.localeOf(context).languageCode == 'ku';
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF030D08) : const Color(0xFFF4F6F5),
        appBar: AppBar(
          title: const Text(
            'داشبۆردی داگرتنەکان',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Storage Card (Glassmorphism & Gradients)
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
                                'بیرگەی بەکارهاتوو (Storage Used)',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.8),
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
                          const SizedBox(height: 20),
                          // Fake limit line
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (_totalStorageBytes / (500 * 1024 * 1024)).clamp(0.0, 1.0),
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'سنووری پاشەکەوتکردن: 500 MB',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              Text(
                                '${((_totalStorageBytes / (500 * 1024 * 1024)) * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Active Download Queue Panel
                    StreamBuilder<DownloadQueueState>(
                      stream: queueStateStream,
                      builder: (context, snapshot) {
                        final qState = snapshot.data;
                        if (qState == null || (qState.pendingCount == 0 && qState.activeProgress == null)) {
                          return const SizedBox.shrink();
                        }

                        final active = qState.activeProgress;
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cs.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: cs.cardBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'داگرتنە چالاکەکان (${qState.pendingCount + (active != null ? 1 : 0)})',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: cs.textPrimary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          qState.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                                          color: cs.primary,
                                        ),
                                        onPressed: () {
                                          if (qState.isPaused) {
                                            AudioDownloadManager().resumeQueue();
                                          } else {
                                            AudioDownloadManager().pauseQueue();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              if (active != null) ...[
                                StreamBuilder<DownloadProgress>(
                                  stream: AudioDownloadManager().watchProgress(active.reciterId, active.surahId),
                                  builder: (context, progressSnapshot) {
                                    final progress = progressSnapshot.data ?? active;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'سوورەتی ژمارە ${progress.surahId}',
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: cs.textPrimary,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 20),
                                              onPressed: () {
                                                AudioDownloadManager().cancelDownload(progress.reciterId, progress.surahId);
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: LinearProgressIndicator(
                                            value: progress.progress,
                                            backgroundColor: cs.primary.withValues(alpha: 0.1),
                                            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                                            minHeight: 6,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'داگرتن: ${(progress.progress * 100).toStringAsFixed(1)}%',
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 12,
                                                color: cs.textSecondary,
                                              ),
                                            ),
                                            Text(
                                              '${_formatSize(progress.bytesDownloaded)} / ${_formatSize(progress.totalBytes)}',
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                fontSize: 12,
                                                color: cs.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                              if (qState.pendingCount > 0) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'لە سەرەدان: ${qState.pendingCount} سوورەتی تر',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: cs.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                    // Downloaded Content Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'سوورەتە داگیراوەکان',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: cs.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await AudioDownloadManager().runCleanupPolicy();
                            _loadStorageInfo();
                          },
                          icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                          label: const Text(
                            'پاککردنەوەی LRU',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
                          ),
                          style: TextButton.styleFrom(foregroundColor: cs.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_downloadedReciters.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.cloud_download_outlined, size: 48, color: cs.textSecondary.withValues(alpha: 0.5)),
                              const SizedBox(height: 12),
                              Text(
                                'هیچ سوورەتێک دانەگیراوە',
                                style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _downloadedReciters.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final reciter = _downloadedReciters[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: cs.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: cs.cardBorder),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: cs.primary.withValues(alpha: 0.1),
                                child: Icon(Icons.person_rounded, color: cs.primary),
                              ),
                              title: Text(
                                reciter.name,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: cs.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                'قەبارە: ${_formatSize(reciter.sizeBytes)}',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  color: cs.textSecondary,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      final isRtl = Localizations.localeOf(context).languageCode == 'ar' || Localizations.localeOf(context).languageCode == 'ku';
                                      return Directionality(
                                        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                                        child: AlertDialog(
                                        title: Text(context.l10n.downloadDeleteReciterTitle, style: const TextStyle(fontFamily: 'Cairo')),
                                        content: Text(context.l10n.downloadDeleteReciterConfirm(reciter.name), style: const TextStyle(fontFamily: 'Cairo')),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text(context.l10n.actionCancel, style: const TextStyle(fontFamily: 'Cairo')),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                                            onPressed: () => Navigator.pop(context, true),
                                            child: Text(context.l10n.actionDelete, style: const TextStyle(fontFamily: 'Cairo')),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );

                                  if (confirm == true) {
                                    await AudioDownloadManager().deleteReciter(reciter.id);
                                    _loadStorageInfo();
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
