import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    // Simulate sending email (would request Laravel password reset endpoint)
    await Future.delayed(const Duration(seconds: 1500));
    
    final l = context.l10n;
    if (mounted) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l.authLinkSentTitle, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Cairo')),
          content: Text(
            l.authLinkSent,
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
                Navigator.of(context).pop(); // pop forgot password page
              },
              child: Text(l.actionOk, style: const TextStyle(fontFamily: 'Cairo')),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = ref.watch(accentColorProvider);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.authResetPassword,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_reset_rounded,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 24),
                Text(
                  l.authForgotPasswordQ,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.authForgotPasswordSub,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 36),
                
                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l.authEmailWithLabel,
                    hintText: 'example@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l.authEmailRequired;
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return l.authEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          l.authSendResetLink,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
