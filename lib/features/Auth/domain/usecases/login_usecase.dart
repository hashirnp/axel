import 'package:axel/features/Auth/domain/entities/user.dart';
import 'package:axel/features/Auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<User?> call(String username, String password, bool rememberMe) {
    return repository.login(username, password, rememberMe);
  }
}
