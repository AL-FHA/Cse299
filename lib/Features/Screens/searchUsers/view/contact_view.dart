/// A stateful widget that allows users to search and view their contacts.
///
/// The `SearchUsers` widget fetches a list of user contacts from a backend service
/// (via the `SearchUsersController`) and displays them in a searchable list. Users can
/// filter contacts based on a query entered in the search bar and navigate to a chat screen
/// by selecting a contact.

import 'package:chitter_chatter/Features/chatScreen/chatscreen/View/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chitter_chatter/Features/Screens/searchUsers/model/contact_model.dart';

import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import '../controller/contact_controller.dart';

/// The main widget responsible for managing and displaying the contact search interface.
class SearchUsers extends StatefulWidget {
  /// Creates a `SearchUsers` widget.
  ///
  /// - [key]: An optional key for this widget.
  const SearchUsers({Key? key}) : super(key: key);

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

/// The state associated with the `SearchUsers` widget.
///
/// This class handles loading contacts, managing the search functionality,
/// and updating the UI based on the current state of the contact list.
class _SearchUsersState extends State<SearchUsers> {
  /// The controller responsible for fetching and filtering contacts.
  final SearchUsersController _controller = SearchUsersController();

  /// The controller for managing the search query input field.
  final TextEditingController _searchController = TextEditingController();

  /// The list of all contacts fetched from the backend.
  List<ContactModel> _contacts = [];

  /// The filtered list of contacts based on the search query.
  List<ContactModel> _filteredContacts = [];

  /// Indicates whether the contacts are currently being loaded.
  bool _isLoading = true;

  /// Initializes the state and triggers the loading of contacts.
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  /// Disposes of resources used by this widget, including the search controller.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Loads the contacts from the backend using the `SearchUsersController`.
  ///
  /// If an error occurs during the loading process, an error message
  /// is displayed using a `SnackBar`.
  Future<void> _loadContacts() async {
    try {
      final contacts = await _controller.fetchContacts();
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading contacts: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading contacts. Please try again.')),
        );
      }
    }
  }

  /// Filters the list of contacts based on the search query.
  ///
  /// - [query]: The search string entered by the user.
  void _searchContacts(String query) {
    setState(() {
      _filteredContacts = _controller.filterContacts(_contacts, query);
    });
  }

  /// Builds the widget tree for the contact search interface.
  ///
  /// This includes:
  /// - A search bar in the app bar for entering search queries.
  /// - A loading indicator while contacts are being fetched.
  /// - A message when no contacts match the search query.
  /// - A scrollable list of contacts that match the query.
  ///
  /// Returns a `Scaffold` containing the UI elements.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search contacts...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: _searchContacts,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredContacts.isEmpty
          ? const Center(child: Text('No contacts found'))
          : ListView.builder(
        itemCount: _filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = _filteredContacts[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: contact.profileImage,
            ),
            title: Text(contact.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatView(userId: contact.userId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
