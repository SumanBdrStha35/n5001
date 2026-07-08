import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';
import 'user_isar.dart';

class AuthRepository {
  AuthRepository._();

  static Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final isar = await IsarService.instance;

    final hash = sha256.convert(utf8.encode(password)).toString();

    final existing = await isar.userIsars
        .where()
        .emailEqualTo(email)
        .findFirst();

    if (existing != null) {
      throw StateError('Email already registered');
    }

    await isar.writeTxn(() async {
      await isar.userIsars.put(
        UserIsar()
          ..email = email
          ..passwordHash = hash
          ..createdAt = DateTime.now(),
      );
    });
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final isar = await IsarService.instance;

    final hash = sha256.convert(utf8.encode(password)).toString();

    final user = await isar.userIsars.where().emailEqualTo(email).findFirst();

    if (user == null) return false;
    return user.passwordHash == hash;
  }
}
