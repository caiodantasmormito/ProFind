import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/profile/data/datasource/profile_datasource.dart';
import 'package:profind/features/profile/data/exceptions/exceptions.dart';

import 'package:profind/features/profile/domain/failures/profile_failure.dart';
import 'package:profind/features/profile/domain/repositories/profile_repository.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepositoryImpl({required ProfileDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<(Failure?, UserEntity?)> getUserProfile(String userId) async {
    try {
      final userModel = await _dataSource.getUserProfile(userId);
      return (null, userModel.toModel());
    } on ProfileException catch (error) {
      return (ProfileFailure(message: error.message), null);
    }
  }

  @override
  Future<(Failure?, void)> updateUserProfile(UserEntity user) async {
    try {
      await _dataSource.updateUserProfile(user.toModel());
      return (null, null);
    } on ProfileException catch (error) {
      return (ProfileFailure(message: error.message), null);
    }
  }
}