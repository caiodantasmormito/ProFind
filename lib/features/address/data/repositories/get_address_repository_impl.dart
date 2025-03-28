import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/address/data/datasource/get_address_datasource.dart';
import 'package:profind/features/address/data/exceptions/exceptions.dart';
import 'package:profind/features/address/domain/entities/address_entity.dart';
import 'package:profind/features/address/domain/failures/failures.dart';
import 'package:profind/features/address/domain/repositories/get_address_repository.dart';

class GetAddressRepositoryImpl implements GetAddressRepository {
  final GetAddressDatasource _getAddressDataSource;

  GetAddressRepositoryImpl({required GetAddressDatasource getAddressDataSource})
      : _getAddressDataSource = getAddressDataSource;

  @override
  Future<(Failure?, AddressEntity?)> getAddress({required String cep}) async {
    try {
      final result = await _getAddressDataSource.getAddress(cep: cep);
      return (null, result);
    } on GetAddressException catch (error) {
      return (
        GetAddressFailure(message: error.message),
        null,
      );
    }
  }
}
