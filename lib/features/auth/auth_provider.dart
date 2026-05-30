import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  const AuthState({required this.isAuthenticated});
}

final authProvider = Provider<AuthState>((ref) {
  return const AuthState(isAuthenticated: false);
});

final readingStreaksProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return {
    'current_streak': 3,
    'longest_streak': 7,
    'today_read': false,
  };
});
