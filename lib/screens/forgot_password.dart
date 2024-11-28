import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../widget/form.dart';
import '../widget/back_arrow.dart';

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
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Please enter your email to reset the password',
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
                                  AppColors.darkGreen, // Dark green
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
