// ignore_for_file: deprecated_member_use, experimental_member_use
// drift/web.dart uses the older sql.js-based web backend.
// It is deprecated in favour of drift/wasm.dart but is fully functional for web preview.
// Migration to WASM is recommended for production.
import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Web connection — used in Chrome and Edge browsers.
/// Uses WebDatabase backed by IndexedDB via sql.js.
QueryExecutor openAppDatabase() {
  return WebDatabase.withStorage(
    DriftWebStorage.indexedDb('quran_app', migrateFromLocalStorage: true),
  );
}
