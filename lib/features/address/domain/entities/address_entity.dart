import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String cep;
  final String logradouro;
  final String bairro;
  final String uf;
  final String cidade;

  const AddressEntity({
    required this.cep,
    required this.logradouro,
    required this.uf,
    required this.bairro,
    required this.cidade,
  });

  @override
  List<Object?> get props => [
        cep,
        logradouro,
        bairro,
        uf,
        cidade,
      ];
}
