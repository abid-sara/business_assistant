import 'dart:io';
import 'package:business_assistant/widget/settingoption.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:business_assistant/constants/routes.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File? _profileImage; // To store the selected image
  bool _isEditing = false; // Track editing state
  final TextEditingController _businessNameController =
      TextEditingController(text: 'Cosmetics business owner');

  bool _isNotificationsEnabled = false; // State to control notification toggle

  void _handleNotificationToggle(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  // Image picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path); // Store the selected image
      });
    }
  }

  String userName = "Sara";
  String userSurname = "Abid";
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'), // Replace with your path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main Content
           SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          // Profile Section
                          SingleChildScrollView(
                           // scrollDirection: Axis.horizontal,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              height: 130,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(195, 169, 169, 199),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey, width: 1), // Adding border around the container
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: _profileImage != null
                                          ? FileImage(_profileImage!)
                                          : const NetworkImage(
                                                  'https://via.placeholder.com/150')
                                              as ImageProvider,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' $userName $userSurname',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (_isEditing)
                                              Expanded(
                                                child: TextField(
                                                  controller: _businessNameController,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(255, 112, 112, 112),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                                                  ),
                                                  
                                                ),
                                                
                                              )
                                            else
                                    
                                              Expanded(
                                                child: Text(
                                                  _businessNameController.text,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(255, 112, 112, 112),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isEditing = !_isEditing;
                                                });
                                              },
                                              icon: Icon(
                                                _isEditing ? Icons.check : Icons.edit,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Settings Sections
                          _buildSettingsSection([
                            SettingsOption(
                              title: 'Edit Profile',
                              icon: Icons.edit,
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/editprofil',
                                  arguments: {
                                    'initialName': 'John',
                                    'initialSurname': 'Doe',
                                  },
                                );

                                if (result != null &&
                                    result is Map<String, String>) {
                                  setState(() {
                                    userName = result['name'] ?? userName;
                                    userSurname =
                                        result['surname'] ?? userSurname;
                                  });
                                }
                              },
                            ),
                            SettingsOption(
                              title: 'Change Password',
                              icon: Icons.lock,
                              onTap: () => Navigator.pushNamed(
                                  context, '/changepassword'),
                            ),
                            SettingsOption(
                              title: 'Notifications',
                              icon: Icons.notifications,
                              isNotificationOption:
                                  true, // Show switch for notifications
                              isNotificationEnabled:
                                  _isNotificationsEnabled, // Bind state
                              onNotificationToggle:
                                  _handleNotificationToggle, // Handle toggle change
                              onTap: () {
                                // Handle tap for Notifications if needed
                              },
                            ),
                          ]),
                          const SizedBox(height: 16),
                          _buildSettingsSection([
                            SettingsOption(
                              title: 'Theme',
                              icon: Icons.color_lens,
                              onTap: () {},
                            ),
                            SettingsOption(
                              title: 'My Subscription',
                              icon: Icons.subscriptions,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/subscription'),
                            ),
                            SettingsOption(
                              title: 'Help & Support',
                              icon: Icons.help,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/help&support'),
                            ),
                          ]),
                          const SizedBox(height: 16),
                          _buildSettingsSection([
                            SettingsOption(
                              title: 'Rate Us',
                              icon: Icons.star,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/feedback'),
                            ),
                            SettingsOption(
                              title: 'Report a Problem',
                              icon: Icons.report_problem,
                              onTap: () => Navigator.pushNamed(
                                  context, '/reportproblem'),
                            ),
                            SettingsOption(
                              title: 'Add Account',
                              icon: Icons.account_circle,
                              onTap: () {
                                Navigator.pushNamed(context, '/CreateAccount');
                              },
                            ),
                            SettingsOption(
                              title: 'Log Out',
                              icon: Icons.logout,
                              onTap: () {
                                Navigator.pushNamed(context, '/signIn');
                              },
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a settings section
  Widget _buildSettingsSection(List<SettingsOption> options) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(157, 106, 156, 137),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ...options.map(
            (option) => Column(
              children: [
                option,
                if (option != options.last)
                  const Divider(
                    color: Color.fromARGB(255, 69, 67, 67),
                    thickness: 2,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
