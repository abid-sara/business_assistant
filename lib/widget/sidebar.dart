import 'package:business_assistant/data/Task.dart';
import 'package:business_assistant/screens/Analysis/analysis.dart';
import 'package:business_assistant/screens/Analysis/transactions.dart';
import 'package:business_assistant/screens/Settings/setting.dart';
import 'package:business_assistant/screens/To_do.dart/all_tasks.dart';
import 'package:business_assistant/screens/customers/customers_center.dart';
import 'package:business_assistant/screens/dashboard.dart';
import 'package:business_assistant/screens/goallist/goal_list.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/orders/orders_center.dart';

import '/constants/imagePaths.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String selectedMenuItem = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double itemSpacing = screenHeight * 0.02;

    return SafeArea(
      child: Drawer(
        width: screenWidth * 0.6,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: <Widget>[
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: screenWidth * 0.18,
                    height: screenWidth * 0.18,
                    child: const DrawerHeader(
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.shrink(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sara ABID',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                // const Spacer(),
                // const Align(
                //   alignment: Alignment.centerRight,
                //   child: Icon(Icons.keyboard_arrow_right),
                // )
              ],
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            buildMenuItem(
              title: 'Dashboard',
              image: selectedMenuItem == 'Dashboard'
                  ? home_filled
                  : home_not_filled,
              route: '/dashboard',
              parameter: const Dashboard(), // Replace with the actual widget
            ),

           
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'Orders',
              image: selectedMenuItem == 'Orders'
                  ? orders_filled
                  : orders_not_filled,
              route: '/orders',
              parameter: const OrdersPage(),
            ),
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'To do',
              image:
                  selectedMenuItem == 'To do' ? todo_filled : todo_not_filled,
              route: '/Tasks',
              parameter: const Tasks(),
            ),
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'Customers',
              image: selectedMenuItem == 'Customers'
                  ? customers_filled
                  : customers_not_filled,
              route: '/customers',
              parameter: const customersPage(),
              
            ),
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'Analysis',
              image: selectedMenuItem == 'Analysis'
                  ? analysis_filled
                  : analysis_not_filled,
              route: '/analysis',
              parameter: const Analysis(),
            ),
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'Inventory',
              image: selectedMenuItem == 'Inventory'
                  ? inventory_filled
                  : inventory_not_filled,
              route: '/inventory',
              parameter: const Inventory(),
            ),
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'Transactions',
              image:
                  selectedMenuItem == 'Transactions' ? transaction_filled : transaction_not_filled,
              route: '/transaction',
              parameter: const Transaction(),
            ),
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'Goals',
              image:
                  selectedMenuItem == 'Goals' ? goals_filled : goals_not_filled,
              route: '/goalList',
              parameter: const GoalList(),
            ),
            SizedBox(height: itemSpacing),
            buildMenuItem(
              title: 'Settings',
              image: selectedMenuItem == 'Settings'
                  ? settings_filled
                  : settings_not_filled,
              route: '/settings',
              parameter: const Settings(),
              
            ),
            SizedBox(height: itemSpacing),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, size: 25, color: Colors.red),
              title:
                  const Text('Logout account', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signIn');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String title, required String image, required String route, required parameter}) {
    return ListTile(
      leading: SizedBox(
        width: 25,
        height: 25,
        child: Image.asset(image, fit: BoxFit.cover),
      ),
      title: Text(title, style: const TextStyle(fontSize: 20)),
      
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => parameter,
        ),
      );
        setState(() {
        selectedMenuItem = title;
          
        });
      },
    );
  }
}
