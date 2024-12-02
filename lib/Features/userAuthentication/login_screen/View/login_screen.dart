/// login_screen.dart
/// This file defines the LoginScreen, which is the UI for the login functionality.
/// It utilizes the LoginController to handle business logic, ensuring a clean
/// separation of concerns between the UI and backend logic.
///
/// The screen includes fields for user input (email and password), buttons for
/// login, navigation to registration and password recovery, and responsiveness
/// for wide and narrow screen layouts.

import 'package:chitter_chatter/Features/Screens/homepage/View/homepage_view.dart';
import 'package:chitter_chatter/Features/userAuthentication/forgot_password_screen/View/forgot_password_screen.dart';
import 'package:chitter_chatter/Features/userAuthentication/register_Screen/View/register_screen.dart';
import 'package:flutter/material.dart';
import '../../../../common_utils/widgets/colors.dart';
import '../../../../common_utils/widgets/custom_button.dart';
import '../Controller/login_controller.dart';

/// LoginScreen is a stateful widget that displays the login UI.
/// It allows users to enter their credentials and initiate login,
/// as well as navigate to the registration or password recovery screens.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// TextEditingControllers for managing the input fields for email and password.
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  /// Instance of LoginController to handle login business logic.
  final LoginController _loginController = LoginController();

  /// Disposes of the TextEditingControllers when the widget is removed from the widget tree.
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Builds the UI for the login screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: appBarColor,
        elevation: 0, // Flat design with no shadow.
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          /// Determines if the screen is wide, which affects layout alignment.
          bool isWideScreen = constraints.maxWidth > 800;

          return Container(
            alignment: isWideScreen ? Alignment.center : Alignment.topCenter,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWideScreen ? 400 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(_email, "Enter your email", Icons.email),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _password,
                        "Enter your password",
                        Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        onPressed: () {
                          /// Handles the login process by invoking the controller's method.
                          final email = _email.text;
                          final password = _password.text;
                          _loginController.loginUser(
                            email: email,
                            password: password,
                            context: context,
                            onSuccess: () {
                              /// Navigates to the homepage on successful login.
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Homepage(),
                                ),
                              );
                            },
                          );
                        },
                        text: 'Login',
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// Button to navigate to the registration screen.
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Not Registered? Register Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      /// Button to navigate to the forgot password screen.
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds a styled [TextField] widget for email or password input.
  ///
  /// - Parameters:
  ///   - [controller]: The controller for managing the input field's value.
  ///   - [hintText]: Placeholder text displayed in the input field.
  ///   - [icon]: Leading icon displayed in the input field.
  ///   - [isPassword]: Boolean indicating if the field should obscure text (e.g., for passwords).
  ///
  /// - Returns: A [TextField] widget with custom styling and behavior.
  Widget _buildTextField(
      TextEditingController controller,
      String hintText,
      IconData icon, {
        bool isPassword = false,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
