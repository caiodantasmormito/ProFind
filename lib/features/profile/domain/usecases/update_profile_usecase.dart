import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/profile/domain/repositories/profile_repository.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';

class UpdateProfileUsecase implements UseCase<void, UserEntity> {
  final ProfileRepository _repository;

  UpdateProfileUsecase({required ProfileRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, void)> call(UserEntity user) async {
    return await _repository.updateUserProfile(user);
  }
}