import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import 'auth_provider.dart';

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isChangingPassword = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isChangingPassword = true);

    final result = await ref.read(authRepositoryProvider).changePassword(
          currentPassword: _currentPasswordController.text,
          password: _newPasswordController.text,
          passwordConfirmation: _confirmPasswordController.text,
        );

    if (mounted) {
      setState(() => _isChangingPassword = false);
      result.when(
        success: (_) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('شیکارەکەت بە سەرکەوتوویی نوێکرایەوە', textDirection: TextDirection.rtl, style: TextStyle(fontFamily: 'Cairo')),
              backgroundColor: Colors.green,
            ),
          );
        },
        error: (message, statusCode, cachedData) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message, textDirection: TextDirection.rtl, style: const TextStyle(fontFamily: 'Cairo')),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
      );
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'سڕینەوەی ئەکاونت',
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        content: const Text(
          'ئایا دڵنیایت لە سڕینەوەی ئەکاونتەکەت؟ ئەکاونتەکەت دەچێتە ماوەی ٣٠ ڕۆژ چاکبوونەوە. دوای ٣٠ ڕۆژ سەرجەم داتا و کۆپییە یەدەگەکانت بە یەکجاری دەسڕێنەوە.',
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('پاشگەزبوونەوە', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await ref.read(authProvider.notifier).deleteAccount();
              if (mounted) {
                if (success) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('سڕینەوەی ئەکاونت سەرکەوتوو نەبوو', textDirection: TextDirection.rtl, style: TextStyle(fontFamily: 'Cairo')),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('سڕینەوە', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = ref.watch(accentColorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ڕێکخستنەکانی ئەکاونت',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Theme setting shortcut if desired
            const Text(
              'ڕێکخستنە گشتییەکان',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(Icons.palette_outlined, color: accentColor),
                title: const Text('ڕەنگی سەرەکی ئەپ', style: TextStyle(fontFamily: 'Cairo')),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  // Accent cycle handler
                  ref.read(accentColorProvider.notifier).cycle();
                },
              ),
            ),
            const SizedBox(height: 24),

            // Password Reset Section
            const Text(
              'گۆڕینی شیکارە (Password)',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Current Password
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: _obscureCurrent,
                        decoration: InputDecoration(
                          labelText: 'شیکارەی ئێستا',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                        validator: (value) => value == null || value.isEmpty ? 'تکایە شیکارەی ئێستات بنووسە' : null,
                      ),
                      const SizedBox(height: 16),

                      // New Password
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNew,
                        decoration: InputDecoration(
                          labelText: 'شیکارەی نوێ',
                          prefixIcon: const Icon(Icons.lock_clock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscureNew = !_obscureNew),
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'تکایە شیکارە نوێیەکە دیاری بکە';
                          if (value.length < 8) return 'شیکارە دەبێت لانی کەم ٨ پیت یان ژمارە بێت';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'دووبارەکردنەوەی شیکارەی نوێ',
                          prefixIcon: const Icon(Icons.lock_reset),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'تکایە شیکارە نوێیەکە دووبارە بکەرەوە';
                          if (value != _newPasswordController.text) return 'شیکارەکان وەک یەک نین';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _isChangingPassword ? null : _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isChangingPassword
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('شیکارە بگۆڕە', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Danger Zone
            const Text(
              'ناوچەی مەترسی (Danger Zone)',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.red.withValues(alpha: 0.04),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Logout
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text('چوونەدەرەوە لەم ئامێرە', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      onTap: () async {
                        await ref.read(authProvider.notifier).logout(deviceIdentifier: 'device_mobile_uuid');
                        if (mounted) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      },
                    ),
                    const Divider(),
                    // Logout all devices
                    ListTile(
                      leading: const Icon(Icons.power_settings_new_outlined, color: Colors.redAccent),
                      title: const Text('چوونەدەرەوە لە سەرجەم ئامێرەکان', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      onTap: () async {
                        final repo = ref.read(authRepositoryProvider);
                        final result = await repo.logoutAll();
                        if (mounted) {
                          result.when(
                            success: (_) async {
                              await ref.read(authProvider.notifier).logout();
                              if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            error: (msg, _, __) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                            },
                          );
                        }
                      },
                    ),
                    const Divider(),
                    // Soft Delete Account
                    ListTile(
                      leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                      title: const Text('سڕینەوەی ئەکاونت (Delete Account)', style: TextStyle(fontFamily: 'Cairo', color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      onTap: () => _showDeleteAccountDialog(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
