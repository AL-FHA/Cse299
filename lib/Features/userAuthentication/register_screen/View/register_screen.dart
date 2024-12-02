import 'package:chitter_chatter/Features/userAuthentication/login_screen/View/login_screen.dart';
import 'package:chitter_chatter/Features/userAuthentication/user_information_screen/View/user_information_screen.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:chitter_chatter/common_utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../Controller/register_controller.dart';

/// A Flutter screen for user registration.
///
/// This screen allows users to register for the application by entering their
/// email, phone number, and password. The registration process validates
/// the inputs and communicates with the [RegisterController] to handle backend logic.
///
/// Navigates to the [UserInformationScreen] on successful registration, or
/// displays an error message if registration fails.
class RegisterScreen extends StatefulWidget {
  /// Creates a [RegisterScreen] widget.
  ///
  /// This widget is the entry point for user registration.
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

/// State class for the [RegisterScreen].
///
/// Handles user interaction, form validation, and communication with the
/// [RegisterController] to manage the registration process.
///
/// Manages the UI layout to adapt to screen size constraints.
class _RegisterScreenState extends State<RegisterScreen> {
  /// Controller for managing the email input field.
  final TextEditingController _email = TextEditingController();

  /// Controller for managing the password input field.
  final TextEditingController _password = TextEditingController();

  /// Controller for managing the password confirmation input field.
  final TextEditingController _reEnterPassword = TextEditingController();

  /// Instance of the [RegisterController] to handle the business logic for user registration.
  final RegisterController _controller = RegisterController();

  /// Holds the complete phone number entered by the user, including the country code.
  ///
  /// This is updated dynamically as the user types in the phone number field.
  String? _phoneNumber;

  @override
  void dispose() {
    // Dispose of text controllers to free resources when the widget is destroyed.
    _email.dispose();
    _password.dispose();
    _reEnterPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: appBarColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determines if the device screen is wide (e.g., tablet or desktop).
          final isWideScreen = constraints.maxWidth > 800;

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
                        "Create Account",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(_email, "Enter your email", Icons.email),
                      const SizedBox(height: 20),
                      IntlPhoneField(
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white24,
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        initialCountryCode: 'BD',
                        onChanged: (phone) {
                          _phoneNumber = phone.completeNumber;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _password,
                        "Enter your password",
                        Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _reEnterPassword,
                        "Re-enter your password",
                        Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        onPressed: () async {
                          // Attempt to register the user using the provided inputs.
                          final message = await _controller.registerUser(
                            email: _email.text.trim(),
                            password: _password.text.trim(),
                            reEnterPassword: _reEnterPassword.text.trim(),
                            phoneNumber: _phoneNumber,
                          );

                          // Display an error message if registration fails.
                          if (message != null) {
                            _showSnackBar(context, message);
                          } else {
                            // Navigate to the user information screen upon success.
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserInformationScreen(),
                              ),
                            );
                          }
                        },
                        text: 'Register',
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Go to Login Screen",
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

  /// Builds a styled text field for user input.
  ///
  /// This helper method creates a [TextField] with consistent styling,
  /// which includes rounded corners and a prefix icon.
  ///
  /// - [controller]: Controls the input field's text.
  /// - [hintText]: Placeholder text for the input field.
  /// - [icon]: The icon displayed at the start of the field.
  /// - [isPassword]: Whether the field should obscure the text for passwords.
  ///
  /// Returns a styled [Widget] representing the text field.
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
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  /// Displays a [SnackBar] with a message.
  ///
  /// Shows a [SnackBar] to provide feedback to the user, such as error messages
  /// or success notifications.
  ///
  /// - [context]: The [BuildContext] to find the nearest scaffold.
  /// - [message]: The message text to display in the snackbar.
  void _showSnackBar(BuildContext context, String message) {
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
        backgroundColor: errorMessageColor,
      ),
    );
  }
}
