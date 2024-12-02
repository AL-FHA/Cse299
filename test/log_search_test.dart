import 'dart:typed_data';
import 'package:chitter_chatter/Features/selectContacts/search_contacts/model/contact_search_model.dart';
import 'package:flutter_test/flutter_test.dart';


/// Mock class for `Contact` to simulate real contacts.
class MockContact {
  final String displayName;
  final List<MockPhone> phones;

  MockContact({
    required this.displayName,
    required this.phones,
  });
}

/// Mock class for `Phone` to simulate phone numbers in a contact.
class MockPhone {
  final String number;

  MockPhone(this.number);
}

void main() {
  group('ContactModel Tests', () {
    test('Creates ContactModel from MockContact', () {
      final mockContact = MockContact(
        displayName: 'John Doe',
        phones: [MockPhone('123-456-7890')],
      );

      final contactModel = ContactModel(
        displayName: mockContact.displayName,
        phoneNumber: mockContact.phones.first.number,
      );

      expect(contactModel.displayName, 'John Doe');
      expect(contactModel.phoneNumber, '123-456-7890');
    });

    test('Handles MockContact with no phone numbers', () {
      final mockContact = MockContact(
        displayName: 'Jane Doe',
        phones: [],
      );

      final contactModel = ContactModel(
        displayName: mockContact.displayName,
        phoneNumber: 'No number',
      );

      expect(contactModel.displayName, 'Jane Doe');
      expect(contactModel.phoneNumber, 'No number');
    });

    test('Searches for contacts by name', () {
      final mockContacts = [
        MockContact(displayName: 'Alice', phones: [MockPhone('111-111-1111')]),
        MockContact(displayName: 'Bob', phones: [MockPhone('222-222-2222')]),
        MockContact(displayName: 'Charlie', phones: [MockPhone('333-333-3333')]),
      ];

      final contactModels = mockContacts
          .map((c) => ContactModel(
        displayName: c.displayName,
        phoneNumber: c.phones.isNotEmpty ? c.phones.first.number : 'No number',
      ))
          .toList();

      final searchQuery = 'Bob';
      final filteredContacts = contactModels
          .where((contact) => contact.displayName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      expect(filteredContacts.length, 1);
      expect(filteredContacts.first.displayName, 'Bob');
      expect(filteredContacts.first.phoneNumber, '222-222-2222');
    });

    test('Searches for contacts by phone number', () {
      final mockContacts = [
        MockContact(displayName: 'Alice', phones: [MockPhone('111-111-1111')]),
        MockContact(displayName: 'Bob', phones: [MockPhone('222-222-2222')]),
        MockContact(displayName: 'Charlie', phones: [MockPhone('333-333-3333')]),
      ];

      final contactModels = mockContacts
          .map((c) => ContactModel(
        displayName: c.displayName,
        phoneNumber: c.phones.isNotEmpty ? c.phones.first.number : 'No number',
      ))
          .toList();

      final searchQuery = '333';
      final filteredContacts = contactModels
          .where((contact) => contact.phoneNumber.contains(searchQuery))
          .toList();

      expect(filteredContacts.length, 1);
      expect(filteredContacts.first.displayName, 'Charlie');
      expect(filteredContacts.first.phoneNumber, '333-333-3333');
    });
  });
}
