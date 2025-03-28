import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/registration/domain/entities/service_provider_entity.dart';
import 'package:profind/features/registration/domain/repositories/registration_repository.dart';

class RegistrationServiceProviderUsecase
    implements
        UseCase<ServiceProviderEntity, ServiceProviderRegistrationParams> {
  final RegistrationRepository _repository;

  RegistrationServiceProviderUsecase(
      {required RegistrationRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, ServiceProviderEntity?)> call(
          ServiceProviderRegistrationParams params) =>
      _repository.registerServiceProvider(
        serviceProviderEntity: params.serviceProviderEntity,
        password: params.password,
      );
}

class ServiceProviderRegistrationParams {
  final ServiceProviderEntity serviceProviderEntity;
  final String password;

  ServiceProviderRegistrationParams({
    required this.serviceProviderEntity,
    required this.password,
  });
}
