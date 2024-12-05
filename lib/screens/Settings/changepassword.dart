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
  
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _passwordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

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
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/background.png'), 
              fit: BoxFit.cover, 
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              BackArrow(
                title: 'Change password',
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png', 
                        height: 165, 
                      ),
                      const SizedBox(height: 20), 
                      CustomTextField(
                        label: 'Enter your current password',
                        controller: _passwordController,
                        validator: _validatePassword,
                        errorText: _passwordError,
                        obscureText: true,
                        onChanged: () {
                          setState(() {
                            _passwordError = null; 
                          });
                        },
                      ),
                      CustomTextField(
                        label: 'Enter your new password',
                        controller: _newPasswordController,
                        validator: _validateNewPassword,
                        errorText: _newPasswordError,
                        obscureText: true, 
                        onChanged: () {
                          setState(() {
                            _newPasswordError =
                                null; 
                          });
                        },
                      ),
                      CustomTextField(
                        label: 'Confirm your new password',
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword,
                        errorText: _confirmPasswordError,
                        obscureText: true, 
                        onChanged: () {
                          setState(() {
                            _confirmPasswordError =
                                null; // Clear error on input change
                          });
                        },
                      ),
                      
          
                      
                      Positioned( 
                        right: 20, 
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
                              color: AppColors.darkGreen, 
                            ),
                          ),
                        ),
                      ),
                      
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
                            
                          }
                        },
                        style: button, 
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
        ),
      ]),
    );
  }
}
