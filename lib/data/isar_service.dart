import 'package:isar/isar.dart';

import 'dart:io';

class IsarService {
  IsarService._();

  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    final dir = Directory.systemTemp.path;

    _isar = await Isar.open([], directory: dir);

    return _isar!;
  }
}
