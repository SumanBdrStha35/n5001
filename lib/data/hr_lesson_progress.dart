import 'package:isar/isar.dart';

part 'hr_lesson_progress.g.dart';

/// Tracks the user's progress per lesson.
///
/// Each document corresponds to a single lesson identified by [lessonId].
/// [status] can be: "Opened", "Locked", "In Progress", or "Completed".
@collection
class LessonProgress {
  Id id = Isar.autoIncrement;

  /// Unique lesson identifier (e.g. "lesson_1").
  @Index(unique: true, replace: true)
  late String lessonId;

  /// Progress status: "Opened", "Locked", "In Progress", or "Completed".
  late String status;
}
