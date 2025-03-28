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
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthenticateException(message: e.message ?? "Falha no login.");
    }
  }

  /*@override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Falha no registro.");
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Usuário não autenticado.");

      // Reautenticar antes de excluir
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Falha ao excluir conta.");
    }
  }

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();*/
}