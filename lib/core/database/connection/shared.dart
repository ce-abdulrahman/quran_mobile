// Platform-conditional database connection.
// The correct implementation is selected at compile-time via conditional imports.
// See: native.dart (mobile/desktop) and web.dart (browser)
export 'package:drift/drift.dart' show QueryExecutor;
