import 'dart:io';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:business_assistant/widget/customtextfile.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';

class EditProfile extends StatefulWidget {
  final String initialName;
  final String initialSurname;
  final String? initialProfilePicture;

  const EditProfile({
    required this.initialName,
    required this.initialSurname,
    this.initialProfilePicture,
    super.key,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late File? _profilePicture;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _surnameController = TextEditingController(text: widget.initialSurname);
    _profilePicture = widget.initialProfilePicture != null
        ? File(widget.initialProfilePicture!)
        : null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    } else if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Name cannot contain numbers';
    }
    return null;
  }

  String? _validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Surname cannot be empty';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number cannot be empty';
    } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') // Improved regex
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedName = _nameController.text;
      final updatedSurname = _surnameController.text;

      Navigator.pop(context, {
        'name': updatedName,
        'surname': updatedSurname,
        'profilePicture': _profilePicture?.path,
      });
    }
  }

  Future<void> _pickProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery, 
    );

    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                BackArrow(title: 'Edit profile'),
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Padding directly around the form
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _pickProfilePicture,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: _profilePicture != null
                                      ? FileImage(_profilePicture!)
                                      : const AssetImage('assets/images/flower.png')
                                          as ImageProvider,
                                ),
                              ),
                              const SizedBox(height: 16),
                              buildTextField(
                                label: 'Name',
                                controller: _nameController,
                                validator: _validateName,
                              ),
                              buildTextField(
                                label: 'Surname',
                                controller: _surnameController,
                                validator: _validateSurname,
                              ),
                              buildTextField(
                                label: 'Mobile',
                                controller: _mobileController,
                                hint: '+213',
                                keyboardType: TextInputType.phone,
                                validator: _validateMobile,
                              ),
                              buildTextField(
                                label: 'E-mail',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _saveProfile,
                                style: button, 
                                child: const Text(
                                'Save',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
                    ],
                  ),
          ),
      ]
      )
    );
  }
}
