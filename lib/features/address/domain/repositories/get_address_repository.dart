

import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/address/domain/entities/address_entity.dart';

abstract class GetAddressRepository {
  Future<(Failure?, AddressEntity?)> getAddress({required String cep});
  
}
