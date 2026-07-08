import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'isar_config.dart';

/// Provides a lazily-initialized Isar instance for the app.
class IsarService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    final directory = await _isarDirectory;
    _isar = await Isar.open(IsarConfig.schemas, directory: directory);

    return _isar!;
  }

  static Future<String> get _isarDirectory async {
    // Use platform-correct persistent storage.
    final baseDir = await getApplicationDocumentsDirectory();
    final isarDir = Directory('${baseDir.path}/isar');

    // Ensure it exists before Isar opens.
    if (!await isarDir.exists()) {
      await isarDir.create(recursive: true);
    }

    return isarDir.path;
  }
}
