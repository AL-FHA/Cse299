import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:chitter_chatter/Features/selectContacts/search_contacts/controller/contact_search_controller.dart';
import 'package:chitter_chatter/Features/selectContacts/search_contacts/view/contact_search_view.dart';
import 'package:chitter_chatter/Features/chatScreen/chatscreen/View/chat_screen.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';

/// The `ContactsPage` widget displays a list of contacts retrieved from the user's device.
///
/// - Allows users to view their contacts and identify which ones are registered in the app.
/// - Provides a search functionality to filter through the contacts.
/// - Tapping on a registered contact navigates to a chat screen with that contact.
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ContactsController _controller = ContactsController(contacts: []);
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  /// Fetches the user's contacts using the `ContactsController`.
  ///
  /// Updates the `contacts` state once the contacts are successfully retrieved.
  Future<void> _fetchContacts() async {
    final fetchedContacts = await _controller.fetchContacts();
    setState(() {
      contacts = fetchedContacts;
    });
  }

  /// Displays a message to the user in a `SnackBar`.
  ///
  /// [message] - The message to be displayed.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: tabColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        backgroundColor: appBarColor,
        actions: [
          // Search button navigates to the `SearchContactsView`.
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchContactsView(
                    contacts: _controller.mapToContactModels(contacts),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : '';

          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: contact.photo != null
                  ? MemoryImage(contact.photo!)
                  : const NetworkImage('https://www.example.com/default-profile-pic.png'),
            ),
            title: Text(contact.displayName, style: const TextStyle(fontSize: 18)),
            subtitle: Text(phoneNumber.isNotEmpty ? phoneNumber : 'No number'),
            onTap: () async {
              // Checks if the contact is registered in the app.
              final contactUserId = await _controller.checkContactRegistration(phoneNumber);
              if (contactUserId != null) {
                // Adds the contact to the current user's chat list and navigates to the chat screen.
                await _controller.addToChatList(contactUserId);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatView(userId: contactUserId),
                  ),
                );
              } else {
                _showMessage("Contact is not registered on the app");
              }
            },
          );
        },
      ),
    );
  }
}
