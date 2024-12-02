import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chitter_chatter/Features/selectContacts/search_contacts/model/contact_search_model.dart';

/// A controller to handle contact operations for the contact search feature.
///
/// Provides methods for filtering, mapping, and interacting with contact data.
class ContactsController {
  final List<ContactModel> contacts;

  ContactsController({required this.contacts});

  /// Fetches contacts from the device with their properties (e.g., name and phone numbers).
  ///
  /// Returns a list of `Contact` objects if the user grants permissions, otherwise an empty list.
  Future<List<Contact>> fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      return await FlutterContacts.getContacts(withProperties: true);
    }
    return [];
  }

  /// Maps a list of `Contact` objects to `ContactModel` objects.
  ///
  /// Simplifies the contact data for use within the application.
  List<ContactModel> mapToContactModels(List<Contact> contacts) {
    return contacts.map((contact) {
      final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : '';
      return ContactModel(
        displayName: contact.displayName,
        phoneNumber: phoneNumber,
        photo: contact.photo,
      );
    }).toList();
  }

  /// Filters the contact list based on the search query.
  ///
  /// Returns only the contacts whose display name contains the query (case-insensitive).
  List<ContactModel> filterContacts(String query) {
    return contacts
        .where((contact) =>
        contact.displayName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Normalizes phone numbers to a consistent format.
  ///
  /// Removes non-numeric characters while preserving the leading "+" if present.
  String normalizePhoneNumber(String phoneNumber) {
    String normalized = '';
    for (int i = 0; i < phoneNumber.length; i++) {
      final char = phoneNumber[i];
      if (char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
          char.codeUnitAt(0) <= '9'.codeUnitAt(0)) {
        normalized += char;
      } else if (char == '+' && normalized.isEmpty) {
        normalized += char;
      }
    }
    return normalized;
  }

  /// Checks if a contact is registered in the app based on their phone number.
  ///
  /// Queries Firestore for a user with the normalized phone number and returns their user ID if found.
  Future<String?> checkContactRegistration(String phoneNumber) async {
    try {
      final normalizedNumber = normalizePhoneNumber(phoneNumber);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: normalizedNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error checking contact registration: $e");
      return null;
    }
  }

  /// Adds a contact to the current user's chat list in Firestore.
  ///
  /// Retrieves the contact's profile data and updates the chat list.
  Future<void> addToChatList(String contactUserId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final contactDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(contactUserId)
          .get();

      if (contactDoc.exists) {
        final contactData = contactDoc.data();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('chatList')
            .doc(contactUserId)
            .set({
          'name': contactData?['name'] ?? '',
          'profilePic': contactData?['profilePicture'] ?? '',
          'userId': contactUserId,
          'lastMessage': '',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error adding to chat list: $e");
    }
  }
}
