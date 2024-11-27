import 'screens/create_account.dart';
import 'package:flutter/material.dart';
import 'screens/forgot_password.dart';
import 'screens/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Assistant',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      routes: {
        SignIn.pageRoute: (ctx) => const SignIn(),
        CreateAccount.pageRoute: (ctx) => const CreateAccount(),
        ForgotPassword.pageRoute: (ctx) => ForgotPassword(),
      },
      home: const SignIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}
