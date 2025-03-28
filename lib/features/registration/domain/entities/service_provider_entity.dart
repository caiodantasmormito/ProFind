import 'package:equatable/equatable.dart';
import 'package:profind/features/registration/data/models/service_provider_model.dart';

base class ServiceProviderEntity extends Equatable {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String cpf;

  final String city;
  final String uf;
  final String cep;
  final String service;
  

  const ServiceProviderEntity(
      {required this.id,
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
      [id, name, email, cpf, surname, city, uf, cep, service];

  ServiceProviderEntity copyWith({
    String? id,
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
      );
}
