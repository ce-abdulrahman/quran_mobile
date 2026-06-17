import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../local_db/guest_memorization_db.dart';
import '../services/guest_memo_migration_service.dart';
import 'app_providers.dart';
import 'tasbih_session_provider.dart';
import 'achievement_provider.dart';
import 'tasbih_theme_provider.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  guest,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final Map<String, dynamic>? stats;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.stats,
    this.errorMessage,
  });

  /// True only when the user has a valid authenticated session.
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// True for both explicit guest mode and unauthenticated state —
  /// i.e., any non-authenticated user who can browse freely.
  bool get isGuest =>
      status == AuthStatus.guest || status == AuthStatus.unauthenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    Map<String, dynamic>? stats,
    String? errorMessage,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      stats: clearUser ? null : (stats ?? this.stats),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState(status: AuthStatus.initial)) {
    checkAuthState();
  }

  SharedPreferences get _prefs => _ref.read(sharedPreferencesProvider);

  /// Check token on app boot.
  /// Always resolves to a usable state — never blocks the user.
  Future<void> checkAuthState() async {
    state = state.copyWith(status: AuthStatus.loading);
    final token = _prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      final repo = _ref.read(authRepositoryProvider);
      final result = await repo.getProfile();

      result.when(
        success: (data) {
          state = AuthState(
            status: AuthStatus.authenticated,
            user: data['user'] as UserModel,
            stats: data['stats'] as Map<String, dynamic>,
          );
          // Sync themes on boot
          _ref.read(tasbihThemeProvider.notifier).syncOnLogin();
        },
        error: (message, statusCode, cachedData) {
          // 401/403 → token is invalid, clear it, continue as guest
          if (statusCode == 401 || statusCode == 403) {
            _prefs.remove('auth_token');
          }
          // Any error (network or auth) → guest mode so app is always usable
          state = AuthState(
            status: AuthStatus.guest,
            errorMessage: message,
          );
        },
      );
    } else {
      // No token → always enter guest mode (app is always usable without login)
      _prefs.setBool('is_guest_mode', true);
      state = const AuthState(status: AuthStatus.guest);
    }
  }

  /// Perform User Login
  Future<bool> login({
    required String login,
    required String password,
    String? deviceIdentifier,
    String? deviceName,
    String? platform,
    String? platformVersion,
    String? pushToken,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    
    // Collect guest progress data for migration if they are currently in guest mode
    Map<String, dynamic>? guestData;
    if (state.status == AuthStatus.guest || _prefs.getBool('is_guest_mode') == true) {
      guestData = _collectGuestData();
    }

    final repo = _ref.read(authRepositoryProvider);
    final result = await repo.login(
      login: login,
      password: password,
      deviceIdentifier: deviceIdentifier,
      deviceName: deviceName,
      platform: platform,
      platformVersion: platformVersion,
      pushToken: pushToken,
      guestData: guestData,
    );

    return result.when(
      success: (data) {
        final token = data['token'] as String;
        _prefs.setString('auth_token', token);
        _prefs.setBool('is_guest_mode', false);
        
        state = AuthState(
          status: AuthStatus.authenticated,
          user: data['user'] as UserModel,
          stats: data['stats'] as Map<String, dynamic>,
        );
        // Sync themes on login
        _ref.read(tasbihThemeProvider.notifier).syncOnLogin();
        // Migrate any guest memorization drafts to the backend
        _migrateGuestMemoDrafts();
        return true;
      },
      error: (message, statusCode, cachedData) {
        state = AuthState(
          status: AuthStatus.error,
          errorMessage: message,
        );
        return false;
      },
    );
  }

  /// Perform User Registration
  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? gender,
    int? birthYear,
    int? countryId,
    int? provinceId,
    String? avatarPath,
    String? deviceIdentifier,
    String? deviceName,
    String? platform,
    String? platformVersion,
    String? pushToken,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    // Collect guest progress data for migration if they are currently in guest mode
    Map<String, dynamic>? guestData;
    if (state.status == AuthStatus.guest || _prefs.getBool('is_guest_mode') == true) {
      guestData = _collectGuestData();
    }

    final repo = _ref.read(authRepositoryProvider);
    final result = await repo.register(
      name: name,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      gender: gender,
      birthYear: birthYear,
      countryId: countryId,
      provinceId: provinceId,
      avatarPath: avatarPath,
      deviceIdentifier: deviceIdentifier,
      deviceName: deviceName,
      platform: platform,
      platformVersion: platformVersion,
      pushToken: pushToken,
      guestData: guestData,
    );

    return result.when(
      success: (data) {
        final token = data['token'] as String;
        _prefs.setString('auth_token', token);
        _prefs.setBool('is_guest_mode', false);

        state = AuthState(
          status: AuthStatus.authenticated,
          user: data['user'] as UserModel,
          stats: data['stats'] as Map<String, dynamic>,
        );
        // Sync themes on register
        _ref.read(tasbihThemeProvider.notifier).syncOnLogin();
        // Migrate any guest memorization drafts to the backend
        _migrateGuestMemoDrafts();
        return true;
      },
      error: (message, statusCode, cachedData) {
        state = AuthState(
          status: AuthStatus.error,
          errorMessage: message,
        );
        return false;
      },
    );
  }

  /// Switch to Guest Mode
  void continueAsGuest() {
    _prefs.setBool('is_guest_mode', true);
    state = const AuthState(status: AuthStatus.guest);
  }

  /// Edit Profile
  Future<bool> updateProfile({
    String? name,
    String? username,
    String? email,
    String? gender,
    int? birthYear,
    int? countryId,
    int? provinceId,
    String? avatarPath,
    String? bio,
    String? nickname,
    String? publicTitle,
    String? profileQuote,
    Map<String, dynamic>? translations,
  }) async {
    final repo = _ref.read(authRepositoryProvider);
    final result = await repo.updateProfile(
      name: name,
      username: username,
      email: email,
      gender: gender,
      birthYear: birthYear,
      countryId: countryId,
      provinceId: provinceId,
      avatarPath: avatarPath,
      bio: bio,
      nickname: nickname,
      publicTitle: publicTitle,
      profileQuote: profileQuote,
      translations: translations,
    );

    return result.when(
      success: (data) {
        state = state.copyWith(
          user: data['user'] as UserModel,
          stats: data['stats'] as Map<String, dynamic>,
        );
        return true;
      },
      error: (message, statusCode, cachedData) {
        return false;
      },
    );
  }

  /// User Logout — always reverts to guest mode so app stays usable
  Future<void> logout({String? deviceIdentifier}) async {
    final repo = _ref.read(authRepositoryProvider);
    await repo.logout(deviceIdentifier: deviceIdentifier);

    _prefs.remove('auth_token');
    _prefs.setBool('is_guest_mode', true);

    state = const AuthState(status: AuthStatus.guest);
  }

  /// Soft Delete Account — reverts to guest mode
  Future<bool> deleteAccount() async {
    final repo = _ref.read(authRepositoryProvider);
    final result = await repo.deleteAccount();
    
    return result.when(
      success: (_) {
        _prefs.remove('auth_token');
        _prefs.setBool('is_guest_mode', true);
        state = const AuthState(status: AuthStatus.guest);
        return true;
      },
      error: (message, statusCode, cachedData) {
        return false;
      },
    );
  }

  /// Background migration of guest memorization drafts to backend API.
  /// Called after successful login or registration.
  void _migrateGuestMemoDrafts() {
    // Run in the background — don't await, don't block login flow
    Future.microtask(() async {
      try {
        final db = GuestMemorizationDb();
        await db.init();
        if (db.pendingCount == 0) return;

        final apiClient = _ref.read(apiClientProvider);
        final service = GuestMemoDraftMigrationService(db, apiClient);
        final result = await service.migrate();

        if (result.succeeded > 0) {
          // Could show a SnackBar via a global key if needed
          // For now: silent background migration
        }
      } catch (e) {
        // Migration failure is non-fatal; drafts remain in local DB
        // and can be retried later
      }
    });
  }

  /// Gathers local progress state for merging with user profile
  Map<String, dynamic> _collectGuestData() {
    final data = <String, dynamic>{};
    
    // Streaks
    try {
      final tasbihState = _ref.read(tasbihProvider);
      data['streaks'] = {
        'current_streak': tasbihState.currentStreak,
        'longest_streak': tasbihState.longestStreak,
        'last_activity_date': tasbihState.lastActivityDate,
      };
    } catch (_) {}

    // Goals
    try {
      final tasbihState = _ref.read(tasbihProvider);
      if (tasbihState.dailyGoalDate != null) {
        data['goals'] = [
          {
            'goal_date': tasbihState.dailyGoalDate,
            'goal_value': tasbihState.dailyGoalValue,
            'today_progress': tasbihState.dailyGoalProgress,
            'is_completed': tasbihState.dailyGoalCompleted,
          }
        ];
      }
    } catch (_) {}

    // Sessions history
    try {
      final sessionState = _ref.read(tasbihSessionProvider);
      data['sessions'] = sessionState.history.map((s) => {
        'start_time': s.startTime.toIso8601String(),
        'end_time': s.endTime?.toIso8601String(),
        'duration_seconds': s.durationSeconds,
        'total_count': s.totalCount,
        'avg_per_minute': s.avgPerMinute,
        'session_date': s.sessionDate,
        'status': s.status,
        'custom_dhikr_name': s.customDhikrName,
      }).toList();
    } catch (_) {}

    // Achievements
    try {
      final achievementState = _ref.read(achievementProvider);
      data['achievements'] = achievementState.completed.map((a) => {
        'achievement_id': a.id,
        'unlocked_at': a.completedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      }).toList();
    } catch (_) {}

    return data;
  }
}
