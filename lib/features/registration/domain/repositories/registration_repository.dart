import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/registration/domain/entities/client_entity.dart';
import 'package:profind/features/registration/domain/entities/service_provider_entity.dart';

abstract interface class RegistrationRepository {
  Future<(Failure?, ServiceProviderEntity?)> registerServiceProvider(
      {required ServiceProviderEntity serviceProviderEntity,
      required String password});

  Future<(Failure?, ClientEntity?)> registerClient(
      {required ClientEntity clientEntity, required String password});
      Future<bool> verifyCpfExists(String cpf);
}
