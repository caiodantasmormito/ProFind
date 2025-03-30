import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';
import 'package:profind/features/registration/domain/failures/failures.dart';
import 'package:profind/features/registration/domain/repositories/registration_repository.dart';

class RegistrationUsecase implements UseCase<UserEntity, RegistrationParams> {
  final RegistrationRepository _repository;

  RegistrationUsecase({required RegistrationRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, UserEntity?)> call(RegistrationParams params) async {
    final cpfExists = await _repository.verifyCpf(params.cpf);
    if (cpfExists) {
      return (RegistrationFailure(message: 'CPF já cadastrado'), null);
    }

    if (params.userType == 'service_provider' && params.service == null) {
      return (
        RegistrationFailure(message: 'Serviço é obrigatório para prestadores'),
        null
      );
    }

    return await _repository.registerUser(
      userEntity: UserEntity(
        id: params.id,
        emailVerified: params.emailVerified,
        name: params.name,
        surname: params.surname,
        email: params.email,
        cpf: params.cpf,
        city: params.city,
        uf: params.uf,
        cep: params.cep,
        phone: params.phone,
        address: params.address,
        service: params.service,
        userType: params.userType,
      ),
      password: params.password,
    );
  }
}

class RegistrationParams {
  final String name;
  final bool emailVerified;
  final String surname;
  final String email;
  final String cpf;
  final String? id;
  final String? service;
  final String city;
  final String uf;
  final String cep;
  final String password;
  final String phone;
  final String address;
  final String userType;

  const RegistrationParams({
    this.id,
    this.service,
    required this.emailVerified,
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
    required this.userType,
  });
}
