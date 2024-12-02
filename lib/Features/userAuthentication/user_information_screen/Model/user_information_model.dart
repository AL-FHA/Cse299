/// This file defines the `UserInformationModel` class, which represents
/// the user's data, including their name and profile picture.
///
/// The purpose of the model is to encapsulate the user's information
/// and provide a way to convert the data into a format suitable for
/// saving in a database (e.g., Firebase Firestore).

import 'dart:convert';
import 'dart:typed_data';

/// Represents the user's information, including their name and profile picture.
class UserInformationModel {
  /// The name of the user.
  String name;

  /// The user's profile picture as a `Uint8List` (byte data).
  /// This is useful for handling image data efficiently.
  Uint8List? profilePicture;

  /// Constructor for creating a `UserInformationModel` instance.
  ///
  /// [name] is a required parameter for the user's name.
  /// [profilePicture] is optional and represents the profile picture in byte format.
  UserInformationModel({
    required this.name,
    this.profilePicture,
  });

  /// Converts the `UserInformationModel` instance into a map
  /// that can be used for saving data in Firestore or other databases.
  ///
  /// - The `name` is stored as a string.
  /// - The `profilePicture` is encoded as a Base64 string to ensure compatibility.
  /// If the picture size exceeds 500 KB, only the first 500 KB is encoded.
  Map<String, dynamic> toMap() {
    String? profilePictureBase64;
    if (profilePicture != null) {
      profilePictureBase64 = profilePicture!.length > 500000
          ? base64Encode(profilePicture!.sublist(0, 500000))
          : base64Encode(profilePicture!);
    }

    return {
      'name': name,
      'profilePicture': profilePictureBase64,
    };
  }
}
