import 'package:business_assistant/screens/landingPages/check_email.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../widget/button.dart';
import '../../widget/form.dart';
import '../../widget/back_arrow.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static const String pageRoute = '/forgot_password';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const BackArrow(),
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
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Please enter your email to reset the password',
                        style: TextStyle(
                          fontSize: 17,
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
                            style: button,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CheckEmail(
                                      email: _emailController.text)));
                            },
                            child: const Text(
                              'Reset password',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
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
