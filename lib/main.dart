import 'package:business_assistant/screens/customers.dart/customers_center.dart';
import 'package:business_assistant/screens/orders.dart/orders_center.dart';

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
        OrdersPage.pageRoute: (ctx) =>
            const OrdersPage(), // takes to the main page of orders
        customersPage.pageRoute: (ctx) => const customersPage(),
      },
      home: const SignIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}
