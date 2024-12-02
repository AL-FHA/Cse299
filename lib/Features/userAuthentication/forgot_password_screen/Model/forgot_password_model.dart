
/// The `ForgotPasswordModel` class is responsible for handling all
/// Firebase Authentication interactions related to password reset.
///
/// This class serves as the "Model" in the MVC architecture, isolating
/// the business logic of the password reset feature from the View and Controller.
///
/// Methods:
/// - [sendPasswordResetEmail]: Sends a password reset email to the specified email address.

import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordModel {
  // Instance of Firebase Authentication for handling user authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Sends a password reset email to the given email address.
  ///
  /// Parameters:
  /// - [email]: A valid email address registered with Firebase Authentication.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if an error occurs during the process,
  ///   such as an invalid email or a network issue.
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
