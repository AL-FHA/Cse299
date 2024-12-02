import 'package:chitter_chatter/Features/chatScreen/chatscreen/Model/chat_model.dart';
import 'package:chitter_chatter/Features/Screens/homepage/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

// ************************* UNIT TEST CODE *************************
// flutter test test/user_status_test.dart

void main() {
  group('UserStatus Test Cases', () {
    test('Test Case 1: Success - Correctly shows user status', () {
      // Arrange
      const isOnline = true;
      const lastSeen = null; // Not providing a Timestamp
      const currentChatWith = 'JD#123';
      const name = 'John Doe';
      const profilePicture = 'https://example.com/image.jpg';

      // Act
      final userStatus = UserStatus(
        isOnline: isOnline,
        lastSeen: lastSeen,
        currentChatWith: currentChatWith,
        name: name,
        profilePicture: profilePicture,
      );

      // Assert
      expect(userStatus.isOnline, isOnline);
      expect(userStatus.lastSeen, lastSeen);
      expect(userStatus.currentChatWith, currentChatWith);
      expect(userStatus.name, name);
      expect(userStatus.profilePicture, profilePicture);
    });

    test('Test Case 2: Failure - User is online, but showing offline', () {
      // Arrange
      const isOnline = true;
      const lastSeen = null;
      const currentChatWith = 'JD#456';
      const name = 'Jane Doe';
      const profilePicture = 'https://example.com/jane.jpg';

      // Act
      final userStatus = UserStatus(
        isOnline: false,
        lastSeen: lastSeen,
        currentChatWith: currentChatWith,
        name: name,
        profilePicture: profilePicture,
      );

      // Assert
      expect(userStatus.isOnline, isOnline);
      expect(userStatus.lastSeen, lastSeen);
      expect(userStatus.currentChatWith, currentChatWith);
      expect(userStatus.name, name);
      expect(userStatus.profilePicture, profilePicture);
    });


  });
}
