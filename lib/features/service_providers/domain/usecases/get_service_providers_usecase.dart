import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/service_providers/domain/entities/service_provider_entity.dart';
import 'package:profind/features/service_providers/domain/repositories/service_providers_repository.dart';

class GetServiceProvidersUsecase
    implements UseCase<List<ServiceProviderEntity>, NoParams> {
  final ServiceProvidersRepository _repository;
  GetServiceProvidersUsecase({required ServiceProvidersRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, List<ServiceProviderEntity>?)> call(NoParams params) =>
      _repository.getServiceProviders();
}
