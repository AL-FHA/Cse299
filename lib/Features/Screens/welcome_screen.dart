import 'package:chitter_chatter/Features/Screens/login_screen.dart';
import 'package:chitter_chatter/common_utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 9, 31),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Welcome To Chitter-Chatter",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: (size.height) / 20,
            ),
            Image.asset(
              'assets/icon2.png',
              height: 450,
              width: 450,
            ),
            SizedBox(height: (size.height) / 20),
            const Text("Click the button to continue to the app",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
                width: size.width * 0.80,
                child: CustomButton(
                    text: "Continue",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    }, child: const Text("Continue"),))
          ],
        ),
      ),
    );
  }
}
