/// Mock representation of a Contact object.
class MockContact {
  /// The display name of the contact.
  final String displayName;

  /// List of phone numbers associated with the contact.
  final List<MockPhone> phones;

  /// Constructor to create a mock contact.
  MockContact({
    required this.displayName,
    required this.phones,
  });
}

/// Mock representation of a phone number associated with a contact.
class MockPhone {
  /// The phone number string.
  final String number;

  /// Constructor to create a mock phone number.
  MockPhone(this.number);
}

/// Example utility to generate mock contact data.
class MockContactData {
  /// Returns a list of mock contacts.
  static List<MockContact> getMockContacts() {
    return [
      MockContact(
        displayName: 'Alice',
        phones: [MockPhone('111-111-1111')],
      ),
      MockContact(
        displayName: 'Bob',
        phones: [MockPhone('222-222-2222')],
      ),
      MockContact(
        displayName: 'Charlie',
        phones: [MockPhone('333-333-3333')],
      ),
      MockContact(
        displayName: 'Dave',
        phones: [MockPhone('444-444-4444')],
      ),
    ];
  }
}
