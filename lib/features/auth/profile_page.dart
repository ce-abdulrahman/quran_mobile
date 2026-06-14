import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import 'auth_provider.dart';
import 'profile_settings_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _nicknameController;
  late TextEditingController _titleController;
  late TextEditingController _quoteController;
  
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController(text: user?.profile?.bio ?? '');
    _nicknameController = TextEditingController(text: user?.profile?.nickname ?? '');
    _titleController = TextEditingController(text: user?.profile?.publicTitle ?? '');
    _quoteController = TextEditingController(text: user?.profile?.profileQuote ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _nicknameController.dispose();
    _titleController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    final success = await ref.read(authProvider.notifier).updateProfile(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      nickname: _nicknameController.text.trim(),
      publicTitle: _titleController.text.trim(),
      profileQuote: _quoteController.text.trim(),
    );
    
    if (mounted) {
      setState(() {
        _isSaving = false;
        if (success) _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'پرۆفایلەکەت بە سەرکەوتوویی نوێکرایەوە' : 'نوێکردنەوەی پرۆفایل سەرکەوتوو نەبوو',
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: success ? Colors.green : Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final stats = authState.stats ?? {};
    final accentColor = ref.watch(accentColorProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'تکایە سەرەتا بچۆ ژوورەوە',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
          ),
        ),
      );
    }

    final totalDhikrs = stats['total_dhikrs'] ?? 0;
    final goalCompletionRate = stats['goal_completion_rate'] ?? 0;
    final achievementsCount = stats['achievements_count'] ?? 0;
    final totalSessions = stats['total_sessions'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'پرۆفایلی من',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileSettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar & Name Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: accentColor.withValues(alpha: 0.1),
                            backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
                            child: user.avatar == null
                                ? Text(
                                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: accentColor, fontFamily: 'Cairo'),
                                  )
                                : null,
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                                  onPressed: () {
                                    // File upload simulation (or integration with image_picker in production)
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${user.username}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 16),
                      
                      // Profile Completion Rate Indicator
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${user.profileCompletionPercentage}%',
                                style: TextStyle(fontWeight: FontWeight.bold, color: accentColor, fontFamily: 'Cairo'),
                              ),
                              const Text(
                                'ڕێژەی تەواوبوونی پرۆفایل',
                                style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: user.profileCompletionPercentage / 100,
                              backgroundColor: Colors.grey.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Statistics Section
              const Text(
                'ئامارەکانی من',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 12),
              
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    context,
                    title: 'زیکرەکان',
                    value: totalDhikrs.toString(),
                    icon: Icons.fingerprint,
                    color: Colors.blueAccent,
                  ),
                  _buildStatCard(
                    context,
                    title: 'ڕێژەی ئامانجەکان',
                    value: '$goalCompletionRate%',
                    icon: Icons.track_changes_outlined,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    context,
                    title: 'خولەکان',
                    value: totalSessions.toString(),
                    icon: Icons.hourglass_empty_outlined,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    title: 'دەستکەوتەکان',
                    value: achievementsCount.toString(),
                    icon: Icons.emoji_events_outlined,
                    color: Colors.amber,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Account Details Info and Form
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isEditing)
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _isEditing = false),
                          child: const Text('پاشگەزبوونەوە', style: TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(backgroundColor: accentColor, foregroundColor: Colors.white),
                          child: _isSaving
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('پاشەکەوت', style: TextStyle(fontFamily: 'Cairo')),
                        ),
                      ],
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _isEditing = true),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('دەستکاریکردن', style: TextStyle(fontFamily: 'Cairo')),
                      style: OutlinedButton.styleFrom(foregroundColor: accentColor, side: BorderSide(color: accentColor)),
                    ),
                  const Text(
                    'زانیارییە کەسییەکان',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Full Name Field
                      TextFormField(
                        controller: _nameController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          labelText: 'ناو',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'تکایە ناو بنووسە' : null,
                      ),
                      const SizedBox(height: 16),

                      // Username Field
                      TextFormField(
                        controller: _usernameController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          labelText: 'ناوی بەکارهێنەر',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'تکایە ناوی بەکارهێنەر بنووسە' : null,
                      ),
                      const SizedBox(height: 16),

                      // Bio Field
                      TextFormField(
                        controller: _bioController,
                        enabled: _isEditing,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'دەربارە (Bio)',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nickname Field
                      TextFormField(
                        controller: _nicknameController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          labelText: 'نازناو (Nickname)',
                          prefixIcon: Icon(Icons.face_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Public Title Field
                      TextFormField(
                        controller: _titleController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          labelText: 'ناونیشانی گشتی',
                          prefixIcon: Icon(Icons.military_tech_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Profile Quote Field
                      TextFormField(
                        controller: _quoteController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          labelText: 'وتەی پرۆفایل',
                          prefixIcon: Icon(Icons.format_quote_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo'),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
