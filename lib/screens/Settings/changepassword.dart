import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/widget/Textfieldpassword.dart'; // Assuming your CustomTextField is here

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // Each TextField should have its own controller
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Error message variables for validation
  String? _passwordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  // Basic validation methods
  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  String? _validateNewPassword(String value) {
    if (value.isEmpty) {
      return 'New password cannot be empty';
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Background Image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/background.png'), // Replace with your image path
              fit: BoxFit.cover, // Ensure the image covers the entire page
            ),
          ),
        ),
        // Content with Transparent AppBar
        Column(
          children: [
            BackArrow(
              title: 'Change password',
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Add the logo at the top (optional)
                    Image.asset(
                      'assets/images/logo.png', // Replace with your logo path
                      height: 165, // Adjust height as necessary
                    ),
                    const SizedBox(height: 20), // Space between logo and form

                    // Password fields with separate controllers
                    CustomTextField(
                      label: 'Enter your current password',
                      controller: _passwordController,
                      validator: _validatePassword,
                      errorText: _passwordError,
                      obscureText: true, // Mask password input
                      onChanged: () {
                        setState(() {
                          _passwordError = null; // Clear error on input change
                        });
                      },
                    ),
                    CustomTextField(
                      label: 'Enter your new password',
                      controller: _newPasswordController,
                      validator: _validateNewPassword,
                      errorText: _newPasswordError,
                      obscureText: true, // Mask password input
                      onChanged: () {
                        setState(() {
                          _newPasswordError =
                              null; // Clear error on input change
                        });
                      },
                    ),
                    CustomTextField(
                      label: 'Confirm your new password',
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                      errorText: _confirmPasswordError,
                      obscureText: true, // Mask password input
                      onChanged: () {
                        setState(() {
                          _confirmPasswordError =
                              null; // Clear error on input change
                        });
                      },
                    ),
                    const SizedBox(
                        height: 20), // Space between fields and button
                    const SizedBox(
                        height: 20), // Space between fields and button

                    // Forgot Password Link (Underlined and Bold)
                    Positioned(
                      bottom: 30, // Distance from the bottom
                      right: 20, // Distance from the right
                      child: TextButton(
                        onPressed: () {
                          // Navigate to Forgot Password page
                          Navigator.pushNamed(context, '/ForgotPassword');
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: AppColors.darkGreen, // Adjust text color
                          ),
                        ),
                      ),
                    ),
                    // Reset Password Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Perform validation for each field
                          _passwordError =
                              _validatePassword(_passwordController.text);
                          _newPasswordError =
                              _validateNewPassword(_newPasswordController.text);
                          _confirmPasswordError = _validateConfirmPassword(
                              _confirmPasswordController.text);
                        });

                        // If no errors, proceed with password change logic
                        if (_passwordError == null &&
                            _newPasswordError == null &&
                            _confirmPasswordError == null) {
                          // Add your password reset logic here
                        }
                      },
                      style: button, // Apply the button style here
                      child: const Text(
                        'Reset password',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
