// homepage_controller.dart
import 'dart:convert';
import 'package:chitter_chatter/Features/Screens/homepage/Model/user_model.dart';
import 'package:chitter_chatter/Features/userAuthentication/login_screen/View/login_screen.dart';
import 'package:chitter_chatter/Features/userProfile/profile_screen/view/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


/// Controller for handling homepage-related logic and operations.
///
/// Provides functionalities for fetching user data, managing user stories,
/// and handling sign-out operations.
class HomepageController {
  /// An instance of [FirebaseAuth] for handling authentication-related operations.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// An instance of [FirebaseFirestore] for interacting with the Firestore database.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches the current user's data and their recent statuses from Firestore.
  ///
  /// This method retrieves the user's basic information from the 'users' collection,
  /// and their recent stories from the 'stories' subcollection. Stories older than
  /// 24 hours are excluded from the results.
  ///
  /// Returns a [UserModel] containing the user's name, profile picture, and recent statuses,
  /// or `null` if an error occurs or the user data is not found.
  Future<UserModel?> fetchUserData() async {
    // Get the current user's ID.
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        // Fetch the user's main document from the 'users' collection.
        final doc = await _firestore.collection('users').doc(userId).get();

        // Fetch the user's stories, ordered by the 'date' field in descending order.
        final storiesCollection = await _firestore
            .collection('users')
            .doc(userId)
            .collection('stories')
            .orderBy('date', descending: true)
            .get();

        // Get the current time to filter stories within the last 24 hours.
        final currentTime = DateTime.now();

        // A list to hold the filtered statuses.
        List<Map<String, dynamic>> statuses = [];

        // Loop through each story document and filter based on the timestamp.
        for (var doc in storiesCollection.docs) {
          final data = doc.data();
          final timestamp = data['date'] as Timestamp;
          final statusDate = timestamp.toDate();

          // Include the story only if it was created within the last 24 hours.
          if (currentTime.difference(statusDate).inHours < 24) {
            statuses.add({
              'status': data['status'], // The status content.
              'date': statusDate, // The timestamp of the status.
            });
          }
        }

        // If the user's main document exists, return a UserModel with the fetched data.
        if (doc.exists) {
          return UserModel(
            name: doc['name'], // The user's name.
            profilePictureBase64: doc['profilePicture'], // Base64-encoded profile picture.
            recentStatus: statuses, // List of recent statuses.
          );
        }
      } catch (e) {
        // Log an error message if an exception occurs during the fetch process.
        print("Error fetching user data: $e");
      }
    }

    // Return null if the user ID is null or the data fetch process fails.
    return null;
  }

  /// Signs out the current user and navigates back to the login screen.
  ///
  /// This method attempts to sign the user out using FirebaseAuth's `signOut` method.
  /// If successful, the user is redirected to the [LoginScreen]. If an error occurs,
  /// a snackbar with an error message is displayed.
  ///
  /// [context] is required for navigation and displaying snackbar messages.
  Future<void> signOut(BuildContext context) async {
    try {
      // Perform the sign-out operation using FirebaseAuth.
      await _auth.signOut();

      // Navigate to the login screen, replacing the current route stack.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Log the error and display a snackbar with an error message.
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error signing out. Please try again.")),
      );
    }
  }
}
