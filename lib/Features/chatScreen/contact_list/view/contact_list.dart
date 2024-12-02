import 'package:flutter/material.dart';
import 'package:chitter_chatter/Features/chatScreen/chatscreen/View/chat_screen.dart';
import 'package:chitter_chatter/Features/chatScreen/contact_list/controller/contact_controller.dart';

/// Widget for displaying the contact list.
///
/// Fetches and displays contacts as a list of tiles, with options to delete contacts or navigate to a chat screen.
class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactController _controller = ContactController();

    return StreamBuilder(
      stream: _controller.getChatList(),
      builder: (context, snapshot) {
        // Show a loading indicator while the data is being fetched.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Display a message if no data is available.
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No chats available"));
        }

        // Build a list of contacts.
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                onTap: () {
                  // Navigate to the chat screen when a contact is tapped.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatView(userId: data['userId']),
                    ),
                  );
                },
                title: Text(
                  data['name'],
                  style: const TextStyle(fontSize: 18),
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: _controller.getProfileImage(data['profilePic']),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    // Confirm deletion when the delete icon is pressed.
                    _controller.confirmDelete(context, doc.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
