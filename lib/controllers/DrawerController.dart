import 'package:get/get.dart';

class DrawerControl extends GetxController {
  var selectedMenuItem = 'Dashboard'.obs;

  void selectMenuItem(String menuItem) {
    selectedMenuItem.value = menuItem;
  }
}
