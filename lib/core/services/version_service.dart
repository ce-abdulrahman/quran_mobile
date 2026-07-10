import 'package:shared_preferences/shared_preferences.dart';

/// Manages version tracking and changelog display for the app.
class VersionService {
  static const String _lastSeenVersionKey = 'last_seen_version';

  /// Current app version - update this with every release.
  static const String currentVersion = '1.0.5';

  /// Changelog entries per version. Add new version entries at the top.
  static const Map<String, List<ChangelogEntry>> changelog = {
    '1.0.5': [
      ChangelogEntry(
        icon: '📚',
        titleKu: 'داتای نوێی فەرموودەکان',
        descKu: 'داتای فەرموودەکان بەپێی بەشەکان ڕێکخرایەوە و کێشەی نیشاندانی داتا چارەسەر کرا',
      ),
      ChangelogEntry( 
        icon: '🎨',
        titleKu: 'ڕێکخستنی بابەتەکان و ڕەنگەکان',
        descKu: 'کارتی خوێنەری قورئان و چەند لاپەڕەیەکی ناچالاک لادران، و لیستی ڕەنگەکان کورت کرایەوە بۆ ٥ ڕەنگی جوان',
      ),
      ChangelogEntry(
        icon: '📿',
        titleKu: 'نوێکاری لە پەیجی تەسبیح',
        descKu: 'کێشەی داخستنی خولی تەسبیح چارەسەر کرا، و زیکرە سەرەکییەکان بۆ سبحان الله و استغفر الله کورتکرانەوە',
      ),
      ChangelogEntry(
        icon: '🌐',
        titleKu: 'ڕووکارەکانی تەسبیح بە زمانی کوردی',
        descKu: 'پەیجی ڕووکارەکانی تەسبیح بۆ زمانەکانی کوردی و عەرەبی بە تەواوی وەرگێڕدران',
      ),
      ChangelogEntry(
        icon: '🛠️',
        titleKu: 'چارەسەری کێشەی بارکردن',
        descKu: 'کێشەی ڕاوستانی پرۆسەی دابەزاندنی داتا لە ٩٩٪ چارەسەر کرا',
      ),
      ChangelogEntry(
        icon: '📿',
        titleKu: 'ئەزکارەکان زیاد کران',
        descKu: 'ئەزکاری بەیانی، ئێوارە، خەو و دوای نوێژ زیاد کران',
      ),
      ChangelogEntry(
        icon: '🎨',
        titleKu: 'ئایکۆنی نوێ',
        descKu: 'ئایکۆنی ئەپەکە لەسەر شاشە نوێ کرایەوە',
      ),
      ChangelogEntry(
        icon: '📝',
        titleKu: 'چارەسەری کێشەی رووی خوێندنی قورئان',
        descKu: 'کێشەی تەجوید و overflow لەناو رووی خوێندن چارەسەر کرا',
      ),
    ],
    '1.0.4': [
      ChangelogEntry(
        icon: '🕌',
        titleKu: 'رووی مووسحەف زیاد کرا',
        descKu: 'رووی خوێندنی مووسحەف بە شێوازی تازە زیاد کرا',
      ),
      ChangelogEntry(
        icon: '🔊',
        titleKu: 'گۆراندنی دەنگی قورئان باش کرا',
        descKu: 'بچووکترکردنەوەی مشکلاتی دەنگ و بەرزکردنی کیفەیەت',
      ),
    ],
    '1.0.3': [
      ChangelogEntry(
        icon: '⭐',
        titleKu: 'تازەکاری گشتی',
        descKu: 'باشترکردنی گشتی و چارەسەری کێشەکان',
      ),
    ],
  };

  /// Check if the user has seen this version's changelog.
  static Future<bool> shouldShowChangelog() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString(_lastSeenVersionKey);
    return lastSeen != currentVersion;
  }

  /// Mark the current version as seen.
  static Future<void> markVersionSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSeenVersionKey, currentVersion);
  }

  /// Get changelog entries for a specific version, or for all versions if null.
  static List<VersionChangelog> getChangelog({String? forVersion}) {
    if (forVersion != null) {
      final entries = changelog[forVersion];
      if (entries == null) return [];
      return [VersionChangelog(version: forVersion, entries: entries)];
    }

    return changelog.entries
        .map((e) => VersionChangelog(version: e.key, entries: e.value))
        .toList();
  }

  /// Get the changelog for the current version only (for the "What's new" popup).
  static List<ChangelogEntry> getCurrentVersionChangelog() {
    return changelog[currentVersion] ?? [];
  }
}

/// A single changelog entry.
class ChangelogEntry {
  final String icon;
  final String titleKu;
  final String descKu;

  const ChangelogEntry({
    required this.icon,
    required this.titleKu,
    required this.descKu,
  });
}

/// A version's full changelog.
class VersionChangelog {
  final String version;
  final List<ChangelogEntry> entries;

  const VersionChangelog({required this.version, required this.entries});
}

