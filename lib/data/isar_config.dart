import 'package:isar/isar.dart';

import 'hr_lesson_progress.dart';
import 'user_store.dart';

/// Central place to list all Isar schemas used by the app.
class IsarConfig {
  static List<CollectionSchema> get schemas => const [
    AppUserSchema,
    LessonProgressSchema,
  ];
}
