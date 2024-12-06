import 'package:business_assistant/controllers/DrawerController.dart';
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
import 'package:get/get.dart';

import '/constants/imagePaths.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

String selectedMenuItem = 'Dashboard';

late double screenWidth;
late double screenHeight;

class _SidebarState extends State<Sidebar> {
  final controller = Get.put(DrawerControl());

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final double itemSpacing = screenHeight * 0.01;

    return SafeArea(
      child: Drawer(
        width: screenWidth * 0.6,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/editprofil');
              },
              child: Row(
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sara ABID',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.056,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Obx(
              () => buildMenuItem(
                title: 'Dashboard',
                image: controller.selectedMenuItem.value == 'Dashboard'
                    ? home_filled
                    : home_not_filled,
                route: '/dashboard',
              ),
            ),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'Orders',
                  image: controller.selectedMenuItem.value == 'Orders'
                      ? orders_filled
                      : orders_not_filled,
                  route: '/orders',
                )),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'To do',
                  image: controller.selectedMenuItem.value == 'To do'
                      ? todo_filled
                      : todo_not_filled,
                  route: '/Tasks',
                )),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'Customers',
                  image: controller.selectedMenuItem.value == 'Customers'
                      ? customers_filled
                      : customers_not_filled,
                  route: '/customers',
                )),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'Analysis',
                  image: controller.selectedMenuItem.value == 'Analysis'
                      ? analysis_filled
                      : analysis_not_filled,
                  route: '/analysis',
                )),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'Inventory',
                  image: controller.selectedMenuItem.value == 'Inventory'
                      ? inventory_filled
                      : inventory_not_filled,
                  route: '/inventory',
                )),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'Transactions',
                  image: controller.selectedMenuItem.value == 'Transactions'
                      ? transaction_filled
                      : transaction_not_filled,
                  route: '/transaction',
                )),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'Goals',
                  image: controller.selectedMenuItem.value == 'Goals'
                      ? goals_filled
                      : goals_not_filled,
                  route: '/goalList',
                )),
            SizedBox(height: itemSpacing),
            Obx(() => buildMenuItem(
                  title: 'Settings',
                  image: controller.selectedMenuItem.value == 'Settings'
                      ? settings_filled
                      : settings_not_filled,
                  route: '/settings',
                )),
            SizedBox(height: itemSpacing),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, size: 25, color: Colors.red),
              title: Text('Logout account',
                  style: TextStyle(fontSize: screenWidth * 0.04)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signIn');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String title,
    required String image,
    required String route,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 25,
        height: 25,
        child: Image.asset(image, fit: BoxFit.cover),
      ),
      title: Text(title, style: TextStyle(fontSize: screenWidth * 0.04)),
      onTap: () {
        controller.selectedMenuItem(title);
        Get.back();
        Get.toNamed(route);
      },
    );
  }
}
