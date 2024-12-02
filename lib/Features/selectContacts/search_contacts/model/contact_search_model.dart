import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:typed_data';

/// A data model representing a contact.
///
/// Used to store essential information about a contact fetched from the device's contact list.
class ContactModel {
  final String displayName;
  final String phoneNumber;
  final Uint8List? photo;

  ContactModel({
    required this.displayName,
    required this.phoneNumber,
    this.photo,
  });

  /// Factory method to create a `ContactModel` from a `Contact` object.
  ///
  /// - Extracts the display name and phone number.
  /// - Defaults phone number to "No number" if not available.
  factory ContactModel.fromContact(Contact contact) {
    final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : 'No number';
    return ContactModel(
      displayName: contact.displayName,
      phoneNumber: phoneNumber,
    );
  }
}
