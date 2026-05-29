import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../auth/auth_provider.dart';

final lastReadProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return null;

  final client = ref.watch(quranApiClientProvider);
  return await client.fetchLastRead();
});

final readingStreaksProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return null;

  final client = ref.watch(quranApiClientProvider);
  return await client.fetchReadingStreaks();
});
