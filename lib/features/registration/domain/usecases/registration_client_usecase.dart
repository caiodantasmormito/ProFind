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
        clientEntity: ClientEntity(
            address: params.address,
            phone: params.phone,
            name: params.name,
            surname: params.surname,
            email: params.email,
            cpf: params.cpf,
            city: params.city,
            uf: params.uf,
            cep: params.cep),
        password: params.password,
      );
}

class ClientRegistrationParams {
  final String name;
  final String surname;
  final String email;
  final String cpf;

  final String city;
  final String uf;
  final String cep;
  final String password;
  final String phone;
  final String address;

  const ClientRegistrationParams({
    required this.phone,
    required this.name,
    required this.surname,
    required this.email,
    required this.cpf,
    required this.city,
    required this.uf,
    required this.cep,
    required this.address,
    required this.password,
  });
}
