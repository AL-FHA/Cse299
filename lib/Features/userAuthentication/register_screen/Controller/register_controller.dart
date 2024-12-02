import 'package:chitter_chatter/Features/userAuthentication/register_Screen/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A controller class for handling user registration logic.
///
/// This class acts as the intermediary between the view and the model,
/// managing business logic and communication with Firebase.
class RegisterController {
  final UserRepository _userRepository = UserRepository();

  /// Registers a new user with the given details.
  ///
  /// [email] is the user's email address.
  /// [password] is the user's password.
  /// [reEnterPassword] is the confirmation password to match the initial password.
  /// [phoneNumber] is the user's phone number.
  ///
  /// Returns `null` if registration is successful, or an error message if
  /// registration fails.
  Future<String?> registerUser({
    required String email,
    required String password,
    required String reEnterPassword,
    required String? phoneNumber,
  }) async {
    if (password != reEnterPassword) {
      return "Password did not match.";
    }

    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "Please enter a valid phone number.";
    }

    final phoneNumberExists =
    await _userRepository.isPhoneNumberAlreadyInUse(phoneNumber);
    if (phoneNumberExists) {
      return "Phone number is already in use!";
    }

    try {
      final user = UserModel(email: email, phoneNumber: phoneNumber);
      await _userRepository.createUser(user, password);
      return null; // Success, no error message
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  /// Handles Firebase authentication errors and maps them to user-friendly messages.
  ///
  /// This method processes a [FirebaseAuthException] to determine the error type
  /// and provides a corresponding user-friendly message to display in the UI.
  ///
  /// ### Supported Error Codes:
  /// - `'email-already-in-use'`: Indicates the email address is already registered.
  /// - `'invalid-email'`: Indicates the provided email is not in a valid format.
  /// - Any other error defaults to a message guiding the user to create a strong password.
  ///
  /// #### Parameters:
  /// - [e]: The [FirebaseAuthException] to handle, containing error codes and messages.
  ///
  /// #### Returns:
  /// A user-friendly error message as a [String] that can be displayed to the user.
  String _handleFirebaseError(FirebaseAuthException e) {
    if (e.code == 'email-already-in-use') {
      // The email address is already associated with an existing account.
      return "Email already in use. Try another.";
    } else if (e.code == 'invalid-email') {
      // The email address entered is not in the proper format.
      return "Please enter a valid email address.";
    } else {
      // Default case, assumes issues with password strength.
      return "Password must contain an uppercase letter, lowercase letter, numeric, and special character.";
    }
  }
}