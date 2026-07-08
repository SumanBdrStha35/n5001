import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

part 'user_store.g.dart';

/// Isar user model.
///
/// This app currently only needs email/password for the auth flow on
/// `LoginScreen`.
@collection
class AppUser {
  Id id = Isar.autoIncrement;

  late String email;

  /// Password hash (sha256).
  late String passwordHash;

  /// Optional display name.
  String? username;

  /// Unique index on email.
  @Index(unique: true, replace: true)
  late String emailUnique;
}

/// Simple repository/service for auth related storage.
///
/// Uses Isar for persistence.
class UserStore {
  UserStore({required this.isar});

  final Isar isar;

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> isEmailRegistered(String email) async {
    final normalized = email.trim().toLowerCase();
    final existing = await isar.appUsers
        .filter()
        .emailUniqueEqualTo(normalized)
        .findFirst();
    return existing != null;
  }

  Future<void> createUser({
    required String email,
    required String password,
    String? username,
  }) async {
    final normalized = email.trim().toLowerCase();

    final already = await isEmailRegistered(normalized);
    if (already) {
      throw StateError('Account already exists for this email.');
    }

    final user = AppUser()
      ..email = email.trim()
      ..emailUnique = normalized
      ..username = username
      ..passwordHash = hashPassword(password);

    await isar.writeTxn(() async {
      await isar.appUsers.put(user);
    });
  }

  Future<bool> validateCredentials({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final passwordHash = hashPassword(password);

    final user = await isar.appUsers
        .filter()
        .emailUniqueEqualTo(normalized)
        .passwordHashEqualTo(passwordHash)
        .findFirst();

    return user != null;
  }
}
