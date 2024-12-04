import 'package:business_assistant/data/goaldata.dart';
import 'package:business_assistant/screens/Analysis/analysis.dart';
import 'package:business_assistant/screens/Analysis/analysis_week.dart';
import 'package:business_assistant/screens/customers/customers_center.dart';
import 'package:business_assistant/screens/goallist/goal_list.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/Analysis/transactions.dart';
import 'package:business_assistant/data/transactiondata.dart';
import 'package:flutter/foundation.dart';
import 'constants/routes.dart';
import 'package:flutter/material.dart';
import 'screens/landingPages/welcome_screen.dart';
import 'screens/orders/orders_center.dart';
import 'screens/Analysis/transactions.dart';
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
      home: const GoalList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
