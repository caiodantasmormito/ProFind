import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/registration/data/models/user_model.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String surname;
  final String cpf;
  final String email;
  final String city;
  final String uf;
  final String cep;
  final String phone;
  final String address;
  final String? service;
  final String userType;
  final bool emailVerified;

  const UserEntity({
    this.id,
    required this.emailVerified,
    required this.name,
    required this.surname,
    required this.cpf,
    required this.email,
    required this.city,
    required this.uf,
    required this.cep,
    required this.phone,
    required this.address,
    required this.userType,
    this.service,
  });

  @override
  List<Object?> get props => [
        id,
        emailVerified,
        address,
        phone,
        name,
        email,
        cpf,
        surname,
        city,
        uf,
        cep,
        service,
        userType,
      ];

  UserModel toModel() => UserModel(
        id: id,
        emailVerified: emailVerified,
        name: name,
        surname: surname,
        cpf: cpf,
        email: email,
        city: city,
        uf: uf,
        cep: cep,
        phone: phone,
        address: address,
        service: service,
        userType: userType,
      );

  factory UserEntity.fromFirestore(
    DocumentSnapshot doc, {
    required String userType,
  }) {
    final data = doc.data() as Map<String, dynamic>;

    return UserEntity(
      id: doc.id,
      emailVerified: data['emailVerified'] ?? false,
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      cpf: data['cpf'] ?? '',
      email: data['email'] ?? '',
      city: data['city'] ?? '',
      uf: data['uf'] ?? '',
      cep: data['cep'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      service: data['service'],
      userType: userType,
    );
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? surname,
    String? cpf,
    String? email,
    String? city,
    String? uf,
    String? cep,
    String? phone,
    String? address,
    String? service,
    String? userType,
    bool? emailVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      emailVerified: emailVerified ?? this.emailVerified,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      city: city ?? this.city,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      service: service ?? this.service,
      userType: userType ?? this.userType,
    );
  }
}
