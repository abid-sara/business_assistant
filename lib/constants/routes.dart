import '/screens/landingPages/forgot_password.dart';
import '/screens/landingPages/sign_in.dart';
import '/screens/customers.dart/customers_center.dart';
import '/screens/orders.dart/orders_center.dart';
import '/screens/landingPages/reset_password.dart';
import '/screens/landingPages/businessDetails.dart';
import '/screens/landingPages/create_account.dart';

var routes = {
  SignIn.pageRoute: (ctx) => const SignIn(),
  CreateAccount.pageRoute: (ctx) => const CreateAccount(),
  ForgotPassword.pageRoute: (ctx) => ForgotPassword(),
  OrdersPage.pageRoute: (ctx) => const OrdersPage(),
  customersPage.pageRoute: (ctx) => const customersPage(),
  ResetPassword.pageRoute: (ctx) => const ResetPassword(),
  Businessdetails.pageRoute: (ctx) => const Businessdetails(),
};
