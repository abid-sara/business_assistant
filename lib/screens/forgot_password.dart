import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/form.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static const String pageRoute = '/forgot_password';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 0, 0),
            decoration: const BoxDecoration(
              color: AppColors.yellowGreen, 
              shape: BoxShape.circle, 
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined, 
                color: AppColors.darkGreen,
              ),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          // Transparent background
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png', // Add your logo here
                        height: 110,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Forgot password',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Please enter your email to rest the password',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 45),
                Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        structure(
                          "Email",
                          "Enter your email",
                          _emailController,
                          validateEmail,
                        ),

                        const SizedBox(height: 20),

                        // Sign In Button
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(312, 48),
                              backgroundColor:
                                  const Color(0xFF16423C), // Dark green
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            onPressed: () {
                              //ççççççççççççççççççççççç change
                              if (formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  //do this
                                  const SnackBar(
                                    content: Text('Great!'),
                                  ), // SnackBar
                                );
                              }
                            },
                            child: const Text(
                              'Reset password',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
