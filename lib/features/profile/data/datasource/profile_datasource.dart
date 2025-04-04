import 'package:profind/features/registration/data/models/user_model.dart';

abstract interface class ProfileDataSource {
  Future<UserModel> getUserProfile(String userId);
  Future<void> updateUserProfile(UserModel userModel);
}