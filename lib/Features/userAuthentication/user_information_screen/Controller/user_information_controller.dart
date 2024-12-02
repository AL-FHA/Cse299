/// This file defines the `UserInformationController` class, which manages
/// the business logic for handling user data and interactions, such as
/// selecting an image and saving user information to Firebase Firestore.

import 'dart:typed_data';
import 'package:chitter_chatter/Features/userAuthentication/email_verification_screen/View/email_varification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_information_model.dart';


/// Handles the business logic for the user information screen.
class UserInformationController {
  /// An instance of `ImagePicker` for picking images from the user's gallery.
  final ImagePicker _picker = ImagePicker();

  /// Indicates whether a save operation is in progress.
  bool _isLoading = false;

  /// Public getter for `_isLoading`.
  bool get isLoading => _isLoading;

  /// Opens the image picker and returns the selected image as a byte array (`Uint8List`).
  ///
  /// Returns `null` if the user cancels the operation or an error occurs.
  Future<Uint8List?> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      return pickedFile != null ? await pickedFile.readAsBytes() : null;
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }

  /// Saves the user's information to Firebase Firestore.
  ///
  /// Parameters:
  /// - [user]: A `UserInformationModel` instance containing the user's data.
  /// - [context]: The `BuildContext` for navigation and showing error messages.
  ///
  /// Throws an exception if:
  /// - The user is not authenticated.
  /// - The name or profile picture is missing.
  /// - There is an error while saving the data.
  Future<void> saveUserInfo({
    required UserInformationModel user,
    required BuildContext context,
  }) async {
    if (_isLoading) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    if (user.name.trim().isEmpty) {
      throw Exception('Please enter your name');
    }

    if (user.profilePicture == null) {
      throw Exception('Please select a profile picture');
    }

    _isLoading = true;

    try {
      final userData = user.toMap();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set(userData, SetOptions(merge: true));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
            (route) => false,
      );
    } catch (e) {
      throw Exception('Error saving user info: $e');
    } finally {
      _isLoading = false;
    }
  }
}
