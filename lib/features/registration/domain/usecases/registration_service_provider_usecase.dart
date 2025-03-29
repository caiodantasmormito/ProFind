/*import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/registration/domain/entities/service_provider_entity.dart';
import 'package:profind/features/registration/domain/failures/failures.dart';
import 'package:profind/features/registration/domain/repositories/registration_repository.dart';
import 'package:profind/features/registration/domain/usecases/registration_usecase.dart';

class RegistrationServiceProviderUsecase
    implements
        UseCase<ServiceProviderEntity, RegistrationParams> {
  final RegistrationRepository _repository;

  RegistrationServiceProviderUsecase(
      {required RegistrationRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, ServiceProviderEntity?)> call(
      RegistrationParams params) async {
    final cpfExists = await _repository.verifyCpfExists(params.cpf);
    if (cpfExists) {
      return (RegistrationFailure(message: 'CPF já cadastrado'), null);
    }
    return await _repository.registerServiceProvider(
      serviceProviderEntity: ServiceProviderEntity(
          id: params.id!,
          name: params.name,
          surname: params.surname,
          email: params.email,
          cpf: params.cpf,
          city: params.city,
          uf: params.uf,
          cep: params.cep,
          service: params.service!),
      password: params.password,
    );
  }
}
*/