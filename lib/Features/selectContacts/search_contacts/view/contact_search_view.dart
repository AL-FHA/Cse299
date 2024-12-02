import 'package:flutter/material.dart';
import 'package:chitter_chatter/Features/chatScreen/chatscreen/View/chat_screen.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:chitter_chatter/Features/selectContacts/search_contacts/model/contact_search_model.dart';
import 'package:chitter_chatter/Features/selectContacts/search_contacts/controller/contact_search_controller.dart';

/// A UI view for searching through the contact list.
///
/// Displays a list of contacts filtered by the user's search query.
class SearchContactsView extends StatefulWidget {
  final List<ContactModel> contacts;

  const SearchContactsView({Key? key, required this.contacts}) : super(key: key);

  @override
  State<SearchContactsView> createState() => _SearchContactsViewState();
}

class _SearchContactsViewState extends State<SearchContactsView> {
  late ContactsController controller;
  List<ContactModel> filteredContacts = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    controller = ContactsController(contacts: widget.contacts);
    filteredContacts = widget.contacts;
  }

  /// Updates the filtered contact list based on the user's search query.
  void _updateSearchQuery(String searchText) {
    setState(() {
      query = searchText;
      filteredContacts = controller.filterContacts(query);
    });
  }

  /// Displays a message to the user using a `SnackBar`.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: tabColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: _updateSearchQuery,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search contacts...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
      body: filteredContacts.isEmpty
          ? const Center(child: Text("No matching contacts"))
          : ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(contact.displayName),
            subtitle: Text(contact.phoneNumber),
            onTap: () async {
              if (contact.phoneNumber == 'No number') {
                _showMessage("Contact has no valid phone number");
                return;
              }

              final contactUserId =
              await controller.checkContactRegistration(contact.phoneNumber);

              if (contactUserId != null) {
                Navigator.pop(context); // Close search
                Navigator.push(
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
