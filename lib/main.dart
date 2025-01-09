import 'package:business_assistant/cubits/Income/income_repository.dart';
import 'package:business_assistant/cubits/Income/income_cubit.dart';
import 'package:business_assistant/cubits/customer/customer_cubit.dart';
import 'package:business_assistant/cubits/goals/goal_cubit.dart';
import 'package:business_assistant/cubits/goals/goal_repository.dart';
import 'package:business_assistant/cubits/order/order_cubit.dart';
import 'package:business_assistant/cubits/order/order_repository.dart';
import 'package:business_assistant/cubits/product/product_cubit.dart';
import 'package:business_assistant/cubits/product/product_repository.dart';
import 'package:business_assistant/cubits/tasks/task_cubit.dart';
import 'package:business_assistant/cubits/tasks/task_repository.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:business_assistant/screens/customers/customers_center.dart';
import 'package:business_assistant/screens/dashboard.dart';
import 'package:business_assistant/screens/orders/orders_center.dart';
import 'package:business_assistant/screens/landingPages/welcome_screen.dart';
import 'package:business_assistant/screens/Analysis/analysis_week.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'constants/routes.dart';
import 'package:flutter/material.dart';
import 'cubits/customer/customer_repository.dart';
import 'cubits/customer/validation_cubit.dart';
import 'cubits/order/orderDetails_cubit.dart';
import 'cubits/product/validation_cubit.dart';
import 'database/db_delete.dart';
import 'database/db_helper.dart';
import 'screens/inventory/products_center.dart';
import 'screens/landingPages/welcome_screen.dart';
import 'package:sqflite/sqflite.dart'; // For mobile platforms (Android/iOS)
import 'package:permission_handler/permission_handler.dart';
import 'cubits/expense/expense_cubit.dart';
import 'cubits/expense/expense_repository.dart';
import 'dart:io';
import 'package:business_assistant/cubits/Authentification/auth_repository.dart';
import 'package:business_assistant/cubits/Authentification/auth_cubit.dart';
// Import for Desktop (Windows, macOS, Linux)
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Correct import for desktop

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase for local testing
  await Supabase.initialize(
    url: 'https://ovjuafdbpmzxpwpocpzy.supabase.co', // Replace with your project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im92anVhZmRicG16eHB3cG9jcHp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyNDMzNDUsImV4cCI6MjA1MTgxOTM0NX0.RZk2Zf0vlQYHpoFdgxErHq_pdeaS4-VUd8RFkjmHhYQ', // Replace with your anon key
  );

  // Initialize SQLite based on platform
  if (Platform.isAndroid || Platform.isIOS) {
    // For mobile platforms
    databaseFactory = databaseFactory; // Use the normal sqflite databaseFactory
  } else {
    // For desktop platforms, initialize sqflite_ffi
    sqfliteFfiInit(); // Initializes the FFI support for SQLite on desktop
    databaseFactory =
        databaseFactoryFfi; // Use the FFI databaseFactory for desktop
  }

await requestStoragePermission();
  runApp(MyApp());
}

Future<void> requestStoragePermission() async {
  if (Platform.isAndroid || Platform.isIOS) {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission is required');
    }
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(AuthRepository(Supabase.instance.client))),
        BlocProvider(create: (context) => ProductCubit(ProductRepository())),
        BlocProvider(create: (context) => ValidationCubit()),
        BlocProvider(create: (context) => CustomerCubit(CustomerRepository())),
        BlocProvider(create: (context) => ValidationCustomerCubit()),

        BlocProvider(
            create: (context) => OrderCubit(repository: OrderRepository())),
        BlocProvider(
            create: (context) =>
                OrderDetailsCubit(repository: OrderRepository())),
        BlocProvider<ExpenseCubit>(
          create: (context) => ExpenseCubit(repository: ExpenseRepository()),
           
        ),
        BlocProvider(create:  (context) => IncomeCubit(repository:  IncomeRepository())),
        BlocProvider(create: (context) => TaskCubit(TaskRepository())), // Added TaskCubit
        BlocProvider(create: (context) => GoalCubit(GoalRepository())),
      ],
      child: GetMaterialApp(
        title: 'Business Assistant',
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        routes: routes,
        home: WelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

