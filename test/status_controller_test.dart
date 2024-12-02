import 'package:chitter_chatter/Features/status/controller/status_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_search_test.dart';
import 'status_controller_test.mocks.dart';


// Ensure these are concrete classes, not mocks, that you want to generate mocks for
@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  // Mock data to be returned from Firestore
  final Map<String, dynamic> mockStoryData = {
    'status': 'fly me to the moon',
    'date': Timestamp.fromDate(DateTime.now())
  };

  setUp(() {
    // Initialize mocks
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocRef = MockDocumentReference<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    // Mock Firestore collection and document reference
    when(mockFirestore.collection('users')).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocRef);

    // Mock the subcollection 'stories'
    final mockStoriesCollection =
        MockCollectionReference<Map<String, dynamic>>();
    when(mockDocRef.collection('stories')).thenReturn(mockStoriesCollection);
    when(mockStoriesCollection.doc(any)).thenReturn(mockDocRef);

    // Mock the document get method to return a mocked snapshot
    when(mockDocRef.get()).thenAnswer((_) async => mockDocumentSnapshot);

    // Mock the snapshot data
    when(mockDocumentSnapshot.data()).thenReturn(mockStoryData);
  });

  test('fetches user story from Firestore', () async {
    // Simulate fetching the user story from Firestore
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await mockFirestore
        .collection('users')
        .doc('userId')
        .collection('stories')
        .doc('storyId')
        .get();

    // Extract story data
    Map<String, dynamic> storyData = docSnapshot.data()!;

    // Verify the data fetched from Firestore
    expect(storyData['status'], 'fly me to the moon');
    expect(storyData['date'] is Timestamp, true);
  });
}
