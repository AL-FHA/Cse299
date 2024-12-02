import 'package:flutter/material.dart';

import '../Model/message_search_model.dart';
import '../Controller/message_search_controller.dart';

/// A screen that allows users to search messages in their chats.
///
/// This screen implements the **Model-View-Controller (MVC)** pattern to
/// separate business logic, data handling, and UI rendering.
///
/// The [MessageSearchScreen] class is the **View**, which interacts with the
/// user and renders the UI.
/// It communicates with the [MessageSearchController] to handle the search logic
/// and displays results using the [MessageModel].
class MessageSearchScreen extends StatefulWidget {
  /// The ID of the current user performing the search.
  final String currentUserId;

  /// Creates a [MessageSearchScreen] widget.
  ///
  /// The [currentUserId] parameter is required to filter messages by user.
  const MessageSearchScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  State<MessageSearchScreen> createState() => _MessageSearchScreenState();
}

class _MessageSearchScreenState extends State<MessageSearchScreen> {
  /// Controller for the search input field.
  final TextEditingController _searchController = TextEditingController();

  /// The controller responsible for handling message search logic.
  final MessageSearchController _controller =
      MessageSearchController(MessageService());

  /// List of search results retrieved from the [MessageSearchController].
  List<MessageModel> _searchResults = [];

  /// Searches for messages containing the provided query.
  ///
  /// - [query]: The string to search for in the user's messages.
  ///
  /// Updates the [_searchResults] list with the matching messages
  /// and refreshes the UI.
  void _searchMessages(String query) async {
    try {
      final results =
          await _controller.searchMessages(widget.currentUserId, query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print("Error searching messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search messages',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _searchMessages,
        ),
        backgroundColor: Colors.purple,
      ),
      body: _searchResults.isEmpty
          ? const Center(
              child: Text(
                'No messages found',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final message = _searchResults[index];

                return ListTile(
                  title: Text(
                    message.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Sent at: ${DateTime.fromMillisecondsSinceEpoch(message.timestamp.millisecondsSinceEpoch)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    // Navigate to the message in chat screen or highlight it
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}
