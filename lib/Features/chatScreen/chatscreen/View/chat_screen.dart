import 'dart:convert';
import 'package:chitter_chatter/Features/chatScreen/messageSearch/View/message_search_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chitter_chatter/Features/chatScreen/chatscreen/Controller/chat_controller.dart';
import 'package:chitter_chatter/Features/chatScreen/chatscreen/Model/chat_model.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

/// A stateful widget representing the chat view screen.
class ChatView extends StatefulWidget {
  /// The ID of the user that the current user is chatting with.
  final String userId;

  /// Constructor for the ChatView widget.
  ///
  /// [userId] is required and specifies the recipient's user ID.
  const ChatView({super.key, required this.userId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

/// The state class for the ChatView widget.
///
/// Manages chat-related functionalities such as message handling, emoji picker,
/// user status updates, and lifecycle event handling.
class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  /// The chat controller handling the chat logic and data interactions.
  late ChatController _chatController;

  /// The controller for the message input text field.
  final TextEditingController _messageController = TextEditingController();

  /// A boolean flag indicating if the emoji picker is visible.
  bool _isEmojiPickerVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize the chat controller with the current and recipient user IDs.
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _chatController = ChatController(
      currentUserId: currentUserId,
      recipientUserId: widget.userId,
    );

    // Add this widget as an observer to track app lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Update the user's chat status to "online" and initialize chat list entry.
    _chatController.updateUserChatStatus(true);
    _chatController.initializeChatListEntry();
  }

  @override
  void dispose() {
    // Update the user's chat status to "offline" and clean up resources.
    _chatController.updateUserChatStatus(false);
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes to update chat status accordingly.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _chatController.updateUserChatStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      _chatController.updateUserChatStatus(true);
    }
  }

  /// Toggles the visibility of the emoji picker.
  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiPickerVisible = !_isEmojiPickerVisible;
    });
  }

  /// Sends a text message entered by the user.
  ///
  /// Clears the text field after sending.
  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatController.sendMessage(message);
      _messageController.clear();
    }
  }

  /// Builds the app bar for the chat view, displaying user info and a search button.
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: appBarColor,
      leading: BackButton(
        color: Colors.grey,
        onPressed: () {
          _chatController.updateUserChatStatus(false);
          Navigator.pop(context);
        },
      ),
      title: StreamBuilder<DocumentSnapshot>(
        stream: _chatController.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("User not found");
          }

          final userData = UserStatus.fromFirestore(snapshot.data!);
          final bool isActiveInChat = userData.isOnline &&
              userData.currentChatWith == _chatController.currentUserId;

          return _buildUserInfo(userData, isActiveInChat);
        },
      ),
      elevation: 1,
    );
  }

  /// Builds the user information widget for the app bar.
  ///
  /// [userData] contains the user details.
  /// [isActiveInChat] indicates if the user is currently active in the chat.
  Widget _buildUserInfo(UserStatus userData, bool isActiveInChat) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: userData.profilePicture.isEmpty
              ? const NetworkImage(
            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
          )
              : MemoryImage(base64Decode(userData.profilePicture))
          as ImageProvider,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userData.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActiveInChat ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isActiveInChat
                        ? "online"
                        : userData.lastSeen != null
                        ? "last seen ${_chatController.formatLastSeen(userData.lastSeen!)}"
                        : "offline",
                    style: TextStyle(
                      fontSize: 14,
                      color: isActiveInChat ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MessageSearchScreen(currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
              ),
            );
          },
          icon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// Builds the message list widget displaying chat messages.
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatController.getChatStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .where((message) =>
        message.participants.contains(_chatController.currentUserId) &&
            message.participants.contains(widget.userId))
            .toList();

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  /// Builds a single message item (text or image) in the chat list.
  ///
  /// [message] is the chat message object.
  /// [isSender] indicates if the current user is the sender of the message.
  Widget _buildMessageItem(ChatMessage message) {
    final bool isSender = message.senderId == _chatController.currentUserId;

    if (message.message == 'photo' && message.base64Image != null) {
      return _buildImageMessage(message, isSender);
    }

    return _buildTextMessage(message, isSender);
  }

  /// Builds an image message item.
  ///
  /// [message] is the chat message containing the image.
  /// [isSender] indicates if the current user is the sender.
  Widget _buildImageMessage(ChatMessage message, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 8.0,
        ),
        child: Image.memory(
          base64Decode(message.base64Image!),
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Builds a text message item.
  ///
  /// [message] is the chat message containing text.
  /// [isSender] indicates if the current user is the sender.
  Widget _buildTextMessage(ChatMessage message, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 8.0,
        ),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSender ? Colors.green.shade600 : Colors.purple.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _chatController.formatMessageTime(message.timestamp),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the message input field with options for emoji picker and file attachment.
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: mobileChatBoxColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: mobileChatBoxColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _toggleEmojiPicker,
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: _chatController.sendPhoto,
                  icon: const Icon(
                    Icons.attach_file,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message here",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: tabColor,
                  ),
                ),
              ],
            ),
          ),
          if (_isEmojiPickerVisible)
            Container(
              color: Colors.white,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text += emoji.emoji;
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _chatController.updateUserChatStatus(false);
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar() as PreferredSizeWidget?,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/chatbg2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(child: _buildMessageList()),
                _buildMessageInput(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
