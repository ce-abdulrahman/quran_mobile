import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/tasbih_theme_model.dart';
import '../../../core/providers/tasbih_theme_provider.dart';
import 'theme_preview_overlay.dart';

class ThemeSelectorPage extends ConsumerWidget {
  const ThemeSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(tasbihThemeProvider);
    final themeNotifier = ref.read(tasbihThemeProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Tasbih Themes',
          style: TextStyle(fontFamily: 'Patua One', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          if (themeState.isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: themeState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFffd700)),
              ),
            )
          : DefaultTabController(
              length: themeState.categories.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    indicatorColor: const Color(0xFFffd700),
                    labelColor: const Color(0xFFffd700),
                    unselectedLabelColor: Colors.white60,
                    tabs: themeState.categories.map((cat) {
                      return Tab(
                        child: Row(
                          children: [
                            Icon(_getCategoryIcon(cat.icon), size: 16),
                            const SizedBox(width: 8),
                            Text(cat.name),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: themeState.categories.map((cat) {
                        return _buildThemeGrid(context, cat.themes, themeNotifier, themeState);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  IconData _getCategoryIcon(String iconClass) {
    switch (iconClass) {
      case 'bi bi-moon-stars-fill':
        return Icons.brightness_3;
      case 'bi bi-tree-fill':
        return Icons.park;
      case 'bi bi-circle-half':
        return Icons.tonality;
      case 'bi bi-star-fill':
        return Icons.grade;
      case 'bi bi-cloud-sun-fill':
        return Icons.filter_drama;
      default:
        return Icons.palette;
    }
  }

  Widget _buildThemeGrid(
    BuildContext context,
    List<TasbihThemeModel> themes,
    TasbihThemeNotifier themeNotifier,
    TasbihThemeState themeState,
  ) {
    if (themes.isEmpty) {
      return const Center(
        child: Text(
          'No themes available in this category',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.72,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        return _buildThemeCard(context, theme, themeNotifier, themeState);
      },
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    TasbihThemeModel theme,
    TasbihThemeNotifier themeNotifier,
    TasbihThemeState themeState,
  ) {
    final isActive = themeState.activeTheme?.themeKey == theme.themeKey;

    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: isActive ? const Color(0xFFffd700) : Colors.transparent,
          width: 2.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview / Thumbnail Block
              Expanded(
                child: Container(
                  color: Colors.black26,
                  child: theme.thumbnail != null
                      ? Image.network(
                          theme.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildMockThumbnail(theme),
                        )
                      : _buildMockThumbnail(theme),
                ),
              ),
              // Name & Category metadata
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.description,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Actions (Apply / Preview)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!theme.isUnlocked) {
                                _showUnlockPrompt(context, theme);
                              } else {
                                themeNotifier.applyTheme(theme);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isActive
                                  ? const Color(0xFFffd700)
                                  : (theme.isUnlocked
                                      ? Colors.white24
                                      : Colors.amber.shade900),
                              foregroundColor: isActive ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              isActive
                                  ? 'Applied'
                                  : (theme.isUnlocked
                                      ? 'Apply'
                                      : 'Unlock'),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined, size: 20),
                          color: Colors.white70,
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (context, _, __) =>
                                    ThemePreviewOverlay(theme: theme),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Badges / Favorites
          Positioned(
            top: 8,
            left: 8,
            child: _buildBadge(theme),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(
                theme.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: theme.isFavorite ? Colors.red : Colors.white70,
              ),
              onPressed: () => themeNotifier.toggleFavorite(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockThumbnail(TasbihThemeModel theme) {
    // Elegant fallback based on theme key configurations
    final color = _getThemeColor(theme.themeKey);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.8), color.withOpacity(0.3)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.palette_outlined, color: Colors.white70, size: 36),
            const SizedBox(height: 8),
            Text(
              theme.themeKey.toUpperCase().replaceAll('_', ' '),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThemeColor(String key) {
    if (key.contains('kaaba')) return const Color(0xFFffd700);
    if (key.contains('madinah')) return const Color(0xFF2e7d32);
    if (key.contains('minimal')) return const Color(0xFF333333);
    if (key.contains('forest')) return const Color(0xFF1b3d2f);
    if (key.contains('ramadan')) return const Color(0xFFffb300);
    return Colors.blueGrey;
  }

  Widget _buildBadge(TasbihThemeModel theme) {
    if (theme.isFeatured) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.shade800,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'FEATURED',
          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
        ),
      );
    }
    if (theme.unlockType == 'premium') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.purple.shade700,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'PREMIUM',
          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _showUnlockPrompt(BuildContext context, TasbihThemeModel theme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            'Unlock ${theme.name}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            theme.unlockType == 'points'
                ? 'This theme requires ${theme.unlockValue} points to unlock.'
                : (theme.unlockType == 'streak'
                    ? 'Reach a ${theme.unlockValue}-day Tasbih streak to unlock this theme.'
                    : 'Requires event/achievement progress to unlock.'),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFffd700)),
              child: const Text('Okay', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
