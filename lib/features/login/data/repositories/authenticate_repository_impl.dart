import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/login/data/datasources/authenticate_datasource.dart';
import 'package:profind/features/login/data/exceptions/exceptions.dart';
import 'package:profind/features/login/domain/failures/failures.dart';
import 'package:profind/features/login/domain/repositories/authenticate_repository.dart';

final class AuthenticateRepositoryImpl implements AuthenticateRepository {
  final AuthenticationDataSource _dataSource;

  AuthenticateRepositoryImpl({required AuthenticationDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<(Failure?, User?)> authenticate({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.authenticate(
        email: email,
        password: password,
      );

      if (user == null) {
        return (AuthenticationFailure(message: "E-mail não verificado"), null);
      }

      return (null, user);
    } on FirebaseAuthException catch (e) {
      final failure = _handleFirebaseError(e);
      return (failure, null);
    } on AuthenticateException catch (e) {
      return (AuthenticationFailure(message: e.message), null);
    } catch (e) {
      return (
        AuthenticationFailure(message: "Erro desconhecido: ${e.toString()}"),
        null
      );
    }
  }

  AuthenticationFailure _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-credential':
        return AuthenticationFailure(message: "E-mail ou senha inválidos");
      case 'user-disabled':
        return AuthenticationFailure(message: "Conta desativada");
      case 'too-many-requests':
        return AuthenticationFailure(
            message: "Muitas tentativas. Tente novamente mais tarde");
      case 'network-request-failed':
        return AuthenticationFailure(message: "Sem conexão com a internet");
      case 'invalid-email':
        return AuthenticationFailure(message: "E-mail inválido");
      default:
        return AuthenticationFailure(
            message: e.message ?? "Erro ao autenticar");
    }
  }
}
