/// The `ForgotPasswordController` class is responsible for managing
/// the communication between the `ForgotPasswordModel` (data/business logic)
/// and the `ForgotPasswordScreen` (UI).
///
/// This class serves as the "Controller" in the MVC architecture, providing
/// logic for handling user actions and responding to the model's results.
///
/// Constructor:
/// - Requires an instance of `ForgotPasswordModel` to perform actions.
///
/// Methods:
/// - [handlePasswordReset]: Sends a password reset email using the model and provides
///   feedback to the user through the view.

import 'package:flutter/material.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import '../Model/forgot_password_model.dart';

class ForgotPasswordController {
  // Instance of ForgotPasswordModel to interact with the business logic
  final ForgotPasswordModel _model;

  /// Constructor that initializes the controller with a `ForgotPasswordModel`.
  ForgotPasswordController(this._model);

  /// Handles the process of sending a password reset email and provides
  /// feedback to the user.
  ///
  /// Parameters:
  /// - [context]: The `BuildContext` of the calling widget for navigation and snack bars.
  /// - [email]: The email address to which the password reset email should be sent.
  ///
  /// This method:
  /// - Calls the `sendPasswordResetEmail` method of the `ForgotPasswordModel`.
  /// - Displays a success message using a `SnackBar` if the operation succeeds.
  /// - Displays an error message using a `SnackBar` if an exception occurs.
  /// - Redirects the user to the Login screen upon success.
  Future<void> handlePasswordReset(
      BuildContext context,
      String email,
      ) async {
    try {
      await _model.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password reset email sent!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: tabColor,
        ),
      );

      // Navigate to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: ${e.toString()}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          backgroundColor: errorMessageColor,
        ),
      );
    }
  }
}
