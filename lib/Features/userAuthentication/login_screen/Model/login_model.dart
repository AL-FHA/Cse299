/// login_model.dart
/// This file contains the AuthModel class responsible for interacting with Firebase
/// to manage authentication-related operations.

import 'package:firebase_auth/firebase_auth.dart';

class LoginModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Logs in a user with the provided [email] and [password].
  /// Throws a [FirebaseAuthException] on failure.
  Future<User?> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }
}
