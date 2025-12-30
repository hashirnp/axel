import 'package:axel/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password, bool rememberMe);
  Future<void> register(User user);
  Future<bool> isUsernameTaken(String username);
  Future<void> logout();
}
