import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chitter_chatter/Features/chatScreen/contact_list/model/contact_model.dart';

/// Controller for managing contacts in the chat list.
///
/// Provides methods to fetch the chat list, delete a contact, get profile images, and handle user confirmation for contact deletion.
class ContactController {
  // Private instance of `ContactModel` to delegate operations.
  final ContactModel _contactModel = ContactModel();

  /// Fetches the chat list as a stream of `QuerySnapshot` objects.
  Stream getChatList() {
    return _contactModel.getChatList();
  }

  /// Deletes a contact by its document ID from Firestore.
  Future<void> deleteContact(String documentId) async {
    return _contactModel.deleteContact(documentId);
  }

  /// Retrieves the profile image as an `ImageProvider`.
  ///
  /// If a valid base64-encoded string is provided, it decodes it to an image; otherwise, it returns a default image.
  ImageProvider<Object> getProfileImage(String? base64Image) {
    return _contactModel.getProfileImage(base64Image);
  }

  /// Displays a confirmation dialog before deleting a contact.
  ///
  /// If confirmed, the contact is deleted using its document ID.
  void confirmDelete(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Contact"),
          content: const Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await deleteContact(documentId);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
