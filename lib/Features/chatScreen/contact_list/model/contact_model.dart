import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Model for managing contact data.
///
/// Includes methods to fetch, delete, and retrieve profile images for contacts in the chat list.
class ContactModel {
  /// Fetches the chat list for the current user as a stream of `QuerySnapshot` objects.
  ///
  /// The chat list is ordered by the `timestamp` field in descending order.
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatList() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .collection('chatList')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Deletes a contact by its document ID from the Firestore chat list.
  Future<void> deleteContact(String documentId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .collection('chatList')
          .doc(documentId)
          .delete();
    } catch (e) {
      throw Exception("Error deleting contact: $e");
    }
  }

  /// Retrieves a profile image from a base64-encoded string or a default image if the string is null/empty.
  ///
  /// - `base64Image`: Base64-encoded string representing the profile picture.
  ImageProvider<Object> getProfileImage(String? base64Image) {
    if (base64Image != null && base64Image.isNotEmpty) {
      return MemoryImage(base64Decode(base64Image));
    }
    return const NetworkImage(
        'https://www.example.com/default-profile-pic.png'); // Replace with your default profile image URL.
  }
}
