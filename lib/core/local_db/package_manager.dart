import 'dart:async';
import 'dart:convert';
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
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return PackageManifest.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isPackageReady(ContentPackage pkg) async {
    final manifest = await getManifest(pkg);
    return manifest != null && manifest.isComplete;
  }

  /// Downloads a package and all of its declared dependencies recursively.
  Future<void> downloadPackage(ContentPackage pkg, {void Function(double)? onProgress}) async {
    // 1. Check/Resolve Dependencies first
    final manifest = await _fetchRemoteManifest(pkg);
    for (final dep in manifest.dependencies) {
      final isDepReady = await isPackageReady(dep);
      if (!isDepReady) {
        _eventController.add(PackageDownloadEvent(
          package: pkg,
          progress: 0.0,
          isCompleted: false,
          errorMessage: 'Downloading dependency ${dep.name}...',
        ));
        await downloadPackage(dep);
      }
    }

    _eventController.add(PackageDownloadEvent(package: pkg, progress: 0.1, isCompleted: false));

    // 2. Perform the download into a pending buffer
    final currentManifest = await getManifest(pkg);
    PackageManifest updatedManifest;

    if (currentManifest != null) {
      updatedManifest = manifest.copyWith(
        backupVersion: currentManifest.version,
        backupChecksum: currentManifest.checksum,
      );
    } else {
      updatedManifest = manifest;
    }

    // Simulate download progress
    await Future.delayed(const Duration(milliseconds: 300));
    _eventController.add(PackageDownloadEvent(package: pkg, progress: 0.5, isCompleted: false));
    await Future.delayed(const Duration(milliseconds: 300));

    // 3. Validation & Parsing Verification
    final isValid = await _verifyPackage(pkg, updatedManifest.checksum);
    if (!isValid) {
      // Rollback to previous version if validation fails
      await _rollback(pkg, currentManifest);
      _eventController.add(PackageDownloadEvent(
        package: pkg,
        progress: 0.0,
        isCompleted: false,
        isError: true,
        errorMessage: 'Package validation failed. Rolled back to previous version.',
      ));
      throw Exception('Validation failed for package ${pkg.name}. Rollback executed.');
    }

    // Save manifest as completed and active
    final finalManifest = updatedManifest.copyWith(isComplete: true);
    await _saveManifest(pkg, finalManifest);

    _eventController.add(PackageDownloadEvent(package: pkg, progress: 1.0, isCompleted: true));
  }

  Future<void> updatePackage(ContentPackage pkg) async {
    await downloadPackage(pkg);
  }

  Future<List<ContentPackage>> checkForUpdates() async {
    // Stub: Check if server manifest has higher version numbers
    return [];
  }

  /// Simulate fetching the package manifest from Laravel config endpoint
  Future<PackageManifest> _fetchRemoteManifest(ContentPackage pkg) async {
    // In production, this would make an API call. Here we return defined mocks
    List<ContentPackage> deps = [];
    if (pkg == ContentPackage.translations || pkg == ContentPackage.tajweed || pkg == ContentPackage.tafsir) {
      deps = [ContentPackage.quran]; // Translations, Tajweed, and Tafsir depend on base Quran package
    }

    return PackageManifest(
      package: pkg,
      version: '1.0.0',
      checksum: 'sha256_mock_checksum_${pkg.name}',
      cachedAt: DateTime.now(),
      sizeBytes: 1024 * 1024 * 4,
      isComplete: false,
      dependencies: deps,
    );
  }

  /// Verify checksum and run a mock parsing integrity test on the downloaded bundle.
  Future<bool> _verifyPackage(ContentPackage pkg, String checksum) async {
    // Verification logic (e.g. check if the checksum is correct)
    if (checksum.isEmpty || checksum.contains('corrupted')) {
      return false;
    }
    return true;
  }

  /// Revert a package back to its backup version if validation fails.
  Future<void> _rollback(ContentPackage pkg, PackageManifest? previousManifest) async {
    if (previousManifest != null) {
      // Re-enable and restore the previous manifest
      await _saveManifest(pkg, previousManifest);
    } else {
      // No previous manifest existed, invalidate completely
      final key = 'pkg_manifest_${pkg.name}';
      await _prefs.remove(key);
    }
  }

  Future<void> _saveManifest(ContentPackage pkg, PackageManifest manifest) async {
    final key = 'pkg_manifest_${pkg.name}';
    await _prefs.setString(key, jsonEncode(manifest.toJson()));
  }

  Future<void> deletePackage(ContentPackage pkg) async {
    final key = 'pkg_manifest_${pkg.name}';
    await _prefs.remove(key);
    _eventController.add(PackageDownloadEvent(
      package: pkg,
      progress: 0.0,
      isCompleted: false,
    ));
  }
}
