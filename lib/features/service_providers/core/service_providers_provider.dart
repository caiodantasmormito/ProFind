import 'package:profind/features/service_providers/data/datasources/service_providers_datasource.dart';
import 'package:profind/features/service_providers/data/datasources/service_providers_datasource_impl.dart';
import 'package:profind/features/service_providers/data/repositories/service_providers_repository_impl.dart';
import 'package:profind/features/service_providers/domain/repositories/service_providers_repository.dart';
import 'package:profind/features/service_providers/domain/usecases/get_service_providers_usecase.dart';
import 'package:provider/provider.dart';

sealed class ServiceProvidersInject {
  static final List<Provider> providers = [
    Provider<ServiceProvidersDatasource>(
      create: (context) => ServiceProvidersDatasourceImpl(),
    ),
    Provider<ServiceProvidersRepository>(
      create: (context) => ServiceProvidersRepositoryImpl(
          dataSource: context.read<ServiceProvidersDatasource>()),
    ),
    Provider<GetServiceProvidersUsecase>(
      create: (context) => GetServiceProvidersUsecase(
        repository: context.read<ServiceProvidersRepository>(),
      ),
    ),
  ];
}
