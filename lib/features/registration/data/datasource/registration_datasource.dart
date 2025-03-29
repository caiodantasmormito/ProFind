import 'package:profind/features/registration/data/models/user_model.dart';

abstract interface class RegistrationDataSource {
  Future<UserModel> registerUser({
    required UserModel userModel,
    required String password,
    
  });
  
  Future<bool> verifyCpfExists(String cpf);
}