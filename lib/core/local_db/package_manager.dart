import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'content_package.dart';

class PackageManager {
  final SharedPreferences _prefs;
  final _eventController = StreamController<PackageDownloadEvent>.broadcast();

  PackageManager(this._prefs);

  Stream<PackageDownloadEvent> get downloadEvents => _eventController.stream;

  Future<PackageManifest?> getManifest(ContentPackage pkg) async {
    final key = 'pkg_manifest_${pkg.name}';
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      // return manifest parsed from JSON
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> isPackageReady(ContentPackage pkg) async {
    // Basic stub: Quran package ready if downloaded version key exists
    final version = _prefs.getString('pkg_version_${pkg.name}');
    return version != null && version.isNotEmpty;
  }

  Future<void> downloadPackage(ContentPackage pkg, {void Function(double)? onProgress}) async {
    _eventController.add(PackageDownloadEvent(package: pkg, progress: 0.1, isCompleted: false));
    await Future.delayed(const Duration(milliseconds: 500));
    _eventController.add(PackageDownloadEvent(package: pkg, progress: 0.5, isCompleted: false));
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Seed version key
    await _prefs.setString('pkg_version_${pkg.name}', '1.0.0');
    
    _eventController.add(PackageDownloadEvent(package: pkg, progress: 1.0, isCompleted: true));
  }

  Future<void> updatePackage(ContentPackage pkg) async {
    await downloadPackage(pkg);
  }

  Future<List<ContentPackage>> checkForUpdates() async {
    return [];
  }
}
