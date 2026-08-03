import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/notification_service.dart';

class OnboardingDialog extends ConsumerStatefulWidget {
  const OnboardingDialog({super.key});

  static Future<void> showIfNeeded(BuildContext context, WidgetRef ref) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;
    if (hasCompletedOnboarding) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const OnboardingDialog(),
    );
  }

  @override
  ConsumerState<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends ConsumerState<OnboardingDialog> {
  String _selectedLanguage = 'ku';
  ThemeMode _selectedTheme = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: const Text(
          'خۆشھاتیت • أهلاً بك • Welcome',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'زمان هەڵبژێرە / اختر اللغة / Select Language',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'ku', child: Text('کوردی (Kurdî)', style: TextStyle(fontFamily: 'Cairo'))),
                DropdownMenuItem(value: 'ar', child: Text('العربية', style: TextStyle(fontFamily: 'Cairo'))),
                DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(fontFamily: 'Cairo'))),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedLanguage = val;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'ڕووکاری ئەپ / مظهر التطبيق / App Theme',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<ThemeMode>(
              value: _selectedTheme,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('سەرتاپای سیستەم (System)', style: TextStyle(fontFamily: 'Cairo'))),
                DropdownMenuItem(value: ThemeMode.light, child: Text('ڕووناک (Light)', style: TextStyle(fontFamily: 'Cairo'))),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('تاریک (Dark)', style: TextStyle(fontFamily: 'Cairo'))),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedTheme = val;
                  });
                }
              },
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.all(16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AB66D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                // Apply options
                await ref.read(appLocaleProvider.notifier).setLocale(_selectedLanguage);
                await ref.read(themeModeProvider.notifier).setMode(_selectedTheme);
                
                // Request notification permission dynamically
                try {
                  final notifService = NotificationService();
                  final granted = await notifService.requestPermissions();
                  if (granted) {
                    // Schedule right away at 8:00 AM if permission is granted
                    await notifService.scheduleDailyNotifications(hour: 8, minute: 0);
                  }
                } catch (_) {}
                
                // Save onboarding status
                final prefs = ref.read(sharedPreferencesProvider);
                await prefs.setBool('has_completed_onboarding', true);
                
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'تۆمارکردن و بەردەوامبوون',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
