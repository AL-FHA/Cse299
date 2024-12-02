import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:chitter_chatter/Features/Screens/searchUsers/controller/contact_controller.dart';
import 'package:chitter_chatter/Features/Screens/searchUsers/model/contact_model.dart';

@GenerateMocks([SearchUsersController])
import 'contact_search_test.mocks.dart';

void main() {
  late MockSearchUsersController mockController;
  final mockContacts = [
    ContactModel(name: 'Alice', userId: '1', profilePic: null),
    ContactModel(name: 'Bob', userId: '2', profilePic: null),
    ContactModel(name: 'Charlie', userId: '3', profilePic: null),
  ];

  setUp(() => mockController = MockSearchUsersController());

  group('Contact Searching', () {
    test('fetchContacts returns a list of contacts', () async {
      when(mockController.fetchContacts()).thenAnswer((_) async => mockContacts);
      final result = await mockController.fetchContacts();

      expect(result, isNotEmpty);
      expect(result.length, 3);
      expect(result[0].name, 'Alice');
    });

    test('filterContacts returns matching results based on query', () {
      when(mockController.filterContacts(mockContacts, 'Bo'))
          .thenReturn([mockContacts[1]]);
      final filteredContacts = mockController.filterContacts(mockContacts, 'Bo');

      expect(filteredContacts.length, 1);
      expect(filteredContacts[0].name, 'Bob');
    });

    test('filterContacts returns all results when query is empty', () {
      when(mockController.filterContacts(mockContacts, '')).thenReturn(mockContacts);
      final filteredContacts = mockController.filterContacts(mockContacts, '');

      expect(filteredContacts.length, mockContacts.length);
    });

    test('filterContacts returns no results for unmatched query', () {
      when(mockController.filterContacts(mockContacts, 'Zoe')).thenReturn([]);
      final filteredContacts = mockController.filterContacts(mockContacts, 'Zoe');

      expect(filteredContacts, isEmpty);
    });
  });
}