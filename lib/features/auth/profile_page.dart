import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
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
      final l = context.l10n;
      setState(() {
        _isSaving = false;
        if (success) _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? l.authProfileUpdated : l.authProfileUpdateFailed,
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
    final l = context.l10n;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            l.authPleaseLoginFirst,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
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
        title: Text(
          l.authMyProfile,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
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
                              Text(
                                l.authProfileCompletion,
                                style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo'),
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
              Text(
                l.authMyStats,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
                    title: l.authDhikrs,
                    value: totalDhikrs.toString(),
                    icon: Icons.fingerprint,
                    color: Colors.blueAccent,
                  ),
                  _buildStatCard(
                    context,
                    title: l.authGoalsRate,
                    value: '$goalCompletionRate%',
                    icon: Icons.track_changes_outlined,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    context,
                    title: l.authSessions,
                    value: totalSessions.toString(),
                    icon: Icons.hourglass_empty_outlined,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    title: l.authAchievements,
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
                          child: Text(l.actionCancel, style: const TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(backgroundColor: accentColor, foregroundColor: Colors.white),
                          child: _isSaving
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(l.actionSave, style: const TextStyle(fontFamily: 'Cairo')),
                        ),
                      ],
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _isEditing = true),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: Text(l.actionEdit, style: const TextStyle(fontFamily: 'Cairo')),
                      style: OutlinedButton.styleFrom(foregroundColor: accentColor, side: BorderSide(color: accentColor)),
                    ),
                  Text(
                    l.authPersonalDetails,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
                        decoration: InputDecoration(
                          labelText: l.authName,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) => value == null || value.isEmpty ? l.authNameRequired : null,
                      ),
                      const SizedBox(height: 16),

                      // Username Field
                      TextFormField(
                        controller: _usernameController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          labelText: l.authUsername,
                          prefixIcon: const Icon(Icons.alternate_email),
                        ),
                        validator: (value) => value == null || value.isEmpty ? l.authUsernameRequired : null,
                      ),
                      const SizedBox(height: 16),

                      // Bio Field
                      TextFormField(
                        controller: _bioController,
                        enabled: _isEditing,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: l.authBio,
                          prefixIcon: const Icon(Icons.info_outline),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nickname Field
                      TextFormField(
                        controller: _nicknameController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          labelText: l.authNickname,
                          prefixIcon: const Icon(Icons.face_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Public Title Field
                      TextFormField(
                        controller: _titleController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          labelText: l.authPublicTitle,
                          prefixIcon: const Icon(Icons.military_tech_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Profile Quote Field
                      TextFormField(
                        controller: _quoteController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          labelText: l.authProfileQuote,
                          prefixIcon: const Icon(Icons.format_quote_outlined),
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
