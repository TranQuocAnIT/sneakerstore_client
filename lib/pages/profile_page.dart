import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

class ProfilePage extends StatelessWidget {
  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<LoginController>(
          builder: (controller) {
            final user = controller.LoginUser;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture section
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user?.profilePicture ?? 'default_image_url'),
                  ),
                ),
                TextButton(
                  onPressed: _showAvatarSelection,
                  child: Text('Change Avatar'),
                ),

                // User Information section
                TextField(
                  controller: TextEditingController(text: user?.name),
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => user?.name = value,
                ),
                TextField(
                  controller: TextEditingController(text: user?.phonenumber.toString()),
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) => user?.phonenumber = int.tryParse(value),
                ),
                TextField(
                  controller: TextEditingController(text: user?.password),
                  decoration: InputDecoration(labelText: 'Password'),
                  onChanged: (value) => user?.password = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.updateUserProfile(user),
                  child: Text('Update Profile'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Show available avatars for selection
  void _showAvatarSelection() {
    Get.dialog(
      SimpleDialog(
        title: Text('Select Avatar'),
        children: List.generate(
          avatarUrls.length,
              (index) => SimpleDialogOption(
            onPressed: () {
              controller.updateProfilePicture(avatarUrls[index]);
              Get.back();
            },
            child: Image.network(avatarUrls[index], width: 50, height: 50),
          ),
        ),
      ),
    );
  }

  // List of predefined avatar URLs
  final List<String> avatarUrls = [
    'https://example.com/avatar1.png',
    'https://example.com/avatar2.png',
    'https://example.com/avatar3.png',
  ];
}
