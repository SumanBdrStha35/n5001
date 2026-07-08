import 'package:isar/isar.dart';

import '../data/isar_service.dart';
import '../data/user_store.dart';

class UserProfileService {
  const UserProfileService();

  Future<AppUser?> getCurrentUser() async {
    final isar = await IsarService.instance;
    return isar.appUsers.where().findFirst();
  }
}
