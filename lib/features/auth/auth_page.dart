import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
import 'auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final isLogin = _tabController.index == 0;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    bool success = false;
    if (isLogin) {
      success = await ref.read(authProvider.notifier).login(email, password);
    } else {
      success = await ref.read(authProvider.notifier).register(name, email, password);
    }

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final authState = ref.watch(authProvider);
    final isLogin = _tabController.index == 0;
    final lang = ref.watch(localeProvider).languageCode;
    final isRtl = lang != 'en';

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.onSuccess != null
            ? null
            : IconButton(
                icon: Icon(Icons.close, color: cs.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryGreen, Color(0xFF2A7A5A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('☪', style: TextStyle(fontSize: 36, color: Colors.white)),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),

                  const SizedBox(height: 24),

                  // Title & Subtitle
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(isLogin),
                      children: [
                        Text(
                          isLogin ? context.l10n.authWelcomeBack : context.l10n.authRegisterTitle,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: cs.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            isLogin ? context.l10n.authWelcomeSub : context.l10n.authRegisterSub,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: cs.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Error Banner
                  if (authState.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().shake(duration: 400.ms),

                  // Tab Selector Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: cs.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.cardBorder),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: cs.textSecondary,
                      labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.normal, fontSize: 13),
                      tabs: [
                        Tab(text: context.l10n.authLogin),
                        Tab(text: context.l10n.authRegister),
                      ],
                    ),
                  ),

                  // Name Field (only for registration)
                  if (!isLogin) ...[
                    TextFormField(
                      controller: _nameController,
                      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: context.l10n.authName,
                        hintText: context.l10n.authNameHint,
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return context.l10n.authNameEmpty;
                        }
                        return null;
                      },
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
                    const SizedBox(height: 16),
                  ],

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr, // Email always LTR
                    decoration: InputDecoration(
                      labelText: context.l10n.authEmail,
                      hintText: 'name@example.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty || !val.contains('@')) {
                        return context.l10n.authEmailInvalid;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textDirection: TextDirection.ltr, // Passwords always LTR
                    decoration: InputDecoration(
                      labelText: context.l10n.authPassword,
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.length < 8) {
                        return context.l10n.authPasswordShort;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              isLogin ? context.l10n.authLogin : context.l10n.authRegister,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Switch Auth Mode link
                  TextButton(
                    onPressed: () {
                      _tabController.animateTo(isLogin ? 1 : 0);
                    },
                    child: Text(
                      isLogin ? context.l10n.authNoAccount : context.l10n.authHasAccount,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
