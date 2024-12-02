import 'package:chitter_chatter/Features/status/model/status_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


/// Controller for managing status logic.
class StatusController {
  /// Fetches the most recent statuses for the current user and their chat list.
  ///
  /// Fetches the statuses from the current user's profile and each user in their chat list.
  /// The statuses are filtered to show only those created within the last 24 hours.
  ///
  /// Returns a list of [StatusModel] objects representing the fetched statuses.
  static Future<List<StatusModel>> fetchStatuses() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    try {
      final currentTime = DateTime.now();
      List<StatusModel> statuses = [];

      // Fetch current user status
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final currentUserName = currentUserDoc.data()?['name'] ?? 'Unknown User';
      final currentUserProfilePic =
          currentUserDoc.data()?['profilePicture'] ?? '';
      final userStories = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('stories')
          .orderBy('date', descending: true)
          .get();

      statuses.addAll(_extractRecentStatuses(
        userStories.docs,
        currentUserName,
        currentTime,
        currentUserProfilePic,
      ));

      // Fetch status of chatList users
      final chatList = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('chatList')
          .get();

      for (var chatDoc in chatList.docs) {
        final chatUserId = chatDoc.id;
        final chatUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(chatUserId)
            .get();

        if (chatUserDoc.exists) {
          final chatUserName = chatUserDoc.data()?['name'] ?? 'Unknown User';
          final chatUserProfilePic =
              chatUserDoc.data()?['profilePicture'] ?? '';
          final chatUserStories = await FirebaseFirestore.instance
              .collection('users')
              .doc(chatUserId)
              .collection('stories')
              .orderBy('date', descending: true)
              .get();

          statuses.addAll(_extractRecentStatuses(
            chatUserStories.docs,
            chatUserName,
            currentTime,
            chatUserProfilePic,
          ));
        }
      }

      return statuses;
    } catch (e) {
      print("Error fetching statuses: $e");
      return [];
    }
  }

  /// Helper function to extract recent statuses.
  ///
  /// This function filters the list of [docs] to include only the statuses
  /// posted within the last 24 hours. It also constructs a list of [StatusModel]
  /// instances from the data.
  ///
  /// Returns a list of [StatusModel] representing the recent statuses.
  static List<StatusModel> _extractRecentStatuses(
    List<QueryDocumentSnapshot> docs,
    String userName,
    DateTime currentTime,
    String profilePicture,
  ) {
    return docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = data['date'] as Timestamp?;
          final statusDate = timestamp?.toDate();

          if (statusDate != null &&
              currentTime.difference(statusDate).inHours < 24) {
            return StatusModel(
              name: userName,
              status: data['status'] ?? 'No Status',
              date: statusDate,
              profilePicture: profilePicture,
            );
          }
          return null;
        })
        .where((status) => status != null)
        .cast<StatusModel>()
        .toList();
  }

  /// Creates a new status for the current user.
  ///
  /// This method uploads a new status message to Firebase under the current user's
  /// `stories` collection. The status message is saved with the current timestamp.
  ///
  /// [statusText] is the content of the new status.
  static Future<void> createStatus(String statusText) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('stories')
          .add({
        'status': statusText.trim(),
        'date': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to create status: $e');
    }
  }
}
