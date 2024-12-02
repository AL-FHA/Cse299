import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:typed_data';

import 'package:chitter_chatter/Features/selectContacts/contactsPage/model/contactPage_model.dart';

class ContactController {
  /// Normalize phone numbers
  String normalizePhoneNumber(String phoneNumber) {
    String normalized = '';
    for (int i = 0; i < phoneNumber.length; i++) {
      final char = phoneNumber[i];
      if (char.codeUnitAt(0) >= '0'.codeUnitAt(0) && char.codeUnitAt(0) <= '9'.codeUnitAt(0)) {
        normalized += char;
      } else if (char == '+' && normalized.isEmpty) {
        normalized += char;
      }
    }
    return normalized;
  }

  /// Fetch contacts with normalized phone numbers
  Future<List<Contact>> fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      for (var contact in contacts) {
        for (var i = 0; i < contact.phones.length; i++) {
          contact.phones[i] = Phone(
            normalizePhoneNumber(contact.phones[i].number),
            label: contact.phones[i].label,
          );
        }
      }
      return contacts;
    }
    return [];
  }

  /// Convert Flutter contacts to ContactModel
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

  /// Check if the contact is registered
  Future<String?> checkContactRegistration(String phoneNumber) async {
    try {
      final normalizedNumber = normalizePhoneNumber(phoneNumber);
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: normalizedNumber)
          .get();

      return querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.id : null;
    } catch (e) {
      print("Error checking contact registration: $e");
      return null;
    }
  }

  /// Add contact to chat list
  Future<void> addToChatList(String contactUserId) async {
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
  }
}
