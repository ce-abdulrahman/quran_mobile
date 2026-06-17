import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_db/content_package.dart';
import '../local_db/package_manager.dart';
import 'app_providers.dart';

final packageManagerProvider = Provider<PackageManager>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PackageManager(prefs);
});

final packageDownloadProgressProvider = StreamProvider<PackageDownloadEvent>((ref) {
  final manager = ref.watch(packageManagerProvider);
  return manager.downloadEvents;
});

final isQuranReadyProvider = FutureProvider<bool>((ref) {
  final manager = ref.watch(packageManagerProvider);
  return manager.isPackageReady(ContentPackage.quran);
});

final pendingUpdatesProvider = FutureProvider<List<ContentPackage>>((ref) {
  final manager = ref.watch(packageManagerProvider);
  return manager.checkForUpdates();
});
