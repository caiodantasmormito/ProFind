import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';

abstract interface class RegistrationRepository {
  Future<(Failure?, UserEntity?)> registerUser({
    required UserEntity userEntity,
    required String password,
    
  });

  Future<bool> verifyCpf(String cpf);
}
