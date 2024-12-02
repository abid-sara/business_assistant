import 'package:business_assistant/screens/customers/customer_details.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/inventory/products_details.dart';
import 'package:business_assistant/screens/orders/order_details.dart';

import '/screens/landingPages/forgot_password.dart';
import '/screens/landingPages/sign_in.dart';
import '../screens/customers/customers_center.dart';
import '../screens/orders/orders_center.dart';
import '/screens/landingPages/reset_password.dart';
import '/screens/landingPages/businessDetails.dart';
import '/screens/landingPages/create_account.dart';

var routes = {
  SignIn.pageRoute: (ctx) => const SignIn(),
  CreateAccount.pageRoute: (ctx) => const CreateAccount(),
  ForgotPassword.pageRoute: (ctx) => ForgotPassword(),
  ResetPassword.pageRoute: (ctx) => const ResetPassword(),
  Businessdetails.pageRoute: (ctx) => const Businessdetails(),
  '/details': (context) => const orderDetails(),
  '/customers': (context) => const customersPage(),
  '/customerDetails': (context) => const customerDetails(),
  '/inventory': (context) => const Inventory(),
  '/itemDetails': (context) => const ItemDetails(),
};
