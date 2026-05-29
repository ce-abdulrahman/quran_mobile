import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/quran_api_client.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool status;
  final int pointsTotal;
  final int streakDays;
  final int longestStreak;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.pointsTotal,
    required this.streakDays,
    required this.longestStreak,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      status: (json['status'] is int) ? (json['status'] == 1) : (json['status'] as bool? ?? true),
      pointsTotal: json['points_total'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'points_total': pointsTotal,
      'streak_days': streakDays,
      'longest_streak': longestStreak,
    };
  }
}

class AuthState {
  final String? token;
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.token,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AuthState copyWith({
    String? token,
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool clearToken = false,
    bool clearUser = false,
  }) {
    return AuthState(
      token: clearToken ? null : (token ?? this.token),
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SharedPreferences _prefs;
  final QuranApiClient _apiClient;

  AuthNotifier(this._prefs, this._apiClient) : super(AuthState()) {
    _loadAuth();
  }

  void _loadAuth() {
    final token = _prefs.getString('auth_token');
    final userJson = _prefs.getString('auth_user');
    if (token != null && token.isNotEmpty) {
      UserModel? user;
      if (userJson != null) {
        try {
          user = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
        } catch (_) {}
      }
      state = AuthState(token: token, user: user);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _apiClient.login(email, password);
      final token = data['token'] as String;
      final userMap = data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);

      await _prefs.setString('auth_token', token);
      await _prefs.setString('auth_user', jsonEncode(userMap));

      state = AuthState(token: token, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _apiClient.register(name, email, password);
      final token = data['token'] as String;
      final userMap = data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);

      await _prefs.setString('auth_token', token);
      await _prefs.setString('auth_user', jsonEncode(userMap));

      state = AuthState(token: token, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('auth_user');
    state = AuthState();
  }

  void updateUserStats(int pointsTotal, int streakDays, int longestStreak) {
    if (state.user != null) {
      final updatedUser = UserModel(
        id: state.user!.id,
        name: state.user!.name,
        email: state.user!.email,
        role: state.user!.role,
        status: state.user!.status,
        pointsTotal: pointsTotal,
        streakDays: streakDays,
        longestStreak: longestStreak,
      );
      _prefs.setString('auth_user', jsonEncode(updatedUser.toJson()));
      state = state.copyWith(user: updatedUser);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  final apiClient = ref.watch(quranApiClientProvider);
  return AuthNotifier(prefs, apiClient);
});
