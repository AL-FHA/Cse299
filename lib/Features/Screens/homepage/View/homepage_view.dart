// homepage_view.dart
import 'dart:convert';
import 'package:chitter_chatter/Features/Screens/searchUsers/view/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:chitter_chatter/Features/chatScreen/contact_list/view/contact_list.dart';
import 'package:chitter_chatter/Features/helpUI/View/help_view.dart';
import 'package:chitter_chatter/Features/selectContacts/contactsPage/view/contactPage_view.dart';
import 'package:chitter_chatter/Features/status/view/status_view.dart';
import 'package:chitter_chatter/Features/userProfile/profile_screen/view/profile_screen.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import '../controller/homepage_controller.dart';
import '../model/user_model.dart';

class Homepage extends StatefulWidget {
  // The Homepage widget serves as the main screen of the application,
  // which displays the user interface for chats and statuses.
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  // The TabController is used to manage the TabBar and TabBarView for switching between "Chats" and "Status" tabs.
  late TabController _tabController;

  // Instance of HomepageController, which handles the business logic, such as fetching user data and sign-out functionality.
  final HomepageController _controller = HomepageController();

  // Stores the current user's data, such as profile picture and name.
  UserModel? userModel;

  // Indicates whether the user data is still loading. Initially set to true.
  bool _loading = true;

  @override
  void initState() {
    // Initializes the widget state and sets up the TabController.
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs: "Chats" and "Status".
    _fetchUserData(); // Fetches user data asynchronously on initialization.
  }

  Future<void> _fetchUserData() async {
    // Asynchronous function to fetch user data through the controller.
    final user = await _controller.fetchUserData(); // Fetches user data from backend or local storage.
    setState(() {
      userModel = user as UserModel?; // Cast and store the user data in userModel.
      _loading = false; // Stops showing the loading indicator after data is fetched.
    });
  }

  @override
  void dispose() {
    // Disposes of the TabController to free resources when the widget is removed from the widget tree.
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Builds the main UI for the homepage.
    return Scaffold(
      appBar: AppBar(
        // The AppBar displays the app title and a set of action buttons.
        title: const Text(
          "Chitter-Chatter", // The application name displayed at the top.
          style: TextStyle(
            color: Colors.grey, // Text color of the title.
            fontSize: 22, // Font size of the title.
            fontWeight: FontWeight.bold, // Font weight of the title.
          ),
        ),
        backgroundColor: appBarColor, // Background color of the AppBar.
        actions: [
          // Action button for navigating to the Help screen.
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Help()),
              );
            },
            icon: const Icon(Icons.help, color: Colors.grey), // Help icon with grey color.
          ),
          // Action button for navigating to the Search Users screen.
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchUsers()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.grey), // Search icon with grey color.
          ),
          // Action button for signing out the user.
          IconButton(
            onPressed: () => _controller.signOut(context), // Calls the signOut method in the controller.
            icon: const Icon(Icons.logout, color: Colors.grey), // Logout icon with grey color.
          ),
        ],
      ),
      body: Column(
        // The main body of the page, structured as a vertical column.
        children: [
          Container(
            // A container displaying the user's profile information or a loading indicator.
            padding: const EdgeInsets.all(10), // Padding inside the container.
            color: appBarColor, // Background color matches the AppBar.
            child: _loading
                ? const Center(child: CircularProgressIndicator()) // Shows a loading indicator while fetching data.
                : GestureDetector(
              // Allows the user to navigate to the ProfileScreen by tapping the profile section.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: Row(
                // Displays the user's profile picture and name in a horizontal layout.
                children: [
                  CircleAvatar(
                    // Circular avatar widget for displaying the user's profile picture.
                    radius: 30, // Size of the circle.
                    backgroundColor: Colors.grey[300], // Background color for the avatar.
                    backgroundImage: userModel?.profilePictureBase64 != null
                    // Displays the user's profile picture if available; otherwise, a default image.
                        ? MemoryImage(base64Decode(userModel!.profilePictureBase64!))
                        : const AssetImage('assets/images/default_profile_pic.png')
                    as ImageProvider,
                  ),
                  const SizedBox(width: 15), // Spacing between the avatar and text.
                  Text(
                    userModel?.name ?? "User Name", // Displays the user's name or a placeholder.
                    style: const TextStyle(
                      fontSize: 18, // Font size of the text.
                      fontWeight: FontWeight.bold, // Font weight of the text.
                    ),
                  ),
                ],
              ),
            ),
          ),
          PreferredSize(
            // A widget that enforces a specific height for the TabBar.
            preferredSize: const Size.fromHeight(60), // Height of the TabBar.
            child: TabBar(
              // TabBar widget for switching between "Chats" and "Status" tabs.
              controller: _tabController, // Controller for managing tab switching.
              indicatorColor: Colors.green, // Color of the tab indicator.
              labelColor: Colors.green, // Color of the selected tab's label.
              unselectedLabelColor: Colors.grey, // Color of the unselected tab's label.
              tabs: const [
                Tab(child: Text("Chats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                Tab(child: Text("Status", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            // Expanded widget allows the TabBarView to take up the remaining vertical space.
            child: TabBarView(
              // TabBarView widget for displaying content corresponding to the selected tab.
              controller: _tabController, // Controller for managing the TabBarView.
              children: const [
                Center(child: ContactList()), // Displays the list of contacts in the "Chats" tab.
                Center(child: StatusTab()), // Displays the status updates in the "Status" tab.
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Floating action button for navigating to the ContactsPage.
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactsPage()),
          );
        },
        backgroundColor: tabColor, // Background color of the floating action button.
        child: const Icon(Icons.comment), // Icon for the floating action button.
      ),
    );
  }
}
