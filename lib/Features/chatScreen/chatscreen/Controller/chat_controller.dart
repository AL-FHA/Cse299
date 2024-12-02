import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:chitter_chatter/Features/chatScreen/chatscreen/Model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

/// ChatController manages all chat-related functionalities between two users.
class ChatController {
  /// ID of the current user.
  final String currentUserId;

  /// ID of the recipient user.
  final String recipientUserId;

  /// Constructor for initializing the ChatController.
  ///
  /// [currentUserId] is the ID of the user who is currently logged in.
  /// [recipientUserId] is the ID of the user the current user is chatting with.
  ChatController({
    required this.currentUserId,
    required this.recipientUserId,
  });

  /// Updates the current user's chat status in Firestore.
  ///
  /// [isInChat] indicates whether the user is actively in a chat.
  /// If the user is in a chat, it also updates the `currentChatWith` field.
  Future<void> updateUserChatStatus(bool isInChat) async {
    if (currentUserId.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
        'isOnline': isInChat,
        'lastSeen': FieldValue.serverTimestamp(),
        'currentChatWith': isInChat ? recipientUserId : null,
      });
    } catch (e) {
      print("Error updating chat status: $e");
    }
  }

  /// Initializes chat list entries for both the current user and recipient.
  ///
  /// Ensures both users have an entry for each other in their `chatList` collections.
  Future<void> initializeChatListEntry() async {
    try {
      await _createOrUpdateChatListEntry(currentUserId, recipientUserId);
      await _createOrUpdateChatListEntry(recipientUserId, currentUserId);
    } catch (e) {
      print("Error initializing chat list entries: $e");
    }
  }

  /// Creates or updates a chat list entry for a given user.
  ///
  /// [userId] is the user whose `chatList` collection is being updated.
  /// [otherUserId] is the user to be added/updated in the chat list.
  Future<void> _createOrUpdateChatListEntry(String userId, String otherUserId) async {
    final chatListRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chatList')
        .where('userId', isEqualTo: otherUserId)
        .limit(1);

    final snapshot = await chatListRef.get();

    if (snapshot.docs.isEmpty) {
      final otherUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .get();

      final otherUserData = otherUserDoc.data();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('chatList')
          .add({
        'userId': otherUserId,
        'name': otherUserData?['name'] ?? 'Unknown',
        'profilePic': otherUserData?['profilePicture'] ?? '',
        'hasUnreadMessages': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else if (!snapshot.docs.first.data().containsKey('hasUnreadMessages')) {
      await snapshot.docs.first.reference.set({
        'hasUnreadMessages': false,
      }, SetOptions(merge: true));
    }
  }

  /// Updates the recipient's chat list with unread message status and timestamp.
  Future<void> updateRecipientChatList() async {
    try {
      final recipientChatListRef = FirebaseFirestore.instance
          .collection('users')
          .doc(recipientUserId)
          .collection('chatList')
          .where('userId', isEqualTo: currentUserId)
          .limit(1);

      final snapshot = await recipientChatListRef.get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({
          'hasUnreadMessages': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        await initializeChatListEntry();
        final newSnapshot = await recipientChatListRef.get();
        if (newSnapshot.docs.isNotEmpty) {
          await newSnapshot.docs.first.reference.update({
            'hasUnreadMessages': true,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print("Error updating recipient chat list: $e");
    }
  }

  /// Sends a text message from the current user to the recipient.
  ///
  /// [message] is the text message to be sent.
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final timestamp = Timestamp.now();

    try {
      final chatMessage = ChatMessage(
        senderId: currentUserId,
        receiverId: recipientUserId,
        message: message.trim(),
        timestamp: timestamp,
        participants: [currentUserId, recipientUserId],
      );

      await FirebaseFirestore.instance.collection('chats').add(chatMessage.toMap());
      await updateRecipientChatList();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  /// Sends a photo message from the current user to the recipient.
  ///
  /// The user is prompted to pick an image from their gallery.
  Future<void> sendPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final File file = File(image.path);
      final Uint8List imageBytes = await file.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final chatMessage = ChatMessage(
        senderId: currentUserId,
        receiverId: recipientUserId,
        message: 'photo',
        timestamp: Timestamp.now(),
        base64Image: base64Image,
        participants: [currentUserId, recipientUserId],
      );

      await FirebaseFirestore.instance.collection('chats').add(chatMessage.toMap());
      await updateRecipientChatList();
    } catch (e) {
      print("Error sending photo: $e");
    }
  }

  /// Streams updates for the recipient user's data in Firestore.
  ///
  /// Useful for observing the recipient's status, last seen, etc.
  Stream<DocumentSnapshot> getUserStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(recipientUserId)
        .snapshots();
  }

  /// Streams updates for chat messages between the current user and recipient.
  ///
  /// The messages are ordered by timestamp in descending order.
  Stream<QuerySnapshot> getChatStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Formats a `lastSeen` timestamp into a user-friendly string.
  String formatLastSeen(Timestamp lastSeen) {
    final now = DateTime.now();
    final lastSeenDate = lastSeen.toDate();
    final difference = now.difference(lastSeenDate);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastSeenDate.day}/${lastSeenDate.month}/${lastSeenDate.year}';
    }
  }

  /// Formats a `timestamp` into a time string (e.g., `08:45 PM`).
  String formatMessageTime(Timestamp timestamp) {
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }
}