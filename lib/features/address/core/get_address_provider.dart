import 'package:profind/core/infra/http_client.dart';
import 'package:profind/features/address/data/datasource/get_address_datasource.dart';
import 'package:profind/features/address/data/datasource/get_address_datasource_impl.dart';
import 'package:profind/features/address/data/repositories/get_address_repository_impl.dart';
import 'package:profind/features/address/domain/repositories/get_address_repository.dart';
import 'package:profind/features/address/domain/usecase/get_address_usecase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class AddressInject {
  static final List<Provider> providers = [
    Provider<GetAddressDatasource>(
      create: (context) => GetAddressDatasourceImpl(
          client: context.read<AuthenticatedClient>(),
          localStorage: context.read<SharedPreferences>()),
    ),
    Provider<GetAddressRepository>(
      create: (context) => GetAddressRepositoryImpl(
          getAddressDataSource: context.read<GetAddressDatasource>()),
    ),
    Provider<GetAddressUsecase>(
      create: (context) => GetAddressUsecase(
        getAddressRepository: context.read<GetAddressRepository>(),
      ),
    ),
  ];
}
