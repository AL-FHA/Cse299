/// A controller class to handle fetching and filtering of user contacts.
///
/// The `SearchUsersController` is responsible for interacting with Firebase
/// to retrieve a user's chat list and apply filtering logic based on a search query.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chitter_chatter/Features/Screens/searchUsers/model/contact_model.dart';

/// A controller to manage fetching and filtering user contacts.
class SearchUsersController {
  /// Fetches the list of user contacts from Firestore.
  ///
  /// This method retrieves the authenticated user's `chatList` from the Firestore database.
  /// Each contact document in the `chatList` is converted into a `ContactModel` object.
  ///
  /// If the current user is not authenticated, it returns an empty list.
  ///
  /// Example usage:
  /// ```dart
  /// final controller = SearchUsersController();
  /// final contacts = await controller.fetchContacts();
  /// ```
  ///
  /// Returns a `Future` that resolves to a list of `ContactModel` objects.
  Future<List<ContactModel>> fetchContacts() async {
    // Get the currently authenticated user.
    final currentUser = FirebaseAuth.instance.currentUser;

    // If no user is logged in, return an empty list.
    if (currentUser == null) return [];

    // Fetch the chat list from Firestore.
    final snapshot = await FirebaseFirestore.instance
        .collection('users') // Access the 'users' collection.
        .doc(currentUser.uid) // Find the document for the logged-in user.
        .collection('chatList') // Access the 'chatList' sub-collection.
        .get();

    // Map the Firestore documents into a list of ContactModel objects.
    return snapshot.docs
        .map((doc) => ContactModel.fromFirestore(doc.data()))
        .toList();
  }

  /// Filters a list of contacts based on a search query.
  ///
  /// This method searches through the provided list of contacts and returns
  /// only the contacts whose names contain the query string (case-insensitive).
  ///
  /// If the query string is empty or consists only of whitespace, it returns
  /// the full list of contacts.
  ///
  /// Example usage:
  /// ```dart
  /// final controller = SearchUsersController();
  /// final filteredContacts = controller.filterContacts(allContacts, 'Alice');
  /// ```
  ///
  /// - [contacts]: The list of `ContactModel` objects to be filtered.
  /// - [query]: The search query string.
  ///
  /// Returns a list of `ContactModel` objects matching the query.
  List<ContactModel> filterContacts(List<ContactModel> contacts, String query) {
    // If the query is empty or only whitespace, return the full list.
    if (query.trim().isEmpty) return contacts;

    // Filter contacts based on whether their name contains the query (case-insensitive).
    return contacts
        .where((contact) => contact.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
