import 'package:business_assistant/screens/customers/customer_details.dart';
import 'package:business_assistant/screens/dashboard.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/inventory/products_details.dart';
import 'package:business_assistant/screens/orders/order_details.dart';
// import 'package:bussiness_assist/all_task.dart';
// import 'package:bussiness_assist/editprofile.dart';
// import 'package:bussiness_assist/help&support.dart';
// import 'package:bussiness_assist/passwordedit.dart';
// import 'package:bussiness_assist/rateus.dart';
// import 'package:bussiness_assist/reportproblem.dart';
// import 'package:bussiness_assist/setting.dart';
// import 'package:bussiness_assist/subscription.dart';
import '/screens/landingPages/forgot_password.dart';
import '/screens/landingPages/sign_in.dart';
import '../screens/customers/customers_center.dart';
import '../screens/orders/orders_center.dart';
import '/screens/landingPages/reset_password.dart';
import '/screens/landingPages/businessDetails.dart';
import '/screens/landingPages/create_account.dart';
import '../screens/Analysis/transactions.dart';
import '../screens/Analysis/analysis.dart';
import '../screens/Analysis/analysis_week.dart';
import '../screens/goallist/goal_list.dart';
import '../screens/goallist/description.dart';

var routes = {
  '/signIn': (ctx) => const SignIn(),
  '/CreateAccount': (ctx) => const CreateAccount(),
  '/ForgotPassword': (ctx) => ForgotPassword(),
  '/ResetPassword': (ctx) => const ResetPassword(),
  '/Businessdetails': (ctx) => const Businessdetails(),
  '/details': (context) => const orderDetails(),
  '/orders': (context) => const OrdersPage(),
  '/customers': (context) => const customersPage(),
  '/customerDetails': (context) => const customerDetails(),
  // '/inventory': (context) => const Inventory(),
  '/itemDetails': (context) => const ItemDetails(),
  '/dashboard': (context) => const Dashboard(),
  // '/settings' : (context) => const Settings(),
  // '/editprofil' : (context) => const EditProfile(),
  // '/changepassword' : (context) => const ChangePassword(),
  // '/subscription' : (context) => const SubscriptionPage(),
  // '/reportproblem' : (context) => const ReportProblemPage(),
  // '/help&support' : (context) => const HelpSupportPage(),
  // '/feedback' : (context) => const Feedback(),
  // '/Tasks' : (cntext) => const Tasks(),
  '/goalList': (context) => const GoalList(),
   '/description': (context) => const Description(),
   '/analysis': (context) =>  const Analysis(),
   '/analysisweek': (context) => const AnalysisWeek(),
     '/transaction': (context) =>  const Transaction(),
};
