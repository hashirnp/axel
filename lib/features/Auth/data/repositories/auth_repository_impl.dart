import 'dart:convert';
import 'dart:developer';

import 'package:axel/core/const/strings.dart';
import 'package:axel/features/Auth/data/models/user_model.dart';
import 'package:axel/features/Auth/domain/entities/user.dart';
import 'package:axel/features/Auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences prefs;

  AuthRepositoryImpl(this.prefs);

  Map<String, dynamic> _getUsersMap() {
    final raw = prefs.getString(StringConstants.usersKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _saveUsersMap(Map<String, dynamic> users) async {
    await prefs.setString(StringConstants.usersKey, jsonEncode(users));
  }

  @override
  Future<bool> isUsernameTaken(String username) async {
    final users = _getUsersMap();
    return users.containsKey(username);
  }

  @override
  Future<void> register(User user) async {
    final users = _getUsersMap();

    if (users.containsKey(user.username)) {
      throw Exception('Username already exists');
    }

    users[user.username] = UserModel(
      username: user.username,
      fullName: user.fullName,
      password: user.password,
      imagePath: user.imagePath,
      dob: user.dob.toIso8601String(),
    ).toJson();

    await _saveUsersMap(users);
  }

  @override
  Future<User> login(String username, String password, bool rememberMe) async {
    final users = _getUsersMap();
    log("$username $password");

    if (!users.containsKey(username)) {
      throw Exception('User not found');
    }

    final user = UserModel.fromJson(users[username]);
    log(user.password!);

    final lockKey = 'login_lock_time_$username';

    final attempts = prefs.getInt(StringConstants.attemptKey) ?? 0;
    final lockedAt = prefs.getInt(lockKey);

    if (lockedAt != null) {
      final diff = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lockedAt))
          .inSeconds;

      if (diff < 30) {
        throw Exception('Account locked. Try again in ${30 - diff}s');
      } else {
        await prefs.remove(lockKey);
        await prefs.remove(StringConstants.attemptKey);
      }
    }

    if (user.password != password) {
      final newAttempts = attempts + 1;
      await prefs.setInt(StringConstants.attemptKey, newAttempts);

      // if (newAttempts >= 3) {
      //   await prefs.setInt(lockKey, DateTime.now().millisecondsSinceEpoch);
      //   throw Exception('Too many attempts. Account locked for 30 seconds');
      // }

      throw Exception('Invalid credentials');
    }

    await prefs.remove(StringConstants.attemptKey);
    await prefs.remove(lockKey);

    await prefs.setBool(StringConstants.loggedIn, rememberMe);
    await prefs.setString(StringConstants.currentUserId, user.username!);

    return user.toEntity();
  }

  @override
  Future<void> logout() async {
    await prefs.remove(StringConstants.currentUserId);
    await prefs.setBool(StringConstants.loggedIn, false);
  }
}
