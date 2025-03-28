import 'package:profind/features/address/data/models/address_model.dart';


abstract interface class GetAddressDatasource {
  Future<AddressModel> getAddress({required String cep});

  
}
