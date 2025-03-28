import 'package:profind/features/registration/data/datasource/registration_datasource.dart';
import 'package:profind/features/registration/data/datasource/registration_datasource_impl.dart';
import 'package:profind/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:profind/features/registration/domain/repositories/registration_repository.dart';
import 'package:profind/features/registration/domain/usecases/registration_client_usecase.dart';
import 'package:profind/features/registration/domain/usecases/registration_service_provider_usecase.dart';
import 'package:provider/provider.dart';

sealed class RegistrationInject {
  static final List<Provider> providers = [
    Provider<RegistrationDataSource>(
      create: (context) => RegistrationDataSourceImpl(),
    ),
    Provider<RegistrationRepository>(
      create: (context) => RegistrationRepositoryImpl(
          dataSource: context.read<RegistrationDataSource>()),
    ),
    Provider<RegistrationClientUsecase>(
      create: (context) => RegistrationClientUsecase(
        repository: context.read<RegistrationRepository>(),
      ),
    ),
    Provider<RegistrationServiceProviderUsecase>(
      create: (context) => RegistrationServiceProviderUsecase(
        repository: context.read<RegistrationRepository>(),
      ),
    ),
    Provider<RegistrationServiceProviderUsecase>(
      create: (context) => RegistrationServiceProviderUsecase(
        repository: context.read<RegistrationRepository>(),
      ),
    ),
  ];
}
