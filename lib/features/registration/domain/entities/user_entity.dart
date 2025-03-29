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

  const UserEntity({
    this.id,
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
}
