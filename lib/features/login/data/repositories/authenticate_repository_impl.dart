import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/login/domain/failures/failures.dart';
import 'package:profind/features/login/domain/repositories/authenticate_repository.dart';

final class AuthenticateRepositoryImpl implements AuthenticateRepository {
  final FirebaseAuth _auth;

  AuthenticateRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<(Failure?, User?)> authenticate({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (null, userCredential.user);
    } on FirebaseAuthException catch (e) {
      final failure = _handleFirebaseError(e);
      return (failure, null);
    } catch (e) {
      return (AuthenticationFailure(message: "Erro desconhecido"), null);
    }
  }

  AuthenticationFailure _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
        return AuthenticationFailure(message: "E-mail ou senha inválidos");
      case 'network-request-failed':
        return AuthenticationFailure(message: "Sem conexão com a internet");
      default:
        return AuthenticationFailure(
            message: e.message ?? "Erro ao autenticar");
    }
  }
}
