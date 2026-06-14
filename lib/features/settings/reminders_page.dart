import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import 'widgets/reminder_time_card.dart';

class RemindersPage extends ConsumerStatefulWidget {
  const RemindersPage({super.key});

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reminderProvider.notifier).loadReminders();
    });
  }

  Future<void> _saveAllSettings() async {
    final success = await ref.read(reminderProvider.notifier).savePreferences();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Reminders updated successfully!' : 'Failed to save settings.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reminderProvider);
    final cs = AppColorScheme.of(context);
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
          'Reminder Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.textPrimary, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.read(reminderProvider.notifier).loadReminders(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Master toggle header banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Reminders',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Toggle all notification reminders at once',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: state.isMasterEnabled,
                              activeThumbColor: Colors.white,
                              activeTrackColor: Colors.white38,
                              onChanged: (val) {
                                ref.read(reminderProvider.notifier).setMasterEnabled(val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // List of sub-reminder cards
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
                        itemCount: state.reminders.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final reminder = state.reminders[index];
                          return ReminderTimeCard(
                            reminder: reminder,
                            masterEnabled: state.isMasterEnabled,
                            onToggle: (enabled) {
                              ref.read(reminderProvider.notifier).toggleReminderLocally(reminder.type, enabled);
                            },
                            onTimeChanged: (time) {
                              ref.read(reminderProvider.notifier).updateTimeLocally(reminder.type, time);
                            },
                            onFrequencyChanged: (freq, days) {
                              ref.read(reminderProvider.notifier).updateFrequencyLocally(reminder.type, freq, days);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: state.isLoading || state.errorMessage != null
          ? null
          : Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                onPressed: state.isSaving ? null : _saveAllSettings,
                child: state.isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded),
                          SizedBox(width: 8),
                          Text(
                            'Save Preferences',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}
