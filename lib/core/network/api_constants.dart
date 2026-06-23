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
  static const String surahs          = '/surahs';
  static String ayahs(int id)         => '/surahs/$id/ayahs';
  static const String settings        = '/settings';
  static const String dailyVerse      = '/ayahs/daily';
  static const String banners         = '/banners';
  static const String prayerWidget    = '/prayer-widget';
  static const String adhkars         = '/adhkars';
  static const String tasbihs         = '/tasbihs';
  static const String hadiths         = '/hadiths';
  static const String tajweedRules    = '/tajweed-rules';
  static const String tajweedCategories = '/tajweed-categories';
  static String pageAyahs(int page)   => '/search/by-page/$page';
  static const String memorizationPlansToday = '/memorization-plans/today';
  static const String memorizationReviews = '/memorization-reviews';
  static const String dueReviews      = '/reviews/due';
  static const String weakReviews     = '/reviews/weak';
  static const String learningReviews = '/reviews/learning';
  static const String statsFull       = '/memorization/statistics';
  static const String progressDetailed= '/memorization/progress';
  static const String forecastDetailed= '/memorization/forecast';
  static const String sessionLog      = '/memorization/sessions';
  static const String dashboardStats  = '/user-ayah-progress/dashboard';

  // ── Achievements ───────────────────────────────────────────────────────────
  static const String achievements        = '/achievements';
  static const String achievementsSync    = '/achievements/sync';
  static const String achievementsUnlocked= '/achievements/unlocked';
  static String achievement(int id)       => '/achievements/$id';

  // ── Leaderboard ────────────────────────────────────────────────────────────
  static const String leaderboard         = '/leaderboard';
  static const String leaderboardMe       = '/leaderboard/me';
  static const String leaderboardPrivacy  = '/leaderboard/privacy';
  static const String leaderboardTop      = '/leaderboard/top';

  // ── Reminders ──────────────────────────────────────────────────────────────
  static const String reminders           = '/reminders';
  static const String remindersSave       = '/reminders/save';
  static const String remindersEnable     = '/reminders/enable';
  static const String remindersDisable    = '/reminders/disable';
  static const String remindersSync       = '/reminders/sync';
  static const String remindersOpened     = '/reminders/opened';

  // ── Tasbih Sessions ────────────────────────────────────────────────────────
  static const String sessionsStart     = '/sessions/start';
  static const String sessionsIncrement = '/sessions/increment';
  static const String sessionsPause     = '/sessions/pause';
  static const String sessionsResume    = '/sessions/resume';
  static const String sessionsEnd       = '/sessions/end';
  static const String sessionsActive    = '/sessions/active';
  static const String sessionsHistory   = '/sessions/history';
  static const String sessionsAnalytics = '/sessions/analytics';

  // ── Backup & Restore ────────────────────────────────────────────────────────
  static const String backupsCreate         = '/backups/create';
  static const String backupsList           = '/backups';
  static String backupsDownload(int id)    => '/backups/download/$id';
  static const String backupsUpload         = '/backups/upload';
  static const String backupsRestorePreview = '/backups/restore/preview';
  static const String backupsRestore        = '/backups/restore';
  static String backupsDelete(int id)       => '/backups/$id';

  // ── Authentication ──────────────────────────────────────────────────────────
  static const String authLogin          = '/auth/login';
  static const String authRegister       = '/auth/register';
  static const String authLogout         = '/auth/logout';
  static const String authLogoutAll      = '/auth/logout-all';
  static const String authProfile        = '/auth/profile';
  static const String authProfileUpdate  = '/auth/profile/update';
  static const String authChangePassword = '/auth/change-password';
  static const String authGuestConvert   = '/auth/guest-convert';
  static const String authAccountDelete  = '/auth/account/delete';
  static const String authCountries      = '/auth/countries';
  static String authProvinces(int id)    => '/auth/provinces/$id';

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ── Cache TTL ──────────────────────────────────────────────────────────────
  static const Duration surahsTtl   = Duration(hours: 24);
  static const Duration ayahsTtl    = Duration(hours: 24);
  static const Duration settingsTtl = Duration(hours: 1);
  static const Duration dailyVerseTtl = Duration(hours: 12);

  // ── Statistics & Analytics ──────────────────────────────────────────────────
  static const String statsDashboard    = '/statistics/dashboard';
  static const String statsDhikr        = '/statistics/dhikr';
  static const String statsSessions     = '/statistics/sessions';
  static const String statsGoals        = '/statistics/goals';
  static const String statsAchievements = '/statistics/achievements';
  static const String statsStreaks       = '/statistics/streaks';
  static const String statsLeaderboard  = '/statistics/leaderboard';
  static const String statsFingerprint  = '/statistics/fingerprint';
  static const String statsReminders    = '/statistics/reminders';
  static const String statsInsights     = '/statistics/insights';
  static const String statsMilestones   = '/statistics/milestones';
  static const String statsExport       = '/statistics/export';
  static const String statsRefresh      = '/statistics/refresh';

  // ── Fingerprint ────────────────────────────────────────────────────────────
  static const String fingerprintSettings   = '/fingerprint/settings';
  static const String fingerprintSession    = '/fingerprint/session';
  static const String fingerprintStatistics = '/fingerprint/statistics';

  // ── Prayer Times Calendar ──────────────────────────────────────────────────
  static const String prayerTimes        = '/prayer-times';
  static const String prayerTimesCities  = '/prayer-times/cities';
  static const Duration prayerTimesTtl   = Duration(hours: 24);
}

