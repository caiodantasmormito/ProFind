import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/registration/data/datasource/registration_datasource.dart';
import 'package:profind/features/registration/data/exceptions/exceptions.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';
import 'package:profind/features/registration/domain/failures/failures.dart';
import 'package:profind/features/registration/domain/repositories/registration_repository.dart';

final class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationDataSource dataSource;

  RegistrationRepositoryImpl({required this.dataSource});

  @override
  Future<(Failure?, UserEntity?)> registerUser({
    required UserEntity userEntity,
    required String password,
    
  }) async {
    try {
      final result = await dataSource.registerUser(
        userModel: userEntity.toModel(),
        password: password,
        
      );
      return (null, result);
    } on RegisterException catch (error) {
      return (RegistrationFailure(message: error.message), null);
    }
  }

  @override
  Future<bool> verifyCpf(String cpf) async {
    try {
      return await dataSource.verifyCpf(cpf);
    } catch (e) {
      throw RegisterException(message: 'Erro ao verificar CPF');
    }
  }
}
