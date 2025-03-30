import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract interface class AuthenticationDataSource {
  Future<User?> authenticate({required String email, required String password});
}
