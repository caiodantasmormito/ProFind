import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/service_providers/data/datasources/service_providers_datasource.dart';
import 'package:profind/features/service_providers/data/exceptions/exceptions.dart';
import 'package:profind/features/service_providers/domain/entities/service_provider_entity.dart';
import 'package:profind/features/service_providers/domain/failures/failures.dart';
import 'package:profind/features/service_providers/domain/repositories/service_providers_repository.dart';

final class ServiceProvidersRepositoryImpl
    implements ServiceProvidersRepository {
  final ServiceProvidersDatasource dataSource;

  ServiceProvidersRepositoryImpl({required this.dataSource});

  @override
  Future<(Failure?, List<ServiceProviderEntity>?)> getServiceProviders() async {
    try {
      final result = await dataSource.getServiceProviders();
      return (null, result);
    } on GetServiceProvidersException catch (error) {
      return (GetServiceProvidersFailure(message: error.message), null);
    }
  }
}
