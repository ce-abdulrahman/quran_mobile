import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
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
      final l = context.l10n;
      setState(() => _isChangingPassword = false);
      result.when(
        success: (_) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.msgPasswordChanged, textDirection: TextDirection.rtl, style: const TextStyle(fontFamily: 'Cairo')),
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
    final l = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l.authDeleteAccount,
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        content: Text(
          l.authDeleteAccountConfirm,
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Cairo', height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.actionCancel, style: const TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
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
                    SnackBar(
                      content: Text(context.l10n.authDeleteAccountFailed, textDirection: TextDirection.rtl, style: const TextStyle(fontFamily: 'Cairo')),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: Text(l.actionDelete, style: const TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = ref.watch(accentColorProvider);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.authAccountSettings,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // General settings
            Text(
              l.authGeneralSettings,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(Icons.palette_outlined, color: accentColor),
                title: Text(l.authPrimaryColor, style: const TextStyle(fontFamily: 'Cairo')),
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
            Text(
              l.authChangePassword,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
                          labelText: l.authCurrentPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                        validator: (value) => value == null || value.isEmpty ? l.authCurrentPasswordRequired : null,
                      ),
                      const SizedBox(height: 16),

                      // New Password
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNew,
                        decoration: InputDecoration(
                          labelText: l.authNewPassword,
                          prefixIcon: const Icon(Icons.lock_clock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscureNew = !_obscureNew),
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                        validator: (value) {
                          if (value == null || value.isEmpty) return l.authNewPasswordRequired;
                          if (value.length < 8) return l.authPasswordMinLength;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: l.authRepeatNewPassword,
                          prefixIcon: const Icon(Icons.lock_reset),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                        validator: (value) {
                          if (value == null || value.isEmpty) return l.authRepeatNewPasswordRequired;
                          if (value != _newPasswordController.text) return l.authPasswordsDontMatch;
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
                            : Text(l.authChangePassword, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Danger Zone
            Text(
              l.authDangerZone,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent, fontFamily: 'Cairo'),
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
                      title: Text(l.authLogoutThisDevice, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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
                      title: Text(l.authLogoutAllDevices, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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
                      title: Text(l.authDeleteAccount, style: const TextStyle(fontFamily: 'Cairo', color: Colors.redAccent, fontWeight: FontWeight.bold)),
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
