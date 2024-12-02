

import 'package:chitter_chatter/Features/helpUI/Model/help_model.dart';

/// Controller class responsible for managing the help content.
///
/// The [HelpController] provides predefined help content to be displayed
/// in the Help section of the app. It encapsulates the logic for preparing
/// and returning structured help information.
class HelpController {
  /// Retrieves the help content for the Help section of the app.
  ///
  /// This method constructs and returns a [HelpContent] object containing:
  /// - A title for the help page ([title]).
  /// - A description explaining the purpose of the Help section ([description]).
  /// - A list of key points highlighting the app's features ([points]).
  /// - A footer message ([footer]).
  ///
  /// Returns:
  /// - A [HelpContent] object containing the structured help information.
  HelpContent getHelpContent() {
    return HelpContent(
      title: 'Welcome to the Help Page',
      description:
          'Here, you can find answers to common questions and understand how to use the app effectively.',
      points: [
        '1. An user can chat with other users by clicking "Chats" bar',
        '2. An user can add other users by adding them through "Contact" icon',
        '3. An user can create a group by clicking "Groups" bar and can add multiple users in a group through contact list',
        '4. An user can add status by clicking "Status" bar and can see other users\' status',
      ],
      footer: 'Thank you for using our app!',
    );
  }
}
