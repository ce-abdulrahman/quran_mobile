// ─────────────────────────────────────────────────────────────────────────────
// API Constants
// ─────────────────────────────────────────────────────────────────────────────

class ApiConstants {
  ApiConstants._();

  /// Replace with your actual Laravel server address.
  /// Examples:
  ///   LAN dev:    'http://192.168.1.100/api'
  ///   Production: 'https://api.yourqurandomain.com/api'
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  // ── Endpoints ──────────────────────────────────────────────────────────────
  static const String surahs   = '/surahs';
  static String ayahs(int id)  => '/surahs/$id/ayahs';
  static const String settings = '/settings';
  static const String dailyVerse = '/ayahs/daily';
  static const String banners = '/banners';
  static const String adhkars = '/adhkars';
  static const String tasbihs = '/tasbihs';
  static String pageAyahs(int page) => '/search/by-page/$page';
  static const String memorizationPlansToday = '/memorization-plans/today';
  static const String memorizationReviews = '/memorization-reviews';

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ── Cache TTL ──────────────────────────────────────────────────────────────
  static const Duration surahsTtl   = Duration(hours: 24);
  static const Duration ayahsTtl    = Duration(hours: 24);
  static const Duration settingsTtl = Duration(hours: 1);
  static const Duration dailyVerseTtl = Duration(hours: 12);
}
