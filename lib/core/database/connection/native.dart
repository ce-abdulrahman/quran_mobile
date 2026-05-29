import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native connection — used on Android, iOS, and Desktop.
/// Uses NativeDatabase backed by a real SQLite file via dart:ffi.
QueryExecutor openAppDatabase() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'quran_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
