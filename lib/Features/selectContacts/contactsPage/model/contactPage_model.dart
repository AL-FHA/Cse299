import 'dart:typed_data';

/// A model class representing a contact.
///
/// Contains the following fields:
/// - `displayName` - The name of the contact.
/// - `phoneNumber` - The normalized phone number of the contact.
/// - `photo` - A photo of the contact as a `Uint8List`, or `null` if unavailable.
class ContactModel {
  final String displayName;
  final String phoneNumber;
  final Uint8List? photo;

  /// Constructs a `ContactModel` instance.
  ///
  /// [displayName] - The contact's display name.
  /// [phoneNumber] - The contact's phone number.
  /// [photo] - The contact's photo as a `Uint8List` (optional).
  ContactModel({
    required this.displayName,
    required this.phoneNumber,
    this.photo,
  });
}
