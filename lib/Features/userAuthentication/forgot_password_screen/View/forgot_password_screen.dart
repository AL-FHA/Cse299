/// The `ForgotPasswordScreen` widget is the user interface for the
/// "Forgot Password" feature.
///
/// This widget serves as the "View" in the MVC architecture. It displays
/// the UI elements and delegates user interactions to the `ForgotPasswordController`.
///
/// Features:
/// - Displays a form with an email input field.
/// - Provides a button to trigger the password reset process.
/// - Shows success or error messages based on the result of the operation.

import 'package:flutter/material.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:chitter_chatter/common_utils/widgets/custom_button.dart';
import '../Controller/forgot_password_controller.dart';
import '../Model/forgot_password_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for managing user input in the email field
    final TextEditingController _emailController = TextEditingController();

    // Initializing the controller with the model
    final ForgotPasswordController _controller =
    ForgotPasswordController(ForgotPasswordModel());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: appBarColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust layout for wide screens
          bool isWideScreen = constraints.maxWidth > 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 400 : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60), // Add top padding
                    const Icon(
                      Icons.lock_outline,
                      size: 100,
                      color: tabColor,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Enter your email address below, and we'll send you an email with instructions to reset your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      onPressed: () {
                        if (_emailController.text.isNotEmpty) {
                          _controller.handlePasswordReset(
                            context,
                            _emailController.text,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter a valid email address.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: errorMessageColor,
                            ),
                          );
                        }
                      },
                      text: 'Send Email',
                      child: const Text(
                        "Send Email",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
