import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chitter_chatter/Features/userProfile/profile_screen/controller/profile_controller.dart';
import 'package:chitter_chatter/Features/userProfile/profile_screen/model/profile_model.dart';
import 'package:chitter_chatter/common_utils/widgets/colors.dart';
import 'package:chitter_chatter/common_utils/widgets/custom_button.dart';

/// A screen to display and edit the user's profile.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = ProfileController();
  ProfileModel? _profile;
  bool _loading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _profilePictureBase64;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Loads the user data when the screen is initialized.
  Future<void> _loadUserData() async {
    final profile = await _controller.fetchUserData();
    if (profile != null) {
      setState(() {
        _profile = profile;
        _nameController.text = profile.name ?? ''; // Default to an empty string if null
        _phoneController.text = profile.phoneNumber ?? ''; // Default to an empty string if null
        _profilePictureBase64 = profile.profilePictureBase64;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  /// Saves the changes to the user's profile.
  ///
  /// Updates the user's profile data in Firestore using the updated [ProfileModel].
  Future<void> _saveChanges() async {
    final updatedProfile = ProfileModel(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      profilePictureBase64: _profilePictureBase64,
    );

    try {
      await _controller.updateUserData(updatedProfile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile.")),
      );
    }
  }

  /// Allows the user to select a new profile picture from the gallery.
  Future<void> _selectProfilePicture() async {
    final base64Image = await _controller.pickImage();
    if (base64Image != null) {
      setState(() {
        _profilePictureBase64 = base64Image;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture selected!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: backgroundColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: _selectProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profilePictureBase64 != null
                      ? MemoryImage(base64Decode(_profilePictureBase64!))
                      : const AssetImage('assets/images/default_profile_pic.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              CustomButton(
                onPressed: _saveChanges,
                text: 'Save Changes',
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
