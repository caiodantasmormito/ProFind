import 'package:profind/features/service_providers/data/models/service_provider_model.dart';

abstract interface class ServiceProvidersDatasource {
  Future<List<ServiceProviderModel>> getServiceProviders();
}
