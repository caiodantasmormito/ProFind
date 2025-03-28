import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/registration/domain/entities/client_entity.dart';
import 'package:profind/features/registration/domain/repositories/registration_repository.dart';

class RegistrationClientUsecase
    implements UseCase<ClientEntity, ClientRegistrationParams> {
  final RegistrationRepository _repository;

  RegistrationClientUsecase({required RegistrationRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, ClientEntity?)> call(ClientRegistrationParams params) =>
      _repository.registerClient(
        clientEntity: params.clientEntity,
        password: params.password,
      );
}

class ClientRegistrationParams {
  final ClientEntity clientEntity;
  final String password;

  ClientRegistrationParams({
    required this.clientEntity,
    required this.password,
  });
}
