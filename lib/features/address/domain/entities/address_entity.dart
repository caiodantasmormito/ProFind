import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String cep;
  final String logradouro;
  final String bairro;
  final String uf;

  const AddressEntity({
    required this.cep,
    required this.logradouro,
    required this.uf,
    required this.bairro,
  });

  @override
  List<Object?> get props => [
        cep,
        logradouro,
        bairro,
        uf,
      ];
}
