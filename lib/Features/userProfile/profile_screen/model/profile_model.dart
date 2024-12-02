/// A model class that represents a user's profile information.
class ProfileModel {
  final String? name;
  final String? phoneNumber;
  final String? profilePictureBase64;

  ProfileModel({
    required this.name,
    required this.phoneNumber,
    required this.profilePictureBase64,
  });

  /// Creates an instance of [ProfileModel] from Firestore document data.
  ///
  /// [data] is a map containing the Firestore document fields.
  factory ProfileModel.fromFirestore(Map<String, dynamic> data) {
    return ProfileModel(
      name: data['name'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      profilePictureBase64: data['profilePicture'] as String?,
    );
  }

  /// Converts [ProfileModel] instance into a Firestore-compatible map.
  ///
  /// Returns a map with keys 'name', 'phoneNumber', and 'profilePicture'.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePictureBase64,
    };
  }
}
