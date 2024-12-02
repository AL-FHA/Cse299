// user_model.dart
/// Represents a user's profile and recent activity information
///
/// This model encapsulates key user details including their name,
/// profile picture, and recent status updates.
class UserModel {
  /// The user's name, which can be null if not provided
  ///
  /// [name] is an optional string representing the user's display name
  /// It allows for scenarios where a user might not have set a name
  final String? name;

  /// Base64 encoded string representing the user's profile picture
  ///
  /// [profilePictureBase64] stores the profile picture as a base64 encoded string
  /// This allows for efficient storage and transmission of image data
  /// Can be null if no profile picture is set
  final String? profilePictureBase64;

  /// A list of recent status updates for the user
  ///
  /// [recentStatus] is a list of maps containing dynamic status information
  /// Each map can include various details about a user's recent activity or status
  /// The dynamic typing allows for flexible status update structures
  final List<Map<String, dynamic>> recentStatus;

  /// Constructor for creating a [UserModel] instance
  ///
  /// All parameters are required, but can be null for [name] and [profilePictureBase64]
  ///
  /// [name] is the user's display name
  /// [profilePictureBase64] is the base64 encoded profile picture
  /// [recentStatus] is the list of recent status updates
  UserModel({
    required this.name,
    required this.profilePictureBase64,
    required this.recentStatus,
  });
}