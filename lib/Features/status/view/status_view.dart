import 'dart:convert';

import 'package:chitter_chatter/Features/status/controller/status_controller.dart';
import 'package:chitter_chatter/Features/status/model/status_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// View representing the status tab where users can view and create statuses.
class StatusTab extends StatefulWidget {
  const StatusTab({super.key});

  @override
  _StatusTabState createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  bool _loading = true;
  bool _isCreatingStatus = false;
  final TextEditingController _statusController = TextEditingController();
  List<StatusModel> recentStatus = [];

  /// Fetches statuses when the widget is first initialized.
  ///
  /// Calls the [StatusController.fetchStatuses] method to load statuses.
  /// Updates the state of the widget to display the fetched statuses.
  @override
  void initState() {
    super.initState();
    _fetchStatuses();
  }

  /// Fetches the recent statuses from the [StatusController].
  Future<void> _fetchStatuses() async {
    setState(() {
      _loading = true;
    });

    try {
      final statuses = await StatusController.fetchStatuses();
      setState(() {
        recentStatus = statuses;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error: $e");
    }
  }

  /// Creates a new status using the [StatusController].
  Future<void> _createStatus() async {
    if (_statusController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status cannot be empty')),
      );
      return;
    }

    try {
      await StatusController.createStatus(_statusController.text);
      setState(() {
        _isCreatingStatus = false;
        _statusController.clear();
      });
      await _fetchStatuses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create status: $e')),
      );
    }
  }

  /// Formats the date of a status for display.
  ///
  /// Takes a [DateTime] object and returns a formatted string
  /// (e.g., 'Nov 30, 2024 3:45 PM').
  ///
  /// [date] is the [DateTime] object to format.
  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  Widget _buildProfileAvatar(String? profilePicture) {
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      child: profilePicture != null
          ? Image.memory(base64Decode(profilePicture))
          : const Icon(Icons.person, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Status Creation Section
              if (_isCreatingStatus)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _statusController,
                        decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 3,
                        maxLength: 250,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _createStatus,
                            child: const Text('Share'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Status List Section
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : recentStatus.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentStatus.length,
                          itemBuilder: (context, index) {
                            final status = recentStatus[index];
                            return ListTile(
                              leading:
                                  _buildProfileAvatar(status.profilePicture),
                              title: Text(status.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(status.status),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Posted on: ${_formatDate(status.date)}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("No status available"),
                        ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isCreatingStatus = !_isCreatingStatus;
          });
        },
        child: Icon(_isCreatingStatus ? Icons.close : Icons.add),
      ),
    );
  }
}
