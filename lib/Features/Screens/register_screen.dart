import 'package:chitter_chatter/Features/Screens/login_screen.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:chitter_chatter/common_utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _reEnterPassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _reEnterPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
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
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
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
                _buildTextField(_password, "Enter your password", Icons.lock,
                    isPassword: true),
                const SizedBox(height: 20),
                _buildTextField(
                    _reEnterPassword, "Re-enter your password", Icons.lock,
                    isPassword: true),
                const SizedBox(height: 30),
                CustomButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    final reEnterPassword = _reEnterPassword.text;
                    if (password == reEnterPassword) {
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        _handleFirebaseError(e, context);
                      }
                    } else {
                      String mismatchError = "Password did not match";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            mismatchError,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, // Make the text bold
                              color:
                                  Colors.white, // Set the text color to black
                            ),
                          ),
                          backgroundColor: tabColor,
                        ),
                      );
                    }
                  },
                  text: 'Register',
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
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
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false}) {
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

  void _handleFirebaseError(FirebaseAuthException e, BuildContext context) {
    String errorMessage = "An unexpected error occurred.";
    if (e.code == 'email-already-in-use') {
      errorMessage = "Email already in use. Try another.";
    } else if (e.code == 'invalid-email') {
      errorMessage = "Please enter a valid email address.";
    } else {
      errorMessage =
          "Password must contain an uppercase letter and lowercase letter and numeric and special character.";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.white, // Set the text color to black
          ),
        ),
        backgroundColor: tabColor,
      ),
    );
  }
}
