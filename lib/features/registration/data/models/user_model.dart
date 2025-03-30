import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';

final class UserModel extends UserEntity {
  const UserModel({
    super.id,
    required super.emailVerified,
    required super.userType,
    required super.name,
    required super.surname,
    required super.cpf,
    required super.email,
    required super.city,
    required super.uf,
    required super.cep,
    required super.phone,
    required super.address,
    super.service,
  });
  
    factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      emailVerified: map['emailVerified'],
      userType: map['userType'],
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
      service: map['service'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emailVerified': emailVerified,
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
      'userType': userType,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

