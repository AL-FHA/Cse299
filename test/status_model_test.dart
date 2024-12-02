import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chitter_chatter/Features/status/model/status_model.dart';

void main() {
  group('StatusModel', () {
    test('fromMap creates a valid StatusModel instance', () {

      final mockData = {
        'name': 'Partha Chowdhury',
        'status': 'Hello World',
        'date': Timestamp.fromDate(DateTime(2024, 12, 1, 10, 30)),
        'profilePicture': 'base64EncodedProfilePicture',
      };

      final status = StatusModel.fromMap(mockData);

      expect(status.name, equals('Partha Chowdhury'));
      expect(status.status, equals('Hello World'));
      expect(status.date, equals(DateTime(2024, 12, 1, 10, 30)));
      expect(status.profilePicture, equals('base64EncodedProfilePicture'));
    });
  });
}
