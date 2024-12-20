import 'package:business_assistant/screens/dashboard.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/orders/orders_center.dart';
import 'package:get/get.dart';
import 'constants/routes.dart';
import 'package:flutter/material.dart';
import 'screens/landingPages/welcome_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI
  sqfliteFfiInit();

  // Set the database factory
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
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
      // home: Inventory(),
      debugShowCheckedModeBanner: false,
    );
  }
}
