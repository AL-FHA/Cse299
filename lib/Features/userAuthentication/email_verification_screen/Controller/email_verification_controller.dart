/// EmailVerificationController
///
/// This controller handles the business logic and connects the
/// EmailVerificationModel to the view. It acts as the middleman
/// in the MVC structure.
///
/// Responsibilities:
/// - Periodically checking the email verification status.
/// - Managing timers for periodic checks.
/// - Handling user interactions for sending and resending verification emails.

import 'dart:async';
import 'package:flutter/material.dart';
import '../Model/email_verification_model.dart';

class EmailVerificationController {
  final EmailVerificationModel _model = EmailVerificationModel();
  Timer? timer;

  /// Checks the user's email verification status and updates the view.
  ///
  /// This method uses the model to check the current email verification
  /// status. If the user's email is verified, the provided callback
  /// [onVerified] is invoked with a `true` value.
  ///
  /// Parameters:
  /// - [onVerified]: A callback function to notify the view when the
  ///   email is verified.
  ///
  /// Returns:
  /// - A [Future] resolving to a [bool] indicating the verification status.
  Future<bool> checkVerificationStatus(Function(bool) onVerified) async {
    bool isVerified = await _model.checkVerificationStatus();
    if (isVerified) {
      timer?.cancel();
      onVerified(isVerified);
    }
    return isVerified;
  }

  /// Starts a timer to periodically check the email verification status.
  ///
  /// The timer runs every 3 seconds, calling [checkVerificationStatus]
  /// to check the status and update the view.
  ///
  /// Parameters:
  /// - [onVerified]: A callback function to notify the view when the
  ///   email is verified.
  void startVerificationTimer(Function(bool) onVerified) {
    timer = Timer.periodic(
      const Duration(seconds: 3),
          (_) => checkVerificationStatus(onVerified),
    );
  }

  /// Stops the periodic timer for email verification checks.
  void stopVerificationTimer() {
    timer?.cancel();
  }

  /// Sends a verification email to the user and displays a message.
  ///
  /// This method invokes the model to send a verification email.
  /// Depending on the [isResend] flag, it shows either a "sent" or
  /// "resent" message to the user using a [SnackBar].
  ///
  /// Parameters:
  /// - [context]: The build context of the view.
  /// - [isResend]: Whether this is a resend operation.
  Future<void> sendVerificationEmail(BuildContext context, {bool isResend = false}) async {
    await _model.sendEmailVerification();
    final message = isResend
        ? "Verification email resent."
        : "Verification email sent.";
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
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
