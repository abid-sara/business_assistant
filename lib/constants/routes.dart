import 'package:business_assistant/screens/To_do.dart/add_task.dart';
import 'package:business_assistant/screens/To_do.dart/all_tasks.dart';
import 'package:business_assistant/screens/customers/customer_details.dart';
import 'package:business_assistant/screens/dashboard.dart';
import 'package:business_assistant/screens/inventory/products_center.dart';
import 'package:business_assistant/screens/inventory/products_details.dart';
import 'package:business_assistant/screens/orders/order_details.dart';
import 'package:business_assistant/screens/Settings/changepassword.dart';
import 'package:business_assistant/screens/Settings/feedback.dart';
import 'package:business_assistant/screens/Settings/editprofile.dart';
import 'package:business_assistant/screens/Settings/help&support.dart';
import 'package:business_assistant/screens/Settings/reportproblem.dart';
import 'package:business_assistant/screens/Settings/subscription.dart';
import 'package:business_assistant/screens/Settings/setting.dart';
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
  '/customers': (context) =>  const customersPage(),
  '/customerDetails': (context) => const customerDetails(),
  '/inventory': (context) => const Inventory(),
  '/itemDetails': (context) => const ItemDetails(),
  '/dashboard': (context) => const Dashboard(),
   '/settings' : (context) => const Settings(),
   '/editprofil' : (context) => const EditProfile(initialName: 'Sara', initialSurname: 'Abid',),
   '/changepassword' : (context) => const ChangePassword(),
   '/subscription' : (context) => const SubscriptionPage(),
   '/reportproblem' : (context) => const ReportProblemPage(),
   '/help&support' : (context) => const HelpSupportPage(),
   '/feedback' : (context) => const Feedback(),
   '/Tasks' : (cntext) => const Tasks(),
   '/addtask' : (context) => AddTaskPage(onAddTask: (task) {},),
  '/goalList': (context) => const GoalList(),
  '/description': (context) => const Description(),
  '/analysis': (context) => const Analysis(),
  '/analysisweek': (context) => const AnalysisWeek(),
  '/transaction': (context) => const Transaction(),
};
