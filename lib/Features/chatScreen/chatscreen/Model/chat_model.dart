import 'package:cloud_firestore/cloud_firestore.dart';

/// A model representing a chat message in the application.
class ChatMessage {
  /// The ID of the sender of the message.
  final String senderId;

  /// The ID of the receiver of the message.
  final String receiverId;

  /// The message content as a string.
  final String message;

  /// The timestamp of when the message was sent.
  final Timestamp timestamp;

  /// The base64-encoded image content, if the message contains a photo.
  final String? base64Image;

  /// The list of participants in the chat, typically the sender and receiver IDs.
  final List<dynamic> participants;

  /// Constructor for initializing a `ChatMessage` object.
  ///
  /// [senderId] is the ID of the user sending the message.
  /// [receiverId] is the ID of the user receiving the message.
  /// [message] is the text content of the message.
  /// [timestamp] is the time the message was sent.
  /// [base64Image] is the optional base64-encoded image content for photo messages.
  /// [participants] is the list of participants in the chat.
  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.base64Image,
    required this.participants,
  });

  /// Factory constructor for creating a `ChatMessage` object from a Firestore document.
  ///
  /// [doc] is the Firestore document representing the chat message.
  /// Returns a new `ChatMessage` instance populated with data from Firestore.
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      message: data['message'],
      timestamp: data['timestamp'],
      base64Image: data['base64Image'],
      participants: data['participants'],
    );
  }

  /// Converts the `ChatMessage` object into a map suitable for Firestore storage.
  ///
  /// Returns a map containing all the fields of the `ChatMessage`.
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'base64Image': base64Image,
      'participants': participants,
    };
  }
}

/// A model representing the status of a user in the application.
class UserStatus {
  /// Indicates whether the user is currently online.
  final bool isOnline;

  /// The last seen timestamp of the user, or `null` if not available.
  final Timestamp? lastSeen;

  /// The ID of the user the current user is actively chatting with, or `null` if not in a chat.
  final String? currentChatWith;

  /// The name of the user.
  final String name;

  /// The profile picture URL or data of the user.
  final String profilePicture;

  /// Constructor for initializing a `UserStatus` object.
  ///
  /// [isOnline] indicates whether the user is online.
  /// [lastSeen] is the last seen timestamp of the user, or `null` if unavailable.
  /// [currentChatWith] is the ID of the user the current user is chatting with, or `null`.
  /// [name] is the name of the user.
  /// [profilePicture] is the URL or data of the user's profile picture.
  UserStatus({
    required this.isOnline,
    this.lastSeen,
    this.currentChatWith,
    required this.name,
    required this.profilePicture,
  });

  /// Factory constructor for creating a `UserStatus` object from a Firestore document.
  ///
  /// [doc] is the Firestore document representing the user status.
  /// Returns a new `UserStatus` instance populated with data from Firestore.
  factory UserStatus.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserStatus(
      isOnline: data['isOnline'] ?? false,
      lastSeen: data['lastSeen'],
      currentChatWith: data['currentChatWith'],
      name: data['name'] ?? 'Unknown',
      profilePicture: data['profilePicture'] ?? '',
    );
  }
}
