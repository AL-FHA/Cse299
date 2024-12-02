import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a user's status.
class StatusModel {
  final String name;
  final String status;
  final DateTime date;
  final String profilePicture;

  /// Creates a [StatusModel] instance from a map of data.
  ///
  /// This factory constructor is used to convert the Firebase document data
  /// to a [StatusModel] instance.
  ///
  /// The [map] argument contains the Firebase document data, which should
  /// include the fields: 'name', 'status', 'date', and 'profilePicture'.
  StatusModel({
    required this.name,
    required this.status,
    required this.date,
    required this.profilePicture,
  });

  /// Creates a [StatusModel] from a map.
  ///
  /// The map should contain the keys:
  /// - 'name' (String): The name of the user who posted the status.
  /// - 'status' (String): The status content.
  /// - 'date' (Timestamp): The date when the status was posted.
  /// - 'profilePicture' (String): Base64-encoded profile picture of the user.
  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      name: map['name'],
      status: map['status'],
      date: (map['date'] as Timestamp).toDate(),
      profilePicture: map['profilePicture'],
    );
  }
}
