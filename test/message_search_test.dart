import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chitter_chatter/Features/chatScreen/messageSearch/Model/message_search_model.dart';
import 'package:chitter_chatter/Features/chatScreen/messageSearch/View/message_search_view.dart';
import 'package:chitter_chatter/Features/chatScreen/messageSearch/Controller/message_search_controller.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
  });

  group('MessageSearch Widget Tests', () {
    test('filterMessages returns matching results based on query', () {
      // Arrange: Prepare mock data
      final mockMessages = [
        {
          'message': 'Hello Bob',
          'timestamp': Timestamp.now(),
          'participants': ['user1', 'user2']
        },
        {
          'message': 'Hi Alice',
          'timestamp': Timestamp.now(),
          'participants': ['user1', 'user3']
        },
      ];

      final result = filterMessages(mockMessages, 'Bob');

      // Assert: Verify the filtered results
      expect(result.length, 1);
      expect(result[0]['message'], 'Hello Bob');
    });

    test('filterMessages returns all results when query is empty', () {
      // Arrange: Prepare mock data
      final mockMessages = [
        {
          'message': 'Hello Bob',
          'timestamp': Timestamp.now(),
          'participants': ['user1', 'user2']
        },
        {
          'message': 'Hi Alice',
          'timestamp': Timestamp.now(),
          'participants': ['user1', 'user3']
        },
      ];

      final result = filterMessages(mockMessages, '');

      // Assert: Verify that all messages are returned when query is empty
      expect(result.length, mockMessages.length);
    });

    test('filterMessages returns no results for unmatched query', () {
      // Arrange: Prepare mock data
      final mockMessages = [
        {
          'message': 'Hello Bob',
          'timestamp': Timestamp.now(),
          'participants': ['user1', 'user2']
        },
        {
          'message': 'Hi Alice',
          'timestamp': Timestamp.now(),
          'participants': ['user1', 'user3']
        },
      ];

      final result = filterMessages(mockMessages, 'Zoe');

      // Assert: Verify that no results are returned for unmatched query
      expect(result, isEmpty);
    });
  });
}

// A simple message filtering function
List<Map<String, dynamic>> filterMessages(
    List<Map<String, dynamic>> messages, String query) {
  if (query.isEmpty) {
    return messages;
  }

  return messages.where((message) {
    return message['message']
            ?.toString()
            .toLowerCase()
            .contains(query.toLowerCase()) ??
        false;
  }).toList();
}
