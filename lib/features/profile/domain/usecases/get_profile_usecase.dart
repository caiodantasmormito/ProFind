import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/profile/domain/repositories/profile_repository.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';

class GetProfileUsecase implements UseCase<UserEntity, String> {
  final ProfileRepository _repository;

  GetProfileUsecase({required ProfileRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, UserEntity?)> call(String userId) async {
    return await _repository.getUserProfile(userId);
  }
}