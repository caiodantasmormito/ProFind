import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<(Failure?, UserEntity?)> getUserProfile(String userId);
  Future<(Failure?, void)> updateUserProfile(UserEntity user);
}