import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/registration/data/datasource/registration_datasource.dart';
import 'package:profind/features/registration/data/exceptions/exceptions.dart';
import 'package:profind/features/registration/domain/entities/client_entity.dart';
import 'package:profind/features/registration/domain/entities/service_provider_entity.dart';
import 'package:profind/features/registration/domain/failures/failures.dart';
import 'package:profind/features/registration/domain/repositories/registration_repository.dart';

final class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationDataSource dataSource;

  RegistrationRepositoryImpl({required this.dataSource});

  @override
  Future<(Failure?, ServiceProviderEntity?)> registerServiceProvider(
      {required ServiceProviderEntity serviceProviderEntity,
      required String password}) async {
    try {
      final result = await dataSource.registerServiceProvider(
          serviceProviderModel: serviceProviderEntity.toModel(),
          password: password);
      return (null, result);
    } on RegisterException catch (error) {
      return (RegistrationFailure(message: error.message), null);
    }
  }

  @override
  Future<(Failure?, ClientEntity?)> registerClient(
      {required ClientEntity clientEntity, required String password}) async {
    try {
      final result = await dataSource.registerClient(
          clientModel: clientEntity.toModel(), password: password);
      return (null, result);
    } on RegisterException catch (error) {
      return (RegistrationFailure(message: error.message), null);
    }
  }
}
