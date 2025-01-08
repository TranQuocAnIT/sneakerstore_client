import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

class ProfilePage extends StatelessWidget {
  final LoginController controller = Get.find();
  final TextEditingController imageUrlController = TextEditingController();

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<LoginController>(
            builder: (controller) {
              final user = controller.LoginUser;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture section
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              user?.profilePicture ?? 'default_image_url',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              color: Colors.white,
                              onPressed: _showAvatarSelection,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Information section
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: user?.name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => user?.name = value,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: user?.phonenumber.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) => user?.phonenumber = int.tryParse(value),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: user?.password,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            onChanged: (value) => user?.password = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: ()
                          => controller.updateUserProfile(user), // Gọi hàm đăng nhập với mật khẩu
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAvatarSelection() {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Avatar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Custom URL input field
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (imageUrlController.text.isNotEmpty) {
                        controller.updateProfilePicture(imageUrlController.text);
                        Get.back();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Or choose from available avatars'),
              const SizedBox(height: 8),
              // Grid view of predefined avatars
              SizedBox(
                height: 200,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: avatarUrls.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      controller.updateProfilePicture(avatarUrls[index]);
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Image.network(
                        avatarUrls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // List of predefined avatar URLs
  final List<String> avatarUrls = [
    'https://cdn-icons-png.flaticon.com/128/16683/16683451.png',
    'https://cdn-icons-png.flaticon.com/128/16683/16683455.png',
    'https://cdn-icons-png.flaticon.com/128/16683/16683463.png',
    'https://cdn-icons-png.flaticon.com/128/16683/16683461.png',
    'https://cdn-icons-png.flaticon.com/128/16683/16683457.png',
    'https://cdn-icons-png.flaticon.com/128/16683/16683465.png',
    // Add more avatar URLs as needed
  ];
}