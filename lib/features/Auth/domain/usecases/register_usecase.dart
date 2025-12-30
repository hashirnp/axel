import 'package:axel/features/Auth/domain/entities/user.dart';
import 'package:axel/features/Auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<void> call(User user) {
    return repository.register(user);
  }
}
