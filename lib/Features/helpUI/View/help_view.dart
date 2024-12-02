import 'package:chitter_chatter/Features/helpUI/Controller/help_controller.dart';
import 'package:chitter_chatter/Features/helpUI/Model/help_model.dart';
import 'package:flutter/material.dart';


/// A StatelessWidget that represents the Help page in the app.
///
/// The [Help] widget displays detailed information about how to use the app,
/// including a title, description, a list of key points, and a footer.
/// It retrieves this content from the [HelpController] and uses a [HelpContent]
/// model to structure the information.
class Help extends StatelessWidget {
  /// Creates an instance of the [Help] widget.
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of the HelpController to retrieve help content.
    final HelpController controller = HelpController();

    // Fetch the structured help content.
    final HelpContent content = controller.getHelpContent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the title of the help page.
            Text(
              content.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Display the description of the help page.
            Text(
              content.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16),

            // Display the list of key points.
            ...content.points.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  point,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Display the footer of the help page.
            Text(
              content.footer,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
