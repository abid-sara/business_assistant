import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../widget/form.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
  static const String pageRoute = '/signIn';
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        'Sign in to your account',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
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

                        const Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 19),
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            border: normalBorder,
                            focusedBorder: focused,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Forgot password logic
                              Navigator.pushNamed(context, '/ForgotPassword');
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Color(0xFF16423C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Sign In Button
                        Center(
                          child: ElevatedButton(
                            style: button,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pushNamed(context, '/dashboard');
                              }
                            },
                            child: const Text(
                              'Sign in',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ),
                // Email Address Field

                const SizedBox(height: 20),

                // Create Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to create account
                        Navigator.pushNamed(context, '/CreateAccount');
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
