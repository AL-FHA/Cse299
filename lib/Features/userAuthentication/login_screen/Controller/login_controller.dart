/// login_controller.dart
/// This file defines the LoginController class, which is responsible for handling
/// the business logic related to the login functionality in the application.
///
/// The controller acts as an intermediary between the LoginModel (data handling)
/// and the LoginScreen (UI), ensuring a clear separation of concerns. It also
/// manages error handling and user feedback.

import 'package:chitter_chatter/Features/userAuthentication/login_screen/Model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  /// Instance of LoginModel used for authentication-related operations.
  final LoginModel _authModel = LoginModel();

  /// Handles user login by validating the provided [email] and [password] using
  /// the LoginModel. If the login succeeds, it triggers the [onSuccess] callback.
  ///
  /// - Parameters:
  ///   - [email]: The user's email address for authentication.
  ///   - [password]: The user's password for authentication.
  ///   - [context]: BuildContext for showing feedback (e.g., SnackBars).
  ///   - [onSuccess]: A callback executed if the login is successful, typically
  ///     used to navigate to the next screen or perform a specific action.
  ///
  /// - Throws:
  ///   - [FirebaseAuthException]: If authentication fails.
  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    try {
      // Attempt to log in the user through the model.
      final user = await _authModel.login(email, password);

      // If successful, execute the onSuccess callback.
      if (user != null) {
        onSuccess();
      }
    } on FirebaseAuthException catch (_) {
      // Handle any authentication errors by showing an error message.
      _showErrorSnackbar(context, "Incorrect email or password!");
    }
  }

  /// Displays an error message in a [SnackBar] within the given [context].
  ///
  /// - Parameters:
  ///   - [context]: BuildContext for displaying the SnackBar.
  ///   - [message]: The error message to display.
  ///
  /// This method is typically called when login attempts fail, providing
  /// the user with feedback about the issue.
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent, // Red background for error indication.
      ),
    );
  }
}
