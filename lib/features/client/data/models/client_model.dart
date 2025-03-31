import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/client/domain/entities/client_entity.dart';

final class ClientModel extends ClientEntity {
  const ClientModel({
    required super.id,
    required super.name,
    required super.surname,
    required super.cpf,
    required super.email,
    required super.city,
    required super.uf,
    required super.cep,
    required super.address,
    required super.phone
  });
  factory ClientModel.fromJson(Map<String, dynamic> map) {
    return ClientModel(
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      cpf: map['cpf'] ?? '',
      email: map['email'] ?? '',
      city: map['city'] ?? '',
      uf: map['uf'] ?? '',
      cep: map['cep'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'address': address,
      'id': id,
      'name': name,
      'surname': surname,
      'cpf': cpf,
      'email': email,
      'city': city,
      'uf': uf,
      'cep': cep,
      'userType': 'client',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
