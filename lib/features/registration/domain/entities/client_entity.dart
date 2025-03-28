import 'package:equatable/equatable.dart';
import 'package:profind/features/registration/data/models/client_model.dart';

base class ClientEntity extends Equatable {
  final String? id;
  final String name;
  final String surname;
  final String email;
  final String cpf;
  final String phone;

  final String city;
  final String uf;
  final String cep;
  final String address;

  const ClientEntity({
    this.id,
    required this.address,
    required this.phone,
    required this.name,
    required this.surname,
    required this.email,
    required this.cpf,
    required this.city,
    required this.uf,
    required this.cep,
  });

  @override
  List<Object?> get props => [
        id,
        address,
        phone,
        name,
        email,
        cpf,
        surname,
        city,
        uf,
        cep,
      ];

  ClientEntity copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    String? cpf,
    String? city,
    String? uf,
    String? cep,
    String? phone,
    String? address,
  }) {
    return ClientEntity(
        id: id ?? this.id,
        address: address ?? this.address,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        cpf: cpf ?? this.cpf,
        city: city ?? this.city,
        uf: uf ?? this.uf,
        cep: cep ?? this.cep,
        phone: phone ?? this.phone);
  }

  ClientModel toModel() => ClientModel(
        address: address,
        phone: phone,
        name: name,
        id: id,
        surname: surname,
        cpf: cpf,
        email: email,
        city: city,
        uf: uf,
        cep: cep,
      );
}
