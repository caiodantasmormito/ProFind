import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/service_providers/domain/entities/service_provider_entity.dart';

abstract interface class ServiceProvidersRepository {
  Future<(Failure?, List<ServiceProviderEntity>?)> getServiceProviders();
}
