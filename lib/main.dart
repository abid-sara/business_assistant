import 'package:get/get.dart';
import 'constants/routes.dart';
import 'package:flutter/material.dart';
import 'screens/landingPages/reset_password.dart';
import 'screens/landingPages/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
