import 'package:isar/isar.dart';

import 'user_store.dart';

/// Central place to list all Isar schemas used by the app.
class IsarConfig {
  static List<CollectionSchema> get schemas => const [AppUserSchema];
}
