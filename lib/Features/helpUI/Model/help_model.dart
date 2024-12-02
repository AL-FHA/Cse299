/// Model class representing the structured content for the Help section of the app.
///
/// The [HelpContent] class encapsulates all the information required to
/// display the help page, including the title, description, key points,
/// and a footer message.
class HelpContent {
  /// The title of the Help page.
  ///
  /// Typically used as the main heading of the Help section.
  final String title;

  /// A description explaining the purpose of the Help page.
  ///
  /// Provides context about the help content and how it benefits users.
  final String description;

  /// A list of key points detailing the app's features or common tasks.
  ///
  /// Each item in the list represents a specific feature or usage guideline
  /// for the app.
  final List<String> points;

  /// A footer message displayed at the bottom of the Help page.
  ///
  /// Often used to thank the user or provide additional encouragement.
  final String footer;

  /// Creates a [HelpContent] instance with the provided title, description, points, and footer.
  ///
  /// - [title]: The main heading of the Help page.
  /// - [description]: A brief explanation of the Help page's purpose.
  /// - [points]: A list of strings representing the app's features or instructions.
  /// - [footer]: A closing message for the Help page.
  HelpContent({
    required this.title,
    required this.description,
    required this.points,
    required this.footer,
  });
}
