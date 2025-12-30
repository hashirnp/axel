import 'package:axel/features/profile/domain/entity/profile.dart';
import 'package:axel/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUsecase {
  final ProfileRepository repository;
  UpdateProfileUsecase(this.repository);

  Future<void> call(Profile profile) {
    return repository.updateProfile(profile);
  }
}
