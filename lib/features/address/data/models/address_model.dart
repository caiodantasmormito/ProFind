import 'package:profind/features/address/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel(
      {required super.cep,
      required super.logradouro,
      required super.uf,
      required super.bairro});

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      cep: map['cep'] ?? '',
      logradouro: map['logradouro'] ?? '',
      uf: map['uf'] ?? '',
      bairro: map['bairro'] ?? '',
    );
  }
}
