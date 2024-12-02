import 'package:flutter/material.dart';
import '../Model/message_search_model.dart';

/// Controller class for handling message search functionality.
///
/// The [MessageSearchController] acts as the intermediary between the view and the model,
/// managing the logic required to search messages.
/// It interacts with the [MessageService] to retrieve data and process search results.
class MessageSearchController {
  /// The service responsible for interacting with Firestore to fetch messages.
  final MessageService _messageService;

  /// Creates a [MessageSearchController] instance.
  ///
  /// - [_messageService]: The [MessageService] used for data operations.
  MessageSearchController(this._messageService);

  /// Searches messages for a specific user based on a query.
  ///
  /// - [currentUserId]: The ID of the user performing the search.
  /// - [query]: The search query to filter messages.
  ///
  /// This method:
  /// - Returns an empty list if the [query] is empty or contains only whitespace.
  /// - Uses [_messageService] to fetch messages from Firestore where the user
  ///   is a participant, and filters them based on the [query].
  ///
  /// Returns a `Future` that resolves to a list of [MessageModel] objects
  /// matching the search criteria.
  ///
  /// Throws an exception if an error occurs during the search process.
  Future<List<MessageModel>> searchMessages(
      String currentUserId, String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return await _messageService.searchMessages(currentUserId, query);
    } catch (e) {
      throw Exception("Error searching messages: $e");
    }
  }
}
