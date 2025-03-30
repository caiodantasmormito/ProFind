import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/login/data/datasources/authenticate_datasource.dart';
import 'package:profind/features/login/data/exceptions/exceptions.dart';

final class AuthenticationDataSourceImpl implements AuthenticationDataSource {
  final FirebaseAuth _auth;

  AuthenticationDataSourceImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<User?> authenticate({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.reload();
      final User? user = _auth.currentUser;
      if (user == null) return null;

      if (!user.emailVerified) {
        await _auth.signOut();

        return null;
      }

      return user;
    } on AuthenticateException catch (e) {
      throw AuthenticateException(message: e.message ?? "Falha no login.");
    }
  }
}
