/// EmailVerificationModel
///
/// This model is responsible for managing the core logic
/// related to email verification using Firebase Authentication.
///
/// It provides methods to:
/// - Check whether the user's email is verified.
/// - Send a verification email to the user.
///
/// This is the data layer in the MVC architecture, where all
/// Firebase operations are encapsulated.

import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Checks whether the currently logged-in user's email is verified.
  ///
  /// This method reloads the user's information to ensure the latest
  /// verification status is retrieved.
  ///
  /// Returns:
  /// - A [Future] that resolves to a [bool] indicating whether the
  ///   user's email is verified.
  Future<bool> checkVerificationStatus() async {
    await _auth.currentUser?.reload();
    var user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  /// Sends a verification email to the currently logged-in user.
  ///
  /// If the user's email is not verified, this method sends a
  /// verification email. No action is taken if the user is null
  /// or their email is already verified.
  ///
  /// Returns:
  /// - A [Future] that completes when the email is sent.
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
