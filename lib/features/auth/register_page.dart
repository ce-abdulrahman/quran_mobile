import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import 'auth_provider.dart';
import 'login_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  String? _selectedGender;
  int? _selectedBirthYear;
  int? _selectedCountryId;
  int? _selectedProvinceId;

  List<Map<String, dynamic>> _countries = [];
  List<Map<String, dynamic>> _provinces = [];
  bool _isLoadingLocations = false;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoadingLocations = true);
    final result = await ref.read(authRepositoryProvider).getCountries();
    if (mounted) {
      result.when(
        success: (data) {
          setState(() {
            _countries = data;
            _isLoadingLocations = false;
          });
        },
        error: (message, statusCode, cachedData) {
          setState(() => _isLoadingLocations = false);
        },
      );
    }
  }

  Future<void> _loadProvinces(int countryId) async {
    setState(() {
      _isLoadingLocations = true;
      _provinces = [];
      _selectedProvinceId = null;
    });
    final result = await ref.read(authRepositoryProvider).getProvinces(countryId);
    if (mounted) {
      result.when(
        success: (data) {
          setState(() {
            _provinces = data;
            _isLoadingLocations = false;
          });
        },
        error: (message, statusCode, cachedData) {
          setState(() => _isLoadingLocations = false);
        },
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmController.text,
          gender: _selectedGender,
          birthYear: _selectedBirthYear,
          countryId: _selectedCountryId,
          provinceId: _selectedProvinceId,
          deviceIdentifier: 'device_mobile_uuid',
          deviceName: 'Flutter Mobile Device',
          platform: 'Mobile',
        );

    if (mounted) {
      if (success) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        final error = ref.read(authProvider).errorMessage ?? 'هەڵەیەک لە دروستکردنی ئەکاونتدا ڕوویدا';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = ref.watch(accentColorProvider);
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'خۆتۆمارکردن',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'ئەکاونت دروستبکە',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'زانیارییەکانت بنووسە بۆ تۆمارکردنی ئەکاونتێکی نوێ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 36),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'ناوی تەواوت',
                    hintText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'تکایە ناوەکەت بنووسە';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'ناوی بەکارهێنەر',
                    hintText: 'username',
                    prefixIcon: const Icon(Icons.alternate_email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  textDirection: TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'تکایە ناوی بەکارهێنەر بنووسە';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'ئیمەیڵ',
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
                      return 'تکایە ئیمەیڵەکەت بنووسە';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'تکایە ئیمەیڵێکی دروست بنووسە';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'وشەی نهێنی بنووسە',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  textDirection: TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'تکایە وشەی نهێنی بنووسە';
                    }
                    if (value.length < 8) {
                      return 'وشەی نهێنی دەبێت لانی کەم ٨ پیت یان ژمارە بێت';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password confirmation field
                TextFormField(
                  controller: _passwordConfirmController,
                  obscureText: _obscurePasswordConfirm,
                  decoration: InputDecoration(
                    labelText: 'دووبارەکردنەوەی وشەی نهێنی',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePasswordConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(() => _obscurePasswordConfirm = !_obscurePasswordConfirm),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  textDirection: TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'تکایە وشەی نهێنی دووبارە بنووسەوە';
                    }
                    if (value != _passwordController.text) {
                      return 'وشەکان وەک یەک نین';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Optional profile demographic settings
                const Divider(height: 32),
                const Text(
                  'زانیارییە زیاتر (ئارەزوومەندانە)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),

                // Gender selector
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'ڕەگەز (Gender)',
                    prefixIcon: const Icon(Icons.family_restroom_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('نێر')),
                    DropdownMenuItem(value: 'female', child: Text('مێ')),
                  ],
                  onChanged: (val) => setState(() => _selectedGender = val),
                ),
                const SizedBox(height: 20),

                // Birth Year selector
                DropdownButtonFormField<int>(
                  value: _selectedBirthYear,
                  decoration: InputDecoration(
                    labelText: 'ساڵی لەدایکبوون',
                    prefixIcon: const Icon(Icons.cake_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: List.generate(
                    DateTime.now().year - 1900 + 1,
                    (index) {
                      final year = DateTime.now().year - index;
                      return DropdownMenuItem(value: year, child: Text(year.toString()));
                    },
                  ),
                  onChanged: (val) => setState(() => _selectedBirthYear = val),
                ),
                const SizedBox(height: 20),

                // Country selector
                DropdownButtonFormField<int>(
                  value: _selectedCountryId,
                  decoration: InputDecoration(
                    labelText: 'وڵات',
                    prefixIcon: const Icon(Icons.public_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: _isLoadingLocations
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                  ),
                  items: _countries.map((c) {
                    final trs = c['translations'] as List?;
                    // Fallback to English (language_id: 1) or first translation
                    final name = trs != null && trs.isNotEmpty
                        ? trs.firstWhere((t) => t['language_id'] == 1, orElse: () => trs.first)['value'] as String
                        : 'Unknown';
                    return DropdownMenuItem(value: c['id'] as int, child: Text(name));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedCountryId = val);
                      _loadProvinces(val);
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Province selector
                DropdownButtonFormField<int>(
                  value: _selectedProvinceId,
                  decoration: InputDecoration(
                    labelText: 'شار/پارێزگا',
                    prefixIcon: const Icon(Icons.map_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: _provinces.map((p) {
                    final trs = p['translations'] as List?;
                    final name = trs != null && trs.isNotEmpty
                        ? trs.firstWhere((t) => t['language_id'] == 1, orElse: () => trs.first)['value'] as String
                        : 'Unknown';
                    return DropdownMenuItem(value: p['id'] as int, child: Text(name));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedProvinceId = val),
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'دروستکردنی ئەکاونت',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Navigate to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: Text(
                        'بچۆ ژوورەوە',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    const Text(
                      'پێشتر ئەکاونتت دروستکردووە؟',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
