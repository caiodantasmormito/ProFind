import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/service_providers/domain/entities/service_provider_entity.dart';

final class ServiceProviderModel extends ServiceProviderEntity {
  const ServiceProviderModel({
    required super.id,
    required super.phone,
    required super.name,
    required super.surname,
    required super.cpf,
    required super.email,
    required super.city,
    required super.uf,
    required super.cep,
    required super.service,
  });
  factory ServiceProviderModel.fromJson(Map<String, dynamic> map) {
    return ServiceProviderModel(
        phone: map['phone'] ?? '',
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        surname: map['surname'] ?? '',
        cpf: map['cpf'] ?? '',
        email: map['email'] ?? '',
        city: map['city'] ?? '',
        uf: map['uf'] ?? '',
        cep: map['cep'] ?? '',
        service: map['service'] is String
            ? [map['service']]
            : List<String>.from(map['service'] ?? []));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'cpf': cpf,
      'email': email,
      'city': city,
      'uf': uf,
      'cep': cep,
      'service': service,
      'userType': 'service_provider',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
