import 'dart:convert';

import 'package:axel/core/const/strings.dart';
import 'package:axel/features/profile/data/model/profile.dart';
import 'package:axel/features/profile/domain/entity/profile.dart';
import 'package:axel/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final SharedPreferences prefs;

  ProfileRepositoryImpl(this.prefs);

  // -------------------------------
  // INTERNAL HELPERS (LIKE AUTH)
  // -------------------------------

  Map<String, dynamic> _getProfilesMap() {
    final raw = prefs.getString(StringConstants.usersKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _saveProfilesMap(Map<String, dynamic> profiles) async {
    await prefs.setString(StringConstants.usersKey, jsonEncode(profiles));
  }

  String _currentUserId() {
    final userId = prefs.getString(StringConstants.currentUserId);
    if (userId == null) {
      throw Exception('No active user');
    }
    return userId;
  }

  // -------------------------------
  // REPOSITORY API
  // -------------------------------

  @override
  Future<Profile> getProfile() async {
    final profiles = _getProfilesMap();
    final userId = _currentUserId();

    if (!profiles.containsKey(userId)) {
      throw Exception('Profile not found');
    }

    return ProfileModel.fromJson(profiles[userId]).toEntity();
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final profiles = _getProfilesMap();
    final userId = _currentUserId();

    profiles[userId] = ProfileModel(
      username: profile.username,
      fullName: profile.fullName,
      imagePath: profile.imagePath,
      dob: profile.dob!.toIso8601String(),
    ).toJson();

    await _saveProfilesMap(profiles);
  }
}
