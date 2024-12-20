import 'package:get/get.dart';
import 'constants/routes.dart';
import 'package:flutter/material.dart';
import 'screens/landingPages/welcome_screen.dart';
import 'package:sqflite/sqflite.dart';  // For mobile platforms (Android/iOS)
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

// Import for Desktop (Windows, macOS, Linux)
import 'package:sqflite_common_ffi/sqflite_ffi.dart';  // Correct import for desktop

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    print("Storage permission granted");
  } else {
    print("Storage permission denied");
  }

  if (Platform.isAndroid && await Permission.manageExternalStorage.isPermanentlyDenied) {
    openAppSettings();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite based on platform
  if (Platform.isAndroid || Platform.isIOS) {
    // For mobile platforms
    databaseFactory = databaseFactory; // Use the normal sqflite databaseFactory
  } else {
    // For desktop platforms, initialize sqflite_ffi
    sqfliteFfiInit();  // Initializes the FFI support for SQLite on desktop
    databaseFactory = databaseFactoryFfi;  // Use the FFI databaseFactory for desktop
  }

  await requestStoragePermission();
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
      debugShowCheckedModeBanner: false,
    );
  }
}
