/// EmailVerificationScreen
///
/// This screen provides the user interface for the email verification process.
/// It displays instructions and buttons for the user to verify or resend their
/// email verification link.
///
/// Responsibilities:
/// - Render the email verification UI.
/// - Interact with the controller for user actions.
/// - Update the screen when the email is verified.

import 'package:flutter/material.dart';
import '../Controller/email_verification_controller.dart';
import 'package:chitter_chatter/Features/userAuthentication/login_screen/View/login_screen.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:chitter_chatter/common_utils/widgets/custom_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final EmailVerificationController _controller = EmailVerificationController();
  bool isVerified = false;

  /// Initializes the email verification screen by starting the verification timer.
  @override
  void initState() {
    super.initState();
    _controller.startVerificationTimer((verified) {
      setState(() {
        isVerified = verified;
      });
    });
  }

  /// Cleans up resources when the screen is disposed.
  @override
  void dispose() {
    _controller.stopVerificationTimer();
    super.dispose();
  }

  /// Builds the email verification screen UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 100,
                color: tabColor,
              ),
              const SizedBox(height: 24),
              const Text(
                "Please verify your email address",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Click the Verify button below and we will send a verification email to your inbox. Please check and click on the link to verify your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              isVerified
                  ? CustomButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                text: 'Continue',
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : Column(
                children: [
                  CustomButton(
                    onPressed: () {
                      _controller.sendVerificationEmail(context);
                    },
                    text: 'Verify',
                    child: const Text(
                      "Verify",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _controller.sendVerificationEmail(context, isResend: true);
                    },
                    child: const Text(
                      "Resend Email",
                      style: TextStyle(color: tabColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
