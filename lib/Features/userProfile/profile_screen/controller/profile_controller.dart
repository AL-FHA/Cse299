import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chitter_chatter/Features/userProfile/profile_screen/model/profile_model.dart';

/// A controller class to handle profile-related operations
/// including fetching, updating user data and picking profile pictures.
class ProfileController {
  final ImagePicker _picker = ImagePicker();

  /// Fetches the user's profile data from Firestore.
  ///
  /// Returns a [ProfileModel] instance containing user details or null if user is not found.
  Future<ProfileModel?> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        return ProfileModel.fromFirestore(doc.data()!);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  /// Updates the user's profile data in Firestore.
  ///
  /// [profile] is an instance of [ProfileModel] containing the updated user information.
  Future<void> updateUserData(ProfileModel profile) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update(profile.toFirestore());
    } catch (e) {
      print("Error updating user data: $e");
      throw Exception("Failed to update profile.");
    }
  }

  /// Picks a profile image from the gallery.
  ///
  /// Returns the image as a base64 encoded string or null if no image is selected.
  Future<String?> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        return base64Encode(bytes);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
    return null;
  }
}
