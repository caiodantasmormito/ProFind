import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';

import 'package:profind/features/login/domain/repositories/authenticate_repository.dart';

class AuthenticateUseCase
    implements UseCase<User?, AuthenticateParams> { 
  const AuthenticateUseCase({required this.repository});
  final AuthenticateRepository repository;

  @override
  Future<(Failure?, User?)> call(AuthenticateParams params) async {
    return repository.authenticate(
      email: params.email,
      password: params.password,
    );
  }
}

class AuthenticateParams extends Equatable {
  final String email;
  final String password;

  const AuthenticateParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}