/// A data model representing a user contact.
///
/// The `ContactModel` class encapsulates the essential details of a contact,
/// including their name, user ID, and profile picture. It provides functionality
/// to parse contact data from Firestore and handle profile picture rendering.
import 'dart:convert';
import 'package:flutter/material.dart';

/// A model class to represent a contact.
class ContactModel {
  /// The name of the contact.
  final String name;

  /// The unique identifier for the contact.
  final String userId;

  /// The base64-encoded string representing the contact's profile picture.
  ///
  /// This can be `null` if the contact does not have a profile picture.
  final String? profilePic;

  /// Creates a new instance of `ContactModel`.
  ///
  /// - [name]: The name of the contact (required).
  /// - [userId]: The unique user ID of the contact (required).
  /// - [profilePic]: A base64-encoded string of the contact's profile picture (optional).
  ContactModel({
    required this.name,
    required this.userId,
    this.profilePic,
  });

  /// Factory constructor to create a `ContactModel` from Firestore data.
  ///
  /// This parses the given `data` map, typically retrieved from Firestore,
  /// to initialize a `ContactModel` instance. Defaults are provided for missing fields.
  ///
  /// Example usage:
  /// ```dart
  /// final data = {
  ///   'name': 'Alice',
  ///   'userId': '123',
  ///   'profilePic': 'base64string'
  /// };
  /// final contact = ContactModel.fromFirestore(data);
  /// ```
  ///
  /// - [data]: A map of key-value pairs representing the contact details from Firestore.
  ///
  /// Returns a `ContactModel` instance.
  factory ContactModel.fromFirestore(Map<String, dynamic> data) {
    return ContactModel(
      name: data['name'] ?? 'Unknown',
      userId: data['userId'] ?? '',
      profilePic: data['profilePic'],
    );
  }

  /// Retrieves the profile image of the contact.
  ///
  /// - If `profilePic` is a valid base64-encoded string, it returns a `MemoryImage`.
  /// - If `profilePic` is `null` or empty, it defaults to a placeholder image
  ///   stored in the assets at `assets/images/default_profile_pic.png`.
  ///
  /// Example usage:
  /// ```dart
  /// final image = contact.profileImage; // Returns an ImageProvider for rendering.
  /// ```
  ///
  /// Returns an `ImageProvider` suitable for rendering in Flutter widgets.
  ImageProvider get profileImage {
    if (profilePic != null && profilePic!.isNotEmpty) {
      return MemoryImage(base64Decode(profilePic!));
    }
    return const AssetImage('assets/images/default_profile_pic.png');
  }
}
