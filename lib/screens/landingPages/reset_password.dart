import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../widget/back_arrow.dart';
import '../../widget/form.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});
  static const String pageRoute = '/ResetPassword';
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

TextEditingController _password = TextEditingController();
TextEditingController _passwordCheck = TextEditingController();
bool _isObscure = true;

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        appBar: BackArrow(
          title: "",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Set a new password',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 19),
                const Text(
                  "Create a new password. Ensure it differs from previous ones for security",
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                const SizedBox(height: 52),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _password,
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
                      const SizedBox(height: 25),
                      const Text(
                        "Confirm password",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _passwordCheck,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password to confirm';
                          }
                          if (_password.text != _passwordCheck.text) {
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
                    ],
                  ),
                ),
                const SizedBox(height: 33),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, '/dashboard');
                      }
                    },
                    style: button,
                    child: const Text(
                      "Update Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
