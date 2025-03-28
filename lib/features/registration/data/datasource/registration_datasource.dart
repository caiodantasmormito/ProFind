import 'package:profind/features/registration/data/models/client_model.dart';
import 'package:profind/features/registration/data/models/service_provider_model.dart';

abstract interface class RegistrationDataSource {
  Future<ServiceProviderModel> registerServiceProvider(
      {required ServiceProviderModel serviceProviderModel,
      required String password});

      Future<ClientModel> registerClient(
      {required ClientModel clientModel,
      required String password});
}


