

import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/core/domain/failure/failure.dart';

abstract interface class AuthenticateRepository {
  Future<(Failure?, User?)> authenticate(
      {required String email, required String password});
}
