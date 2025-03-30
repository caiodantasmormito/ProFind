import 'package:equatable/equatable.dart';
import 'package:profind/features/service_providers/data/models/service_provider_model.dart';

base class ServiceProviderEntity extends Equatable {
  final String? id;
  final String name;
  final String surname;
  final String email;
  final String cpf;

  final String city;
  final String uf;
  final String cep;
  final String service;
  final String phone;

  const ServiceProviderEntity(
      {this.id,
      required this.phone,
      required this.name,
      required this.surname,
      required this.email,
      required this.cpf,
      required this.city,
      required this.uf,
      required this.cep,
      required this.service});

  @override
  List<Object?> get props =>
      [id, name, email, cpf, surname, city, uf, cep, service, phone];

  ServiceProviderEntity copyWith({
    String? id,
    String? phone,
    String? name,
    String? surname,
    String? email,
    String? cpf,
    String? city,
    String? uf,
    String? cep,
    String? service,
  }) {
    return ServiceProviderEntity(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      city: city ?? this.city,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      service: service ?? this.service,
    );
  }

  ServiceProviderModel toModel() => ServiceProviderModel(
        name: name,
        id: id,
        surname: surname,
        cpf: cpf,
        email: email,
        city: city,
        uf: uf,
        cep: cep,
        service: service,
        phone: phone,
      );
}
