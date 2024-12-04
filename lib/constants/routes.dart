import 'package:business_assistant/screens/customers/customer_details.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/inventory/products_details.dart';

import '/screens/landingPages/forgot_password.dart';
import '/screens/landingPages/sign_in.dart';
import '../screens/customers/customers_center.dart';
import '/screens/landingPages/reset_password.dart';
import '/screens/landingPages/businessDetails.dart';
import '/screens/landingPages/create_account.dart';
import '../screens/Analysis/transactions.dart';
import '../screens/Analysis/analysis.dart';
import '../screens/Analysis/analysis_week.dart';
import '../screens/goallist/goal_list.dart';
import '../screens/goallist/description.dart';


var routes = {
  SignIn.pageRoute: (ctx) => const SignIn(),
  CreateAccount.pageRoute: (ctx) => const CreateAccount(),
  ForgotPassword.pageRoute: (ctx) => ForgotPassword(),
  ResetPassword.pageRoute: (ctx) => const ResetPassword(),
  Businessdetails.pageRoute: (ctx) => const Businessdetails(),
  // '/details': (context) => const orderDetails(),
  '/customers': (context) => const customersPage(),
  '/customerDetails': (context) => const customerDetails(),
  '/inventory': (context) => const Inventory(),
  '/itemDetails': (context) => const ItemDetails(),
   '/goalList': (context) => const GoalList(),
   '/description': (context) => const Description(),
   '/analysis': (context) =>  Analysis(),
   '/analysisweek': (context) => const AnalysisWeek(),
     '/transaction': (context) =>  Transaction(),

};
