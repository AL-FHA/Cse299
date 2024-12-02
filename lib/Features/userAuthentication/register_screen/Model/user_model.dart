import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A model class representing the user data.
class UserModel {
  /// The user's email address.
  final String email;

  /// The user's phone number.
  final String phoneNumber;

  /// Constructor to create a [UserModel] instance.
  ///
  /// [email] is the user's email address.
  /// [phoneNumber] is the user's phone number.
  UserModel({required this.email, required this.phoneNumber});

  /// Converts the [UserModel] instance to a map for Firestore storage.
  ///
  /// Returns a [Map<String, dynamic>] with the user's email and phone number.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}

/// A repository class for managing user-related operations in Firebase.
class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checks if a phone number is already in use.
  ///
  /// [phoneNumber] is the phone number to check.
  /// Returns `true` if the phone number exists in the Firestore `users` collection.
  Future<bool> isPhoneNumberAlreadyInUse(String phoneNumber) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  /// Creates a new user in Firebase with the given credentials.
  ///
  /// [user] is an instance of [UserModel] containing the user's details.
  /// [password] is the user's password.
  ///
  /// Throws [FirebaseAuthException] if there's an issue with user creation.
  Future<void> createUser(UserModel user, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: password);

    final userId = userCredential.user?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).set(user.toMap());
    }
  }
}
