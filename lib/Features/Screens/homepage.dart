import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:chitter_chatter/common_utils/widgets/contact_list.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chitter-Chatter",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController, // TabController
          indicatorColor: tabColor, // Green color for the indicator
          labelColor: tabColor, // Green color for selected tab
          unselectedLabelColor: Colors.grey, // Grey color for unselected tab
          tabs: const [
            Tab(text: "Chats"),
            Tab(text: "Status"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: ContactList()),
          Center(child: Text("Status Screen")),
        ],
      ),
    );
  }
}
