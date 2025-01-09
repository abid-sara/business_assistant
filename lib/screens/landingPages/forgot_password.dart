import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/cubits/Authentification/auth_cubit.dart';
import '../../style/colors.dart';
import '../../widget/form.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static const String pageRoute = '/ForgotPassword';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: BackArrow(
          title: "",
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
                        'assets/images/logo.png',
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
                        Center(
                  child: ElevatedButton(
                          style: button,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().resetPassword(
                                _emailController.text,
                              ).then((_) {
                                Navigator.pushReplacementNamed(context, '/check-email', arguments: _emailController.text);
                              });
                            }
                          },
                          child: const Text(
                            'Reset password',
                            style: TextStyle(fontSize: 19, color: Colors.white),
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