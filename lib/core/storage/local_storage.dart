import 'package:axel/core/const/strings.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<bool> isLoggedIn();
  Future<void> clearSession();
}

@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  final SharedPreferences prefs;

  LocalStorageImpl(this.prefs);

  @override
  Future<bool> isLoggedIn() async {
    return prefs.getBool(StringConstants.loggedIn) ?? false;
  }

  @override
  Future<void> clearSession() async {
    await prefs.setBool(StringConstants.loggedIn, false);
  }
}
