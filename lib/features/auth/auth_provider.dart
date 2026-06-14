import 'package:flutter_riverpod/flutter_riverpod.dart';
export '../../core/providers/auth_provider.dart';

final readingStreaksProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return {
    'current_streak': 3,
    'longest_streak': 7,
    'today_read': false,
  };
});
