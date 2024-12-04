import 'package:business_assistant/screens/customers/customers_center.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/dashboard.dart';

import 'constants/routes.dart';
import 'package:flutter/material.dart';
import 'screens/landingPages/welcome_screen.dart';


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
      routes: routes,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
