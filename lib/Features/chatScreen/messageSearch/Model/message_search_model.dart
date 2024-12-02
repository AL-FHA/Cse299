import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a chat message in the application.
///
/// Each [MessageModel] contains:
/// - The message content ([message]).
/// - The timestamp when the message was sent ([timestamp]).
/// - The list of participants in the chat ([participants]).
class MessageModel {
  /// The content of the message.
  final String message;

  /// The timestamp indicating when the message was sent.
  final Timestamp timestamp;

  /// The list of participants involved in the chat.
  final List<String> participants;

  /// Creates a new [MessageModel] instance.
  ///
  /// - [message]: The content of the message.
  /// - [timestamp]: The time the message was sent.
  /// - [participants]: The users involved in the chat.
  MessageModel({
    required this.message,
    required this.timestamp,
    required this.participants,
  });

  /// Factory constructor to create a [MessageModel] from a Firestore document.
  ///
  /// - [doc]: A [DocumentSnapshot] containing the Firestore data.
  ///
  /// This constructor maps Firestore fields (`message`, `timestamp`,
  /// and `participants`) to the [MessageModel] properties.
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    return MessageModel(
      message: doc['message'] ?? '',
      timestamp: doc['timestamp'] as Timestamp,
      participants: List<String>.from(doc['participants'] ?? []),
    );
  }
}

/// A service class for handling chat-related operations in Firestore.
///
/// The [MessageService] provides methods for interacting with Firestore
/// to fetch and search messages.
class MessageService {
  /// The Firestore instance for database operations.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Searches messages in Firestore that match a given query for a user.
  ///
  /// - [currentUserId]: The ID of the current user performing the search.
  /// - [query]: The search query to filter messages.
  ///
  /// This method:
  /// - Fetches all chat documents where the user is a participant.
  /// - Filters the fetched messages to include only those whose content
  ///   contains the given [query].
  ///
  /// Returns a list of [MessageModel] objects matching the search criteria.
  ///
  /// Throws an exception if an error occurs during the Firestore query.
  Future<List<MessageModel>> searchMessages(
      String currentUserId, String query) async {
    try {
      // Query Firestore for chats where the user is a participant
      final snapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      // Map documents to MessageModel and filter by query
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .where((message) =>
              message.message.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      // Throw an exception if an error occurs
      throw Exception("Error searching messages: $e");
    }
  }
}
