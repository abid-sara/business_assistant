import 'package:business_assistant/screens/customers.dart/customers_center.dart';
import 'package:business_assistant/screens/orders.dart/orders_center.dart';
import 'package:business_assistant/screens/landingPages/check_email.dart';
import 'package:business_assistant/screens/landingPages/reset_password.dart';
import 'package:business_assistant/screens/landingPages/welcome_screen.dart';
import 'screens/landingPages/businessDetails.dart';
import 'screens/landingPages/create_account.dart';
import 'package:flutter/material.dart';
import 'screens/landingPages/forgot_password.dart';
import 'screens/landingPages/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

        OrdersPage.pageRoute: (ctx) =>
            const OrdersPage(), // takes to the main page of orders
        customersPage.pageRoute: (ctx) => const customersPage(),

        ResetPassword.pageRoute: (ctx) => ResetPassword(),
      },
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
