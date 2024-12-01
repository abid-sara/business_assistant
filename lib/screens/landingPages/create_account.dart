import 'package:business_assistant/screens/landingPages/sign_in.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../widget/form.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
  static const String pageRoute = '/create_account';
}

class _CreateAccountState extends State<CreateAccount> {
  bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckerController =
      TextEditingController();
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

                      // Welcome Text
                      const Text(
                        'Create new account',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Address Field
                      structure(
                        "Name",
                        "Enter your name",
                        _nameController,
                        validateName,
                      ),

                      // Email Address Field
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
                            color: AppColors.darkGreen),
                      ),
                      const SizedBox(height: 5),

                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
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

                      const SizedBox(height: 18),
                      const Text(
                        "Confirm password",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen),
                      ),
                      const SizedBox(height: 5),

                      TextFormField(
                        controller: _passwordCheckerController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password to confirm';
                          }
                          if (_passwordController.text !=
                              _passwordCheckerController.text) {
                            return "The password is not matching";
                          }
                          return null;
                        },
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: 'Enter your confirm password',
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

                      const SizedBox(height: 20),

                      // Sign In Button
                      Center(
                        child: ElevatedButton(
                          style: button,
                          onPressed: () {
                            // Sign in logic that will be changed after ______________
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
                            'Sign in',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // Create Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignIn.pageRoute);
                      },
                      child: const Text(
                        'Back to Sign In',
                        style: TextStyle(
                          color: Color(0xFF16423C),
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
