import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/backup_model.dart';
import '../../core/providers/backup_provider.dart';

class BackupRestorePage extends ConsumerStatefulWidget {
  const BackupRestorePage({super.key});

  @override
  ConsumerState<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends ConsumerState<BackupRestorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _cloudPasswordController = TextEditingController();
  final TextEditingController _localPasswordController = TextEditingController();
  final TextEditingController _importPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(backupStateProvider.notifier).fetchCloudBackups();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cloudPasswordController.dispose();
    _localPasswordController.dispose();
    _importPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(backupStateProvider);
    final notifier = ref.read(backupStateProvider.notifier);
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show success snackbar
    ref.listen<BackupState>(backupStateProvider, (previous, next) {
      if (next.successMessage != null && next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

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
          'پاڵپشتی و گەڕاندنەوە',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'پاڵپشتی سحابی'),
            Tab(text: 'پاڵپشتی ناوخۆیی'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCloudTab(state, notifier, cs, isDark),
          _buildLocalTab(state, notifier, cs, isDark),
        ],
      ),
    );
  }

  Widget _buildCloudTab(BackupState state, BackupNotifier notifier, AppColorScheme cs, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Create Backup Card
        Card(
          elevation: 0,
          color: cs.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'دروستکردنی پاڵپشتی نوێ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cloudPasswordController,
                  obscureText: true,
                  style: TextStyle(color: cs.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'تێپەڕەوشە بۆ سڕکردن (تەشفیر) - ئارەزوومەندانە',
                    labelStyle: TextStyle(color: cs.textSecondary, fontSize: 13),
                    prefixIcon: Icon(Icons.lock_outline, color: cs.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            final pw = _cloudPasswordController.text;
                            await notifier.createCloudBackup(password: pw.isNotEmpty ? pw : null);
                            _cloudPasswordController.clear();
                          },
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_upload_outlined, color: Colors.white),
                    label: const Text(
                      'ئێستا کۆپی بکە',
                      style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Auto Backup Interval
        Card(
          elevation: 0,
          color: cs.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'پاڵپشتی خۆکار',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                    Text(
                      'دیاریکردنی ماوەی پاڵپشتی خۆکار',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: state.autoBackupInterval,
                  dropdownColor: cs.card,
                  style: TextStyle(color: cs.textPrimary, fontFamily: 'Cairo'),
                  items: const [
                    DropdownMenuItem(value: 'disabled', child: Text('ناچالاکە')),
                    DropdownMenuItem(value: 'daily', child: Text('ڕۆژانە')),
                    DropdownMenuItem(value: 'weekly', child: Text('هەفتانە')),
                    DropdownMenuItem(value: 'monthly', child: Text('مانگانە')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      notifier.setAutoBackupInterval(val);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Cloud Backups List
        Text(
          'کۆپییە سحابییەکان',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: cs.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        if (state.isLoading && state.backups.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()))
        else if (state.backups.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'هیچ کۆپییەکی سحابی پاشەکەوت نەکراوە',
                style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.backups.length,
            itemBuilder: (context, index) {
              final b = state.backups[index];
              return Card(
                elevation: 0,
                color: cs.card,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      Icon(
                        b.isEncrypted ? Icons.shield_outlined : Icons.lock_open_outlined,
                        color: b.isEncrypted ? Colors.green : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'پاڵپشتی #${b.id}',
                        style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: cs.textPrimary),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'ڕێکەوت: ${b.createdAt.toLocal().toString().substring(0, 16)}\nقەبارە: ${(b.fileSize / 1024).toStringAsFixed(2)} KB | وەشانی ئەپ: ${b.appVersion ?? "1.0"}',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary, height: 1.5),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.history_outlined, color: cs.primary),
                        onPressed: () => _showRestorePreviewDialog(context, notifier, cs, backup: b),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('سڕینەوەی پاڵپشتی', style: TextStyle(fontFamily: 'Cairo')),
                              content: const Text('ئایا دڵنیایت لە سڕینەوەی ئەم پاڵپشتییە لەسەر سێرڤەر؟', style: TextStyle(fontFamily: 'Cairo')),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('پاشگەزبوونەوە', style: TextStyle(fontFamily: 'Cairo')),
                                ),
                                TextButton(
                                  onPressed: () {
                                    notifier.deleteCloudBackup(b.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('سڕینەوە', style: TextStyle(fontFamily: 'Cairo', color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildLocalTab(BackupState state, BackupNotifier notifier, AppColorScheme cs, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Export Local Card
        Card(
          elevation: 0,
          color: cs.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'هەناردەکردنی پاڵپشتی ناوخۆیی',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'کۆپی کردنی زانیارییەکان بۆ ناو فایلی ناوخۆیی لەسەر مۆبایلەکەت',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: cs.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _localPasswordController,
                  obscureText: true,
                  style: TextStyle(color: cs.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'تێپەڕەوشە بۆ پاراستنی فایلەکە - ئارەزوومەندانە',
                    labelStyle: TextStyle(color: cs.textSecondary, fontSize: 13),
                    prefixIcon: Icon(Icons.lock_outline, color: cs.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            final pw = _localPasswordController.text;
                            await notifier.exportLocalBackup(pw.isNotEmpty ? pw : null);
                            _localPasswordController.clear();
                          },
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    label: const Text(
                      'دروستکردن و هاوبەشکردنی فایل',
                      style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Import Local Card
        Card(
          elevation: 0,
          color: cs.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'گەڕاندنەوە لە فایلی ناوخۆییەوە',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'هێنانە ناوەوەی زانیارییەکان لە فایلی کۆپی پاڵپشتییەوە',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: cs.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _importPasswordController,
                  obscureText: true,
                  style: TextStyle(color: cs.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'تێپەڕەوشەی فایلەکە (ئەگەر سڕکرابوو)',
                    labelStyle: TextStyle(color: cs.textSecondary, fontSize: 13),
                    prefixIcon: Icon(Icons.lock_open_outlined, color: cs.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            final result = await FilePicker.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['json'],
                            );
                            if (result != null && result.files.single.path != null) {
                              final file = File(result.files.single.path!);
                              final pw = _importPasswordController.text;
                              
                              // Trigger restore check
                              _showRestorePreviewDialog(context, notifier, cs, localFile: file, password: pw.isNotEmpty ? pw : null);
                            }
                          },
                    icon: const Icon(Icons.file_open_outlined, color: Colors.white),
                    label: const Text(
                      'هەڵبژاردنی فایل و گەڕاندنەوە',
                      style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showRestorePreviewDialog(BuildContext context, BackupNotifier notifier, AppColorScheme cs, {BackupModel? backup, File? localFile, String? password}) {
    // Call preview generation
    Future.microtask(() {
      notifier.generateRestorePreview(
        backupId: backup?.id,
        localFile: localFile,
        password: password,
      );
    });

    String conflictResolution = 'merge';
    final List<String> modules = ['user', 'tasbih', 'goals', 'achievements', 'sessions', 'reminders', 'leaderboard', 'bookmarks', 'favorites'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cs.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final state = ref.watch(backupStateProvider);

            if (state.isLoading) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final preview = state.previewReport;
            if (preview == null) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.errorMessage ?? 'نەتوانرا پێشبینی گەڕاندنەوە دروست بکرێت',
                      style: TextStyle(fontFamily: 'Cairo', color: Colors.red),
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'پێداچوونەوە پێش گەڕاندنەوە',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.bold, color: cs.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    
                    // Preview Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildReportRow('ئامێری سەرچاوە:', preview.deviceType, cs),
                          _buildReportRow('سیستم:', preview.platform, cs),
                          _buildReportRow('وەشان:', preview.appVersion, cs),
                          _buildReportRow('ژمارەی دانیشتنەکان:', '${preview.sessionsCount} دانە', cs),
                          _buildReportRow('ئامانجەکان:', '${preview.goalsCount} دانە', cs),
                          _buildReportRow('دەستکەوتەکان:', '${preview.achievementsCount} دانە', cs),
                          _buildReportRow('ئاڵۆزییەکان/کێشەکان:', '${preview.sessionConflicts + preview.goalConflicts} ناکۆکی', cs, valColor: Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Conflict resolution chooser
                    Text(
                      'چارەسەری ناکۆکییەکان (دوبارەبوونی داتا)',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: cs.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('تێکەڵکردن (تەوصیە)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                            value: 'merge',
                            groupValue: conflictResolution,
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => conflictResolution = val);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('گۆڕینی هەمووی', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.red)),
                            value: 'replace',
                            groupValue: conflictResolution,
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => conflictResolution = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (conflictResolution == 'replace')
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'ئاگاداری: زانیارییەکانی ئێستات لەسەر مۆبایلەکە دەسڕێنەوە و داتاکانی پاڵپشتییەکە دەخرێنە شوێنی.',
                                style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.red[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Actions
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: state.isRestoring
                            ? null
                            : () async {
                                final success = await notifier.executeRestore(
                                  backupId: backup?.id,
                                  localFile: localFile,
                                  conflictResolution: conflictResolution,
                                  modules: modules,
                                  password: password,
                                );
                                if (success && context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        child: state.isRestoring
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'تەواوکردنی گەڕاندنەوە',
                                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReportRow(String label, String value, AppColorScheme cs, {Color? valColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textSecondary)),
          Text(value, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: valColor ?? cs.textPrimary)),
        ],
      ),
    );
  }
}
