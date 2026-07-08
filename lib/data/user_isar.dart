import 'package:isar/isar.dart';

part 'user_isar.g.dart';

@collection
class UserIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String email;

  late String passwordHash;
  late DateTime createdAt;
}
