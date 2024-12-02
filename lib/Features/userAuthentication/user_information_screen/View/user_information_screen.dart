/// This file defines the `UserInformationScreen` widget, which serves as the
/// UI for collecting user information, such as their name and profile picture.

import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../common_utils/widgets/colors.dart';
import '../controller/user_information_controller.dart';
import '../model/user_information_model.dart';

/// A stateful widget for collecting user information.
class UserInformationScreen extends StatefulWidget {
  static const String routeName = '/user-information';

  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  /// Controller for the name input field.
  final TextEditingController nameController = TextEditingController();

  /// Stores the selected image as a byte array.
  Uint8List? imageBytes;

  /// Instance of `UserInformationController` for handling logic.
  final UserInformationController _controller = UserInformationController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  /// Opens the image picker to select an image.
  ///
  /// If successful, updates the state with the selected image.
  /// Displays an error message if the operation fails.
  void selectImage() async {
    try {
      final pickedImage = await _controller.pickImage();
      setState(() {
        imageBytes = pickedImage;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  /// Saves the user's information by invoking the controller logic.
  ///
  /// Displays error messages for validation or save failures.
  void saveUserInfo() async {
    try {
      final user = UserInformationModel(
        name: nameController.text.trim(),
        profilePicture: imageBytes,
      );

      await _controller.saveUserInfo(user: user, context: context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: errorMessageColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: imageBytes != null
                        ? MemoryImage(imageBytes!)
                        : const NetworkImage(
                      'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                    ) as ImageProvider,
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: _controller.isLoading ? null : selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.7,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      enabled: !_controller.isLoading,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  _controller.isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                    onPressed: saveUserInfo,
                    icon: const Icon(Icons.done),
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
